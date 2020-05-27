CREATE DATABASE  IF NOT EXISTS `warehouse` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_general_ci */;
USE `warehouse`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: dev.nginx.net    Database: warehouse
-- ------------------------------------------------------
-- Server version	5.7.28

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
-- Table structure for table `description`
--

DROP TABLE IF EXISTS `description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `description` (
  `sku` mediumint(8) unsigned NOT NULL,
  `name` text COLLATE latin1_general_ci,
  `summary` text COLLATE latin1_general_ci,
  `brand` text COLLATE latin1_general_ci,
  `type` text COLLATE latin1_general_ci,
  `country` varchar(2) COLLATE latin1_general_ci DEFAULT NULL,
  `region` text COLLATE latin1_general_ci,
  `style` text COLLATE latin1_general_ci,
  `size` decimal(6,1) unsigned DEFAULT NULL,
  `unit` varchar(2) COLLATE latin1_general_ci DEFAULT NULL,
  `asset` text COLLATE latin1_general_ci,
  `created` int(11) unsigned DEFAULT NULL,
  `updated` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `description`
--

LOCK TABLES `description` WRITE;
/*!40000 ALTER TABLE `description` DISABLE KEYS */;
INSERT INTO `description` VALUES (11249,'Barefoot Cellars Cabernet (1.5 L)','Fresh and easy, the Barefoot Cabernet drinks like a fun red; no time needed for this puppy to satisfy your palate; smooth in the finish.','Barefoot Cellars','Cabernet Sauvignon','US','California','Other',1.5,'L','11249.png',1541030400,NULL),(11251,'Barefoot Chardonnay (1.5 L)','A great Chardonnay to have in the fridge, the versatile Barefoot Chardonnay is so well made for its category; ripe, soft, and easy-to-drink.','Barefoot Cellars','Chardonnay','US','California','Other',1.5,'L','11251.png',1541030400,NULL),(28780,'Barefoot Merlot (1.5 L)','A crowd-pleaser, the soft and easy-drinking Barefoot Merlot is a red wine that will fit everyone\'s palate; a nicely focused effort.','Barefoot Cellars','Merlot','US','California','Other',1.5,'L','28780.png',1541030400,NULL),(28781,'Barefoot Chardonnay (750 ML)','GOLD MEDAL, BEST OF CLASS, 2011 SAN FRANCISCO CHRONICLE WINE COMP. Simply stunning, especially for the money! The Barefoot Chardonnay has it all; fresh core fruit flavors and superb structure.','Barefoot Cellars','Chardonnay','US','California','Other',750.0,'ML','28781.png',1541030400,NULL),(28782,'Barefoot Cabernet (750 ML)','Fresh and easy, the Barefoot Cabernet drinks like a fun red; no time need for this puppy to satisfy your palate; smooth in the finish.','Barefoot Cellars','Cabernet Sauvignon','US','California','Other',750.0,'ML','28782.png',1541030400,NULL),(65896,'Barefoot Bubbly Brut Cuvee (750 ML)','Barefoot Bubbly Brut Cuvee Champagne offers aromas and flavors of crisp green apple and freshly picked peach. Pear and lime flavors linger following the crisp, dry finish.','Barefoot Cellars','Champagne/Sparking','US','California','Brut',750.0,'ML','65896.png',1541030400,NULL),(81002,'Barefoot Bubbly Extra Dry (750 ML)','Barefoot Bubbly Extra Dry Champagne offers aromas of ripe apple complemented by hints of citrus. Toasty flavors complement the creamy, lingering finish.','Barefoot Cellars','Champagne/Sparking','US','California','Extra Dry',750.0,'ML','81002.png',1541030400,NULL),(84992,'Barefoot Cellars Moscato (750 ML)','A standout, aromatic white, the juicy and aromatic Barefoot Moscato opens up with expressive flowers and core fruit flavors; medium sweet finish.','Barefoot Cellars','Fortified/Dessert','US','California','Dessert Wine',750.0,'ML','84992.png',1541030400,NULL),(85838,'Barefoot Pinot Grigio (1.5 L)','Want to make the Italian wine industry jealous? Serve them the Barefoot Pinot Grigio; crisp, fresh, and frisky; a really fine example of the grape.','Barefoot Cellars','Pinot Grigio/Pinot Gris','US','California','Other',1.5,'L','85838.png',1541030400,NULL),(89531,'Barefoot Cellars Riesling (750 ML)','The Barefoot Riesling is a lovely wine with tasty aromas and flavors of refreshing tropical citrus fruit layered with delicious green apple and luscious peach; slightly sweet finish.','Barefoot Cellars','Riesling','US','California','Other',750.0,'ML','89531.png',1541030400,NULL),(91158,'Barefoot Bubbly Moscato Spumante (750 ML)','Barefoot Bubbly Moscato Spumante is sweet citrus in the bottle! This bubbly has aromas and flavors of jasmine & juicy tangerine. Enjoy the Mandarin orange flavors and the sweet lime finish!','Barefoot Cellars','Champagne/Sparking','US','California','Other',750.0,'ML','91158.png',1541030400,NULL),(95740,'Barefoot Bubbly Pink Moscato (750 ML)','Fresh, sweet, smooth, and delicious, the \"Pink\" is new and a must try!','Barefoot Cellars','Champagne/Sparking','US','California','Other',750.0,'ML','95740.png',1541030400,NULL);
/*!40000 ALTER TABLE `description` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory` (
  `sku` mediumint(8) unsigned NOT NULL,
  `quantity` smallint(5) unsigned DEFAULT NULL,
  `created` int(11) unsigned DEFAULT NULL,
  `updated` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (11249,1,1541030400,NULL),(11251,5,1541030400,NULL),(28780,3,1541030400,NULL),(28781,3,1541030400,NULL),(28782,9,1541030400,NULL),(65896,11,1541030400,NULL),(81002,17,1541030400,NULL),(84992,1,1541030400,NULL),(85838,3,1541030400,NULL),(89531,15,1541030400,NULL),(91158,2,1541030400,NULL),(95740,18,1541030400,NULL);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price`
--

DROP TABLE IF EXISTS `price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `price` (
  `sku` mediumint(8) unsigned NOT NULL,
  `retail` decimal(7,2) unsigned DEFAULT NULL,
  `sale` decimal(7,2) unsigned DEFAULT NULL,
  `created` int(11) unsigned DEFAULT NULL,
  `updated` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price`
--

LOCK TABLES `price` WRITE;
/*!40000 ALTER TABLE `price` DISABLE KEYS */;
INSERT INTO `price` VALUES (11249,11.99,9.99,1541030400,NULL),(11251,11.99,10.49,1541030400,NULL),(28780,11.99,10.49,1541030400,NULL),(28781,9.99,8.99,1541030400,NULL),(28782,10.99,9.49,1541030400,NULL),(65896,13.99,12.49,1541030400,NULL),(81002,13.99,12.49,1541030400,NULL),(84992,10.99,9.49,1541030400,NULL),(85838,11.99,10.49,1541030400,NULL),(89531,8.99,NULL,1541030400,NULL),(91158,13.99,12.49,1541030400,NULL),(95740,13.99,12.99,1541030400,NULL);
/*!40000 ALTER TABLE `price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating` (
  `sku` mediumint(8) unsigned NOT NULL,
  `score` decimal(2,1) unsigned DEFAULT NULL,
  `reviews` smallint(5) unsigned DEFAULT NULL,
  `created` int(11) unsigned DEFAULT NULL,
  `updated` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
INSERT INTO `rating` VALUES (11249,3.0,2,1541030400,NULL),(11251,NULL,NULL,1541030400,NULL),(28780,NULL,NULL,1541030400,NULL),(28781,5.0,1,1541030400,NULL),(28782,NULL,NULL,1541030400,NULL),(65896,3.0,1,1541030400,NULL),(81002,NULL,NULL,1541030400,NULL),(84992,NULL,NULL,1541030400,NULL),(85838,5.0,1,1541030400,NULL),(89531,4.5,4,1541030400,NULL),(91158,4.3,3,1541030400,NULL),(95740,5.0,1,1541030400,NULL);
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-08  2:18:41
