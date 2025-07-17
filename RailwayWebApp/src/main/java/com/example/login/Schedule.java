package com.example.login;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.sql.Time;

public class Schedule {
    private int id;
    private int trainId;
    private int originStationId;
    private int destinationStationId;
    private Timestamp departureTime;
    private Timestamp arrivalTime;
    private BigDecimal fare;

    // For scheduleDetails
    private String stationName;
    private String lineName;

    public Schedule() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTrainId() { return trainId; }
    public void setTrainId(int trainId) { this.trainId = trainId; }

    public int getOriginStationId() { return originStationId; }
    public void setOriginStationId(int originStationId) { this.originStationId = originStationId; }

    public int getDestinationStationId() { return destinationStationId; }
    public void setDestinationStationId(int destinationStationId) { this.destinationStationId = destinationStationId; }

    // Departure time: stored as Timestamp, but allow setting via Timestamp or Time
    public Timestamp getDepartureTime() { return departureTime; }
    public void setDepartureTime(Timestamp departureTime) { this.departureTime = departureTime; }
    public void setDepartureTime(Time departureTime) { 
        this.departureTime = departureTime != null
            ? new Timestamp(departureTime.getTime())
            : null;
    }

    // Arrival time: same overload
    public Timestamp getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Timestamp arrivalTime) { this.arrivalTime = arrivalTime; }
    public void setArrivalTime(Time arrivalTime) {
        this.arrivalTime = arrivalTime != null
            ? new Timestamp(arrivalTime.getTime())
            : null;
    }

    public BigDecimal getFare() { return fare; }
    public void setFare(BigDecimal fare) { this.fare = fare; }

    public String getStationName() { return stationName; }
    public void setStationName(String stationName) { this.stationName = stationName; }

public String getLineName() {
    return lineName;
}
public void setLineName(String lineName) {
    this.lineName = lineName;
}
private int lineCode;
public int getLineCode()              { return lineCode; }
public void setLineCode(int lineCode) { this.lineCode = lineCode; }
}

