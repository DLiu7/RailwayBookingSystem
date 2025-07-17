<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.List, com.example.login.Schedule" %>
<%
    // Protect page
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Schedule> stops = (List<Schedule>) request.getAttribute("stops");
    // lineCode was set as an Integer in the servlet:
    Integer lineCode = (Integer) request.getAttribute("lineCode");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Line <%= lineCode %> Stops</title>

  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap"
        rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height:100%;
      font-family:'Roboto',sans-serif;
         background: url('Train1.jpg') no-repeat center center fixed;
      background-size: cover;
    }
    .panel {
      background: rgba(10,37,64,1);
      max-width: 600px;
      margin: 40px auto;
      padding: 40px 32px;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.4);
      color: #fff;
    }
    .panel h2 {
      text-align: center;
      margin-bottom: 24px;
      font-weight: 500;
      font-size: 1.5rem;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 14px;
      color: #fff;
    }
    th, td {
      padding: 12px 8px;
      text-align: center;
    }
    th {
      background: rgba(0,0,0,0.6);
    }
    tr:nth-child(even) { background: rgba(255,255,255,0.05); }
    tr:nth-child(odd)  { background: rgba(255,255,255,0.02); }
    .link-secondary {
      text-align: center;
      margin-top: 16px;
    }
    .link-secondary a {
      color: #FFC947;
      text-decoration: none;
      font-size: 1rem;
      font-weight: 500;
    }
  </style>
</head>
<body>
  <div class="panel">
    <h2>Line <%= lineCode %> Stops</h2>
    <table>
      <thead>
        <tr>
          <th>Station</th>
          <th>Depart</th>
          <th>Arrive</th>
          <th>Arrived At</th>
        </tr>
      </thead>
      <tbody>
        <% if (stops == null || stops.isEmpty()) { %>
          <tr><td colspan="4">No stops found for this line.</td></tr>
        <% } else {
             for (int i = 0; i < stops.size(); i++) {
               Schedule s      = stops.get(i);
               boolean isLast  = (i == stops.size() - 1);
               String dep = s.getDepartureTime()
                             .toLocalDateTime()
                             .toLocalTime()
                             .toString().substring(0,5);
               String arr = s.getArrivalTime()
                             .toLocalDateTime()
                             .toLocalTime()
                             .toString().substring(0,5);
               // compute next station name (if any)
               String nextStation = isLast
                 ? ""
                 : stops.get(i + 1).getStationName();
        %>
          <tr>
            <td><%= s.getStationName() %></td>
            <% if (!isLast) { %>
              <td><%= dep %></td>
              <td><%= arr %></td>
            <% } else { %>
              <td></td>
              <td></td>
            <% } %>
            <td><%= nextStation %></td>
          </tr>
        <%   }
           } %>
      </tbody>
    </table>
    <div class="link-secondary">
      <a href="javascript:history.back()">Back to Results</a>
    </div>
  </div>
</body>
</html>

