<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>
  <style>
    /* reset + full‐screen train image */
    * { box-sizing:border-box; margin:0; padding:0; }
    html, body {
      height:100%; font-family:'Roboto',sans-serif;
      background: url('<%=request.getContextPath()%>/Train5.jpg') no-repeat center center fixed;
      background-size: cover;
      display:flex; align-items:center; justify-content:center;
    }

    /* glass card */
    .login-card {
      width:80%; max-width:800px; padding:40px;
      background: #0A2540;
      border-radius:16px; box-shadow:0 8px 32px rgba(0,0,0,0.4);
      color:#fff; text-align:center; animation:fadeIn .8s ease-out;
      margin:20px;
    }
    .login-card h2 {
      margin-bottom:24px; font-weight:500; font-size:1.5rem;
    }

    /* pill buttons */
    .login-card .btn {
      display:inline-block;
      padding:12px 32px;
      margin:12px 8px;
      background:#FFC947;
      border:none; border-radius:24px;
      color:#0A2540;
      font-size:16px; font-weight:500;
      cursor:pointer;
      box-shadow:0 4px 16px rgba(0,0,0,0.2);
      transition:transform .2s,box-shadow .2s;
      text-decoration:none;
      white-space: nowrap;
    }
    .login-card .btn:hover {
      transform:translateY(-2px);
      box-shadow:0 8px 24px rgba(0,0,0,0.3);
    }

    @keyframes fadeIn {
      from {opacity:0; transform:translateY(-20px);}
      to   {opacity:1; transform:translateY(0);}
    }
  </style>
</head>
<body>
  <div class="login-card">
    <h2>Admin Dashboard</h2>

    <a class="btn" href="<%=request.getContextPath()%>/admin/reps">
      Manage Customer Representatives
    </a>

    <a class="btn" href="<%=request.getContextPath()%>/admin/sales-report">
      View Monthly Sales Report
    </a>

    <a class="btn" href="<%=request.getContextPath()%>/admin/reservations/line">
      List Reservations by Line
    </a>

    <a class="btn" href="<%=request.getContextPath()%>/admin/reservations/customer">
      List Reservations by Customer
    </a>
    
 

    <a class="btn" href="<%=request.getContextPath()%>/login2.jsp">
      Logout
    </a>
  </div>
</body>
</html>

