\c scint
--
-- Table structure for table station
--
DROP TABLE IF EXISTS station_belong_institution;
DROP TABLE IF EXISTS station;
DROP TABLE IF EXISTS instrument;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS institution;
DROP TABLE IF EXISTS satellite;
DROP TABLE IF EXISTS constellation;

CREATE TABLE IF NOT EXISTS instrument(
    code            char(3) NOT NULL,
    name            varchar(255) NOT NULL,
    description     text NULL,
    modified        timestamp,
    PRIMARY KEY  (code),
    UNIQUE (name)
);

INSERT INTO instrument VALUES ('NG4','Novatel GSV4004',NULL,'2021-03-08 09:40:28');
INSERT INTO instrument VALUES ('NG6','Novatel GPStation-6',NULL,'2021-03-08 09:42:50');
INSERT INTO instrument VALUES ('S5S','Septentrio PolaRx5S',NULL,'2021-03-08 09:43:47');
INSERT INTO instrument VALUES ('SXS','Septentrio PolaRxS',NULL,'2021-03-08 09:45:38');

ALTER TABLE instrument OWNER TO scintu;

CREATE TABLE status (
  code varchar(3)       NOT NULL,
  name varchar(255)     NOT NULL,
  description text      NULL,
  modified timestamp    NOT NULL,
  PRIMARY KEY (code),
  UNIQUE (name)
);

ALTER TABLE status OWNER TO scintu;

INSERT INTO status (code, name, description, modified) VALUES ('CLO','Closed','Dismissed station','2020-11-09 10:42:23');
INSERT INTO status (code, name, description, modified) VALUES ('INS','Installing','Installing station','2020-11-09 10:42:23');
INSERT INTO status (code, name, description, modified) VALUES ('OFF','Disabled','Tenporary disabled station','2020-11-09 10:42:23');
INSERT INTO status (code, name, description, modified) VALUES ('ON','Active','Online station','2020-11-09 10:42:23');

CREATE TABLE institution (
  code varchar(10) NOT NULL,
  name varchar(255) NOT NULL,
  description text ,
  url varchar(1024) DEFAULT NULL,
  country varchar(1024) DEFAULT NULL,
  orderby int NOT NULL DEFAULT 0,
  modified timestamp    NOT NULL,
  PRIMARY KEY (code),
  UNIQUE (name)
);

ALTER TABLE institution OWNER TO scintu;

INSERT INTO institution VALUES ('ASI','Agenzia Spaziale Italiana','','https://www.asi.it','it',0,'2022-04-05 12:55:50');
INSERT INTO institution VALUES ('CNR','Consiglio Nazionale delle Ricerche (CNR)',NULL,'http://www.cnr.it','it',0,'2020-11-16 08:24:41');
INSERT INTO institution VALUES ('ENEA','Agenzia nazionale per le nuove tecnologie, l’energia e lo sviluppo economico sostenibile (ENEA)','','https://www.enea.it','it',0,'2020-11-16 08:24:47');
INSERT INTO institution VALUES ('ERAU','Embry-Riddle Aeronautical University (ERAU)',NULL,'https://erau.edu','us',0,'2021-12-22 12:03:25');
INSERT INTO institution VALUES ('FCT_UNESP','Universidade Estadual Paulista','','https://www.fct.unesp.br/','br',0,'2023-04-18 09:22:53');
INSERT INTO institution VALUES ('FMI','Finnish Meteorological Institute','','https://en.ilmatieteenlaitos.fi/','fi',0,'2021-12-15 16:15:25');
INSERT INTO institution VALUES ('FREDERICK','Frederick University',NULL,'http://www.frederick.ac.cy/','cy',0,'2020-11-16 08:28:21');
INSERT INTO institution VALUES ('HMU','Hellenic Mediterranean University','','https://www.hmu.gr/en','gr',0,'2022-06-21 08:06:30');
INSERT INTO institution VALUES ('INGV','Istituto Nazionale di Geofisica e Vulcanologia','','http://www.ingv.it','it',0,'2020-11-16 09:55:08');
INSERT INTO institution VALUES ('KGEO','Kartverket Geodetic Earth Observatory',NULL,'https://www.kartverket.no/en/about-kartverket/geodetic-earth-observatory','no',0,'2020-11-16 08:27:52');
INSERT INTO institution VALUES ('KLU','K L University','','https://www.kluniversity.in/','in',0,'2022-03-17 10:24:05');
INSERT INTO institution VALUES ('KNMI','Royal Netherlands Meteorological Institute','','https://www.knmi.nl','nl',0,'2022-05-04 20:40:07');
INSERT INTO institution VALUES ('MACKENZIE','Mackenzie University',NULL,'https://www.mackenzie.br/','br',0,'2020-11-16 08:27:30');
INSERT INTO institution VALUES ('NASRDA','National Space Research and Development Agency','Space Environment Research Laboratory (SERL) ','http://nasrda.gov.ng/','ng',0,'2022-12-05 12:48:42');
INSERT INTO institution VALUES ('NAVIS','International Collaboration Centre for Research and Development on Satellite Navigation Technology in South East Asia (NAVIS)',NULL,'http://navis.hust.edu.vn/index.php','vn',0,'2020-11-16 08:26:59');
INSERT INTO institution VALUES ('NSF','National Science Foundation',NULL,'https://www.nsf.gov/','us',0,'2021-09-07 13:53:26');
INSERT INTO institution VALUES ('PNRA','Programma nazionale di ricerca in Antartide (PNRA)',NULL,'https://www.pnra.aq','it',0,'2020-11-16 08:24:53');
INSERT INTO institution VALUES ('PWANI','Pwani University',NULL,'https://www.pu.ac.ke/','ke',0,'2020-11-16 08:26:34');
INSERT INTO institution VALUES ('SANSA','South African National Space Agency (SANSA)',NULL,'https://www.sansa.org.za/','za',0,'2020-11-16 08:25:37');
INSERT INTO institution VALUES ('SMN','Servicio Metereologico National','','https://www.argentina.gob.ar/smn','ar',0,'2021-12-02 15:07:04');
INSERT INTO institution VALUES ('UIT','The Arctic University of Norway (UIT)',NULL,'https://uit.no/startsida','no',0,'2020-11-16 08:25:58');
INSERT INTO institution VALUES ('UNT','Universidad Nacional de Tucuman','','https://www.unt.edu.ar','ar',0,'2021-12-07 20:51:25');

CREATE TABLE IF NOT EXISTS station(
    code            varchar(6) NOT NULL,
    filecode        varchar(6) NOT NULL,
    name            varchar(255) NULL,
    start_time      timestamp NULL,
    end_time        timestamp NULL,
    lat             decimal(9,6) NULL,
    lon             decimal(9,6) NULL,
    h               decimal(8,2) NULL,
    area            varchar(255) NULL,
    description     text NULL ,
    fk_instrument   char(3),
    fk_status       char(3),
    fk_institution  char(10),
    modified timestamp    NOT NULL,
    PRIMARY KEY (code),
    CONSTRAINT foreign_instrument
        FOREIGN KEY (fk_instrument)
        REFERENCES instrument (code),
    CONSTRAINT foreign_institution
        FOREIGN KEY (fk_institution)
        REFERENCES institution (code),
    CONSTRAINT foreign_status
        FOREIGN KEY (fk_status)
        REFERENCES status (code)
);

ALTER TABLE station OWNER TO scintu;

INSERT INTO station VALUES ('btn0s','btn0s','Mario Zucchelli','2006-01-18 00:00:00','2019-01-04 00:00:00',-74.700000,164.110000,NULL,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 16:26:13');
INSERT INTO station VALUES ('dmc0s','dmc0s','Dome C','2009-11-18 00:01:00','2022-09-25 00:00:00',-75.100000,123.333000,3253.00,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 17:29:23');
INSERT INTO station VALUES ('nya1s','nya1s','Ny Alesund','2010-01-01 00:02:00','2020-09-17 02:22:00',78.929308,11.867489,83.00,'ARCTIC',NULL,'NG4','CLO','KGEO','2023-05-15 13:14:50');
INSERT INTO station VALUES ('kil0n','kil0','Kilifi','2019-05-14 16:01:00','2999-01-01 00:00:00',-3.600000,39.800000,NULL,'AFRICA',NULL,'NG6','ON','PWANI','2022-12-15 17:27:11');
INSERT INTO station VALUES ('lyb0p','lyb0','Longyearbyen','2019-01-13 10:39:00','2999-01-01 00:00:00',78.200000,16.000000,NULL,'ARCTIC',NULL,'S5S','ON','UIT','2022-12-15 16:37:33');
INSERT INTO station VALUES ('dmc0p','dmc0p','Dome C','2017-01-29 03:16:00','2999-01-01 00:00:00',-75.100000,123.333000,3253.00,'ANTARCTIC',NULL,'S5S','ON','PNRA','2022-12-15 17:26:06');
INSERT INTO station VALUES ('san0p','sna0p','SANAE IV','2015-12-27 09:51:00','2999-01-01 00:00:00',-71.700000,-2.800000,NULL,'ANTARCTIC',NULL,'SXS','ON','SANSA','2022-12-15 17:25:44');
INSERT INTO station VALUES ('nya0p','nya0p','Ny Alesund','2015-11-09 00:01:00','2999-01-01 00:00:00',78.923478,11.925192,52.00,'ARCTIC',NULL,'S5S','ON','CNR','2023-05-15 13:15:32');
INSERT INTO station VALUES ('sao0p','sao0p','SaoPaolo','2017-05-31 13:33:00','2999-01-01 00:00:00',-23.500000,-46.700000,1.00,'SOUTH AMERICA',NULL,'SXS','ON','MACKENZIE','2022-12-15 16:29:53');
INSERT INTO station VALUES ('dmc1s','dmc1s','Dome C','2010-10-31 00:01:00','2022-09-25 00:00:00',-75.106048,123.304836,3236.00,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 17:29:45');
INSERT INTO station VALUES ('dmc2s','dmc2s','Dome C','2013-11-16 07:44:00','2022-09-25 00:00:00',-75.099586,123.304816,3232.00,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 17:30:04');
INSERT INTO station VALUES ('lam0p','lam0p','Lampedusa','2019-10-16 07:28:00','2999-01-01 00:00:00',35.520000,12.630000,NULL,'MEDITERRANEAN',NULL,'S5S','ON','ENEA','2022-12-15 16:29:09');
INSERT INTO station VALUES ('mzs0p','btn0p','Mario Zucchelli','2016-11-29 22:01:00','2999-01-01 00:00:00',-74.700000,164.110000,NULL,'ANTARCTIC',NULL,'SXS','ON','PNRA','2022-12-15 17:25:20');
INSERT INTO station VALUES ('nya0s','nya0s','Ny Alesund','2003-09-01 00:00:00','2020-09-17 00:40:00',78.923478,11.925192,52.00,'ARCTIC',NULL,'NG4','CLO','CNR','2023-05-15 13:15:35');
INSERT INTO station VALUES ('nya1p','nya1p','Ny Alesund','2020-01-02 13:11:00','2999-01-01 00:00:00',78.929308,11.867489,83.00,'ARCTIC',NULL,'S5S','ON','KGEO','2023-05-15 13:14:54');
INSERT INTO station VALUES ('lam0s','lam0s','Lampedusa','2011-06-22 00:01:00','2018-11-07 10:15:00',35.520000,12.630000,NULL,'MEDITERRANEAN',NULL,'NG4','CLO','ENEA','2022-12-15 17:32:44');
INSERT INTO station VALUES ('lyb0s','lyb0s','Longyearbyen','2010-01-01 00:01:00','2017-10-07 00:00:00',78.200000,16.000000,NULL,'ARCTIC',NULL,'NG4','CLO','UIT','2022-12-15 17:32:14');
INSERT INTO station VALUES ('nic0p','nic0p','Nicosia','2020-09-29 14:01:00','2999-01-01 00:00:00',35.181110,33.379170,NULL,'MEDITERRANEAN',NULL,'S5S','ON','FREDERICK','2022-12-15 16:36:12');
INSERT INTO station VALUES ('han0p','TQBS','Hanoi','2020-09-30 06:16:00','2999-01-01 00:00:00',21.004600,105.843900,NULL,'SOUTH EAST ASIA',NULL,'SXS','ON','NAVIS','2022-12-15 16:31:41');
INSERT INTO station VALUES ('thu0n','thu0n','Thule','2023-04-30 00:00:00','2000-01-01 00:00:00',76.510000,-68.740000,NULL,'ARCTIC',NULL,'NG6','INS','INGV','2023-05-01 19:30:12');
INSERT INTO station VALUES ('thu0p','thu0p','Thule','2021-04-29 11:05:00','2999-01-01 00:00:00',76.510000,-68.740000,NULL,'ARCTIC',NULL,'S5S','ON','NSF','2022-12-15 17:26:35');
INSERT INTO station VALUES ('ush0p','ush0p','Ushuaia','2021-12-02 15:31:00','2999-01-01 00:00:00',-54.848300,-68.310800,34.00,'SOUTH AMERICA','','S5S','ON','SMN','2022-12-15 16:30:21');
INSERT INTO station VALUES ('tuc0p','tuc0p','Tucuman','2021-12-09 09:31:00','2999-01-01 00:00:00',-23.727000,-65.230000,472.00,'SOUTH AMERICA','','S5S','ON','UNT','2022-12-15 16:30:48');
INSERT INTO station VALUES ('hel0p','hel0p','Helsinki','2021-12-16 09:01:00','2999-01-01 00:00:00',60.203800,24.960762,50.00,'EUROPE','','S5S','ON','FMI','2022-12-15 16:35:42');
INSERT INTO station VALUES ('klu0p','klu0p','KLUniversity','2022-03-17 00:00:00','2999-01-01 00:00:00',16.440342,80.623689,0.00,'SOUTH EAST ASIA','','S5S','ON','KLU','2022-12-15 16:34:21');
INSERT INTO station VALUES ('mal0p','mal0p','Broglio Space Center','2022-04-05 12:15:00','2999-01-01 00:00:00',-2.995556,40.194444,0.00,'AFRICA','','S5S','ON','ASI','2022-12-15 17:27:36');
INSERT INTO station VALUES ('sab0p','sab0p','Saba','2022-05-03 00:01:00','2999-01-01 00:00:00',17.621000,-63.243000,279.00,'CENTRAL AMERICA','','S5S','ON','KNMI','2022-12-15 17:24:49');
INSERT INTO station VALUES ('seu0p','seu0p','St. Eustatius','2022-05-06 08:24:00','2999-01-01 00:00:00',17.471000,-62.976000,30.93,'CENTRAL AMERICA','','S5S','ON','KNMI','2022-12-15 16:35:07');
INSERT INTO station VALUES ('cha0p','cha0p','Chania','2022-06-21 12:31:00','2999-01-01 00:00:00',35.518866,24.042406,68.00,'MEDITERRANEAN','','S5S','ON','HMU','2022-12-15 16:28:30');
INSERT INTO station VALUES ('cat0p','cat0p','Catania','2022-11-23 00:00:00','2999-01-01 00:00:00',37.766642,15.016750,2847.00,'MEDITERRANEAN','','S5S','INS','INGV','2022-11-23 08:34:09');
INSERT INTO station VALUES ('dmc1p','dmc1p','Dome C','2022-11-23 07:46:00','2999-01-01 00:00:00',-75.106048,123.304836,3236.00,'ANTARCTIC','','S5S','ON','PNRA','2022-12-15 17:28:17');
INSERT INTO station VALUES ('dmc2p','dmc2p','Dome C','2022-11-26 11:31:00','2999-01-01 00:00:00',-75.099586,123.304816,3232.00,'ANTARCTIC','','S5S','ON','PNRA','2022-12-15 17:28:00');
INSERT INTO station VALUES ('tes0p','tes0p','test station','2022-11-23 00:00:00','2999-01-01 00:00:00',-18.781279,-42.933526,802.00,'SOUTH AMERICA','TEST STATION DO NOT USE','S5S','INS','INGV','2022-11-23 08:34:09');
INSERT INTO station VALUES ('abu0p','abu0p','Abuja','2022-12-05 14:00:00','2999-01-01 00:00:00',8.989722,7.384444,457.00,'AFRICA','','S5S','ON','NASRDA','2023-04-06 14:39:17');
INSERT INTO station VALUES ('pru2p','pru2p','Presidente Prudente','2023-03-29 12:00:00','2999-01-01 00:00:00',-22.122037,-51.407080,442.00,'SOUTH AMERICA','','S5S','INS','FCT_UNESP','2023-04-18 09:26:08');
INSERT INTO station VALUES ('sod0p','sod0p','Sodankyla','2023-04-18 15:00:00','2999-01-01 00:00:00',67.366669,26.629917,205.50,'EUROPE','','S5S','ON','FMI','2023-04-18 11:40:17');

CREATE TABLE station_belong_institution (
  id  SERIAL PRIMARY KEY,
  fk_station varchar(6) NOT NULL,
  fk_institution varchar(10) NOT NULL,
  orderby int NOT NULL DEFAULT '0',
  modified timestamp NOT NULL,
  -- PRIMARY KEY (id),
  CONSTRAINT foreign_station
        FOREIGN KEY (fk_station)
        REFERENCES station (code),
    CONSTRAINT foreign_institution
        FOREIGN KEY (fk_institution)
        REFERENCES institution (code)
);

ALTER TABLE station_belong_institution OWNER TO scintu;

-- carlo@switsrv:~$ mysql --login-path=dataroot scintillation -Ns -e "select CONCAT('INSERT INTO station_belong_institution VALUES (', l.id, ',', quote(s.code), ',', quote(l.fk_institution), ',', l.orderby, ',', quote(l.modified),');')     from station s join station_belong_institution l on l.fk_station=s.id order by l.id;"

INSERT INTO station_belong_institution VALUES (1,'btn0s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (2,'btn0s','PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (3,'dmc0p','PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (4,'dmc0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (5,'dmc0s','PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (6,'dmc0s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (7,'dmc1s','PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (8,'dmc1s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (9,'dmc2s','PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (10,'dmc2s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (11,'han0p','NAVIS',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (12,'kil0n','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (13,'kil0n','ERAU',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (14,'lam0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (15,'lam0s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (16,'lyb0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (17,'lyb0s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (18,'mzs0p','PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (19,'mzs0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (20,'nic0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (21,'nya0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (22,'nya0s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (23,'nya1p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (24,'nya1s','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (25,'san0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (26,'sao0p','INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (27,'ush0p','INGV',0,'2021-12-02 15:12:42');
INSERT INTO station_belong_institution VALUES (28,'thu0p','INGV',0,'2021-12-02 15:13:13');
INSERT INTO station_belong_institution VALUES (29,'tuc0p','INGV',0,'2021-12-07 20:55:23');
INSERT INTO station_belong_institution VALUES (30,'hel0p','FMI',0,'2021-12-15 16:50:18');
INSERT INTO station_belong_institution VALUES (31,'klu0p','KLU',0,'2022-03-17 10:38:01');
INSERT INTO station_belong_institution VALUES (32,'mal0p','INGV',0,'2022-04-06 06:25:16');
INSERT INTO station_belong_institution VALUES (33,'sab0p','KNMI',0,'2022-05-04 20:51:56');
INSERT INTO station_belong_institution VALUES (34,'seu0p','KNMI',0,'2022-05-06 10:33:01');
INSERT INTO station_belong_institution VALUES (35,'cha0p','INGV',0,'2022-06-21 12:25:14');
INSERT INTO station_belong_institution VALUES (36,'cat0p','INGV',0,'2022-11-08 16:16:25');
INSERT INTO station_belong_institution VALUES (37,'dmc1p','INGV',0,'2022-11-21 11:16:28');
INSERT INTO station_belong_institution VALUES (38,'dmc1p','PNRA',0,'2022-11-21 11:16:35');
INSERT INTO station_belong_institution VALUES (39,'dmc2p','INGV',0,'2022-11-21 11:16:42');
INSERT INTO station_belong_institution VALUES (40,'dmc2p','PNRA',0,'2022-11-21 11:16:46');
INSERT INTO station_belong_institution VALUES (42,'tes0p','INGV',0,'2022-11-22 08:09:42');
INSERT INTO station_belong_institution VALUES (43,'abu0p','INGV',0,'2022-12-05 12:56:36');
INSERT INTO station_belong_institution VALUES (44,'pru2p','FCT_UNESP',0,'2023-03-28 12:49:16');
INSERT INTO station_belong_institution VALUES (45,'sod0p','FMI',0,'2023-04-18 09:14:12');

CREATE TABLE constellation (
  id            SERIAL PRIMARY KEY,
  code          varchar(10) NOT NULL,
  name          varchar(255) DEFAULT NULL,
  description   text,
  nmp_code      char(1) DEFAULT NULL,
  modified      timestamp NOT NULL,
  UNIQUE (code)
);

ALTER TABLE constellation OWNER TO scintu;

INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (0,'GPS','GPS',NULL,'G','2019-10-02 13:53:15');
INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (1,'GLO','GLONASS',NULL,'R','2019-10-02 13:53:15');
INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (2,'SBAS','SBAS block1',NULL,'S','2019-10-02 13:53:15');
INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (5,'GAL','GALILEO',NULL,'E','2019-10-02 13:53:15');
INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (6,'BEIDU','Beidu, Compass',NULL,'C','2019-10-02 13:53:15');
INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (7,'QZSS','QZSS',NULL,'Q','2019-10-02 13:53:15');
INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (8,'IRNSS','IRNSS',NULL,NULL,'2019-10-02 13:53:15');
INSERT INTO constellation (id, code, name, description, nmp_code, modified) VALUES (9,'FREE','Free',NULL,NULL,'2019-10-02 13:53:15');

CREATE TABLE satellite (
  svid              int NOT NULL,
  prn               int DEFAULT NULL,
  fk_constellation  int NOT NULL,
  modified          timestamp NOT NULL,
  PRIMARY KEY (svid),
   CONSTRAINT foreign_contellation
        FOREIGN KEY (fk_constellation)
        REFERENCES constellation (id)
);

ALTER TABLE satellite OWNER TO scintu;

INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (1,1,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (2,2,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (3,3,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (4,4,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (5,5,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (6,6,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (7,7,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (8,8,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (9,9,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (10,10,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (11,11,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (12,12,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (13,13,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (14,14,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (15,15,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (16,16,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (17,17,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (18,18,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (19,19,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (20,20,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (21,21,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (22,22,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (23,23,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (24,24,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (25,25,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (26,26,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (27,27,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (28,28,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (29,29,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (30,30,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (31,31,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (32,32,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (33,33,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (34,34,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (35,35,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (36,36,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (37,37,'0','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (38,1,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (39,2,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (40,3,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (41,4,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (42,5,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (43,6,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (44,7,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (45,8,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (46,9,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (47,10,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (48,11,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (49,12,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (50,13,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (51,14,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (52,15,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (53,16,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (54,17,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (55,18,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (56,19,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (57,20,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (58,21,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (59,22,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (60,23,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (61,24,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (62,25,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (63,26,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (64,27,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (65,28,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (66,29,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (67,30,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (68,31,'1','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (69,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (70,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (71,1,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (72,2,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (73,3,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (74,4,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (75,5,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (76,6,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (77,7,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (78,8,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (79,9,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (80,10,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (81,11,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (82,12,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (83,13,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (84,14,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (85,15,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (86,16,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (87,17,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (88,18,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (89,19,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (90,20,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (91,21,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (92,22,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (93,23,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (94,24,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (95,25,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (96,26,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (97,27,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (98,28,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (99,29,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (100,30,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (101,31,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (102,32,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (103,33,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (104,34,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (105,35,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (106,36,'5','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (107,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (108,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (109,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (110,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (111,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (112,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (113,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (114,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (115,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (116,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (117,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (118,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (119,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (120,1,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (121,2,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (122,3,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (123,4,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (124,5,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (125,6,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (126,7,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (127,8,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (128,9,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (129,10,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (130,11,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (131,12,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (132,13,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (133,14,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (134,15,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (135,16,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (136,17,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (137,18,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (138,19,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (139,20,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (140,21,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (141,1,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (142,2,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (143,3,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (144,4,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (145,5,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (146,6,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (147,7,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (148,8,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (149,9,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (150,10,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (151,11,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (152,12,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (153,13,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (154,14,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (155,15,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (156,16,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (157,17,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (158,18,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (159,19,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (160,20,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (161,21,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (162,22,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (163,23,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (164,24,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (165,25,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (166,26,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (167,27,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (168,28,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (169,29,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (170,30,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (171,31,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (172,32,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (173,33,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (174,34,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (175,35,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (176,36,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (177,37,'6','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (178,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (179,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (180,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (181,1,'7','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (182,2,'7','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (183,3,'7','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (184,4,'7','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (185,5,'7','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (186,6,'7','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (187,7,'7','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (188,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (189,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (190,NULL,'9','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (191,1,'8','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (192,2,'8','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (193,3,'8','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (194,4,'8','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (195,5,'8','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (196,6,'8','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (197,7,'8','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (198,22,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (199,23,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (200,24,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (201,25,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (202,26,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (203,27,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (204,28,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (205,29,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (206,30,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (207,31,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (208,32,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (209,33,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (210,34,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (211,35,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (212,36,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (213,37,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (214,38,'2','2019-10-02 13:53:15');
INSERT INTO satellite (svid, prn, fk_constellation, modified) VALUES (215,39,'2','2019-10-02 13:53:15');

