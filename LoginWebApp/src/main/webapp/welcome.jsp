<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // Redirect if not logged in
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String user = (String) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Welcome</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%;
      font-family: 'Roboto', sans-serif;
      background: linear-gradient(135deg, #43cea2, #185a9d);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .welcome-card {
      background: rgba(255,255,255,0.15);
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.37);
      backdrop-filter: blur(8px);
      padding: 40px;
      width: 360px;
      text-align: center;
      animation: fadeInCard 0.8s ease-out;
    }

    .welcome-card h1 {
      color: #fff;
      font-weight: 500;
      margin-bottom: 16px;
    }
    .welcome-card p {
      color: #f0f0f0;
      margin-bottom: 24px;
    }

    .btn-logout {
      display: inline-block;
      padding: 12px 28px;
      background: linear-gradient(135deg, #ff7e5f, #feb47b);
      color: #fff;
      text-decoration: none;
      border-radius: 24px;
      font-weight: 500;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
      margin: 8px; /* spacing between buttons */
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
  <div class="welcome-card">
    <h1>Hey, <%= user %>!</h1>
    <p>You have successfully logged in.</p>
    <a href="logout" class="btn-logout">Log Out</a>
  </div>
</body>
</html>

