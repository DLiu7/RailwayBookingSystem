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

    // Data for dropdowns (Transit Lines)
    List<String> transitLines = new ArrayList<>();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DatabaseUtils.getConnection();

        // Fetch transit line names for dropdown
        ps = conn.prepareStatement("SELECT line_name FROM transitline ORDER BY line_name");
        rs = ps.executeQuery();
        while (rs.next()) {
            transitLines.add(rs.getString("line_name"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
        message = "Error loading transit lines: " + e.getMessage();
        messageType = "error";
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Report results (if available from servlet)
    List<List<String>> customersWithReservations = (List<List<String>>) request.getAttribute("customersWithReservations");
    String selectedLineName = (String) request.getAttribute("selectedLineName");
    String selectedDate = (String) request.getAttribute("selectedDate");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Reservations Report</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Roboto', sans-serif;
      background: url('TR8.jpg') no-repeat center center fixed; /* New background image */
      background-size: cover;
    }

    .container {
      background: #0a2540;
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.4);
      width: 95%;
      max-width: 900px; /* Standard width */
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
    .input-group select,
    .input-group input[type="date"] {
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
    .input-group input::placeholder {
        color: rgba(255,255,255,0.5);
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
    <h1>Customer Reservations Report</h1>

    <% if (message != null) { %>
      <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="form-section">
      <h2>Search Reservations by Transit Line and Date</h2>
      <form action="repReports" method="get">
        <input type="hidden" name="reportType" value="customerReservations">
        <div class="input-group">
          <label for="lineSelect">Select Transit Line:</label>
          <select name="lineName" id="lineSelect" required>
            <option value="" disabled selected>Select a Transit Line...</option>
            <% for (String line : transitLines) { %>
              <option value="<%= line %>" <%= (selectedLineName != null && selectedLineName.equals(line)) ? "selected" : "" %>>
                <%= line %>
              </option>
            <% } %>
          </select>
        </div>
        <div class="input-group">
          <label for="travelDate">Select Travel Date:</label>
          <input type="date" name="travelDate" id="travelDate" value="<%= selectedDate != null ? selectedDate : "" %>" required>
        </div>
        <button type="submit" class="btn">Generate Report</button>
      </form>
    </div>

    <% if (customersWithReservations != null) { %>
      <h2>Customers with Reservations on Line "<%= selectedLineName %>" for <%= selectedDate %></h2>
      <% if (customersWithReservations.isEmpty()) { %>
        <p style="text-align: center; color: rgba(255,255,255,0.7);">No customers found with reservations for the selected criteria.</p>
      <% } else { %>
        <table>
          <thead>
            <tr>
              <th>Customer Username</th>
              <th>Train</th>
              <th>Travel Date</th>
              <th>Departure Time</th>
              <th>Origin Station</th>
              <th>Destination Station</th>
              <th>Seat ID</th>
              <th>Passenger Type</th>
              <th>Trip Type</th>
            </tr>
          </thead>
          <tbody>
            <% for (List<String> reservation : customersWithReservations) { %>
              <tr>
                <td><%= reservation.get(0) %></td> <%-- Customer Username --%>
                <td><%= reservation.get(1) %></td> <%-- Train --%>
                <td><%= reservation.get(2) %></td> <%-- Travel Date --%>
                <td><%= reservation.get(3) %></td> <%-- Departure Time --%>
                <td><%= reservation.get(4) %></td> <%-- Origin Station Name --%>
                <td><%= reservation.get(5) %></td> <%-- Destination Station Name --%>
                <td><%= reservation.get(6) %></td> <%-- Seat ID --%>
                <td><%= reservation.get(7) %></td> <%-- Passenger Type --%>
                <td><%= reservation.get(8) %></td> <%-- Trip Type --%>
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
