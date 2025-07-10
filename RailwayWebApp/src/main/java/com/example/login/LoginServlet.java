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
import javax.servlet.http.HttpSession; // Import HttpSession

// your DB utility
import com.example.login.DatabaseUtils;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** Utility to get a connection */
    private Connection getConnection() throws SQLException {
        return DatabaseUtils.getConnection();
    }

    /** Show the login page on GET */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // forward rather than redirect so we can display any messages
        req.getRequestDispatcher("/login2.jsp")
           .forward(req, resp);
    }

    /** Handle form submission on POST */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // FIX: Select both password AND role
        String sql = "SELECT password, role FROM users WHERE username = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String userRoleFromDB = rs.getString("role"); // FIX: Retrieve the role

                    // CASE-SENSITIVE check:
                    if (storedPassword.equals(password)) {
                        // success!
                        HttpSession session = req.getSession(); // Get the session
                        session.setAttribute("user", username);
                        session.setAttribute("role", userRoleFromDB); // FIX: Store the role in session

                        resp.sendRedirect("welcome.jsp");
                        return;
                    }
                }
                // either no such user or password didn’t match exactly
                req.setAttribute("error", "Invalid username or password");
                req.getRequestDispatcher("/login2.jsp")
                   .forward(req, resp);
            }

        } catch (SQLException e) {
            // Log the exception for debugging purposes
            e.printStackTrace();
            throw new ServletException("Database error during login", e);
        }
    }
}
