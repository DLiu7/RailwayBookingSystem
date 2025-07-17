<%@ page import="java.sql.*, java.util.*, com.example.login.DatabaseUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  // Protect page
  if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("login2.jsp");
    return;
  }
  String user     = (String) session.getAttribute("user");
  boolean isAdmin = "admin".equalsIgnoreCase(user);

  // Prepare lists
  List<Map<String,Object>> currentList = new ArrayList<>();
  List<Map<String,Object>> pastList    = new ArrayList<>();

  String selectCols =
      "r.id           AS id,"
    + " u.username     AS username,"
    + " r.train        AS train,"
    + " r.line_name    AS line,"
    + " r.travel_date  AS travelDate,"
    + " r.departure_time AS time,"
    + " o.name         AS origin,"
    + " d.name         AS destination,"
    + " r.seat_id      AS seat,"
    + " r.passenger_type AS passengerType,"
    + " r.trip_type    AS tripType,"
    + " r.total_fare   AS fare,"
    + " r.reservation_date AS bookedOn";
  String fromJoins =
      "reservations r"
    + " JOIN users   u ON r.user_id                = u.CustomerID"
    + " JOIN station o ON r.origin_station_id      = o.station_id"
    + " JOIN station d ON r.destination_station_id = d.station_id";

  String currentSql = "SELECT " + selectCols + " FROM " + fromJoins
                    + " WHERE " + (isAdmin
                        ? "r.travel_date >= CURDATE()"
                        : "u.username = ? AND r.travel_date >= CURDATE()");
  String pastSql    = "SELECT " + selectCols + " FROM " + fromJoins
                    + " WHERE " + (isAdmin
                        ? "r.travel_date < CURDATE()"
                        : "u.username = ? AND r.travel_date < CURDATE()");
  try ( Connection conn = DatabaseUtils.getConnection();
        PreparedStatement psCurr = conn.prepareStatement(currentSql);
        PreparedStatement psPast = conn.prepareStatement(pastSql) ) {

    if (!isAdmin) {
      psCurr.setString(1, user);
      psPast.setString(1, user);
    }

    try (ResultSet rs = psCurr.executeQuery()) {
      while (rs.next()) {
        Map<String,Object> row = new HashMap<>();
        row.put("username",     rs.getString   ("username"));
        row.put("id",           rs.getInt      ("id"));
        row.put("train",        rs.getString   ("train"));
        row.put("line",         rs.getString   ("line"));
        row.put("travelDate",   rs.getDate     ("travelDate"));
        row.put("time",         rs.getTime     ("time"));
        row.put("origin",       rs.getString   ("origin"));
        row.put("destination",  rs.getString   ("destination"));
        row.put("seat",         rs.getString   ("seat"));
        row.put("passengerType",rs.getString   ("passengerType"));
        row.put("tripType",     rs.getString   ("tripType"));
        row.put("fare",         rs.getBigDecimal("fare"));
        row.put("bookedOn",     rs.getDate     ("bookedOn"));
        currentList.add(row);
      }
    }

    try (ResultSet rs = psPast.executeQuery()) {
      while (rs.next()) {
        Map<String,Object> row = new HashMap<>();
        row.put("username",     rs.getString   ("username"));
        row.put("id",           rs.getInt      ("id"));
        row.put("train",        rs.getString   ("train"));
        row.put("line",         rs.getString   ("line"));
        row.put("travelDate",   rs.getDate     ("travelDate"));
        row.put("time",         rs.getTime     ("time"));
        row.put("origin",       rs.getString   ("origin"));
        row.put("destination",  rs.getString   ("destination"));
        row.put("seat",         rs.getString   ("seat"));
        row.put("passengerType",rs.getString   ("passengerType"));
        row.put("tripType",     rs.getString   ("tripType"));
        row.put("fare",         rs.getBigDecimal("fare"));
        row.put("bookedOn",     rs.getDate     ("bookedOn"));
        pastList.add(row);
      }
    }
  } catch (Exception e) {
    throw new ServletException("Error loading reservations", e);
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= isAdmin 
           ? "All Users’ Reservations" 
           : user + "’s Reservations" %></title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap"
        rel="stylesheet">
  <style>
    * { box-sizing:border-box; margin:0; padding:0 }
    html, body {
      height:100%; 
      background:url('TR1.jpg') center/cover no-repeat;
      font-family:'Roboto',sans-serif;
    }
    .container {
      background:#0a2540; color:#fff;
      border-radius:8px; padding:32px; margin:40px auto;
      width:960px; box-shadow:0 2px 12px rgba(0,0,0,0.4);
      animation:fadeIn .8s ease-out;
    }
    h1, h2 {
      margin-bottom:16px;
      font-weight:500;
    }
    h1 { font-size:1.75rem; }
    h2 { font-size:1.25rem; margin-top:32px; }

    .table-wrapper {
      overflow-x:auto; white-space:nowrap; margin-bottom:24px;
    }
    table {
      width:100%; border-collapse:collapse;
      background:rgba(0,0,0,0.2);
    }
    th, td {
      padding:12px 8px; text-align:center; font-size:14px;
    }
    th {
      background:rgba(0,0,0,0.6); text-transform:uppercase;
    }
    tr:nth-child(even) { background:rgba(255,255,255,0.05); }
    tr:nth-child(odd)  { background:rgba(255,255,255,0.02); }

    .btn-cancel {
      background:#ff6961; color:#fff; border:none;
      padding:6px 12px; border-radius:4px; cursor:pointer;
      transition:background .2s;
    }
    .btn-cancel:hover { background:#ff4343; }

    .btn-back {
      display:inline-block; background:#FFC947; color:#0A2540;
      padding:12px 28px; border-radius:4px; text-decoration:none;
      font-weight:500; box-shadow:0 2px 6px rgba(0,0,0,0.3);
      transition:background .2s;
    }
    .btn-back:hover { background:#f06552; }

    @keyframes fadeIn {
      from { opacity:0; transform:translateY(-20px); }
      to   { opacity:1; transform:translateY(0); }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1><%= isAdmin 
           ? "All Users’ Reservations" 
           : user + "’s Reservations" %></h1>

    <!-- CURRENT RESERVATIONS -->
    <h2>Current Reservations</h2>
    <div class="table-wrapper">
      <table>
        <tr>
          <% if (isAdmin) { %><th>User</th><% } %>
          <th>Res.ID</th><th>Train</th><th>Line</th>
          <th>Date</th>
          <th>Departs At</th><th>Arrives At</th>
          <th>Origin</th><th>Destination</th>
          <th>Seat</th><th>Passenger Type</th><th>Trip Type</th>
          <th>Fare</th><th>Booked On</th>
          <% if (!isAdmin) { %><th>Action</th><% } %>
        </tr>
        <% if (currentList.isEmpty()) { %>
          <tr>
            <td colspan="<%= (isAdmin? 15 : 16) %>">No current reservations.</td>
          </tr>
        <% } else {
            for (Map<String,Object> r : currentList) {
              String line = (String) r.get("line");
              String origin = (String) r.get("origin");
              String dest = (String) r.get("destination");
              Time dbTime = (Time) r.get("time");
              String dbTimeStr = dbTime.toString().substring(0,5);
        %>
        <tr>
          <% if (isAdmin) { %><td><%= r.get("username") %></td><% } %>
          <td><%= r.get("id") %></td>
          <td><%= r.get("train") %></td>
          <td><%= line %></td>
          <td><%= r.get("travelDate") %></td>
          <td class="depart-time"
              data-line="<%= line %>"
              data-origin="<%= origin %>"
              data-destination="<%= dest %>"
              data-time="<%= dbTimeStr %>">--:--</td>
          <td class="arrival-time">--:--</td>
          <td><%= origin %></td>
          <td><%= dest %></td>
          <td><%= r.get("seat") %></td>
          <td><%= r.get("passengerType") %></td>
          <td><%= r.get("tripType") %></td>
          <td>$<%= r.get("fare") %></td>
          <td><%= r.get("bookedOn") %></td>
          <% if (!isAdmin) { %>
            <td>
              <form method="post" action="reserve">
                <input type="hidden" name="action"        value="cancel">
                <input type="hidden" name="reservationId" value="<%= r.get("id") %>">
                <button type="submit" class="btn-cancel">Cancel</button>
              </form>
            </td>
          <% } %>
        </tr>
        <%   }
           }
        %>
      </table>
    </div>

    <!-- PAST RESERVATIONS -->
    <h2>Past Reservations</h2>
    <div class="table-wrapper">
      <table>
        <tr>
          <% if (isAdmin) { %><th>User</th><% } %>
          <th>Res.ID</th><th>Train</th><th>Line</th>
          <th>Date</th>
          <th>Departs At</th><th>Arrives At</th>
          <th>Origin</th><th>Destination</th>
          <th>Seat</th><th>Passenger Type</th><th>Trip Type</th>
          <th>Fare</th><th>Booked On</th>
        </tr>
        <% if (pastList.isEmpty()) { %>
          <tr><td colspan="<%= (isAdmin? 15 : 15) %>">No past reservations.</td></tr>
        <% } else {
            for (Map<String,Object> r : pastList) {
              String line = (String) r.get("line");
              String origin = (String) r.get("origin");
              String dest = (String) r.get("destination");
              Time dbTime = (Time) r.get("time");
              String dbTimeStr = dbTime.toString().substring(0,5);
        %>
        <tr>
          <% if (isAdmin) { %><td><%= r.get("username") %></td><% } %>
          <td><%= r.get("id") %></td>
          <td><%= r.get("train") %></td>
          <td><%= line %></td>
          <td><%= r.get("travelDate") %></td>
          <td class="depart-time"
              data-line="<%= line %>"
              data-origin="<%= origin %>"
              data-destination="<%= dest %>"
              data-time="<%= dbTimeStr %>">--:--</td>
          <td class="arrival-time">--:--</td>
          <td><%= origin %></td>
          <td><%= dest %></td>
          <td><%= r.get("seat") %></td>
          <td><%= r.get("passengerType") %></td>
          <td><%= r.get("tripType") %></td>
          <td>$<%= r.get("fare") %></td>
          <td><%= r.get("bookedOn") %></td>
        </tr>
        <%   }
           }
        %>
      </table>
    </div>

    <a href="welcome.jsp" class="btn-back">Back to Welcome</a>
  </div>

  <script>
    // base schedule for line 4000
    const outbound = ['Trenton','New Brunswick','Newark Penn','New York Penn'];
    const inbound  = ['New York Penn','Newark Penn','New Brunswick','Trenton'];
    const baseOut  = {
      'Trenton':'08:00','New Brunswick':'09:00',
      'Newark Penn':'10:00','New York Penn':'11:00'
    };
    const baseIn   = {
      'New York Penn':'14:00','Newark Penn':'15:00',
      'New Brunswick':'16:00','Trenton':'17:00'
    };

    function shiftTime(timeStr, offset) {
      let [h,m] = timeStr.split(':').map(Number);
      h += offset;
      return String(h).padStart(2,'0') + ':' + String(m).padStart(2,'0');
    }

    // compute for every row
    document.querySelectorAll('td.depart-time').forEach(td => {
      const line  = td.dataset.line;
      const ori   = td.dataset.origin;
      const dst   = td.dataset.destination;
      const fallback = td.dataset.time;  // DB time
      let depart='--:--', arrive='--:--';

      if (line.startsWith('400')) {
        const offset = parseInt(line,10) - 4000;
        const oi = outbound.indexOf(ori), di = outbound.indexOf(dst);
        if (oi>=0 && di>=0 && oi<di) {
          depart = shiftTime(baseOut[ori], offset);
          arrive = shiftTime(baseOut[dst], offset);
        } else {
          const ii = inbound.indexOf(ori), id = inbound.indexOf(dst);
          if (ii>=0 && id>=0 && ii<id) {
            depart = shiftTime(baseIn[ori], offset);
            arrive = shiftTime(baseIn[dst], offset);
          }
        }
      } else {
        depart = fallback;
      }

      td.textContent = depart;
      const next = td.nextElementSibling;
      if (next && next.classList.contains('arrival-time')) {
        next.textContent = arrive;
      }
    });
  </script>
</body>
</html>


