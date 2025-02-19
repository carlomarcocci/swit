--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: institution; Type: TABLE; Schema: public; Owner: aisu
--

CREATE TABLE public.institution (
    code character varying(10) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    url character varying(1024) DEFAULT NULL::character varying,
    country character varying(1024) DEFAULT NULL::character varying,
    orderby integer DEFAULT 0 NOT NULL,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.institution OWNER TO aisu;

--
-- Name: instrument; Type: TABLE; Schema: public; Owner: aisu
--

CREATE TABLE public.instrument (
    code character(3) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    modified timestamp without time zone
);


ALTER TABLE public.instrument OWNER TO aisu;

--
-- Name: station; Type: TABLE; Schema: public; Owner: aisu
--

CREATE TABLE public.station (
    code character varying(6) NOT NULL,
    filecode character varying(6) NOT NULL,
    name character varying(255),
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    lat numeric(9,6),
    lon numeric(9,6),
    h numeric(8,2),
    area character varying(255),
    description text,
    fk_instrument character(3),
    fk_status character(3),
    fk_institution character(10),
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.station OWNER TO aisu;

--
-- Name: station_belong_institution; Type: TABLE; Schema: public; Owner: aisu
--

CREATE TABLE public.station_belong_institution (
    id integer NOT NULL,
    fk_station character varying(6) NOT NULL,
    fk_institution character varying(10) NOT NULL,
    orderby integer DEFAULT 0 NOT NULL,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.station_belong_institution OWNER TO aisu;

--
-- Name: station_belong_institution_id_seq; Type: SEQUENCE; Schema: public; Owner: aisu
--

CREATE SEQUENCE public.station_belong_institution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.station_belong_institution_id_seq OWNER TO aisu;

--
-- Name: station_belong_institution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aisu
--

ALTER SEQUENCE public.station_belong_institution_id_seq OWNED BY public.station_belong_institution.id;


--
-- Name: status; Type: TABLE; Schema: public; Owner: aisu
--

CREATE TABLE public.status (
    code character varying(3) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.status OWNER TO aisu;

--
-- Name: station_belong_institution id; Type: DEFAULT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station_belong_institution ALTER COLUMN id SET DEFAULT nextval('public.station_belong_institution_id_seq'::regclass);


--
-- Data for Name: institution; Type: TABLE DATA; Schema: public; Owner: aisu
--

INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('INGV', 'Istituto Nazionale di Geofisica e Vulcanologia', 'NULL', 'http://www.ingv.it', 'it', 0, '2020-11-16 09:55:29');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('UNT', 'Universidad Nacional de Tucuman (UNT)', NULL, 'http://www.unt.edu.ar/', 'ar', 0, '2020-11-16 08:29:38');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('UTN', 'Universidad Tecnologica Nacional (UTN)', NULL, 'https://www.frbb.utn.edu.ar/frbb/index.php', 'ar', 0, '2020-11-16 08:29:41');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('EPSS', 'Institute of Earth Physics and Space Science', '', 'https://epss.hu/en/', 'hu', 0, '2023-03-23 12:00:00');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('ASI', 'Agenzia Spaziale Italiana', '', 'https://www.asi.it', 'it', 0, '2023-08-15 10:00:00');


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: aisu
--

INSERT INTO public.instrument (code, name, description, modified) VALUES ('AIS', 'AIS-INGV Ionosonde', NULL, '2021-03-08 09:33:09');
INSERT INTO public.instrument (code, name, description, modified) VALUES ('DPS', 'Lowell Digisonde DPS-4', NULL, '2021-03-08 09:31:55');
INSERT INTO public.instrument (code, name, description, modified) VALUES ('D4D', 'Lowell Digisonde DPS-4D', NULL, '2023-05-11 08:00:00');


--
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: aisu
--

INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('rm041', 'rm041', 'Rome', '2004-11-25 10:53:00', '2999-01-01 00:00:00', 41.800000, 12.500000, NULL, 'MEDITERRANEAN', NULL, 'AIS', 'ON ', 'INGV      ', '2020-11-09 13:58:59');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('gm037', 'gm037', 'Gibilmanna', '2002-11-26 12:35:00', '2999-01-01 00:00:00', 37.900000, 14.000000, NULL, 'MEDITERRANEAN', NULL, 'AIS', 'ON ', 'INGV      ', '2020-11-09 14:03:06');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('bbj3r', 'bbj3r', 'Bahia Blanca', '2016-01-01 00:00:00', '2999-01-01 00:00:00', -38.700000, -62.300000, 20.00, 'SOUTH AMERICA', 'Dati e ionogrammi della ionosonda AIS-INGV installata a BAhia Blanca, Argentina', 'AIS', 'ON ', 'UTN       ', '2020-11-09 14:07:22');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('ro041', 'ro041', 'Rome', '1997-01-01 00:00:00', '2999-01-01 00:00:00', 41.800000, 12.500000, NULL, 'MEDITERRANEAN', 'Dps', 'DPS', 'ON ', 'INGV      ', '2020-11-09 14:01:54');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('ncmv0', 'ncmv0', 'MUF(3000)F2 NOWCASTING EUROPE', NULL, NULL, 43.120000, 13.330000, NULL, NULL, NULL, 'AIS', NULL, NULL, '2022-04-26 17:13:18.860735');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('ncmr0', 'ncmr0', 'MUF(3000)F2 RATIO NOWCASTING EUROPE', NULL, NULL, 43.120000, 13.330000, NULL, NULL, NULL, 'AIS', NULL, NULL, '2022-04-26 17:13:18.706173');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('fcmv0', 'fcmv0', 'MUF(3000)F2 FORECASTING EUROPE', NULL, NULL, 43.120000, 13.330000, NULL, NULL, NULL, 'AIS', NULL, NULL, '2022-04-26 17:13:18.883056');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('fcmr0', 'fcmr0', 'MUF(3000)F2 RATIO FORECASTING EUROPE', NULL, NULL, 43.120000, 13.330000, NULL, NULL, NULL, 'AIS', NULL, NULL, '2022-04-26 17:13:18.872259');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('tuj2o', 'tuj2o', 'Tucuman', '2007-09-01 00:00:00', '2999-01-01 00:00:00', -26.900000, -65.400000, 430.00, 'SOUTH AMERICA', 'Dati e ionogrammi della ionosonda AIS-INGV installata a Tucuman, Argentina', 'AIS', 'ON ', 'UNT       ', '2020-11-09 14:05:45');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('ml10l', 'ml10l', 'Broglio Space Center', '2023-07-13 15:00:00', '2999-01-01 00:00:00', -3.000000, 40.200000, 0.00, 'AFRICA', 'AIS', 'AIS', 'ON ', 'ASI       ', '2023-05-25 12:00:00');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_instrument, fk_status, fk_institution, modified) VALUES ('so148', 'so148', 'Sopron', '2023-03-23 12:00:00', '2999-01-01 00:00:00', 47.633333, 16.716667, 154.90, 'EUROPE', 'Dps', 'D4D', 'INS', 'EPSS      ', '2023-03-23 12:00:00');


--
-- Data for Name: station_belong_institution; Type: TABLE DATA; Schema: public; Owner: aisu
--

INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (1, 'rm041', 'INGV', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (2, 'ro041', 'INGV', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (4, 'gm037', 'INGV', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (5, 'bbj3r', 'UTN', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (7, 'ncmr0', 'INGV', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (8, 'ncmv0', 'INGV', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (9, 'fcmr0', 'INGV', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (10, 'fcmv0', 'INGV', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (3, 'tuj2o', 'UNT', 0, '2020-11-12 11:17:54');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (6, 'so148', 'EPSS', 0, '2023-03-23 12:00:00');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (11, 'ml10l', 'INGV', 0, '2023-05-25 12:00:00');


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: aisu
--

INSERT INTO public.status (code, name, description, modified) VALUES ('CLO', 'Closed', 'Dismissed station', '2020-11-09 10:42:23');
INSERT INTO public.status (code, name, description, modified) VALUES ('INS', 'Installing', 'Installing station', '2020-11-09 10:42:23');
INSERT INTO public.status (code, name, description, modified) VALUES ('OFF', 'Disabled', 'Tenporary disabled station', '2020-11-09 10:42:23');
INSERT INTO public.status (code, name, description, modified) VALUES ('ON', 'Active', 'Online station', '2020-11-09 10:42:23');


--
-- Name: station_belong_institution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aisu
--

SELECT pg_catalog.setval('public.station_belong_institution_id_seq', 5, true);


--
-- Name: institution institution_name_key; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.institution
    ADD CONSTRAINT institution_name_key UNIQUE (name);


--
-- Name: institution institution_pkey; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.institution
    ADD CONSTRAINT institution_pkey PRIMARY KEY (code);


--
-- Name: instrument instrument_name_key; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_name_key UNIQUE (name);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (code);


--
-- Name: station_belong_institution station_belong_institution_pkey; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station_belong_institution
    ADD CONSTRAINT station_belong_institution_pkey PRIMARY KEY (id);


--
-- Name: station station_pkey; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (code);


--
-- Name: status status_name_key; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_name_key UNIQUE (name);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (code);


--
-- Name: station foreign_institution; Type: FK CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT foreign_institution FOREIGN KEY (fk_institution) REFERENCES public.institution(code);


--
-- Name: station foreign_instrument; Type: FK CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT foreign_instrument FOREIGN KEY (fk_instrument) REFERENCES public.instrument(code);


--
-- Name: station foreign_status; Type: FK CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT foreign_status FOREIGN KEY (fk_status) REFERENCES public.status(code);


--
-- Name: station_belong_institution institution_ref_station; Type: FK CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station_belong_institution
    ADD CONSTRAINT institution_ref_station FOREIGN KEY (fk_institution) REFERENCES public.institution(code);


--
-- Name: station_belong_institution station_ref_institution; Type: FK CONSTRAINT; Schema: public; Owner: aisu
--

ALTER TABLE ONLY public.station_belong_institution
    ADD CONSTRAINT station_ref_institution FOREIGN KEY (fk_station) REFERENCES public.station(code);


--
-- Name: TABLE institution; Type: ACL; Schema: public; Owner: aisu
--

GRANT SELECT ON TABLE public.institution TO wsreader;


--
-- Name: TABLE instrument; Type: ACL; Schema: public; Owner: aisu
--

GRANT SELECT ON TABLE public.instrument TO wsreader;


--
-- Name: TABLE station; Type: ACL; Schema: public; Owner: aisu
--

GRANT SELECT ON TABLE public.station TO wsreader;


--
-- Name: TABLE status; Type: ACL; Schema: public; Owner: aisu
--

GRANT SELECT ON TABLE public.status TO wsreader;


--
-- PostgreSQL database dump complete
--

