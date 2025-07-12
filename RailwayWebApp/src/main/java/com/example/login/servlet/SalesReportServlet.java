package com.example.login.servlet;

import com.example.login.dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;
import java.time.YearMonth;
import java.math.BigDecimal;

@WebServlet("/admin/sales-report")
public class SalesReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // parse year param or default to current year
        int year;
        String ys = req.getParameter("year");
        if (ys != null) {
            try { year = Integer.parseInt(ys); }
            catch (NumberFormatException e) { year = java.time.Year.now().getValue(); }
        } else {
            year = java.time.Year.now().getValue();
        }

        try {
            Map<YearMonth, BigDecimal> salesData =
                new ReportDAO().getMonthlySales(year);

            req.setAttribute("salesData", salesData);
            req.setAttribute("year", year);

            req.getRequestDispatcher("/admin/salesReport.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error generating sales report", e);
        }
    }
}

