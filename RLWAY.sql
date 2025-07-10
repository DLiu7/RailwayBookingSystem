-- Drop the database if it exists to ensure a clean start
DROP DATABASE IF EXISTS `login_project`;

-- Create the database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS `login_project`;

-- Use the newly created or existing database
USE `login_project`;

-- Table structure for table `users`
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'customer',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `users`
INSERT INTO `users` VALUES (1,'ROMAAN','secret','customer'),(2,'SARA','secret1','customer'),(3,'DANIEL','secret2','customer'),(4,'PRANJAL','secret3','customer'),(5,'ADMIN','admin','admin'),(6,'MIKE','secret5','customer'),(7,'MARK','secret6','customer'),(8,'RONALDO','UCL5','customer'),(9,'RASHFORD','secret9','customer'),(10,'SERGIO','ramos','customer');

-- Insert an Admin account
-- Username: admin_user
-- Password: admin_password (You can change this password)
-- Role: admin
INSERT INTO `users` (`username`, `password`, `role`) VALUES
('Admin User', 'admin', 'admin');

-- Insert a Customer Representative account
-- Username: rep_user
-- Password: rep_password (You can change this password)
-- Role: customer_rep
INSERT INTO `users` (`username`, `password`, `role`) VALUES
('Customer Representative', 'representative', 'customer_rep');

-- Table structure for table `station`
DROP TABLE IF EXISTS `station`;
CREATE TABLE `station` (
  `station_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `station`
INSERT INTO `station` VALUES (1,'Newark Penn'),(2,'New York Penn'),(3,'New Brunswick'),(4,'Trenton');

-- Table structure for table `trains`
DROP TABLE IF EXISTS `trains`;
CREATE TABLE `trains` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_trains_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `trains`
INSERT INTO `trains` VALUES (2,'AMTRAK'),(1,'NJ TRANSIT');

-- Table structure for table `transitline`
DROP TABLE IF EXISTS `transitline`;
CREATE TABLE `transitline` (
  `line_name` varchar(100) NOT NULL,
  `route_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`line_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `transitline`
INSERT INTO `transitline` VALUES ('4000',NULL),('4001',NULL),('4002',NULL),('4003',NULL),('4005',NULL);

-- Table structure for table `reservations`
DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `train` varchar(50) NOT NULL,
  `travel_date` date NOT NULL,
  `seat_id` varchar(10) NOT NULL,
  `total_fare` decimal(6,2) DEFAULT NULL,
  `departure_time` time DEFAULT NULL,
  `reservation_date` date DEFAULT NULL,
  `line_name` varchar(100) DEFAULT NULL,
  `origin_station_id` int DEFAULT NULL,
  `destination_station_id` int DEFAULT NULL,
  `passenger_type` varchar(20) NOT NULL DEFAULT 'Adult',
  `trip_type` varchar(20) NOT NULL DEFAULT 'One-way',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `train` (`train`),
  KEY `line_name` (`line_name`),
  KEY `origin_station_id` (`origin_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`train`) REFERENCES `trains` (`name`),
  CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`line_name`) REFERENCES `transitline` (`line_name`),
  CONSTRAINT `reservations_ibfk_4` FOREIGN KEY (`origin_station_id`) REFERENCES `station` (`station_id`),
  CONSTRAINT `reservations_ibfk_5` FOREIGN KEY (`destination_station_id`) REFERENCES `station` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `reservations`
INSERT INTO `reservations` VALUES (1,3,'NJ TRANSIT','2025-07-10','B1',27.50,'16:00:00','2025-07-06','4005',4,1,'Adult','One-way'),(2,2,'AMTRAK','2025-07-15','A1',20.00,'10:00:00','2025-07-06','4001',3,2,'Adult','One-way'),(3,2,'NJ TRANSIT','2025-07-12','C2',16.50,'08:00:00','2025-07-06','4000',4,3,'Adult','One-way'),(4,2,'AMTRAK','2025-07-30','A2',20.00,'10:00:00','2025-07-06','4001',3,2,'Adult','One-way'),(5,4,'NJ TRANSIT','2025-07-20','A1',27.50,'12:00:00','2025-07-06','4002',4,1,'Adult','One-way'),(6,2,'NJ TRANSIT','2025-07-24','A1',30.00,'08:00:00','2025-07-08','4000',2,4,'Adult','One-way'),(7,7,'NJ TRANSIT','2025-07-12','A2',25.00,'08:00:00','2025-07-08','4000',1,3,'Adult','One-way'),(9,1,'NJ TRANSIT','2025-07-18','A1',19.25,'08:00:00','2025-07-08','4000',1,4,'Disabled','One-way'),(10,1,'NJ TRANSIT','2025-07-31','A2',10.50,'08:00:00','2025-07-08','4000',1,2,'Disabled','One-way'),(11,1,'AMTRAK','2025-07-17','A1',15.00,'08:00:00','2025-07-08','4000',2,4,'Child','One-way'),(18,1,'NJ TRANSIT','2025-07-01','C2',30.00,'10:00:00','2025-07-08','4001',1,2,'Adult','Round-trip'),(19,9,'NJ TRANSIT','2025-07-09','B1',40.00,'08:00:00','2025-07-08','4000',3,2,'Adult','Round-trip');

-- Table structure for table `station_fares`
DROP TABLE IF EXISTS `station_fares`;
CREATE TABLE `station_fares` (
  `origin_station_id` int NOT NULL,
  `destination_station_id` int NOT NULL,
  `fare` decimal(6,2) NOT NULL,
  PRIMARY KEY (`origin_station_id`,`destination_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  CONSTRAINT `station_fares_ibfk_1` FOREIGN KEY (`origin_station_id`) REFERENCES `station` (`station_id`),
  CONSTRAINT `station_fares_ibfk_2` FOREIGN KEY (`destination_station_id`) REFERENCES `station` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `station_fares`
INSERT INTO `station_fares` VALUES (1,2,15.00),(1,3,25.00),(1,4,27.50),(2,3,20.00),(2,4,30.00),(3,4,16.50);

-- Table for customer questions
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL, -- Foreign key to the 'users' table (the customer who asked)
    `subject` VARCHAR(255) NOT NULL, -- Subject line for the question
    `question_text` TEXT NOT NULL, -- The full text of the question
    `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP, -- When the question was asked
    `status` VARCHAR(20) DEFAULT 'Open', -- e.g., 'Open', 'Answered', 'Closed'
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table for replies to questions
DROP TABLE IF EXISTS `replies`;
CREATE TABLE `replies` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `question_id` INT NOT NULL, -- Foreign key to the 'questions' table
    `user_id` INT NOT NULL, -- Foreign key to the 'users' table (the customer rep who replied, or customer if they reply)
    `reply_text` TEXT NOT NULL, -- The full text of the reply
    `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP, -- When the reply was made
    PRIMARY KEY (`id`),
    FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `train_schedules`;
CREATE TABLE `train_schedules` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `train_id` INT NOT NULL, -- Foreign key to the 'trains' table
    `origin_station_id` INT NOT NULL, -- Foreign key to 'station' table (using station_id)
    `destination_station_id` INT NOT NULL, -- Foreign key to 'station' table (using station_id)
    `departure_time` DATETIME NOT NULL,
    `arrival_time` DATETIME NOT NULL,
    `fare` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`train_id`) REFERENCES `trains` (`id`),
    FOREIGN KEY (`origin_station_id`) REFERENCES `station` (`station_id`), -- Adjusted to 'station' table
    FOREIGN KEY (`destination_station_id`) REFERENCES `station` (`station_id`) -- Adjusted to 'station' table
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `train_schedules` (`train_id`, `origin_station_id`, `destination_station_id`, `departure_time`, `arrival_time`, `fare`) VALUES
(1, 1, 2, '2025-07-15 08:00:00', '2025-07-15 09:00:00', 15.00),
(1, 2, 1, '2025-07-15 10:00:00', '2025-07-15 11:00:00', 15.00),
(2, 3, 4, '2025-07-16 09:30:00', '2025-07-16 12:00:00', 16.50), -- Assuming AMTRAK (id 2)
(1, 4, 1, '2025-07-17 14:00:00', '2025-07-17 16:00:00', 27.50);
