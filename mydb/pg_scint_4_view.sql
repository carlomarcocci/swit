/*
CREATE OR REPLACE VIEW wsstation AS
SELECT
    -- s.id,
    s.code,
    s.name,
    s.start_time active_since,
    CASE
        WHEN s.end_time >CURRENT_TIMESTAMP THEN NULL
        ELSE s.end_time
    END AS  active_until,
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
    string_agg(o.code, ',' ORDER BY o.orderby) data_owner
FROM station s
    JOIN instrument i                           ON i.code = s.fk_instrument
    JOIN status st                              ON st.code = s.fk_status
    JOIN institution h                          ON h.code = s.fk_institution
    LEFT JOIN station_belong_institution l      ON l.fk_station = s.code
--    LEFT JOIN station_belong_institution l    ON l.fk_station = s.code
    LEFT JOIN institution o                     ON o.code = l.fk_institution
GROUP BY s.code, s.name, active_since, active_until, s.lat, s.lon, s.h, s.area, s.description, i.name, st.name
;
*/
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
