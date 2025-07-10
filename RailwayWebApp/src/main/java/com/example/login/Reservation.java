package com.example.login;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

public class Reservation {
    private int id;
    private String train;
    private String lineName;
    private Date travelDate;
    private Time departureTime;
    private int originStationId;
    private int destinationStationId;
    private String seatId;
    private BigDecimal totalFare;
    private String passengerType;
    private Date reservationDate;

    // getters & setters
    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }
    public String getTrain()                { return train; }
    public void setTrain(String train)      { this.train = train; }
    public String getLineName()             { return lineName; }
    public void setLineName(String lineName){ this.lineName = lineName; }
    public Date getTravelDate()             { return travelDate; }
    public void setTravelDate(Date d)       { this.travelDate = d; }
    public Time getDepartureTime()          { return departureTime; }
    public void setDepartureTime(Time t)    { this.departureTime = t; }
    public int getOriginStationId()         { return originStationId; }
    public void setOriginStationId(int o)   { this.originStationId = o; }
    public int getDestinationStationId()    { return destinationStationId; }
    public void setDestinationStationId(int d) { this.destinationStationId = d; }
    public String getSeatId()               { return seatId; }
    public void setSeatId(String s)         { this.seatId = s; }
    public BigDecimal getTotalFare()        { return totalFare; }
    public void setTotalFare(BigDecimal f)  { this.totalFare = f; }
    public String getPassengerType()        { return passengerType; }
    public void setPassengerType(String p)  { this.passengerType = p; }
    public Date getReservationDate()        { return reservationDate; }
    public void setReservationDate(Date d)  { this.reservationDate = d; }
}
