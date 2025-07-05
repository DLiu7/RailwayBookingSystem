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

// import your centralized utility
import com.example.login.DatabaseUtils;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // now just pulls a connection from DatabaseUtils
    private Connection getConnection() throws SQLException {
        return DatabaseUtils.getConnection();
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

