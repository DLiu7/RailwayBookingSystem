<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect if not logged in
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String user = (String) session.getAttribute("user");
    String ctx  = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Welcome</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height: 100%;
      font-family: 'Roboto', sans-serif;
      background: url('Train1.jpg') no-repeat center center fixed;
      background-size: cover;
    }
    /* Container for both cards */
    .cards-container {
      display: flex;
      gap: 32px;
      max-width: 1200px;
      margin: 40px auto;
      align-items: flex-start;
      justify-content: center;
      padding: 0 16px;
    }

    /* Shared card styles */
    .card {
      background: #0a2540;
      color: #fff;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.4);
      padding: 32px;
      flex: 1;
      display: flex;
      flex-direction: column;
      max-width: 500px;
    }
    @keyframes fadeInCard {
      from { opacity: 0; transform: translateY(-20px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .card { animation: fadeInCard 0.8s ease-out; }

    /* Left (welcome) card */
    .welcome-card h1 {
      font-size: 1.75rem;
      font-weight: 500;
      text-align: center;
      margin-bottom: 8px;
    }
    .welcome-card p {
      color: #e0e0e0;
      text-align: center;
      margin-bottom: 24px;
      flex-shrink: 0;
    }
    .button-row {
      display: flex;
      flex-direction: column;
      flex: 1;                   /* take all remaining vertical space */
      justify-content: space-around; /* evenly space the buttons */
      gap: 12px;
      margin-bottom: 0;
    }
    .btn-logout {
      display: inline-block;
      padding: 12px 28px;
      background: #FFC947;
      color: #0A2540;
      text-decoration: none;
      border-radius: 24px;
      font-weight: 500;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
      text-align: center;
      border: none;
      cursor: pointer;
      width: 100%;
    }
    .btn-logout:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }

    /* Right (search) card */
    .search-card h2 {
      font-size: 1.5rem;
      font-weight: 500;
      text-align: center;
      margin-bottom: 24px;
    }
    .search-form {
      display: flex;
      flex-direction: column;
      gap: 16px;
      flex-shrink: 0;
    }
    .search-form .input-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .search-form .input-group label {
      font-size: 14px;
      color: rgba(255,255,255,0.8);
    }
    .search-form .input-group select,
    .search-form .input-group input[type="date"] {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 8px;
      background: rgba(255,255,255,0.15);
      color: #fff;
      font-size: 16px;
      transition: background .3s;
    }
    .search-form .input-group select option {
      color: #000;
      background: #fff;
    }
    .search-form .input-group select:focus,
    .search-form .input-group input[type="date"]:focus {
      background: rgba(255,255,255,0.3);
      outline: none;
    }
    .btn-search {
      width: 100%;
      padding: 12px;
      background: #FFC947;
      color: #0A2540;
      border: none;
      border-radius: 24px;
      font-size: 16px;
      font-weight: 500;
      cursor: pointer;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: background .2s;
    }
    .btn-search:hover {
      background: #FFEA00;
    }
  </style>
</head>
<body>
  <div class="cards-container">
    <!-- Welcome / Actions Card -->
    <div class="card welcome-card">
      <h1>Hey, <%= user %>!</h1>
      <p>You have successfully logged in.</p>
      <div class="button-row">
        <a href="<%= ctx %>/bookings.jsp"    class="btn-logout">View My Bookings</a>
        <a href="<%= ctx %>/reservation.jsp" class="btn-logout">Make Reservation</a>
        <a href="<%= ctx %>/customer_service_forum.jsp" class="btn-logout">Customer Service Forum</a>
        <a href="<%= ctx %>/logout"          class="btn-logout">Log Out</a>
      </div>
    </div>

    <!-- Search Schedules Card -->
    <div class="card search-card">
      <h2>Search Train Schedules</h2>
      <form class="search-form" action="<%= ctx %>/search" method="get">
        <div class="input-group">
          <label for="origin">Origin Station</label>
          <select name="originStationID" id="origin" required>
            <option value="">Select origin…</option>
            <option value="4">Trenton</option>
            <option value="3">New Brunswick</option>
            <option value="1">Newark Penn</option>
            <option value="2">New York Penn</option>
          </select>
        </div>
        <div class="input-group">
          <label for="destination">Destination Station</label>
          <select name="destinationStationID" id="destination" required>
            <option value="">Select destination…</option>
            <option value="4">Trenton</option>
            <option value="3">New Brunswick</option>
            <option value="1">Newark Penn</option>
            <option value="2">New York Penn</option>
          </select>
        </div>
        <div class="input-group">
          <label for="date">Date of Travel</label>
          <input type="date" name="travelDate" id="date" required>
        </div>
        <button type="submit" class="btn-search">Search Schedules</button>
      </form>
    </div>
  </div>
</body>
</html>




