package com.example.login;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
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

        try (Connection conn = DatabaseUtils.getConnection()) {
            // 1) find user_id (now CustomerID)
            int userId;
            try (PreparedStatement pu = conn.prepareStatement(
                     "SELECT CustomerID FROM users WHERE username = ?")) {
                pu.setString(1, username);
                try (ResultSet ru = pu.executeQuery()) {
                    if (!ru.next()) throw new ServletException("Unknown user: " + username);
                    userId = ru.getInt("CustomerID");
                }
            }

            // 2) pick departure_time
            Time departureTime = Time.valueOf(
                switch (lineCode) {
                    case "4000" -> "08:00:00";
                    case "4001" -> "10:00:00";
                    case "4002" -> "12:00:00";
                    case "4003" -> "14:00:00";
                    case "4005" -> "16:00:00";
                    default     -> "00:00:00";
                }
            );

            // 3) lookup base fare
            BigDecimal baseFare;
            try (PreparedStatement pf = conn.prepareStatement(
                     "SELECT fare FROM station_fares "
                   + "WHERE (origin_station_id=? AND destination_station_id=?) "
                   +   "OR (origin_station_id=? AND destination_station_id=?)")) {
                pf.setInt(1, origin);
                pf.setInt(2, destination);
                pf.setInt(3, destination);
                pf.setInt(4, origin);
                try (ResultSet rf = pf.executeQuery()) {
                    if (!rf.next()) throw new ServletException("No fare defined for selected route");
                    baseFare = rf.getBigDecimal("fare");
                }
            }

            // 4) discount factor
            BigDecimal factor = switch (passengerType) {
                case "Child"    -> new BigDecimal("0.50");
                case "Senior"   -> new BigDecimal("0.75");
                case "Disabled" -> new BigDecimal("0.70");
                default         -> BigDecimal.ONE;
            };

            // 5) total fare = base * discount * tripMult
            BigDecimal totalFare = baseFare
                .multiply(factor)
                .multiply(BigDecimal.valueOf(tripMult))
                .setScale(2, BigDecimal.ROUND_HALF_UP);

            // 6) insert reservation
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


