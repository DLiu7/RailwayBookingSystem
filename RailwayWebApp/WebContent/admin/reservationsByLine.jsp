<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.example.login.ReservationDetail" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reservations by Line</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <style>
    /* Base reset */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%;
      font-family: 'Roboto', sans-serif;
      background: url('<%=request.getContextPath()%>/Train5.jpg') no-repeat center center fixed;
      background-size: cover;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    /* Card */
    .login-card {
      width: 95%;
      max-width: 1200px;             /* doubled from 600/900 to 1200px */
      background: #0A2540;           /* fully opaque navy */
      border-radius: 12px;
      padding: 32px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.4);
      color: #fff;
    }

    .login-card h2 {
      font-size: 2rem;
      font-weight: 700;
      color: #FFC947;
      text-align: center;
      margin-bottom: 24px;
    }

    /* Form */
    form {
      display: flex;
      flex-direction: column;
      max-width: 400px;
      margin: 0 auto 32px;
    }
    label {
      font-size: 0.9rem;
      margin-bottom: 8px;
      color: #e0e0e0;
      text-align: left;
    }
    input[type="text"] {
      padding: 10px 12px;
      font-size: 1rem;
      border: none;
      border-radius: 6px;
      margin-bottom: 16px;
    }
    button {
      padding: 12px;
      font-size: 1rem;
      font-weight: 700;
      color: #0A2540;
      background: #FFC947;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background .2s, transform .2s;
    }
    button:hover {
      background: #e5b43c;
      transform: translateY(-2px);
    }

    /* Table wrapper for horizontal scroll */
    .table-wrapper {
      overflow-x: auto;
      margin-top: 24px;
    }
    /* Table */
    table {
      width: 100%;
      border-collapse: collapse;
      min-width: 700px;              /* ensure it has room */
    }
    th, td {
      padding: 12px 16px;            /* increased padding */
      border-bottom: 1px solid rgba(255,255,255,0.2);
      font-size: 1rem;               /* increased font-size */
      color: #fff;
      text-align: left;
      white-space: nowrap;
    }
    th {
      background: rgba(255,255,255,0.1);
      font-weight: 500;
    }

    /* Back link */
    .back-link {
      display: block;
      text-align: center;
      margin-top: 32px;
      color: #FFC947;
      font-weight: 500;
      text-decoration: none;
      transition: color .2s;
    }
    .back-link:hover {
      color: #e5b43c;
    }
  </style>
</head>
<body>
  <div class="login-card">
    <h2>Reservations by Line</h2>
    <form method="get">
      <label for="lineName">Enter line name</label>
      <input id="lineName" name="lineName"
             type="text"
             placeholder="e.g. 4000"
             value="<%= request.getParameter("lineName")==null?"":request.getParameter("lineName") %>" />
      <button type="submit">Show</button>
    </form>

    <div class="table-wrapper">
      <%
        List<ReservationDetail> list =
          (List<ReservationDetail>)request.getAttribute("reservations");
        if (list != null && !list.isEmpty()) {
      %>
      <table>
        <thead>
          <tr>
            <th>ID</th><th>Customer</th><th>Train</th>
            <th>Date</th><th>Fare</th><th>Line</th>
          </tr>
        </thead>
        <tbody>
        <%
          for (ReservationDetail rd : list) {
        %>
          <tr>
            <td><%= rd.getId() %></td>
            <td><%= rd.getCustomerName() %></td>
            <td><%= rd.getTrain() %></td>
            <td><%= rd.getTravelDate() %></td>
            <td><%= rd.getTotalFare() %></td>
            <td><%= rd.getLineName() %></td>
          </tr>
        <%
          }
        %>
        </tbody>
      </table>
      <% } %>
    </div>

    <a href="<%=request.getContextPath()%>/admin/dashboard" class="back-link">
      ← Back to Dashboard
    </a>
  </div>
</body>
</html>



