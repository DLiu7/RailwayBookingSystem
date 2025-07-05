<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // Protect this page—redirect back to login if not authenticated
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
  <title>Make a Reservation</title>
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
    .card {
      background: rgba(255,255,255,0.15);
      border-radius: 16px; box-shadow: 0 8px 32px rgba(0,0,0,0.37);
      backdrop-filter: blur(8px); padding: 40px; width: 360px;
      text-align: center; animation: fadeIn 0.8s ease-out;
    }
    .card h2 {
      color: #fff; font-weight: 500; margin-bottom: 24px;
    }
    .input-group {
      position: relative; margin-bottom: 24px; text-align: left;
    }
    .input-group select,
    .input-group input[type="date"] {
      width: 100%; padding: 12px;
      border: none; border-radius: 8px;
      background: rgba(255,255,255,0.25); color: #fff;
      font-size: 16px; transition: background .3s;
    }
    .input-group select:focus,
    .input-group input:focus {
      background: rgba(255,255,255,0.4); outline: none;
    }
    .btn {
      width: 100%; padding: 12px;
      background: linear-gradient(135deg, #ff7e5f, #feb47b);
      color: #fff; border: none; border-radius: 24px;
      font-weight: 500; cursor: pointer;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
    }
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-20px); }
      to   { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="card">
    <h2>Hello, <%= user %>—Book a Train</h2>
    <form action="reserve" method="post">
      <div class="input-group">
        <label for="train" style="color:#fff; font-size:14px;">Train</label>
        <select name="train" id="train" required>
          <option value="" disabled selected>Select train...</option>
          <option>Express A</option>
          <option>Regional B</option>
          <option>Coastal C</option>
          <option>Mountain D</option>
        </select>
      </div>
      <div class="input-group">
        <label for="date" style="color:#fff; font-size:14px;">Travel Date</label>
        <input type="date" name="date" id="date" required />
      </div>
      <button type="submit" class="btn">Reserve Now</button>
    </form>
  </div>
</body>
</html>
