package com.example.login;

import java.sql.Connection;
import java.sql.Date;           // **only** java.sql.Date
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScheduleDAO {

    /**
     * Pulls schedules (including their real line_code) from train_schedules
     * for the given origin→destination on the given date.
     */
    public List<Schedule> findSchedules(int originId,
                                        int destId,
                                        LocalDate date) throws SQLException {
        String sql =
          "SELECT id, train_id, origin_station_id, destination_station_id,"
        + "       departure_time, arrival_time, fare, line_code"
        + "  FROM train_schedules"
        + " WHERE origin_station_id      = ?"
        + "   AND destination_station_id = ?"
        + "   AND DATE(departure_time)   = ?"
        + " ORDER BY departure_time ASC";

        try (Connection conn = DatabaseUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt  (1, originId);
            ps.setInt  (2, destId);
            ps.setDate (3, Date.valueOf(date));

            try (ResultSet rs = ps.executeQuery()) {
                List<Schedule> list = new ArrayList<>();
                while (rs.next()) {
                    Schedule s = new Schedule();
                    s.setId                   (rs.getInt       ("id"));
                    s.setTrainId              (rs.getInt       ("train_id"));
                    s.setOriginStationId      (rs.getInt       ("origin_station_id"));
                    s.setDestinationStationId (rs.getInt       ("destination_station_id"));
                    s.setDepartureTime        (rs.getTimestamp ("departure_time"));
                    s.setArrivalTime          (rs.getTimestamp ("arrival_time"));
                    s.setFare                 (rs.getBigDecimal("fare"));

                    // ### read the real line_code ###
                    s.setLineCode             (rs.getInt       ("line_code"));

                    list.add(s);
                }
                return list;
            }
        }
    }

    /**
     * Returns a list of the four stops (station names + times) for a given line code.
     * Uses “outbound” order (Trenton→…→NY) or “inbound” (NY→…→Trenton) based on the boolean.
     */
    public List<Schedule> getStopsForLine(int lineCode, boolean inbound) {
        // Outbound route + base times @ line 4000
        List<String> outbound = Arrays.asList(
            "Trenton", "New Brunswick", "Newark Penn", "New York Penn"
        );
        Map<String,LocalTime> baseOut = Map.of(
            "Trenton",       LocalTime.of(8, 0),
            "New Brunswick", LocalTime.of(9, 0),
            "Newark Penn",   LocalTime.of(10,0),
            "New York Penn", LocalTime.of(11,0)
        );

        // Inbound route + base times @ line 4000
        List<String> inboundRoute = Arrays.asList(
            "New York Penn", "Newark Penn", "New Brunswick", "Trenton"
        );
        Map<String,LocalTime> baseIn = Map.of(
            "New York Penn", LocalTime.of(14,0),
            "Newark Penn",   LocalTime.of(15,0),
            "New Brunswick", LocalTime.of(16,0),
            "Trenton",       LocalTime.of(17,0)
        );

        // Offset = how many hours beyond the base-4000 schedule
        int offset = Math.max(0, lineCode - 4000);

        List<Schedule> stops = new ArrayList<>();
        List<String> route = inbound ? inboundRoute : outbound;
        Map<String,LocalTime> base = inbound ? baseIn : baseOut;

        for (String station : route) {
            LocalTime depart = base.getOrDefault(station, LocalTime.MIDNIGHT)
                                   .plusHours(offset);
            LocalTime arrive = depart.plusHours(1);

            Schedule s = new Schedule();
            s.setStationName   (station);
            s.setDepartureTime (Time.valueOf(depart));
            s.setArrivalTime   (Time.valueOf(arrive));
            stops.add(s);
        }
        return stops;
    }
}


