package com.example.login.servlet;

import com.example.login.Employee;
import com.example.login.dao.EmployeeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/rep-form")
public class RepFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String ssn = req.getParameter("ssn");
        if (ssn != null && !ssn.isEmpty()) {
            Employee rep = null;
            try {
                rep = new EmployeeDAO().findBySsn(ssn);
            } catch (Exception e) {
                throw new ServletException(e);
            }
            req.setAttribute("rep", rep);
        }
        req.getRequestDispatcher("/admin/repForm.jsp")
           .forward(req, resp);
    }
}

