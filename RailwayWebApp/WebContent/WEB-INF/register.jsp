<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register for Railway Booking</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    /* reset + full‐screen train image */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Roboto', sans-serif;

      /* single full-screen background image */
      background:
        url('Train5.jpg') /* Using the same background as login2.jsp for consistency */
        no-repeat center center fixed;
      background-size: cover;

      /* center your card */
      display: flex;
      align-items: center;
      justify-content: center;
    }

    /* dark‐blue “glass” registration card */
    .register-card {
      width: 520px;
      padding: 40px;
      background: rgba(10,37,64,1.5); /* Same dark blue as login card */
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.4);
      color: #fff;
      text-align: center;
      animation: fadeIn 0.8s ease-out;
    }
    .register-card h2 {
      margin-bottom: 24px;
      font-weight: 500;
      font-size: 1.5rem;
    }

    /* floating‐label inputs */
    .input-group {
      position: relative;
      margin-bottom: 24px;
    }
    .input-group input {
      width: 100%;
      padding: 12px 0;
      border: none;
      border-bottom: 2px solid rgba(255,255,255,0.6);
      background: transparent;
      color: #fff;
      font-size: 16px;
    }
    .input-group input::placeholder { color: transparent; }
    .input-group label {
      position: absolute;
      left: 0; top: 12px;
      color: rgba(255,255,255,0.6);
      font-size: 14px;
      pointer-events: none;
      transition: transform .3s, font-size .3s, color .3s;
    }
    .input-group input:focus + label,
    .input-group input:not(:placeholder-shown) + label {
      transform: translateY(-24px);
      font-size: 12px;
      color: #fff;
    }
    .input-group input:focus {
      outline: none;
      border-bottom-color: #fff;
    }

    /* error/success text */
    .message {
      font-size: 14px;
      margin-bottom: 16px;
      text-align: left;
    }
    .message.error {
      color: #ff6961; /* Red for errors */
    }
    .message.success {
      color: #61ff8d; /* Green for success */
    }

    /* gradient “pill” button */
    .register-card button {
      width: 100%;
      padding: 12px;
      background: #FFC947; /* Yellow */
      border: none;
      border-radius: 24px;
      color: #0A2540; /* Dark blue */
      font-size: 16px;
      font-weight: 500;
      cursor: pointer;
      box-shadow: 0 4px 16px rgba(0,0,0,0.2);
      transition: transform .2s, box-shadow .2s;
    }
    .register-card button:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0,0,0,0.3);
    }

    .link-text {
        margin-top: 20px;
        font-size: 14px;
    }
    .link-text a {
        color: #FFC947; /* Yellow link */
        text-decoration: none;
        font-weight: 500;
        transition: color .2s;
    }
    .link-text a:hover {
        color: #f06552; /* Hover color */
    }

    /* fade‐in */
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-20px); }
      to   { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="register-card">
    <h2>Create Your Account</h2>
    <form action="register" method="post">
      <div class="input-group">
        <input type="text" name="username" id="u" placeholder=" " required>
        <label for="u">Username</label>
      </div>
      <div class="input-group">
        <input type="password" name="password" id="p" placeholder=" " required>
        <label for="p">Password</label>
      </div>
      <div class="input-group">
        <input type="password" name="confirm_password" id="cp" placeholder=" " required>
        <label for="cp">Confirm Password</label>
      </div>

      <% /* Display messages from the servlet (e.g., success or error) */ %>
      <% if (request.getAttribute("error") != null) { %>
        <div class="message error"><%= request.getAttribute("error") %></div>
      <% } else if (request.getAttribute("success") != null) { %>
        <div class="message success"><%= request.getAttribute("success") %></div>
      <% } %>

      <button type="submit">Register</button>
    </form>
    <div class="link-text">
      Already have an account? <a href="login2.jsp">Log In</a>
    </div>
  </div>
</body>
</html>
