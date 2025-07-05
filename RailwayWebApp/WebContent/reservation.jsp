<%@ page import="java.sql.*" contentType="text/html; charset=UTF-8" %>
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
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height: 100%;
      font-family: 'Roboto', sans-serif;
      background: url('TP.jpg') no-repeat center center fixed;
      background-size: cover;
      display: flex; align-items: center; justify-content: center;
    }

    .card {
      background: #0A2540;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.5);
      padding: 40px;
      width: 360px;
      text-align: center;
      animation: fadeIn 0.8s ease-out;
    }
    .card h2 {
      color: #fff;
      font-weight: 500;
      margin-bottom: 24px;
    }

    .input-group {
      margin-bottom: 24px;
      text-align: left;
    }
    .input-group label {
      display: block;
      color: rgba(255,255,255,0.8);
      margin-bottom: 6px;
      font-size: 14px;
    }
    .input-group select,
    .input-group input[type="date"] {
      width: 100%;
      padding: 12px;
      border: none;
      border-radius: 8px;
      background: rgba(255,255,255,0.15);
      color: #fff;
      font-size: 16px;
      transition: background .3s;
    }
    .input-group select:focus,
    .input-group input:focus {
      background: rgba(255,255,255,0.3);
      outline: none;
    }
    .input-group select option {
      color: #000;
      background: #fff;
    }

    .btn {
  display: block;               /* make it a block so margin-top applies */
  width: 100%;
  padding: 12px;
  background: #FFD700;
  color: #0A2540;
  text-align: center;
  text-decoration: none;
  border: none;
  border-radius: 24px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  box-shadow: 0 4px 16px rgba(0,0,0,0.3);
  transition: transform .2s, background .2s;
  margin-top: 24px;
}
    .btn:hover {
      background: #FFEA00;
      transform: translateY(-2px);
    }

    /* add a little gap whenever one .btn follows another */
    .btn + .btn {
      margin-top: 40px;
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
        <label for="train">Train</label>
        <select name="train" id="train" required>
          <option value="" disabled selected>Select train...</option>
          <option>Express A</option>
          <option>Regional B</option>
          <option>Coastal C</option>
          <option>Mountain D</option>
        </select>
      </div>
      <div class="input-group">
        <label for="date">Travel Date</label>
        <input type="date" name="date" id="date" required />
      </div>
      <div class="input-group">
    <label for="seat">Seat</label>
    <select name="seat" id="seat" required>
      <option value="" disabled selected>Select seat…</option>
      <option>A1</option>
      <option>A2</option>
      <option>B1</option>
      <option>B2</option>
      <option>C1</option>
      <option>C2</option>
    </select>
  </div>
      <button type="submit" class="btn">Reserve Now</button>
    </form>

    <a href="welcome.jsp" class="btn">Back to Welcome</a>
  </div>
</body>
</html>



