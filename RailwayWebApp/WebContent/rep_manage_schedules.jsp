<%@ page import="java.sql.*, java.util.List, java.util.ArrayList, com.example.login.DatabaseUtils" %>
<%@ page import="java.time.LocalDateTime, java.time.format.DateTimeFormatter, java.time.ZoneId" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // Protect page - only accessible by Customer Reps or Admin
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String userRole = (String) session.getAttribute("role");
    if (!"admin".equalsIgnoreCase(userRole) && !"customer_representative".equalsIgnoreCase(userRole)) {
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
      background: url('TR9.jpg') no-repeat center center fixed;
      background-size: cover;
      min-height: 100vh;
    }

    .container {
      background: #0a2540;
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.4);
      width: 95%;
      max-width: 1200px;
      padding: 32px;
      margin: 60px auto;
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
      background-color: #28a745;
      color: white;
    }
    .message.error {
      background-color: #dc3545;
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
        appearance: none;
    }
    .input-group input::placeholder {
        color: rgba(255,255,255,0.5);
    }
    .input-group select option {
        background: #0a2540;
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
        background: #FFC947;
    }
    .btn-primary:hover {
        background: #f06552;
        transform: translateY(-2px);
    }
    .btn-secondary {
        background: #6c757d;
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
      font-size: 0.9rem;
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
        background: #3498db;
        color: white;
    }
    .action-btn.edit:hover {
        background: #2980b9;
    }
    .action-btn.delete {
        background: #e74c3c;
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
          <select name="trainId" id="trainName" required>
            <option value="" disabled selected>Select Train...</option>
            <% for (String[] train : trainNames) { %>
              <option value="<%= train[0] %>"><%= train[1] %></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="originStation">Origin Station:</label>
          <select name="originStationId" id="originStation" required>
            <option value="" disabled selected>Select Origin Station...</option>
            <% for (String[] station : stations) { %>
              <option value="<%= station[0] %>"><%= station[1] %></option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="destinationStation">Destination Station:</label>
          <select name="destinationStationId" id="destinationStation" required>
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
          conn = null; // Re-initialize to ensure fresh connection/resources
          ps = null;
          rs = null;
          try {
              conn = DatabaseUtils.getConnection();
              String sql = "SELECT ts.id, t.name AS train_name, os.name AS origin_station_name, " +
                           "ds.name AS destination_station_name, ts.departure_time, ts.arrival_time, ts.fare, " +
                           "t.id AS train_id, os.station_id AS origin_station_id, ds.station_id AS destination_station_id " +
                           "FROM train_schedules ts " +
                           "JOIN trains t ON ts.train_id = t.id " +
                           "JOIN station os ON ts.origin_station_id = os.station_id " +
                           "JOIN station ds ON ts.destination_station_id = ds.station_id " +
                           "ORDER BY ts.departure_time DESC";

              ps = conn.prepareStatement(sql);
              rs = ps.executeQuery();

              DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

              if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                  out.println("<tr><td colspan='8'>No train schedules found.</td></tr>");
              } else {
                  while (rs.next()) {
                      String formattedDepartureTime = rs.getTimestamp("departure_time")
                                                         .toLocalDateTime()
                                                         .format(formatter);
                      String formattedArrivalTime = rs.getTimestamp("arrival_time")
                                                       .toLocalDateTime()
                                                       .format(formatter);
        %>
            <tr>
              <td><%= rs.getInt("id") %></td>
              <td><%= rs.getString("train_name") %></td>
              <td><%= rs.getString("origin_station_name") %></td>
              <td><%= rs.getString("destination_station_name") %></td>
              <td><%= rs.getTimestamp("departure_time") %></td> <%-- Displaying full timestamp string --%>
              <td><%= rs.getTimestamp("arrival_time") %></td>   <%-- Displaying full timestamp string --%>
              <td>$<%= String.format("%.2f", rs.getDouble("fare")) %></td>
              <td>
                <button type="button" class="action-btn edit"
                        onclick="editSchedule(
                            <%= rs.getInt("id") %>,
                            <%= rs.getInt("train_id") %>,
                            <%= rs.getInt("origin_station_id") %>,
                            <%= rs.getInt("destination_station_id") %>,
                            '<%= formattedDepartureTime %>', <%-- Pass formatted time for datetime-local input --%>
                            '<%= formattedArrivalTime %>',   <%-- Pass formatted time for datetime-local input --%>
                            <%= rs.getDouble("fare") %>
                        )">Edit</button>
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
              // --- COMPLETED FINALLY BLOCK ---
              try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
              try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
              try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
          }
        %>
      </tbody>
    </table>

    <script>
      // Function to populate the form for editing
      function editSchedule(id, trainId, originStationId, destinationStationId, departureTime, arrivalTime, fare) {
          // Change form action to edit
          const form = document.querySelector('.form-section form');
          form.action = "manageSchedule";
          form.querySelector('input[name="action"]').value = "edit";

          // Add hidden input for schedule ID
          let scheduleIdInput = form.querySelector('input[name="scheduleId"]');
          if (!scheduleIdInput) {
              scheduleIdInput = document.createElement('input');
              scheduleIdInput.type = 'hidden';
              scheduleIdInput.name = 'scheduleId';
              form.appendChild(scheduleIdInput);
          }
          scheduleIdInput.value = id;

          // Populate fields
          document.getElementById('trainName').value = trainId;
          document.getElementById('originStation').value = originStationId;
          document.getElementById('destinationStation').value = destinationStationId;
          document.getElementById('departureTime').value = departureTime;
          document.getElementById('arrivalTime').value = arrivalTime;
          document.getElementById('fare').value = fare;

          // Change button text
          const submitBtn = form.querySelector('button[type="submit"]');
          submitBtn.textContent = "Update Schedule";
          submitBtn.classList.remove('btn-primary');
          submitBtn.classList.add('btn-secondary'); // Change color to indicate update mode

          // Add a "Cancel Edit" button if it doesn't exist
          let cancelBtn = form.querySelector('.btn-cancel-edit');
          if (!cancelBtn) {
              cancelBtn = document.createElement('button');
              cancelBtn.type = 'button';
              cancelBtn.textContent = 'Cancel Edit';
              cancelBtn.className = 'btn btn-secondary btn-cancel-edit';
              cancelBtn.onclick = resetForm;
              form.querySelector('.form-buttons').appendChild(cancelBtn);
          }
      }

      // Function to reset the form to "Add New" mode
      function resetForm() {
          const form = document.querySelector('.form-section form');
          form.action = "manageSchedule";
          form.querySelector('input[name="action"]').value = "add";

          // Clear scheduleId hidden input
          const scheduleIdInput = form.querySelector('input[name="scheduleId"]');
          if (scheduleIdInput) {
              form.removeChild(scheduleIdInput);
          }

          // Reset form fields
          form.reset(); // Resets all form elements to their initial values
          // Explicitly reset selects as form.reset() might not clear them reliably for 'selected' attribute
          document.getElementById('trainName').value = "";
          document.getElementById('originStation').value = "";
          document.getElementById('destinationStation').value = "";

          // Reset button text
          const submitBtn = form.querySelector('button[type="submit"]');
          submitBtn.textContent = "Add Schedule";
          submitBtn.classList.remove('btn-secondary');
          submitBtn.classList.add('btn-primary');

          // Remove "Cancel Edit" button
          const cancelBtn = form.querySelector('.btn-cancel-edit');
          if (cancelBtn) {
              cancelBtn.remove();
          }
      }
    </script>

    <a href="rep_dashboard.jsp" class="btn btn-secondary" style="margin-top: 30px;">Back to Dashboard</a>
  </div>
</body>
</html>