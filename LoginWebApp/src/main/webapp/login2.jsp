<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login Page</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    /* full-page gradient + centering */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%;
      font-family: 'Roboto', sans-serif;
      background: linear-gradient(135deg, #8B0000 0%, #4B0000 100%);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    /* glass-morphic card */
    .login-card {
      background: rgba(255,255,255,0.15);
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.37);
      backdrop-filter: blur(8px);
      padding: 40px;
      width: 320px;
      text-align: center;
      animation: fadeIn 0.8s ease-out;
    }
    .login-card h2 {
      color: #fff;
      font-weight: 500;
      margin-bottom: 24px;
    }

    /* input styling */
    .login-card .input-group {
      position: relative;
      margin-bottom: 24px;
    }
    .login-card input {
      width: 100%;
      padding: 12px 0;
      border: none;
      border-bottom: 2px solid rgba(255,255,255,0.6);
      background: transparent;
      color: #fff;
      font-size: 16px;
      transition: border-color .3s;
    }
    .login-card input:focus {
      outline: none;
      border-bottom-color: #fff;
    }
    .login-card label {
      position: absolute;
      top: 12px; left: 0;
      color: rgba(255,255,255,0.7);
      font-size: 14px;
      pointer-events: none;
      transition: transform .3s, font-size .3s;
    }
    .login-card input:focus + label,
    .login-card input:not(:placeholder-shown) + label {
      transform: translateY(-24px);
      font-size: 12px;
      color: #fff;
    }

    /* button styling */
    .login-card button {
      width: 100%;
      padding: 12px;
      background: linear-gradient(135deg, #ff758c, #ff7eb3);
      border: none;
      border-radius: 24px;
      color: #fff;
      font-size: 16px;
      font-weight: 500;
      cursor: pointer;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
    }
    .login-card button:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }

    /* fade‐in animation */
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-20px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* error message */
    .error {
      color: #ff6961;
      font-size: 14px;
      margin-top: -16px;
      margin-bottom: 16px;
      text-align: left;
    }
  </style>
</head>
<body>
  <div class="login-card">
    <h2>Welcome Back</h2>
    <form action="login" method="post">
      <div class="input-group">
        <input type="text" name="username" id="u" placeholder=" " required>
        <label for="u">Username</label>
      </div>
      <div class="input-group">
        <input type="password" name="password" id="p" placeholder=" " required>
        <label for="p">Password</label>
      </div>
      <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
      <% } %>
      <button type="submit">Log In</button>
    </form>
  </div>
</body>
</html>