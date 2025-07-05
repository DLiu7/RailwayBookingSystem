package com.example.login;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private Connection getConnection() throws SQLException, ServletException {
    	
    	 try {
             Class.forName("com.mysql.cj.jdbc.Driver");
         } catch (ClassNotFoundException e) {
             throw new ServletException("MySQL JDBC Driver not found", e);
         }

        return DriverManager.getConnection(
          "jdbc:mysql://localhost:3306/login_project",
          "root", "Fla97456@");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT 1 FROM users WHERE username=? AND password=?")) {
            ps.setString(1, user);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect("welcome.jsp");
            } else {
                req.setAttribute("error", "Invalid username or password");
                req.getRequestDispatcher("login2.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws IOException {
        resp.sendRedirect("login2.jsp");
    }
}

