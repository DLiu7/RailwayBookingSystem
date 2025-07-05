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
  margin: 8px;
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
    <div class="button-row">
    <a href="bookings.jsp"    class="btn-logout">View My Bookings</a>
    <a href="reservation.jsp" class="btn-logout">Make Reservation</a>    
    <a href="logout" class="btn-logout">Log Out</a>
  </div>
</body>
</html>