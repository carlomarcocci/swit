--
-- PostgreSQL database dump
--

-- Dumped from database version 14.10
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
-- Name: constellation; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.constellation (
    id integer NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    description text,
    nmp_code character(1) DEFAULT NULL::bpchar,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.constellation OWNER TO scintu;

--
-- Name: constellation_id_seq; Type: SEQUENCE; Schema: public; Owner: scintu
--

CREATE SEQUENCE public.constellation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.constellation_id_seq OWNER TO scintu;

--
-- Name: constellation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scintu
--

ALTER SEQUENCE public.constellation_id_seq OWNED BY public.constellation.id;


--
-- Name: institution; Type: TABLE; Schema: public; Owner: scintu
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


ALTER TABLE public.institution OWNER TO scintu;

--
-- Name: instrument; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.instrument (
    code character(3) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    modified timestamp without time zone DEFAULT now(),
    fk_type_table character varying(50)
);


ALTER TABLE public.instrument OWNER TO scintu;

--
-- Name: producer; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.producer (
    code character varying(3) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.producer OWNER TO scintu;

--
-- Name: satellite; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.satellite (
    svid integer NOT NULL,
    prn integer,
    fk_constellation integer NOT NULL,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.satellite OWNER TO scintu;

--
-- Name: station; Type: TABLE; Schema: public; Owner: scintu
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
    fk_status character(3),
    fk_institution character(10),
    modified timestamp without time zone NOT NULL,
    fk_producer character varying(6)
);


ALTER TABLE public.station OWNER TO scintu;

--
-- Name: station_belong_institution; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.station_belong_institution (
    id integer NOT NULL,
    fk_station character varying(6) NOT NULL,
    fk_institution character varying(10) NOT NULL,
    orderby integer DEFAULT 0 NOT NULL,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.station_belong_institution OWNER TO scintu;

--
-- Name: station_belong_institution_id_seq; Type: SEQUENCE; Schema: public; Owner: scintu
--

CREATE SEQUENCE public.station_belong_institution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.station_belong_institution_id_seq OWNER TO scintu;

--
-- Name: station_belong_institution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scintu
--

ALTER SEQUENCE public.station_belong_institution_id_seq OWNED BY public.station_belong_institution.id;


--
-- Name: station_has_instrument; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.station_has_instrument (
    id integer NOT NULL,
    fk_station character varying(6) NOT NULL,
    fk_instrument character varying(3) NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    orderby integer DEFAULT 0 NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.station_has_instrument OWNER TO scintu;

--
-- Name: station_has_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: scintu
--

CREATE SEQUENCE public.station_has_instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.station_has_instrument_id_seq OWNER TO scintu;

--
-- Name: station_has_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scintu
--

ALTER SEQUENCE public.station_has_instrument_id_seq OWNED BY public.station_has_instrument.id;


--
-- Name: station_instrument_period; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.station_instrument_period (
    id integer NOT NULL,
    code character varying(1) DEFAULT NULL::character varying,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    orderby integer DEFAULT 0 NOT NULL,
    fk_station character varying(6) NOT NULL,
    fk_instrument character varying(3) NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.station_instrument_period OWNER TO scintu;

--
-- Name: station_instrument_period_id_seq; Type: SEQUENCE; Schema: public; Owner: scintu
--

CREATE SEQUENCE public.station_instrument_period_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.station_instrument_period_id_seq OWNER TO scintu;

--
-- Name: station_instrument_period_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: scintu
--

ALTER SEQUENCE public.station_instrument_period_id_seq OWNED BY public.station_instrument_period.id;


--
-- Name: status; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.status (
    code character varying(3) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    modified timestamp without time zone NOT NULL
);


ALTER TABLE public.status OWNER TO scintu;

--
-- Name: type_table; Type: TABLE; Schema: public; Owner: scintu
--

CREATE TABLE public.type_table (
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    dictionary jsonb,
    tableextension character varying(10) NOT NULL,
    parser_ref character varying(50) NOT NULL,
    description text,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.type_table OWNER TO scintu;

--
-- Name: constellation id; Type: DEFAULT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.constellation ALTER COLUMN id SET DEFAULT nextval('public.constellation_id_seq'::regclass);


--
-- Name: station_belong_institution id; Type: DEFAULT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_belong_institution ALTER COLUMN id SET DEFAULT nextval('public.station_belong_institution_id_seq'::regclass);


--
-- Name: station_has_instrument id; Type: DEFAULT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_has_instrument ALTER COLUMN id SET DEFAULT nextval('public.station_has_instrument_id_seq'::regclass);


--
-- Name: station_instrument_period id; Type: DEFAULT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_instrument_period ALTER COLUMN id SET DEFAULT nextval('public.station_instrument_period_id_seq'::regclass);


--
-- Data for Name: constellation; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (0, 'GPS', 'GPS', NULL, 'G', '2019-10-02 13:53:15');
INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (1, 'GLO', 'GLONASS', NULL, 'R', '2019-10-02 13:53:15');
INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (2, 'SBAS', 'SBAS block1', NULL, 'S', '2019-10-02 13:53:15');
INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (5, 'GAL', 'GALILEO', NULL, 'E', '2019-10-02 13:53:15');
INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (6, 'BEIDU', 'Beidu, Compass', NULL, 'C', '2019-10-02 13:53:15');
INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (7, 'QZSS', 'QZSS', NULL, 'Q', '2019-10-02 13:53:15');
INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (8, 'IRNSS', 'IRNSS', NULL, NULL, '2019-10-02 13:53:15');
INSERT INTO public.constellation (id, code, name, description, nmp_code, modified) VALUES (9, 'FREE', 'Free', NULL, NULL, '2019-10-02 13:53:15');


--
-- Data for Name: institution; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('ASI', 'Agenzia Spaziale Italiana', '', 'https://www.asi.it', 'it', 0, '2022-04-05 12:55:50');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('CNR', 'Consiglio Nazionale delle Ricerche (CNR)', NULL, 'http://www.cnr.it', 'it', 0, '2020-11-16 08:24:41');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('ENEA', 'Agenzia nazionale per le nuove tecnologie, l’energia e lo sviluppo economico sostenibile (ENEA)', '', 'https://www.enea.it', 'it', 0, '2020-11-16 08:24:47');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('ERAU', 'Embry-Riddle Aeronautical University (ERAU)', NULL, 'https://erau.edu', 'us', 0, '2021-12-22 12:03:25');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('FCT_UNESP', 'Universidade Estadual Paulista', '', 'https://www.fct.unesp.br/', 'br', 0, '2023-04-18 09:22:53');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('FMI', 'Finnish Meteorological Institute', '', 'https://en.ilmatieteenlaitos.fi/', 'fi', 0, '2021-12-15 16:15:25');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('FREDERICK', 'Frederick University', NULL, 'http://www.frederick.ac.cy/', 'cy', 0, '2020-11-16 08:28:21');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('HMU', 'Hellenic Mediterranean University', '', 'https://www.hmu.gr/en', 'gr', 0, '2022-06-21 08:06:30');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('INGV', 'Istituto Nazionale di Geofisica e Vulcanologia', '', 'http://www.ingv.it', 'it', 0, '2020-11-16 09:55:08');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('KGEO', 'Kartverket Geodetic Earth Observatory', NULL, 'https://www.kartverket.no/en/about-kartverket/geodetic-earth-observatory', 'no', 0, '2020-11-16 08:27:52');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('KLU', 'K L University', '', 'https://www.kluniversity.in/', 'in', 0, '2022-03-17 10:24:05');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('KNMI', 'Royal Netherlands Meteorological Institute', '', 'https://www.knmi.nl', 'nl', 0, '2022-05-04 20:40:07');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('MACKENZIE', 'Mackenzie University', NULL, 'https://www.mackenzie.br/', 'br', 0, '2020-11-16 08:27:30');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('NASRDA', 'National Space Research and Development Agency', 'Space Environment Research Laboratory (SERL) ', 'http://nasrda.gov.ng/', 'ng', 0, '2022-12-05 12:48:42');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('NAVIS', 'International Collaboration Centre for Research and Development on Satellite Navigation Technology in South East Asia (NAVIS)', NULL, 'http://navis.hust.edu.vn/index.php', 'vn', 0, '2020-11-16 08:26:59');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('NSF', 'National Science Foundation', NULL, 'https://www.nsf.gov/', 'us', 0, '2021-09-07 13:53:26');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('PNRA', 'Programma nazionale di ricerca in Antartide (PNRA)', NULL, 'https://www.pnra.aq', 'it', 0, '2020-11-16 08:24:53');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('PWANI', 'Pwani University', NULL, 'https://www.pu.ac.ke/', 'ke', 0, '2020-11-16 08:26:34');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('SANSA', 'South African National Space Agency (SANSA)', NULL, 'https://www.sansa.org.za/', 'za', 0, '2020-11-16 08:25:37');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('SMN', 'Servicio Metereologico National', '', 'https://www.argentina.gob.ar/smn', 'ar', 0, '2021-12-02 15:07:04');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('UIT', 'The Arctic University of Norway (UIT)', NULL, 'https://uit.no/startsida', 'no', 0, '2020-11-16 08:25:58');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('UNT', 'Universidad Nacional de Tucuman', '', 'https://www.unt.edu.ar', 'ar', 0, '2021-12-07 20:51:25');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('MIST', 'Military Institute of Science and Technology', '', 'https://mist.ac.bd/', 'bd', 0, '2024-06-26 04:04:33');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('KSA', 'Kenya Space Agency', NULL, 'https://ksa.go.ke/', 'ke', 0, '2023-10-11 09:43:54');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('NCU', 'National Central University', 'Department of space science & engineering', 'https://www.ss.ncu.edu.tw/en/', 'tw', 0, '2023-09-19 07:59:54');
INSERT INTO public.institution (code, name, description, url, country, orderby, modified) VALUES ('IAP', 'Institute of Atmospheric Physics', NULL, 'https://www.ufa.cas.cz/en/homepage-en/', 'cz', 0, '2023-09-19 08:00:57');


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.instrument (code, name, description, modified, fk_type_table) VALUES ('NG4', 'Novatel GSV4004', NULL, '2021-03-08 09:40:28', 'nov_gps');
INSERT INTO public.instrument (code, name, description, modified, fk_type_table) VALUES ('NG6', 'Novatel GPStation-6', NULL, '2021-03-08 09:42:50', 'nov_multi');
INSERT INTO public.instrument (code, name, description, modified, fk_type_table) VALUES ('S5S', 'Septentrio PolaRx5S', NULL, '2021-03-08 09:43:47', 'ismr_sept');
INSERT INTO public.instrument (code, name, description, modified, fk_type_table) VALUES ('SXS', 'Septentrio PolaRxS', NULL, '2021-03-08 09:45:38', 'ismr_sept');


--
-- Data for Name: producer; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.producer (code, name, description, modified) VALUES ('SEN', 'Sensor producing date', NULL, '2025-01-28 11:05:23.256475');
INSERT INTO public.producer (code, name, description, modified) VALUES ('ALG', 'Algotithm producing date', NULL, '2025-01-28 11:05:23.261903');


--
-- Data for Name: satellite; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (1, 1, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (2, 2, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (3, 3, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (4, 4, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (5, 5, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (6, 6, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (7, 7, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (8, 8, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (9, 9, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (10, 10, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (11, 11, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (12, 12, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (13, 13, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (14, 14, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (15, 15, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (16, 16, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (17, 17, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (18, 18, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (19, 19, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (20, 20, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (21, 21, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (22, 22, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (23, 23, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (24, 24, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (25, 25, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (26, 26, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (27, 27, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (28, 28, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (29, 29, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (30, 30, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (31, 31, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (32, 32, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (33, 33, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (34, 34, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (35, 35, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (36, 36, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (37, 37, 0, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (38, 1, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (39, 2, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (40, 3, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (41, 4, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (42, 5, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (43, 6, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (44, 7, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (45, 8, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (46, 9, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (47, 10, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (48, 11, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (49, 12, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (50, 13, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (51, 14, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (52, 15, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (53, 16, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (54, 17, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (55, 18, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (56, 19, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (57, 20, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (58, 21, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (59, 22, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (60, 23, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (61, 24, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (62, 25, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (63, 26, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (64, 27, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (65, 28, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (66, 29, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (67, 30, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (68, 31, 1, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (69, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (70, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (71, 1, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (72, 2, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (73, 3, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (74, 4, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (75, 5, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (76, 6, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (77, 7, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (78, 8, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (79, 9, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (80, 10, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (81, 11, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (82, 12, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (83, 13, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (84, 14, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (85, 15, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (86, 16, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (87, 17, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (88, 18, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (89, 19, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (90, 20, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (91, 21, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (92, 22, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (93, 23, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (94, 24, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (95, 25, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (96, 26, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (97, 27, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (98, 28, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (99, 29, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (100, 30, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (101, 31, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (102, 32, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (103, 33, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (104, 34, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (105, 35, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (106, 36, 5, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (107, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (108, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (109, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (110, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (111, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (112, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (113, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (114, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (115, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (116, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (117, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (118, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (119, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (120, 1, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (121, 2, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (122, 3, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (123, 4, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (124, 5, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (125, 6, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (126, 7, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (127, 8, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (128, 9, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (129, 10, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (130, 11, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (131, 12, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (132, 13, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (133, 14, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (134, 15, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (135, 16, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (136, 17, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (137, 18, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (138, 19, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (139, 20, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (140, 21, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (141, 1, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (142, 2, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (143, 3, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (144, 4, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (145, 5, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (146, 6, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (147, 7, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (148, 8, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (149, 9, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (150, 10, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (151, 11, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (152, 12, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (153, 13, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (154, 14, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (155, 15, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (156, 16, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (157, 17, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (158, 18, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (159, 19, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (160, 20, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (161, 21, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (162, 22, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (163, 23, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (164, 24, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (165, 25, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (166, 26, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (167, 27, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (168, 28, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (169, 29, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (170, 30, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (171, 31, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (172, 32, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (173, 33, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (174, 34, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (175, 35, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (176, 36, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (177, 37, 6, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (178, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (179, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (180, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (181, 1, 7, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (182, 2, 7, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (183, 3, 7, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (184, 4, 7, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (185, 5, 7, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (186, 6, 7, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (187, 7, 7, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (188, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (189, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (190, NULL, 9, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (191, 1, 8, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (192, 2, 8, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (193, 3, 8, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (194, 4, 8, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (195, 5, 8, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (196, 6, 8, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (197, 7, 8, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (198, 22, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (199, 23, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (200, 24, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (201, 25, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (202, 26, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (203, 27, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (204, 28, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (205, 29, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (206, 30, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (207, 31, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (208, 32, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (209, 33, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (210, 34, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (211, 35, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (212, 36, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (213, 37, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (214, 38, 2, '2019-10-02 13:53:15');
INSERT INTO public.satellite (svid, prn, fk_constellation, modified) VALUES (215, 39, 2, '2019-10-02 13:53:15');


--
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('btn0s', 'btn0s', 'Mario Zucchelli', '2006-01-18 00:00:00', '2019-01-04 00:00:00', -74.700000, 164.110000, NULL, 'ANTARCTIC', NULL, 'CLO', 'PNRA      ', '2022-12-15 16:26:13', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('dmc0s', 'dmc0s', 'Dome C', '2009-11-18 00:01:00', '2022-09-25 00:00:00', -75.100000, 123.333000, 3253.00, 'ANTARCTIC', NULL, 'CLO', 'PNRA      ', '2022-12-15 17:29:23', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('nya1s', 'nya1s', 'Ny Alesund', '2010-01-01 00:02:00', '2020-09-17 02:22:00', 78.929308, 11.867489, 83.00, 'ARCTIC', NULL, 'CLO', 'KGEO      ', '2023-05-15 13:14:50', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('lyb0p', 'lyb0', 'Longyearbyen', '2019-01-13 10:39:00', '2999-01-01 00:00:00', 78.200000, 16.000000, NULL, 'ARCTIC', NULL, 'ON ', 'UIT       ', '2022-12-15 16:37:33', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('dmc0p', 'dmc0p', 'Dome C', '2017-01-29 03:16:00', '2999-01-01 00:00:00', -75.100000, 123.333000, 3253.00, 'ANTARCTIC', NULL, 'ON ', 'PNRA      ', '2022-12-15 17:26:06', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('san0p', 'sna0p', 'SANAE IV', '2015-12-27 09:51:00', '2999-01-01 00:00:00', -71.700000, -2.800000, NULL, 'ANTARCTIC', NULL, 'ON ', 'SANSA     ', '2022-12-15 17:25:44', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('nya0p', 'nya0p', 'Ny Alesund', '2015-11-09 00:01:00', '2999-01-01 00:00:00', 78.923478, 11.925192, 52.00, 'ARCTIC', NULL, 'ON ', 'CNR       ', '2023-05-15 13:15:32', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('sao0p', 'sao0p', 'SaoPaolo', '2017-05-31 13:33:00', '2999-01-01 00:00:00', -23.500000, -46.700000, 1.00, 'SOUTH AMERICA', NULL, 'ON ', 'MACKENZIE ', '2022-12-15 16:29:53', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('dmc1s', 'dmc1s', 'Dome C', '2010-10-31 00:01:00', '2022-09-25 00:00:00', -75.106048, 123.304836, 3236.00, 'ANTARCTIC', NULL, 'CLO', 'PNRA      ', '2022-12-15 17:29:45', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('dmc2s', 'dmc2s', 'Dome C', '2013-11-16 07:44:00', '2022-09-25 00:00:00', -75.099586, 123.304816, 3232.00, 'ANTARCTIC', NULL, 'CLO', 'PNRA      ', '2022-12-15 17:30:04', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('lam0p', 'lam0p', 'Lampedusa', '2019-10-16 07:28:00', '2999-01-01 00:00:00', 35.520000, 12.630000, NULL, 'MEDITERRANEAN', NULL, 'ON ', 'ENEA      ', '2022-12-15 16:29:09', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('mzs0p', 'btn0p', 'Mario Zucchelli', '2016-11-29 22:01:00', '2999-01-01 00:00:00', -74.700000, 164.110000, NULL, 'ANTARCTIC', NULL, 'ON ', 'PNRA      ', '2022-12-15 17:25:20', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('nya0s', 'nya0s', 'Ny Alesund', '2003-09-01 00:00:00', '2020-09-17 00:40:00', 78.923478, 11.925192, 52.00, 'ARCTIC', NULL, 'CLO', 'CNR       ', '2023-05-15 13:15:35', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('nya1p', 'nya1p', 'Ny Alesund', '2020-01-02 13:11:00', '2999-01-01 00:00:00', 78.929308, 11.867489, 83.00, 'ARCTIC', NULL, 'ON ', 'KGEO      ', '2023-05-15 13:14:54', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('lam0s', 'lam0s', 'Lampedusa', '2011-06-22 00:01:00', '2018-11-07 10:15:00', 35.520000, 12.630000, NULL, 'MEDITERRANEAN', NULL, 'CLO', 'ENEA      ', '2022-12-15 17:32:44', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('lyb0s', 'lyb0s', 'Longyearbyen', '2010-01-01 00:01:00', '2017-10-07 00:00:00', 78.200000, 16.000000, NULL, 'ARCTIC', NULL, 'CLO', 'UIT       ', '2022-12-15 17:32:14', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('nic0p', 'nic0p', 'Nicosia', '2020-09-29 14:01:00', '2999-01-01 00:00:00', 35.181110, 33.379170, NULL, 'MEDITERRANEAN', NULL, 'ON ', 'FREDERICK ', '2022-12-15 16:36:12', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('han0p', 'TQBS', 'Hanoi', '2020-09-30 06:16:00', '2999-01-01 00:00:00', 21.004600, 105.843900, NULL, 'SOUTH EAST ASIA', NULL, 'ON ', 'NAVIS     ', '2022-12-15 16:31:41', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('thu0n', 'thu0n', 'Thule', '2023-04-30 00:00:00', '2000-01-01 00:00:00', 76.510000, -68.740000, NULL, 'ARCTIC', NULL, 'INS', 'INGV      ', '2023-05-01 19:30:12', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('thu0p', 'thu0p', 'Thule', '2021-04-29 11:05:00', '2999-01-01 00:00:00', 76.510000, -68.740000, NULL, 'ARCTIC', NULL, 'ON ', 'NSF       ', '2022-12-15 17:26:35', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('ush0p', 'ush0p', 'Ushuaia', '2021-12-02 15:31:00', '2999-01-01 00:00:00', -54.848300, -68.310800, 34.00, 'SOUTH AMERICA', '', 'ON ', 'SMN       ', '2022-12-15 16:30:21', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('tuc0p', 'tuc0p', 'Tucuman', '2021-12-09 09:31:00', '2999-01-01 00:00:00', -23.727000, -65.230000, 472.00, 'SOUTH AMERICA', '', 'ON ', 'UNT       ', '2022-12-15 16:30:48', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('hel0p', 'hel0p', 'Helsinki', '2021-12-16 09:01:00', '2999-01-01 00:00:00', 60.203800, 24.960762, 50.00, 'EUROPE', '', 'ON ', 'FMI       ', '2022-12-15 16:35:42', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('klu0p', 'klu0p', 'KLUniversity', '2022-03-17 00:00:00', '2999-01-01 00:00:00', 16.440342, 80.623689, 0.00, 'SOUTH EAST ASIA', '', 'ON ', 'KLU       ', '2022-12-15 16:34:21', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('mal0p', 'mal0p', 'Broglio Space Center', '2022-04-05 12:15:00', '2999-01-01 00:00:00', -2.995556, 40.194444, 0.00, 'AFRICA', '', 'ON ', 'ASI       ', '2022-12-15 17:27:36', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('sab0p', 'sab0p', 'Saba', '2022-05-03 00:01:00', '2999-01-01 00:00:00', 17.621000, -63.243000, 279.00, 'CENTRAL AMERICA', '', 'ON ', 'KNMI      ', '2022-12-15 17:24:49', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('cha0p', 'cha0p', 'Chania', '2022-06-21 12:31:00', '2999-01-01 00:00:00', 35.518866, 24.042406, 68.00, 'MEDITERRANEAN', '', 'ON ', 'HMU       ', '2022-12-15 16:28:30', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('dmc1p', 'dmc1p', 'Dome C', '2022-11-23 07:46:00', '2999-01-01 00:00:00', -75.106048, 123.304836, 3236.00, 'ANTARCTIC', '', 'ON ', 'PNRA      ', '2022-12-15 17:28:17', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('dmc2p', 'dmc2p', 'Dome C', '2022-11-26 11:31:00', '2999-01-01 00:00:00', -75.099586, 123.304816, 3232.00, 'ANTARCTIC', '', 'ON ', 'PNRA      ', '2022-12-15 17:28:00', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('tes0p', 'tes0p', 'test station', '2022-11-23 00:00:00', '2999-01-01 00:00:00', -18.781279, -42.933526, 802.00, 'SOUTH AMERICA', 'TEST STATION DO NOT USE', 'INS', 'INGV      ', '2022-11-23 08:34:09', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('abu0p', 'abu0p', 'Abuja', '2022-12-05 14:00:00', '2999-01-01 00:00:00', 8.989722, 7.384444, 457.00, 'AFRICA', '', 'ON ', 'NASRDA    ', '2023-04-06 14:39:17', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('pru2p', 'pru2p', 'Presidente Prudente', '2023-03-29 12:00:00', '2999-01-01 00:00:00', -22.122037, -51.407080, 442.00, 'SOUTH AMERICA', '', 'INS', 'FCT_UNESP ', '2023-04-18 09:26:08', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('sod0p', 'sod0p', 'Sodankyla', '2023-04-18 15:00:00', '2999-01-01 00:00:00', 67.366669, 26.629917, 205.50, 'EUROPE', '', 'ON ', 'FMI       ', '2023-04-18 11:40:17', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('dha0p', 'dha0p', 'Dhaka', '2024-06-25 14:00:00', '2999-01-01 00:00:00', 23.837448, 90.357175, 34.00, 'SOUTH EAST ASIA', '', 'ON ', 'MIST      ', '2024-06-26 04:28:52', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('suo0p', 'suo0p', 'Suomussalmi', '2023-10-12 09:00:00', '2999-01-01 00:00:00', 65.016639, 28.885333, 267.00, 'EUROPE', '', 'ON ', 'FMI       ', '2023-10-12 10:27:05', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('ken0p', 'ken0p', 'Kenting', '2023-09-19 10:00:00', '2999-01-01 00:00:00', 21.913250, 120.848194, 46.00, 'SOUTH EAST ASIA', NULL, 'ON ', 'NCU       ', '2023-09-19 09:06:45', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('nai0p', 'nai0p', 'Nairobi', '2023-10-11 11:00:00', '2999-01-01 00:00:00', -1.288398, 36.800694, 1735.00, 'AFRICA', NULL, 'ON ', 'KSA       ', '2023-10-11 12:25:53', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('seu0p', 'seu0p', 'St. Eustatius', '2022-05-06 08:24:00', '2999-01-01 00:00:00', 17.471000, -62.976000, 30.93, 'CENTRAL AMERICA', '', 'CLO', 'KNMI      ', '2022-12-15 16:35:07', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('kil0n', 'kil0', 'Kilifi', '2019-05-14 16:01:00', '2999-01-01 00:00:00', -3.600000, 39.800000, NULL, 'AFRICA', NULL, 'CLO', 'PWANI     ', '2022-12-15 17:27:11', 'SEN');
INSERT INTO public.station (code, filecode, name, start_time, end_time, lat, lon, h, area, description, fk_status, fk_institution, modified, fk_producer) VALUES ('cat0p', 'cat0p', 'Catania', '2022-11-23 00:00:00', '2999-01-01 00:00:00', 37.766642, 15.016750, 2847.00, 'MEDITERRANEAN', '', 'ON ', 'INGV      ', '2022-11-23 08:34:09', 'SEN');


--
-- Data for Name: station_belong_institution; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (1, 'btn0s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (2, 'btn0s', 'PNRA', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (3, 'dmc0p', 'PNRA', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (4, 'dmc0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (5, 'dmc0s', 'PNRA', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (6, 'dmc0s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (7, 'dmc1s', 'PNRA', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (8, 'dmc1s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (9, 'dmc2s', 'PNRA', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (10, 'dmc2s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (11, 'han0p', 'NAVIS', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (12, 'kil0n', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (13, 'kil0n', 'ERAU', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (14, 'lam0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (15, 'lam0s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (16, 'lyb0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (17, 'lyb0s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (18, 'mzs0p', 'PNRA', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (19, 'mzs0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (20, 'nic0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (21, 'nya0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (22, 'nya0s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (23, 'nya1p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (24, 'nya1s', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (25, 'san0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (26, 'sao0p', 'INGV', 0, '2020-11-12 11:17:07');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (27, 'ush0p', 'INGV', 0, '2021-12-02 15:12:42');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (28, 'thu0p', 'INGV', 0, '2021-12-02 15:13:13');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (29, 'tuc0p', 'INGV', 0, '2021-12-07 20:55:23');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (30, 'hel0p', 'FMI', 0, '2021-12-15 16:50:18');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (31, 'klu0p', 'KLU', 0, '2022-03-17 10:38:01');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (32, 'mal0p', 'INGV', 0, '2022-04-06 06:25:16');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (33, 'sab0p', 'KNMI', 0, '2022-05-04 20:51:56');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (34, 'seu0p', 'KNMI', 0, '2022-05-06 10:33:01');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (35, 'cha0p', 'INGV', 0, '2022-06-21 12:25:14');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (36, 'cat0p', 'INGV', 0, '2022-11-08 16:16:25');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (37, 'dmc1p', 'INGV', 0, '2022-11-21 11:16:28');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (38, 'dmc1p', 'PNRA', 0, '2022-11-21 11:16:35');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (39, 'dmc2p', 'INGV', 0, '2022-11-21 11:16:42');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (40, 'dmc2p', 'PNRA', 0, '2022-11-21 11:16:46');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (42, 'tes0p', 'INGV', 0, '2022-11-22 08:09:42');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (43, 'abu0p', 'INGV', 0, '2022-12-05 12:56:36');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (44, 'pru2p', 'FCT_UNESP', 0, '2023-03-28 12:49:16');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (45, 'sod0p', 'FMI', 0, '2023-04-18 09:14:12');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (49, 'suo0p', 'FMI', 0, '2023-10-11 13:06:26');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (50, 'dha0p', 'INGV', 0, '2024-06-26 04:23:09');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (51, 'nai0p', 'KSA', 0, '2023-10-11 09:47:55');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (52, 'ken0p', 'INGV', 0, '2023-09-19 08:09:12');
INSERT INTO public.station_belong_institution (id, fk_station, fk_institution, orderby, modified) VALUES (53, 'ken0p', 'IAP', 0, '2023-09-19 09:04:44');


--
-- Data for Name: station_has_instrument; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (1, 'btn0s', 'NG4', '2006-01-18 00:00:00', '2019-01-04 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (2, 'dmc0s', 'NG4', '2009-11-18 00:01:00', '2022-09-25 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (3, 'nya1s', 'NG4', '2010-01-01 00:02:00', '2020-09-17 02:22:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (4, 'lyb0p', 'S5S', '2019-01-13 10:39:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (5, 'dmc0p', 'S5S', '2017-01-29 03:16:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (6, 'san0p', 'SXS', '2015-12-27 09:51:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (7, 'nya0p', 'S5S', '2015-11-09 00:01:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (8, 'sao0p', 'SXS', '2017-05-31 13:33:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (9, 'dmc1s', 'NG4', '2010-10-31 00:01:00', '2022-09-25 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (10, 'dmc2s', 'NG4', '2013-11-16 07:44:00', '2022-09-25 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (11, 'lam0p', 'S5S', '2019-10-16 07:28:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (12, 'mzs0p', 'SXS', '2016-11-29 22:01:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (13, 'nya0s', 'NG4', '2003-09-01 00:00:00', '2020-09-17 00:40:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (14, 'nya1p', 'S5S', '2020-01-02 13:11:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (15, 'lam0s', 'NG4', '2011-06-22 00:01:00', '2018-11-07 10:15:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (16, 'lyb0s', 'NG4', '2010-01-01 00:01:00', '2017-10-07 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (17, 'nic0p', 'S5S', '2020-09-29 14:01:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (18, 'han0p', 'SXS', '2020-09-30 06:16:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (19, 'thu0n', 'NG6', '2023-04-30 00:00:00', '2000-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (20, 'thu0p', 'S5S', '2021-04-29 11:05:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (21, 'ush0p', 'S5S', '2021-12-02 15:31:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (22, 'tuc0p', 'S5S', '2021-12-09 09:31:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (23, 'hel0p', 'S5S', '2021-12-16 09:01:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (24, 'klu0p', 'S5S', '2022-03-17 00:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (25, 'mal0p', 'S5S', '2022-04-05 12:15:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (26, 'sab0p', 'S5S', '2022-05-03 00:01:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (27, 'cha0p', 'S5S', '2022-06-21 12:31:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (28, 'dmc1p', 'S5S', '2022-11-23 07:46:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (29, 'dmc2p', 'S5S', '2022-11-26 11:31:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (30, 'tes0p', 'S5S', '2022-11-23 00:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (31, 'abu0p', 'S5S', '2022-12-05 14:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (32, 'pru2p', 'S5S', '2023-03-29 12:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (33, 'sod0p', 'S5S', '2023-04-18 15:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (34, 'dha0p', 'S5S', '2024-06-25 14:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (35, 'suo0p', 'S5S', '2023-10-12 09:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (36, 'ken0p', 'SXS', '2023-09-19 10:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (37, 'nai0p', 'S5S', '2023-10-11 11:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (38, 'seu0p', 'S5S', '2022-05-06 08:24:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (39, 'kil0n', 'NG6', '2019-05-14 16:01:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');
INSERT INTO public.station_has_instrument (id, fk_station, fk_instrument, start_time, end_time, orderby, modified) VALUES (40, 'cat0p', 'S5S', '2022-11-23 00:00:00', '2999-01-01 00:00:00', 0, '2025-01-28 11:05:23.562835');


--
-- Data for Name: station_instrument_period; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (1, 's', '2006-01-18 00:00:00', '2019-01-04 00:00:00', 0, 'btn0s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (2, 's', '2009-11-18 00:01:00', '2022-09-25 00:00:00', 0, 'dmc0s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (3, 's', '2010-01-01 00:02:00', '2020-09-17 02:22:00', 0, 'nya1s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (4, 'p', '2019-01-13 10:39:00', '2999-01-01 00:00:00', 0, 'lyb0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (5, 'p', '2017-01-29 03:16:00', '2999-01-01 00:00:00', 0, 'dmc0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (6, 'p', '2015-12-27 09:51:00', '2999-01-01 00:00:00', 0, 'san0p', 'SXS', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (7, 'p', '2015-11-09 00:01:00', '2999-01-01 00:00:00', 0, 'nya0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (8, 'p', '2017-05-31 13:33:00', '2999-01-01 00:00:00', 0, 'sao0p', 'SXS', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (9, 's', '2010-10-31 00:01:00', '2022-09-25 00:00:00', 0, 'dmc1s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (10, 's', '2013-11-16 07:44:00', '2022-09-25 00:00:00', 0, 'dmc2s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (11, 'p', '2019-10-16 07:28:00', '2999-01-01 00:00:00', 0, 'lam0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (12, 'p', '2016-11-29 22:01:00', '2999-01-01 00:00:00', 0, 'mzs0p', 'SXS', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (13, 's', '2003-09-01 00:00:00', '2020-09-17 00:40:00', 0, 'nya0s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (14, 'p', '2020-01-02 13:11:00', '2999-01-01 00:00:00', 0, 'nya1p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (15, 's', '2011-06-22 00:01:00', '2018-11-07 10:15:00', 0, 'lam0s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (16, 's', '2010-01-01 00:01:00', '2017-10-07 00:00:00', 0, 'lyb0s', 'NG4', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (17, 'p', '2020-09-29 14:01:00', '2999-01-01 00:00:00', 0, 'nic0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (18, 'p', '2020-09-30 06:16:00', '2999-01-01 00:00:00', 0, 'han0p', 'SXS', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (19, 'n', '2023-04-30 00:00:00', '2000-01-01 00:00:00', 0, 'thu0n', 'NG6', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (20, 'p', '2021-04-29 11:05:00', '2999-01-01 00:00:00', 0, 'thu0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (21, 'p', '2021-12-02 15:31:00', '2999-01-01 00:00:00', 0, 'ush0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (22, 'p', '2021-12-09 09:31:00', '2999-01-01 00:00:00', 0, 'tuc0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (23, 'p', '2021-12-16 09:01:00', '2999-01-01 00:00:00', 0, 'hel0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (24, 'p', '2022-03-17 00:00:00', '2999-01-01 00:00:00', 0, 'klu0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (25, 'p', '2022-04-05 12:15:00', '2999-01-01 00:00:00', 0, 'mal0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (26, 'p', '2022-05-03 00:01:00', '2999-01-01 00:00:00', 0, 'sab0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (27, 'p', '2022-06-21 12:31:00', '2999-01-01 00:00:00', 0, 'cha0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (28, 'p', '2022-11-23 07:46:00', '2999-01-01 00:00:00', 0, 'dmc1p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (29, 'p', '2022-11-26 11:31:00', '2999-01-01 00:00:00', 0, 'dmc2p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (30, 'p', '2022-11-23 00:00:00', '2999-01-01 00:00:00', 0, 'tes0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (31, 'p', '2022-12-05 14:00:00', '2999-01-01 00:00:00', 0, 'abu0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (32, 'p', '2023-03-29 12:00:00', '2999-01-01 00:00:00', 0, 'pru2p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (33, 'p', '2023-04-18 15:00:00', '2999-01-01 00:00:00', 0, 'sod0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (34, 'p', '2024-06-25 14:00:00', '2999-01-01 00:00:00', 0, 'dha0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (35, 'p', '2023-10-12 09:00:00', '2999-01-01 00:00:00', 0, 'suo0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (36, 'p', '2023-09-19 10:00:00', '2999-01-01 00:00:00', 0, 'ken0p', 'SXS', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (37, 'p', '2023-10-11 11:00:00', '2999-01-01 00:00:00', 0, 'nai0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (38, 'p', '2022-05-06 08:24:00', '2999-01-01 00:00:00', 0, 'seu0p', 'S5S', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (39, 'n', '2019-05-14 16:01:00', '2999-01-01 00:00:00', 0, 'kil0n', 'NG6', '2025-01-28 19:31:32.262716');
INSERT INTO public.station_instrument_period (id, code, start_time, end_time, orderby, fk_station, fk_instrument, modified) VALUES (40, 'p', '2022-11-23 00:00:00', '2999-01-01 00:00:00', 0, 'cat0p', 'S5S', '2025-01-28 19:31:32.262716');


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.status (code, name, description, modified) VALUES ('CLO', 'Closed', 'Dismissed station', '2020-11-09 10:42:23');
INSERT INTO public.status (code, name, description, modified) VALUES ('INS', 'Installing', 'Installing station', '2020-11-09 10:42:23');
INSERT INTO public.status (code, name, description, modified) VALUES ('OFF', 'Disabled', 'Tenporary disabled station', '2020-11-09 10:42:23');
INSERT INTO public.status (code, name, description, modified) VALUES ('ON', 'Active', 'Online station', '2020-11-09 10:42:23');


--
-- Data for Name: type_table; Type: TABLE DATA; Schema: public; Owner: scintu
--

INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('ais_auto', 'ais autoscaled', NULL, '_auto', 'ais_auto_file', NULL, '2025-01-28 11:05:23.328562');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('ais_rdf', 'ais raw ddata format', NULL, '_rdf', 'ais_rdf_file', NULL, '2025-01-28 11:05:23.333504');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('ais_rev', 'ais manual defined values', NULL, '_rev', 'ais_rev_file', NULL, '2025-01-28 11:05:23.335253');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('dps_auto', 'dps autoscaled data', NULL, '_auto', 'dps_sao_file, dps4d_xml_file', NULL, '2025-01-28 11:05:23.336995');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('hf_ncfc', 'hf product', NULL, '', 'hf_nc_fc_file', NULL, '2025-01-28 11:05:23.338658');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('ismr_sept', 'ismr septentrio file', NULL, '', 'septentrio_file', NULL, '2025-01-28 11:05:23.340293');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('nov_gps', 'nov gps est data', NULL, '_auto', 'novatel_gps_file', NULL, '2025-01-28 11:05:23.345084');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('nov_multi', 'novatel multisat data', NULL, '', 'novatel_multi_file', NULL, '2025-01-28 11:05:23.347118');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('raw_sept', 'raw sept data', NULL, '_auto', 'septentrio_file', NULL, '2025-01-28 11:05:23.348833');
INSERT INTO public.type_table (code, name, dictionary, tableextension, parser_ref, description, modified) VALUES ('tec_ncfc', 'tec product data', NULL, '', 'tec_file', NULL, '2025-01-28 11:05:23.350662');


--
-- Name: constellation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scintu
--

SELECT pg_catalog.setval('public.constellation_id_seq', 1, false);


--
-- Name: station_belong_institution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scintu
--

SELECT pg_catalog.setval('public.station_belong_institution_id_seq', 1, true);


--
-- Name: station_has_instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scintu
--

SELECT pg_catalog.setval('public.station_has_instrument_id_seq', 40, true);


--
-- Name: station_instrument_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: scintu
--

SELECT pg_catalog.setval('public.station_instrument_period_id_seq', 40, true);


--
-- Name: constellation constellation_code_key; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.constellation
    ADD CONSTRAINT constellation_code_key UNIQUE (code);


--
-- Name: constellation constellation_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.constellation
    ADD CONSTRAINT constellation_pkey PRIMARY KEY (id);


--
-- Name: institution institution_name_key; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.institution
    ADD CONSTRAINT institution_name_key UNIQUE (name);


--
-- Name: institution institution_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.institution
    ADD CONSTRAINT institution_pkey PRIMARY KEY (code);


--
-- Name: instrument instrument_name_key; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_name_key UNIQUE (name);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (code);


--
-- Name: producer producer_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.producer
    ADD CONSTRAINT producer_pkey PRIMARY KEY (code);


--
-- Name: satellite satellite_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.satellite
    ADD CONSTRAINT satellite_pkey PRIMARY KEY (svid);


--
-- Name: station_belong_institution station_belong_institution_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_belong_institution
    ADD CONSTRAINT station_belong_institution_pkey PRIMARY KEY (id);


--
-- Name: station_has_instrument station_has_instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_has_instrument
    ADD CONSTRAINT station_has_instrument_pkey PRIMARY KEY (id);


--
-- Name: station_instrument_period station_instrument_period_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_instrument_period
    ADD CONSTRAINT station_instrument_period_pkey PRIMARY KEY (id);


--
-- Name: station station_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (code);


--
-- Name: status status_name_key; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_name_key UNIQUE (name);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (code);


--
-- Name: type_table type_table_pkey; Type: CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.type_table
    ADD CONSTRAINT type_table_pkey PRIMARY KEY (code);


--
-- Name: satellite foreign_contellation; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.satellite
    ADD CONSTRAINT foreign_contellation FOREIGN KEY (fk_constellation) REFERENCES public.constellation(id);


--
-- Name: station foreign_institution; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT foreign_institution FOREIGN KEY (fk_institution) REFERENCES public.institution(code);


--
-- Name: station_belong_institution foreign_institution; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_belong_institution
    ADD CONSTRAINT foreign_institution FOREIGN KEY (fk_institution) REFERENCES public.institution(code);


--
-- Name: station_has_instrument foreign_instrument; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_has_instrument
    ADD CONSTRAINT foreign_instrument FOREIGN KEY (fk_instrument) REFERENCES public.instrument(code);


--
-- Name: station_instrument_period foreign_instrument; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_instrument_period
    ADD CONSTRAINT foreign_instrument FOREIGN KEY (fk_instrument) REFERENCES public.instrument(code);


--
-- Name: station foreign_producer; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT foreign_producer FOREIGN KEY (fk_producer) REFERENCES public.producer(code);


--
-- Name: station_belong_institution foreign_station; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_belong_institution
    ADD CONSTRAINT foreign_station FOREIGN KEY (fk_station) REFERENCES public.station(code);


--
-- Name: station_has_instrument foreign_station; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_has_instrument
    ADD CONSTRAINT foreign_station FOREIGN KEY (fk_station) REFERENCES public.station(code);


--
-- Name: station_instrument_period foreign_station; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station_instrument_period
    ADD CONSTRAINT foreign_station FOREIGN KEY (fk_station) REFERENCES public.station(code);


--
-- Name: station foreign_status; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT foreign_status FOREIGN KEY (fk_status) REFERENCES public.status(code);


--
-- Name: instrument foreign_type_table; Type: FK CONSTRAINT; Schema: public; Owner: scintu
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT foreign_type_table FOREIGN KEY (fk_type_table) REFERENCES public.type_table(code);


--
-- Name: TABLE constellation; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.constellation TO wsreader;
GRANT SELECT ON TABLE public.constellation TO grafana;


--
-- Name: TABLE institution; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.institution TO wsreader;
GRANT SELECT ON TABLE public.institution TO grafana;


--
-- Name: TABLE instrument; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.instrument TO wsreader;
GRANT SELECT ON TABLE public.instrument TO grafana;


--
-- Name: TABLE producer; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.producer TO grafana;
GRANT SELECT ON TABLE public.producer TO wsreader;


--
-- Name: TABLE satellite; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.satellite TO wsreader;
GRANT SELECT ON TABLE public.satellite TO grafana;


--
-- Name: TABLE station; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.station TO wsreader;
GRANT SELECT ON TABLE public.station TO grafana;


--
-- Name: TABLE station_belong_institution; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.station_belong_institution TO wsreader;
GRANT SELECT ON TABLE public.station_belong_institution TO grafana;


--
-- Name: TABLE station_has_instrument; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.station_has_instrument TO grafana;
GRANT SELECT ON TABLE public.station_has_instrument TO wsreader;


--
-- Name: TABLE status; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.status TO wsreader;
GRANT SELECT ON TABLE public.status TO grafana;


--
-- Name: TABLE type_table; Type: ACL; Schema: public; Owner: scintu
--

GRANT SELECT ON TABLE public.type_table TO grafana;
GRANT SELECT ON TABLE public.type_table TO wsreader;


--
-- PostgreSQL database dump complete
--

