package com.example.login.dao;

import com.example.login.DatabaseUtils;

import java.math.BigDecimal;
import java.sql.*;
import java.time.YearMonth;
import java.util.LinkedHashMap;
import java.util.Map;

public class ReportDAO {
    private Connection getConnection() throws SQLException {
        return DatabaseUtils.getConnection();
    }

    /**
     * Returns a map from YearMonth → total_fare for that month in the given year.
     */
    public Map<YearMonth, BigDecimal> getMonthlySales(int year) throws SQLException {
        String sql =
          "SELECT DATE_FORMAT(travel_date, '%Y-%m') AS ym, "
        + "       SUM(total_fare) AS total_sales "
        + "  FROM reservations "
        + " WHERE YEAR(travel_date) = ? "
        + " GROUP BY ym "
        + " ORDER BY ym";

        Map<YearMonth, BigDecimal> result = new LinkedHashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    YearMonth ym = YearMonth.parse(rs.getString("ym"));
                    result.put(ym, rs.getBigDecimal("total_sales"));
                }
            }
        }
        return result;
    }

    /**
     * Revenue grouped by transit line.
     * @return LinkedHashMap<lineName, revenue>
     */
    public Map<String, BigDecimal> getRevenueByLine() throws SQLException {
        String sql =
          "SELECT line_name, SUM(total_fare) AS revenue "
        + "  FROM reservations "
        + " GROUP BY line_name "
        + " ORDER BY line_name";

        Map<String, BigDecimal> map = new LinkedHashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("line_name"),
                        rs.getBigDecimal("revenue"));
            }
        }
        return map;
    }

    /**
     * Revenue grouped by customer (firstName + lastName).
     * @return LinkedHashMap<customerName, revenue>
     */
    public Map<String, BigDecimal> getRevenueByCustomer() throws SQLException {
        String sql =
          "SELECT CONCAT(u.firstName,' ',u.lastName) AS customerName, "
        + "       SUM(r.total_fare)            AS revenue "
        + "  FROM reservations r "
        + "  JOIN users u ON r.user_id = u.CustomerID "
        + " GROUP BY u.CustomerID, customerName "
        + " ORDER BY revenue DESC";

        Map<String, BigDecimal> map = new LinkedHashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("customerName"),
                        rs.getBigDecimal("revenue"));
            }
        }
        return map;
    }

    /**
     * Finds the single best customer by total spend.
     * @return "Name (US$amount)" or "—" if none
     */
    public String getBestCustomer() throws SQLException {
        String sql =
          "SELECT CONCAT(u.firstName,' ',u.lastName) AS cust, "
        + "       SUM(r.total_fare)            AS revenue "
        + "  FROM reservations r "
        + "  JOIN users u ON r.user_id = u.CustomerID "
        + " GROUP BY u.CustomerID "
        + " ORDER BY revenue DESC "
        + " LIMIT 1";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String name = rs.getString("cust");
                BigDecimal rev = rs.getBigDecimal("revenue");
                return name + " (US$" + rev + ")";
            }
        }
        return "—";
    }

    /**
     * Top‐5 transit lines by number of reservations.
     * @return LinkedHashMap<lineName, count>
     */
    public Map<String, Integer> getTop5TransitLines() throws SQLException {
        String sql =
          "SELECT line_name, COUNT(*) AS cnt "
        + "  FROM reservations "
        + " GROUP BY line_name "
        + " ORDER BY cnt DESC "
        + " LIMIT 5";

        Map<String, Integer> map = new LinkedHashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("line_name"),
                        rs.getInt("cnt"));
            }
        }
        return map;
    }
}

