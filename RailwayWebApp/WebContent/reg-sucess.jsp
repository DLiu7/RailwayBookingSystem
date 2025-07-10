<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Registration Successful</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link
    href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap"
    rel="stylesheet">

  <style>
    /* full-screen train background + centering */
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height:100%; font-family:'Roboto',sans-serif;
      background: url('Train5.jpg') no-repeat center center fixed;
      background-size:cover;
      display:flex; align-items:center; justify-content:center;
    }

    /* confirmation card */
    .success-card {
      width:450px; padding:36px;
      background: rgba(10,37,64,0.85);
      border-radius:16px; box-shadow:0 8px 32px rgba(0,0,0,0.4);
      color:#fff; text-align:center;
      animation:fadeIn .8s ease-out;
    }
    .success-card h2 {
      margin-bottom:16px; font-size:1.6rem; font-weight:500;
    }
    .success-card p {
      margin-bottom:24px; font-size:1rem; line-height:1.4;
    }
    .success-card button {
      padding:12px 24px;
      background:#FFC947; border:none; border-radius:24px;
      color:#0A2540; font-size:16px; font-weight:500;
      cursor:pointer; box-shadow:0 4px 16px rgba(0,0,0,0.2);
      transition:transform .2s,box-shadow .2s;
    }
    .success-card button:hover {
      transform: translateY(-2px);
      box-shadow:0 8px 24px rgba(0,0,0,0.3);
    }

    @keyframes fadeIn {
      from { opacity:0; transform: translateY(-20px); }
      to   { opacity:1; transform: translateY(0);    }
    }
  </style>
</head>
<body>
  <div class="success-card">
    <h2>🎉 Registration Successful!</h2>
    <p>Your account has been created. Click below to go back to the login page and sign in.</p>
    <form action="login2.jsp" method="get">
      <button type="submit">Back to Login</button>
    </form>
  </div>
</body>
</html>
