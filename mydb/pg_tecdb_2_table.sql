\c tecdb

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 14.8 (Ubuntu 14.8-0ubuntu0.22.04.1)

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
-- Name: instrument; Type: TABLE; Schema: public; Owner: tecu
--

CREATE TABLE public.instrument (
    code character(3) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    modified timestamp without time zone
);


ALTER TABLE public.instrument OWNER TO tecu;

--
-- Name: station; Type: TABLE; Schema: public; Owner: tecu
--

CREATE TABLE public.station (
    id integer NOT NULL,
    code character varying(6) NOT NULL,
    filecode character varying(6) NOT NULL,
    name character varying(255),
    lat numeric(9,6),
    lon numeric(9,6),
    h numeric(8,2),
    area character varying(255),
    description text,
    fk_instrument character(3)
);


ALTER TABLE public.station OWNER TO tecu;

--
-- Name: station_id_seq; Type: SEQUENCE; Schema: public; Owner: tecu
--

CREATE SEQUENCE public.station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_id_seq OWNER TO tecu;

--
-- Name: station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tecu
--

ALTER SEQUENCE public.station_id_seq OWNED BY public.station.id;


--
-- Name: station id; Type: DEFAULT; Schema: public; Owner: tecu
--

ALTER TABLE ONLY public.station ALTER COLUMN id SET DEFAULT nextval('public.station_id_seq'::regclass);


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: tecu
--



--
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: tecu
--

INSERT INTO public.station (id, code, filecode, name, lat, lon, h, area, description, fk_instrument) VALUES (1, 'nc_med', 'nc_med', 'TEC NOWCASTING OVER MED', 43.120000, 13.330000, NULL, NULL, NULL, 'RIN');
INSERT INTO public.station (id, code, filecode, name, lat, lon, h, area, description, fk_instrument) VALUES (5, 'sf_med', 'sf_med', 'TEC SHORT TERM FORECASTING OVER MED', 43.120000, 13.330000, NULL, NULL, NULL, 'RIN');
INSERT INTO public.station (id, code, filecode, name, lat, lon, h, area, description, fk_instrument) VALUES (4, 'nc_eu', 'nc_eu', 'TEC FORECASTING OVER WORLD', 43.120000, 13.330000, NULL, NULL, NULL, 'EUR');
INSERT INTO public.station (id, code, filecode, name, lat, lon, h, area, description, fk_instrument) VALUES (2, 'nc_gl', 'nc_gl', 'TEC NOWCASTING OVER WORLD', 43.120000, 13.330000, NULL, NULL, NULL, 'IGS');
INSERT INTO public.station (id, code, filecode, name, lat, lon, h, area, description, fk_instrument) VALUES (3, 'ltf_gl', 'ltf_gl', 'TEC NOWCASTING OVER EUROPE', 43.120000, 13.330000, NULL, NULL, NULL, 'IGS');


--
-- Name: station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tecu
--

SELECT pg_catalog.setval('public.station_id_seq', 4, true);


--
-- Name: instrument instrument_name_key; Type: CONSTRAINT; Schema: public; Owner: tecu
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_name_key UNIQUE (name);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: tecu
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (code);


--
-- Name: station station_code_key; Type: CONSTRAINT; Schema: public; Owner: tecu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_code_key UNIQUE (code);


--
-- Name: station station_pkey; Type: CONSTRAINT; Schema: public; Owner: tecu
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (id);


--
-- Name: TABLE instrument; Type: ACL; Schema: public; Owner: tecu
--

GRANT SELECT ON TABLE public.instrument TO grafana;


--
-- Name: TABLE station; Type: ACL; Schema: public; Owner: tecu
--

GRANT SELECT ON TABLE public.station TO grafana;


--
-- PostgreSQL database dump complete
--

