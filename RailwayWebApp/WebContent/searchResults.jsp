<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.List,com.example.login.Schedule" %>
<%
  // Protect page
  if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("login2.jsp");
    return;
  }

  @SuppressWarnings("unchecked")
  List<Schedule> results = (List<Schedule>) request.getAttribute("results");
  String ctx = request.getContextPath();

  // Grab the search params so we can re-submit them to details:
  String originParam     = request.getParameter("originStationID");
  String destParam       = request.getParameter("destinationStationID");
  String travelDateParam = request.getParameter("travelDate");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Available Trains</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap"
        rel="stylesheet">
  <style>
    html, body {
      margin:0; padding:0; height:100%;
      font-family:'Roboto',sans-serif;
         background: url('Train1.jpg') no-repeat center center fixed;
      background-size: cover;
    }
    .panel {
      background:rgba(10,37,64,1);
      max-width:800px; margin:40px auto; padding:40px;
      border-radius:16px; box-shadow:0 8px 32px rgba(0,0,0,0.4);
      color:#fff;
    }
    .panel h2 {
      text-align:center; margin-bottom:24px; font-weight:500;
    }
    table {
      width:100%; border-collapse:collapse; font-size:14px; color:#fff;
    }
    th, td {
      padding:12px 8px; text-align:center;
    }
    th {
      background:rgba(0,0,0,0.6); cursor:pointer;
    }
    tr:nth-child(even){ background:rgba(255,255,255,0.05); }
    tr:nth-child(odd) { background:rgba(255,255,255,0.02); }
    .btn-detail {
      background:#FFC947; color:#0A2540;
      padding:6px 12px; border:none; border-radius:4px;
      text-decoration:none; font-size:14px;
    }
    .btn-detail:hover { background:#FFEA00; }
    .link-secondary {
      text-align:center; margin-top:16px;
    }
    .link-secondary a { color:#FFC947; text-decoration:none; }
  </style>
  <script>
    function sortTable(idx) {
      const table = document.getElementById('resultsTable'),
            tbody = table.tBodies[0],
            rows  = Array.from(tbody.rows);
      const asc = table.getAttribute('data-sort-col')!=idx
                || table.getAttribute('data-sort-dir')=='desc';
      rows.sort((a,b)=>{
        let x=a.cells[idx].innerText.replace('$','').trim(),
            y=b.cells[idx].innerText.replace('$','').trim();
        let nx=parseFloat(x)||x,
            ny=parseFloat(y)||y;
        if(nx<ny) return asc?-1:1;
        if(nx>ny) return asc?1:-1;
        return 0;
      });
      rows.forEach(r=>tbody.appendChild(r));
      table.setAttribute('data-sort-col', idx);
      table.setAttribute('data-sort-dir', asc?'asc':'desc');
    }
  </script>
</head>
<body>
  <div class="panel">
    <h2>Available Trains</h2>
    <table id="resultsTable">
      <thead>
        <tr>
          <th onclick="sortTable(0)">Depart</th>
          <th onclick="sortTable(1)">Arrive</th>
          <th onclick="sortTable(2)">Fare</th>
          <th>Details</th>
        </tr>
      </thead>
      <tbody>
        <% if (results == null || results.isEmpty()) { %>
          <tr>
            <td colspan="4">No schedules found.</td>
          </tr>
        <% } else {
             for (Schedule s : results) {
               String dep = s.getDepartureTime()
                             .toLocalDateTime()
                             .toLocalTime()
                             .toString().substring(0,5);
               String arr = s.getArrivalTime()
                             .toLocalDateTime()
                             .toLocalTime()
                             .toString().substring(0,5);
        %>
          <tr>
            <td><%= dep %></td>
            <td><%= arr %></td>
            <td>$<%= s.getFare() %></td>
            <td>
              <a class="btn-detail"
                  href="<%=ctx%>/scheduleDetails?originStationID=<%=originParam%>&destinationStationID=<%=destParam%>&travelDate=<%=travelDateParam%>&lineCode=<%=s.getLineCode()%>"> 
                  View Stops
              </a>
            </td>
          </tr>
        <%   }
           } %>
      </tbody>
    </table>
    <div class="link-secondary">
      <a href="<%= ctx %>/search.jsp">New Search</a>
    </div>
  </div>
</body>
</html>