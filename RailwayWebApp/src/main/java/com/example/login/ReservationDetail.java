package com.example.login;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

public class ReservationDetail {
    private int id;
    private String customerName;
    private String lineName;
    private String train;
    private LocalDate travelDate;
    private String seatId;
    private BigDecimal totalFare;
    private LocalTime departureTime;
    private LocalDate reservationDate;
    private String passengerType;
    private String tripType;

    // ---- Getters & Setters ----

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getLineName() {
        return lineName;
    }
    public void setLineName(String lineName) {
        this.lineName = lineName;
    }

    public String getTrain() {
        return train;
    }
    public void setTrain(String train) {
        this.train = train;
    }

    public LocalDate getTravelDate() {
        return travelDate;
    }
    public void setTravelDate(LocalDate travelDate) {
        this.travelDate = travelDate;
    }

    public String getSeatId() {
        return seatId;
    }
    public void setSeatId(String seatId) {
        this.seatId = seatId;
    }

    public BigDecimal getTotalFare() {
        return totalFare;
    }
    public void setTotalFare(BigDecimal totalFare) {
        this.totalFare = totalFare;
    }

    public LocalTime getDepartureTime() {
        return departureTime;
    }
    public void setDepartureTime(LocalTime departureTime) {
        this.departureTime = departureTime;
    }

    public LocalDate getReservationDate() {
        return reservationDate;
    }
    public void setReservationDate(LocalDate reservationDate) {
        this.reservationDate = reservationDate;
    }

    public String getPassengerType() {
        return passengerType;
    }
    public void setPassengerType(String passengerType) {
        this.passengerType = passengerType;
    }

    public String getTripType() {
        return tripType;
    }
    public void setTripType(String tripType) {
        this.tripType = tripType;
    }
}
