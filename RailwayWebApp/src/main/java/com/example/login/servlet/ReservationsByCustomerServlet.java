package com.example.login.servlet;

import com.example.login.ReservationDetail;
import com.example.login.dao.ReservationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reservations/customer")
public class ReservationsByCustomerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("customerName");
        if (name != null && !name.isEmpty()) {
            try {
                List<ReservationDetail> list =
                    new ReservationDAO().findByCustomerName(name);
                req.setAttribute("customerName", name);
                req.setAttribute("reservations", list);
            } catch (Exception e) {
                throw new ServletException("Error fetching by customer", e);
            }
        }

        // forward to the JSP (see below)
        req.getRequestDispatcher("/admin/reservationsByCustomer.jsp")
           .forward(req, resp);
    }
}
