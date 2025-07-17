package com.example.login;

import java.sql.*;

public class DatabaseUtils {
  private static final String URL  = "jdbc:mysql://localhost:3306/login_project6";
  private static final String USER = "root";
  private static final String PASS = "Fla97456@";

  static {
    try {
      Class.forName("com.mysql.jdbc.Driver");
    } catch (ClassNotFoundException e) {
      throw new RuntimeException(e);
    }
  }

  public static Connection getConnection() throws SQLException {
    return DriverManager.getConnection(URL, USER, PASS);
  }
}

