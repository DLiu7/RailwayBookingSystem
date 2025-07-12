package com.example.login.servlet;

import com.example.login.dao.EmployeeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/rep-delete")
public class RepDeleteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String ssn = req.getParameter("ssn");
            new EmployeeDAO().delete(ssn);
            resp.sendRedirect(req.getContextPath() + "/admin/reps");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
