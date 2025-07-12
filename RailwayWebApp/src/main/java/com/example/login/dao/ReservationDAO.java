package com.example.login.dao;

import com.example.login.ReservationDetail;
import com.example.login.DatabaseUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    /** Utility to get a JDBC Connection */
    private Connection getConnection() throws SQLException {
        return DatabaseUtils.getConnection();
    }

    /**
     * Returns all reservations matching exactly the given transit line name.
     */
    public List<ReservationDetail> findByLineName(String lineName) throws SQLException {
        String sql =
            "SELECT " +
            "  r.id, " +
            "  CONCAT(u.firstName, ' ', u.lastName) AS customerName, " +
            "  r.line_name, " +
            "  r.train, " +
            "  r.travel_date, " +
            "  r.seat_id, " +
            "  r.total_fare, " +
            "  r.departure_time, " +
            "  r.reservation_date, " +
            "  r.passenger_type, " +
            "  r.trip_type " +
            "FROM reservations r " +
            "JOIN users u ON r.user_id = u.CustomerID " +
            "WHERE r.line_name = ? " +
            "ORDER BY r.travel_date";

        List<ReservationDetail> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lineName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReservationDetail rd = new ReservationDetail();
                    rd.setId(rs.getInt("id"));
                    rd.setCustomerName(rs.getString("customerName"));
                    rd.setLineName(rs.getString("line_name"));
                    rd.setTrain(rs.getString("train"));
                    rd.setTravelDate(rs.getDate("travel_date").toLocalDate());
                    rd.setSeatId(rs.getString("seat_id"));
                    rd.setTotalFare(rs.getBigDecimal("total_fare"));
                    rd.setDepartureTime(rs.getTime("departure_time").toLocalTime());
                    rd.setReservationDate(rs.getDate("reservation_date").toLocalDate());
                    rd.setPassengerType(rs.getString("passenger_type"));
                    rd.setTripType(rs.getString("trip_type"));
                    list.add(rd);
                }
            }
        }
        return list;
    }

    /**
     * Returns all reservations whose customer's full name matches the given pattern.
     */
    public List<ReservationDetail> findByCustomerName(String namePattern) throws SQLException {
        String sql =
            "SELECT " +
            "  r.id, " +
            "  CONCAT(u.firstName, ' ', u.lastName) AS customerName, " +
            "  r.line_name, " +
            "  r.train, " +
            "  r.travel_date, " +
            "  r.seat_id, " +
            "  r.total_fare, " +
            "  r.departure_time, " +
            "  r.reservation_date, " +
            "  r.passenger_type, " +
            "  r.trip_type " +
            "FROM reservations r " +
            "JOIN users u ON r.user_id = u.CustomerID " +
            "WHERE CONCAT(u.firstName, ' ', u.lastName) LIKE ? " +
            "ORDER BY r.travel_date";

        List<ReservationDetail> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + namePattern + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReservationDetail rd = new ReservationDetail();
                    rd.setId(rs.getInt("id"));
                    rd.setCustomerName(rs.getString("customerName"));
                    rd.setLineName(rs.getString("line_name"));
                    rd.setTrain(rs.getString("train"));
                    rd.setTravelDate(rs.getDate("travel_date").toLocalDate());
                    rd.setSeatId(rs.getString("seat_id"));
                    rd.setTotalFare(rs.getBigDecimal("total_fare"));
                    rd.setDepartureTime(rs.getTime("departure_time").toLocalTime());
                    rd.setReservationDate(rs.getDate("reservation_date").toLocalDate());
                    rd.setPassengerType(rs.getString("passenger_type"));
                    rd.setTripType(rs.getString("trip_type"));
                    list.add(rd);
                }
            }
        }
        return list;
    }
}

