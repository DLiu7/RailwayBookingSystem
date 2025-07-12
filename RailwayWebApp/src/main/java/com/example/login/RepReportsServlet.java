package com.example.login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter; // Not directly used but kept if other parts rely on it
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/repReports")
public class RepReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");

        // Protect servlet - only accessible by Customer Reps or Admin
        if (session.getAttribute("user") == null || (!"admin".equalsIgnoreCase(userRole) && !"customer_representative".equalsIgnoreCase(userRole))) {
            response.sendRedirect("login2.jsp"); // Not logged in or not authorized
            return;
        }

        String reportType = request.getParameter("reportType");
        String message = null;
        String messageType = "error";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtils.getConnection();

            if ("stationSchedules".equals(reportType)) {
                // --- TRAIN SCHEDULES FOR GIVEN STATION REPORT ---
                String stationIdStr = request.getParameter("stationId");
                String searchType = request.getParameter("searchType"); // "origin" or "destination"

                if (stationIdStr == null || stationIdStr.isEmpty() || searchType == null || searchType.isEmpty()) {
                    // Initial load or missing parameters, just forward to JSP
                    // Pass selectedStationId back to retain dropdown selection on initial load
                    request.setAttribute("selectedStationId", request.getParameter("stationId"));
                    request.setAttribute("searchType", request.getParameter("searchType"));
                    request.getRequestDispatcher("rep_station_schedules_report.jsp").forward(request, response);
                    return;
                }

                int stationId = Integer.parseInt(stationIdStr);

                List<List<String>> schedules = new ArrayList<>();
                String sql;
                if ("origin".equals(searchType)) {
                    sql = "SELECT ts.id, t.name AS train_name, os.name AS origin_station_name, " +
                          "ds.name AS destination_station_name, ts.departure_time, ts.arrival_time, ts.fare " +
                          "FROM train_schedules ts " +
                          "JOIN trains t ON ts.train_id = t.id " +
                          "JOIN station os ON ts.origin_station_id = os.station_id " +
                          "JOIN station ds ON ts.destination_station_id = ds.station_id " +
                          "WHERE ts.origin_station_id = ? ORDER BY ts.departure_time ASC";
                } else if ("destination".equals(searchType)) {
                    sql = "SELECT ts.id, t.name AS train_name, os.name AS origin_station_name, " +
                          "ds.name AS destination_station_name, ts.departure_time, ts.arrival_time, ts.fare " +
                          "FROM train_schedules ts " +
                          "JOIN trains t ON ts.train_id = t.id " +
                          "JOIN station os ON ts.origin_station_id = os.station_id " +
                          "JOIN station ds ON ts.destination_station_id = ds.station_id " +
                          "WHERE ts.destination_station_id = ? ORDER BY ts.departure_time ASC";
                } else {
                    message = "Invalid search type specified.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.setAttribute("selectedStationId", stationIdStr); // Pass back for form retention
                    request.getRequestDispatcher("rep_station_schedules_report.jsp").forward(request, response);
                    return;
                }

                ps = conn.prepareStatement(sql);
                ps.setInt(1, stationId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    List<String> schedule = new ArrayList<>();
                    schedule.add(rs.getString("train_name"));
                    schedule.add(rs.getString("origin_station_name"));
                    schedule.add(rs.getString("destination_station_name"));
                    schedule.add(rs.getTimestamp("departure_time").toString());
                    schedule.add(rs.getTimestamp("arrival_time").toString());
                    schedule.add(String.format("%.2f", rs.getDouble("fare")));
                    schedules.add(schedule);
                }
                request.setAttribute("schedules", schedules);
                request.setAttribute("selectedStationName", getStationNameById(conn, stationId));
                request.setAttribute("selectedStationId", stationIdStr); // Pass back for form retention
                request.setAttribute("searchType", searchType);
                request.getRequestDispatcher("rep_station_schedules_report.jsp").forward(request, response);

            } else if ("customerReservations".equals(reportType)) {
                // --- CUSTOMERS WITH RESERVATIONS REPORT ---
                String lineName = request.getParameter("lineName");
                String travelDateStr = request.getParameter("travelDate"); // Format: YYYY-MM-DD

                if (lineName == null || lineName.isEmpty() || travelDateStr == null || travelDateStr.isEmpty()) {
                    // Initial load or missing parameters, just forward to JSP
                    request.setAttribute("selectedLineName", request.getParameter("lineName"));
                    request.setAttribute("selectedDate", request.getParameter("travelDate"));
                    request.getRequestDispatcher("rep_customer_reservations_report.jsp").forward(request, response);
                    return;
                }

                Date travelDate = Date.valueOf(travelDateStr);

                List<List<String>> customersWithReservations = new ArrayList<>();
                // --- FIX STARTS HERE: Corrected SQL query for customerReservations ---
                String sql = "SELECT u.username, r.train AS train_name, r.travel_date, r.departure_time, " +
                             "os.name AS origin_station_name, ds.name AS destination_station_name, " +
                             "r.seat_id, r.passenger_type, r.trip_type " +
                             "FROM reservations r " +
                             "JOIN users u ON r.user_id = u.CustomerID " +
                             "JOIN station os ON r.origin_station_id = os.station_id " + // Join directly on reservations.origin_station_id
                             "JOIN station ds ON r.destination_station_id = ds.station_id " + // Join directly on reservations.destination_station_id
                             "WHERE r.line_name = ? " + // Filter directly using line_name from reservations
                             "AND r.travel_date = ? " +
                             "ORDER BY u.username, r.departure_time ASC";
                // --- FIX ENDS HERE ---

                ps = conn.prepareStatement(sql);
                ps.setString(1, lineName);
                ps.setDate(2, travelDate);
                rs = ps.executeQuery();

                while (rs.next()) {
                    List<String> reservation = new ArrayList<>();
                    reservation.add(rs.getString("username"));
                    reservation.add(rs.getString("train_name"));
                    reservation.add(rs.getDate("travel_date").toString());
                    reservation.add(rs.getTime("departure_time").toString());
                    reservation.add(rs.getString("origin_station_name"));
                    reservation.add(rs.getString("destination_station_name"));
                    reservation.add(rs.getString("seat_id"));
                    reservation.add(rs.getString("passenger_type"));
                    reservation.add(rs.getString("trip_type"));
                    customersWithReservations.add(reservation);
                }
                request.setAttribute("customersWithReservations", customersWithReservations);
                request.setAttribute("selectedLineName", lineName);
                request.setAttribute("selectedDate", travelDateStr);
                request.getRequestDispatcher("rep_customer_reservations_report.jsp").forward(request, response);

            } else {
                message = "Invalid report type specified.";
                request.setAttribute("message", message);
                request.setAttribute("messageType", messageType);
                request.getRequestDispatcher("welcome.jsp").forward(request, response); // Fallback
            }

        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error: " + e.getMessage();
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            // Pass back selected values in case of an error for form retention
            request.setAttribute("selectedStationId", request.getParameter("stationId"));
            request.setAttribute("searchType", request.getParameter("searchType"));
            request.setAttribute("selectedLineName", request.getParameter("lineName"));
            request.setAttribute("selectedDate", request.getParameter("travelDate"));

            // Forward back to the appropriate JSP based on reportType if an error occurs
            if ("stationSchedules".equals(reportType)) {
                request.getRequestDispatcher("rep_station_schedules_report.jsp").forward(request, response);
            } else if ("customerReservations".equals(reportType)) {
                request.getRequestDispatcher("rep_customer_reservations_report.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("welcome.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            message = "Invalid station ID format. Please ensure a valid station is selected.";
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            // Pass back selected values in case of an error for form retention
            request.setAttribute("selectedStationId", request.getParameter("stationId"));
            request.setAttribute("searchType", request.getParameter("searchType"));
            request.getRequestDispatcher("rep_station_schedules_report.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            message = "An unexpected error occurred: " + e.getMessage();
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            // Pass back selected values in case of an error for form retention
            request.setAttribute("selectedStationId", request.getParameter("stationId"));
            request.setAttribute("searchType", request.getParameter("searchType"));
            request.setAttribute("selectedLineName", request.getParameter("lineName"));
            request.setAttribute("selectedDate", request.getParameter("travelDate"));

            if ("stationSchedules".equals(reportType)) {
                request.getRequestDispatcher("rep_station_schedules_report.jsp").forward(request, response);
            } else if ("customerReservations".equals(reportType)) {
                request.getRequestDispatcher("rep_customer_reservations_report.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("welcome.jsp").forward(request, response);
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    private String getStationNameById(Connection conn, int stationId) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        String stationName = "Unknown Station";
        try {
            ps = conn.prepareStatement("SELECT name FROM station WHERE station_id = ?");
            ps.setInt(1, stationId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stationName = rs.getString("name");
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return stationName;
    }
}