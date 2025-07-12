<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.example.login.Employee" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><%= request.getAttribute("rep")!=null ? "Edit" : "Add" %> Representative</title>
  <style>
    /* reset + full‐screen train image */
    * { box-sizing:border-box; margin:0; padding:0; }
    html, body {
      height:100%; font-family:'Roboto',sans-serif;
      background: url('<%=request.getContextPath()%>/Train5.jpg') no-repeat center center fixed;
      background-size:cover;
      display:flex; align-items:center; justify-content:center;
    }
    /* dark‐blue “glass” card */
    .login-card {
      width:520px; padding:40px;
      background:rgba(10,37,64,0.85);
      border-radius:16px; box-shadow:0 8px 32px rgba(0,0,0,0.4);
      color:#fff; text-align:center;
      animation:fadeIn .8s ease-out;
    }
    .login-card h2 {
      margin-bottom:24px; font-weight:500; font-size:1.5rem;
    }
    /* floating‐label inputs */
    .input-group {
      position:relative; margin-bottom:24px;
    }
    .input-group input {
      width:100%; padding:12px 0;
      border:none; border-bottom:2px solid rgba(255,255,255,0.6);
      background:transparent; color:#fff; font-size:16px;
    }
    .input-group input::placeholder { color:transparent; }
    .input-group label {
      position:absolute; left:0; top:12px;
      color:rgba(255,255,255,0.6); font-size:14px;
      pointer-events:none;
      transition:transform .3s, font-size .3s, color .3s;
    }
    .input-group input:focus + label,
    .input-group input:not(:placeholder-shown) + label {
      transform:translateY(-24px); font-size:12px; color:#fff;
    }
    .input-group input:focus {
      outline:none; border-bottom-color:#fff;
    }
    /* error text (if you need it) */
    .error {
      color:#ff6961; font-size:14px; margin-bottom:16px;
      text-align:left;
    }
    /* yellow pill button */
    .login-card button {
      width:100%; padding:12px;
      background:#FFC947; border:none; border-radius:24px;
      color:#0A2540; font-size:16px; font-weight:500;
      cursor:pointer; box-shadow:0 4px 16px rgba(0,0,0,0.2);
      transition:transform .2s, box-shadow .2s;
      margin-top:16px;
    }
    .login-card button:hover {
      transform:translateY(-2px);
      box-shadow:0 8px 24px rgba(0,0,0,0.3);
    }
    /* fade‐in */
    @keyframes fadeIn {
      from {opacity:0; transform:translateY(-20px);}
      to   {opacity:1; transform:translateY(0);}
    }
    /* link‐text */
    .link-text {
      margin-top:20px; font-size:14px;
      color:rgba(255,255,255,0.8); text-align:center;
    }
    .link-text a {
      color:#FFC947; text-decoration:none; font-weight:500;
      transition:color .2s;
    }
    .link-text a:hover {
      color:#f06552;
    }
  </style>
</head>
<body>
  <%
    Employee rep = (Employee) request.getAttribute("rep");
    boolean edit = rep != null;
  %>
  <div class="login-card">
    <h2><%= edit ? "Edit" : "Add" %> Customer Representative</h2>

    <form action="<%=request.getContextPath()%>/admin/rep-save"
          method="post">
      <% if (edit) { %>
        <input type="hidden" name="originalSsn" value="<%=rep.getSsn()%>"/>
      <% } %>

      <div class="input-group">
        <input type="text" id="ssn" name="ssn"
               value="<%= edit?rep.getSsn():"" %>"
               placeholder=" " required />
        <label for="ssn">SSN</label>
      </div>

      <div class="input-group">
        <input type="text" id="firstName" name="firstName"
               value="<%= edit?rep.getFirstName():"" %>"
               placeholder=" " required />
        <label for="firstName">First Name</label>
      </div>

      <div class="input-group">
        <input type="text" id="lastName" name="lastName"
               value="<%= edit?rep.getLastName():"" %>"
               placeholder=" " required />
        <label for="lastName">Last Name</label>
      </div>

      <div class="input-group">
        <input type="text" id="username" name="username"
               value="<%= edit?rep.getUsername():"" %>"
               placeholder=" " required />
        <label for="username">Username</label>
      </div>

      <div class="input-group">
        <input type="password" id="password" name="password"
               placeholder=" " <%= edit? "" : "required" %> />
        <label for="password"><%= edit? "New Password" : "Password" %></label>
      </div>

      <button type="submit">
        <%= edit ? "Update Representative" : "Create Representative" %>
      </button>
    </form>

    <div class="link-text">
      <a href="<%=request.getContextPath()%>/admin/reps">← Back to List</a>
    </div>
  </div>
</body>
</html>
