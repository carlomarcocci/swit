\c tecdb

-- wsltf_gl    100
-- wsnc_med    60
-- wsnc_gl     100
-- wsnc_eu     60
-- wssf_med    60

-- viste di test
CREATE OR REPLACE VIEW wsnc_med AS
SELECT *,
fn_median('nc_med', 'tec_mean', 0, 70, dt, 14, 27) tec_med_27_days
FROM nc_med
;

CREATE OR REPLACE VIEW wsltf_gl AS
SELECT *,
fn_median('ltf_gl', 'tec_mean', 0, 100, dt, 14, 27) tec_med_27_days
FROM ltf_gl
;

CREATE OR REPLACE VIEW wsnc_gl AS
SELECT *,
fn_median('nc_gl', 'tec_mean', 0, 100, dt, 14, 27) tec_med_27_days
FROM nc_gl
;

CREATE OR REPLACE VIEW wsnc_eu AS
SELECT *,
fn_median('nc_eu', 'tec_mean', 0, 60, dt, 14, 27) tec_med_27_days
FROM nc_eu
;

CREATE OR REPLACE VIEW wsnc_eu AS
SELECT *,
fn_median('nc_eu', 'tec_mean', 0, 60, dt, 14, 27) tec_med_27_days
FROM nc_eu
;

CREATE OR REPLACE VIEW wssf_med AS
SELECT *,
fn_median('nc_eu', 'tec_mean', 0, 60, dt, 14, 27) tec_med_27_days
FROM sf_med
;

