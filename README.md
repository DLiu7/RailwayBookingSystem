# Railway Booking System

## Overview

The Railway Booking System is a foundational web application designed to manage user accounts, train schedules, and reservations for a railway network. Developed using JavaServer Pages (JSP) for the frontend, JDBC for database connectivity, and MySQL as the backend database, this project demonstrates core full-stack web development principles and database interaction. It's deployed and run on an Apache Tomcat server.

## Features

* **User Authentication:** Secure login and logout functionality for both customers and employees (representatives, managers) with session management.
* **Role-Based Access:** Basic differentiation for users (customer, representative, manager) with a unified dashboard for this initial version.
* **Database Management:** Stores and manages user credentials, train details, station information, transit lines, schedules, stops, questions, answers, and reservations.
* **Dynamic Content:** JSP pages dynamically generate content based on user sessions and data retrieved from the MySQL database.
* **Reservation Viewing:** Allows logged-in users to view their personal reservations, and provides an administrative view for all reservations.

## Technologies Used

* **Frontend:** HTML, CSS, JSP (JavaServer Pages)
* **Backend:** Java Servlets, JDBC (Java Database Connectivity)
* **Database:** MySQL
* **Server:** Apache Tomcat v9.0
* **Development Environment:** Eclipse IDE
* **Version Control:** Git

## Setup and Installation

To get a local copy of this project up and running, follow these steps:

### 1. Prerequisites

* **Java Development Kit (JDK):** Version 8 or higher.
* **Apache Tomcat Server:** Version 9.0.x.
* **MySQL Server:** Version 8.0.x.
* **MySQL JDBC Connector:** Download the `mysql-connector-j-x.x.x.jar` file.
* **Eclipse IDE:** With "Eclipse IDE for Enterprise Java and Web Developers" package (includes WTP - Web Tools Platform).

### 2. Database Setup

1.  **Create the Database:**
    Open your MySQL client (e.g., MySQL Workbench, command line) and execute the following:
    ```sql
    CREATE DATABASE IF NOT EXISTS login_project;
    ```
2.  **Import Schema and Data:**
    Navigate to the directory containing your SQL dump file (e.g., `RailwayDB.sql`) in your terminal and run:
    ```bash
    mysql -u root -p login_project < "RailwayDB.sql"
    ```
    (Enter your MySQL root password when prompted. Ensure the password in the dump file's `INSERT` statements matches the plain text passwords used by the application, e.g., 'secret', 'admin').

    **Note:** The application currently uses plain text password comparison for simplicity. In a production environment, passwords should always be hashed and salted.

### 3. Eclipse Project Setup

1.  **Import Project:**
    * Open Eclipse.
    * Go to `File > Import... > Maven > Existing Maven Projects` (if it's a Maven project) or `General > Existing Projects into Workspace`.
    * Browse to the root directory of your cloned `RailwayBookingSystem` project and import it.
2.  **Add MySQL JDBC Driver:**
    * Right-click on your project in "Package Explorer" > `Build Path > Configure Build Path...`.
    * Go to the `Libraries` tab.
    * Click `Add External JARs...` and select your `mysql-connector-j-x.x.x.jar` file.
    * Click `Apply` and `Close`.
3.  **Add Apache Tomcat Server Runtime:**
    * Right-click on your project in "Package Explorer" > `Properties`.
    * Go to `Java Build Path` > `Libraries` tab.
    * Click `Add Library...` > `Server Runtime` > `Next`.
    * Select your configured `Apache Tomcat v9.0` server.
    * Click `Finish`, then `Apply` and `Close`.
4.  **Configure Project Facets (Crucial for Servlet API):**
    * Right-click on your project > `Properties`.
    * Go to `Project Facets`.
    * Ensure `Dynamic Web Module` is checked (version 4.0).
    * Ensure `Java` is checked (version 1.8 or higher).
    * Click on `Runtimes` (or "Further configuration available...") and ensure `Apache Tomcat v9.0` is checked.
    * Click `OK`, then `Apply and Close`.

### 4. Deploy and Run

1.  **Add Project to Tomcat Server:**
    * In Eclipse's "Servers" view (Window > Show View > Servers), right-click on your `Apache Tomcat v9.0 Server at localhost`.
    * Select `Add and Remove...`.
    * Move your `RailwayBookingSystem` project from "Available" to "Configured" and click `Finish`.
2.  **Clean and Publish:**
    * Right-click on the Tomcat server in the "Servers" view.
    * Select `Clean Tomcat Work Directory...`.
    * Select `Publish`.
3.  **Start the Server:**
    * Right-click on the Tomcat server and select `Start`.
4.  **Access the Application:**
    * Open your web browser and navigate to:
        `http://localhost:8080/RailwayBookingSystem/login2.jsp`

## Usage

Once the application is running, you can log in using the sample credentials from the `login_project` database:


## Database Schema

The `login_project` database consists of the following tables:

* **`users`**: Stores user authentication details (id, username, password).
* **`trains`**: Stores information about available trains (id, name).
* **`reservations`**: Stores booking details, linked to users and trains (id, user_id, train, travel_date, seat_id).

Refer to the `RailwayDB.sql` file for the complete schema and initial data.

## Screenshots

*(Optional: Add screenshots here to showcase the login page, dashboard, and reservations view. You can link image files from your repository.)*

---
