CREATE DATABASE  IF NOT EXISTS `login_project6` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `login_project6`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: login_project6
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `ssn` varchar(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','customer_representative') NOT NULL,
  PRIMARY KEY (`ssn`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES ('000-00-0000','Site','Admin','admin1','admin','admin'),('001-00-0000','Romaan','Roshan','romaan24','secret','customer_representative'),('002-00-1000','Marc','Andre','marct','boss','customer_representative');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `QuestionID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` int NOT NULL,
  `Subject` varchar(255) NOT NULL,
  `QuestionText` text NOT NULL,
  `Timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `Status` varchar(20) DEFAULT 'Open',
  PRIMARY KEY (`QuestionID`),
  KEY `CustomerID` (`CustomerID`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `users` (`CustomerID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,1,'Line 4000 depart','testing','2025-07-16 10:04:02','Answered');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `replies`
--

DROP TABLE IF EXISTS `replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `replies` (
  `ReplyID` int NOT NULL AUTO_INCREMENT,
  `QuestionID_FK` int NOT NULL,
  `EmployeeSSN_FK` varchar(11) NOT NULL,
  `ReplyText` text NOT NULL,
  `Timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ReplyID`),
  KEY `QuestionID_FK` (`QuestionID_FK`),
  KEY `EmployeeSSN_FK` (`EmployeeSSN_FK`),
  CONSTRAINT `replies_ibfk_employee` FOREIGN KEY (`EmployeeSSN_FK`) REFERENCES `employees` (`ssn`) ON DELETE CASCADE,
  CONSTRAINT `replies_ibfk_question` FOREIGN KEY (`QuestionID_FK`) REFERENCES `questions` (`QuestionID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `replies`
--

LOCK TABLES `replies` WRITE;
/*!40000 ALTER TABLE `replies` DISABLE KEYS */;
INSERT INTO `replies` VALUES (1,1,'001-00-0000','works','2025-07-16 10:04:32');
/*!40000 ALTER TABLE `replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`CustomerID`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`train`) REFERENCES `trains` (`name`),
  CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`line_name`) REFERENCES `transitline` (`line_name`),
  CONSTRAINT `reservations_ibfk_4` FOREIGN KEY (`origin_station_id`) REFERENCES `station` (`station_id`),
  CONSTRAINT `reservations_ibfk_5` FOREIGN KEY (`destination_station_id`) REFERENCES `station` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,3,'NJ TRANSIT','2025-07-10','B1',27.50,'16:00:00','2025-07-06','4005',4,1,'Adult','One-way'),(2,2,'AMTRAK','2025-07-15','A1',20.00,'10:00:00','2025-07-06','4001',3,2,'Adult','One-way'),(4,2,'AMTRAK','2025-07-30','A2',20.00,'10:00:00','2025-07-06','4001',3,2,'Adult','One-way'),(9,1,'NJ TRANSIT','2025-07-18','A1',19.25,'08:00:00','2025-07-08','4000',1,4,'Disabled','One-way'),(10,1,'NJ TRANSIT','2025-07-31','A2',10.50,'08:00:00','2025-07-08','4000',1,2,'Disabled','One-way'),(11,1,'AMTRAK','2025-07-17','A1',15.00,'08:00:00','2025-07-08','4000',2,4,'Child','One-way'),(24,11,'NJ TRANSIT','2025-07-12','A2',21.00,'08:00:00','2025-07-09','4000',1,2,'Disabled','Round-trip'),(25,1,'NJ TRANSIT','2025-05-08','A1',20.63,'08:00:00','2025-07-09','4000',1,4,'Senior','One-way'),(26,1,'AMTRAK','2025-06-19','B2',37.50,'16:00:00','2025-07-09','4005',1,3,'Senior','Round-trip'),(27,11,'NJ TRANSIT','2025-07-19','A2',60.00,'12:00:00','2025-07-11','4002',2,4,'Adult','Round-trip'),(28,11,'NJ TRANSIT','2025-07-26','A1',35.00,'14:00:00','2025-07-11','4003',1,3,'Disabled','Round-trip'),(29,1,'NJ TRANSIT','2025-07-17','A1',15.00,'08:00:00','2025-07-13','4000',1,2,'Adult','One-way'),(30,1,'NJ TRANSIT','2025-07-16','A2',16.50,'10:00:00','2025-07-13','4001',4,3,'Adult','One-way'),(31,1,'NJ TRANSIT','2025-07-31','A1',27.50,'19:00:00','2025-07-13','4005',1,4,'Adult','One-way'),(32,1,'NJ TRANSIT','2025-07-30','A1',13.75,'20:00:00','2025-07-13','4005',1,4,'Child','One-way'),(33,1,'NJ TRANSIT','2025-07-30','C2',60.00,'08:00:00','2025-07-14','4000',4,2,'Adult','Round-trip'),(34,2,'NJ TRANSIT','2025-07-16','A2',25.00,'09:00:00','2025-07-15','4000',3,1,'Adult','One-way');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `station_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `City` varchar(100) DEFAULT NULL,
  `State` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'Newark Penn','Newark','NJ'),(2,'New York Penn','New York','NY'),(3,'New Brunswick','New Brunswick','NJ'),(4,'Trenton','Trenton','NJ');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station_fares`
--

DROP TABLE IF EXISTS `station_fares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station_fares` (
  `origin_station_id` int NOT NULL,
  `destination_station_id` int NOT NULL,
  `fare` decimal(6,2) NOT NULL,
  PRIMARY KEY (`origin_station_id`,`destination_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  CONSTRAINT `station_fares_ibfk_1` FOREIGN KEY (`origin_station_id`) REFERENCES `station` (`station_id`),
  CONSTRAINT `station_fares_ibfk_2` FOREIGN KEY (`destination_station_id`) REFERENCES `station` (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station_fares`
--

LOCK TABLES `station_fares` WRITE;
/*!40000 ALTER TABLE `station_fares` DISABLE KEYS */;
INSERT INTO `station_fares` VALUES (1,2,15.00),(1,3,25.00),(1,4,27.50),(2,3,20.00),(2,4,30.00),(3,4,16.50);
/*!40000 ALTER TABLE `station_fares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_schedules`
--

DROP TABLE IF EXISTS `train_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `train_id` int NOT NULL,
  `origin_station_id` int NOT NULL,
  `destination_station_id` int NOT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `fare` decimal(10,2) NOT NULL,
  `line_code` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `train_id` (`train_id`),
  KEY `origin_station_id` (`origin_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  CONSTRAINT `train_schedules_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`id`),
  CONSTRAINT `train_schedules_ibfk_2` FOREIGN KEY (`origin_station_id`) REFERENCES `station` (`station_id`),
  CONSTRAINT `train_schedules_ibfk_3` FOREIGN KEY (`destination_station_id`) REFERENCES `station` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_schedules`
--

LOCK TABLES `train_schedules` WRITE;
/*!40000 ALTER TABLE `train_schedules` DISABLE KEYS */;
INSERT INTO `train_schedules` VALUES (1,2,3,2,'2025-07-14 14:01:00','2025-07-14 16:21:00',35.00,0),(2,2,1,2,'2025-07-14 10:00:00','2025-07-14 11:00:00',15.00,0),(4,2,4,3,'2025-07-15 08:00:00','2025-07-15 09:00:00',25.00,4000),(6,2,4,3,'2025-07-15 09:00:00','2025-07-15 10:00:00',31.00,4001),(8,1,4,1,'2025-07-15 08:00:00','2025-07-15 10:00:00',27.50,4000),(9,2,4,3,'2025-07-15 09:00:00','2025-07-15 10:00:00',16.50,4001),(10,2,4,1,'2025-07-15 09:00:00','2025-07-15 11:00:00',27.50,4001),(11,2,4,2,'2025-07-15 09:00:00','2025-07-15 12:00:00',30.00,4001),(12,2,3,1,'2025-07-15 10:00:00','2025-07-15 11:00:00',25.00,4001),(13,2,3,2,'2025-07-15 10:00:00','2025-07-15 12:00:00',20.00,4001),(14,2,1,2,'2025-07-15 11:00:00','2025-07-15 12:00:00',15.00,4001),(15,2,4,3,'2025-07-15 10:00:00','2025-07-15 11:00:00',16.50,4002),(16,2,4,1,'2025-07-15 10:00:00','2025-07-15 12:00:00',27.50,4002),(17,2,4,2,'2025-07-15 10:00:00','2025-07-15 13:00:00',30.00,4002),(18,2,3,1,'2025-07-15 11:00:00','2025-07-15 12:00:00',25.00,4002),(19,2,3,2,'2025-07-15 11:00:00','2025-07-15 13:00:00',20.00,4002),(20,2,1,2,'2025-07-15 12:00:00','2025-07-15 13:00:00',15.00,4002),(21,2,4,3,'2025-07-15 11:00:00','2025-07-15 12:00:00',16.50,4003),(22,2,4,1,'2025-07-15 11:00:00','2025-07-15 13:00:00',27.50,4003),(23,2,4,2,'2025-07-15 11:00:00','2025-07-15 14:00:00',30.00,4003),(24,2,3,1,'2025-07-15 12:00:00','2025-07-15 13:00:00',25.00,4003),(25,2,3,2,'2025-07-15 12:00:00','2025-07-15 14:00:00',20.00,4003),(26,2,1,2,'2025-07-15 13:00:00','2025-07-15 14:00:00',15.00,4003),(27,2,4,3,'2025-07-15 13:00:00','2025-07-15 14:00:00',16.50,4005),(28,2,4,1,'2025-07-15 13:00:00','2025-07-15 15:00:00',27.50,4005),(29,2,4,2,'2025-07-15 13:00:00','2025-07-15 16:00:00',30.00,4005),(30,2,3,1,'2025-07-15 14:00:00','2025-07-15 15:00:00',25.00,4005),(31,2,3,2,'2025-07-15 14:00:00','2025-07-15 16:00:00',20.00,4005),(32,2,1,2,'2025-07-15 15:00:00','2025-07-15 16:00:00',15.00,4005),(33,2,2,1,'2025-07-15 14:00:00','2025-07-15 15:00:00',15.00,4000),(34,2,2,3,'2025-07-15 14:00:00','2025-07-15 16:00:00',20.00,4000),(35,2,2,4,'2025-07-15 14:00:00','2025-07-15 17:00:00',30.00,4000),(36,2,1,3,'2025-07-15 15:00:00','2025-07-15 16:00:00',25.00,4000),(37,2,1,4,'2025-07-15 15:00:00','2025-07-15 17:00:00',27.50,4000),(38,2,3,4,'2025-07-15 16:00:00','2025-07-15 17:00:00',16.50,4000),(39,2,2,1,'2025-07-15 15:00:00','2025-07-15 16:00:00',15.00,4001),(40,2,2,3,'2025-07-15 15:00:00','2025-07-15 17:00:00',20.00,4001),(41,2,2,4,'2025-07-15 15:00:00','2025-07-15 18:00:00',30.00,4001),(42,2,1,3,'2025-07-15 16:00:00','2025-07-15 17:00:00',25.00,4001),(43,2,1,4,'2025-07-15 16:00:00','2025-07-15 18:00:00',27.50,4001),(44,2,3,4,'2025-07-15 17:00:00','2025-07-15 18:00:00',16.50,4001),(45,2,2,1,'2025-07-15 16:00:00','2025-07-15 17:00:00',15.00,4002),(46,2,2,3,'2025-07-15 16:00:00','2025-07-15 18:00:00',20.00,4002),(47,2,2,4,'2025-07-15 16:00:00','2025-07-15 19:00:00',30.00,4002),(48,2,1,3,'2025-07-15 17:00:00','2025-07-15 18:00:00',25.00,4002),(49,2,1,4,'2025-07-15 17:00:00','2025-07-15 19:00:00',27.50,4002),(50,2,3,4,'2025-07-15 18:00:00','2025-07-15 19:00:00',16.50,4002),(51,2,2,1,'2025-07-15 17:00:00','2025-07-15 18:00:00',15.00,4003),(52,2,2,3,'2025-07-15 17:00:00','2025-07-15 19:00:00',20.00,4003),(53,2,2,4,'2025-07-15 17:00:00','2025-07-15 20:00:00',30.00,4003),(54,2,1,3,'2025-07-15 18:00:00','2025-07-15 19:00:00',25.00,4003),(55,2,1,4,'2025-07-15 18:00:00','2025-07-15 20:00:00',27.50,4003),(56,2,3,4,'2025-07-15 19:00:00','2025-07-15 20:00:00',16.50,4003),(57,2,2,1,'2025-07-15 19:00:00','2025-07-15 20:00:00',15.00,4005),(58,2,2,3,'2025-07-15 19:00:00','2025-07-15 21:00:00',20.00,4005),(59,2,2,4,'2025-07-15 19:00:00','2025-07-15 22:00:00',30.00,4005),(60,2,1,3,'2025-07-15 20:00:00','2025-07-15 21:00:00',25.00,4005),(61,2,1,4,'2025-07-15 20:00:00','2025-07-15 22:00:00',27.50,4005),(62,2,3,4,'2025-07-15 21:00:00','2025-07-15 22:00:00',16.50,4005),(63,2,2,1,'2025-07-15 14:00:00','2025-07-15 15:00:00',15.00,4000),(64,2,2,3,'2025-07-15 14:00:00','2025-07-15 16:00:00',20.00,4000),(65,2,2,4,'2025-07-15 14:00:00','2025-07-15 17:00:00',30.00,4000),(66,2,1,3,'2025-07-15 15:00:00','2025-07-15 16:00:00',25.00,4000),(67,2,1,4,'2025-07-15 15:00:00','2025-07-15 17:00:00',27.50,4000),(68,2,3,4,'2025-07-15 16:00:00','2025-07-15 17:00:00',16.50,4000);
/*!40000 ALTER TABLE `train_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trains` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_trains_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trains`
--

LOCK TABLES `trains` WRITE;
/*!40000 ALTER TABLE `trains` DISABLE KEYS */;
INSERT INTO `trains` VALUES (2,'AMTRAK'),(1,'NJ TRANSIT');
/*!40000 ALTER TABLE `trains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transitline`
--

DROP TABLE IF EXISTS `transitline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transitline` (
  `line_name` varchar(100) NOT NULL,
  `route_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`line_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transitline`
--

LOCK TABLES `transitline` WRITE;
/*!40000 ALTER TABLE `transitline` DISABLE KEYS */;
INSERT INTO `transitline` VALUES ('4000',NULL),('4001',NULL),('4002',NULL),('4003',NULL),('4005',NULL);
/*!40000 ALTER TABLE `transitline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `CustomerID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'customer',
  PRIMARY KEY (`CustomerID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Romaan','Roshan',NULL,'ROMAAN','secret','customer'),(2,'Sara','AbuelKhair',NULL,'SARA','secret1','customer'),(3,'Daniel','Liu',NULL,'DANIEL','secret2','customer'),(4,'Pranjal','Patel',NULL,'PRANJAL','secret3','customer'),(5,'','',NULL,'ADMIN','admin','admin'),(6,'','',NULL,'MIKE','secret5','customer'),(7,'','',NULL,'MARK','secret6','customer'),(8,'','',NULL,'RONALDO','UCL5','customer'),(9,'','',NULL,'RASHFORD','secret9','customer'),(10,'','',NULL,'SERGIO','ramos','customer'),(11,'Miranda','Garcia','amg@gmail.com','amg','336','customer'),(20,'Pogba','Paul',NULL,'pogba','manu','cust.rep');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-17 15:57:06
