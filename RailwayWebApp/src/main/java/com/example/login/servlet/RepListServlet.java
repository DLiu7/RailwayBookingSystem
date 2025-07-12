package com.example.login.servlet;

import com.example.login.Employee;
import com.example.login.dao.EmployeeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reps")
public class RepListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Employee> reps = new EmployeeDAO().findReps();
            req.setAttribute("reps", reps);
            req.getRequestDispatcher("/admin/repsList.jsp")
               .forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
