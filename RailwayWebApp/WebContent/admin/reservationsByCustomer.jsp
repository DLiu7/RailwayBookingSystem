<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.example.login.ReservationDetail" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reservations by Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <style>
    /* Reset & base */
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

    /* Card container */
    .card {
      width: 100%;
      max-width: 800px;
      background: rgba(10,37,64,0.9);
      border-radius: 12px;
      padding: 32px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.4);
      color: #fff;
       overflow-x: auto; 
    }
    .card h2 {
      font-size: 2rem;
      font-weight: 700;
      color: #FFC947;
      text-align: center;
      margin-bottom: 24px;
    }

    /* Form */
    .card form {
      display: flex;
      flex-direction: column;
      margin-bottom: 24px;
    }
    .card label {
      font-size: 0.9rem;
      margin-bottom: 8px;
      color: #e0e0e0;
    }
    .card input[type="text"] {
      padding: 10px 12px;
      font-size: 1rem;
      border: none;
      border-radius: 6px;
      margin-bottom: 16px;
    }

    /* Buttons */
    .card button,
    .card .btn {
      padding: 12px;
      font-size: 1rem;
      font-weight: 700;
      color: #0A2540;
      background: #FFC947;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background .2s, transform .2s;
      text-decoration: none;
      text-align: center;
    }
    .card button:hover,
    .card .btn:hover {
      background: #e5b43c;
      transform: translateY(-2px);
    }

    /* Table */
    .card table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 16px;
      font-size: 0.9rem;
    }
    .card th, .card td {
      padding: 8px;
      border-bottom: 1px solid rgba(255,255,255,0.2);
      color: #fff;
      white-space: nowrap;
    }
    .card th {
      background: rgba(255,255,255,0.1);
      font-weight: 500;
      text-align: left;
    }

    /* Back link */
    .back-link {
      display: block;
      text-align: center;
      margin-top: 24px;
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
  <div class="card">
    <h2>Reservations by Customer</h2>
    <form method="get">
      <label for="customerName">Enter full or partial customer name</label>
      <input id="customerName" name="customerName" type="text"
             placeholder="e.g. John Doe"
             value="<%= request.getParameter("customerName")==null?"":request.getParameter("customerName") %>" />
      <button type="submit">Show</button>
    </form>

    <%
      List<ReservationDetail> list =
        (List<ReservationDetail>)request.getAttribute("reservations");
      if (list != null && !list.isEmpty()) {
    %>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Customer</th>
            <th>Train</th>
            <th>Line</th>
            <th>Date</th>
            <th>Seat</th>
            <th>Fare</th>
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
            <td><%= rd.getLineName() %></td>
            <td><%= rd.getTravelDate() %></td>
            <td><%= rd.getSeatId() %></td>
            <td><%= rd.getTotalFare() %></td>
          </tr>
        <%
          }
        %>
        </tbody>
      </table>
    <% } %>

    <a class="btn back-link" href="<%=request.getContextPath()%>/admin/dashboard">
      ← Back to Dashboard
    </a>
  </div>
</body>
</html>
