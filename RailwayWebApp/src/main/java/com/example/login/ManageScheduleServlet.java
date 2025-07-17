package com.example.login;

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

/**
 * Servlet implementation class ManageScheduleServlet
 * Handles add, edit, and delete operations on train_schedules.
 */
@WebServlet("/manageSchedule")
public class ManageScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter DATETIME_FORMATTER =
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1) Security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login2.jsp");
            return;
        }
        String userRole = (String) session.getAttribute("role");
        if (!"admin".equalsIgnoreCase(userRole)
         && !"customer_representative".equalsIgnoreCase(userRole)) {
            response.sendRedirect("welcome.jsp");
            return;
        }

        String action      = request.getParameter("action");
        String message     = null;
        String messageType = "error";

        Connection        conn = null;
        PreparedStatement ps   = null;

        try {
            conn = DatabaseUtils.getConnection();

            if ("add".equals(action)) {
                // --- ADD NEW SCHEDULE ---
                String lineCodeStr            = request.getParameter("lineCode");
                String trainIdStr             = request.getParameter("trainId");
                String originStationIdStr     = request.getParameter("originStationId");
                String destinationStationIdStr= request.getParameter("destinationStationId");
                String departureTimeStr       = request.getParameter("departureTime");
                String arrivalTimeStr         = request.getParameter("arrivalTime");
                String fareStr                = request.getParameter("fare");

                // Validate inputs
                if (lineCodeStr == null || lineCodeStr.isEmpty()
                 || trainIdStr == null || trainIdStr.isEmpty()
                 || originStationIdStr == null || originStationIdStr.isEmpty()
                 || destinationStationIdStr == null || destinationStationIdStr.isEmpty()
                 || departureTimeStr == null || departureTimeStr.isEmpty()
                 || arrivalTimeStr == null || arrivalTimeStr.isEmpty()
                 || fareStr == null || fareStr.isEmpty()) {
                    message = "All fields are required.";
                } else {
                    // Parse
                    int lineCode        = Integer.parseInt(lineCodeStr);
                    int trainId         = Integer.parseInt(trainIdStr);
                    int originStationId = Integer.parseInt(originStationIdStr);
                    int destStationId   = Integer.parseInt(destinationStationIdStr);
                    double fare         = Double.parseDouble(fareStr);

                    LocalDateTime departureLDT =
                        LocalDateTime.parse(departureTimeStr, DATETIME_FORMATTER);
                    LocalDateTime arrivalLDT   =
                        LocalDateTime.parse(arrivalTimeStr, DATETIME_FORMATTER);

                    String insertSql =
                        "INSERT INTO train_schedules "
                      + "(line_code, train_id, origin_station_id, destination_station_id, "
                      + " departure_time, arrival_time, fare) "
                      + "VALUES (?,?,?,?,?,?,?)";
                    ps = conn.prepareStatement(insertSql);
                    int idx = 1;
                    ps.setInt       (idx++, lineCode);
                    ps.setInt       (idx++, trainId);
                    ps.setInt       (idx++, originStationId);
                    ps.setInt       (idx++, destStationId);
                    ps.setTimestamp (idx++, Timestamp.valueOf(departureLDT));
                    ps.setTimestamp (idx++, Timestamp.valueOf(arrivalLDT));
                    ps.setDouble    (idx++, fare);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        message     = "Schedule added successfully.";
                        messageType = "success";
                    } else {
                        message = "Failed to add schedule.";
                    }
                }

            } else if ("edit".equals(action)) {
                // --- EDIT EXISTING SCHEDULE ---
                String scheduleIdStr          = request.getParameter("scheduleId");
                String lineCodeStr            = request.getParameter("lineCode");
                String trainIdStr             = request.getParameter("trainId");
                String originStationIdStr     = request.getParameter("originStationId");
                String destinationStationIdStr= request.getParameter("destinationStationId");
                String departureTimeStr       = request.getParameter("departureTime");
                String arrivalTimeStr         = request.getParameter("arrivalTime");
                String fareStr                = request.getParameter("fare");

                // Validate
                if (scheduleIdStr == null || scheduleIdStr.isEmpty()
                 || lineCodeStr    == null || lineCodeStr.isEmpty()
                 || trainIdStr     == null || trainIdStr.isEmpty()
                 || originStationIdStr == null || originStationIdStr.isEmpty()
                 || destinationStationIdStr == null || destinationStationIdStr.isEmpty()
                 || departureTimeStr == null || departureTimeStr.isEmpty()
                 || arrivalTimeStr == null || arrivalTimeStr.isEmpty()
                 || fareStr == null || fareStr.isEmpty()) {
                    message = "All fields are required for edit.";
                } else {
                    int scheduleId      = Integer.parseInt(scheduleIdStr);
                    int lineCode        = Integer.parseInt(lineCodeStr);
                    int trainId         = Integer.parseInt(trainIdStr);
                    int originStationId = Integer.parseInt(originStationIdStr);
                    int destStationId   = Integer.parseInt(destinationStationIdStr);
                    double fare         = Double.parseDouble(fareStr);

                    LocalDateTime departureLDT =
                        LocalDateTime.parse(departureTimeStr, DATETIME_FORMATTER);
                    LocalDateTime arrivalLDT   =
                        LocalDateTime.parse(arrivalTimeStr, DATETIME_FORMATTER);

                    String updateSql =
                        "UPDATE train_schedules SET "
                      + " line_code = ?, train_id = ?, origin_station_id = ?, "
                      + " destination_station_id = ?, departure_time = ?, arrival_time = ?, fare = ? "
                      + "WHERE id = ?";
                    ps = conn.prepareStatement(updateSql);
                    int idx = 1;
                    ps.setInt       (idx++, lineCode);
                    ps.setInt       (idx++, trainId);
                    ps.setInt       (idx++, originStationId);
                    ps.setInt       (idx++, destStationId);
                    ps.setTimestamp (idx++, Timestamp.valueOf(departureLDT));
                    ps.setTimestamp (idx++, Timestamp.valueOf(arrivalLDT));
                    ps.setDouble    (idx++, fare);
                    ps.setInt       (idx++, scheduleId);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        message     = "Schedule updated successfully.";
                        messageType = "success";
                    } else {
                        message = "Failed to update schedule.";
                    }
                }

            } else if ("delete".equals(action)) {
                // --- DELETE SCHEDULE ---
                String scheduleIdStr = request.getParameter("scheduleId");
                if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
                    message = "Schedule ID required for delete.";
                } else {
                    int scheduleId = Integer.parseInt(scheduleIdStr);
                    String deleteSql = "DELETE FROM train_schedules WHERE id = ?";
                    ps = conn.prepareStatement(deleteSql);
                    ps.setInt(1, scheduleId);
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        message     = "Schedule deleted successfully.";
                        messageType = "success";
                    } else {
                        message = "Failed to delete schedule.";
                    }
                }

            } else {
                message = "Unknown action: " + action;
            }

        } catch (NumberFormatException e) {
            message = "Invalid number format: " + e.getMessage();
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
        } finally {
            try { if (ps   != null) ps.close();   } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }

        // 4) Forward back with feedback
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("rep_manage_schedules.jsp")
               .forward(request, response);
    }
}
