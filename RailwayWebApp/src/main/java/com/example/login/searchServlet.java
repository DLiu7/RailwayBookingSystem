package com.example.login;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/search")
public class searchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Security check
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login2.jsp");
            return;
        }

        // 2. Read parameters
        int origin      = Integer.parseInt(req.getParameter("originStationID"));
        int destination = Integer.parseInt(req.getParameter("destinationStationID"));
        LocalDate date  = LocalDate.parse(req.getParameter("travelDate"));

        try {
            // 3. Query the DAO
            ScheduleDAO dao = new ScheduleDAO();
            List<Schedule> results = dao.findSchedules(origin, destination, date);

            // 4. Pass to JSP
            req.setAttribute("results", results);
            req.getRequestDispatcher("/searchResults.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error searching schedules", e);
        }
    }
}
