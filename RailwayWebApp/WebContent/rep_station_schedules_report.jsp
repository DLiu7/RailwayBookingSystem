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

    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");

    // Data for dropdowns (Stations)
    List<String[]> stations = new ArrayList<>(); // Store as [id, name]

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DatabaseUtils.getConnection();

        // Fetch stations for dropdown
        ps = conn.prepareStatement("SELECT station_id, name FROM station ORDER BY name");
        rs = ps.executeQuery();
        while (rs.next()) {
            stations.add(new String[]{String.valueOf(rs.getInt("station_id")), rs.getString("name")});
        }
    } catch (SQLException e) {
        e.printStackTrace();
        message = "Error loading stations: " + e.getMessage();
        messageType = "error";
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Report results (if available from servlet)
    List<List<String>> schedules = (List<List<String>>) request.getAttribute("schedules");
    String selectedStationName = (String) request.getAttribute("selectedStationName");
    String searchType = (String) request.getAttribute("searchType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Train Schedules Report</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Roboto', sans-serif;
      background: url('TR7.jpg') no-repeat center center fixed; /* New background image */
      background-size: cover;
    }

    .container {
      background: #0a2540;
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.4);
      width: 95%;
      max-width: 1000px; /* Wider for reports */
      padding: 32px;
      margin: 20px auto;
      display: flex;
      flex-direction: column;
      min-height: calc(100vh - 40px);
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
    .input-group select option {
        background: #0a2540;
        color: #fff;
    }
    .input-group input[type="radio"] {
        margin-right: 5px;
    }
    .input-group .radio-group label {
        display: inline-block;
        margin-right: 15px;
    }

    .btn {
        padding: 10px 20px;
        border-radius: 20px;
        text-decoration: none;
        font-weight: 500;
        box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        transition: background .2s, transform .2s;
        cursor: pointer;
        border: none;
        color: #0A2540;
        background: #FFC947;
    }
    .btn:hover {
        background: #f06552;
        transform: translateY(-2px);
    }
    .btn-secondary {
        background: #6c757d;
        color: #fff;
    }
    .btn-secondary:hover {
        background: #5a6268;
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

    @keyframes fadeIn {
      from { opacity:0; transform: translateY(-20px); }
      to   { opacity:1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Train Schedules Report</h1>

    <% if (message != null) { %>
      <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="form-section">
      <h2>Search Schedules by Station</h2>
      <form action="repReports" method="get">
        <input type="hidden" name="reportType" value="stationSchedules">
        <div class="input-group">
          <label for="stationSelect">Select Station:</label>
          <select name="stationId" id="stationSelect" required>
            <option value="" disabled selected>Select a Station...</option>
            <% for (String[] station : stations) { %>
              <option value="<%= station[0] %>" <%= (selectedStationName != null && selectedStationName.equals(station[1])) ? "selected" : "" %>>
                <%= station[1] %>
              </option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
            <label>Search as:</label>
            <div class="radio-group">
                <label><input type="radio" name="searchType" value="origin" <%= "origin".equals(searchType) ? "checked" : "" %> required> Origin</label>
                <label><input type="radio" name="searchType" value="destination" <%= "destination".equals(searchType) ? "checked" : "" %>> Destination</label>
            </div>
        </div>
        <button type="submit" class="btn">Generate Report</button>
      </form>
    </div>

    <% if (schedules != null) { %>
      <h2>Schedules for <%= selectedStationName %> as <%= searchType != null ? searchType : "" %></h2>
      <% if (schedules.isEmpty()) { %>
        <p style="text-align: center; color: rgba(255,255,255,0.7);">No schedules found for the selected station and type.</p>
      <% } else { %>
        <table>
          <thead>
            <tr>
              <th>Train</th>
              <th>Origin</th>
              <th>Destination</th>
              <th>Departure Time</th>
              <th>Arrival Time</th>
              <th>Fare</th>
            </tr>
          </thead>
          <tbody>
            <% for (List<String> schedule : schedules) { %>
              <tr>
                <td><%= schedule.get(0) %></td> <%-- Train Name --%>
                <td><%= schedule.get(1) %></td> <%-- Origin Station Name --%>
                <td><%= schedule.get(2) %></td> <%-- Destination Station Name --%>
                <td><%= schedule.get(3) %></td> <%-- Departure Time --%>
                <td><%= schedule.get(4) %></td> <%-- Arrival Time --%>
                <td>$<%= schedule.get(5) %></td> <%-- Fare --%>
              </tr>
            <% } %>
          </tbody>
        </table>
      <% } %>
    <% } %>

    <a href="welcome.jsp" class="btn btn-secondary" style="margin-top: 30px;">Back to Dashboard</a>
  </div>
</body>
</html>
