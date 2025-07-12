package com.example.login.servlet;

import com.example.login.Employee;
import com.example.login.dao.EmployeeDAO;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/rep-save")
public class RepSaveServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Employee e = new Employee();
            e.setSsn(req.getParameter("ssn"));
            e.setFirstName(req.getParameter("firstName"));
            e.setLastName(req.getParameter("lastName"));
            e.setUsername(req.getParameter("username"));
            // hash the incoming password before saving:
            String raw = req.getParameter("password");
             e.setPassword( raw );
            e.setRole("customer_representative");

            EmployeeDAO dao = new EmployeeDAO();
            // if originalSsn present, it's an update
            if (req.getParameter("originalSsn") != null) {
                dao.update(e);
            } else {
                dao.create(e);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/reps");
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
