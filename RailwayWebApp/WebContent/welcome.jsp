<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // Redirect if not logged in
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String user = (String) session.getAttribute("user");
    // Retrieve user role from session. IMPORTANT: Your LoginServlet must set this attribute.
    String userRole = (String) session.getAttribute("role");
    if (userRole == null) {
        // Default to 'customer' if role is not set (e.g., for existing sessions before role implementation)
        userRole = "customer";
    }

    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
    boolean isCustomerRep = "customer_rep".equalsIgnoreCase(userRole);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
     html, body {
  height: 100%;
  margin: 0;
  padding: 0;
  font-family: 'Roboto', sans-serif;

  /* full-screen, non-repeating train background */
  background: url('Train1.jpg') no-repeat center center fixed;
  background-size: cover;

  /* flex-center any .*-card */
  display: flex;
  align-items: center;
  justify-content: center;
}

    .welcome-card {
      background: #0a2540;               /* dark navy */
      color: #fff;                       /* white text */
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.4);
      padding: 40px 32px;
      width: 460px;
      text-align: center;
      animation: fadeInCard 0.8s ease-out;
    }

    .welcome-card h1 {
      font-size: 1.75rem;
      font-weight: 500;
      margin-bottom: 16px;
    }
    .welcome-card p {
      color: #e0e0e0;
      margin-bottom: 24px;
    }

    .button-row {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    /* Unified button style for common actions */
    .btn-common {
      display: inline-block;
      padding: 12px 28px;
      background: #FFC947; /* Yellow */
      color: #0A2540;
      text-decoration: none;
      border-radius: 24px;
      font-weight: 500;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
      margin: 8px; /* Added margin for consistent spacing */
    }
    .btn-common:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }

    /* Specific style for logout button, can be same as common or distinct */
    .btn-logout {
      display: inline-block;
      padding: 12px 28px;
      background: #FFC947; /* Yellow */
      color: #0A2540;
      text-decoration: none;
      border-radius: 24px;
      font-weight: 500;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
      margin: 8px;
    }
    .btn-logout:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }

    /* Style for the search form (if you decide to add it back later) */
    .search-section {
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid rgba(255,255,255,0.2);
        text-align: left;
    }

    .search-section h2 {
        font-size: 1.25rem;
        font-weight: 500;
        margin-bottom: 15px;
        color: #FFC947; /* Yellow heading */
    }

    .input-group {
        margin-bottom: 15px;
        position: relative;
    }

    .input-group label {
        display: block;
        color: rgba(255,255,255,0.8);
        margin-bottom: 5px;
        font-size: 14px;
    }

    .input-group input[type="text"],
    .input-group input[type="date"] {
        width: 100%;
        padding: 10px;
        border: none;
        border-radius: 8px;
        background: rgba(255,255,255,0.15);
        color: #fff;
        font-size: 16px;
        transition: background .3s;
    }

    .input-group input[type="text"]:focus,
    .input-group input[type="date"]:focus {
        background: rgba(255,255,255,0.3);
        outline: none;
    }

    .search-button {
        width: 100%;
        padding: 12px;
        background: #FFC947;
        border: none;
        border-radius: 24px;
        color: #0A2540;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        box-shadow: 0 4px 16px rgba(0,0,0,0.2);
        transition: transform .2s, box-shadow .2s;
    }
    .search-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }

    @keyframes fadeInCard {
      from { opacity: 0; transform: translateY(-20px); }
      to   { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="welcome-card">
    <h1>Hey, <%= user %>!</h1>
    <p>You have successfully logged in as a <%= userRole %>.</p>
    <div class="button-row">
    <a href="bookings.jsp"    class="btn-common">View My Bookings</a>
    <a href="reservation.jsp" class="btn-common">Make Reservation</a>
    
    <a href="customer_service_forum.jsp" class="btn-common" style="background: #9b59b6;">Customer Service Forum</a>

    <% if (isCustomerRep || isAdmin) { %> <%-- Admins can also access these reports --%>
    	<a href="rep_manage_schedules.jsp" class="btn-common" style="background: #3498db;">Manage Train Schedules</a>
        <a href="rep_station_schedules_report.jsp" class="btn-common" style="background: #3498db;">Train Schedules Report</a>
        <a href="rep_customer_reservations_report.jsp" class="btn-common" style="background: #1abc9c;">Customer Reservations Report</a>
    <% } %>

    <a href="logout" class="btn-logout">Log Out</a>
  </div>
</body>
</html>
