package com.example.login;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/scheduleDetails")
public class ScheduleDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) ensure logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login2.jsp");
            return;
        }

        // 2) read & validate parameters
        String oParam = req.getParameter("originStationID");
        String dParam = req.getParameter("destinationStationID");
        String dateParam = req.getParameter("travelDate");
        String lineParam = req.getParameter("lineCode");  // from your "View Stops" link

        if (oParam == null || dParam == null || dateParam == null) {
            resp.sendRedirect(req.getContextPath() + "/search.jsp");
            return;
        }

        int origin = Integer.parseInt(oParam);
        int dest   = Integer.parseInt(dParam);
        LocalDate date = LocalDate.parse(dateParam);

        try {
            ScheduleDAO dao = new ScheduleDAO();

            // 3) determine which run (lineCode) to show stops for
            int lineCode;
            if (lineParam != null) {
                lineCode = Integer.parseInt(lineParam);
            } else {
                // fallback: pick the very next schedule
                List<Schedule> upcoming = dao.findSchedules(origin, dest, date);
                if (upcoming.isEmpty()) {
                    throw new ServletException("No upcoming schedules found.");
                }
                lineCode = upcoming.get(0).getLineCode();
            }

            // 4) decide direction: outbound vs inbound
            //    route‐order is Trenton(4)->NB(3)->Newark(1)->NY(2)
            Map<Integer,Integer> order = Map.of(
              4, 0,
              3, 1,
              1, 2,
              2, 3
            );
            boolean inbound = order.get(origin) > order.get(dest);

            // 5) fetch stops for that line & direction
            List<Schedule> stops = dao.getStopsForLine(lineCode, inbound);

            // 6) forward to JSP
            req.setAttribute("lineCode", lineCode);
            req.setAttribute("stops",     stops);
            req.getRequestDispatcher("/scheduleDetails.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading schedule details", e);
        }
    }
}


