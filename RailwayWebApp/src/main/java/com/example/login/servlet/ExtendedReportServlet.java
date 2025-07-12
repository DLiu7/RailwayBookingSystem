package com.example.login.servlet;

import com.example.login.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/admin/extended-reports")
public class ExtendedReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        // Only admin should see these
        if (session == null || !"admin".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/login2.jsp");
            return;
        }

        try {
            ReportDAO dao = new ReportDAO();
            // 1) Revenue by line
            Map<String, BigDecimal> revByLine     = dao.getRevenueByLine();
            // 2) Revenue by customer
            Map<String, BigDecimal> revByCustomer = dao.getRevenueByCustomer();
            // 3) Best customer
            String bestCustomer                  = dao.getBestCustomer();
            // 4) Top 5 active lines
            Map<String, Integer> top5Lines       = dao.getTop5TransitLines();

            req.setAttribute("revByLine",     revByLine);
            req.setAttribute("revByCustomer", revByCustomer);
            req.setAttribute("bestCustomer",  bestCustomer);
            req.setAttribute("top5Lines",     top5Lines);

            req.getRequestDispatcher("/admin/extendedReports.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error generating extended reports", e);
        }
    }
}
