package com.example.login; // Adjust package as per your project structure

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/manageSchedule") // Maps this servlet to the URL /manageSchedule
public class ManageScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handles POST requests (for add, edit, delete operations)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");

        // Protect servlet - only accessible by Customer Reps or Admin
        if (session.getAttribute("user") == null || (!"admin".equalsIgnoreCase(userRole) && !"customer_representative".equalsIgnoreCase(userRole))) {
            response.sendRedirect("login2.jsp"); // Not logged in or not authorized
            return;
        }

        String action = request.getParameter("action");
        String message = null;
        String messageType = "error"; // Default message type

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseUtils.getConnection();

            if ("add".equals(action)) {
                // --- ADD NEW SCHEDULE ---
                String trainIdStr = request.getParameter("trainId");
                String originStationIdStr = request.getParameter("originStationId");
                String destinationStationIdStr = request.getParameter("destinationStationId");
                String departureTimeStr = request.getParameter("departureTime");
                String arrivalTimeStr = request.getParameter("arrivalTime");
                String fareStr = request.getParameter("fare");

                // Input validation
                if (trainIdStr == null || trainIdStr.isEmpty() ||
                    originStationIdStr == null || originStationIdStr.isEmpty() ||
                    destinationStationIdStr == null || destinationStationIdStr.isEmpty() ||
                    departureTimeStr == null || departureTimeStr.isEmpty() ||
                    arrivalTimeStr == null || arrivalTimeStr.isEmpty() ||
                    fareStr == null || fareStr.isEmpty()) {
                    message = "All fields are required for adding a schedule.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }

                // Convert string IDs to int
                int trainId = Integer.parseInt(trainIdStr);
                int originStationId = Integer.parseInt(originStationIdStr);
                int destinationStationId = Integer.parseInt(destinationStationIdStr);
                double fare = Double.parseDouble(fareStr);


                // Convert datetime-local string to SQL TIMESTAMP format
                DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime departureLDT = LocalDateTime.parse(departureTimeStr, inputFormatter);
                LocalDateTime arrivalLDT = LocalDateTime.parse(arrivalTimeStr, inputFormatter);

                // Insert into train_schedules
                String insertSql = "INSERT INTO train_schedules (train_id, origin_station_id, destination_station_id, departure_time, arrival_time, fare) VALUES (?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(insertSql);
                ps.setInt(1, trainId);
                ps.setInt(2, originStationId);
                ps.setInt(3, destinationStationId);
                ps.setTimestamp(4, Timestamp.valueOf(departureLDT));
                ps.setTimestamp(5, Timestamp.valueOf(arrivalLDT));
                ps.setDouble(6, fare);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Train schedule added successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to add train schedule.";
                }

            } else if ("edit".equals(action)) {
                // --- EDIT EXISTING SCHEDULE ---
                String scheduleIdStr = request.getParameter("scheduleId");
                String trainIdStr = request.getParameter("trainId");
                String originStationIdStr = request.getParameter("originStationId");
                String destinationStationIdStr = request.getParameter("destinationStationId");
                String departureTimeStr = request.getParameter("departureTime");
                String arrivalTimeStr = request.getParameter("arrivalTime");
                String fareStr = request.getParameter("fare");

                // Input validation
                if (scheduleIdStr == null || scheduleIdStr.isEmpty() ||
                    trainIdStr == null || trainIdStr.isEmpty() ||
                    originStationIdStr == null || originStationIdStr.isEmpty() ||
                    destinationStationIdStr == null || destinationStationIdStr.isEmpty() ||
                    departureTimeStr == null || departureTimeStr.isEmpty() ||
                    arrivalTimeStr == null || arrivalTimeStr.isEmpty() ||
                    fareStr == null || fareStr.isEmpty()) {
                    message = "All fields are required for editing a schedule.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }

                // Convert string IDs to int
                int scheduleId = Integer.parseInt(scheduleIdStr);
                int trainId = Integer.parseInt(trainIdStr);
                int originStationId = Integer.parseInt(originStationIdStr);
                int destinationStationId = Integer.parseInt(destinationStationIdStr);
                double fare = Double.parseDouble(fareStr);

                DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                LocalDateTime departureLDT = LocalDateTime.parse(departureTimeStr, inputFormatter);
                LocalDateTime arrivalLDT = LocalDateTime.parse(arrivalTimeStr, inputFormatter);

                String updateSql = "UPDATE train_schedules SET train_id = ?, origin_station_id = ?, destination_station_id = ?, departure_time = ?, arrival_time = ?, fare = ? WHERE id = ?";
                ps = conn.prepareStatement(updateSql);
                ps.setInt(1, trainId);
                ps.setInt(2, originStationId);
                ps.setInt(3, destinationStationId);
                ps.setTimestamp(4, Timestamp.valueOf(departureLDT));
                ps.setTimestamp(5, Timestamp.valueOf(arrivalLDT));
                ps.setDouble(6, fare);
                ps.setInt(7, scheduleId);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    message = "Train schedule updated successfully!";
                    messageType = "success";
                } else {
                    message = "Failed to update train schedule. Schedule ID might not exist.";
                }

            } else if ("delete".equals(action)) {
                // --- DELETE SCHEDULE ---
                String scheduleIdStr = request.getParameter("scheduleId");
                if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
                    message = "Schedule ID is required for deletion.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
                    return;
                }

                int scheduleId = Integer.parseInt(scheduleIdStr);

                String deleteSql = "DELETE FROM train_schedules WHERE id = ?";
                ps = conn.prepareStatement(deleteSql);
                ps.setInt(1, scheduleId);

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
            message = "Invalid number format for ID or Fare. Please ensure all numerical inputs are valid.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "An unexpected error occurred: " + e.getMessage();
        } finally {
            // Close resources
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        // Forward back to the JSP with message
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("rep_manage_schedules.jsp").forward(request, response);
    }
}