<%@ page import="java.sql.*" contentType="text/html; charset=UTF-8" %>
<%
    // Protect this page
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String user = (String) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Bookings</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    /* reuse your card + table styles from reservation.jsp */
    body, html { height:100%; margin:0; font-family:'Roboto',sans-serif;
      background: linear-gradient(135deg,#8B0000 0%,#4B0000 100%);
      display:flex;align-items:center;justify-content:center;
    }
    .card { background:rgba(255,255,255,0.15);backdrop-filter:blur(8px);
      border-radius:16px;padding:40px;width:380px;
      box-shadow:0 8px 32px rgba(0,0,0,0.37);
      animation:fadeIn 0.8s ease-out;
    }
    h2 { color:#fff; text-align:center; margin-bottom:24px; }
    table { width:100%; border-collapse:collapse; }
    th, td { padding:8px; border-bottom:1px solid rgba(255,255,255,0.3);
      color:#fff; text-align:left;
    }
    th { font-weight:500; }
    .btn { display:block; width:100%; margin-top:24px;
      text-align:center; padding:12px; border-radius:24px;
      background:linear-gradient(135deg,#ff7e5f,#feb47b);
      color:#fff; text-decoration:none; font-weight:500;
      box-shadow:0 4px 16px rgba(0,0,0,0.2);
      transition:transform .2s,box-shadow .2s;
    }
    .btn:hover { transform:translateY(-2px);
      box-shadow:0 8px 24px rgba(0,0,0,0.3);
    }
    @keyframes fadeIn { from{opacity:0;transform:translateY(-20px);}
      to{opacity:1;transform:translateY(0);} }
  </style>
</head>
<body>
  <div class="card">
    <h2><%= user %>’s Bookings</h2>
    <%
      // Fetch and display
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
          "jdbc:mysql://localhost:3306/login_project",
          "root","BMWF30CAZ4406");
        PreparedStatement ps = conn.prepareStatement(
          "SELECT r.train, r.travel_date "
          + "FROM reservations r JOIN users u ON r.user_id=u.id "
          + "WHERE u.username=?");
        ps.setString(1, user);
        ResultSet rs = ps.executeQuery();
    %>
      <table>
        <tr><th>Train</th><th>Date</th></tr>
        <% while(rs.next()){ %>
          <tr>
            <td><%= rs.getString("train") %></td>
            <td><%= rs.getDate("travel_date") %></td>
          </tr>
        <% } %>
      </table>
    <%
        rs.close(); ps.close(); conn.close();
      } catch(Exception e){
        out.println("<p style='color:#ff6961;'>Error loading bookings.</p>");
      }
    %>
    <a href="welcome.jsp" class="btn">Back to Welcome</a>
  </div>
</body>
</html>
