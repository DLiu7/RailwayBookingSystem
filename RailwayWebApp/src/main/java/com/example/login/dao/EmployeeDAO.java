package com.example.login.dao;

import com.example.login.Employee;
import com.example.login.DatabaseUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    /** Get a JDBC connection from your utility */
    private Connection getConnection() throws SQLException {
        return DatabaseUtils.getConnection();
    }

    /** CREATE a new employee (admin or rep) */
    public void create(Employee e) throws SQLException {
        String sql = "INSERT INTO employees "
                   + "(ssn, first_name, last_name, username, password, role) "
                   + "VALUES (?,?,?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getSsn());
            ps.setString(2, e.getFirstName());
            ps.setString(3, e.getLastName());
            ps.setString(4, e.getUsername());
            ps.setString(5, e.getPassword());  // assume already hashed
            ps.setString(6, e.getRole());
            ps.executeUpdate();
        }
    }

    /** READ one employee by SSN */
    public Employee findBySsn(String ssn) throws SQLException {
        String sql = "SELECT * FROM employees WHERE ssn = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ssn);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee e = new Employee();
                    e.setSsn(rs.getString("ssn"));
                    e.setFirstName(rs.getString("first_name"));
                    e.setLastName(rs.getString("last_name"));
                    e.setUsername(rs.getString("username"));
                    e.setPassword(rs.getString("password"));
                    e.setRole(rs.getString("role"));
                    return e;
                }
            }
        }
        return null;
    }

    /** READ all customer representatives */
    public List<Employee> findReps() throws SQLException {
        String sql = "SELECT * FROM employees WHERE role = 'customer_representative'";
        List<Employee> reps = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Employee e = new Employee();
                e.setSsn(rs.getString("ssn"));
                e.setFirstName(rs.getString("first_name"));
                e.setLastName(rs.getString("last_name"));
                e.setUsername(rs.getString("username"));
                e.setPassword(rs.getString("password"));
                e.setRole(rs.getString("role"));
                reps.add(e);
            }
        }
        return reps;
    }

    /** UPDATE an existing employee’s info */
    public void update(Employee e) throws SQLException {
        String sql = "UPDATE employees SET "
                   + "first_name = ?, last_name = ?, "
                   + "username = ?, password = ? "
                   + "WHERE ssn = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getFirstName());
            ps.setString(2, e.getLastName());
            ps.setString(3, e.getUsername());
            ps.setString(4, e.getPassword());
            ps.setString(5, e.getSsn());
            ps.executeUpdate();
        }
    }

    /** DELETE a rep by SSN */
    public void delete(String ssn) throws SQLException {
        String sql = "DELETE FROM employees WHERE ssn = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ssn);
            ps.executeUpdate();
        }
    }
}
