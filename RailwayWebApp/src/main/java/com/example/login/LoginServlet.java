package com.example.login;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** Utility to get a JDBC connection */
    private Connection getConnection() throws SQLException {
        // Assuming DatabaseUtils.getConnection() handles your database connection logic
        return DatabaseUtils.getConnection();
    }

    /** Show the login page */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login2.jsp")
           .forward(req, resp);
    }

    /** Handle form submission */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection conn = getConnection()) {
            // 1) Try the employees table for admin or customer_representative
            String empSql = "SELECT ssn, password, role FROM employees WHERE username = ?";
            try (PreparedStatement eps = conn.prepareStatement(empSql)) {
                eps.setString(1, username);
                try (ResultSet ers = eps.executeQuery()) {
                    if (ers.next()) {
                        String storedPassword = ers.getString("password");
                        String role = ers.getString("role");
                        String ssn = ers.getString("ssn"); // Get SSN for employee

                        // --- IMPORTANT: Replace with secure password hashing/verification ---
                        // Example: if (PasswordUtil.checkPassword(password, storedPassword)) {
                        if (storedPassword.equals(password)) { // Currently plain text comparison
                        // ------------------------------------------------------------------

                            HttpSession session = req.getSession();
                            session.setAttribute("user", username);
                            session.setAttribute("role", role); // Store the actual role from DB
                            session.setAttribute("ssn", ssn); // Store SSN for employees

                            if ("admin".equals(role)) {
                                // Redirect admins to their specific dashboard, if you have one.
                                // For now, let's assume they might also use rep_dashboard or have their own separate section.
                                // If you have an '/admin/dashboard' as intended, keep this:
                                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                                // Otherwise, consider if admins go to rep_dashboard or a different page
                                // resp.sendRedirect(req.getContextPath() + "/rep_dashboard.jsp");
                                return;
                            } else if ("customer_representative".equals(role)) {
                                resp.sendRedirect(req.getContextPath() + "/rep_dashboard.jsp"); // Redirect reps to their dashboard
                                return;
                            }
                        }
                        // Found an employee but bad password or role not handled for this login path
                        req.setAttribute("error", "Invalid username or password");
                        req.getRequestDispatcher("/login2.jsp")
                           .forward(req, resp);
                        return;
                    }
                }
            }

            // 2) Fallback: try the users table for a customer
            String userSql = "SELECT CustomerID, password FROM users WHERE username = ?"; // Fetch CustomerID
            try (PreparedStatement ups = conn.prepareStatement(userSql)) {
                ups.setString(1, username);
                try (ResultSet urs = ups.executeQuery()) {
                    if (urs.next()) {
                        int customerId = urs.getInt("CustomerID"); // Get CustomerID
                        String storedPassword = urs.getString("password");

                        // --- IMPORTANT: Replace with secure password hashing/verification ---
                        // Example: if (PasswordUtil.checkPassword(password, storedPassword)) {
                        if (storedPassword.equals(password)) { // Currently plain text comparison
                        // ------------------------------------------------------------------

                            HttpSession session = req.getSession();
                            session.setAttribute("user", username);
                            session.setAttribute("role", "customer");
                            session.setAttribute("customerId", customerId); // Store CustomerID for customers
                            resp.sendRedirect(req.getContextPath() + "/welcome.jsp");
                            return;
                        }
                    }
                }
            }

            // 3) No valid login found in either table
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/login2.jsp")
               .forward(req, resp);

        } catch (SQLException e) {
            // Log the exception for debugging purposes, do not expose to user
            e.printStackTrace();
            throw new ServletException("Database error during login", e);
        }
    }
}
