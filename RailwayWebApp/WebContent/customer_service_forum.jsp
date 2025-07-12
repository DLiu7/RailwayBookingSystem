<%@ page import="java.sql.*, java.util.List, java.util.ArrayList, com.example.login.DatabaseUtils" contentType="text/html; charset=UTF-8" %>
<%
    // Protect page - redirect back to login if not authenticated
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login2.jsp");
        return;
    }
    String currentUser = (String) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");
    boolean isCustomerRep = "customer_representative".equalsIgnoreCase(userRole);

    // Message for success/error (e.g., after asking question or replying)
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType"); // "success" or "error"

    // For search functionality
    String searchTerm = request.getParameter("searchTerm");
    String searchSqlClause = "";
    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
        searchSqlClause = " WHERE q.Subject LIKE ? OR q.QuestionText LIKE ?";
    }

    // Pagination/Limiting for questions
    int questionLimit = 15; // Display up to 15 recent questions by default

    // List to hold questions and their replies
    List<List<Object>> questionsWithReplies = new ArrayList<>();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DatabaseUtils.getConnection();

        // Fetch questions with a LIMIT clause
        String questionsSql = "SELECT q.QuestionID, q.Subject, q.QuestionText, q.Timestamp, u.Username, q.Status " +
                              "FROM questions q JOIN users u ON q.CustomerID = u.CustomerID" + searchSqlClause +
                              " ORDER BY q.Timestamp DESC LIMIT ?";
        ps = conn.prepareStatement(questionsSql);
        int paramIndex = 1;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            ps.setString(paramIndex++, "%" + searchTerm + "%");
            ps.setString(paramIndex++, "%" + searchTerm + "%");
        }
        ps.setInt(paramIndex, questionLimit);
        rs = ps.executeQuery();

        while (rs.next()) {
            int questionId = rs.getInt("QuestionID");
            String subject = rs.getString("Subject");
            String questionText = rs.getString("QuestionText");
            Timestamp questionTimestamp = rs.getTimestamp("Timestamp");
            String questionerUsername = rs.getString("Username");
            String status = rs.getString("Status");

            List<Object> questionData = new ArrayList<>();
            questionData.add(questionId);
            questionData.add(subject);
            questionData.add(questionText);
            questionData.add(questionTimestamp);
            questionData.add(questionerUsername);
            questionData.add(status);

            // Fetch replies for this question - now strictly joining with employees table
            List<List<Object>> repliesForQuestion = new ArrayList<>();
            PreparedStatement psReplies = conn.prepareStatement(
                "SELECT r.ReplyID, r.ReplyText, r.Timestamp, e.username AS replierUsername " + // Get employee's username
                "FROM replies r JOIN employees e ON r.EmployeeSSN_FK = e.ssn " + // Direct join on ssn
                "WHERE r.QuestionID_FK = ? ORDER BY r.Timestamp ASC");
            psReplies.setInt(1, questionId);
            ResultSet rsReplies = psReplies.executeQuery();
            while (rsReplies.next()) {
                List<Object> replyData = new ArrayList<>();
                replyData.add(rsReplies.getInt("ReplyID"));
                replyData.add(rsReplies.getString("ReplyText"));
                replyData.add(rsReplies.getTimestamp("Timestamp"));
                replyData.add(rsReplies.getString("replierUsername")); // Use the alias
                repliesForQuestion.add(replyData);
            }
            rsReplies.close();
            psReplies.close();

            questionData.add(repliesForQuestion);
            questionsWithReplies.add(questionData);
        }

    } catch (SQLException e) {
        e.printStackTrace();
        message = "Error loading forum data: " + e.getMessage();
        messageType = "error";
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Service Forum</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin:0; padding:0; }
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Roboto', sans-serif;
      background: url('chatroom.jpg') no-repeat center center fixed;
      background-size: cover;
    }

    .container {
      background: #0a2540;
      color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.4);
      width: 95%;
      max-width: 900px;
      padding: 32px;
      margin: 20px auto;
      display: flex;
      flex-direction: column;
      min-height: calc(100vh - 40px);
      animation: fadeIn 0.8s ease-out;
    }

    h1 {
      font-size: 1.75rem;
      margin-bottom: 24px;
      text-align: center;
      color: #FFC947;
    }

    .message {
      padding: 10px;
      margin-bottom: 20px;
      border-radius: 5px;
      text-align: center;
      font-weight: 500;
    }
    .message.success {
      background-color: #28a745;
      color: white;
    }
    .message.error {
      background-color: #dc3545;
      color: white;
    }

    .form-section {
        background: rgba(0,0,0,0.3);
        padding: 25px;
        border-radius: 8px;
        margin-bottom: 30px;
    }
    .form-section h2 {
        font-size: 1.4rem;
        margin-bottom: 20px;
        color: #FFC947;
        text-align: center;
    }
    .input-group {
        margin-bottom: 15px;
    }
    .input-group label {
        display: block;
        margin-bottom: 5px;
        font-size: 0.9rem;
        color: rgba(255,255,255,0.8);
    }
    .input-group input[type="text"],
    .input-group textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 5px;
        background: rgba(255,255,255,0.1);
        color: #fff;
        font-size: 1rem;
    }
    .input-group textarea {
        min-height: 80px;
        resize: vertical;
    }
    .input-group input::placeholder, .input-group textarea::placeholder {
        color: rgba(255,255,255,0.5);
    }

    .btn {
        padding: 10px 20px;
        border-radius: 20px;
        text-decoration: none;
        font-weight: 500;
        box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        transition: background .2s, transform .2s;
        cursor: pointer;
        border: none;
        color: #0A2540;
        background: #FFC947;
    }
    .btn:hover {
        background: #f06552;
        transform: translateY(-2px);
    }
    .btn-secondary {
        background: #6c757d;
        color: #fff;
    }
    .btn-secondary:hover {
        background: #5a6268;
    }

    .forum-questions {
        margin-top: 30px;
        flex-grow: 1;
    }
    .question-card {
        background: rgba(255,255,255,0.08);
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
    .question-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        padding-bottom: 10px;
    }
    .question-header h3 {
        font-size: 1.2rem;
        color: #FFC947;
    }
    .question-meta {
        font-size: 0.85rem;
        color: rgba(255,255,255,0.6);
    }
    .question-body {
        font-size: 1rem;
        line-height: 1.5;
        margin-bottom: 15px;
    }
    .question-status {
        font-weight: 500;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 0.8rem;
        margin-left: 10px;
    }
    .question-status.Open {
        background-color: #e74c3c;
    }
    .question-status.Answered {
        background-color: #2ecc71;
    }
    .question-status.Closed {
        background-color: #6c757d;
    }

    .btn-reply {
        background-color: #007bff;
        color: white;
        padding: 6px 12px;
        border-radius: 15px;
        font-size: 0.85rem;
        font-weight: 500;
        cursor: pointer;
        border: none;
        transition: background-color .2s;
    }
    .btn-reply:hover {
        background-color: #0056b3;
    }

    .replies-section {
        margin-top: 15px;
        padding-left: 20px;
        border-left: 2px solid rgba(255,255,255,0.2);
    }
    .reply-card {
        background: rgba(255,255,255,0.05);
        padding: 15px;
        border-radius: 6px;
        margin-bottom: 10px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.1);
    }
    .reply-meta {
        font-size: 0.8rem;
        color: rgba(255,255,255,0.5);
        margin-bottom: 5px;
    }
    .reply-body {
        font-size: 0.9rem;
        line-height: 1.4;
    }

    .reply-form-container {
        margin-top: 15px;
        padding-top: 15px;
        border-top: 1px solid rgba(255,255,255,0.1);
        width: 100%;
    }
    .reply-form-container textarea {
        margin-bottom: 10px;
        width: 100%;
        padding: 10px;
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 5px;
        background: rgba(255,255,255,0.1);
        color: #fff;
        font-size: 1rem;
        min-height: 80px;
        resize: vertical;
    }
    .reply-form-container button {
        width: auto;
        padding: 8px 15px;
        font-size: 0.9rem;
    }

    @keyframes fadeIn {
      from { opacity:0; transform: translateY(-20px); }
      to   { opacity:1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Customer Service Forum</h1>

    <% if (message != null) { %>
      <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="form-section">
      <h2>Search Questions</h2>
      <form action="customer_service_forum.jsp" method="get">
        <div class="input-group">
          <input type="text" name="searchTerm" placeholder="Search by subject or keywords..." value="<%= searchTerm != null ? searchTerm : "" %>">
        </div>
        <button type="submit" class="btn">Search</button>
      </form>
    </div>

    <div class="form-section">
      <h2>Ask a New Question</h2>
      <form action="customerService" method="post">
        <input type="hidden" name="action" value="askQuestion">
        <div class="input-group">
          <label for="subject">Subject:</label>
          <input type="text" name="subject" id="subject" required>
        </div>
        <div class="input-group">
          <label for="questionText">Your Question:</label>
          <textarea name="questionText" id="questionText" required></textarea>
        </div>
        <button type="submit" class="btn">Submit Question</button>
      </form>
    </div>

    <div class="forum-questions">
      <h2>All Questions (<%= questionsWithReplies.size() %>)</h2>
      <% if (questionsWithReplies.isEmpty()) { %>
        <p style="text-align: center; color: rgba(255,255,255,0.7);">No questions found <%= searchTerm != null && !searchTerm.trim().isEmpty() ? "for '" + searchTerm + "'" : "" %>.</p>
      <% } else { %>
        <% for (List<Object> qData : questionsWithReplies) { %>
          <div class="question-card">
            <div class="question-header">
              <h3><%= qData.get(1) %></h3>
              <% if (isCustomerRep) { %>
                <span class="question-status <%= qData.get(5) %>"><%= qData.get(5) %></span>
                <% if ("Open".equals(qData.get(5))) { %>
                    <button type="button" class="btn-reply" onclick="toggleReplyForm(<%= qData.get(0) %>)">Reply</button>
                <% } %>
              <% } else { %>
                <span class="question-status <%= qData.get(5) %>"><%= qData.get(5) %></span>
              <% } %>
            </div>
            <div class="question-meta">
              Asked by <%= qData.get(4) %> on <%= qData.get(3) %>
            </div>
            <div class="question-body">
              <%= qData.get(2) %>
            </div>

            <% List<List<Object>> replies = (List<List<Object>>) qData.get(6); %>
            <% if (!replies.isEmpty()) { %>
              <div class="replies-section">
                <h4>Replies:</h4>
                <% for (List<Object> rData : replies) { %>
                  <div class="reply-card">
                    <div class="reply-meta">
                      Replied by <%= rData.get(3) %> on <%= rData.get(2) %>
                    </div>
                    <div class="reply-body">
                      <%= rData.get(1) %>
                    </div>
                  </div>
                <% } %>
              </div>
            <% } %>

            <% if (isCustomerRep) { %>
              <div class="reply-form-container" id="replyForm_<%= qData.get(0) %>" style="display:none;">
                <form action="customerService" method="post">
                  <input type="hidden" name="action" value="replyQuestion">
                  <input type="hidden" name="questionId" value="<%= qData.get(0) %>">
                  <textarea name="replyText" placeholder="Type your reply here..." required></textarea>
                  <button type="submit" class="btn">Submit Reply</button>
                </form>
              </div>
            <% } %>
          </div>
        <% } %>
      <% } %>
    </div>

    <%
        String backLink = "welcome.jsp";
        if (isCustomerRep) {
            backLink = "rep_dashboard.jsp";
        }
    %>
    <a href="<%= backLink %>" class="btn btn-secondary" style="margin-top: 30px;">Back to Dashboard</a>
  </div>

  <script>
    function toggleReplyForm(questionId) {
        const form = document.getElementById('replyForm_' + questionId);
        if (form.style.display === 'none') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }
  </script>
</body>
</html>