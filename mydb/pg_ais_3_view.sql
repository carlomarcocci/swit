CREATE OR REPLACE VIEW wsstation AS
SELECT 
    s.code AS code,
    s.name AS name,
    s.start_time AS active_since,
    CASE
        WHEN s.end_time >CURRENT_TIMESTAMP THEN NULL
        ELSE s.end_time
    END AS active_until,
    
    s.lat AS lat,
    s.lon AS lon,
    s.h AS altitude,
    s.area AS area,
    s.description AS description,
    i.name AS instrument,
    st.name AS status,
    h.code AS host_institution,
    h.country AS host_institution_country,
    h.url AS host_institution_url,
    string_agg(o.code, ',' ORDER BY o.orderby) data_owner
FROM station s 
    JOIN instrument i                       ON i.code   = s.fk_instrument
    JOIN status st                          ON st.code  = s.fk_status
    JOIN institution h                      ON h.code   = s.fk_institution
    LEFT JOIN station_belong_institution l  ON s.code   = l.fk_station
    LEFT JOIN institution o                 ON o.code   = l.fk_institution
 GROUP BY s.code,s.name,active_since,active_until,s.lat,s.lon,s.h,s.area,s.description,i.name,st.name, h.code,h.url
;

CREATE OR REPLACE VIEW wsrm041_auto AS
SELECT *,
fn_median('rm041_auto', 'fof2', 0, 100, dt, 27) fof2_med_27_days
FROM rm041_auto
;

CREATE OR REPLACE VIEW wsgm037_auto AS
SELECT *,
fn_median('gm037_auto', 'fof2', 0, 100, dt, 14, 27) fof2_med_27_days
FROM gm037_auto
;

CREATE OR REPLACE VIEW wstuj2O_auto AS
SELECT *,
fn_median('tuj2O_auto', 'fof2', 0, 100, dt, 14, 27) fof2_med_27_days
FROM tuj2O_auto
;
CREATE OR REPLACE VIEW wsro041_auto AS
SELECT *,
fn_median('ro041_auto', 'fof2', 0, 100, dt,  14, 27) fof2_med_27_days
FROM ro041_auto
;
CREATE OR REPLACE VIEW wsbbj3r_auto AS
SELECT *,
fn_median('bbj3r_auto', 'fof2', 0, 100, dt,  14, 27) fof2_med_27_days
FROM bbj3r_auto
;
CREATE OR REPLACE VIEW wsso148_auto AS
SELECT *,
fn_median('so148_auto', 'fof2', 0, 100, dt,  14, 27) fof2_med_27_days
FROM so148_auto;
