\set ON_ERROR_STOP off

CREATE USER switu WITH PASSWORD '$SWITU_PASS';
CREATE DATABASE swit OWNER switu;
GRANT ALL PRIVILEGES ON DATABASE swit TO switu;

\set ON_ERROR_STOP on
\c swit

--
--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)

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
-- Name: dt_format; Type: TABLE; Schema: public; Owner: switu
--

CREATE TABLE public.dt_format (
    code character(3) NOT NULL,
    dt_len integer NOT NULL,
    description text
);


ALTER TABLE public.dt_format OWNER TO switu;

--
-- Name: file_input; Type: TABLE; Schema: public; Owner: switu
--

CREATE TABLE public.file_input (
    code character varying(6) NOT NULL,
    filecode character varying(20) NOT NULL,
    dt_start integer NOT NULL,
    extension character varying(255) NOT NULL,
    description text,
    fk_dt_format character(3),
    db_host character varying(255) NOT NULL,
    db_port integer NOT NULL,
    db_name character varying(255) NOT NULL,
    to_parse integer NOT NULL,
    to_store integer NOT NULL,
    bkup_dir character varying(255) NOT NULL,
    db_type character varying DEFAULT 'pg'::character varying NOT NULL,
    db_user character varying DEFAULT 'user'::character varying NOT NULL,
    db_pass character varying DEFAULT 'pass'::character varying NOT NULL,
    fk_file_type character varying(50) DEFAULT 'def_set'::character varying NOT NULL,
    code_start integer DEFAULT 0 NOT NULL,
    code_length integer DEFAULT 5 NOT NULL
);


ALTER TABLE public.file_input OWNER TO switu;

--
-- Name: file_type; Type: TABLE; Schema: public; Owner: switu
--

CREATE TABLE public.file_type (
    code character varying(50) NOT NULL,
    parser_ref character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.file_type OWNER TO switu;

--
-- Data for Name: dt_format; Type: TABLE DATA; Schema: public; Owner: switu
--

COPY public.dt_format (code, dt_len, description) FROM stdin;
NG0	10	YYMMGGHHNN
TE0	15	YYYYMMGGTHHNNSS
NM0	12	YYYY_D_HH_MM, a
AI0	13	YYJJJAMM, A lettera pre le ore
AI1	11	station_YYYYJJJHHNNSS
AI2	13	YYYYMMGGHHNN
SE0	9	JJJAMM.YY, A lettera per le ore
DP0	8	YJJJAMMS, Y anno  primi sondaggi sono del 1997 fino al 2005, S una lettera indicante i secondi delinizio del sondaggio A= 0-4 secondi e cosi via nella lettura i secondi vengono tralasciati e  messi sempre a 00
\.


--
-- Data for Name: file_input; Type: TABLE DATA; Schema: public; Owner: switu
--

COPY public.file_input (code, filecode, dt_start, extension, description, fk_dt_format, db_host, db_port, db_name, to_parse, to_store, bkup_dir, db_type, db_user, db_pass, fk_file_type, code_start, code_length) FROM stdin;
rm041	rm041	6	dat	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rev	0	5
gm037	gm037	6	dat	\N	AI2	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rev	0	5
ro041	ro041	6	sao	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	dps_auto	0	5
rm041	rm041	6	rdf	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rdf	0	5
bbj3r	bbj3r	6	rdf	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rdf	0	5
tuj2o	tuj2z	6	rdf	\N	AI0	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rdf	0	5
gm037	gm037	6	rdf	\N	AI0	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rdf	0	5
tuj2o	tuj2o	6	rdf	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rdf	0	5
fcmr0	fcmr0	6	json		TE0	aispg	5432	ais	1	1	ais	pg	aisu	password	hf_ncfc	0	5
fcmv0	fcmv0	6	json		TE0	aispg	5432	ais	1	1	ais	pg	aisu	password	hf_ncfc	0	5
ncmv0	ncmv0	6	json		TE0	aispg	5432	ais	1	1	ais	pg	aisu	password	hf_ncfc	0	5
ml10l	ml10l	6	rdf		AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rdf	0	5
ncmr0	ncmr0	6	json		TE0	aispg	5432	ais	1	1	ais	pg	aisu	password	hf_ncfc	0	5
so148	so148	6	sao		AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	dps_auto	0	5
so148	so148	6	xml		AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	def_set	0	5
ml10l	ml10l	6	txt		AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_auto	0	5
ml10l	ml10l	6	xml		AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_sao	0	5
ml10l	ml10l	6	dat		AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_rev	0	5
rm041	rm041	6	gif	\N	AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
bbj3r	bbj3r	6	gif	\N	AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
tuj2o	tuj2z	6	gif	\N	AI0	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
ro041	ro041	6	gif	\N	AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
ro041	ro041	6	sbf	\N	AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
gm037	gm037	6	gif	\N	AI0	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
ro041	roold	6	gif	\N	DP0	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
ro041	roold	6	sbf	\N	DP0	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
nc_gl	nc_gl	28	json	\N	TE0	datapg	5432	tecdb	1	1	tecdb	pg	tecu	password	tec_ncfc	9	5
ltf_gl	ltf_gl	28	json	\N	TE0	datapg	5432	tecdb	1	1	tecdb	pg	tecu	password	tec_ncfc	9	6
nc_eu	nc_eu	27	json	\N	TE0	datapg	5432	tecdb	1	1	tecdb	pg	tecu	password	tec_ncfc	9	5
sf_med	stfmed	30	json		TE0	eswua.rm.ingv.it	5432	tecdb	1	1	tecdb	pg	tecu	password	tec_ncfc	9	6
tuj2o	tuj2o	6	gif	\N	AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
so148	so148	6	gif		AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
so148	so148	6	rsf		AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
ml10l	ml10l	6	gif		AI1	aispg	5432	ais	0	1	ais	pg	aisu	password	def_set	0	5
ro041	roold	6	sao	\N	DP0	aispg	5432	ais	1	1	ais	pg	aisu	password	dps_auto	0	5
rm041	rm041	6	txt	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_auto	0	5
bbj3r	bbj3r	6	txt	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_auto	0	5
tuj2o	tuj2z	6	txt	\N	AI0	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_auto	0	5
gm037	gm037	6	txt	\N	AI0	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_auto	0	5
tuj2o	tuj2o	6	txt	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_auto	0	5
bbj3r	bbj3r	6	xml	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_sao	0	5
tuj2o	tuj2z	6	xml	\N	AI0	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_sao	0	5
gm037	gm037	6	xml	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_sao	0	5
rm041	rm041	6	xml	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_sao	0	5
tuj2o	tuj2o	6	xml	\N	AI1	aispg	5432	ais	1	1	ais	pg	aisu	password	ais_sao	0	5
nc_med	nc_med	29	json	\N	TE0	datapg	5432	tecdb	1	1	tecdb	pg	tecu	password	tec_ncfc	9	6
dmc0s	dmc0s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
dmc1s	dmc1s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
dmc2s	dmc2s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
san0p	sna0p	6	[2-9][0-9]\\_	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
nya1s	nya1s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
nya1s	nya1s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
btn0s	btn0s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
btn0s	btn0s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
lam0p	lam0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
lyb0p	lyb0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
mzs0p	btn0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
nya0p	nya0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
nya1p	nya1p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
sao0p	sao0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
san0p	sna0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
thu0p	thu0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
ush0p	ush0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
tuc0p	tuc0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
hel0p	hel0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
klu0p	klu0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
cha0p	cha0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
sab0p	sab0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
seu0p	seu0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
mal0p	mal0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
cat0p	cat0p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
tes0p	tes0p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
nya0p	nya0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
ush0p	ush0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
tuc0p	tuc0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
hel0p	hel0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
klu0p	klu0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
cat0p	cat0p	6	[0-9][0-9]o		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
sao0p	sao0p	6	[2-9][0-9]\\_	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
lam0p	lam0p	6	[0-9][0-9]l	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
lam0p	lam0p	6	[0-9][0-9]n	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
lyb0p	lyb0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
nic0p	nic0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
nya1p	nya1p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
sao0p	sao0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
san0p	sna0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
nya0s	nya0s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
nya0s	nya0s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
lam0s	lam0s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
lam0s	lam0s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
dmc1p	dmc1p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
dmc2p	dmc2p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
abu0p	abu0p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
sod0p	sod0p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
pru2p	pru2p	5	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
thu0n	thu0n	6	rwd		NM0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_multi	0	5
hel0p	hel0p	6	[0-9][0-9]_		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	raw_sept	0	5
sod0p	sod0p	6	[0-9][0-9]_		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	raw_sept	0	5
ken0p	ken0p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
abu0p	abu0p	6	[0-9][0-9]o		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
sod0p	sod0p	6	[0-9][0-9]o		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
lyb0s	lyb0s	6	est	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
lyb0s	lyb0s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
nic0p	nic0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
lam0p	lam0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
kil0n	kil0	5	rwd	\N	NM0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_multi	0	4
lam0p	lam0p	6	[0-9][0-9]g	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
lam0p	lam0p	6	[0-9][0-9]h	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
dmc0s	dmc0s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
dmc1s	dmc1s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
dmc2s	dmc2s	6	s60	\N	NG0	scintdb	5432	scint	1	1	scint	pg	scintu	password	nov_gps	0	5
dmc0p	dmc0p	6	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
lam0p	lam0p	6	[0-9][0-9]i	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
suo0p	suo0p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
suo0p	suo0p	6	[0-9][0-9]_		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	raw_sept	0	5
nai0p	nai0p	6	ismr		SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	5
han0p	tqbs	4	ismr	\N	SE0	scintdb	5432	scint	1	1	scint	pg	scintu	password	ismr_sept	0	4
ken0p	ken0p	6	[0-9][0-9]o		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
suo0p	suo0p	6	[0-9][0-9]o		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
nai0p	nai0p	6	[0-9][0-9]o		SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	5
han0p	tqbs	4	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	def_set	0	4
cha0p	cha0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	ismr_sept	0	5
mal0p	mal0p	6	[0-9][0-9]o	\N	SE0	scintdb	5432	scint	0	1	scint	pg	scintu	password	ismr_sept	0	5
\.


--
-- Data for Name: file_type; Type: TABLE DATA; Schema: public; Owner: switu
--

COPY public.file_type (code, parser_ref, description) FROM stdin;
def_set	progammatically set	\N
ais_auto	class_ais_measure_auto.php	\N
ais_rev	class_ais_measure_rev.php	\N
ais_rdf	class_ais_rdf.php	\N
ais_sao	class_ais_measure_sao.php	\N
dps_auto	class_dps_sao.php	\N
hf_ncfc	class_hf_nc_fc.php	\N
nov_gps	class_novatel_gps.php	\N
nov_multi	class_novatel_multi.php	\N
ismr_sept	class_septentrio.php	\N
tec_ncfc	class_tec.php	\N
raw_sept	class_septentrio.php	\N
\.


--
-- Name: dt_format dt_format_pkey; Type: CONSTRAINT; Schema: public; Owner: switu
--

ALTER TABLE ONLY public.dt_format
    ADD CONSTRAINT dt_format_pkey PRIMARY KEY (code);


--
-- Name: file_input file_input_pkey; Type: CONSTRAINT; Schema: public; Owner: switu
--

ALTER TABLE ONLY public.file_input
    ADD CONSTRAINT file_input_pkey PRIMARY KEY (filecode, extension, dt_start);


--
-- Name: file_type file_type_pkey; Type: CONSTRAINT; Schema: public; Owner: switu
--

ALTER TABLE ONLY public.file_type
    ADD CONSTRAINT file_type_pkey PRIMARY KEY (code);


--
-- Name: file_input foreign_file_type; Type: FK CONSTRAINT; Schema: public; Owner: switu
--

ALTER TABLE ONLY public.file_input
    ADD CONSTRAINT foreign_file_type FOREIGN KEY (fk_file_type) REFERENCES public.file_type(code);


--
-- PostgreSQL database dump complete
--

