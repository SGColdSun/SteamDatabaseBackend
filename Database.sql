--
-- Database Structure
--
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
-- Table structure for table `Apps`
--

DROP TABLE IF EXISTS `Apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Apps` (
  `AppID` int(7) unsigned NOT NULL,
  `AppType` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(150) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'SteamDB Unknown App',
  `StoreName` varchar(150) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `LastKnownName` varchar(150) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `LastUpdated` int(11) DEFAULT NULL,
  `LastDepotUpdate` int(11) DEFAULT NULL,
  UNIQUE KEY `AppID` (`AppID`),
  KEY `AppType` (`AppType`),
  FULLTEXT KEY `Name` (`Name`,`StoreName`,`LastKnownName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AppsHistory`
--

DROP TABLE IF EXISTS `AppsHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AppsHistory` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) unsigned NOT NULL,
  `AppID` int(7) unsigned NOT NULL,
  `Time` int(11) DEFAULT NULL,
  `Action` enum('created_app','deleted_app','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) unsigned NOT NULL DEFAULT '0',
  `OldValue` mediumtext COLLATE utf8_bin NOT NULL,
  `NewValue` mediumtext COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `AppID` (`AppID`)
) ENGINE=InnoDB AUTO_INCREMENT=272195 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AppsInfo`
--

DROP TABLE IF EXISTS `AppsInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AppsInfo` (
  `AppID` int(7) unsigned NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `Value` mediumtext COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `AppID` (`AppID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AppsTypes`
--

DROP TABLE IF EXISTS `AppsTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AppsTypes` (
  `AppType` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varbinary(15) NOT NULL,
  `DisplayName` varchar(30) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`AppType`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Changelists`
--

DROP TABLE IF EXISTS `Changelists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Changelists` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) unsigned NOT NULL,
  `Date` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id` (`ChangeID`)
) ENGINE=InnoDB AUTO_INCREMENT=1755 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ChangelistsApps`
--

DROP TABLE IF EXISTS `ChangelistsApps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ChangelistsApps` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) unsigned NOT NULL,
  `AppID` int(11) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ChangeID` (`ChangeID`,`AppID`)
) ENGINE=InnoDB AUTO_INCREMENT=1307 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ChangelistsSubs`
--

DROP TABLE IF EXISTS `ChangelistsSubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ChangelistsSubs` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) unsigned NOT NULL,
  `SubID` int(11) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ChangeID` (`ChangeID`,`SubID`)
) ENGINE=InnoDB AUTO_INCREMENT=904 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Depots`
--

DROP TABLE IF EXISTS `Depots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Depots` (
  `DepotID` int(7) unsigned NOT NULL,
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'Unknown Depot',
  `BuildID` int(7) unsigned NOT NULL DEFAULT '0',
  `ManifestID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Displayed on the website, used for history',
  `LastManifestID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Only updated after file list was successfully updated',
  `LastUpdated` int(11) DEFAULT NULL,
  UNIQUE KEY `DepotID` (`DepotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DepotsFiles`
--

DROP TABLE IF EXISTS `DepotsFiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DepotsFiles` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `DepotID` int(7) unsigned NOT NULL,
  `File` varchar(255) COLLATE utf8_bin NOT NULL,
  `Hash` char(40) COLLATE utf8_bin NOT NULL DEFAULT '0000000000000000000000000000000000000000',
  `Size` bigint(20) unsigned NOT NULL,
  `Flags` int(5) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `File` (`DepotID`,`File`),
  KEY `DepotID` (`DepotID`)
) ENGINE=InnoDB AUTO_INCREMENT=46763 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DepotsHistory`
--

DROP TABLE IF EXISTS `DepotsHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DepotsHistory` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) unsigned NOT NULL,
  `DepotID` int(7) unsigned NOT NULL,
  `Time` int(11) DEFAULT NULL,
  `Action` enum('added','removed','modified','modified_flags','manifest_change','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `File` varchar(300) COLLATE utf8_bin NOT NULL,
  `OldValue` bigint(20) unsigned NOT NULL,
  `NewValue` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `DepotID` (`DepotID`)
) ENGINE=InnoDB AUTO_INCREMENT=18330 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DepotsKeys`
--

DROP TABLE IF EXISTS `DepotsKeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DepotsKeys` (
  `DepotID` int(7) unsigned NOT NULL,
  `Key` varchar(64) COLLATE utf8_bin NOT NULL,
  `LastUpdate` int(11) DEFAULT NULL,
  PRIMARY KEY (`DepotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GC`
--

DROP TABLE IF EXISTS `GC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GC` (
  `AppID` int(7) unsigned NOT NULL,
  `Status` varchar(80) COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ImportantApps`
--

DROP TABLE IF EXISTS `ImportantApps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ImportantApps` (
  `ID` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `AppID` int(7) unsigned NOT NULL,
  `Channel` varchar(50) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `AppID` (`AppID`,`Channel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ImportantSubs`
--

DROP TABLE IF EXISTS `ImportantSubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ImportantSubs` (
  `SubID` int(7) unsigned NOT NULL,
  UNIQUE KEY `AppID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `KeyNames`
--

DROP TABLE IF EXISTS `KeyNames`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `KeyNames` (
  `ID` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(120) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `Type` (`Type`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `KeyNamesSubs`
--

DROP TABLE IF EXISTS `KeyNamesSubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `KeyNamesSubs` (
  `ID` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(90) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `Type` (`Type`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PICSTokens`
--

DROP TABLE IF EXISTS `PICSTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PICSTokens` (
  `AppID` int(7) NOT NULL,
  `Token` bigint(20) unsigned NOT NULL,
  `Date` int(11) DEFAULT NULL,
  `CommunityID` bigint(17) unsigned NOT NULL,
  PRIMARY KEY (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `RSS`
--

DROP TABLE IF EXISTS `RSS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RSS` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) COLLATE utf8_bin NOT NULL,
  `Link` varchar(300) COLLATE utf8_bin NOT NULL,
  `Date` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Link` (`Link`(255))
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `StoreUpdateQueue`
--

DROP TABLE IF EXISTS `StoreUpdateQueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StoreUpdateQueue` (
  `ID` int(7) unsigned NOT NULL,
  `Type` enum('app','sub') COLLATE utf8_bin NOT NULL,
  `Date` int(11) DEFAULT NULL,
  UNIQUE KEY `ID` (`ID`,`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Subs`
--

DROP TABLE IF EXISTS `Subs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Subs` (
  `SubID` int(7) unsigned NOT NULL,
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'SteamDB Unknown Package',
  `StoreName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastKnownName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastUpdated` int(11) DEFAULT NULL,
  UNIQUE KEY `SubID` (`SubID`),
  FULLTEXT KEY `Name` (`Name`,`StoreName`,`LastKnownName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SubsApps`
--

DROP TABLE IF EXISTS `SubsApps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SubsApps` (
  `SubID` int(7) unsigned NOT NULL,
  `AppID` int(7) unsigned NOT NULL,
  `Type` enum('app','depot') COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `Unique` (`SubID`,`AppID`),
  KEY `AppID` (`AppID`),
  KEY `SubID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SubsHistory`
--

DROP TABLE IF EXISTS `SubsHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SubsHistory` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) unsigned NOT NULL,
  `SubID` int(7) unsigned NOT NULL,
  `Time` int(11) DEFAULT NULL,
  `Action` enum('created_sub','deleted_sub','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `OldValue` text COLLATE utf8_bin NOT NULL,
  `NewValue` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `SubID` (`SubID`)
) ENGINE=InnoDB AUTO_INCREMENT=9650 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SubsInfo`
--

DROP TABLE IF EXISTS `SubsInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SubsInfo` (
  `SubID` int(7) unsigned NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `Value` text COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `SubID` (`SubID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `steam`.`app_insert`
BEFORE INSERT
ON `Apps` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdated is null)
    then
        set new.LastUpdated = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `app_update`
BEFORE UPDATE
ON `Apps` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdated is null)
    then
        set new.LastUpdated = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `appshistory_insert`
BEFORE INSERT
ON `AppsHistory` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Time is null)
    then
        set new.Time = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `appshistory_update`
BEFORE UPDATE
ON `AppsHistory` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Time is null)
    then
        set new.Time = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `changelists_insert`
BEFORE INSERT 
ON `Changelists` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `changelists_update`
BEFORE UPDATE 
ON `Changelists` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `depots_insert`
BEFORE INSERT
ON `Depots` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdated is null)
    then
        set new.LastUpdated = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `depots_update`
BEFORE UPDATE
ON `Depots` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdated is null)
    then
        set new.LastUpdated = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `depotshistory_insert`
BEFORE INSERT
ON `DepotsHistory` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Time is null)
    then
        set new.Time = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `depotshistory_update`
BEFORE UPDATE
ON `DepotsHistory` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Time is null)
    then
        set new.Time = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `steam`.`depotskeys`
BEFORE INSERT
ON `DepotsKeys` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdate is null)
    then
        set new.LastUpdate = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `depotskeys_update`
BEFORE UPDATE 
ON `DepotsKeys` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdate is null)
    then
        set new.LastUpdate = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PICSTokens_Insert`
BEFORE INSERT
ON `PICSTokens` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PICSTokens_Update`
BEFORE UPDATE
ON `PICSTokens` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rss_insert`
BEFORE INSERT
ON `RSS` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rss_delete`
BEFORE UPDATE
ON `RSS` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `StoreUpdateQueue_insert`
BEFORE INSERT 
ON `StoreUpdateQueue` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `SoteUpdateQueue_update`
BEFORE UPDATE 
ON `StoreUpdateQueue` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Date is null)
    then
        set new.Date = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `subs_insert`
BEFORE INSERT
ON `Subs` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdated is null)
    then
        set new.LastUpdated = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `subs_update`
BEFORE UPDATE
ON `Subs` FOR EACH ROW
BEGIN
-- Definition start
    if (new.LastUpdated is null)
    then
        set new.LastUpdated = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `SubsHistory_insert`
BEFORE INSERT
ON `SubsHistory` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Time is null)
    then
        set new.Time = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `SubsHistory_update`
BEFORE UPDATE
ON `SubsHistory` FOR EACH ROW
BEGIN
-- Definition start
    if (new.Time is null)
    then
        set new.Time = unix_timestamp();
    end if;
-- Definition end
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
