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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String currentUser = (String) session.getAttribute("user"); // Username
        String userRole = (String) session.getAttribute("role");    // Role from session

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

            // --- Get current user's ID based on their role ---
            // CustomerID is int, Employee SSN is String. We will store the relevant ID here.
            Integer customerId = null; // For customers
            String employeeSsn = null; // For employees

            String idQuerySql = "";

            if ("customer_representative".equalsIgnoreCase(userRole)) {
                idQuerySql = "SELECT ssn FROM employees WHERE Username = ?"; // Fetching SSN
            } else { // Assume 'customer' role
                idQuerySql = "SELECT CustomerID FROM users WHERE Username = ?";
            }

            ps = conn.prepareStatement(idQuerySql);
            ps.setString(1, currentUser);
            rs = ps.executeQuery();
            if (rs.next()) {
                if ("customer_representative".equalsIgnoreCase(userRole)) {
                    employeeSsn = rs.getString("ssn"); // Get SSN as String
                } else {
                    customerId = rs.getInt("CustomerID"); // Get CustomerID as Integer
                }
            } else {
                message = "User ID not found in database for current role. Please log in again.";
                request.setAttribute("message", message);
                request.setAttribute("messageType", messageType);
                request.getRequestDispatcher("customer_service_forum.jsp").forward(request, response);
                return;
            }
            rs.close();
            ps.close();

            if ("askQuestion".equals(action)) {
                // --- CUSTOMER ASKING A NEW QUESTION ---
                // ONLY allow users with the 'customer' role to ask questions
                if (!"customer".equalsIgnoreCase(userRole) || customerId == null) {
                    message = "Only customers are allowed to ask new questions.";
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", messageType);
                    request.getRequestDispatcher("customer_service_forum.jsp").forward(request, response);
                    return;
                }

                String subject = request.getParameter("subject");
                String questionText = request.getParameter("questionText");

                if (subject == null || subject.trim().isEmpty() ||
                    questionText == null || questionText.trim().isEmpty()) {
                    message = "Subject and question text are required.";
                } else {
                    // Use customerId (Integer) for questions table
                    String insertSql = "INSERT INTO questions (CustomerID, Subject, QuestionText, Status) VALUES (?, ?, ?, ?)";
                    ps = conn.prepareStatement(insertSql);
                    ps.setInt(1, customerId); // This is the CustomerID
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
                // Only allow if user is a customer_representative AND employeeSsn is found
                if (!"customer_representative".equalsIgnoreCase(userRole) || employeeSsn == null) {
                    message = "You are not authorized to reply to questions.";
                } else {
                    String questionIdStr = request.getParameter("questionId");
                    String replyText = request.getParameter("replyText");

                    if (questionIdStr == null || questionIdStr.isEmpty() ||
                        replyText == null || replyText.trim().isEmpty()) {
                        message = "Reply text and question ID are required.";
                    } else {
                        int questionId = Integer.parseInt(questionIdStr);

                        // Use employeeSsn (String) for the replies table
                        String insertReplySql = "INSERT INTO replies (QuestionID_FK, EmployeeSSN_FK, ReplyText) VALUES (?, ?, ?)";
                        ps = conn.prepareStatement(insertReplySql);
                        ps.setInt(1, questionId);
                        ps.setString(2, employeeSsn); // Use SSN (String) here
                        ps.setString(3, replyText);
                        int replyRowsAffected = ps.executeUpdate();

                        if (replyRowsAffected > 0) {
                            // Update question status to 'Answered'
                            String updateStatusSql = "UPDATE questions SET Status = 'Answered' WHERE QuestionID = ?";
                            ps = conn.prepareStatement(updateStatusSql);
                            ps.setInt(1, questionId);
                            ps.executeUpdate();

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
            message = "Invalid ID format. Ensure IDs are correctly handled.";
        } catch (Exception e) {
            e.printStackTrace();
            message = "An unexpected error occurred: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.getRequestDispatcher("customer_service_forum.jsp").forward(request, response);
    }
}