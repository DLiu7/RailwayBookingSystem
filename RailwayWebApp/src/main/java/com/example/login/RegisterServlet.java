package com.example.login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** Show the registration form */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp")
               .forward(request, response);
    }

    /** Handle form submission */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Retrieve parameters
        String firstName       = request.getParameter("firstName");
        String lastName        = request.getParameter("lastName");
        String email           = request.getParameter("email");
        String username        = request.getParameter("username");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // 2) Basic validation
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName  == null || lastName.trim().isEmpty()  ||
            email     == null || email.trim().isEmpty()     ||
            username  == null || username.trim().isEmpty()  ||
            password  == null || password.trim().isEmpty()  ||
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

        // 3) Check for existing username or email
        String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        String insertSql = 
          "INSERT INTO users (firstName, lastName, email, username, password, role) "
        + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql);
             PreparedStatement psInsert = conn.prepareStatement(insertSql))
        {
            psCheck.setString(1, username);
            psCheck.setString(2, email);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    request.setAttribute("error",
                        "That username or email is already in use.");
                    request.getRequestDispatcher("/register.jsp")
                           .forward(request, response);
                    return;
                }
            }

            // 4) Insert new user
            psInsert.setString(1, firstName);
            psInsert.setString(2, lastName);
            psInsert.setString(3, email);
            psInsert.setString(4, username);
            psInsert.setString(5, password);    // plain text for now
            psInsert.setString(6, "customer");  // default role

            int rows = psInsert.executeUpdate();
            if (rows > 0) {
                // success
                response.sendRedirect(request.getContextPath() + "/reg-sucess.jsp");
            } else {
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

