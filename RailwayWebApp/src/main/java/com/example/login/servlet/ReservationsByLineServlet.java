package com.example.login.servlet;

import com.example.login.ReservationDetail;
import com.example.login.dao.ReservationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reservations/line")
public class ReservationsByLineServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String line = req.getParameter("lineName");
        if (line != null && !line.isEmpty()) {
            try {
                List<ReservationDetail> list =
                  new ReservationDAO().findByLineName(line);
                req.setAttribute("lineName", line);
                req.setAttribute("reservations", list);
            } catch (Exception e) {
                throw new ServletException("Error fetching by line", e);
            }
        }
        req.getRequestDispatcher("/admin/reservationsByLine.jsp")
           .forward(req, resp);
    }
}
