<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map, java.math.BigDecimal, java.util.Map.Entry" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Extended Admin Reports</title>
  <style>
    /* Base + full‐screen train background */
    * { margin: 0; padding: 0; box‐sizing: border-box; }
    html, body {
      height: 100%;
    }
    body {
      font-family: Roboto, sans-serif;
      padding: 20px;
      background: 
        url('Train5.jpg')
        no-repeat center center fixed;
      background-size: cover;
      color: #333;
    }

    /* Content wrapper for better readability */
    .report-wrapper {
      background: rgba(255,255,255,0.90);
      max-width: 900px;
      margin: auto;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
    }

    h1 {
      margin-bottom: 16px;
      color: #0A2540;
      font-size: 1.75rem;
    }
    table {
      border-collapse: collapse;
      margin-bottom: 30px;
      width: 100%;
    }
    th, td {
      border: 1px solid #aaa;
      padding: 8px;
      text-align: left;
    }
    th {
      background: #eee;
      font-weight: 500;
    }

    a.back {
      display: inline-block;
      margin-top: 16px;
      color: #FFC947;
      text-decoration: none;
      font-weight: 500;
    }
    a.back:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <div class="report-wrapper">
    <h1>Revenue by Transit Line</h1>
    <table>
      <tr><th>Line</th><th>Revenue (US$)</th></tr>
      <%
        Map<String,BigDecimal> revByLine = (Map)request.getAttribute("revByLine");
        for (Entry<String, BigDecimal> e : revByLine.entrySet()) {
      %>
      <tr>
        <td><%= e.getKey() %></td>
        <td><%= e.getValue() %></td>
      </tr>
      <% } %>
    </table>

    <h1>Revenue by Customer</h1>
    <table>
      <tr><th>Customer</th><th>Revenue (US$)</th></tr>
      <%
        Map<String,BigDecimal> revByCustomer = (Map)request.getAttribute("revByCustomer");
        for (Entry<String, BigDecimal> e : revByCustomer.entrySet()) {
      %>
      <tr>
        <td><%= e.getKey() %></td>
        <td><%= e.getValue() %></td>
      </tr>
      <% } %>
    </table>

    <h1>Best Customer</h1>
    <p><strong><%= request.getAttribute("bestCustomer") %></strong></p>

    <h1>Top 5 Most Active Transit Lines</h1>
    <table>
      <tr><th>Line</th><th>Reservations</th></tr>
      <%
        Map<String,Integer> top5 = (Map)request.getAttribute("top5Lines");
        for (Entry<String,Integer> e : top5.entrySet()) {
      %>
      <tr>
        <td><%= e.getKey() %></td>
        <td><%= e.getValue() %></td>
      </tr>
      <% } %>
    </table>

    <a href="<%=request.getContextPath()%>/admin/dashboard" class="back">
      ← Back to Dashboard
    </a>
  </div>
</body>
</html>
