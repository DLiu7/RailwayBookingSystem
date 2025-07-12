<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.example.login.Employee" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Customer Representatives</title>
  <style>
    /* reset + full‐screen train image */
    * { box-sizing:border-box; margin:0; padding:0; }
    html, body {
      height:100%; font-family:'Roboto',sans-serif;
      background: url('<%=request.getContextPath()%>/Train5.jpg') no-repeat center center fixed;
      background-size: cover;
      display:flex; align-items:center; justify-content:center;
    }

    /* —— Wider “glass” card —— */
    .login-card {
      width:90%; max-width:1000px;
      padding:40px;
     background: #0A2540;
      border-radius:16px;
      box-shadow:0 8px 32px rgba(0,0,0,0.4);
      color:#fff; text-align:center;
      animation:fadeIn .8s ease-out;
      margin:20px;
    }
    .login-card h2 {
      margin-bottom:24px; font-weight:500; font-size:1.5rem;
    }

    /* —— Table styling —— */
    .login-card table {
      width:100%; border-collapse:collapse; margin-top:20px;
      table-layout:fixed;
    }
    .login-card th, .login-card td {
      border:1px solid rgba(255,255,255,0.3);
      padding:12px 16px;
      color:#fff;
      white-space:nowrap;
      overflow:hidden; text-overflow:ellipsis;
    }
    .login-card th {
      background:rgba(255,255,255,0.1);
    }
    .login-card th:nth-child(1),
    .login-card td:nth-child(1) { width:20%; }
    .login-card th:nth-child(2),
    .login-card td:nth-child(2) { width:35%; }
    .login-card th:nth-child(3),
    .login-card td:nth-child(3) { width:25%; }
    .login-card th:nth-child(4),
    .login-card td:nth-child(4) { width:20%; }

    /* yellow pill buttons */
    .login-card .btn,
    .login-card button {
      display:block;
      width:80%; max-width:200px;
      margin:8px auto;
      padding:12px 0;
      background:#FFC947; border:none; border-radius:24px;
      color:#0A2540; font-size:16px; font-weight:500;
      cursor:pointer; box-shadow:0 4px 16px rgba(0,0,0,0.2);
      transition:transform .2s,box-shadow .2s;
      text-decoration:none;
      text-align:center;
    }
    .login-card .btn:hover,
    .login-card button:hover {
      transform:translateY(-2px);
      box-shadow:0 8px 24px rgba(0,0,0,0.3);
    }

    /* fade-in */
    @keyframes fadeIn {
      from { opacity:0; transform:translateY(-20px); }
      to   { opacity:1; transform:translateY(0); }
    }

    .link-text {
      margin-top:16px; font-size:14px;
      color:rgba(255,255,255,0.8); text-align:center;
    }
    .link-text a {
      color:inherit;
    }
  </style>
</head>
<body>
  <div class="login-card">
    <h2>Customer Representatives</h2>

    <div class="link-text">
      <a class="btn" href="rep-form">+ Add New Representative</a>
      <!-- Changed to “Back to Dashboard” -->
      <a class="btn" href="<%=request.getContextPath()%>/admin/dashboard">
        ← Back to Dashboard
      </a>
    </div>

    <table>
      <thead>
        <tr>
          <th>SSN</th><th>Name</th><th>Username</th><th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <%
        List<Employee> reps = (List<Employee>) request.getAttribute("reps");
        if (reps != null) {
          for (Employee e : reps) {
      %>
        <tr>
          <td><%= e.getSsn() %></td>
          <td><%= e.getFirstName() %> <%= e.getLastName() %></td>
          <td><%= e.getUsername() %></td>
          <td>
            <a class="btn" href="rep-form?ssn=<%= e.getSsn() %>">Edit</a>
            <form action="rep-delete" method="post" style="margin:0;">
              <input type="hidden" name="ssn" value="<%= e.getSsn() %>"/>
              <button type="submit" onclick="return confirm('Delete this rep?')">
                Delete
              </button>
            </form>
          </td>
        </tr>
      <%
          }
        }
      %>
      </tbody>
    </table>
  </div>
</body>
</html>
