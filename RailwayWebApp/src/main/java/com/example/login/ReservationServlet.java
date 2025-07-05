package com.example.login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// central JDBC utility
import com.example.login.DatabaseUtils;

@WebServlet("/reserve")
public class ReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Make sure the user is logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("login2.jsp");
            return;
        }
        String username = (String) session.getAttribute("user");

        // 2) Read form parameters
        String train     = req.getParameter("train");
        String dateStr   = req.getParameter("date");
        String seatParam = req.getParameter("seat");

        try (
            // 3) Get the connection from DatabaseUtils
            Connection conn = DatabaseUtils.getConnection()
        ) {
            // 4) Look up the user’s numeric ID
            int userId;
            try (PreparedStatement pu = conn.prepareStatement(
                        "SELECT id FROM users WHERE username = ?"
                    )) {
                pu.setString(1, username);
                try (ResultSet ru = pu.executeQuery()) {
                    if (!ru.next()) {
                        throw new ServletException("Unknown user: " + username);
                    }
                    userId = ru.getInt("id");
                }
            }

            // 5) Insert the reservation with the chosen seat
            try (PreparedStatement pi = conn.prepareStatement(
                        "INSERT INTO reservations (user_id, train, travel_date, seat_id) "
                      + "VALUES (?, ?, ?, ?)"
                    )) {
                pi.setInt   (1, userId);
                pi.setString(2, train);
                pi.setDate  (3, Date.valueOf(dateStr));
                pi.setString(4, seatParam);
                pi.executeUpdate();
            }

            // 6) Redirect to bookings.jsp so the user sees the new reservation
            resp.sendRedirect("bookings.jsp");

        } catch (SQLException e) {
            throw new ServletException("Database error while reserving", e);
        }
    }
}


