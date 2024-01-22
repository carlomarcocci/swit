USE scintillation;

DROP VIEW IF EXISTS wsdmc0p;
CREATE VIEW wsdmc0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM dmc0p d
    JOIN  station s         ON s.code = 'dmc0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
-- WHERE s.code='dmc0p'
;
GRANT SELECT ON scintillation.wsdmc0p TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wslam0p;
CREATE VIEW wslam0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM lam0p d
    JOIN  station s         ON s.code = 'lam0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wslam0p TO 'ws-reader'@'%';


DROP VIEW IF EXISTS wslyb0p;
CREATE VIEW wslyb0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM lyb0p d
    JOIN  station s         ON s.code = 'lyb0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wslyb0p TO 'ws-reader'@'%';


DROP VIEW IF EXISTS wsmzs0p;
CREATE VIEW wsmzs0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM mzs0p d
    JOIN  station s         ON s.code = 'mzs0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsmzs0p TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsnya0p;
CREATE VIEW wsnya0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM nya0p d
    JOIN  station s         ON s.code = 'nya0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsnya0p TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsnya1p;
CREATE VIEW wsnya1p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM nya1p d
    JOIN  station s         ON s.code = 'nya1p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsnya1p TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wssan0p;
CREATE VIEW wssan0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM san0p d
    JOIN  station s         ON s.code = 'san0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wssan0p TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wssao0p;
CREATE VIEW wssao0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM sao0p d
    JOIN  station s         ON s.code = 'sao0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wssao0p TO 'ws-reader'@'%';

-- novatel multi
DROP VIEW IF EXISTS wskil0n;
CREATE VIEW wskil0n AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, 2.6, elevation)    AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, 2.6, elevation)      AS s4_l5_vert,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM kil0n d
    JOIN  station s         ON s.code = 'kil0n'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wskil0n TO 'ws-reader'@'%';

-- novate gps
DROP VIEW IF EXISTS wsdmc0s;
CREATE VIEW wsdmc0s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM dmc0s d
    JOIN  station s         ON s.code = 'dmc0s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsdmc0s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsdmc1s;
CREATE VIEW wsdmc1s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM dmc1s d
    JOIN  station s         ON s.code = 'dmc1s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsdmc1s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsdmc2s;
CREATE VIEW wsdmc2s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM dmc2s d
    JOIN  station s         ON s.code = 'dmc2s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsdmc2s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsnya0s;
CREATE VIEW wsnya0s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM nya0s d
    JOIN  station s         ON s.code = 'nya0s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsnya0s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsnya1s;
CREATE VIEW wsnya1s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM nya1s d
    JOIN  station s         ON s.code = 'nya1s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsnya1s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsstation;
CREATE VIEW wsstation AS 
SELECT 
    s.id,
    s.code,
    s.name,
    s.start_time active_since,
    IF(s.end_time>NOW(), '', s.end_time) active_until,
    s.lat,
    s.lon,
    s.h altitude,
    s.area,
    s.description,
    i.name AS instrument,
    st.name status,
    h.name host_institution,
    h.country host_institution_country,
    h.url host_institution_url,
    GROUP_CONCAT(o.code ORDER BY o.orderby) data_owner 
FROM station s 
    JOIN instrument i   ON i.code=s.fk_instrument
    JOIN status st      ON st.code = s.fk_status
    JOIN institution h  ON h.code = s.fk_institution
    LEFT JOIN station_belong_institution l  ON l.fk_station = s.id
    LEFT JOIN institution o                 ON o.code = l.fk_institution 
GROUP BY s.id, s.code, s.name, active_since, active_until, s.lat, s.lon, s.h, s.area, s.description, i.name, st.name
;
GRANT SELECT ON scintillation.wsstation TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wstables;
CREATE VIEW wstables AS
SELECT
*
FROM information_schema.columns
;
GRANT SELECT ON scintillation.wstables TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsnya0s;
CREATE VIEW wsnya0s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM nya0s d
    JOIN  station s         ON s.code = 'nya0s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsnya0s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsbtn0s;
CREATE VIEW wsbtn0s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM btn0s d
    JOIN  station s         ON s.code = 'btn0s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsbtn0s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wslam0s;
CREATE VIEW wslam0s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM lam0s d
    JOIN  station s         ON s.code = 'lam0s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wslam0s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wslyb0s;
CREATE VIEW wslyb0s AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
-- fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
-- fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
-- fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- -- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
-- fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
-- fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM lyb0s d
    JOIN  station s         ON s.code = 'lyb0s'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wslyb0s TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsnic0p;
CREATE VIEW wsnic0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM nic0p d
    JOIN  station s         ON s.code = 'nic0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsnic0p TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wshan0p;
CREATE VIEW wshan0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM han0p d
    JOIN  station s         ON s.code = 'han0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wshan0p TO 'ws-reader'@'%';

DROP VIEW IF EXISTS wsthu0p;
CREATE VIEW wsthu0p AS
SELECT
d.*,
fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,
fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,
fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert,
fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,
fn_stec(tec0, tec15, tec30, tec45)                              AS stec,
fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,
fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,
fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert,
fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,
fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,
-- fn_s4_l5_vert(totalS4_L5, correctionS4_L5, p_l5, elevation)     AS s4_l5_ver,
fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,
fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,
CONCAT(c.nmp_code,IF(LENGTH(t.prn) = 1, '0', ''), t.prn)        AS PRN
FROM thu0p d
    JOIN  station s         ON s.code = 'thu0p'
    JOIN satellite t        ON t.svid = d.svid
    JOIN constellation c    ON c.id = t.fk_constellation
;
GRANT SELECT ON scintillation.wsthu0p TO 'ws-reader'@'%';


USE ais;
DROP VIEW IF EXISTS wsstation;
CREATE VIEW wsstation AS 
SELECT 
    s.id,
    s.code,
    s.name,
    s.start_time active_since,
    IF(s.end_time>NOW(), '', s.end_time) active_until,
    s.lat,
    s.lon,
    s.h altitude,
    s.area,
    s.description,
    i.name AS instrument,
    st.name status,
    h.name host_institution,
    h.country host_institution_country,
    h.url host_institution_url,
    GROUP_CONCAT(o.code ORDER BY o.orderby) data_owner 
FROM station s 
    JOIN instrument i   ON i.code=s.fk_instrument
    JOIN status st      ON st.code = s.fk_status
    JOIN institution h  ON h.code = s.fk_institution
    LEFT JOIN station_belong_institution l  ON l.fk_station = s.id
    LEFT JOIN institution o                 ON o.code = l.fk_institution 
GROUP BY s.id, s.code, s.name, active_since, active_until, s.lat, s.lon, s.h, s.area, s.description, i.name, st.name
;
GRANT SELECT ON scintillation.wsstation TO 'ws-reader'@'%';

USE mystat;
DROP VIEW IF EXISTS wsstat_tables;
CREATE VIEW wsstat_tables AS 
SELECT *
FROM stat_tables
;
GRANT SELECT ON mystat.wsstat_tables TO 'ws-reader'@'%';


