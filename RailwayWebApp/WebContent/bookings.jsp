<%@ page import="java.sql.*, com.example.login.DatabaseUtils" contentType="text/html; charset=UTF-8" %>
<%
    // Protect page
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String user = (String) session.getAttribute("user");
    boolean isAdmin = "admin".equalsIgnoreCase(user);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= isAdmin ? "All Users’ Reservations" : user + "’s Reservations" %></title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      /* Train image as the full-page background */
      background-image: url('TR1.jpg');
      background-size: cover;
      background-position: center;
      font-family: 'Roboto', sans-serif;
    }

    /* Dark blue “card” on top */
    .container {
      background: #0a2540;       /* deep navy blue */
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.4);
      width: 900px;
      padding: 32px;
      margin: 40px auto;
      display: flex;
      flex-direction: column;
      animation: fadeIn 0.8s ease-out;
    }

    h1 {
      font-size: 1.75rem;
      margin-bottom: 24px;
      text-align: left;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 32px;
      background: rgba(0,0,0,0.2);    /* semi-transparent so a hint of train shows through */
      border-radius: 4px;
      overflow: hidden;
    }

    th, td {
      padding: 12px 8px;
      font-size: 1rem;
      text-align: center;
    }

    th {
      background: rgba(0,0,0,0.6);
      text-transform: uppercase;
      font-weight: 500;
    }

    tr:nth-child(even) {
      background: rgba(255,255,255,0.05);
    }
    tr:not(:nth-child(even)) {
      background: rgba(255,255,255,0.02);
    }

    .btn {
      align-self: flex-start;
      background: #FFC947; 
      color: #0A2540;   
      padding: 12px 28px;
      border-radius: 4px;
      text-decoration: none;
      font-weight: 500;
      box-shadow: 0 2px 6px rgba(0,0,0,0.3);
      transition: background .2s;
    }
    .btn:hover {
      background: #f06552;
    }

    @keyframes fadeIn {
      from { opacity:0; transform: translateY(-20px); }
      to   { opacity:1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1><%= isAdmin ? "All Users’ Reservations" : user + "’s Reservations" %></h1>
    <%
      try {
    	  Connection conn = DatabaseUtils.getConnection();

        String sql;
        if (isAdmin) {
          sql = "SELECT u.username, r.id, r.train, r.travel_date, r.seat_id "
              + "FROM reservations r JOIN users u ON r.user_id = u.id";
        } else {
          sql = "SELECT r.id, r.train, r.travel_date, r.seat_id "
              + "FROM reservations r JOIN users u ON r.user_id = u.id "
              + "WHERE u.username = ?";
        }
        PreparedStatement ps = conn.prepareStatement(sql);
        if (!isAdmin) {
          ps.setString(1, user);
        }
        ResultSet rs = ps.executeQuery();
    %>
      <table>
        <tr>
          <% if (isAdmin) { %>
            <th>User</th>
          <% } %>
          <th>Res.ID</th>
          <th>Train</th>
          <th>Date</th>
          <th>Seat</th>
        </tr>
        <% while (rs.next()) { %>
          <tr>
            <% if (isAdmin) { %>
              <td><%= rs.getString("username") %></td>
            <% } %>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("train") %></td>
            <td><%= rs.getDate("travel_date") %></td>
            <td><%= rs.getString("seat_id") %></td>
          </tr>
        <% } %>
      </table>
    <%
        rs.close();
        ps.close();
        conn.close();
      } catch(Exception e) {
        out.println(
          "<p style='color:#ff6961;text-align:center;'>"
          + "Error loading bookings: "+ e.getMessage()
          + "</p>");
      }
    %>
    <a href="welcome.jsp" class="btn">Back to Welcome</a>
  </div>
</body>
</html>


