package com.example.login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/customerService")
public class CustomerServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handles POST requests for asking questions and replying
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String currentUser = (String) session.getAttribute("user");
        String userRole = (String) session.getAttribute("role");

        // Redirect if not logged in
        if (currentUser == null) {
            response.sendRedirect("login2.jsp");
            return;
        }

        String action = request.getParameter("action");
        String message = null;
        String messageType = "error";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtils.getConnection();

            // Get current user's ID
            int currentUserId = -1;
            ps = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            ps.setString(1, currentUser);
            rs = ps.executeQuery();
            if (rs.next()) {
                currentUserId = rs.getInt("id");
            } else {
                message = "User not found in database.";
                request.setAttribute("message", message);
                request.setAttribute("messageType", messageType);
                request.getRequestDispatcher("customer_service_forum.jsp").forward(request, response);
                return;
            }
            rs.close();
            ps.close();

            if ("askQuestion".equals(action)) {
                // --- CUSTOMER ASKING A NEW QUESTION ---
                String subject = request.getParameter("subject");
                String questionText = request.getParameter("questionText");

                if (subject == null || subject.trim().isEmpty() ||
                    questionText == null || questionText.trim().isEmpty()) {
                    message = "Subject and question text are required.";
                } else {
                    String insertSql = "INSERT INTO questions (user_id, subject, question_text, status) VALUES (?, ?, ?, ?)";
                    ps = conn.prepareStatement(insertSql);
                    ps.setInt(1, currentUserId);
                    ps.setString(2, subject);
                    ps.setString(3, questionText);
                    ps.setString(4, "Open"); // Default status for new questions

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        message = "Your question has been submitted successfully!";
                        messageType = "success";
                    } else {
                        message = "Failed to submit your question.";
                    }
                }

            } else if ("replyQuestion".equals(action)) {
                // --- CUSTOMER REP REPLYING TO A QUESTION ---
                // Only allow if user is a customer rep or admin
                if (!"admin".equalsIgnoreCase(userRole) && !"customer_rep".equalsIgnoreCase(userRole)) {
                    message = "You are not authorized to reply to questions.";
                } else {
                    String questionIdStr = request.getParameter("questionId");
                    String replyText = request.getParameter("replyText");

                    if (questionIdStr == null || questionIdStr.isEmpty() ||
                        replyText == null || replyText.trim().isEmpty()) {
                        message = "Reply text and question ID are required.";
                    } else {
                        int questionId = Integer.parseInt(questionIdStr);

                        // Insert the reply
                        String insertReplySql = "INSERT INTO replies (question_id, user_id, reply_text) VALUES (?, ?, ?)";
                        ps = conn.prepareStatement(insertReplySql);
                        ps.setInt(1, questionId);
                        ps.setInt(2, currentUserId); // The rep's user_id
                        ps.setString(3, replyText);
                        int replyRowsAffected = ps.executeUpdate();

                        if (replyRowsAffected > 0) {
                            // Update question status to 'Answered'
                            String updateStatusSql = "UPDATE questions SET status = 'Answered' WHERE id = ?";
                            ps = conn.prepareStatement(updateStatusSql);
                            ps.setInt(1, questionId);
                            ps.executeUpdate(); // No need to check rowsAffected for status update

                            message = "Reply submitted successfully!";
                            messageType = "success";
                        } else {
                            message = "Failed to submit reply.";
                        }
                    }
                }
            } else {
                message = "Invalid action specified.";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error: " + e.getMessage();
        } catch (NumberFormatException e) {
            e.printStackTrace();
            message = "Invalid ID format.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "An unexpected error occurred: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        // Forward back to the forum page with the message
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("customer_service_forum.jsp").forward(request, response);
    }
}
