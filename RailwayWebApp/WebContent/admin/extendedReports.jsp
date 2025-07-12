<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map, java.math.BigDecimal, java.util.Map.Entry" %>
<%
    Map<String, BigDecimal> revByLine     = (Map)request.getAttribute("revByLine");
    Map<String, BigDecimal> revByCustomer = (Map)request.getAttribute("revByCustomer");
    String bestCustomer                   = (String)request.getAttribute("bestCustomer");
    Map<String, Integer> top5             = (Map)request.getAttribute("top5Lines");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Extended Admin Reports</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <style>
    /* BASE + BACKGROUND IMAGE */
    body {
      margin: 0;
      padding: 20px;
      background: url('Train5.jpg') no-repeat center center fixed;
      background-size: cover;
      font-family: 'Roboto', sans-serif;
      color: #eee;
    }
    a { text-decoration: none; }

    /* DARKER OVERLAY CONTAINER */
    .report-container {
      background: rgba(10,37,64,0.95); /* deeper navy at 95% opacity */
      max-width: 900px;
      margin: 40px auto;
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.4);
      color: #FFF;
    }

    /* SECTION STYLING */
    .section {
      margin-bottom: 36px;
    }
    .section-title {
      font-size: 1.5rem;
      font-weight: 500;
      color: #FFFFFF;               
      margin-bottom: 16px;
      border-bottom: 1px solid rgba(255,255,255,0.4);
      padding-bottom: 8px;
    }

    /* YELLOW BUTTONS WITH BOLD BLACK TEXT */
    .btn-yellow {
      display: block;
      width: 100%;
      text-align: left;
      background: #FFC947;
      color: #000000;              /* black text */
      padding: 12px 24px;
      margin-bottom: 10px;
      font-size: 1rem;
      font-weight: 700;            /* bold */
      border: none;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.25);
      cursor: default;
      transition: background 0.3s, box-shadow 0.3s;
    }
    .btn-yellow:hover {
      background: #e6b43e;
      box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }

    /* BACK LINK */
    .back-link {
      display: inline-block;
      margin-top: 24px;
      color: #FFC947;
      font-weight: 500;
    }
    .back-link:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="report-container">

    <div class="section">
      <div class="section-title">Revenue by Transit Line</div>
      <%
        for (Entry<String, BigDecimal> e : revByLine.entrySet()) {
      %>
        <button class="btn-yellow">
          <%= e.getKey() %> &mdash; US$<%= e.getValue() %>
        </button>
      <% } %>
    </div>

    <div class="section">
      <div class="section-title">Revenue by Customer</div>
      <%
        for (Entry<String, BigDecimal> e : revByCustomer.entrySet()) {
      %>
        <button class="btn-yellow">
          <%= e.getKey() %> &mdash; US$<%= e.getValue() %>
        </button>
      <% } %>
    </div>

    <div class="section">
      <div class="section-title">Best Customer</div>
      <button class="btn-yellow"><%= bestCustomer %></button>
    </div>

    <div class="section">
      <div class="section-title">Top 5 Most Active Transit Lines</div>
      <%
        for (Entry<String, Integer> e : top5.entrySet()) {
      %>
        <button class="btn-yellow">
          <%= e.getKey() %> &mdash; <%= e.getValue() %> reservations
        </button>
      <% } %>
    </div>

    <a href="<%=request.getContextPath()%>/admin/dashboard" class="back-link">
      ← Back to Dashboard
    </a>
  </div>
</body>
</html>


