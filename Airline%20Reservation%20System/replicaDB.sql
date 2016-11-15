-- MySQL dump 10.13  Distrib 5.7.11, for Linux (x86_64)
--
-- Host: localhost    Database: replicaDB
-- ------------------------------------------------------
-- Server version	5.7.11-0ubuntu6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `airlineCompany`
--

DROP TABLE IF EXISTS `airlineCompany`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `airlineCompany` (
  `companyId` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(100) NOT NULL,
  PRIMARY KEY (`companyId`),
  UNIQUE KEY `companyName` (`companyName`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airlineCompany`
--

LOCK TABLES `airlineCompany` WRITE;
/*!40000 ALTER TABLE `airlineCompany` DISABLE KEYS */;
INSERT INTO `airlineCompany` VALUES (2,'Air Asia'),(1,'Air India'),(3,'Go Air'),(4,'Indigo'),(5,'Jet Airways'),(6,'SpiceJet');
/*!40000 ALTER TABLE `airlineCompany` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airplane`
--

DROP TABLE IF EXISTS `airplane`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `airplane` (
  `airplaneNumber` int(11) NOT NULL,
  `seatingCapacity` int(11) DEFAULT '100',
  `companyId` int(11) DEFAULT NULL,
  PRIMARY KEY (`airplaneNumber`),
  KEY `companyId` (`companyId`),
  CONSTRAINT `airplane_ibfk_1` FOREIGN KEY (`companyId`) REFERENCES `airlineCompany` (`companyId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airplane`
--

LOCK TABLES `airplane` WRITE;
/*!40000 ALTER TABLE `airplane` DISABLE KEYS */;
INSERT INTO `airplane` VALUES (1,100,1),(2,100,1),(3,100,2),(4,100,2),(5,100,3),(6,100,3),(7,100,4),(8,100,4),(9,100,5),(10,100,5),(11,100,6),(12,100,6);
/*!40000 ALTER TABLE `airplane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airport`
--

DROP TABLE IF EXISTS `airport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `airport` (
  `airportCode` int(11) NOT NULL AUTO_INCREMENT,
  `airportName` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`airportCode`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airport`
--

LOCK TABLES `airport` WRITE;
/*!40000 ALTER TABLE `airport` DISABLE KEYS */;
INSERT INTO `airport` VALUES (1,'Indira Gandhi International Airport','New Dehli','Dehli','India'),(2,'Chennai International Airport','Chennai','Tamilnadu','India'),(3,'Kempegowda International Airport','Bengaluru','Karnataka','India'),(4,'Netaji Subhaschandra Bose International Airport','Kolkatta','West Bengal','India'),(5,'Rajiv Gandhi International Airport','Hyderabad','Andhra Pradesh','India'),(6,'Sardar Vallabhai Patel International Airport','Ahmedabad','Gujarath','India'),(7,'Chhatrapati Shivaji International Airport','Mumbai','Maharashtra','India'),(8,'Dabolim International Airport','Panjim','Goa','India'),(9,'Trivedrum International Airport','Thiruvananthapuram','Kerala','India'),(10,'Raja Bhoj International Airport','Bhopal','Madhya Pradesh','India');
/*!40000 ALTER TABLE `airport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookedTickets`
--

DROP TABLE IF EXISTS `bookedTickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookedTickets` (
  `ticketId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `tripId` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `class` varchar(50) DEFAULT NULL,
  `seatNumbers` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`ticketId`),
  KEY `userId` (`userId`),
  KEY `tripId` (`tripId`),
  CONSTRAINT `bookedTickets_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`),
  CONSTRAINT `bookedTickets_ibfk_2` FOREIGN KEY (`tripId`) REFERENCES `schedule` (`tripId`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookedTickets`
--

LOCK TABLES `bookedTickets` WRITE;
/*!40000 ALTER TABLE `bookedTickets` DISABLE KEYS */;
INSERT INTO `bookedTickets` VALUES (113,1,1,2,'First','14 to 15'),(114,1,19,3,'First','13 to 15'),(115,1,4,2,'First','14 to 15'),(116,1,11,3,'Business','23 to 25'),(117,1,13,4,'Economy','57 to 60'),(118,1,15,4,'First','12 to 15'),(120,7,12,3,'Business','23 to 25'),(121,7,10,2,'Economy','59 to 60'),(122,7,15,5,'First','7 to 11'),(123,7,8,1,'Business','25'),(124,7,14,3,'First','13 to 15');
/*!40000 ALTER TABLE `bookedTickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `tripId` int(11) NOT NULL AUTO_INCREMENT,
  `airlineId` int(11) DEFAULT NULL,
  `airplaneId` int(11) DEFAULT NULL,
  `source` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `depart` date DEFAULT NULL,
  `arrival` date DEFAULT NULL,
  `economyClass` int(11) DEFAULT '60',
  `businessClass` int(11) DEFAULT '25',
  `firstClass` int(11) DEFAULT '15',
  `baseFare` int(11) DEFAULT NULL,
  PRIMARY KEY (`tripId`),
  KEY `airlineId` (`airlineId`),
  KEY `airplaneId` (`airplaneId`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`airlineId`) REFERENCES `airlineCompany` (`companyId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`airplaneId`) REFERENCES `airplane` (`airplaneNumber`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,1,1,'Bengaluru','Dehli','2016-11-09','2016-09-11',60,25,13,3000),(3,2,3,'Bengaluru','Dehli','2016-11-09','2016-11-09',60,25,15,3000),(4,1,2,'Chennai','Dehli','2016-11-09','2016-11-09',60,25,13,3500),(5,2,4,'Hyderabad','Dehli','2016-11-09','2016-11-09',60,25,15,3000),(6,3,5,'Mumbai','Dehli','2016-11-09','2016-11-09',60,25,15,3500),(7,4,7,'Mumbai','Dehli','2016-11-09','2016-11-09',60,25,15,2500),(8,3,6,'Bengaluru','Mumbai','2016-11-09','2016-11-09',60,24,15,2500),(9,4,8,'Kolkatta','Mumbai','2016-11-09','2016-11-09',60,25,15,4000),(10,5,9,'Thiruvananthapuram','Ahmedabad','2016-11-09','2016-11-09',58,25,15,3000),(11,6,11,'Panjim','Bhopal','2016-11-09','2016-11-09',60,22,15,4000),(12,5,10,'Panjim','Delhi','2016-11-09','2016-11-09',60,22,15,4000),(13,6,12,'Thiruvananthapuram','Hyderabad','2016-11-09','2016-11-09',56,25,15,3500),(14,1,1,'Bengaluru','Dehli','2016-11-11','2016-11-11',60,25,12,3000),(15,2,3,'Bengaluru','Dehli','2016-11-11','2016-11-11',60,25,6,3000),(16,1,2,'Chennai','Dehli','2016-11-11','2016-11-11',60,25,15,3500),(17,2,4,'Hyderabad','Dehli','2016-11-11','2016-11-11',60,25,15,3000),(18,3,5,'Mumbai','Dehli','2016-11-11','2016-11-11',60,25,15,3500),(19,4,7,'Mumbai','Dehli','2016-11-11','2016-11-11',60,25,12,2500),(20,3,6,'Bengaluru','Mumbai','2016-11-11','2016-11-11',60,25,15,2500),(21,4,8,'Kolkatta','Mumbai','2016-11-11','2016-11-11',60,25,15,4000),(22,5,9,'Thiruvananthapuram','Ahmedabad','2016-11-11','2016-11-11',60,25,15,3000),(23,6,11,'Panjim','Bhopal','2016-11-11','2016-11-11',60,25,15,4000),(24,5,9,'Thiruvananthapuram','Hyderabad','2016-11-11','2016-11-11',60,25,15,3500),(25,5,10,'Panjim','Dehli','2016-11-11','2016-11-11',60,25,15,4000);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Teddy Winters','deyagondsamarth@gmail.com','samarth'),(2,'Samarth Deyagond','coder@gmail.com','samarth'),(3,'Rachana Kalachetty','Cneil@fbi.com','neil'),(4,'Manimala','manimala@sjce.sc.in','manimala'),(5,'Nick Halden','neil@fbi.com','neil'),(6,'Sagar Deyagond','deyagondsagar@gmail.com','Sagar'),(7,'rachs','rachsdemilovato@gmail.com','1234'),(8,'Adithi Reddy','adithi@gmail.com','adithi');
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

-- Dump completed on 2016-11-15 20:40:30
