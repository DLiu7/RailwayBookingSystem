<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
</head>
<body>
  <h2>Please Log In</h2>
  <form action="login" method="post">
    Username: <input type="text" name="username" required /><br/>
    Password: <input type="password" name="password" required /><br/>
    <input type="submit" value="Log In" />
  </form>
  <% if (request.getAttribute("error") != null) { %>
    <p style="color:red;"><%= request.getAttribute("error") %></p>
  <% } %>
</body>
</html>
