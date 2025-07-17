<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    // Protect page
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    // For building links/forms
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Search Schedules</title>
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
      background: rgba(10,37,64,1);
      max-width:480px; margin:80px auto; padding:40px 32px;
      border-radius:16px; box-shadow:0 8px 32px rgba(0,0,0,0.4);
      color:#fff;
    }
    .panel h2 {
      text-align:center; margin-bottom:24px; font-weight:500;
    }
    .input-group {
      margin-bottom:24px;
    }
    .input-group label {
      display:block; color:rgba(255,255,255,0.8);
      margin-bottom:6px; font-size:14px;
    }

    /* Make the closed <select> text white */
    .input-group select {
      width:100%;
      padding:12px 0;
      background:transparent;
      border:none;
      border-bottom:2px solid rgba(255,255,255,0.6);
      color:#fff;                /* <-- selected text white */
      font-size:16px;
      appearance: none;
    }
    /* But keep the dropdown options themselves black */
    .input-group select option {
      color:#000;                /* <-- dropdown menu items black */
    }

    .input-group select:focus {
      outline:none;
      border-bottom-color:#FFC947;
    }

    /* Date field styling (white text too) */
    .input-group input[type="date"] {
      width:100%;
      padding:12px 0;
      background:transparent;
      border:none;
      border-bottom:2px solid rgba(255,255,255,0.6);
      color:#fff;                /* date text white */
      font-size:16px;
      appearance:none;
    }
    .input-group input[type="date"]::-webkit-datetime-edit {
      color:#fff;
    }
    .input-group input[type="date"]:focus {
      outline:none;
      border-bottom-color:#FFC947;
    }

    .btn-primary {
      display:block; width:100%; padding:14px;
      background:#FFC947; color:#0A2540;
      font-size:16px; font-weight:500;
      border:none; border-radius:24px;
      cursor:pointer; text-align:center;
      margin-top:8px; text-decoration:none;
    }
    .btn-primary:hover { background:#FFEA00; }

    .link-secondary {
      text-align:center; margin-top:16px;
    }
    .link-secondary a {
      color:#FFC947; text-decoration:none;
    }

    /* optional: custom dropdown arrow */
    .input-group select {
      background-image: url('data:image/svg+xml;utf8,<svg fill="%23fff" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/></svg>');
      background-repeat: no-repeat;
      background-position: right 12px center;
    }
  </style>
</head>
<body>
  <div class="panel">
    <h2>Find Your Train</h2>
    <form action="<%= ctx %>/search" method="get">
      <div class="input-group">
        <label for="origin">Origin Station</label>
        <select name="originStationID" id="origin" required>
          <option value="" disabled selected>Select origin…</option>
          <option value="4">Trenton</option>
          <option value="3">New Brunswick</option>
          <option value="1">Newark Penn</option>
          <option value="2">New York Penn</option>
        </select>
      </div>
      <div class="input-group">
        <label for="destination">Destination Station</label>
        <select name="destinationStationID" id="destination" required>
          <option value="" disabled selected>Select destination…</option>
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
      <button type="submit" class="btn-primary">Search Schedules</button>
    </form>
    <div class="link-secondary">
      <a href="<%= ctx %>/welcome.jsp">Back to Home</a>
    </div>
  </div>
</body>
</html>


