package com.example.login;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/reserve")
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** Show the reservation form */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect("login2.jsp");
            return;
        }
        req.getRequestDispatcher("/reservation.jsp").forward(req, resp);
    }

    /** Handle both new reservations *and* cancellations */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect("login2.jsp");
            return;
        }

        String action = req.getParameter("action");
        // ── CANCEL path ──
        if ("cancel".equals(action)) {
            int resId = Integer.parseInt(req.getParameter("reservationId"));
            try (Connection conn = DatabaseUtils.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "DELETE FROM reservations WHERE id = ?")) {
                ps.setInt(1, resId);
                ps.executeUpdate();
            } catch (SQLException e) {
                throw new ServletException("Error cancelling reservation", e);
            }
            resp.sendRedirect("bookings.jsp");
            return;
        }

        // ── NEW RESERVATION path ──
        String username      = (String) s.getAttribute("user");
        String train         = req.getParameter("train");
        String lineCode      = req.getParameter("lineName");
        Date   departDate    = Date.valueOf(req.getParameter("departureDate"));
        int    origin        = Integer.parseInt(req.getParameter("originStationID"));
        int    destination   = Integer.parseInt(req.getParameter("destinationStationID"));
        String seatId        = req.getParameter("seat");
        String passengerType = req.getParameter("passengerType");
        String tripType      = req.getParameter("tripType");
        int    tripMult      = "Round-trip".equals(tripType) ? 2 : 1;

        // ── compute departure_time via schedule lookup ──
        // map station IDs to names
        Map<Integer,String> id2name = new HashMap<>();
        id2name.put(4, "Trenton");
        id2name.put(3, "New Brunswick");
        id2name.put(1, "Newark Penn");
        id2name.put(2, "New York Penn");

        // ordered lists for outbound / inbound
        List<String> outbound = Arrays.asList("Trenton","New Brunswick","Newark Penn","New York Penn");
        List<String> inbound  = Arrays.asList("New York Penn","Newark Penn","New Brunswick","Trenton");

        // base times for line 4000
        Map<String,LocalTime> baseOut = Map.of(
            "Trenton",      LocalTime.of(8,0),
            "New Brunswick",LocalTime.of(9,0),
            "Newark Penn",  LocalTime.of(10,0),
            "New York Penn",LocalTime.of(11,0)
        );
        Map<String,LocalTime> baseIn = Map.of(
            "New York Penn",LocalTime.of(14,0),
            "Newark Penn",  LocalTime.of(15,0),
            "New Brunswick",LocalTime.of(16,0),
            "Trenton",      LocalTime.of(17,0)
        );

        // determine offset hours (e.g. 4003 → 3 hours after base)
        int offset = 0;
        try {
            offset = Integer.parseInt(lineCode) - 4000;
            if (offset < 0) offset = 0;
        } catch (NumberFormatException ex) {
            offset = 0;
        }

        String oriName = id2name.get(origin);
        String dstName = id2name.get(destination);
        LocalTime departLocal;

        // outbound if origin comes before destination in outbound list
        if (outbound.indexOf(oriName) < outbound.indexOf(dstName)) {
            departLocal = baseOut.getOrDefault(oriName, LocalTime.MIDNIGHT)
                                 .plusHours(offset);
        } else {
            // inbound
            departLocal = baseIn.getOrDefault(oriName, LocalTime.MIDNIGHT)
                                .plusHours(offset);
        }
        Time departureTime = Time.valueOf(departLocal);

        try (Connection conn = DatabaseUtils.getConnection()) {
            // 1) find user_id
            int userId;
            try (PreparedStatement pu = conn.prepareStatement(
                     "SELECT CustomerID FROM users WHERE username = ?")) {
                pu.setString(1, username);
                try (ResultSet ru = pu.executeQuery()) {
                    if (!ru.next())
                        throw new ServletException("Unknown user: " + username);
                    userId = ru.getInt("CustomerID");
                }
            }

            // 2) lookup base fare
            BigDecimal baseFare;
            try (PreparedStatement pf = conn.prepareStatement(
                     "SELECT fare FROM station_fares "
                   + "WHERE (origin_station_id=? AND destination_station_id=?) "
                   + "   OR (origin_station_id=? AND destination_station_id=?)")) {
                pf.setInt(1, origin);
                pf.setInt(2, destination);
                pf.setInt(3, destination);
                pf.setInt(4, origin);
                try (ResultSet rf = pf.executeQuery()) {
                    if (!rf.next())
                        throw new ServletException("No fare defined for selected route");
                    baseFare = rf.getBigDecimal("fare");
                }
            }

            // 3) discount factor
            BigDecimal factor = switch (passengerType) {
                case "Child"    -> new BigDecimal("0.50");
                case "Senior"   -> new BigDecimal("0.75");
                case "Disabled" -> new BigDecimal("0.70");
                default         -> BigDecimal.ONE;
            };

            // 4) total fare
            BigDecimal totalFare = baseFare
                .multiply(factor)
                .multiply(BigDecimal.valueOf(tripMult))
                .setScale(2, BigDecimal.ROUND_HALF_UP);

            // 5) insert reservation
            String insertSql =
                "INSERT INTO reservations ("
              + " user_id, train, line_name, travel_date,"
              + " departure_time, origin_station_id,"
              + " destination_station_id, seat_id,"
              + " passenger_type, trip_type, total_fare, reservation_date"
              + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

            try (PreparedStatement pi = conn.prepareStatement(insertSql)) {
                int i = 1;
                pi.setInt       (i++, userId);
                pi.setString    (i++, train);
                pi.setString    (i++, lineCode);
                pi.setDate      (i++, departDate);
                pi.setTime      (i++, departureTime);
                pi.setInt       (i++, origin);
                pi.setInt       (i++, destination);
                pi.setString    (i++, seatId);
                pi.setString    (i++, passengerType);
                pi.setString    (i++, tripType);
                pi.setBigDecimal(i++, totalFare);
                pi.setDate      (i,   new Date(System.currentTimeMillis()));
                pi.executeUpdate();
            }

            resp.sendRedirect("bookings.jsp");
        }
        catch (SQLException e) {
            throw new ServletException("Database error while reserving", e);
        }
    }
}

