<%@ page import="java.sql.*, java.util.List, java.util.ArrayList, com.example.login.DatabaseUtils" contentType="text/html; charset=UTF-8" %>
<%
    // Protect page - only accessible by Customer Reps or Admin
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String userRole = (String) session.getAttribute("role");
    if (!"admin".equalsIgnoreCase(userRole) && !"customer_rep".equalsIgnoreCase(userRole)) {
        response.sendRedirect("welcome.jsp"); // Redirect if not authorized
        return;
    }

    // Message for success/error (e.g., after add/edit/delete operation)
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType"); // "success" or "error"

    // Data for dropdowns (Trains and Stations)
    List<String[]> trainNames = new ArrayList<>(); // Store as [id, name]
    List<String[]> stations = new ArrayList<>(); // Store as [id, name]

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DatabaseUtils.getConnection();

        // Fetch train names for dropdown
        ps = conn.prepareStatement("SELECT id, name FROM trains ORDER BY name");
        rs = ps.executeQuery();
        while (rs.next()) {
            trainNames.add(new String[]{String.valueOf(rs.getInt("id")), rs.getString("name")});
        }
        rs.close();
        ps.close();

        // Fetch stations for dropdown (using 'station' table)
        ps = conn.prepareStatement("SELECT station_id, name FROM station ORDER BY name");
        rs = ps.executeQuery();
        while (rs.next()) {
            stations.add(new String[]{String.valueOf(rs.getInt("station_id")), rs.getString("name")});
        }
        rs.close();
        ps.close();

    } catch (SQLException e) {
        e.printStackTrace();
        message = "Error loading data for forms: " + e.getMessage();
        messageType = "error";
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Train Schedules</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Roboto', sans-serif;
      background: url('TR9.jpg') no-repeat center center fixed; /* New background image */
      background-size: cover;
      /* Removed display: flex, align-items, justify-content for vertical flow */
      min-height: 100vh; /* Ensure body covers full viewport height */
    }

    .container {
      background: #0a2540;
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.4);
      width: 95%; /* Make it wider for more content */
      max-width: 1200px; /* Max width for large screens */
      padding: 32px;
      margin: 60px auto; /* Increased top/bottom margin from 40px to 60px */
      display: flex;
      flex-direction: column;
      animation: fadeIn 0.8s ease-out;
    }

    h1 {
      font-size: 1.75rem;
      margin-bottom: 24px;
      text-align: center;
      color: #FFC947;
    }

    .message {
      padding: 10px;
      margin-bottom: 20px;
      border-radius: 5px;
      text-align: center;
      font-weight: 500;
    }
    .message.success {
      background-color: #28a745; /* Green */
      color: white;
    }
    .message.error {
      background-color: #dc3545; /* Red */
      color: white;
    }

    /* Form Styling */
    .form-section {
        background: rgba(0,0,0,0.3);
        padding: 25px;
        border-radius: 8px;
        margin-bottom: 30px;
    }
    .form-section h2 {
        font-size: 1.4rem;
        margin-bottom: 20px;
        color: #FFC947;
        text-align: center;
    }
    .input-group {
        margin-bottom: 15px;
    }
    .input-group label {
        display: block;
        margin-bottom: 5px;
        font-size: 0.9rem;
        color: rgba(255,255,255,0.8);
    }
    .input-group input[type="text"],
    .input-group input[type="datetime-local"],
    .input-group input[type="number"],
    .input-group select {
        width: 100%;
        padding: 10px;
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 5px;
        background: rgba(255,255,255,0.1);
        color: #fff;
        font-size: 1rem;
        appearance: none; /* Remove default select arrow */
    }
    .input-group input::placeholder {
        color: rgba(255,255,255,0.5);
    }
    .input-group select option {
        background: #0a2540; /* Dark background for dropdown options */
        color: #fff;
    }
    .form-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 20px;
    }
    .btn {
        padding: 12px 25px;
        border-radius: 24px;
        text-decoration: none;
        font-weight: 500;
        box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        transition: background .2s, transform .2s;
        cursor: pointer;
        border: none;
        color: #0A2540;
    }
    .btn-primary {
        background: #FFC947; /* Yellow */
    }
    .btn-primary:hover {
        background: #f06552;
        transform: translateY(-2px);
    }
    .btn-secondary {
        background: #6c757d; /* Gray */
        color: #fff;
    }
    .btn-secondary:hover {
        background: #5a6268;
        transform: translateY(-2px);
    }

    /* Table Styling */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 32px;
      background: rgba(0,0,0,0.2);
      border-radius: 4px;
      overflow: hidden;
    }

    th, td {
      padding: 12px 8px;
      font-size: 0.9rem; /* Slightly smaller font for table */
      text-align: center;
      border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    th {
      background: rgba(0,0,0,0.6);
      text-transform: uppercase;
      font-weight: 500;
      color: #FFC947;
    }

    tr:nth-child(even) {
      background: rgba(255,255,255,0.05);
    }
    tr:not(:nth-child(even)) {
      background: rgba(255,255,255,0.02);
    }
    td .action-btn {
        padding: 6px 12px;
        border-radius: 15px;
        font-size: 0.8rem;
        font-weight: 500;
        text-decoration: none;
        margin: 0 4px;
        transition: background .2s;
        border: none;
        cursor: pointer;
    }
    .action-btn.edit {
        background: #3498db; /* Blue */
        color: white;
    }
    .action-btn.edit:hover {
        background: #2980b9;
    }
    .action-btn.delete {
        background: #e74c3c; /* Red */
        color: white;
    }
    .action-btn.delete:hover {
        background: #c0392b;
    }

    @keyframes fadeIn {
      from { opacity:0; transform: translateY(-20px); }
      to   { opacity:1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Manage Train Schedules</h1>

    <% if (message != null) { %>
      <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="form-section">
      <h2>Add New Schedule</h2>
      <form action="manageSchedule" method="post">
        <input type="hidden" name="action" value="add">
        <div class="input-group">
          <label for="trainName">Train Name:</label>
          <select name="trainName" id="trainName" required>
            <option value="" disabled selected>Select Train...</option>
            <% for (String[] train : trainNames) { %>
              <option value="<%= train[1] %>"><%= train[1] %></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="originStation">Origin Station:</label>
          <select name="originStation" id="originStation" required>
            <option value="" disabled selected>Select Origin Station...</option>
            <% for (String[] station : stations) { %>
              <option value="<%= station[0] %>"><%= station[1] %></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="destinationStation">Destination Station:</label>
          <select name="destinationStation" id="destinationStation" required>
            <option value="" disabled selected>Select Destination Station...</option>
            <% for (String[] station : stations) { %>
              <option value="<%= station[0] %>"><%= station[1] %></option>
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
          <input type="number" name="fare" id="fare" step="0.01" min="0" required>
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
          // Fetch and display existing schedules
          conn = null;
          ps = null;
          rs = null;
          try {
              conn = DatabaseUtils.getConnection();
              String sql = "SELECT ts.id, t.name AS train_name, os.name AS origin_station_name, " +
                           "ds.name AS destination_station_name, ts.departure_time, ts.arrival_time, ts.fare " +
                           "FROM train_schedules ts " +
                           "JOIN trains t ON ts.train_id = t.id " +
                           "JOIN station os ON ts.origin_station_id = os.station_id " +
                           "JOIN station ds ON ts.destination_station_id = ds.station_id " +
                           "ORDER BY ts.departure_time DESC"; // Order by most recent first

              ps = conn.prepareStatement(sql);
              rs = ps.executeQuery();

              if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                  out.println("<tr><td colspan='8'>No train schedules found.</td></tr>");
              } else {
                  while (rs.next()) {
        %>
            <tr>
              <td><%= rs.getInt("id") %></td>
              <td><%= rs.getString("train_name") %></td>
              <td><%= rs.getString("origin_station_name") %></td>
              <td><%= rs.getString("destination_station_name") %></td>
              <td><%= rs.getTimestamp("departure_time") %></td>
              <td><%= rs.getTimestamp("arrival_time") %></td>
              <td>$<%= String.format("%.2f", rs.getDouble("fare")) %></td>
              <td>
                <!-- Edit button (will populate form for editing) -->
                <button type="button" class="action-btn edit"
                        onclick="editSchedule(
                            <%= rs.getInt("id") %>,
                            '<%= rs.getString("train_name") %>',
                            '<%= rs.getString("origin_station_name") %>',
                            '<%= rs.getString("destination_station_name") %>',
                            '<%= rs.getTimestamp("departure_time").toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime().toString().substring(0, 16) %>',
                            '<%= rs.getTimestamp("arrival_time").toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime().toString().substring(0, 16) %>',
                            <%= rs.getDouble("fare") %>
                        )">Edit</button>
                <!-- Delete button (submits form with delete action) -->
                <form action="manageSchedule" method="post" style="display:inline-block;">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="scheduleId" value="<%= rs.getInt("id") %>">
                  <button type="submit" class="action-btn delete" onclick="return confirm('Are you sure you want to delete this schedule?');">Delete</button>
                </form>
              </td>
            </tr>
        <%
                  }
              }
          } catch (SQLException e) {
              e.printStackTrace();
              out.println("<p style='color:#dc3545;text-align:center;'>Error loading schedules: " + e.getMessage() + "</p>");
          } finally {
              try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
              try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
              try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
          }
        %>
      </tbody>
    </table>

    <div class="form-section" id="editScheduleForm" style="display:none;">
      <h2>Edit Schedule</h2>
      <form action="manageSchedule" method="post">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="scheduleId" id="editScheduleId">
        <div class="input-group">
          <label for="editTrainName">Train Name:</label>
          <select name="trainName" id="editTrainName" required>
            <% for (String[] train : trainNames) { %>
              <option value="<%= train[1] %>"><%= train[1] %></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="editOriginStation">Origin Station:</label>
          <select name="originStation" id="editOriginStation" required>
            <% for (String[] station : stations) { %>
              <option value="<%= station[0] %>"><%= station[1] %></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="editDestinationStation">Destination Station:</label>
          <select name="destinationStation" id="editDestinationStation" required>
            <% for (String[] station : stations) { %>
              <option value="<%= station[0] %>"><%= station[1] %></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="editDepartureTime">Departure Time:</label>
          <input type="datetime-local" name="departureTime" id="editDepartureTime" required>
        </div>
        <div class="input-group">
          <label for="editArrivalTime">Arrival Time:</label>
          <input type="datetime-local" name="arrivalTime" id="editArrivalTime" required>
        </div>
        <div class="input-group">
          <label for="editFare">Fare:</label>
          <input type="number" name="fare" id="editFare" step="0.01" min="0" required>
        </div>
        <div class="form-buttons">
          <button type="submit" class="btn btn-primary">Update Schedule</button>
          <button type="button" class="btn btn-secondary" onclick="document.getElementById('editScheduleForm').style.display='none';">Cancel Edit</button>
        </div>
      </form>
    </div>

    <a href="welcome.jsp" class="btn btn-secondary" style="margin-top: 30px;">Back to Dashboard</a>
  </div>

  <script>
    function editSchedule(id, trainName, originStationName, destinationStationName, departureTime, arrivalTime, fare) {
        document.getElementById('editScheduleForm').style.display = 'block';
        document.getElementById('editScheduleId').value = id;

        // Set train name
        const editTrainSelect = document.getElementById('editTrainName');
        for (let i = 0; i < editTrainSelect.options.length; i++) {
            if (editTrainSelect.options[i].text === trainName) {
                editTrainSelect.selectedIndex = i;
                break;
            }
        }

        // Set origin station
        const editOriginSelect = document.getElementById('editOriginStation');
        for (let i = 0; i < editOriginSelect.options.length; i++) {
            if (editOriginSelect.options[i].text === originStationName) {
                editOriginSelect.selectedIndex = i;
                break;
            }
        }

        // Set destination station
        const editDestinationSelect = document.getElementById('editDestinationStation');
        for (let i = 0; i < editDestinationSelect.options.length; i++) {
            if (editDestinationSelect.options[i].text === destinationStationName) {
                editDestinationSelect.selectedIndex = i;
                break;
            }
        }

        document.getElementById('editDepartureTime').value = departureTime;
        document.getElementById('editArrivalTime').value = arrivalTime;
        document.getElementById('editFare').value = fare;

        // Scroll to the edit form
        document.getElementById('editScheduleForm').scrollIntoView({ behavior: 'smooth' });
    }
  </script>
</body>
</html>
