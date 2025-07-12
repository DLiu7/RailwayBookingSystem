<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // Protect page - only accessible by Customer Reps or Admin
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String user = (String) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");

    // If not admin or customer_rep, redirect to welcome.jsp (or login2.jsp if preferred)
    if (!"admin".equalsIgnoreCase(userRole) && !"customer_representative".equalsIgnoreCase(userRole)) {
        response.sendRedirect("welcome.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Representative Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Roboto', sans-serif;

      /* full-screen, non-repeating train background - consistent with welcome.jsp */
      background: url('Train1.jpg') no-repeat center center fixed;
      background-size: cover;

      /* flex-center any .*-card - consistent with welcome.jsp */
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .dashboard-card { /* Renamed from .welcome-card for clarity, but same core styles */
      background: #0a2540;               /* dark navy */
      color: #fff;                       /* white text */
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.4);
      padding: 40px 32px;
      width: 480px; /* Kept wider for grid layout, as per previous design */
      text-align: center;
      animation: fadeInCard 0.8s ease-out;
    }

    .dashboard-card h1 {
      font-size: 1.75rem;
      font-weight: 500;
      margin-bottom: 16px;
      color: #FFC947; /* Yellow heading - consistent with welcome.jsp */
    }
    .dashboard-card p {
      color: #e0e0e0;
      margin-bottom: 24px;
    }

    .button-grid { /* Uses grid for better button layout on dashboard */
      display: grid;
      grid-template-columns: 1fr 1fr; /* Two columns */
      gap: 15px; /* Space between buttons */
      margin-bottom: 24px;
    }

    .btn-dashboard { /* Styles consistent with .btn-common from welcome.jsp */
      display: inline-block;
      padding: 12px 28px; /* Adjusted padding to match .btn-common */
      background: #FFC947; /* Yellow - consistent with welcome.jsp */
      color: #0A2540; /* Dark blue - consistent with welcome.jsp */
      text-decoration: none;
      border-radius: 24px;
      font-weight: 500;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
      text-align: center;
    }
    .btn-dashboard:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }
    /* Specific colors for different button types (optional, but kept if desired for visual distinction) */
    /* If you want all buttons to be yellow, you can remove these specific styles */
    .btn-dashboard.forum { background: #9b59b6; color: #fff; } /* Purple */
    .btn-dashboard.manage { background: #3498db; color: #fff; } /* Blue */
    .btn-dashboard.report1 { background: #1abc9c; color: #fff; } /* Teal */
    .btn-dashboard.report2 { background: #e67e22; color: #fff; } /* Orange */


    .btn-logout { /* Consistent with .btn-logout from welcome.jsp */
      display: inline-block;
      padding: 12px 28px;
      background: #FFC947; /* Yellow - consistent with welcome.jsp */
      color: #0A2540; /* Dark blue - consistent with welcome.jsp */
      text-decoration: none;
      border-radius: 24px;
      font-weight: 500;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
      margin-top: 8px; /* Adjusted margin to match .btn-common/logout in welcome.jsp */
    }
    .btn-logout:hover {
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
  <div class="dashboard-card">
    <h1>Welcome, <%= user %>!</h1>
    <p>You are logged in as a <%= userRole %>.</p>

    <div class="button-grid">
      <a href="customer_service_forum.jsp" class="btn-dashboard forum">Customer Service Forum</a>
      <a href="rep_manage_schedules.jsp" class="btn-dashboard manage">Manage Train Schedules</a>
      <a href="rep_station_schedules_report.jsp" class="btn-dashboard report1">Train Schedules Report</a>
      <a href="rep_customer_reservations_report.jsp" class="btn-dashboard report2">Customer Reservations Report</a>
    </div>

    <a href="logout" class="btn-logout">Log Out</a>
  </div>
</body>
</html>
