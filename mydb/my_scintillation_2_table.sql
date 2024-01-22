USE scintillation;

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS station;
CREATE TABLE station(
    id              bigint NOT NULL auto_increment  COMMENT 'Unique incremental id',
    code            varchar(6) NOT NULL COMMENT 'Station code',
    filecode        varchar(6) NOT NULL COMMENT 'Station code in data file name',
    name            varchar(255) NULL COMMENT 'name',
    lat             decimal(9,6) COMMENT 'Station Latitude',
    lon             decimal(9,6) COMMENT 'Station Longitude',
    h               decimal(8,2) COMMENT 'Station elevation',
    area            varchar(255) NULL COMMENT 'Area',
    description     text COMMENT 'description and note',
    fk_instrument   char(3) NOT NULL DEFAULT 'UNK' COMMENT 'Instrumentat description',
    modified        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last Review',
    PRIMARY KEY  (id),
    UNIQUE KEY (code),
    KEY (fk_instrument)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT '';

DROP TABLE IF EXISTS instrument;
CREATE TABLE instrument(
    code            char(3) NOT NULL COMMENT 'unique code',
    name            varchar(255) NOT NULL COMMENT 'instrumnent name',
    description     text NULL COMMENT 'description',
    modified        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last Review',
    PRIMARY KEY  (code),
    UNIQUE KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT '';

CREATE TABLE IF NOT EXISTS file(
    id              bigint NOT NULL auto_increment  COMMENT 'Unique incremental id',
    name            varchar(255) NOT NULL COMMENT 'origin file name',
    fk_station      bigint COMMENT 'reference to station table',
    fk_chain        bigint DEFAULT 0 COMMENT 'reference to acquisition chain information',
    modified        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last Review',
    PRIMARY KEY  (id),
    UNIQUE KEY (name, fk_station)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT '';

DROP TABLE IF EXISTS constellation;
CREATE TABLE constellation (
    id int(40) NOT NULL,
    code varchar(10) NOT NULL               COMMENT 'Constellation code',
    name varchar(255)                       COMMENT 'Constellation name',
    description text                        COMMENT 'Constellation info',
    nmp_code char(1) NULL DEFAULT NULL      COMMENT 'Constellation letter foe novatel_multi parser',
    modified        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last Review',
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- SVID/Costellazione, da Luca
-- 1-37/GPS
-- 38-68/GLONASS
-- 71-106/GALILEO
-- 120-140/SBAS - primo slot
-- 141-177/BeiDou
-- 181-187/QZSS
-- 191-197/IRNSS
-- 198-215/SBAS - secondo slot

DROP TABLE IF EXISTS satellite;
CREATE TABLE satellite (
    svid int                             COMMENT 'Septentrio svid value',
    prn int DEFAULT NULL                COMMENT 'Novatel PRN value for a specific sat_group',
    fk_constellation CHAR(10) NOT NULL  COMMENT 'Link to sat_group',
    modified        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last Review',
    PRIMARY KEY (svid)
) ENGINE=InnoDB;


-- data
-- MySQL dump 10.16  Distrib 10.1.43-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: eswuax.rm.ingv.it    Database: scintillation
-- ------------------------------------------------------
-- Server version	10.3.20-MariaDB-1:10.3.20+maria~bionic-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES (1,'btn0s','btn0s','Mario Zucchelli',-74.700000,164.110000,NULL,'ANTARCTIC',NULL,'NGP','2019-10-07 12:54:22');
UNLOCK TABLES;

--
-- Dumping data for table `instrument`
--

LOCK TABLES `instrument` WRITE;
/*!40000 ALTER TABLE `instrument` DISABLE KEYS */;
INSERT INTO `instrument` VALUES ('NGP','Novatel GPS',NULL,'2019-10-02 13:53:14');
INSERT INTO `instrument` VALUES ('NMC','Novatel Multiconstellation',NULL,'2019-10-02 13:53:14');
INSERT INTO `instrument` VALUES ('SEP','Septentrio',NULL,'2019-10-02 13:53:14');
/*!40000 ALTER TABLE `instrument` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `constellation`
--

LOCK TABLES `constellation` WRITE;
/*!40000 ALTER TABLE `constellation` DISABLE KEYS */;
INSERT INTO `constellation` VALUES (0,'GPS','GPS',NULL,'G','2019-10-02 13:53:15');
INSERT INTO `constellation` VALUES (1,'GLO','GLONASS',NULL,'R','2019-10-02 13:53:15');
INSERT INTO `constellation` VALUES (2,'SBAS','SBAS block1',NULL,'S','2019-10-02 13:53:15');
INSERT INTO `constellation` VALUES (5,'GAL','GALILEO',NULL,'E','2019-10-02 13:53:15');
INSERT INTO `constellation` VALUES (6,'BEIDU','Beidu, Compass',NULL,'C','2019-10-02 13:53:15');
INSERT INTO `constellation` VALUES (7,'QZSS','QZSS',NULL,'Q','2019-10-02 13:53:15');
INSERT INTO `constellation` VALUES (8,'IRNSS','IRNSS',NULL,NULL,'2019-10-02 13:53:15');
INSERT INTO `constellation` VALUES (9,'FREE','Free',NULL,NULL,'2019-10-02 13:53:15');
/*!40000 ALTER TABLE `constellation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `satellite`
--

LOCK TABLES `satellite` WRITE;
/*!40000 ALTER TABLE `satellite` DISABLE KEYS */;
INSERT INTO `satellite` VALUES (1,1,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (2,2,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (3,3,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (4,4,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (5,5,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (6,6,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (7,7,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (8,8,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (9,9,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (10,10,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (11,11,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (12,12,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (13,13,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (14,14,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (15,15,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (16,16,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (17,17,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (18,18,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (19,19,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (20,20,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (21,21,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (22,22,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (23,23,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (24,24,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (25,25,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (26,26,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (27,27,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (28,28,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (29,29,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (30,30,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (31,31,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (32,32,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (33,33,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (34,34,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (35,35,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (36,36,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (37,37,'0','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (38,1,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (39,2,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (40,3,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (41,4,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (42,5,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (43,6,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (44,7,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (45,8,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (46,9,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (47,10,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (48,11,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (49,12,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (50,13,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (51,14,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (52,15,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (53,16,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (54,17,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (55,18,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (56,19,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (57,20,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (58,21,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (59,22,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (60,23,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (61,24,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (62,25,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (63,26,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (64,27,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (65,28,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (66,29,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (67,30,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (68,31,'1','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (69,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (70,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (71,1,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (72,2,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (73,3,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (74,4,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (75,5,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (76,6,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (77,7,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (78,8,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (79,9,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (80,10,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (81,11,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (82,12,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (83,13,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (84,14,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (85,15,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (86,16,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (87,17,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (88,18,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (89,19,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (90,20,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (91,21,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (92,22,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (93,23,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (94,24,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (95,25,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (96,26,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (97,27,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (98,28,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (99,29,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (100,30,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (101,31,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (102,32,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (103,33,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (104,34,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (105,35,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (106,36,'5','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (107,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (108,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (109,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (110,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (111,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (112,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (113,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (114,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (115,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (116,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (117,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (118,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (119,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (120,1,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (121,2,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (122,3,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (123,4,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (124,5,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (125,6,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (126,7,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (127,8,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (128,9,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (129,10,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (130,11,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (131,12,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (132,13,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (133,14,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (134,15,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (135,16,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (136,17,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (137,18,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (138,19,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (139,20,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (140,21,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (141,1,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (142,2,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (143,3,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (144,4,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (145,5,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (146,6,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (147,7,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (148,8,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (149,9,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (150,10,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (151,11,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (152,12,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (153,13,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (154,14,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (155,15,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (156,16,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (157,17,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (158,18,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (159,19,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (160,20,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (161,21,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (162,22,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (163,23,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (164,24,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (165,25,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (166,26,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (167,27,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (168,28,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (169,29,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (170,30,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (171,31,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (172,32,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (173,33,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (174,34,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (175,35,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (176,36,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (177,37,'6','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (178,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (179,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (180,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (181,1,'7','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (182,2,'7','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (183,3,'7','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (184,4,'7','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (185,5,'7','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (186,6,'7','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (187,7,'7','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (188,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (189,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (190,NULL,'9','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (191,1,'8','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (192,2,'8','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (193,3,'8','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (194,4,'8','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (195,5,'8','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (196,6,'8','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (197,7,'8','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (198,22,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (199,23,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (200,24,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (201,25,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (202,26,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (203,27,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (204,28,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (205,29,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (206,30,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (207,31,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (208,32,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (209,33,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (210,34,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (211,35,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (212,36,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (213,37,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (214,38,'2','2019-10-02 13:53:15');
INSERT INTO `satellite` VALUES (215,39,'2','2019-10-02 13:53:15');
/*!40000 ALTER TABLE `satellite` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-29 12:41:02
