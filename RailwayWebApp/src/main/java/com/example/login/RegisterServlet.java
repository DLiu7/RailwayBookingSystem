package com.example.login;  // ← your package

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

@WebServlet("/register")   // ← clients GET/POST /yourapp/register
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** 
     * Serve the registration form 
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // forwards /register → /register.jsp
        request.getRequestDispatcher("/register.jsp")
               .forward(request, response);
    }

    /**
     * Handle the submitted form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Retrieve parameters
        String username        = request.getParameter("username");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // 2) Basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty())
        {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        // 3) Check + Insert user
        String checkSql  = "SELECT COUNT(*) FROM users WHERE username = ?";
        String insertSql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement psCheck  = conn.prepareStatement(checkSql);
             PreparedStatement psInsert = conn.prepareStatement(insertSql))
        {
            // 3a) Check username
            psCheck.setString(1, username);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    request.setAttribute("error",
                        "Username '" + username + "' is already taken.");
                    request.getRequestDispatcher("/register.jsp")
                           .forward(request, response);
                    return;
                }
            }

            // 3b) Insert new user with default role = "customer"
            psInsert.setString(1, username);
            psInsert.setString(2, password);    // Plain text for now
            psInsert.setString(3, "customer");  // default
            int rows = psInsert.executeUpdate();

            if (rows > 0) {
                // SUCCESS → redirect to your confirmation page
                response.sendRedirect(request.getContextPath()
                                      + "/reg-sucess.jsp");
            } else {
                // odd failure
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
        }
    }
}

