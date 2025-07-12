<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.time.YearMonth, java.math.BigDecimal, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Monthly Sales Report</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <style>
    /* reset & full‐screen background */
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

    /* opaque card wrapper forced to 1200px but responsive */
    .report-card {
      width: 1200px;
      max-width: 95%;
      background: #0A2540; /* solid navy, no transparency */
      border-radius: 12px;
      padding: 32px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.4);
      color: #fff;
      text-align: center;
      animation: fadeIn 0.8s ease-out;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-20px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .report-card h2 {
      font-size: 2rem;
      font-weight: 700;
      color: #FFC947;
      margin-bottom: 24px;
    }

    /* form */
    .form-group {
      margin-bottom: 24px;
      text-align: left;
    }
    .form-group label {
      display: block;
      font-size: 0.9rem;
      margin-bottom: 8px;
      color: #e0e0e0;
    }
    .form-group input {
      width: 100%;
      padding: 10px 12px;
      font-size: 1rem;
      border: none;
      border-radius: 6px;
    }
    .report-card button {
      width: 100%;
      padding: 12px;
      font-size: 1rem;
      font-weight: 700;
      color: #0A2540;
      background: #FFC947;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background .2s, transform .2s;
      margin-top: 16px;
    }
    .report-card button:hover {
      background: #e5b43c;
      transform: translateY(-2px);
    }

    /* table */
    .report-card table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 24px;
      font-size: 0.9rem;
    }
    .report-card th, .report-card td {
      padding: 8px;
      border-bottom: 1px solid rgba(255,255,255,0.2);
      color: #fff;
      text-align: left;
    }
    .report-card th {
      background: rgba(255,255,255,0.1);
      font-weight: 500;
    }

    /* back link */
    .back-link {
      display: block;
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
  <div class="report-card">
    <h2>Sales Report for <%= request.getAttribute("year") %></h2>
    <form method="get">
      <div class="form-group">
        <label for="year">Year</label>
        <input id="year" name="year" type="number"
               value="<%= request.getAttribute("year") %>"
               min="2000" max="2100"/>
      </div>
      <button type="submit">Show</button>
    </form>

    <table>
      <thead>
        <tr><th>Month</th><th>Total Sales</th></tr>
      </thead>
      <tbody>
      <%
        Map<YearMonth, BigDecimal> data =
            (Map<YearMonth, BigDecimal>)request.getAttribute("salesData");
        if (data != null) {
          for (Map.Entry<YearMonth, BigDecimal> e : data.entrySet()) {
      %>
        <tr>
          <td><%= e.getKey() %></td>
          <td><%= e.getValue() %></td>
        </tr>
      <%
          }
        }
      %>
      </tbody>
    </table>

    <a href="<%=request.getContextPath()%>/admin/dashboard" class="back-link">
      ← Back to Dashboard
    </a>
  </div>
</body>
</html>



