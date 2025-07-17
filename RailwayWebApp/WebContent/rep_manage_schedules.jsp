<%@ page import="java.sql.*, java.util.List, java.util.ArrayList, com.example.login.DatabaseUtils" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  // Protect page
  if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect("login2.jsp"); return;
  }
  String userRole = (String) session.getAttribute("role");
  if (!"admin".equalsIgnoreCase(userRole)
   && !"customer_representative".equalsIgnoreCase(userRole)) {
    response.sendRedirect("welcome.jsp"); return;
  }

  // messages
  String message     = (String) request.getAttribute("message");
  String messageType = (String) request.getAttribute("messageType");

  // load dropdown data
  List<String[]> trainNames = new ArrayList<>();
  List<String[]> stations   = new ArrayList<>();
  try (Connection conn = DatabaseUtils.getConnection()) {
    try (PreparedStatement ps = conn.prepareStatement("SELECT id,name FROM trains ORDER BY name");
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        trainNames.add(new String[]{rs.getString("id"), rs.getString("name")});
      }
    }
    try (PreparedStatement ps = conn.prepareStatement("SELECT station_id,name FROM station ORDER BY name");
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        stations.add(new String[]{rs.getString("station_id"), rs.getString("name")});
      }
    }
  } catch (SQLException e) {
    message = "Error loading form data: "+e.getMessage();
    messageType = "error";
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Manage Train Schedules</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap"
        rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0 }
    html, body {
      font-family:'Roboto',sans-serif;
      background: url('TR9.jpg') no-repeat center center fixed;
      background-size:cover; min-height:100vh;
    }
    .container {
      background:#0a2540; color:#fff;
      max-width:1200px; width:95%; margin:60px auto;
      padding:32px; border-radius:8px;
      box-shadow:0 2px 12px rgba(0,0,0,0.4);
      animation:fadeIn .8s ease-out;
    }
    h1 { color:#FFC947; text-align:center; margin-bottom:24px; }
    .message {
      text-align:center; padding:10px; margin-bottom:20px;
      border-radius:5px; font-weight:500;
    }
    .message.success { background:#28a745; color:#fff; }
    .message.error   { background:#dc3545; color:#fff; }

    .form-section {
      background:rgba(0,0,0,0.3); padding:25px;
      border-radius:8px; margin-bottom:30px;
    }
    .form-section h2 {
      text-align:center; color:#FFC947; margin-bottom:20px;
    }
    .input-group { margin-bottom:15px; }
    .input-group label {
      display:block; margin-bottom:5px;
      color:rgba(255,255,255,0.8); font-size:0.9rem;
    }
    .input-group select,
    .input-group input {
      width:100%; padding:10px; font-size:1rem;
      border-radius:5px; border:1px solid rgba(255,255,255,0.3);
      background:rgba(255,255,255,0.1); color:#fff;
    }
    .input-group input::placeholder {
      color:rgba(255,255,255,0.5);
    }
    .form-buttons {
      display:flex; justify-content:center; gap:15px; margin-top:20px;
    }
    .btn {
      padding:12px 25px; border:none; border-radius:24px;
      font-weight:500; cursor:pointer;
      box-shadow:0 2px 6px rgba(0,0,0,0.3);
      transition:background .2s,transform .2s;
    }
    .btn-primary {
      background:#FFC947; color:#0A2540;
    }
    .btn-primary:hover {
      background:#f06552; transform:translateY(-2px);
    }
    .btn-secondary {
      background:#6c757d; color:#fff;
    }
    .btn-secondary:hover {
      background:#5a6268; transform:translateY(-2px);
    }

    table {
      width:100%; border-collapse:collapse;
      margin-top:20px; background:rgba(0,0,0,0.2);
      border-radius:4px; overflow:hidden;
    }
    th, td {
      padding:12px 8px; text-align:center;
      border-bottom:1px solid rgba(255,255,255,0.1);
      font-size:0.9rem;
    }
    th {
      background:rgba(0,0,0,0.6); color:#FFC947;
      text-transform:uppercase;
    }
    tr:nth-child(even){ background:rgba(255,255,255,0.05); }
    tr:nth-child(odd) { background:rgba(255,255,255,0.02); }
    .action-btn {
      padding:6px 12px; border:none; border-radius:15px;
      font-size:0.8rem; font-weight:500; cursor:pointer;
      margin:0 4px; transition:background .2s;
    }
    .action-btn.edit {
      background:#3498db; color:#fff;
    }
    .action-btn.edit:hover {
      background:#2980b9;
    }
    .action-btn.delete {
      background:#e74c3c; color:#fff;
    }
    .action-btn.delete:hover {
      background:#c0392b;
    }

    @keyframes fadeIn {
      from{ opacity:0; transform:translateY(-20px) }
      to{ opacity:1; transform:translateY(0) }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Manage Train Schedules</h1>

    <% if (message != null) { %>
      <div class="message <%=messageType%>"><%=message%></div>
    <% } %>

    <div class="form-section">
      <h2>Add / Edit Schedule</h2>
      <form action="manageSchedule" method="post">
        <input type="hidden" name="action" value="add">
        <div class="input-group">
          <label for="lineCode">Line Code:</label>
          <select name="lineCode" id="lineCode" required>
            <option value="" disabled selected>Select Line…</option>
            <option>4000</option>
            <option>4001</option>
            <option>4002</option>
            <option>4003</option>
            <option>4005</option>
          </select>
        </div>
        <div class="input-group">
          <label for="trainName">Train Name:</label>
          <select name="trainId" id="trainName" required>
            <option value="" disabled selected>Select Train…</option>
            <% for(String[] t:trainNames){ %>
              <option value="<%=t[0]%>"><%=t[1]%></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="originStation">Origin Station:</label>
          <select name="originStationId" id="originStation" required>
            <option value="" disabled selected>Select Origin…</option>
            <% for(String[] s:stations){ %>
              <option value="<%=s[0]%>"><%=s[1]%></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="destinationStation">Destination Station:</label>
          <select name="destinationStationId" id="destinationStation" required>
            <option value="" disabled selected>Select Destination…</option>
            <% for(String[] s:stations){ %>
              <option value="<%=s[0]%>"><%=s[1]%></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="departureTime">Departure Time:</label>
          <input type="datetime-local" name="departureTime" id="departureTime" required>
        </div>
        <div class="input-group">
          <label for="arrivalTime">Arrival Time:</label>
          <input type="datetime-local" name="arrivalTime" id="arrivalTime" required>
        </div>
        <div class="input-group">
          <label for="fare">Fare:</label>
          <input type="number" name="fare" id="fare" min="0" step="0.01" required>
        </div>
        <div class="form-buttons">
          <button type="submit" class="btn btn-primary">Add Schedule</button>
        </div>
      </form>
    </div>

    <h2>Existing Train Schedules</h2>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Line</th>
          <th>Train</th>
          <th>Origin</th>
          <th>Destination</th>
          <th>Departure</th>
          <th>Arrival</th>
          <th>Fare</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <%
        // display existing schedules
        try (Connection c2 = DatabaseUtils.getConnection();
             PreparedStatement p2 = c2.prepareStatement(
               "SELECT ts.id, ts.line_code, t.name AS train_name,"
             + " os.name AS origin_name, ds.name AS dest_name,"
             + " ts.departure_time, ts.arrival_time, ts.fare,"
             + " t.id AS train_id, ts.origin_station_id, ts.destination_station_id "
             + "FROM train_schedules ts "
             + "JOIN trains t ON ts.train_id = t.id "
             + "JOIN station os ON ts.origin_station_id = os.station_id "
             + "JOIN station ds ON ts.destination_station_id = ds.station_id "
             + "ORDER BY ts.departure_time DESC");
             ResultSet r2 = p2.executeQuery()) {

          DateTimeFormatter iso = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

          while (r2.next()) {
            String dep = r2.getTimestamp("departure_time")
                           .toLocalDateTime().format(iso);
            String arr = r2.getTimestamp("arrival_time")
                           .toLocalDateTime().format(iso);
      %>
        <tr>
          <td><%=r2.getInt("id")%></td>
          <td><%=r2.getInt("line_code")%></td>
          <td><%=r2.getString("train_name")%></td>
          <td><%=r2.getString("origin_name")%></td>
          <td><%=r2.getString("dest_name")%></td>
          <td><%=dep%></td>
          <td><%=arr%></td>
          <td>$<%=String.format("%.2f", r2.getDouble("fare"))%></td>
          <td>
            <button class="action-btn edit"
                    onclick="editSchedule(
                      <%=r2.getInt("id")%>,
                      <%=r2.getInt("line_code")%>,
                      <%=r2.getInt("train_id")%>,
                      <%=r2.getInt("origin_station_id")%>,
                      <%=r2.getInt("destination_station_id")%>,
                      '<%=dep%>',
                      '<%=arr%>',
                      <%=r2.getDouble("fare")%>
                    )">
              Edit
            </button>
            <form action="manageSchedule" method="post" style="display:inline">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="scheduleId" value="<%=r2.getInt("id")%>">
              <button class="action-btn delete"
                      onclick="return confirm('Delete this schedule?');">
                Delete
              </button>
            </form>
          </td>
        </tr>
      <%  }
        } catch(SQLException e) {
          out.println("<tr><td colspan='9' style='color:#dc3545;'>Error loading schedules.</td></tr>");
        }
      %>
      </tbody>
    </table>

    <script>
      function editSchedule(id, lineCode, trainId, origId, destId, depTime, arrTime, fare) {
        const form = document.querySelector('.form-section form');
        form.action = 'manageSchedule';
        form.querySelector('input[name="action"]').value = 'edit';

        // scheduleId
        let hid = form.querySelector('input[name="scheduleId"]');
        if (!hid) {
          hid = document.createElement('input');
          hid.type = 'hidden'; hid.name = 'scheduleId';
          form.appendChild(hid);
        }
        hid.value = id;

        // populate fields
        form.querySelector('#lineCode').value         = lineCode;
        form.querySelector('#trainName').value        = trainId;
        form.querySelector('#originStation').value    = origId;
        form.querySelector('#destinationStation').value= destId;
        form.querySelector('#departureTime').value    = depTime;
        form.querySelector('#arrivalTime').value      = arrTime;
        form.querySelector('#fare').value             = fare;

        let btn = form.querySelector('button[type="submit"]');
        btn.textContent = 'Update Schedule';
        btn.classList.replace('btn-primary','btn-secondary');

        // cancel-edit button
        if (!form.querySelector('.btn-cancel-edit')) {
          let c = document.createElement('button');
          c.type='button'; c.textContent='Cancel'; c.className='btn btn-secondary btn-cancel-edit';
          c.onclick = ()=>{
            form.reset();
            form.action = 'manageSchedule';
            form.querySelector('input[name="action"]').value='add';
            btn.textContent='Add Schedule';
            btn.classList.replace('btn-secondary','btn-primary');
            hid?.remove();
            c.remove();
          };
          form.querySelector('.form-buttons').appendChild(c);
        }
      }
    </script>
    <!-- Back to Dashboard -->
    <div style="text-align:center; margin-top:30px;">
      <a href="rep_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

  </div>
</body>
</html>
