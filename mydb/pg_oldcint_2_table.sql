\c scint

CREATE TABLE status (
  code varchar(3) NOT NULL,
  name varchar(255) NOT NULL,
  description text,
  modified timestamp NOT NULL,
  PRIMARY KEY (code),
  UNIQUE (name)
);

INSERT INTO status VALUES ('CLO','Closed','Dismissed station','2020-11-09 10:42:22');
INSERT INTO status VALUES ('INS','Installing','Installing station','2020-11-09 10:42:22');
INSERT INTO status VALUES ('OFF','Disabled','Tenporary disabled station','2020-11-09 10:42:22');
INSERT INTO status VALUES ('ON','Active','Online station','2020-11-09 10:42:22');

CREATE TABLE instrument (
  code char(3) NOT NULL,
  name varchar(255) NOT NULL,
  description text,
  modified timestamp NOT NULL,
  PRIMARY KEY (code),
  UNIQUE (name)
);
--
INSERT INTO instrument VALUES ('NG4','Novatel GSV4004',NULL,'2021-03-08 09:40:28');
INSERT INTO instrument VALUES ('NG6','Novatel GPStation-6',NULL,'2021-03-08 09:42:50');
INSERT INTO instrument VALUES ('S5S','Septentrio PolaRx5S',NULL,'2021-03-08 09:43:47');
INSERT INTO instrument VALUES ('SXS','Septentrio PolaRxS',NULL,'2021-03-08 09:45:38');

CREATE TABLE institution (
  code varchar(10) NOT NULL,
  name varchar(255) NOT NULL,
  description text,
  url varchar(1024) DEFAULT NULL,
  country varchar(1024) DEFAULT NULL,
  orderby int NOT NULL DEFAULT '0',
  modified timestamp NOT NULL,
  PRIMARY KEY (code),
  UNIQUE (name)
);

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

CREATE TABLE station (
  id int NOT NULL AUTO_INCREMENT,
  code varchar(6) NOT NULL,
  filecode varchar(6) NOT NULL,
  name varchar(255) DEFAULT NULL,
  start_time timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  end_time datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  lat numeric(9,6) DEFAULT NULL,
  lon numeric(9,6) DEFAULT NULL,
  h numeric(8,2) DEFAULT NULL,
  area varchar(255) DEFAULT NULL,
  description text,
  fk_instrument char(3) NOT NULL DEFAULT 'UNK',
  fk_status varchar(3) NOT NULL DEFAULT 'INS',
  fk_institution varchar(10) NOT NULL DEFAULT 'INGV',
  modified timestamp NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (code)
);

INSERT INTO station VALUES (1,'btn0s','btn0s','Mario Zucchelli','2006-01-18 00:00:00','2019-01-04 00:00:00',-74.700000,164.110000,NULL,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 16:26:13');
INSERT INTO station VALUES (2,'dmc0s','dmc0s','Dome C','2009-11-18 00:01:00','2022-09-25 00:00:00',-75.100000,123.333000,3253.00,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 17:29:23');
INSERT INTO station VALUES (3,'nya1s','nya1s','Ny Alesund','2010-01-01 00:02:00','2020-09-17 02:22:00',78.929308,11.867489,83.00,'ARCTIC',NULL,'NG4','CLO','KGEO','2023-05-15 13:14:50');
INSERT INTO station VALUES (4,'kil0n','kil0','Kilifi','2019-05-14 16:01:00','2999-01-01 00:00:00',-3.600000,39.800000,NULL,'AFRICA',NULL,'NG6','ON','PWANI','2022-12-15 17:27:11');
INSERT INTO station VALUES (5,'lyb0p','lyb0','Longyearbyen','2019-01-13 10:39:00','2999-01-01 00:00:00',78.200000,16.000000,NULL,'ARCTIC',NULL,'S5S','ON','UIT','2022-12-15 16:37:33');
INSERT INTO station VALUES (6,'dmc0p','dmc0p','Dome C','2017-01-29 03:16:00','2999-01-01 00:00:00',-75.100000,123.333000,3253.00,'ANTARCTIC',NULL,'S5S','ON','PNRA','2022-12-15 17:26:06');
INSERT INTO station VALUES (7,'san0p','sna0p','SANAE IV','2015-12-27 09:51:00','2999-01-01 00:00:00',-71.700000,-2.800000,NULL,'ANTARCTIC',NULL,'SXS','ON','SANSA','2022-12-15 17:25:44');
INSERT INTO station VALUES (8,'nya0p','nya0p','Ny Alesund','2015-11-09 00:01:00','2999-01-01 00:00:00',78.923478,11.925192,52.00,'ARCTIC',NULL,'S5S','ON','CNR','2023-05-15 13:15:32');
INSERT INTO station VALUES (9,'sao0p','sao0p','SaoPaolo','2017-05-31 13:33:00','2999-01-01 00:00:00',-23.500000,-46.700000,1.00,'SOUTH AMERICA',NULL,'SXS','ON','MACKENZIE','2022-12-15 16:29:53');
INSERT INTO station VALUES (10,'dmc1s','dmc1s','Dome C','2010-10-31 00:01:00','2022-09-25 00:00:00',-75.106048,123.304836,3236.00,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 17:29:45');
INSERT INTO station VALUES (11,'dmc2s','dmc2s','Dome C','2013-11-16 07:44:00','2022-09-25 00:00:00',-75.099586,123.304816,3232.00,'ANTARCTIC',NULL,'NG4','CLO','PNRA','2022-12-15 17:30:04');
INSERT INTO station VALUES (12,'lam0p','lam0p','Lampedusa','2019-10-16 07:28:00','2999-01-01 00:00:00',35.520000,12.630000,NULL,'MEDITERRANEAN',NULL,'S5S','ON','ENEA','2022-12-15 16:29:09');
INSERT INTO station VALUES (13,'mzs0p','btn0p','Mario Zucchelli','2016-11-29 22:01:00','2999-01-01 00:00:00',-74.700000,164.110000,NULL,'ANTARCTIC',NULL,'SXS','ON','PNRA','2022-12-15 17:25:20');
INSERT INTO station VALUES (14,'nya0s','nya0s','Ny Alesund','2003-09-01 00:00:00','2020-09-17 00:40:00',78.923478,11.925192,52.00,'ARCTIC',NULL,'NG4','CLO','CNR','2023-05-15 13:15:35');
INSERT INTO station VALUES (15,'nya1p','nya1p','Ny Alesund','2020-01-02 13:11:00','2999-01-01 00:00:00',78.929308,11.867489,83.00,'ARCTIC',NULL,'S5S','ON','KGEO','2023-05-15 13:14:54');
INSERT INTO station VALUES (17,'lam0s','lam0s','Lampedusa','2011-06-22 00:01:00','2018-11-07 10:15:00',35.520000,12.630000,NULL,'MEDITERRANEAN',NULL,'NG4','CLO','ENEA','2022-12-15 17:32:44');
INSERT INTO station VALUES (18,'lyb0s','lyb0s','Longyearbyen','2010-01-01 00:01:00','2017-10-07 00:00:00',78.200000,16.000000,NULL,'ARCTIC',NULL,'NG4','CLO','UIT','2022-12-15 17:32:14');
INSERT INTO station VALUES (19,'nic0p','nic0p','Nicosia','2020-09-29 14:01:00','2999-01-01 00:00:00',35.181110,33.379170,NULL,'MEDITERRANEAN',NULL,'S5S','ON','FREDERICK','2022-12-15 16:36:12');
INSERT INTO station VALUES (20,'han0p','TQBS','Hanoi','2020-09-30 06:16:00','2999-01-01 00:00:00',21.004600,105.843900,NULL,'SOUTH EAST ASIA',NULL,'SXS','ON','NAVIS','2022-12-15 16:31:41');
INSERT INTO station VALUES (21,'thu0n','thu0n','Thule','2023-04-30 00:00:00','2000-01-01 00:00:00',76.510000,-68.740000,NULL,'ARCTIC',NULL,'NMC','INS','INGV','2023-05-01 19:30:12');
INSERT INTO station VALUES (22,'thu0p','thu0p','Thule','2021-04-29 11:05:00','2999-01-01 00:00:00',76.510000,-68.740000,NULL,'ARCTIC',NULL,'S5S','ON','NSF','2022-12-15 17:26:35');
INSERT INTO station VALUES (23,'ush0p','ush0p','Ushuaia','2021-12-02 15:31:00','2999-01-01 00:00:00',-54.848300,-68.310800,34.00,'SOUTH AMERICA','','S5S','ON','SMN','2022-12-15 16:30:21');
INSERT INTO station VALUES (24,'tuc0p','tuc0p','Tucuman','2021-12-09 09:31:00','2999-01-01 00:00:00',-23.727000,-65.230000,472.00,'SOUTH AMERICA','','S5S','ON','UNT','2022-12-15 16:30:48');
INSERT INTO station VALUES (25,'hel0p','hel0p','Helsinki','2021-12-16 09:01:00','2999-01-01 00:00:00',60.203800,24.960762,50.00,'EUROPE','','S5S','ON','FMI','2022-12-15 16:35:42');
INSERT INTO station VALUES (26,'klu0p','klu0p','KLUniversity','2022-03-17 00:00:00','2999-01-01 00:00:00',16.440342,80.623689,0.00,'SOUTH EAST ASIA','','S5S','ON','KLU','2022-12-15 16:34:21');
INSERT INTO station VALUES (27,'mal0p','mal0p','Broglio Space Center','2022-04-05 12:15:00','2999-01-01 00:00:00',-2.995556,40.194444,0.00,'AFRICA','','S5S','ON','ASI','2022-12-15 17:27:36');
INSERT INTO station VALUES (28,'sab0p','sab0p','Saba','2022-05-03 00:01:00','2999-01-01 00:00:00',17.621000,-63.243000,279.00,'CENTRAL AMERICA','','S5S','ON','KNMI','2022-12-15 17:24:49');
INSERT INTO station VALUES (29,'seu0p','seu0p','St. Eustatius','2022-05-06 08:24:00','2999-01-01 00:00:00',17.471000,-62.976000,30.93,'CENTRAL AMERICA','','S5S','ON','KNMI','2022-12-15 16:35:07');
INSERT INTO station VALUES (30,'cha0p','cha0p','Chania','2022-06-21 12:31:00','2999-01-01 00:00:00',35.518866,24.042406,68.00,'MEDITERRANEAN','','S5S','ON','HMU','2022-12-15 16:28:30');
INSERT INTO station VALUES (31,'cat0p','cat0p','Catania','2022-11-23 00:00:00','2999-01-01 00:00:00',37.766642,15.016750,2847.00,'MEDITERRANEAN','','S5S','INS','INGV','2022-11-23 08:34:09');
INSERT INTO station VALUES (32,'dmc1p','dmc1p','Dome C','2022-11-23 07:46:00','2999-01-01 00:00:00',-75.106048,123.304836,3236.00,'ANTARCTIC','','S5S','ON','PNRA','2022-12-15 17:28:17');
INSERT INTO station VALUES (33,'dmc2p','dmc2p','Dome C','2022-11-26 11:31:00','2999-01-01 00:00:00',-75.099586,123.304816,3232.00,'ANTARCTIC','','S5S','ON','PNRA','2022-12-15 17:28:00');
INSERT INTO station VALUES (34,'tes0p','tes0p','test station','2022-11-23 00:00:00','2999-01-01 00:00:00',-18.781279,-42.933526,802.00,'SOUTH AMERICA','TEST STATION DO NOT USE','S5S','INS','INGV','2022-11-23 08:34:09');
INSERT INTO station VALUES (35,'abu0p','abu0p','Abuja','2022-12-05 14:00:00','2999-01-01 00:00:00',8.989722,7.384444,457.00,'AFRICA','','S5S','ON','NASRDA','2023-04-06 14:39:17');
INSERT INTO station VALUES (36,'pru2p','pru2p','Presidente Prudente','2023-03-29 12:00:00','2999-01-01 00:00:00',-22.122037,-51.407080,442.00,'SOUTH AMERICA','','S5S','INS','FCT_UNESP','2023-04-18 09:26:08');
INSERT INTO station VALUES (37,'sod0p','sod0p','Sodankyla','2023-04-18 15:00:00','2999-01-01 00:00:00',67.366669,26.629917,205.50,'EUROPE','','S5S','ON','FMI','2023-04-18 11:40:17');

CREATE TABLE station_belong_institution (
  id integer NOT NULL AUTO_INCREMENT,
  fk_station integer NOT NULL,
  fk_institution varchar(10) NOT NULL,
  orderby int NOT NULL DEFAULT '0',
  modified timestamp NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO station_belong_institution VALUES (1,1,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (2,1,'PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (3,6,'PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (4,6,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (5,2,'PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (6,2,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (7,10,'PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (8,10,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (9,11,'PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (10,11,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (11,20,'NAVIS',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (12,4,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (13,4,'ERAU',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (14,12,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (15,17,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (16,5,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (17,18,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (18,13,'PNRA',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (19,13,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (20,19,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (21,8,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (22,14,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (23,15,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (24,3,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (25,7,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (26,9,'INGV',0,'2020-11-12 11:17:07');
INSERT INTO station_belong_institution VALUES (27,23,'INGV',0,'2021-12-02 15:12:42');
INSERT INTO station_belong_institution VALUES (28,22,'INGV',0,'2021-12-02 15:13:13');
INSERT INTO station_belong_institution VALUES (29,24,'INGV',0,'2021-12-07 20:55:23');
INSERT INTO station_belong_institution VALUES (30,25,'FMI',0,'2021-12-15 16:50:18');
INSERT INTO station_belong_institution VALUES (31,26,'KLU',0,'2022-03-17 10:38:01');
INSERT INTO station_belong_institution VALUES (32,27,'INGV',0,'2022-04-06 06:25:16');
INSERT INTO station_belong_institution VALUES (33,28,'KNMI',0,'2022-05-04 20:51:56');
INSERT INTO station_belong_institution VALUES (34,29,'KNMI',0,'2022-05-06 10:33:01');
INSERT INTO station_belong_institution VALUES (35,30,'INGV',0,'2022-06-21 12:25:14');
INSERT INTO station_belong_institution VALUES (36,31,'INGV',0,'2022-11-08 16:16:25');
INSERT INTO station_belong_institution VALUES (37,32,'INGV',0,'2022-11-21 11:16:28');
INSERT INTO station_belong_institution VALUES (38,32,'PNRA',0,'2022-11-21 11:16:35');
INSERT INTO station_belong_institution VALUES (39,33,'INGV',0,'2022-11-21 11:16:42');
INSERT INTO station_belong_institution VALUES (40,33,'PNRA',0,'2022-11-21 11:16:46');
INSERT INTO station_belong_institution VALUES (42,34,'INGV',0,'2022-11-22 08:09:42');
INSERT INTO station_belong_institution VALUES (43,35,'INGV',0,'2022-12-05 12:56:36');
INSERT INTO station_belong_institution VALUES (44,36,'FCT_UNESP',0,'2023-03-28 12:49:16');
INSERT INTO station_belong_institution VALUES (45,37,'FMI',0,'2023-04-18 09:14:12');
*/
