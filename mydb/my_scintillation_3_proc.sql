USE scintillation;

-- proc
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_station_info $$
CREATE PROCEDURE sp_station_info (
in_filecode     varchar(6)
)
COMMENT 'serach for a station with filecode in input and returns station code and station id'
uscita:BEGIN
    DECLARE l_id        int DEFAULT 0;
    DECLARE l_code      varchar(6) DEFAULT '';
    
    SELECT id, code INTO l_id, l_code
    FROM station
    WHERE filecode = in_filecode;
    SELECT 0 err_code, l_code code, l_id id, CONCAT('MESSAGE: station code and station id') err_message;

END $$
DELIMITER ;
GRANT EXECUTE   ON PROCEDURE sp_station_info      TO 'writer'@'%';

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ins_gps_row $$
CREATE PROCEDURE sp_ins_gps_row (
    in_dt               datetime,
    in_station          varchar(6),
    in_fileid           int,
    in_prn              varchar(255),
    in_rxstatus        varchar(255),
    in_az              varchar(255),
    in_elv             varchar(255),
    in_l1_cno          varchar(255),
    in_s4              varchar(255),
    in_s4_cor          varchar(255),
    in_n1secsigma      varchar(255),
    in_n3secsigma      varchar(255),
    in_n10secsigma     varchar(255),
    in_n30secsigma     varchar(255),
    in_n60secsigma     varchar(255),
    in_code_carrier    varchar(255),
    in_c_cstdev        varchar(255),
    in_tec45           varchar(255),
    in_tecrate45       varchar(255),
    in_tec30           varchar(255),
    in_tecrate30       varchar(255),
    in_tec15           varchar(255),
    in_tecrate15       varchar(255),
    in_tec0            varchar(255),
    in_tecrate0        varchar(255),
    in_l1_locktime     varchar(255),
    in_chanstatus      varchar(255),
    in_l2_locktime     varchar(255),
    in_l2_cno          varchar(255)
)
COMMENT 'Insert single scintillation row'
uscita:BEGIN
    DECLARE l_rowcount      int DEFAULT 0;
    DECLARE l_id_station    bigint DEFAULT 0;
    DECLARE l_id_file       bigint DEFAULT 0;
    DECLARE l_exists        int DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR 1452 BEGIN
        SELECT 2 err_code, CONCAT('ROW_ERROR: ', in_station, ' ', in_dt, ' sat: ', in_prn, ' father absent') err_message;
    END;
--    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
--        SELECT 3 err_code, CONCAT('ROW_ERROR: ', in_station, ' ', in_dt, ' sat: ', in_prn, ' sqlexception') err_message;
--    END;
--    DECLARE EXIT HANDLER FOR 1264 BEGIN
--        SELECT 3 err_code, CONCAT('ROW_ERROR: ', in_station, ' ', in_dt, ' sat: ', in_prn, ' out of range number') err_message;
--    END;

    DECLARE EXIT HANDLER FOR 1062 BEGIN
        SELECT 4 err_code, CONCAT('ROW_ERROR: ', in_station, ' ', in_dt, ' sat: ', in_prn, '\t \tduplicate row') err_message;
    END;

    IF TRIM(in_prn) = '' THEN
        SET in_prn = NULL;
    END IF;
    IF TRIM(in_rxstatus) = '' THEN
        SET in_rxstatus = NULL;
    END IF;
    IF TRIM(in_az) = '' THEN
        SET in_az = NULL;
    END IF;
    IF TRIM(in_elv) = '' THEN
        SET in_elv = NULL;
    END IF;
    IF TRIM(in_l1_cno) IN ('', 'N/A') THEN
        SET in_l1_cno = NULL;
    END IF; 
    IF TRIM(in_s4) IN ('') THEN
        SET in_s4 = NULL;
    END IF;
    IF TRIM(in_s4_cor) IN ('') THEN
        SET in_s4_cor = NULL;
    END IF;
    IF TRIM(in_n1secsigma) IN ('') THEN
        SET in_n1secsigma = NULL;
    END IF;
    IF TRIM(in_n3secsigma) IN ('', 'N/A', 'NO') THEN
        SET in_n3secsigma = NULL;
    END IF; 
    IF TRIM(in_n10secsigma) IN ('', 'NO') THEN
        SET in_n10secsigma = NULL;
    END IF; 
    IF TRIM(in_n30secsigma) IN ('', 'NO') THEN
        SET in_n30secsigma = NULL;
    END IF;
    IF TRIM(in_n60secsigma) IN ('', '---', 'OR AIP', 'E FOUND') THEN
        SET in_n60secsigma = NULL;
    END IF; 
    IF TRIM(in_code_carrier) IN ('', '---') THEN
        SET in_code_carrier = NULL;
    END IF;
    IF TRIM(in_c_cstdev) IN ('', '---') THEN
        SET in_c_cstdev = NULL;
    END IF;
    IF TRIM(in_tec45) IN ('', '---') THEN
        SET in_tec45 = NULL;
    END IF; 
    IF TRIM(in_tecrate45) IN ('', '---') THEN
        SET in_tecrate45 = NULL;
    END IF;
    IF TRIM(in_tec30) IN ('', '---') THEN
        SET in_tec30 = NULL;
    END IF;
    IF TRIM(in_tecrate30) IN ('', '---') THEN
        SET in_tecrate30 = NULL;
    END IF;
    IF TRIM(in_tec15) IN ('', '---') THEN
        SET in_tec15 = NULL;
    END IF;
    IF TRIM(in_tecrate15) IN ('', '---') THEN
        SET in_tecrate15 = NULL;
    END IF;
    IF TRIM(in_tec0) IN ('', '---') THEN
        SET in_tec0 = NULL;
    END IF;
    IF TRIM(in_tecrate0) IN ('', '---') THEN
        SET in_tecrate0 = NULL;
    END IF;
    IF TRIM(in_l1_locktime) IN ('', '---') THEN
        SET in_l1_locktime = NULL;
    END IF;
    IF TRIM(in_chanstatus) IN ('', '---') THEN
        SET in_chanstatus = NULL;
    END IF;
    IF TRIM(in_l2_locktime) IN ('') THEN
        SET in_l2_locktime = NULL;
    END IF;
    IF TRIM(in_l2_cno) IN ('') THEN
        SET in_l2_cno = NULL;
    END IF;
   
    SET @sql = CONCAT('INSERT INTO ', in_station, '(dt, svid, rxstate, azimuth, elevation, averagel1, totals4l1, corrections4l1, phi01l1, phi03l1, phi10l1, phi30l1, phi60l1slant, avgccdl1, sigmaccdl1, tec45, dtec60_45, tec30, dtec45_30, tec15, dtec30_15, tec0, dtec0, locktimel1, chanstatus, 2ndlocktime, avgcn2freqtec, fk_file)',
            'VALUES(', QUOTE(in_dt),',', in_prn,',', QUOTE(in_rxstatus),',', in_az,',', in_elv,',', in_l1_cno,',', in_s4,',', in_s4_cor,',', in_n1secsigma,',', in_n3secsigma,',', in_n10secsigma,',', in_n30secsigma,',', in_n60secsigma,',', in_code_carrier,',', in_c_cstdev,',', in_tec45,',', in_tecrate45,',', in_tec30,',', in_tecrate30,',', in_tec15,',', in_tecrate15,',', in_tec0,',', in_tecrate0,',', in_l1_locktime,',', QUOTE(in_chanstatus),',', in_l2_locktime,',', in_l2_cno, ',', in_fileid, ')');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    SELECT ROW_COUNT() INTO l_rowcount;
    DEALLOCATE PREPARE stmt;

    IF l_rowcount = 1 THEN
        SELECT 0 err_code, CONCAT('ROW_INSERTED: ', in_station, ' ', in_dt, ' sat: ', in_prn, ' inserted') err_message;
    ELSE
        SELECT -1 err_code, CONCAT('ROW_ERROR: ', in_station, ' ', in_dt, ' sat: ', in_prn, ' nothing happened') err_message;
    END IF;
commit;
END $$
DELIMITER ;
-- grants
GRANT EXECUTE   ON PROCEDURE sp_ins_gps_row      TO 'writer'@'%';

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ins_gps_file $$
CREATE PROCEDURE sp_ins_gps_file (
    in_station          varchar(5),
    in_filename         varchar(255)
)
COMMENT 'Insert file if not present and create table for novatel gps data'
uscita:BEGIN
    DECLARE l_exists            bigint DEFAULT 0;
    DECLARE l_id_file           bigint DEFAULT 0;
    DECLARE l_id_station        bigint DEFAULT 0;

    DECLARE EXIT HANDLER FOR 1062 BEGIN
        SELECT 1 err_code, CONCAT('MESSAGE: file: ', in_filename, ' station: ', in_station, '\t \tduplicate file') err_message;
    END;

    -- Controllo se la stazione è nella tabella delle stazioni da inserire
    SELECT id INTO l_id_station FROM station WHERE code = in_station;
    IF l_id_station = 0 THEN
        SELECT 2 err_code, 0 id_station, 0 id_file, CONCAT('MESSAGE: station not found: ', in_station) err_message;
        LEAVE uscita;
    END IF;

    SELECT COUNT(*) INTO l_exists FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = in_station;
-- gps novatel 
    IF l_exists = 0 THEN
        SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS ', in_station,'(',
            'dt             datetime NOT NULL   COMMENT \' measure time UTC\',',
            'svid           int     NOT NULL COMMENT \'Sat internal number\',',
            'rxstate        char(8) COMMENT \'rxstate\',',
            'azimuth        float   COMMENT \'Azimuth (degrees)\',',
            'elevation      float   COMMENT \'Elevation (degrees)\',',
            'averagel1      double  COMMENT \'C/N 0: Average Sig1 C/N0 over the last minute (dB-Hz)\',',
            'totals4l1      double  COMMENT \'Total S4 on Sig1 (dimensionless)\',',
            'corrections4l1 double  COMMENT \'Correction to total S4 on Sig1 (thermal noise component only)(dimensionless)\',',
            'phi01l1        double  COMMENT \'Phi01 on Sig1, 1-second phase sigma (radians)\',',
            'phi03l1        double  COMMENT \'Phi03 on Sig1, 3-second phase sigma (radians)\',',
            'phi10l1        double  COMMENT \'Phi10 on Sig1, 10-second phase sigma (radians)\',',
            'phi30l1        double  COMMENT \'Phi30 on Sig1, 30-second phase sigma (radians)\',',
            'phi60l1slant   double  COMMENT \'Phi60 on Sig1, 60-second phase sigma (radians)\',',
            'avgccdl1       double  COMMENT \'AvgCCD on Sig1, average of code/carrier divergence (meters)\',',
            'sigmaccdl1     double  COMMENT \'SigmaCCD on Sig1, standard deviation of code/carrier divergence(meters)\',',            
            'tec45          float   COMMENT \'TEC at TOW - 45 seconds (TECU)\',',
            'dtec60_45      float   COMMENT \'dTEC from TOW - 60s to TOW - 45s (TECU)\',',
            'tec30          float   COMMENT \'TEC at TOW - 30 seconds (TECU)\',',
            'dtec45_30      float   COMMENT \'dTEC from TOW - 45s to TOW - 30s (TECU)\',',
            'tec15          float   COMMENT \'TEC at TOW - 15 seconds (TECU)\',',
            'dtec30_15      float   COMMENT \'dTEC from TOW - 30s to TOW - 15s (TECU)\',',
            'tec0           float   COMMENT \'TEC at TOW (TECU)\',',
            'dtec0          float   COMMENT \'dTEC from TOW - 15s to TOW (TECU)\',',
            'locktimel1     double  COMMENT \'Sig1 lock time (seconds)\',',
            'chanstatus     char(8) COMMENT \'Channel status\',',
            '2ndlocktime    double  COMMENT \'L2 Lock Time\',',
            'avgcn2freqtec  double  COMMENT \'Averaged C/N0 of second frequency used for the TEC computation (dB-Hz)\',',
            'fk_file        bigint  COMMENT \'reference to file table\',',
            'modified timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'Last Review\',',
            'PRIMARY KEY (dt, svid)',
    '    ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT \'\'');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
   
    SELECT id INTO l_id_file
    FROM file
    WHERE name = in_filename
        AND fk_station = l_id_station;

    IF l_id_file = 0 THEN
        INSERT INTO file (name, fk_station)
        VALUES (in_filename, l_id_station);
        SELECT LAST_INSERT_ID() INTO l_id_file;
    END IF;
commit; 
    SELECT 0 err_code, l_id_file id_file, l_id_station id_station, CONCAT('MESSAGE: file id and station id') err_message;
END $$
DELIMITER ;
-- grants
GRANT EXECUTE   ON PROCEDURE sp_ins_gps_file    TO 'writer'@'%';

-- septentrio date

-- call sp_ins_sept_row (now(), 'dmc0', 'ccoria', 1, 'rxst',7,8,9,0,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63 )
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ins_sept_row $$
CREATE PROCEDURE sp_ins_sept_row (
    in_dt               datetime,
    in_station          varchar(255),
    in_id_file          int,
    in_svid             varchar(255),
    in_rxstatus         varchar(255),
    in_az               varchar(255),
    in_elv              varchar(255),
    in_averageL1        varchar(255),
    in_totalS4L1        varchar(255),
    in_correctionS4L1   varchar(255),
    in_phi01l1          varchar(255),
    in_phi03l1          varchar(255),
    in_phi10l1          varchar(255),
    in_phi30l1          varchar(255),
    in_phi60l1slant     varchar(255),
    in_avgCCDL1         varchar(255),
    in_sigmaCCDL1       varchar(255),
    in_tec45            varchar(255),
    in_dtec60_45        varchar(255),
    in_tec30            varchar(255),
    in_dtec45_30        varchar(255),
    in_tec15            varchar(255),
    in_dtec30_15        varchar(255),
    in_tec0             varchar(255),
    in_dtec0            varchar(255),
    in_locktimeL1       varchar(255),
    in_reserved         varchar(255),
    in_2ndlocktime      varchar(255),
    in_avgcn2freqTEC    varchar(255),
    in_SI_L1_29         varchar(255),
    in_SI_L1_30         varchar(255),
    in_pL1              varchar(255),
    in_avg_c_n0_l2c     varchar(255),
    in_totalS4_L2C      varchar(255),
    in_correctionS4_L2C varchar(255),
    in_phi01_l2c        varchar(255),
    in_phi03_l2c        varchar(255),
    in_phi10_l2c        varchar(255),
    in_phi30_l2c        varchar(255),
    in_phi60_l2c        varchar(255),
    in_avgccd_l2c       varchar(255),
    in_sigmaccd_l2c     varchar(255),
    in_locktime_l2c     varchar(255),
    in_SI_L2C_43        varchar(255),
    in_SI_L2C_44        varchar(255),
    in_p_l2c            varchar(255),
    in_avg_c_n0_l5      varchar(255),
    in_totalS4_L5       varchar(255),
    in_correctionS4_L5  varchar(255),
    in_phi01_l5         varchar(255),
    in_phi03_l5         varchar(255),
    in_phi10_l5         varchar(255),
    in_phi30_l5         varchar(255),
    in_phi60_l5         varchar(255),
    in_avgccd_l5        varchar(255),
    in_sigmaccd_l5      varchar(255),
    in_locktime_l5      varchar(255),
    in_SI_L5_57         varchar(255),
    in_SI_L5_58         varchar(255),
    in_p_l5             varchar(255),
    in_t_l1             varchar(255),
    in_t_l2c            varchar(255),
    in_t_l5             varchar(255)
)
COMMENT 'Insert a single septentrio data row'
uscita:BEGIN
    DECLARE l_rowcount      int DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR 1452 BEGIN
        SELECT 2 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' father absent') err_message;
    END;
--    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
--        SELECT 3 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' sqlexception') err_message;
--    END;
--    DECLARE EXIT HANDLER FOR 1264 BEGIN
--        SELECT 3 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' out of range number') err_message;
--    END;

    DECLARE EXIT HANDLER FOR 1062 BEGIN
        SELECT 4 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' duplicate row') err_message;
    END;

    IF TRIM(in_dt) IN ('', 'NO', 'nan') THEN
        SET in_dt = NULL;
    END IF;
    IF TRIM(in_station) IN ('', 'NO', 'nan') THEN
        SET in_station = NULL;
    END IF; 
    IF TRIM(in_svid) IN ('', 'NO', 'nan') THEN
        SET in_svid = NULL;
    END IF; 
    IF TRIM(in_rxstatus) IN ('', 'NO', 'nan') THEN
        SET in_rxstatus = NULL;
    END IF; 
    IF TRIM(in_az) IN ('', 'NO', 'nan') THEN
        SET in_az = NULL;
    END IF; 
    IF TRIM(in_elv) IN ('', 'NO', 'nan') THEN
        SET in_elv = NULL;
    END IF; 
    IF TRIM(in_averageL1) IN ('', 'NO', 'nan') THEN
        SET in_averageL1 = NULL;
    END IF; 
    IF TRIM(in_totalS4L1) IN ('', 'NO', 'nan') THEN
        SET in_totalS4L1  = NULL;
    END IF; 
    IF TRIM(in_correctionS4L1) IN ('', 'NO', 'nan') THEN
        SET in_correctionS4L1 = NULL;
    END IF; 
    IF TRIM(in_phi01l1) IN ('', 'NO', 'nan') THEN
        SET in_phi01l1 = NULL;
    END IF; 
    IF TRIM(in_phi03l1) IN ('', 'NO', 'nan') THEN
        SET in_phi03l1 = NULL;
    END IF; 
    IF TRIM(in_phi10l1) IN ('', 'NO', 'nan') THEN
        SET in_phi10l1 = NULL;
    END IF; 
    IF TRIM(in_phi30l1) IN ('', 'NO', 'nan') THEN
        SET in_phi30l1 = NULL;
    END IF; 
    IF TRIM(in_phi60l1slant) IN ('', 'NO', 'nan') THEN
        SET in_phi60l1slant = NULL;
    END IF; 
    IF TRIM(in_avgCCDL1) IN ('', 'NO', 'nan') THEN
        SET in_avgCCDL1 = NULL;
    END IF; 
    IF TRIM(in_sigmaCCDL1) IN ('', 'NO', 'nan') THEN
        SET in_sigmaCCDL1 = NULL;
    END IF; 
    IF TRIM(in_tec45) IN ('', 'NO', 'nan') THEN
        SET in_tec45 = NULL;
    END IF; 
    IF TRIM(in_dtec60_45) IN ('', 'NO', 'nan') THEN
        SET in_dtec60_45 = NULL;
    END IF; 
    IF TRIM(in_tec30) IN ('', 'NO', 'nan') THEN
        SET in_tec30 = NULL;
    END IF; 
    IF TRIM(in_dtec45_30) IN ('', 'NO', 'nan') THEN
        SET in_dtec45_30 = NULL;
    END IF; 
    IF TRIM(in_tec15) IN ('', 'NO', 'nan') THEN
        SET in_tec15 = NULL;
    END IF; 
    IF TRIM(in_dtec30_15) IN ('', 'NO', 'nan') THEN
        SET in_dtec30_15 = NULL;
    END IF; 
    IF TRIM(in_tec0) IN ('', 'NO', 'nan') THEN
        SET in_tec0 = NULL;
    END IF; 
    IF TRIM(in_dtec0) IN ('', 'NO', 'nan') THEN
        SET in_dtec0 = NULL;
    END IF; 
    IF TRIM(in_locktimeL1) IN ('', 'NO', 'nan') THEN
        SET in_locktimeL1 = NULL;
    END IF; 
    IF TRIM(in_reserved) IN ('', 'NO', 'nan') THEN
        SET in_reserved = NULL;
    END IF; 
    IF TRIM(in_2ndlocktime) IN ('', 'NO', 'nan') THEN
        SET in_2ndlocktime = NULL;
    END IF; 
    IF TRIM(in_avgcn2freqTEC) IN ('', 'NO', 'nan') THEN
        SET in_avgcn2freqTEC = NULL;
    END IF; 
    IF TRIM(in_SI_L1_29) IN ('', 'NO', 'nan') THEN
        SET in_SI_L1_29 = NULL;
    END IF; 
    IF TRIM(in_SI_L1_30) IN ('', 'NO', 'nan') THEN
        SET in_SI_L1_30 = NULL;
    END IF; 
    IF TRIM(in_pL1) IN ('', 'NO', 'nan') THEN
        SET in_pL1 = NULL;
    END IF; 
    IF TRIM(in_avg_c_n0_l2c) IN ('', 'NO', 'nan') THEN
        SET in_avg_c_n0_l2c = NULL;
    END IF; 
    IF TRIM(in_totalS4_L2C) IN ('', 'NO', 'nan') THEN
        SET in_totalS4_L2C = NULL;
    END IF; 
    IF TRIM(in_correctionS4_L2C) IN ('', 'NO', 'nan') THEN
        SET in_correctionS4_L2C = NULL;
    END IF; 
    IF TRIM(in_phi01_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi01_l2c = NULL;
    END IF; 
    IF TRIM(in_phi03_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi03_l2c = NULL;
    END IF; 
    IF TRIM(in_phi10_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi10_l2c = NULL;
    END IF; 
    IF TRIM(in_phi30_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi30_l2c = NULL;
    END IF;
    IF TRIM(in_phi60_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi60_l2c = NULL;
    END IF; 
    IF TRIM(in_avgccd_l2c) IN ('', 'NO', 'nan') THEN
        SET in_avgccd_l2c = NULL;
    END IF; 
    IF TRIM(in_sigmaccd_l2c) IN ('', 'NO', 'nan') THEN
        SET in_sigmaccd_l2c = NULL;
    END IF; 
    IF TRIM(in_locktime_l2c) IN ('', 'NO', 'nan') THEN
        SET in_locktime_l2c = NULL;
    END IF; 
    IF TRIM(in_SI_L2C_43) IN ('', 'NO', 'nan') THEN
        SET in_SI_L2C_43 = NULL;
    END IF; 
    IF TRIM(in_SI_L2C_44) IN ('', 'NO', 'nan') THEN
        SET in_SI_L2C_44 = NULL;
    END IF; 
    IF TRIM(in_p_l2c) IN ('', 'NO', 'nan') THEN
        SET in_p_l2c = NULL;
    END IF; 
    IF TRIM(in_avg_c_n0_l5) IN ('', 'NO', 'nan') THEN
        SET in_avg_c_n0_l5 = NULL;
    END IF; 
    IF TRIM(in_totalS4_L5) IN ('', 'NO', 'nan') THEN
        SET in_totalS4_L5 = NULL;
    END IF; 
    IF TRIM(in_correctionS4_L5) IN ('', 'NO', 'nan') THEN
        SET in_correctionS4_L5 = NULL;
    END IF; 
    IF TRIM(in_phi01_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi01_l5 = NULL;
    END IF; 
    IF TRIM(in_phi03_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi03_l5 = NULL;
    END IF; 
    IF TRIM(in_phi10_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi10_l5 = NULL;
    END IF; 
    IF TRIM(in_phi30_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi30_l5 = NULL;
    END IF; 
    IF TRIM(in_phi60_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi60_l5 = NULL;
    END IF; 
    IF TRIM(in_avgccd_l5) IN ('', 'NO', 'nan') THEN
        SET in_avgccd_l5 = NULL;
    END IF; 
    IF TRIM(in_sigmaccd_l5) IN ('', 'NO', 'nan') THEN
        SET in_sigmaccd_l5 = NULL;
    END IF; 
    IF TRIM(in_locktime_l5) IN ('', 'NO', 'nan') THEN
        SET in_locktime_l5 = NULL;
    END IF; 
    IF TRIM(in_SI_L5_57) IN ('', 'NO', 'nan') THEN
        SET in_SI_L5_57 = NULL;
    END IF; 
    IF TRIM(in_SI_L5_58) IN ('', 'NO', 'nan') THEN
        SET in_SI_L5_58 = NULL;
    END IF; 
    IF TRIM(in_p_l5) IN ('', 'NO', 'nan') THEN
        SET in_p_l5 = NULL;
    END IF; 
    IF TRIM(in_t_l1) IN ('', 'NO', 'nan') THEN
        SET in_t_l1 = NULL;
    END IF; 
    IF TRIM(in_t_l2c) IN ('', 'NO', 'nan') THEN
        SET in_t_l2c = NULL;
    END IF; 
    IF TRIM(in_t_l5) IN ('', 'NO', 'nan') THEN
        SET in_t_l5 = NULL;
    END IF; 

    SET @sql = CONCAT('INSERT INTO ', in_station, '(',
            'dt,svid,rxstate,azimuth,elevation,averagel1,totals4l1,corrections4l1,phi01l1,phi03l1,phi10l1,phi30l1,phi60l1slant,avgccdl1,sigmaccdl1,tec45,dtec60_45,tec30,dtec45_30,tec15,dtec30_15,tec0,dtec0,locktimel1,reserved,2ndlocktime,avgcn2freqtec,si_l1_29,si_l1_30,pl1,avg_c_n0_l2c,totals4_l2c,correctionS4_L2C,phi01_l2c,phi03_l2c,phi10_l2c,phi30_l2c,phi60_l2c,avgccd_l2c,sigmaccd_l2c,locktime_l2c,si_l2c_43,si_l2c_44,p_l2c,avg_c_n0_l5,totals4_l5,corrections4_l5,phi01_l5,phi03_l5,phi10_l5,phi30_l5,phi60_l5,avgccd_l5,sigmaccd_l5,locktime_l5,si_l5_57,si_l5_58,p_l5,t_l1,t_l2c,t_l5,fk_file) ',
            ' VALUES(', 
                QUOTE(in_dt),',',
                in_svid,',',
                IF(ISNULL(in_rxstatus), 'NULL',QUOTE(in_rxstatus)),',', 
                IF(ISNULL(in_az), 'NULL', in_az),',', 
                IF(ISNULL(in_elv), 'NULL', in_elv),',',
                IF(ISNULL(in_averageL1), 'NULL', in_averageL1),',',
                IF(ISNULL(in_totalS4L1), 'NULL', in_totalS4L1),',',
                IF(ISNULL(in_correctionS4L1), 'NULL', in_correctionS4L1),',',
                IF(ISNULL(in_phi01l1), 'NULL', in_phi01l1),',',
                IF(ISNULL(in_phi03l1), 'NULL', in_phi03l1),',',
                IF(ISNULL(in_phi10l1), 'NULL', in_phi10l1),',',
                IF(ISNULL(in_phi30l1), 'NULL', in_phi30l1),',',
                IF(ISNULL(in_phi60l1slant), 'NULL', in_phi60l1slant),',',
                IF(ISNULL(in_avgCCDL1), 'NULL', in_avgCCDL1),',',
                IF(ISNULL(in_sigmaCCDL1), 'NULL', in_sigmaCCDL1),',',
                IF(ISNULL(in_tec45), 'NULL', in_tec45),',',
                IF(ISNULL(in_dtec60_45), 'NULL', in_dtec60_45),',',
                IF(ISNULL(in_tec30), 'NULL', in_tec30),',',
                IF(ISNULL(in_dtec45_30), 'NULL', in_dtec45_30),',',
                IF(ISNULL(in_tec15), 'NULL', in_tec15),',',
                IF(ISNULL(in_dtec30_15), 'NULL', in_dtec30_15),',',
                IF(ISNULL(in_tec0), 'NULL', in_tec0),',',
                IF(ISNULL(in_dtec0), 'NULL', in_dtec0),',',
                IF(ISNULL(in_locktimeL1), 'NULL', in_locktimeL1),',',
                QUOTE(IF(ISNULL(in_reserved), 'NULL', in_reserved)),',',
                IF(ISNULL(in_2ndlocktime), 'NULL', in_2ndlocktime),',',
                IF(ISNULL(in_avgcn2freqTEC), 'NULL', in_avgcn2freqTEC),',',
                IF(ISNULL(in_SI_L1_29), 'NULL', in_SI_L1_29),',',
                IF(ISNULL(in_SI_L1_30), 'NULL', in_SI_L1_30),',',
                IF(ISNULL(in_pL1), 'NULL', in_pL1),',',
                IF(ISNULL(in_avg_c_n0_l2c), 'NULL', in_avg_c_n0_l2c),',',
                IF(ISNULL(in_totalS4_L2C), 'NULL', in_totalS4_L2C),',',
                IF(ISNULL(in_correctionS4_L2C), 'NULL', in_correctionS4_L2C),',',
                IF(ISNULL(in_phi01_l2c), 'NULL', in_phi01_l2c),',',
                IF(ISNULL(in_phi03_l2c), 'NULL', in_phi03_l2c),',',
                IF(ISNULL(in_phi10_l2c), 'NULL', in_phi10_l2c),',',
                IF(ISNULL(in_phi30_l2c), 'NULL', in_phi30_l2c),',',
                IF(ISNULL(in_phi60_l2c), 'NULL', in_phi60_l2c),',',
                IF(ISNULL(in_avgccd_l2c), 'NULL', in_avgccd_l2c),',',
                IF(ISNULL(in_sigmaccd_l2c), 'NULL', in_sigmaccd_l2c),',',
                IF(ISNULL(in_locktime_l2c), 'NULL', in_locktime_l2c),',',
                IF(ISNULL(in_SI_L2C_43), 'NULL', in_SI_L2C_43),',',
                IF(ISNULL(in_SI_L2C_44), 'NULL', in_SI_L2C_44),',',
                IF(ISNULL(in_p_l2c), 'NULL', in_p_l2c),',',
                IF(ISNULL(in_avg_c_n0_l5), 'NULL', in_avg_c_n0_l5),',',
                IF(ISNULL(in_totalS4_L5), 'NULL', in_totalS4_L5),',',
                IF(ISNULL(in_correctionS4_L5), 'NULL', in_correctionS4_L5),',',
                IF(ISNULL(in_phi01_l5), 'NULL', in_phi01_l5),',',
                IF(ISNULL(in_phi03_l5), 'NULL', in_phi03_l5),',',
                IF(ISNULL(in_phi10_l5), 'NULL', in_phi10_l5),',',
                IF(ISNULL(in_phi30_l5), 'NULL', in_phi30_l5),',',
                IF(ISNULL(in_phi60_l5), 'NULL', in_phi60_l5),',',
                IF(ISNULL(in_avgccd_l5), 'NULL', in_avgccd_l5),',',
                IF(ISNULL(in_sigmaccd_l5), 'NULL', in_sigmaccd_l5),',',
                IF(ISNULL(in_locktime_l5), 'NULL', in_locktime_l5),',',
                IF(ISNULL(in_SI_L5_57), 'NULL', in_SI_L5_57),',',
                IF(ISNULL(in_SI_L5_58), 'NULL', in_SI_L5_58),',',
                IF(ISNULL(in_p_l5), 'NULL', in_p_l5),',',
                IF(ISNULL(in_t_l1), 'NULL', in_t_l1),',',
                IF(ISNULL(in_t_l2c), 'NULL', in_t_l2c),',',
                IF(ISNULL(in_t_l5), 'NULL', in_t_l5),',',
                in_id_file, ')');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    SELECT ROW_COUNT() INTO l_rowcount;
    DEALLOCATE PREPARE stmt;

    IF l_rowcount = 1 THEN
        SELECT 0 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' inserted') err_message;
    ELSE
        SELECT -1 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' nothing happened') err_message;
    END IF;
commit;
END $$
DELIMITER ;
-- grants
GRANT EXECUTE   ON PROCEDURE sp_ins_sept_row      TO 'writer'@'%';

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ins_sept_file $$
CREATE PROCEDURE sp_ins_sept_file (
    in_station          varchar(5),
    in_filename         varchar(255)
)
COMMENT 'Insert file if not present and create table for septentrio ismr data'
uscita:BEGIN
    DECLARE l_exists            bigint DEFAULT 0;
    DECLARE l_id_file           bigint DEFAULT 0;
    DECLARE l_id_station        bigint DEFAULT 0;

    -- Controllo se la stazione è nella tabella delle stazioni da inserire
    SELECT id INTO l_id_station FROM station WHERE code = in_station;
    IF l_id_station = 0 THEN
        SELECT 10 err_code, 0 id_station, 0 id_file, CONCAT('MESSAGE: station not found: ', in_station) err_message;
        LEAVE uscita;
    END IF;

    -- Controllo se la tabella esiste altrimenti la creo 
    SELECT COUNT(*) INTO l_exists FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = in_station;
-- septentrio table
    IF l_exists = 0 THEN
        SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS ', in_station,'(',
            'dt                 datetime NOT NULL COMMENT \' measure time UTC\',',
            'svid               int     NOT NULL COMMENT \'Sat internal number\',',
            'rxstate            float       NULL COMMENT \'Value of the RxState field of the ReceiverStatus SBF block\',',
            'azimuth            float       NULL COMMENT \'Azimuth (degrees)\',',
            'elevation          float       NULL COMMENT \'Elevation (degrees)\',',
            'averagel1          float       NULL COMMENT \'Average Sig1 C/N0 over the last minute (dB-Hz)\',',
            'totals4l1          float       NULL COMMENT \'Total S4 on Sig1 (dimensionless)\',',
            'corrections4l1     float       NULL COMMENT \'Correction to total S4 on Sig1 (thermal noise component only)(dimensionless)\',',
            'phi01l1            float       NULL COMMENT \'Phi01 on Sig1, 1-second phase sigma (radians)\',',
            'phi03l1            float       NULL COMMENT \'Phi03 on Sig1, 3-second phase sigma (radians)\',',
            'phi10l1            float       NULL COMMENT \'Phi10 on Sig1, 10-second phase sigma (radians)\',',
            'phi30l1            float       NULL COMMENT \'Phi30 on Sig1, 30-second phase sigma (radians\',',
            'phi60l1slant       float       NULL COMMENT \'Phi60 on Sig1, 60-second phase sigma (radians)\',',
            'avgccdl1           float       NULL COMMENT \'AvgCCD on Sig1, average of code/carrier divergence (meters)\',',
            'sigmaccdl1         float       NULL COMMENT \'SigmaCCD on Sig1, standard deviation of code/carrier divergence(meters)\',',
            'tec45              float       NULL COMMENT \'TEC at TOW - 45 seconds (TECU)\',',
            'dtec60_45          float       NULL COMMENT \'dTEC from TOW - 60s to TOW - 45s (TECU)\',',
            'tec30              float       NULL COMMENT \'TEC at TOW - 30 seconds (TECU)\',',
            'dtec45_30          float       NULL COMMENT \'dTEC from TOW - 45s to TOW - 30s (TECU)\',',
            'tec15              float       NULL COMMENT \'TEC at TOW - 15 seconds (TECU)\',',
            'dtec30_15          float       NULL COMMENT \'dTEC from TOW - 30s to TOW - 15s (TECU)\',',
            'tec0               float       NULL COMMENT \'TEC at TOW (TECU)\',',
            'dtec0              float       NULL COMMENT \'dTEC from TOW - 15s to TOW (TECU)\',',
            'locktimel1         int         NULL COMMENT \'Sig1 lock time (seconds)\',',
            'reserved           varchar(50) NULL COMMENT \'sbf2ismr version number\',',
            '2ndlocktime        float       NULL COMMENT \'Lock time on the second frequency used for the TEC computation(seconds)\',',
            'avgcn2freqtec      float       NULL COMMENT \'Averaged C/N0 of second frequency used for the TEC computation (dB-Hz)\',',
            'si_l1_29           float       NULL COMMENT \'SI Index on Sig1:(10*log10(Pmax)-10*log10(Pmin))/(10*log10(Pmax)+10*log10(Pmin))(dimensionless)\',',
            'si_l1_30           float       NULL COMMENT \'SI Index on Sig1, numerator only: 10*log10(Pmax)-10*log10(Pmin) (dB)\',',
            'pl1                float       NULL COMMENT \'p on Sig1, spectral slope of detrended phase in the 0.1 to 25Hz range (dimensionless)\',',
            'avg_c_n0_l2c       float       NULL COMMENT \'Average Sig2 C/N0 over the last minute (dB-Hz)\',',
            'totals4_l2c        float       NULL COMMENT \'Total S4 on Sig2 (dimensionless)\',',
            'correctionS4_L2C   float       NULL COMMENT \'Correction to total S4 on Sig2 (thermal noise component only) (dimensionless)\',',
            'phi01_l2c          float       NULL COMMENT \'Phi01 on Sig2, 1-second phase sigma (radians)\',',
            'phi03_l2c         float       NULL COMMENT \'Phi03 on Sig2, 3-second phase sigma (radians)\',',
            'phi10_l2c          float       NULL COMMENT \'Phi10 on Sig2, 10-second phase sigma (radians)\',',
            'phi30_l2c          float       NULL COMMENT \'Phi30 on Sig2, 30-second phase sigma (radians)\',',
            'phi60_l2c          float       NULL COMMENT \'Phi60 on Sig2, 60-second phase sigma (radians)\',',
            'avgccd_l2c         float       NULL COMMENT \'AvgCCD on Sig2, average of code/carrier divergence (meters)\',',
            'sigmaccd_l2c       float       NULL COMMENT \'SigmaCCD on Sig2, standard deviation of code/carrier divergence (meters)\',',
            'locktime_l2c       float       NULL COMMENT \'Sig2 lock time (seconds)\',',
            'si_l2c_43          float       NULL COMMENT \'SI Index on Sig2 (dimensionless)\',',
            'si_l2c_44          float       NULL COMMENT \'SI Index on Sig2, numerator only (dB)\',',
            'p_l2c              float       NULL COMMENT \'p on Sig2, phase spectral slope in the 0.1 to 25Hz range (dimensionless)\',',
            'avg_c_n0_l5        float       NULL COMMENT \'Average Sig3 C/N0 over the last minute (dB-Hz)\',',
            'totals4_l5         float       NULL COMMENT \'Total S4 on Sig3 (dimensionless)\',',
            'corrections4_l5    float       NULL COMMENT \'Correction to total S4 on Sig3 (thermal noise component only) (dimensionless)\',',
            'phi01_l5           float       NULL COMMENT \'Phi01 on Sig3, 1-second phase sigma (radians)\',',
            'phi03_l5           float       NULL COMMENT \'Phi03 on Sig3, 3-second phase sigma (radians)\',',
            'phi10_l5           float       NULL COMMENT \'Phi10 on Sig3, 10-second phase sigma (radians)\',',
            'phi30_l5           float       NULL COMMENT \'Phi30 on Sig3, 30-second phase sigma (radians)\',',
            'phi60_l5           float       NULL COMMENT \'Phi60 on Sig3, 60-second phase sigma (radians)\',',
            'avgccd_l5          float       NULL COMMENT \'AvgCCD on Sig3, average of code/carrier divergence (meters)\',',
            'sigmaccd_l5        float       NULL COMMENT \'SigmaCCD on Sig3, standard deviation of code/carrier divergence(meters)\',',
            'locktime_l5        float       NULL COMMENT \'Sig3 lock time (seconds)\',',
            'si_l5_57           float       NULL COMMENT \'SI Index on Sig3 (dimensionless)\',',
            'si_l5_58           float       NULL COMMENT \'SI Index on Sig3, numerator only (dB)\',',
            'p_l5               float       NULL COMMENT \'p on Sig3, phase spectral slope in the 0.1 to 25Hz range (dimensionless)\',',
            't_l1               float       NULL COMMENT \'T on Sig1, phase power spectral density at 1 Hz (rad^2/Hz)\',',
            't_l2c              float       NULL COMMENT \'T on Sig2, phase power spectral density at 1 Hz (rad^2/Hz)\',',
            't_l5               float       NULL COMMENT \'T on Sig3, phase power spectral density at 1 Hz (rad^2/Hz)\',',
            'fk_file            bigint           COMMENT \'reference to file table\',',
            'modified timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'Last Review\',',
            'PRIMARY KEY  (dt, svid)',
    '    ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT \'Septntrio instrument table\'');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
   
    -- selezione l'id del file se esiste gia altrimenti lo inserisco
    SELECT id INTO l_id_file
    FROM file
    WHERE name = in_filename
        AND fk_station = l_id_station;

    IF l_id_file = 0 THEN
        INSERT INTO file (name, fk_station)
        VALUES (in_filename, l_id_station);
        SELECT LAST_INSERT_ID() INTO l_id_file;
    END IF;
 
    SELECT 0 err_code, l_id_file id_file, l_id_station id_station, CONCAT('MESSAGE: file id and station id') err_message;
commit;
END $$
DELIMITER ;
-- grants
GRANT EXECUTE   ON PROCEDURE sp_ins_sept_file    TO 'writer'@'%';

-- call sp_ins_novam_row (now(), 'dmc0', 'ccoria', 1, 'rxst',7,8,9,0,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63.1 )
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ins_novam_row $$
CREATE PROCEDURE sp_ins_novam_row (
    in_dt               datetime,
    in_station          varchar(255),
    in_id_file          int,
    in_svid             varchar(255),
    in_az               varchar(255),
    in_elv              varchar(255),
    in_averageL1        varchar(255),
    in_totalS4L1        varchar(255),
    in_correctionS4L1   varchar(255),
    in_phi01l1          varchar(255),
    in_phi03l1          varchar(255),
    in_phi10l1          varchar(255),
    in_phi30l1          varchar(255),
    in_phi60l1slant     varchar(255),
    in_avgCCDL1         varchar(255),
    in_sigmaCCDL1       varchar(255),
    in_tec45            varchar(255),
    in_dtec60_45        varchar(255),
    in_tec30            varchar(255),
    in_dtec45_30        varchar(255),
    in_tec15            varchar(255),
    in_dtec30_15        varchar(255),
    in_tec0             varchar(255),
    in_dtec0            varchar(255),
    in_locktimeL1       varchar(255),
    in_avg_c_n0_l2c     varchar(255),
    in_totalS4_L2C      varchar(255),
    in_correctionS4_L2C varchar(255),
    in_phi01_l2c        varchar(255),
    in_phi03_l2c        varchar(255),
    in_phi10_l2c        varchar(255),
    in_phi30_l2c        varchar(255),
    in_phi60_l2c        varchar(255),
    in_avgccd_l2c       varchar(255),
    in_sigmaccd_l2c     varchar(255),
    in_locktime_l2c     varchar(255),
    in_avg_c_n0_l5      varchar(255),
    in_totalS4_L5       varchar(255),
    in_correctionS4_L5  varchar(255),
    in_phi01_l5         varchar(255),
    in_phi03_l5         varchar(255),
    in_phi10_l5         varchar(255),
    in_phi30_l5         varchar(255),
    in_phi60_l5         varchar(255),
    in_avgccd_l5        varchar(255),
    in_sigmaccd_l5      varchar(255),
    in_locktime_l5      varchar(255),
    in_tec45_2c         varchar(255),
    in_dtec60_45_2c     varchar(255),
    in_tec30_2c         varchar(255),
    in_dtec45_30_2c     varchar(255),
    in_tec15_2c         varchar(255),
    in_dtec30_15_2c     varchar(255),
    in_tec0_2c          varchar(255),
    in_dtec0_2c         varchar(255)
)
COMMENT 'Insert a single septentrio data row'
uscita:BEGIN
    DECLARE l_rowcount      int DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR 1452 BEGIN
        SELECT 2 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' father absent') err_message;
    END;
--    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
--        SELECT 3 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' sqlexception') err_message;
--    END;
--    DECLARE EXIT HANDLER FOR 1264 BEGIN
--        SELECT 3 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' out of range number') err_message;
--    END;

    DECLARE EXIT HANDLER FOR 1062 BEGIN
        SELECT 4 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' duplicate row') err_message;
    END;

    IF TRIM(in_dt) IN ('', 'NO', 'nan') THEN
        SET in_dt = NULL;
    END IF;
    IF TRIM(in_station) IN ('', 'NO', 'nan') THEN
        SET in_station = NULL;
    END IF; 
    IF TRIM(in_svid) IN ('', 'NO', 'nan') THEN
        SET in_svid = NULL;
    END IF; 
    IF TRIM(in_az) IN ('', 'NO', 'nan') THEN
        SET in_az = NULL;
    END IF; 
    IF TRIM(in_elv) IN ('', 'NO', 'nan') THEN
        SET in_elv = NULL;
    END IF; 
    IF TRIM(in_averageL1) IN ('', 'NO', 'nan') THEN
        SET in_averageL1 = NULL;
    END IF; 
    IF TRIM(in_totalS4L1) IN ('', 'NO', 'nan') THEN
        SET in_totalS4L1  = NULL;
    END IF; 
    IF TRIM(in_correctionS4L1) IN ('', 'NO', 'nan') THEN
        SET in_correctionS4L1 = NULL;
    END IF; 
    IF TRIM(in_phi01l1) IN ('', 'NO', 'nan') THEN
        SET in_phi01l1 = NULL;
    END IF; 
    IF TRIM(in_phi03l1) IN ('', 'NO', 'nan') THEN
        SET in_phi03l1 = NULL;
    END IF; 
    IF TRIM(in_phi10l1) IN ('', 'NO', 'nan') THEN
        SET in_phi10l1 = NULL;
    END IF; 
    IF TRIM(in_phi30l1) IN ('', 'NO', 'nan') THEN
        SET in_phi30l1 = NULL;
    END IF; 
    IF TRIM(in_phi60l1slant) IN ('', 'NO', 'nan') THEN
        SET in_phi60l1slant = NULL;
    END IF; 
    IF TRIM(in_avgCCDL1) IN ('', 'NO', 'nan') THEN
        SET in_avgCCDL1 = NULL;
    END IF; 
    IF TRIM(in_sigmaCCDL1) IN ('', 'NO', 'nan') THEN
        SET in_sigmaCCDL1 = NULL;
    END IF; 
    IF TRIM(in_tec45) IN ('', 'NO', 'nan') THEN
        SET in_tec45 = NULL;
    END IF; 
    IF TRIM(in_dtec60_45) IN ('', 'NO', 'nan') THEN
        SET in_dtec60_45 = NULL;
    END IF; 
    IF TRIM(in_tec30) IN ('', 'NO', 'nan') THEN
        SET in_tec30 = NULL;
    END IF; 
    IF TRIM(in_dtec45_30) IN ('', 'NO', 'nan') THEN
        SET in_dtec45_30 = NULL;
    END IF; 
    IF TRIM(in_tec15) IN ('', 'NO', 'nan') THEN
        SET in_tec15 = NULL;
    END IF; 
    IF TRIM(in_dtec30_15) IN ('', 'NO', 'nan') THEN
        SET in_dtec30_15 = NULL;
    END IF; 
    IF TRIM(in_tec0) IN ('', 'NO', 'nan') THEN
        SET in_tec0 = NULL;
    END IF; 
    IF TRIM(in_dtec0) IN ('', 'NO', 'nan') THEN
        SET in_dtec0 = NULL;
    END IF; 
    IF TRIM(in_locktimeL1) IN ('', 'NO', 'nan') THEN
        SET in_locktimeL1 = NULL;
    END IF; 
    IF TRIM(in_avg_c_n0_l2c) IN ('', 'NO', 'nan') THEN
        SET in_avg_c_n0_l2c = NULL;
    END IF; 
    IF TRIM(in_totalS4_L2C) IN ('', 'NO', 'nan') THEN
        SET in_totalS4_L2C = NULL;
    END IF; 
    IF TRIM(in_correctionS4_L2C) IN ('', 'NO', 'nan') THEN
        SET in_correctionS4_L2C = NULL;
    END IF; 
    IF TRIM(in_phi01_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi01_l2c = NULL;
    END IF; 
    IF TRIM(in_phi03_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi03_l2c = NULL;
    END IF; 
    IF TRIM(in_phi10_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi10_l2c = NULL;
    END IF; 
    IF TRIM(in_phi30_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi30_l2c = NULL;
    END IF;
    IF TRIM(in_phi60_l2c) IN ('', 'NO', 'nan') THEN
        SET in_phi60_l2c = NULL;
    END IF; 
    IF TRIM(in_avgccd_l2c) IN ('', 'NO', 'nan') THEN
        SET in_avgccd_l2c = NULL;
    END IF; 
    IF TRIM(in_sigmaccd_l2c) IN ('', 'NO', 'nan') THEN
        SET in_sigmaccd_l2c = NULL;
    END IF; 
    IF TRIM(in_locktime_l2c) IN ('', 'NO', 'nan') THEN
        SET in_locktime_l2c = NULL;
    END IF; 
    IF TRIM(in_avg_c_n0_l5) IN ('', 'NO', 'nan') THEN
        SET in_avg_c_n0_l5 = NULL;
    END IF; 
    IF TRIM(in_totalS4_L5) IN ('', 'NO', 'nan') THEN
        SET in_totalS4_L5 = NULL;
    END IF; 
    IF TRIM(in_correctionS4_L5) IN ('', 'NO', 'nan') THEN
        SET in_correctionS4_L5 = NULL;
    END IF; 
    IF TRIM(in_phi01_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi01_l5 = NULL;
    END IF; 
    IF TRIM(in_phi03_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi03_l5 = NULL;
    END IF; 
    IF TRIM(in_phi10_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi10_l5 = NULL;
    END IF; 
    IF TRIM(in_phi30_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi30_l5 = NULL;
    END IF; 
    IF TRIM(in_phi60_l5) IN ('', 'NO', 'nan') THEN
        SET in_phi60_l5 = NULL;
    END IF; 
    IF TRIM(in_avgccd_l5) IN ('', 'NO', 'nan') THEN
        SET in_avgccd_l5 = NULL;
    END IF; 
    IF TRIM(in_sigmaccd_l5) IN ('', 'NO', 'nan') THEN
        SET in_sigmaccd_l5 = NULL;
    END IF; 
    IF TRIM(in_locktime_l5) IN ('', 'NO', 'nan') THEN
        SET in_locktime_l5 = NULL;
    END IF; 

    IF TRIM(in_tec45_2c) IN ('', 'NO', 'nan') THEN
        SET in_tec45_2c = NULL;
    END IF; 
    IF TRIM(in_dtec60_45_2c) IN ('', 'NO', 'nan') THEN
        SET in_dtec60_45_2c = NULL;
    END IF; 
    IF TRIM(in_tec30_2c) IN ('', 'NO', 'nan') THEN
        SET in_tec30_2c = NULL;
    END IF; 
    IF TRIM(in_dtec45_30_2c) IN ('', 'NO', 'nan') THEN
        SET in_dtec45_30_2c = NULL;
    END IF; 
    IF TRIM(in_tec15_2c) IN ('', 'NO', 'nan') THEN
        SET in_tec15_2c = NULL;
    END IF; 
    IF TRIM(in_dtec30_15_2c) IN ('', 'NO', 'nan') THEN
        SET in_dtec30_15_2c = NULL;
    END IF; 
    IF TRIM(in_tec0_2c) IN ('', 'NO', 'nan') THEN
        SET in_tec0_2c = NULL;
    END IF; 
    IF TRIM(in_dtec0_2c) IN ('', 'NO', 'nan') THEN
        SET in_dtec0_2c = NULL;
    END IF; 

    SET @sql = CONCAT('INSERT INTO ', in_station, '(',
        'dt, svid, azimuth, elevation, averagel1, totals4l1, corrections4l1, phi01l1, phi03l1, phi10l1, phi30l1, phi60l1slant, avgccdl1, sigmaccdl1, tec45, dtec60_45, tec30, dtec45_30, tec15, dtec30_15, tec0, dtec0, locktimel1, avg_c_n0_l2c, totals4_l2c, correctionS4_L2C, phi01_l2c, phi03_l2c, phi10_l2c, phi30_l2c, phi60_l2c, avgccd_l2c, sigmaccd_l2c, locktime_l2c, avg_c_n0_l5, totals4_l5, corrections4_l5, phi01_l5, phi03_l5, phi10_l5, phi30_l5, phi60_l5, avgccd_l5, sigmaccd_l5, locktime_l5, tec45_2c, dtec60_45_2c, tec30_2c, dtec45_30_2c, tec15_2c, dtec30_15_2c, tec0_2c, dtec0_2c, fk_file',
            ') VALUES(', 
                QUOTE(in_dt),',',
                in_svid,',',
                IF(ISNULL(in_az), 'NULL', in_az),',', 
                IF(ISNULL(in_elv), 'NULL', in_elv),',',
                IF(ISNULL(in_averageL1), 'NULL', in_averageL1),',',
                IF(ISNULL(in_totalS4L1), 'NULL', in_totalS4L1),',',
                IF(ISNULL(in_correctionS4L1), 'NULL', in_correctionS4L1),',',
                IF(ISNULL(in_phi01l1), 'NULL', in_phi01l1),',',
                IF(ISNULL(in_phi03l1), 'NULL', in_phi03l1),',',
                IF(ISNULL(in_phi10l1), 'NULL', in_phi10l1),',',
                IF(ISNULL(in_phi30l1), 'NULL', in_phi30l1),',',
                IF(ISNULL(in_phi60l1slant), 'NULL', in_phi60l1slant),',',
                IF(ISNULL(in_avgCCDL1), 'NULL', in_avgCCDL1),',',
                IF(ISNULL(in_sigmaCCDL1), 'NULL', in_sigmaCCDL1),',',
                IF(ISNULL(in_tec45), 'NULL', in_tec45),',',
                IF(ISNULL(in_dtec60_45), 'NULL', in_dtec60_45),',',
                IF(ISNULL(in_tec30), 'NULL', in_tec30),',',
                IF(ISNULL(in_dtec45_30), 'NULL', in_dtec45_30),',',
                IF(ISNULL(in_tec15), 'NULL', in_tec15),',',
                IF(ISNULL(in_dtec30_15), 'NULL', in_dtec30_15),',',
                IF(ISNULL(in_tec0), 'NULL', in_tec0),',',
                IF(ISNULL(in_dtec0), 'NULL', in_dtec0),',',
                IF(ISNULL(in_locktimeL1), 'NULL', in_locktimeL1),',',
                IF(ISNULL(in_avg_c_n0_l2c), 'NULL', in_avg_c_n0_l2c),',',
                IF(ISNULL(in_totalS4_L2C), 'NULL', in_totalS4_L2C),',',
                IF(ISNULL(in_correctionS4_L2C), 'NULL', in_correctionS4_L2C),',',
                IF(ISNULL(in_phi01_l2c), 'NULL', in_phi01_l2c),',',
                IF(ISNULL(in_phi03_l2c), 'NULL', in_phi03_l2c),',',
                IF(ISNULL(in_phi10_l2c), 'NULL', in_phi10_l2c),',',
                IF(ISNULL(in_phi30_l2c), 'NULL', in_phi30_l2c),',',
                IF(ISNULL(in_phi60_l2c), 'NULL', in_phi60_l2c),',',
                IF(ISNULL(in_avgccd_l2c), 'NULL', in_avgccd_l2c),',',
                IF(ISNULL(in_sigmaccd_l2c), 'NULL', in_sigmaccd_l2c),',',
                IF(ISNULL(in_locktime_l2c), 'NULL', in_locktime_l2c),',',
                IF(ISNULL(in_avg_c_n0_l5), 'NULL', in_avg_c_n0_l5),',',
                IF(ISNULL(in_totalS4_L5), 'NULL', in_totalS4_L5),',',
                IF(ISNULL(in_correctionS4_L5), 'NULL', in_correctionS4_L5),',',
                IF(ISNULL(in_phi01_l5), 'NULL', in_phi01_l5),',',
                IF(ISNULL(in_phi03_l5), 'NULL', in_phi03_l5),',',
                IF(ISNULL(in_phi10_l5), 'NULL', in_phi10_l5),',',
                IF(ISNULL(in_phi30_l5), 'NULL', in_phi30_l5),',',
                IF(ISNULL(in_phi60_l5), 'NULL', in_phi60_l5),',',
                IF(ISNULL(in_avgccd_l5), 'NULL', in_avgccd_l5),',',
                IF(ISNULL(in_sigmaccd_l5), 'NULL', in_sigmaccd_l5),',',
                IF(ISNULL(in_locktime_l5), 'NULL', in_locktime_l5),',',
                IF(ISNULL(in_tec45_2c), 'NULL', in_tec45_2c),',',
                IF(ISNULL(in_dtec60_45_2c), 'NULL', in_dtec60_45_2c),',',
                IF(ISNULL(in_tec30_2c), 'NULL', in_tec30_2c),',',
                IF(ISNULL(in_dtec45_30_2c), 'NULL', in_dtec45_30_2c),',',
                IF(ISNULL(in_tec15_2c), 'NULL', in_tec15_2c),',',
                IF(ISNULL(in_dtec30_15_2c), 'NULL', in_dtec30_15_2c),',',
                IF(ISNULL(in_tec0_2c), 'NULL', in_tec0_2c),',',
                IF(ISNULL(in_dtec0_2c), 'NULL', in_dtec0_2c),',',
                in_id_file, ')');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    SELECT ROW_COUNT() INTO l_rowcount;
    DEALLOCATE PREPARE stmt;

    IF l_rowcount = 1 THEN
        SELECT 0 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' inserted') err_message;
    ELSE
        SELECT -1 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_svid, ' nothing happened') err_message;
    END IF;
commit;
END $$
DELIMITER ;
-- grants
GRANT EXECUTE   ON PROCEDURE sp_ins_novam_row      TO 'writer'@'%';

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ins_novam_file $$
CREATE PROCEDURE sp_ins_novam_file (
    in_station          varchar(5),
    in_filename         varchar(255)
)
COMMENT 'Insert file if not present and create table for se'
uscita:BEGIN
    DECLARE l_exists            bigint DEFAULT 0;
    DECLARE l_id_file           bigint DEFAULT 0;
    DECLARE l_id_station        bigint DEFAULT 0;

    -- Controllo se la stazione è nella tabella delle stazioni da inserire
    SELECT id INTO l_id_station FROM station WHERE code = in_station;
    IF l_id_station = 0 THEN
        SELECT 10 err_code, 0 id_station, 0 id_file, CONCAT('MESSAGE: station not found: ', in_station) err_message;
        LEAVE uscita;
    END IF;

    -- Controllo se la tabella esiste altrimenti la creo 
    SELECT COUNT(*) INTO l_exists FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = in_station;
-- novatel multi
    IF l_exists = 0 THEN
        SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS ', in_station,'(',
            'dt                 datetime NOT NULL COMMENT \' measure time UTC\',',
            'svid               int     NOT NULL COMMENT \'Sat internal number\',',
            'azimuth            float       NULL COMMENT \'Azimuth (degrees)\',',
            'elevation          float       NULL COMMENT \'Elevation (degrees)\',',
            'averagel1          float       NULL COMMENT \'Average Sig1 C/N0 over the last minute (dB-Hz)\',',
            'totals4l1          float       NULL COMMENT \'Total S4 on Sig1 (dimensionless)\',',
            'corrections4l1     float       NULL COMMENT \'Correction to total S4 on Sig1 (thermal noise component only)(dimensionless)\',',
            'phi01l1            float       NULL COMMENT \'Phi01 on Sig1, 1-second phase sigma (radians)\',',
            'phi03l1            float       NULL COMMENT \'Phi03 on Sig1, 3-second phase sigma (radians)\',',
            'phi10l1            float       NULL COMMENT \'Phi10 on Sig1, 10-second phase sigma (radians)\',',
            'phi30l1            float       NULL COMMENT \'Phi30 on Sig1, 30-second phase sigma (radians\',',
            'phi60l1slant       float       NULL COMMENT \'Phi60 on Sig1, 60-second phase sigma (radians)\',',
            'avgccdl1           float       NULL COMMENT \'AvgCCD on Sig1, average of code/carrier divergence (meters)\',',
            'sigmaccdl1         float       NULL COMMENT \'SigmaCCD on Sig1, standard deviation of code/carrier divergence(meters)\',',
            'tec45              float       NULL COMMENT \'TEC at TOW - 45 seconds (TECU)\',',
            'dtec60_45          float       NULL COMMENT \'dTEC from TOW - 60s to TOW - 45s (TECU)\',',
            'tec30              float       NULL COMMENT \'TEC at TOW - 30 seconds (TECU)\',',
            'dtec45_30          float       NULL COMMENT \'dTEC from TOW - 45s to TOW - 30s (TECU)\',',
            'tec15              float       NULL COMMENT \'TEC at TOW - 15 seconds (TECU)\',',
            'dtec30_15          float       NULL COMMENT \'dTEC from TOW - 30s to TOW - 15s (TECU)\',',
            'tec0               float       NULL COMMENT \'TEC at TOW (TECU)\',',
            'dtec0              float       NULL COMMENT \'dTEC from TOW - 15s to TOW (TECU)\',',
            'locktimel1         float       NULL COMMENT \'Sig1 lock time (seconds)\',',
            'avg_c_n0_l2c       float       NULL COMMENT \'Average Sig2 C/N0 over the last minute (dB-Hz)\',',
            'totals4_l2c        float       NULL COMMENT \'Total S4 on Sig2 (dimensionless)\',',
            'correctionS4_L2C   float       NULL COMMENT \'Correction to total S4 on Sig2 (thermal noise component only) (dimensionless)\',',
            'phi01_l2c          float       NULL COMMENT \'Phi01 on Sig2, 1-second phase sigma (radians)\',',
            'phi03_l2c          float       NULL COMMENT \'Phi03 on Sig2, 3-second phase sigma (radians)\',',
            'phi10_l2c          float       NULL COMMENT \'Phi10 on Sig2, 10-second phase sigma (radians)\',',
            'phi30_l2c          float       NULL COMMENT \'Phi30 on Sig2, 30-second phase sigma (radians)\',',
            'phi60_l2c          float       NULL COMMENT \'Phi60 on Sig2, 60-second phase sigma (radians)\',',
            'avgccd_l2c         float       NULL COMMENT \'AvgCCD on Sig2, average of code/carrier divergence (meters)\',',
            'sigmaccd_l2c       float       NULL COMMENT \'SigmaCCD on Sig2, standard deviation of code/carrier divergence (meters)\',',
            'locktime_l2c       float       NULL COMMENT \'Sig2 lock time (seconds)\',',
            'avg_c_n0_l5        float       NULL COMMENT \'Average Sig3 C/N0 over the last minute (dB-Hz)\',',
            'totals4_l5         float       NULL COMMENT \'Total S4 on Sig3 (dimensionless)\',',
            'corrections4_l5    float       NULL COMMENT \'Correction to total S4 on Sig3 (thermal noise component only) (dimensionless)\',',
            'phi01_l5           float       NULL COMMENT \'Phi01 on Sig3, 1-second phase sigma (radians)\',',
            'phi03_l5           float       NULL COMMENT \'Phi03 on Sig3, 3-second phase sigma (radians)\',',
            'phi10_l5           float       NULL COMMENT \'Phi10 on Sig3, 10-second phase sigma (radians)\',',
            'phi30_l5           float       NULL COMMENT \'Phi30 on Sig3, 30-second phase sigma (radians)\',',
            'phi60_l5           float       NULL COMMENT \'Phi60 on Sig3, 60-second phase sigma (radians)\',',
            'avgccd_l5          float       NULL COMMENT \'AvgCCD on Sig3, average of code/carrier divergence (meters)\',',
            'sigmaccd_l5        float       NULL COMMENT \'SigmaCCD on Sig3, standard deviation of code/carrier divergence(meters)\',',
            'locktime_l5        float       NULL COMMENT \'Sig3 lock time (seconds)\',',
            'tec45_2c           float       NULL COMMENT \'TEC at TOW - 45 seconds (TECU)\',',
            'dtec60_45_2c       float       NULL COMMENT \'dTEC from TOW - 60s to TOW - 45s (TECU)\',',
            'tec30_2c           float       NULL COMMENT \'TEC at TOW - 30 seconds (TECU)\',',
            'dtec45_30_2c       float       NULL COMMENT \'dTEC from TOW - 45s to TOW - 30s (TECU)\',',
            'tec15_2c           float       NULL COMMENT \'TEC at TOW - 15 seconds (TECU)\',',
            'dtec30_15_2c       float       NULL COMMENT \'dTEC from TOW - 30s to TOW - 15s (TECU)\',',
            'tec0_2c            float       NULL COMMENT \'TEC at TOW (TECU)\',',
            'dtec0_2c           float       NULL COMMENT \'dTEC from TOW - 15s to TOW (TECU)\',',
            'fk_file            bigint           COMMENT \'reference to file table\',',
            'modified timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'Last Review\',',
            'PRIMARY KEY  (dt, svid)',
    '    ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT \'Novatel multiconstellation instrument table\'');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
   


    -- selezione l'id del file se esiste
    SELECT id INTO l_id_file
    FROM file
    WHERE name = in_filename
        AND fk_station = l_id_station;

    IF l_id_file = 0 THEN
        INSERT INTO file (name, fk_station)
        VALUES (in_filename, l_id_station);
        SELECT LAST_INSERT_ID() INTO l_id_file;
    END IF;
 
    SELECT 0 err_code, l_id_file id_file, l_id_station id_station, CONCAT('MESSAGE: file id and station id') err_message;
commit;
END $$
DELIMITER ;
-- grants
GRANT EXECUTE   ON PROCEDURE sp_ins_novam_file    TO 'writer'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_gmttime2date  $$
CREATE FUNCTION `fn_gmttime2date`(in_week INT, in_sec INT) RETURNS datetime
    DETERMINISTIC
    COMMENT 'to convert gmt time in date time'
BEGIN
    RETURN DATE_ADD(DATE_ADD('1980-01-06 00:00:00', INTERVAL in_week WEEK), INTERVAL in_sec SECOND);
END $$
DELIMITER ;
-- grants
GRANT EXECUTE ON FUNCTION fn_gmttime2date        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_gmttime2date        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_date4seed  $$
CREATE FUNCTION `fn_date4seed`(in_date DATETIME) RETURNS char(22) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE l_day CHAR(3);
    IF DAYOFYEAR(in_date)<10 THEN
        SET l_day = CONCAT('00',DAYOFYEAR(in_date));
    ELSEIF (DAYOFYEAR(in_date) > 9 AND DAYOFYEAR(in_date)<100) THEN
        SET l_day = CONCAT('0',DAYOFYEAR(in_date));
    ELSEIF (DAYOFYEAR(in_date)>99) THEN
        SET l_day = DAYOFYEAR(in_date);
    END IF;
    RETURN CONCAT(YEAR(in_date),',',l_day,',',TIME(in_date)); 
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_date4seed        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_date4seed        TO 'ws-reader'@'%';


DELIMITER $$
DROP FUNCTION IF EXISTS fn_seed4date  $$
CREATE FUNCTION `fn_seed4date`(in_date VARCHAR(22)) RETURNS datetime
    DETERMINISTIC
BEGIN
    RETURN CONCAT(MAKEDATE(LEFT(in_date, 4), MID(in_date, INSTR(in_date, ',')+1, 3)), ' ', MID(in_date, 10, LENGTH(in_date)));
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_date4seed        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_date4seed        TO 'ws-reader'@'%';

-- nuova nomenclatura

DELIMITER $$
DROP FUNCTION IF EXISTS fn_dt2wn  $$
CREATE FUNCTION fn_dt2wn(in_dt datetime) RETURNS int
    DETERMINISTIC
    COMMENT 'returns the wn of a datetime'
BEGIN
    RETURN FLOOR(DATEDIFF(in_dt, '1980-01-06')/7);
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_dt2wn        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_dt2wn        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_dt2tow  $$
CREATE FUNCTION fn_dt2tow(in_dt datetime) RETURNS int
    DETERMINISTIC
    COMMENT 'returns the wn of a datetime'
BEGIN
--    RETURN UNIX_TIMESTAMP(in_dt) - UNIX_TIMESTAMP(DATE_ADD('1980-01-06', INTERVAL FLOOR(DATEDIFF(in_dt, '1980-01-01')/7)*7 DAY));
    RETURN UNIX_TIMESTAMP(in_dt)-UNIX_TIMESTAMP(fn_gmt2dt(fn_dt2wn(in_dt),0));
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_dt2tow        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_dt2tow        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_gmt2dt  $$
CREATE FUNCTION `fn_gmt2dt`(in_week INT, in_sec INT) RETURNS datetime
    DETERMINISTIC
    COMMENT 'to convert gmt time in date time'
BEGIN
    RETURN DATE_ADD(DATE_ADD('1980-01-06 00:00:00', INTERVAL in_week WEEK), INTERVAL in_sec SECOND);
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_gmt2dt        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_gmt2dt        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_isnan  $$
CREATE FUNCTION fn_isnan(in_data VARCHAR(255)) RETURNS varchar(255)
    DETERMINISTIC
    COMMENT 'returns nan if null'
BEGIN
    SET in_data = IF(in_data=999, NULL, in_data); 
    RETURN IF(ISNULL(in_data), 'nan', in_data);
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_isnan        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_isnan        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_dt2jday $$
CREATE FUNCTION fn_dt2jday (in_date DATETIME) RETURNS char(22) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE l_day CHAR(3);
    IF DAYOFYEAR(in_date)<10 THEN
        SET l_day = CONCAT('00',DAYOFYEAR(in_date));
    ELSEIF (DAYOFYEAR(in_date) > 9 AND DAYOFYEAR(in_date)<100) THEN
        SET l_day = CONCAT('0',DAYOFYEAR(in_date));
    ELSEIF (DAYOFYEAR(in_date)>99) THEN
        SET l_day = DAYOFYEAR(in_date);
    END IF;
    RETURN CONCAT(YEAR(in_date),',',l_day,',',TIME(in_date));
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_dt2jday        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_dt2jday        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_jday2dt $$
CREATE FUNCTION fn_jday2dt (in_date VARCHAR(22)) RETURNS datetime
    DETERMINISTIC
BEGIN
    RETURN CONCAT(MAKEDATE(LEFT(in_date, 4), MID(in_date, INSTR(in_date, ',')+1, 3)), ' ', MID(in_date, 10, LENGTH(in_date)));
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_jday2dt        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_jday2dt        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_s4_l1_vert $$
CREATE FUNCTION fn_s4_l1_vert (in_totalS4L1 double, in_correctionS4L1 double, in_pL1 double, in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    -- valore sqrt(totalS4L1^2-correctionS4L1^2)/F^(( pL1+1)/4)
    -- RETURN SQRT(POW(in_totalS4L1,2)-POW(in_correctionS4L1,2)) / POW(fn_F(in_elevation), ( in_pL1+1)/4) ;
    RETURN fn_s4_l1_slant(in_totalS4L1, in_correctionS4L1) / POW(fn_F(in_elevation), ( in_pL1+1)/4) ;
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_s4_l1_vert        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_s4_l1_vert        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_phi60_l1_vert $$
CREATE FUNCTION fn_phi60_l1_vert (in_phi60l1slant double, in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    -- phi60_l1_vert          phi60l1slant/F^0.5
    RETURN in_phi60l1slant / POW(fn_F(in_elevation), 0.5);
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_phi60_l1_vert        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_phi60_l1_vert        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_stec $$
CREATE FUNCTION fn_stec (in_tec0 double, in_tec15 double, in_tec30 double, in_tec45 double) RETURNS double
    DETERMINISTIC
BEGIN
    -- stec                   (tec0+tec15+ tec30+ tec45)/4
    RETURN (in_tec0+in_tec15+in_tec30+ in_tec45)/4;
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_stec        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_stec        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_vtec $$
CREATE FUNCTION fn_vtec (in_tec0 double, in_tec15 double, in_tec30 double, in_tec45 double, in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    -- vtec                   (tec0+tec15+ tec30+ tec45)/(4*F)
    RETURN (in_tec0+in_tec15+in_tec30+ in_tec45) / (fn_F(in_elevation) * 4);
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_vtec        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_vtec        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_F $$
CREATE FUNCTION fn_F (in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    -- F=1/sqrt(1-(6371 * cos (elevation)     / 6721 )^2)
    RETURN 1/SQRT(1-POW((6371 * COS(RADIANS(in_elevation)) / 6721 ), 2));
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_F        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_F        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_s4_l1_slant $$
CREATE FUNCTION fn_s4_l1_slant (in_totalS4L1 double, in_correctionS4L1 double) RETURNS double
    DETERMINISTIC
BEGIN
    --  s4_l1_slant            sqrt(totalS4L1^2-correctionS4L1^2)
    IF ((POW(in_totalS4L1, 2) - POW(in_correctionS4L1, 2)) > 0) THEN
        RETURN SQRT(POW(in_totalS4L1, 2) - POW(in_correctionS4L1, 2));
    ELSE
        RETURN 0;
    END IF;
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_s4_l1_slant        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_s4_l1_slant        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_s4_l2_vert $$
CREATE FUNCTION fn_s4_l2_vert (in_totalS4_L2C double, in_correctionS4_L2C double, in_p_l2c double, in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    --   s4_l2_vert             sqrt(totalS4_L2C^2-correctionS4_L2C^2)/F^(( p_l2c +1)/4)
    -- RETURN SQRT(POW(in_totalS4_L2C, 2) - POW(in_correctionS4_L2C, 2)) / POW(fn_F(in_elevation), ((in_p_l2c +1)/4)) ;
    RETURN fn_s4_l2_slant( in_totalS4_L2C, in_correctionS4_L2C) / POW(fn_F(in_elevation), ((in_p_l2c +1)/4)) ;
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_s4_l2_vert        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_s4_l2_vert        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_phi60_l2_vert $$
CREATE FUNCTION fn_phi60_l2_vert (in_phi60_l2c double, in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    --   phi60_l2_vert          phi60_l2c/F^0.5
    RETURN in_phi60_l2c / POW(fn_F(in_elevation), 0.5);
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_phi60_l2_vert        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_phi60_l2_vert        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_s4_l2_slant $$
CREATE FUNCTION fn_s4_l2_slant (in_totalS4_L2C double, in_correctionS4_L2C double) RETURNS double
    DETERMINISTIC
BEGIN
    --    s4_l2_slant            sqrt(totalS4_L2C^2-correctionS4_L2C^2)
    IF ( (POW(in_totalS4_L2C, 2) - POW(in_correctionS4_L2C, 2) ) > 0) THEN
        RETURN SQRT( POW(in_totalS4_L2C, 2) - POW(in_correctionS4_L2C, 2));
    ELSE
        RETURN 0;
    END IF;

END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_s4_l2_slant        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_s4_l2_slant        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_s4_l5_vert $$
CREATE FUNCTION fn_s4_l5_vert (in_totalS4_L5 double, in_correctionS4_L5 double, in_p_l5 double, in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    --    s4_l5_vert             sqrt(totalS4_L5^2-correctionS4_L5^2)/F^(( p_l5 +1)/4)       
    -- RETURN SQRT(POW(in_totalS4_L5, 2) - POW(in_correctionS4_L5, 2)) / POW(fn_F(in_elevation), ((in_p_l5 +1)/4)) ;
    RETURN fn_s4_l5_slant(in_totalS4_L5, in_correctionS4_L5) / POW(fn_F(in_elevation), ((in_p_l5 +1)/4)) ;
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_s4_l2_slant        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_s4_l2_slant        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_phi60_l5_vert $$
CREATE FUNCTION fn_phi60_l5_vert (in_phi60_l5 double, in_elevation double) RETURNS double
    DETERMINISTIC
BEGIN
    --    phi60_l5_vert          phi60_l5/F^0.5
    RETURN in_phi60_l5 / POW(fn_F(in_elevation), 0.5);
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_phi60_l5_vert        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_phi60_l5_vert        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_s4_l5_slant $$
CREATE FUNCTION fn_s4_l5_slant (in_totalS4_L5 double, in_correctionS4_L5 double) RETURNS double
    DETERMINISTIC
BEGIN
    --   s4_l5_slant            sqrt(totalS4_L5^2-correctionS4_L5^2)
    IF ( (POW(in_totalS4_L5, 2) - POW(in_correctionS4_L5, 2)) >0 ) THEN
        RETURN SQRT( POW(in_totalS4_L5, 2) - POW(in_correctionS4_L5, 2));
    ELSE
        RETURN 0;
    END IF;

END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_s4_l5_slant        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_s4_l5_slant        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_ismr_latlon $$
CREATE FUNCTION fn_ismr_latlon (in_ll int, in_stalat double, in_stalon double, in_az double, in_el double) RETURNS double
    DETERMINISTIC
BEGIN
    DECLARE l_lat       DOUBLE DEFAULT 0;
    DECLARE l_lon       DOUBLE DEFAULT 0;
    DECLARE l_sbet      DOUBLE;
    DECLARE l_bet       DOUBLE;
    DECLARE l_alf       DOUBLE;
    DECLARE l_phi       DOUBLE;
    DECLARE l_slam      DOUBLE;
    DECLARE l_clam      DOUBLE;
    DECLARE l_lam       DOUBLE;
    DECLARE l_zen       DOUBLE;

    DECLARE l_Re        DOUBLE DEFAULT 6373;
    DECLARE l_h         DOUBLE DEFAULT 350;

    -- Re=6373; %Earth's radius

    -- %coversion to radians
    -- stalat=stalat*pi/180;
    -- stalon=stalon*pi/180;
    -- az=az.*pi/180;
    -- zen=zen.*pi/180;

    SET in_stalon       = RADIANS(in_stalon);
    SET in_stalat       = RADIANS(in_stalat);
    SET in_az           = RADIANS(in_az);
    SET l_zen           = RADIANS(90-in_el );
--    SET l_zen           = RADIANS(in_el-90 );

    -- %angle between geocentre and observing station from the satellite
    -- sbet=Re*sin(zen)/(Re+h);
    SET l_sbet = l_Re * SIN(l_zen)/(l_Re + l_h);
    -- bet=asin(sbet);
    SET l_bet   = ASIN(l_sbet);
    --  %angle from the geocenter between observer and satellite
    --  alf=zen-bet;
    SET l_alf   = l_zen - l_bet;

    -- %geographic latitude of subsatellite point
    -- phi=asin(sin(stalat).*cos(alf)+cos(stalat).*sin(alf).*cos(az));
    SET l_phi   = ASIN(SIN(in_stalat) * COS(l_alf) + COS(in_stalat) * SIN(l_alf) * COS(in_az));

    -- %geographic longitude of the subsatellite point
    -- slam=sin(alf).*sin(az)./cos(phi);
    SET l_slam  = SIN(l_alf) * SIN(in_az) / COS(l_phi);
    -- clam=(cos(alf)-sin(stalat).*sin(phi))./cos(stalat)./cos(stalat);
    SET l_clam  = (COS(l_alf) - SIN(in_stalat) * SIN(l_phi)) / COS(in_stalat) / COS(in_stalat);
    -- lam=stalon+atan2(slam,clam);
    SET l_lam   = in_stalon + ATAN2(l_slam, l_clam);

    -- coord = [phi.*(180/pi) lam.*(180/pi)];

    -- 1: lat
    -- 0: lon
    IF in_ll=1 THEN
        RETURN DEGREES(l_phi);
    ELSEIF in_ll = 0 THEN
        -- if lon>180 lon=180-lon else end
        IF DEGREES(l_lam) > 180 THEN
            -- RETURN 180 - DEGREES(l_lam);
            RETURN -360 + DEGREES(l_lam);
        ELSE
            RETURN DEGREES(l_lam);
        END IF;
    ELSE
        RETURN NULL;
    END IF;
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_ismr_latlon        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_ismr_latlon        TO 'ws-reader'@'%';

DELIMITER $$
DROP FUNCTION IF EXISTS fn_date2filename  $$
CREATE FUNCTION fn_date2filename(in_date DATETIME, in_frmt char(3)) RETURNS char(22)
    DETERMINISTIC
BEGIN
    DECLARE l_day CHAR(3);
    DECLARE l_hour CHAR(1);

    -- set jday with 3 char
    IF DAYOFYEAR(in_date)<10 THEN
        SET l_day = CONCAT('00',DAYOFYEAR(in_date));
    ELSEIF (DAYOFYEAR(in_date) > 9 AND DAYOFYEAR(in_date)<100) THEN
        SET l_day = CONCAT('0',DAYOFYEAR(in_date));
    ELSEIF (DAYOFYEAR(in_date)>99) THEN
        SET l_day = DAYOFYEAR(in_date);
    END IF;
    SET l_hour = CASE
                    WHEN HOUR(in_date) = 0 THEN 'A'
                    WHEN HOUR(in_date) = 1 THEN 'B'
                    WHEN HOUR(in_date) = 2 THEN 'C'
                    WHEN HOUR(in_date) = 3 THEN 'D'
                    WHEN HOUR(in_date) = 4 THEN 'E'
                    WHEN HOUR(in_date) = 5 THEN 'F'
                    WHEN HOUR(in_date) = 6 THEN 'G'
                    WHEN HOUR(in_date) = 7 THEN 'H'
                    WHEN HOUR(in_date) = 8 THEN 'I'
                    WHEN HOUR(in_date) = 9 THEN 'J'
                    WHEN HOUR(in_date) = 10 THEN 'K'
                    WHEN HOUR(in_date) = 11 THEN 'L'
                    WHEN HOUR(in_date) = 12 THEN 'M'
                    WHEN HOUR(in_date) = 13 THEN 'N'
                    WHEN HOUR(in_date) = 14 THEN '='
                    WHEN HOUR(in_date) = 15 THEN 'P'
                    WHEN HOUR(in_date) = 16 THEN 'Q'
                    WHEN HOUR(in_date) = 17 THEN 'R'
                    WHEN HOUR(in_date) = 18 THEN 'S'
                    WHEN HOUR(in_date) = 19 THEN 'T'
                    WHEN HOUR(in_date) = 20 THEN 'U'
                    WHEN HOUR(in_date) = 21 THEN 'V'
                    WHEN HOUR(in_date) = 22 THEN 'W'
                    WHEN HOUR(in_date) = 23 THEN 'X'
                    ELSE NULL
                END;
    IF in_frmt = 'AI0' THEN
        -- station_YYJJJHM
        RETURN CONCAT(RIGHT(YEAR(in_date),2), l_day, l_hour, IF(MINUTE(in_date)<10,'0',''), MINUTE(in_date)); 
    ELSEIF in_frmt = 'AI1' THEN
        -- station_YYYYJJJHHNNSS
        RETURN CONCAT(YEAR(in_date), l_day, IF(HOUR(in_date)<10,'0',''), HOUR(in_date), IF(MINUTE(in_date)<10,'0',''), MINUTE(in_date), IF(SECOND(in_date)<10,'0',''), SECOND(in_date)); 
    ELSEIF in_frmt = 'AI2' THEN
        -- station_YYYYMMGGHHNN
        RETURN CONCAT(YEAR(in_date), IF(MONTH(in_date)<10,'0',''), MONTH(in_date), IF(DAY(in_date)<10,'0',''), DAY(in_date), IF(HOUR(in_date)<10,'0',''), HOUR(in_date), IF(MINUTE(in_date)<10,'0',''), MINUTE(in_date), IF(SECOND(in_date)<10,'0',''), SECOND(in_date)); 
    ELSEIF in_frmt = 'DP0' THEN
        -- station_YJJJAMMS
        -- es ROOLD_9222X25A.SAO
        RETURN CONCAT(RIGHT(YEAR(in_date),1), l_day, l_hour, IF(MINUTE(in_date)<10,'0',''), MINUTE(in_date),'A'); 
    END IF;
    -- RETURN CONCAT(YEAR(in_date),',',l_day,',',TIME(in_date));
END $$
DELIMITER ;
GRANT EXECUTE ON FUNCTION fn_date2filename        TO 'grafana'@'%';
GRANT EXECUTE ON FUNCTION fn_date2filename        TO 'ws-reader'@'%';


