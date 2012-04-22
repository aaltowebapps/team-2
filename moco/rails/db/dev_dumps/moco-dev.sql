--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: presentations; Type: TABLE; Schema: public; Owner: moco-dev; Tablespace: 
--

CREATE TABLE presentations (
    id integer NOT NULL,
    owner integer,
    name character varying(255),
    description character varying(255),
    "currentSlide" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    url character varying(255)
);


ALTER TABLE public.presentations OWNER TO "moco-dev";

--
-- Name: presentations_id_seq; Type: SEQUENCE; Schema: public; Owner: moco-dev
--

CREATE SEQUENCE presentations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.presentations_id_seq OWNER TO "moco-dev";

--
-- Name: presentations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moco-dev
--

ALTER SEQUENCE presentations_id_seq OWNED BY presentations.id;


--
-- Name: presentations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moco-dev
--

SELECT pg_catalog.setval('presentations_id_seq', 7, true);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: moco-dev; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO "moco-dev";

--
-- Name: users; Type: TABLE; Schema: public; Owner: moco-dev; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO "moco-dev";

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: moco-dev
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO "moco-dev";

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: moco-dev
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: moco-dev
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: moco-dev
--

ALTER TABLE ONLY presentations ALTER COLUMN id SET DEFAULT nextval('presentations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: moco-dev
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: presentations; Type: TABLE DATA; Schema: public; Owner: moco-dev
--

COPY presentations (id, owner, name, description, "currentSlide", created_at, updated_at, url) FROM stdin;
7	1	Napoleon bonaparte	English course essay	\N	2012-04-16 17:28:45.059475	2012-04-16 17:28:45.059475	\N
1	1	my presentation	my awesome presentation	23	2012-03-19 16:15:20.215014	2012-04-22 07:35:45.57785	/example_presentation/index.html
5	1	Mid project demo	Moco project demo, 14.5 april	\N	2012-04-16 14:38:40.002259	2012-04-16 14:38:40.002259	\N
6	1	Mid project demo	Moco project demo, 14.5 april	\N	2012-04-16 14:38:40.106182	2012-04-16 14:38:40.106182	\N
3	2	other presentation	my awesome presentation	\N	2012-04-16 12:09:08.463874	2012-04-16 12:09:08.463874	\N
4	1	HTML5 presentation	what	\N	2012-04-16 12:09:38.723869	2012-04-16 12:09:38.723869	\N
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: moco-dev
--

COPY schema_migrations (version) FROM stdin;
20120319153023
20120319153955
20120331083632
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: moco-dev
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at) FROM stdin;
2	joni@test.fi	$2a$10$kV0wN46CiVpRjyUnUv2TH.1.9qKR/iWn4hO5dloO39TA2DsXXa8HW	\N	\N	\N	3	2012-04-16 12:09:48.261727	2012-04-16 12:08:53.556279	127.0.0.1	127.0.0.1	2012-04-16 12:04:52.160855	2012-04-16 12:09:48.262992
1	joni.rajanen@gmail.com	$2a$10$uOBoQGR/Oj5F.4kdJ9M3xuUpl26AU0Kk1cn7OF6qUEgXDFS1ZU4QW	\N	\N	\N	96	2012-04-22 07:35:10.307339	2012-04-22 05:03:59.607033	127.0.0.1	127.0.0.1	2012-03-29 04:22:27.775676	2012-04-22 07:35:10.30894
\.


--
-- Name: presentations_pkey; Type: CONSTRAINT; Schema: public; Owner: moco-dev; Tablespace: 
--

ALTER TABLE ONLY presentations
    ADD CONSTRAINT presentations_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: moco-dev; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: moco-dev; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: moco-dev; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: moco-dev; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

