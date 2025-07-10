package com.example.login; // Adjust package as per your project structure

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp; // Import Timestamp
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // Import HttpSession

@WebServlet("/manageSchedule") // Maps this servlet to the URL /manageSchedule
public class ManageScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handles POST requests (for add, edit, delete operations)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");

        // Protect servlet - only accessible by Customer Reps or Admin
        if (session.getAttribute("user") == null || (!"admin".equalsIgnoreCase(userRole) && !"customer_rep".equalsIgnoreCase(userRole))) {
            response.sendRedirect("login2.jsp"); // Not logged in or not authorized
            return;
        }

        String action = request.getParameter("action");
        String message = null;
        String messageType = "error"; // Default message type

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null; // Used for fetching train/station IDs

        try {
            conn = DatabaseUtils.getConnection();

            if ("add".equals(action)) {
                // --- ADD NEW SCHEDULE ---
                String trainName = request.getParameter("trainName");
                String originStationId = request.getParameter("originStation");
                String destinationStationId = request.getParameter("destinationStation");
                String departureTimeStr = request.getParameter("departureTime");
                String arrivalTimeStr = request.getParameter("arrivalTime");
                String fareStr = request.getParameter("fare");

                // Input validation
                if (trainName == null || trainName.isEmpty() ||
                    originStationId == null || originStationId.isEmpty() ||
                    destinationStationId == null || destinationStationId.isEmpty() ||
                    departureTimeStr == null || departureTimeStr.isEmpty() ||
                    arrivalTimeStr == null || arrivalTimeStr.isEmpty() ||
                    fareStr == null || fareStr.isEmpty()) {
                    message = "All fields are required for adding a schedule.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }

                // Convert datetime-local string to SQL TIMESTAMP format
                // Example: "2025-07-15T08:00" -> "2025-07-15 08:00:00"
                DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime departureLDT = LocalDateTime.parse(departureTimeStr, inputFormatter);
                LocalDateTime arrivalLDT = LocalDateTime.parse(arrivalTimeStr, inputFormatter);

                // Get train_id from train name
                int trainId = -1;
                ps = conn.prepareStatement("SELECT id FROM trains WHERE name = ?");
                ps.setString(1, trainName);
                rs = ps.executeQuery();
                if (rs.next()) {
                    trainId = rs.getInt("id");
                } else {
                    message = "Invalid train name selected.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }
                rs.close();
                ps.close();

                // Insert into train_schedules
                String insertSql = "INSERT INTO train_schedules (train_id, origin_station_id, destination_station_id, departure_time, arrival_time, fare) VALUES (?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(insertSql);
                ps.setInt(1, trainId);
                ps.setInt(2, Integer.parseInt(originStationId));
                ps.setInt(3, Integer.parseInt(destinationStationId));
                ps.setTimestamp(4, Timestamp.valueOf(departureLDT));
                ps.setTimestamp(5, Timestamp.valueOf(arrivalLDT));
                ps.setDouble(6, Double.parseDouble(fareStr));

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Train schedule added successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to add train schedule.";
                }

            } else if ("edit".equals(action)) {
                // --- EDIT EXISTING SCHEDULE ---
                String scheduleId = request.getParameter("scheduleId");
                String trainName = request.getParameter("trainName");
                String originStationId = request.getParameter("originStation");
                String destinationStationId = request.getParameter("destinationStation");
                String departureTimeStr = request.getParameter("departureTime");
                String arrivalTimeStr = request.getParameter("arrivalTime");
                String fareStr = request.getParameter("fare");

                // Input validation
                if (scheduleId == null || scheduleId.isEmpty() ||
                    trainName == null || trainName.isEmpty() ||
                    originStationId == null || originStationId.isEmpty() ||
                    destinationStationId == null || destinationStationId.isEmpty() ||
                    departureTimeStr == null || departureTimeStr.isEmpty() ||
                    arrivalTimeStr == null || arrivalTimeStr.isEmpty() ||
                    fareStr == null || fareStr.isEmpty()) {
                    message = "All fields are required for editing a schedule.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }

                DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime departureLDT = LocalDateTime.parse(departureTimeStr, inputFormatter);
                LocalDateTime arrivalLDT = LocalDateTime.parse(arrivalTimeStr, inputFormatter);

                // Get train_id from train name
                int trainId = -1;
                ps = conn.prepareStatement("SELECT id FROM trains WHERE name = ?");
                ps.setString(1, trainName);
                rs = ps.executeQuery();
                if (rs.next()) {
                    trainId = rs.getInt("id");
                } else {
                    message = "Invalid train name selected for edit.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }
                rs.close();
                ps.close();

                String updateSql = "UPDATE train_schedules SET train_id = ?, origin_station_id = ?, destination_station_id = ?, departure_time = ?, arrival_time = ?, fare = ? WHERE id = ?";
                ps = conn.prepareStatement(updateSql);
                ps.setInt(1, trainId);
                ps.setInt(2, Integer.parseInt(originStationId));
                ps.setInt(3, Integer.parseInt(destinationStationId));
                ps.setTimestamp(4, Timestamp.valueOf(departureLDT));
                ps.setTimestamp(5, Timestamp.valueOf(arrivalLDT));
                ps.setDouble(6, Double.parseDouble(fareStr));
                ps.setInt(7, Integer.parseInt(scheduleId));

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Train schedule updated successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to update train schedule. Schedule ID might not exist.";
                }

            } else if ("delete".equals(action)) {
                // --- DELETE SCHEDULE ---
                String scheduleId = request.getParameter("scheduleId");
                if (scheduleId == null || scheduleId.isEmpty()) {
                    message = "Schedule ID is required for deletion.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }

                String deleteSql = "DELETE FROM train_schedules WHERE id = ?";
                ps = conn.prepareStatement(deleteSql);
                ps.setInt(1, Integer.parseInt(scheduleId));

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Train schedule deleted successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to delete train schedule. Schedule ID might not exist.";
                }

            } else {
                message = "Invalid action specified.";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error: " + e.getMessage();
        } catch (NumberFormatException e) {
            e.printStackTrace();
            message = "Invalid number format for ID or Fare.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "An unexpected error occurred: " + e.getMessage();
        } finally {
            // Close resources
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        // Forward back to the JSP with message
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
    }
}
