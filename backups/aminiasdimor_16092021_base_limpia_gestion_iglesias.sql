--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.20
-- Dumped by pg_dump version 12.3

-- Started on 2021-09-16 22:44:21

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

--
-- TOC entry 7 (class 2615 OID 33200)
-- Name: iglesias; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA iglesias;


ALTER SCHEMA iglesias OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 33201)
-- Name: seguridad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA seguridad;


ALTER SCHEMA seguridad OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 33202)
-- Name: fn_mostrar_jerarquia(character varying, character varying, integer, integer); Type: FUNCTION; Schema: iglesias; Owner: postgres
--

CREATE FUNCTION iglesias.fn_mostrar_jerarquia(in_select character varying, in_where character varying, in_idioma_id integer, in_idioma_id_defecto integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    jerarquia VARCHAR;
		sql VARCHAR;
BEGIN
	sql = 'SELECT (' || in_select || ') AS select  FROM (SELECT /*d.descripcion AS division, */
        CASE WHEN di.di_descripcion IS NULL THEN
        (SELECT di_descripcion FROM iglesias.division_idiomas WHERE iddivision=d.iddivision AND idioma_id='|| in_idioma_id_defecto ||')
        ELSE di.di_descripcion END AS division, 
        p.pais_descripcion AS pais, u.descripcion AS union,
        mi.descripcion AS mision, dm.descripcion AS distritomisionero, i.descripcion AS iglesia,
        d.iddivision, p.pais_id, u.idunion, mi.idmision, dm.iddistritomisionero, i.idiglesia
        FROM  iglesias.division AS d  
        LEFT JOIN iglesias.division_idiomas AS di on(di.iddivision=d.iddivision AND di.idioma_id='|| in_idioma_id ||')
        INNER JOIN iglesias.paises AS p ON(d.iddivision=p.iddivision)
        INNER JOIN iglesias.union_paises AS up ON(up.pais_id=p.pais_id)
        INNER JOIN iglesias.union AS u ON(up.idunion=u.idunion)
        INNER JOIN iglesias.mision AS mi ON(u.idunion=mi.idunion)
        INNER JOIN iglesias.distritomisionero AS dm ON(mi.idmision=dm.idmision)
        INNER JOIN iglesias.iglesia AS i ON(dm.iddistritomisionero=i.iddistritomisionero)
        WHERE ' || in_where || ' LIMIT 1 ) AS s';
	
    EXECUTE sql INTO jerarquia;
		return jerarquia;
END
$$;


ALTER FUNCTION iglesias.fn_mostrar_jerarquia(in_select character varying, in_where character varying, in_idioma_id integer, in_idioma_id_defecto integer) OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 171 (class 1259 OID 33203)
-- Name: actividadmisionera; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.actividadmisionera (
    idactividadmisionera integer NOT NULL,
    descripcion character varying(150) DEFAULT NULL::character varying,
    tipo character varying(20) DEFAULT NULL::character varying
);


ALTER TABLE iglesias.actividadmisionera OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 33208)
-- Name: actividadmisionera_idactividadmisionera_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.actividadmisionera_idactividadmisionera_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.actividadmisionera_idactividadmisionera_seq OWNER TO postgres;

--
-- TOC entry 2657 (class 0 OID 0)
-- Dependencies: 172
-- Name: actividadmisionera_idactividadmisionera_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.actividadmisionera_idactividadmisionera_seq OWNED BY iglesias.actividadmisionera.idactividadmisionera;


--
-- TOC entry 173 (class 1259 OID 33210)
-- Name: capacitacion_miembro; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.capacitacion_miembro (
    idcapacitacion integer NOT NULL,
    idmiembro integer,
    anio integer,
    capacitacion character varying(255),
    centro_estudios character varying(255),
    observaciones_capacitacion text
);


ALTER TABLE iglesias.capacitacion_miembro OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 33216)
-- Name: capacitacion_miembro_idcapacitacion_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.capacitacion_miembro_idcapacitacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.capacitacion_miembro_idcapacitacion_seq OWNER TO postgres;

--
-- TOC entry 2658 (class 0 OID 0)
-- Dependencies: 174
-- Name: capacitacion_miembro_idcapacitacion_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.capacitacion_miembro_idcapacitacion_seq OWNED BY iglesias.capacitacion_miembro.idcapacitacion;


--
-- TOC entry 175 (class 1259 OID 33218)
-- Name: cargo_miembro; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.cargo_miembro (
    idcargomiembro integer NOT NULL,
    idmiembro integer NOT NULL,
    idcargo integer NOT NULL,
    idinstitucion integer,
    observaciones_cargo text,
    vigente character(1) DEFAULT NULL::bpchar,
    periodoini integer,
    periodofin integer,
    idiglesia_cargo integer,
    idnivel smallint,
    idlugar smallint,
    tabla character varying(50),
    lugar character varying(100),
    condicion character(1),
    tiempo character(1)
);


ALTER TABLE iglesias.cargo_miembro OWNER TO postgres;

--
-- TOC entry 2659 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN cargo_miembro.idlugar; Type: COMMENT; Schema: iglesias; Owner: postgres
--

COMMENT ON COLUMN iglesias.cargo_miembro.idlugar IS 'es el id de la jeraquia correspondiente';


--
-- TOC entry 2660 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN cargo_miembro.condicion; Type: COMMENT; Schema: iglesias; Owner: postgres
--

COMMENT ON COLUMN iglesias.cargo_miembro.condicion IS 'R -> remunerado
N -> no remunerado';


--
-- TOC entry 2661 (class 0 OID 0)
-- Dependencies: 175
-- Name: COLUMN cargo_miembro.tiempo; Type: COMMENT; Schema: iglesias; Owner: postgres
--

COMMENT ON COLUMN iglesias.cargo_miembro.tiempo IS 'C -> tiempo completo
P -> tiempo parcial';


--
-- TOC entry 176 (class 1259 OID 33225)
-- Name: cargo_miembro_idcargomiembro_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.cargo_miembro_idcargomiembro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.cargo_miembro_idcargomiembro_seq OWNER TO postgres;

--
-- TOC entry 2662 (class 0 OID 0)
-- Dependencies: 176
-- Name: cargo_miembro_idcargomiembro_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.cargo_miembro_idcargomiembro_seq OWNED BY iglesias.cargo_miembro.idcargomiembro;


--
-- TOC entry 177 (class 1259 OID 33227)
-- Name: categoriaiglesia; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.categoriaiglesia (
    idcategoriaiglesia integer NOT NULL,
    descripcion character varying(30) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE iglesias.categoriaiglesia OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 33231)
-- Name: categoriaiglesia_idcategoriaiglesia_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.categoriaiglesia_idcategoriaiglesia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.categoriaiglesia_idcategoriaiglesia_seq OWNER TO postgres;

--
-- TOC entry 2663 (class 0 OID 0)
-- Dependencies: 178
-- Name: categoriaiglesia_idcategoriaiglesia_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.categoriaiglesia_idcategoriaiglesia_seq OWNED BY iglesias.categoriaiglesia.idcategoriaiglesia;


--
-- TOC entry 179 (class 1259 OID 33233)
-- Name: condicioneclesiastica; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.condicioneclesiastica (
    idcondicioneclesiastica integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE iglesias.condicioneclesiastica OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 33237)
-- Name: condicioneclesiastica_idcondicioneclesiastica_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.condicioneclesiastica_idcondicioneclesiastica_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.condicioneclesiastica_idcondicioneclesiastica_seq OWNER TO postgres;

--
-- TOC entry 2664 (class 0 OID 0)
-- Dependencies: 180
-- Name: condicioneclesiastica_idcondicioneclesiastica_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.condicioneclesiastica_idcondicioneclesiastica_seq OWNED BY iglesias.condicioneclesiastica.idcondicioneclesiastica;


--
-- TOC entry 181 (class 1259 OID 33239)
-- Name: condicioninmueble; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.condicioninmueble (
    idcondicioninmueble integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE iglesias.condicioninmueble OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 33243)
-- Name: condicioninmueble_idcondicioninmueble_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.condicioninmueble_idcondicioninmueble_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.condicioninmueble_idcondicioninmueble_seq OWNER TO postgres;

--
-- TOC entry 2665 (class 0 OID 0)
-- Dependencies: 182
-- Name: condicioninmueble_idcondicioninmueble_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.condicioninmueble_idcondicioninmueble_seq OWNED BY iglesias.condicioninmueble.idcondicioninmueble;


--
-- TOC entry 183 (class 1259 OID 33245)
-- Name: control_traslados; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.control_traslados (
    idcontrol integer NOT NULL,
    idmiembro integer,
    idiglesiaanterior integer,
    idiglesiaactual integer,
    fecha date,
    carta_traslado character varying(100),
    carta_aceptacion character varying(100),
    estado character(1) DEFAULT '1'::bpchar,
    iddivisionactual smallint,
    pais_idactual smallint,
    idunionactual smallint,
    idmisionactual smallint,
    iddistritomisioneroactual smallint
);


ALTER TABLE iglesias.control_traslados OWNER TO postgres;

--
-- TOC entry 2666 (class 0 OID 0)
-- Dependencies: 183
-- Name: COLUMN control_traslados.estado; Type: COMMENT; Schema: iglesias; Owner: postgres
--

COMMENT ON COLUMN iglesias.control_traslados.estado IS '1 -> pendiente

0 -> trasladado

2 -> rechazado';


--
-- TOC entry 184 (class 1259 OID 33249)
-- Name: control_traslados_idcontrol_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.control_traslados_idcontrol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.control_traslados_idcontrol_seq OWNER TO postgres;

--
-- TOC entry 2667 (class 0 OID 0)
-- Dependencies: 184
-- Name: control_traslados_idcontrol_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.control_traslados_idcontrol_seq OWNED BY iglesias.control_traslados.idcontrol;


--
-- TOC entry 185 (class 1259 OID 33251)
-- Name: controlactmisionera; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.controlactmisionera (
    idcontrolactmisionera integer NOT NULL,
    idactividadmisionera integer,
    anio character(4) DEFAULT NULL::bpchar,
    trimestre integer,
    idiglesia integer,
    semana integer,
    valor numeric(6,0) DEFAULT NULL::numeric,
    asistentes numeric(6,0) DEFAULT NULL::numeric,
    interesados numeric(6,0) DEFAULT NULL::numeric,
    mes smallint,
    fecha_inicial date,
    fecha_final date,
    planes text,
    informe_espiritual text,
    iddivision smallint,
    pais_id smallint,
    idunion smallint,
    idmision smallint,
    iddistritomisionero smallint
);


ALTER TABLE iglesias.controlactmisionera OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 33261)
-- Name: controlactmisionera_idcontrolactmisionera_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.controlactmisionera_idcontrolactmisionera_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.controlactmisionera_idcontrolactmisionera_seq OWNER TO postgres;

--
-- TOC entry 2668 (class 0 OID 0)
-- Dependencies: 186
-- Name: controlactmisionera_idcontrolactmisionera_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.controlactmisionera_idcontrolactmisionera_seq OWNED BY iglesias.controlactmisionera.idcontrolactmisionera;


--
-- TOC entry 187 (class 1259 OID 33263)
-- Name: distritomisionero; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.distritomisionero (
    iddistritomisionero integer NOT NULL,
    idmision integer DEFAULT 0 NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying,
    estado character(1) DEFAULT '1'::bpchar NOT NULL
);


ALTER TABLE iglesias.distritomisionero OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 33269)
-- Name: distritomisionero_iddistritomisionero_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.distritomisionero_iddistritomisionero_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.distritomisionero_iddistritomisionero_seq OWNER TO postgres;

--
-- TOC entry 2669 (class 0 OID 0)
-- Dependencies: 188
-- Name: distritomisionero_iddistritomisionero_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.distritomisionero_iddistritomisionero_seq OWNED BY iglesias.distritomisionero.iddistritomisionero;


--
-- TOC entry 189 (class 1259 OID 33271)
-- Name: division; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.division (
    iddivision integer NOT NULL,
    descripcion character varying(50),
    estado character(1)
);


ALTER TABLE iglesias.division OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 33274)
-- Name: division_iddivision_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.division_iddivision_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.division_iddivision_seq OWNER TO postgres;

--
-- TOC entry 2670 (class 0 OID 0)
-- Dependencies: 190
-- Name: division_iddivision_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.division_iddivision_seq OWNED BY iglesias.division.iddivision;


--
-- TOC entry 191 (class 1259 OID 33276)
-- Name: division_idiomas; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.division_idiomas (
    iddivision integer,
    idioma_id integer,
    di_descripcion character varying(100)
);


ALTER TABLE iglesias.division_idiomas OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 33279)
-- Name: educacion_miembro; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.educacion_miembro (
    ideducacionmiembro integer NOT NULL,
    idmiembro integer,
    institucion character varying(255),
    nivelestudios character varying(255),
    profesion character varying(255),
    estado character varying(255),
    observacion text
);


ALTER TABLE iglesias.educacion_miembro OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 33285)
-- Name: educacion_miembro_ideducacionmiembro_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.educacion_miembro_ideducacionmiembro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.educacion_miembro_ideducacionmiembro_seq OWNER TO postgres;

--
-- TOC entry 2671 (class 0 OID 0)
-- Dependencies: 193
-- Name: educacion_miembro_ideducacionmiembro_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.educacion_miembro_ideducacionmiembro_seq OWNED BY iglesias.educacion_miembro.ideducacionmiembro;


--
-- TOC entry 194 (class 1259 OID 33287)
-- Name: eleccion; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.eleccion (
    ideleccion integer NOT NULL,
    fecha date,
    fechaanterior date,
    supervisor character varying(255),
    feligresiaanterior integer,
    feligresiaactual integer,
    delegados integer,
    tiporeunion character(1) NOT NULL,
    comentarios text,
    periodoini smallint,
    periodofin smallint,
    iddivision smallint,
    pais_id smallint,
    idunion smallint,
    idmision smallint,
    iddistritomisionero smallint,
    idiglesia smallint
);


ALTER TABLE iglesias.eleccion OWNER TO postgres;

--
-- TOC entry 2672 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN eleccion.tiporeunion; Type: COMMENT; Schema: iglesias; Owner: postgres
--

COMMENT ON COLUMN iglesias.eleccion.tiporeunion IS 'O -> Reunion Ordinaria
E -> Reunion Extraordinaria';


--
-- TOC entry 195 (class 1259 OID 33293)
-- Name: eleccion_ideleccion_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.eleccion_ideleccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.eleccion_ideleccion_seq OWNER TO postgres;

--
-- TOC entry 2673 (class 0 OID 0)
-- Dependencies: 195
-- Name: eleccion_ideleccion_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.eleccion_ideleccion_seq OWNED BY iglesias.eleccion.ideleccion;


--
-- TOC entry 196 (class 1259 OID 33295)
-- Name: historial_altasybajas; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.historial_altasybajas (
    idhistorial integer NOT NULL,
    idmiembro integer,
    responsable integer,
    fecha date,
    observaciones text,
    alta character(1),
    idmotivobaja integer,
    rebautizo character(1) DEFAULT NULL::bpchar,
    usuario character varying(20) DEFAULT NULL::character varying,
    idcondicioneclesiastica character(1),
    tabla character varying(50)
);


ALTER TABLE iglesias.historial_altasybajas OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 33303)
-- Name: historial_altasybajas_idhistorial_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.historial_altasybajas_idhistorial_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.historial_altasybajas_idhistorial_seq OWNER TO postgres;

--
-- TOC entry 2674 (class 0 OID 0)
-- Dependencies: 197
-- Name: historial_altasybajas_idhistorial_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.historial_altasybajas_idhistorial_seq OWNED BY iglesias.historial_altasybajas.idhistorial;


--
-- TOC entry 198 (class 1259 OID 33305)
-- Name: historial_traslados; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.historial_traslados (
    idtraslado integer NOT NULL,
    idmiembro integer,
    idiglesiaanterior integer,
    idiglesiaactual integer,
    fecha date,
    idcontrol smallint
);


ALTER TABLE iglesias.historial_traslados OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 33308)
-- Name: historial_traslados_idtraslado_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.historial_traslados_idtraslado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.historial_traslados_idtraslado_seq OWNER TO postgres;

--
-- TOC entry 2675 (class 0 OID 0)
-- Dependencies: 199
-- Name: historial_traslados_idtraslado_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.historial_traslados_idtraslado_seq OWNED BY iglesias.historial_traslados.idtraslado;


--
-- TOC entry 200 (class 1259 OID 33310)
-- Name: iglesia; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.iglesia (
    idiglesia integer NOT NULL,
    telefono character varying(100) DEFAULT NULL::character varying,
    descripcion character varying(100) DEFAULT ''::character varying NOT NULL,
    referencia character varying(100) DEFAULT NULL::character varying,
    iddistrito integer,
    idcategoriaiglesia integer DEFAULT 0,
    idtipoconstruccion integer DEFAULT 0,
    idtipodocumentacion integer DEFAULT 0,
    idtipoinmueble integer,
    idcondicioninmueble integer,
    area character varying(50) DEFAULT NULL::character varying,
    direccion text DEFAULT ''::character varying,
    valor character varying(50) DEFAULT NULL::character varying,
    observaciones text,
    estado character(1) DEFAULT '1'::bpchar NOT NULL,
    iddepartamento smallint,
    idprovincia smallint,
    tipoestructura character varying(255),
    documentopropiedad character varying(255),
    iddivision smallint,
    pais_id smallint,
    idunion smallint,
    idmision smallint,
    iddistritomisionero smallint
);


ALTER TABLE iglesias.iglesia OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 33326)
-- Name: iglesia_idiglesia_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.iglesia_idiglesia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.iglesia_idiglesia_seq OWNER TO postgres;

--
-- TOC entry 2676 (class 0 OID 0)
-- Dependencies: 201
-- Name: iglesia_idiglesia_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.iglesia_idiglesia_seq OWNED BY iglesias.iglesia.idiglesia;


--
-- TOC entry 202 (class 1259 OID 33328)
-- Name: institucion; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.institucion (
    idinstitucion integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying,
    sede character varying(50) DEFAULT NULL::character varying,
    "direcci??n" character varying(50) DEFAULT NULL::character varying,
    telefono character varying(50) DEFAULT NULL::character varying,
    email character varying(150) DEFAULT NULL::character varying,
    iddivision smallint,
    pais_id smallint,
    idunion smallint,
    idmision smallint,
    iddistritomisionero smallint,
    idiglesia smallint,
    nombre character varying(255),
    tipo character varying(50)
);


ALTER TABLE iglesias.institucion OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 33339)
-- Name: institucion_idinstitucion_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.institucion_idinstitucion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.institucion_idinstitucion_seq OWNER TO postgres;

--
-- TOC entry 2677 (class 0 OID 0)
-- Dependencies: 203
-- Name: institucion_idinstitucion_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.institucion_idinstitucion_seq OWNED BY iglesias.institucion.idinstitucion;


--
-- TOC entry 204 (class 1259 OID 33341)
-- Name: laboral_miembro; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.laboral_miembro (
    idlaboralmiembro integer NOT NULL,
    idmiembro integer,
    cargo character varying(255),
    sector character varying(255),
    institucionlaboral character varying(255),
    fechainicio date,
    fechafin date,
    periodoini smallint,
    periodofin smallint
);


ALTER TABLE iglesias.laboral_miembro OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 33347)
-- Name: laboral_miembro_idlaboralmiembro_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.laboral_miembro_idlaboralmiembro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.laboral_miembro_idlaboralmiembro_seq OWNER TO postgres;

--
-- TOC entry 2678 (class 0 OID 0)
-- Dependencies: 205
-- Name: laboral_miembro_idlaboralmiembro_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.laboral_miembro_idlaboralmiembro_seq OWNED BY iglesias.laboral_miembro.idlaboralmiembro;


--
-- TOC entry 206 (class 1259 OID 33349)
-- Name: miembro; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.miembro (
    idmiembro integer NOT NULL,
    pais_id_nacionalidad integer DEFAULT 0 NOT NULL,
    iddistritonacimiento integer DEFAULT 0,
    iddistritodomicilio integer,
    idtipodoc integer DEFAULT 0 NOT NULL,
    idestadocivil integer DEFAULT 0 NOT NULL,
    idocupacion integer DEFAULT 0 NOT NULL,
    idgradoinstruccion integer DEFAULT 0 NOT NULL,
    paterno character varying(50) DEFAULT ''::character varying,
    materno character varying(50) DEFAULT NULL::character varying,
    nombres character varying(50) DEFAULT ''::character varying NOT NULL,
    foto character varying(50) DEFAULT NULL::character varying,
    fechanacimiento date NOT NULL,
    lugarnacimiento character varying(30) DEFAULT ''::character varying,
    sexo character(1) DEFAULT ''::bpchar NOT NULL,
    nrodoc character varying(20) DEFAULT ''::character varying NOT NULL,
    direccion character varying(80) DEFAULT NULL::character varying,
    referenciadireccion character varying(100) DEFAULT NULL::character varying,
    telefono character varying(20) DEFAULT NULL::character varying,
    celular character varying(20) DEFAULT NULL::character varying,
    email character varying(100) DEFAULT NULL::character varying,
    emailalternativo character varying(100) DEFAULT NULL::character varying,
    idreligion integer DEFAULT 0,
    fechabautizo date,
    idcondicioneclesiastica integer,
    encargado_recibimiento character varying(6) DEFAULT NULL::character varying,
    observaciones text,
    estado character(1) DEFAULT '1'::bpchar,
    estadoeliminado character(1) DEFAULT '0'::bpchar,
    idiglesia integer,
    fechaingresoiglesia date,
    fecharegistro timestamp without time zone,
    tipolugarnac character varying(10),
    ciudadnacextranjero character varying(80),
    apellidos character varying(100),
    iddepartamentodomicilio smallint,
    idprovinciadomicilio smallint,
    iddepartamentonacimiento smallint,
    idprovincianacimiento smallint,
    apellido_soltera character varying(100),
    pais_id_nacimiento smallint,
    iddivision smallint,
    pais_id smallint,
    idunion smallint,
    idmision smallint,
    iddistritomisionero smallint,
    tabla_encargado_bautizo character varying(50),
    encargado_bautizo smallint,
    observaciones_bautizo text,
    idiomas character varying(255),
    texto_bautismal character varying(255),
    pais_id_domicilio integer
);


ALTER TABLE iglesias.miembro OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 33378)
-- Name: miembro_idmiembro_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.miembro_idmiembro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.miembro_idmiembro_seq OWNER TO postgres;

--
-- TOC entry 2679 (class 0 OID 0)
-- Dependencies: 207
-- Name: miembro_idmiembro_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.miembro_idmiembro_seq OWNED BY iglesias.miembro.idmiembro;


--
-- TOC entry 208 (class 1259 OID 33380)
-- Name: mision; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.mision (
    idmision integer NOT NULL,
    idunion integer,
    descripcion character varying(60) DEFAULT ''::character varying,
    direccion character varying(200) DEFAULT NULL::character varying,
    estado character(1) DEFAULT '1'::bpchar,
    telefono character varying(80),
    email character varying(200),
    fax character varying(200)
);


ALTER TABLE iglesias.mision OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 33389)
-- Name: mision_idmision_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.mision_idmision_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.mision_idmision_seq OWNER TO postgres;

--
-- TOC entry 2680 (class 0 OID 0)
-- Dependencies: 209
-- Name: mision_idmision_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.mision_idmision_seq OWNED BY iglesias.mision.idmision;


--
-- TOC entry 210 (class 1259 OID 33391)
-- Name: motivobaja; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.motivobaja (
    idmotivobaja integer NOT NULL,
    descripcion character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE iglesias.motivobaja OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 33395)
-- Name: motivobaja_idmotivobaja_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.motivobaja_idmotivobaja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.motivobaja_idmotivobaja_seq OWNER TO postgres;

--
-- TOC entry 2681 (class 0 OID 0)
-- Dependencies: 211
-- Name: motivobaja_idmotivobaja_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.motivobaja_idmotivobaja_seq OWNED BY iglesias.motivobaja.idmotivobaja;


--
-- TOC entry 212 (class 1259 OID 33397)
-- Name: otras_propiedades; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.otras_propiedades (
    idotrapropiedad integer NOT NULL,
    descripcion character varying(255),
    cantidad integer,
    tipo character varying(50),
    iddivision integer,
    pais_id integer,
    idunion integer,
    idmision integer,
    iddistritomisionero integer,
    idiglesia integer
);


ALTER TABLE iglesias.otras_propiedades OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 33400)
-- Name: otras_propiedades_ idotrapropiedad_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias."otras_propiedades_ idotrapropiedad_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias."otras_propiedades_ idotrapropiedad_seq" OWNER TO postgres;

--
-- TOC entry 2682 (class 0 OID 0)
-- Dependencies: 213
-- Name: otras_propiedades_ idotrapropiedad_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias."otras_propiedades_ idotrapropiedad_seq" OWNED BY iglesias.otras_propiedades.idotrapropiedad;


--
-- TOC entry 214 (class 1259 OID 33402)
-- Name: otrospastores; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.otrospastores (
    idotrospastores integer NOT NULL,
    idcargo integer,
    nombrecompleto character varying(200) DEFAULT NULL::character varying,
    observaciones text,
    periodo character varying(20) DEFAULT NULL::character varying,
    vigente character(1) DEFAULT NULL::bpchar,
    estado character(1) DEFAULT '1'::bpchar,
    idtipodoc integer,
    nrodoc character varying(20)
);


ALTER TABLE iglesias.otrospastores OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 33412)
-- Name: otrospastores_idotrospastores_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.otrospastores_idotrospastores_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.otrospastores_idotrospastores_seq OWNER TO postgres;

--
-- TOC entry 2683 (class 0 OID 0)
-- Dependencies: 215
-- Name: otrospastores_idotrospastores_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.otrospastores_idotrospastores_seq OWNED BY iglesias.otrospastores.idotrospastores;


--
-- TOC entry 216 (class 1259 OID 33414)
-- Name: paises; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.paises (
    pais_id integer NOT NULL,
    pais_descripcion character varying(100),
    estado character(1) DEFAULT 'A'::bpchar,
    idioma_id smallint,
    iddivision smallint,
    direccion character varying(100),
    telefono character varying(50),
    posee_union character(1) DEFAULT 'S'::bpchar
);


ALTER TABLE iglesias.paises OWNER TO postgres;

--
-- TOC entry 2684 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN paises.posee_union; Type: COMMENT; Schema: iglesias; Owner: postgres
--

COMMENT ON COLUMN iglesias.paises.posee_union IS 'S -> si posee union

N -> no posee union';


--
-- TOC entry 217 (class 1259 OID 33419)
-- Name: paises_idiomas; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.paises_idiomas (
    pais_id integer,
    idioma_id integer,
    pai_descripcion character varying(100)
);


ALTER TABLE iglesias.paises_idiomas OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 33422)
-- Name: paises_jerarquia; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.paises_jerarquia (
    pj_id integer NOT NULL,
    pais_id integer,
    pj_descripcion character varying(100),
    pj_item smallint
);


ALTER TABLE iglesias.paises_jerarquia OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 33425)
-- Name: paises_jerarquia_pj_id_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.paises_jerarquia_pj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.paises_jerarquia_pj_id_seq OWNER TO postgres;

--
-- TOC entry 2685 (class 0 OID 0)
-- Dependencies: 219
-- Name: paises_jerarquia_pj_id_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.paises_jerarquia_pj_id_seq OWNED BY iglesias.paises_jerarquia.pj_id;


--
-- TOC entry 220 (class 1259 OID 33427)
-- Name: paises_pais_id_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.paises_pais_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.paises_pais_id_seq OWNER TO postgres;

--
-- TOC entry 2686 (class 0 OID 0)
-- Dependencies: 220
-- Name: paises_pais_id_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.paises_pais_id_seq OWNED BY iglesias.paises.pais_id;


--
-- TOC entry 221 (class 1259 OID 33429)
-- Name: parentesco_miembro; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.parentesco_miembro (
    idparentescomiembro integer NOT NULL,
    idmiembro integer,
    idparentesco integer,
    idpais integer,
    nombres character varying(255),
    idtipodoc integer,
    nrodoc character varying(20),
    fechanacimiento date,
    lugarnacimiento character varying(255)
);


ALTER TABLE iglesias.parentesco_miembro OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 33435)
-- Name: parentesco_miembro_idparentescomiembro_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.parentesco_miembro_idparentescomiembro_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.parentesco_miembro_idparentescomiembro_seq OWNER TO postgres;

--
-- TOC entry 2687 (class 0 OID 0)
-- Dependencies: 222
-- Name: parentesco_miembro_idparentescomiembro_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.parentesco_miembro_idparentescomiembro_seq OWNED BY iglesias.parentesco_miembro.idparentescomiembro;


--
-- TOC entry 223 (class 1259 OID 33437)
-- Name: religion; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.religion (
    idreligion integer NOT NULL,
    descripcion character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE iglesias.religion OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 33441)
-- Name: religion_idreligion_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.religion_idreligion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.religion_idreligion_seq OWNER TO postgres;

--
-- TOC entry 2688 (class 0 OID 0)
-- Dependencies: 224
-- Name: religion_idreligion_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.religion_idreligion_seq OWNED BY iglesias.religion.idreligion;


--
-- TOC entry 225 (class 1259 OID 33443)
-- Name: temp_traslados; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.temp_traslados (
    idtemptraslados integer NOT NULL,
    idmiembro integer NOT NULL,
    idtipodoc integer NOT NULL,
    iddivision integer NOT NULL,
    pais_id integer NOT NULL,
    idunion integer NOT NULL,
    idmision integer NOT NULL,
    iddistritomisionero integer NOT NULL,
    idiglesia integer NOT NULL,
    nrodoc character varying(20) NOT NULL,
    division character varying(100),
    pais character varying(100),
    "union" character varying(100),
    mision character varying(100),
    distritomisionero character varying(100),
    iglesia character varying(100),
    tipo_documento character varying(50),
    usuario_id smallint,
    tipo_traslado integer NOT NULL,
    iddivisiondestino smallint,
    pais_iddestino smallint,
    iduniondestino smallint,
    idmisiondestino smallint,
    iddistritomisionerodestino smallint,
    idiglesiadestino smallint,
    asociado character varying(255)
);


ALTER TABLE iglesias.temp_traslados OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33449)
-- Name: temp_traslados_idtemptraslados_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.temp_traslados_idtemptraslados_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.temp_traslados_idtemptraslados_seq OWNER TO postgres;

--
-- TOC entry 2689 (class 0 OID 0)
-- Dependencies: 226
-- Name: temp_traslados_idtemptraslados_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.temp_traslados_idtemptraslados_seq OWNED BY iglesias.temp_traslados.idtemptraslados;


--
-- TOC entry 227 (class 1259 OID 33451)
-- Name: union; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias."union" (
    idunion integer NOT NULL,
    descripcion character varying(50),
    estado character(1) DEFAULT '1'::bpchar,
    direccion character varying(200),
    telefono character varying(200),
    email character varying(200),
    fax character varying(200)
);


ALTER TABLE iglesias."union" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 33458)
-- Name: union_idunion_seq; Type: SEQUENCE; Schema: iglesias; Owner: postgres
--

CREATE SEQUENCE iglesias.union_idunion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE iglesias.union_idunion_seq OWNER TO postgres;

--
-- TOC entry 2690 (class 0 OID 0)
-- Dependencies: 228
-- Name: union_idunion_seq; Type: SEQUENCE OWNED BY; Schema: iglesias; Owner: postgres
--

ALTER SEQUENCE iglesias.union_idunion_seq OWNED BY iglesias."union".idunion;


--
-- TOC entry 229 (class 1259 OID 33460)
-- Name: union_paises; Type: TABLE; Schema: iglesias; Owner: postgres
--

CREATE TABLE iglesias.union_paises (
    idunion integer,
    pais_id integer
);


ALTER TABLE iglesias.union_paises OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33463)
-- Name: tipodoc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipodoc (
    idtipodoc integer NOT NULL,
    descripcion character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tipodoc OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33467)
-- Name: vista_asociados_traslados; Type: VIEW; Schema: iglesias; Owner: postgres
--

CREATE VIEW iglesias.vista_asociados_traslados AS
SELECT m.idmiembro, (((m.apellidos)::text || ', '::text) || (m.nombres)::text) AS asociado, m.idtipodoc, m.nrodoc, d.descripcion AS division, p.pais_descripcion AS pais, u.descripcion AS "union", mi.descripcion AS mision, dm.descripcion AS distritomisionero, i.descripcion AS iglesia, td.descripcion AS tipo_documento, m.iddivision, m.pais_id, m.idunion, m.idmision, m.iddistritomisionero, m.idiglesia FROM (((((((iglesias.miembro m JOIN iglesias.division d ON ((m.iddivision = d.iddivision))) JOIN iglesias.paises p ON ((m.pais_id = p.pais_id))) JOIN iglesias."union" u ON ((m.idunion = u.idunion))) JOIN iglesias.mision mi ON ((m.idmision = mi.idmision))) JOIN iglesias.distritomisionero dm ON ((m.iddistritomisionero = dm.iddistritomisionero))) JOIN iglesias.iglesia i ON ((m.idiglesia = i.idiglesia))) JOIN public.tipodoc td ON ((td.idtipodoc = m.idtipodoc)));


ALTER TABLE iglesias.vista_asociados_traslados OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 33472)
-- Name: vista_jerarquia; Type: VIEW; Schema: iglesias; Owner: postgres
--

CREATE VIEW iglesias.vista_jerarquia AS
SELECT d.descripcion AS division, p.pais_descripcion AS pais, u.descripcion AS "union", mi.descripcion AS mision, dm.descripcion AS distritomisionero, i.descripcion AS iglesia, d.iddivision, p.pais_id, u.idunion, mi.idmision, dm.iddistritomisionero, i.idiglesia FROM ((((((iglesias.division d JOIN iglesias.paises p ON ((d.iddivision = p.iddivision))) JOIN iglesias.union_paises up ON ((up.pais_id = p.pais_id))) JOIN iglesias."union" u ON ((up.idunion = u.idunion))) JOIN iglesias.mision mi ON ((u.idunion = mi.idunion))) JOIN iglesias.distritomisionero dm ON ((mi.idmision = dm.idmision))) JOIN iglesias.iglesia i ON ((dm.iddistritomisionero = i.iddistritomisionero)));


ALTER TABLE iglesias.vista_jerarquia OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 33477)
-- Name: cargo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cargo (
    idcargo integer NOT NULL,
    descripcion character varying(255) DEFAULT NULL::character varying,
    idtipocargo integer,
    estado character(1) DEFAULT NULL::bpchar,
    idnivel smallint
);


ALTER TABLE public.cargo OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 33482)
-- Name: vista_responsables; Type: VIEW; Schema: iglesias; Owner: postgres
--

CREATE VIEW iglesias.vista_responsables AS
SELECT m.idmiembro AS id, (((m.apellidos)::text || ', '::text) || (m.nombres)::text) AS nombres, 'iglesias.miembro'::text AS tabla, td.descripcion AS tipo_documento, m.nrodoc FROM (iglesias.miembro m JOIN public.tipodoc td ON ((td.idtipodoc = m.idtipodoc))) WHERE (m.idmiembro IN (SELECT cargo_miembro.idmiembro FROM iglesias.cargo_miembro WHERE (cargo_miembro.idcargo IS NOT NULL))) UNION ALL SELECT ot.idotrospastores AS id, ot.nombrecompleto AS nombres, 'iglesias.otrospastores'::text AS tabla, td.descripcion AS tipo_documento, ot.nrodoc FROM ((iglesias.otrospastores ot JOIN public.cargo c ON ((c.idcargo = ot.idcargo))) JOIN public.tipodoc td ON ((td.idtipodoc = ot.idtipodoc))) WHERE (ot.idcargo IS NOT NULL);


ALTER TABLE iglesias.vista_responsables OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 33487)
-- Name: cargo_idcargo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cargo_idcargo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cargo_idcargo_seq OWNER TO postgres;

--
-- TOC entry 2691 (class 0 OID 0)
-- Dependencies: 235
-- Name: cargo_idcargo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cargo_idcargo_seq OWNED BY public.cargo.idcargo;


--
-- TOC entry 236 (class 1259 OID 33489)
-- Name: condicioninmueble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.condicioninmueble (
    idcondicioninmueble integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.condicioninmueble OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 33493)
-- Name: condicioninmueble_idcondicioninmueble_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.condicioninmueble_idcondicioninmueble_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.condicioninmueble_idcondicioninmueble_seq OWNER TO postgres;

--
-- TOC entry 2692 (class 0 OID 0)
-- Dependencies: 237
-- Name: condicioninmueble_idcondicioninmueble_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.condicioninmueble_idcondicioninmueble_seq OWNED BY public.condicioninmueble.idcondicioninmueble;


--
-- TOC entry 238 (class 1259 OID 33495)
-- Name: departamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departamento (
    iddepartamento integer NOT NULL,
    descripcion text DEFAULT ''::character varying NOT NULL,
    pais_id integer
);


ALTER TABLE public.departamento OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 33502)
-- Name: departamento_iddepartamento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departamento_iddepartamento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departamento_iddepartamento_seq OWNER TO postgres;

--
-- TOC entry 2693 (class 0 OID 0)
-- Dependencies: 239
-- Name: departamento_iddepartamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departamento_iddepartamento_seq OWNED BY public.departamento.iddepartamento;


--
-- TOC entry 240 (class 1259 OID 33504)
-- Name: distrito; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.distrito (
    iddistrito integer NOT NULL,
    idprovincia integer DEFAULT 0 NOT NULL,
    descripcion text DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.distrito OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 33512)
-- Name: distrito_iddistrito_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.distrito_iddistrito_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.distrito_iddistrito_seq OWNER TO postgres;

--
-- TOC entry 2694 (class 0 OID 0)
-- Dependencies: 241
-- Name: distrito_iddistrito_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.distrito_iddistrito_seq OWNED BY public.distrito.iddistrito;


--
-- TOC entry 242 (class 1259 OID 33514)
-- Name: estadocivil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estadocivil (
    idestadocivil integer NOT NULL,
    descripcion character varying(30) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.estadocivil OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 33518)
-- Name: estadocivil_idestadocivil_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estadocivil_idestadocivil_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estadocivil_idestadocivil_seq OWNER TO postgres;

--
-- TOC entry 2695 (class 0 OID 0)
-- Dependencies: 243
-- Name: estadocivil_idestadocivil_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estadocivil_idestadocivil_seq OWNED BY public.estadocivil.idestadocivil;


--
-- TOC entry 244 (class 1259 OID 33520)
-- Name: gradoinstruccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gradoinstruccion (
    idgradoinstruccion integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.gradoinstruccion OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 33524)
-- Name: gradoinstruccion_idgradoinstruccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gradoinstruccion_idgradoinstruccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gradoinstruccion_idgradoinstruccion_seq OWNER TO postgres;

--
-- TOC entry 2696 (class 0 OID 0)
-- Dependencies: 245
-- Name: gradoinstruccion_idgradoinstruccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gradoinstruccion_idgradoinstruccion_seq OWNED BY public.gradoinstruccion.idgradoinstruccion;


--
-- TOC entry 246 (class 1259 OID 33526)
-- Name: idiomas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idiomas (
    idioma_id integer NOT NULL,
    idioma_codigo character(10),
    idioma_descripcion character varying(50),
    estado character(1) DEFAULT 'A'::bpchar,
    por_defecto character(1) DEFAULT 'N'::bpchar
);


ALTER TABLE public.idiomas OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 33531)
-- Name: idiomas_idioma_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.idiomas_idioma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.idiomas_idioma_id_seq OWNER TO postgres;

--
-- TOC entry 2697 (class 0 OID 0)
-- Dependencies: 247
-- Name: idiomas_idioma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.idiomas_idioma_id_seq OWNED BY public.idiomas.idioma_id;


--
-- TOC entry 248 (class 1259 OID 33533)
-- Name: nivel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nivel (
    idnivel integer NOT NULL,
    descripcion character varying(50),
    estado character(1) DEFAULT '1'::bpchar,
    idtipocargo smallint
);


ALTER TABLE public.nivel OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 33537)
-- Name: nivel_idnivel_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nivel_idnivel_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nivel_idnivel_seq OWNER TO postgres;

--
-- TOC entry 2698 (class 0 OID 0)
-- Dependencies: 249
-- Name: nivel_idnivel_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nivel_idnivel_seq OWNED BY public.nivel.idnivel;


--
-- TOC entry 250 (class 1259 OID 33539)
-- Name: ocupacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ocupacion (
    idocupacion integer NOT NULL,
    descripcion character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.ocupacion OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 33543)
-- Name: ocupacion_idocupacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ocupacion_idocupacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ocupacion_idocupacion_seq OWNER TO postgres;

--
-- TOC entry 2699 (class 0 OID 0)
-- Dependencies: 251
-- Name: ocupacion_idocupacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ocupacion_idocupacion_seq OWNED BY public.ocupacion.idocupacion;


--
-- TOC entry 252 (class 1259 OID 33545)
-- Name: pais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pais (
    idpais integer NOT NULL,
    descripcion character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.pais OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 33549)
-- Name: pais_idpais_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pais_idpais_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pais_idpais_seq OWNER TO postgres;

--
-- TOC entry 2700 (class 0 OID 0)
-- Dependencies: 253
-- Name: pais_idpais_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pais_idpais_seq OWNED BY public.pais.idpais;


--
-- TOC entry 254 (class 1259 OID 33551)
-- Name: parentesco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parentesco (
    idparentesco integer NOT NULL,
    descripcion character varying(100),
    estado character(1) DEFAULT '1'::bpchar
);


ALTER TABLE public.parentesco OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 33555)
-- Name: parentesco_idparentesco_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parentesco_idparentesco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parentesco_idparentesco_seq OWNER TO postgres;

--
-- TOC entry 2701 (class 0 OID 0)
-- Dependencies: 255
-- Name: parentesco_idparentesco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parentesco_idparentesco_seq OWNED BY public.parentesco.idparentesco;


--
-- TOC entry 256 (class 1259 OID 33557)
-- Name: procesos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procesos (
    proceso_id integer NOT NULL,
    proceso_total_elementos_procesar integer,
    proceso_numero_elementos_procesados integer,
    proceso_porcentaje_actual_progreso double precision,
    proceso_fecha_comienzo timestamp without time zone,
    proceso_fecha_actualizacion timestamp without time zone,
    proceso_tiempo_transcurrido character varying(200)
);


ALTER TABLE public.procesos OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 33560)
-- Name: procesos_proceso_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procesos_proceso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procesos_proceso_id_seq OWNER TO postgres;

--
-- TOC entry 2702 (class 0 OID 0)
-- Dependencies: 257
-- Name: procesos_proceso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.procesos_proceso_id_seq OWNED BY public.procesos.proceso_id;


--
-- TOC entry 258 (class 1259 OID 33562)
-- Name: provincia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provincia (
    idprovincia integer NOT NULL,
    iddepartamento integer DEFAULT 0 NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.provincia OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 33569)
-- Name: provincia_idprovincia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.provincia_idprovincia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.provincia_idprovincia_seq OWNER TO postgres;

--
-- TOC entry 2703 (class 0 OID 0)
-- Dependencies: 259
-- Name: provincia_idprovincia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.provincia_idprovincia_seq OWNED BY public.provincia.idprovincia;


--
-- TOC entry 260 (class 1259 OID 33571)
-- Name: tipocargo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipocargo (
    idtipocargo integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying,
    posee_nivel character(1) DEFAULT 'N'::bpchar
);


ALTER TABLE public.tipocargo OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 33576)
-- Name: tipocargo_idtipocargo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipocargo_idtipocargo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipocargo_idtipocargo_seq OWNER TO postgres;

--
-- TOC entry 2704 (class 0 OID 0)
-- Dependencies: 261
-- Name: tipocargo_idtipocargo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipocargo_idtipocargo_seq OWNED BY public.tipocargo.idtipocargo;


--
-- TOC entry 262 (class 1259 OID 33578)
-- Name: tipoconstruccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipoconstruccion (
    idtipoconstruccion integer NOT NULL,
    descripcion character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tipoconstruccion OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 33582)
-- Name: tipoconstruccion_idtipoconstruccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipoconstruccion_idtipoconstruccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipoconstruccion_idtipoconstruccion_seq OWNER TO postgres;

--
-- TOC entry 2705 (class 0 OID 0)
-- Dependencies: 263
-- Name: tipoconstruccion_idtipoconstruccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipoconstruccion_idtipoconstruccion_seq OWNED BY public.tipoconstruccion.idtipoconstruccion;


--
-- TOC entry 264 (class 1259 OID 33584)
-- Name: tipodoc_idtipodoc_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipodoc_idtipodoc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipodoc_idtipodoc_seq OWNER TO postgres;

--
-- TOC entry 2706 (class 0 OID 0)
-- Dependencies: 264
-- Name: tipodoc_idtipodoc_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipodoc_idtipodoc_seq OWNED BY public.tipodoc.idtipodoc;


--
-- TOC entry 265 (class 1259 OID 33586)
-- Name: tipodocumentacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipodocumentacion (
    idtipodocumentacion integer NOT NULL,
    descripcion character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tipodocumentacion OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 33590)
-- Name: tipodocumentacion_idtipodocumentacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipodocumentacion_idtipodocumentacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipodocumentacion_idtipodocumentacion_seq OWNER TO postgres;

--
-- TOC entry 2707 (class 0 OID 0)
-- Dependencies: 266
-- Name: tipodocumentacion_idtipodocumentacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipodocumentacion_idtipodocumentacion_seq OWNED BY public.tipodocumentacion.idtipodocumentacion;


--
-- TOC entry 267 (class 1259 OID 33592)
-- Name: tipoinmueble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipoinmueble (
    idtipoinmueble integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE public.tipoinmueble OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 33596)
-- Name: tipoinmueble_idtipoinmueble_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipoinmueble_idtipoinmueble_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipoinmueble_idtipoinmueble_seq OWNER TO postgres;

--
-- TOC entry 2708 (class 0 OID 0)
-- Dependencies: 268
-- Name: tipoinmueble_idtipoinmueble_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipoinmueble_idtipoinmueble_seq OWNED BY public.tipoinmueble.idtipoinmueble;


--
-- TOC entry 269 (class 1259 OID 33598)
-- Name: trimestre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trimestre (
    idtrimestre integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying,
    fechainicial character varying(5) DEFAULT NULL::character varying,
    fechafinal character varying(5) DEFAULT NULL::character varying,
    nrosemanas integer
);


ALTER TABLE public.trimestre OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 33604)
-- Name: trimestre_idtrimestre_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trimestre_idtrimestre_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trimestre_idtrimestre_seq OWNER TO postgres;

--
-- TOC entry 2709 (class 0 OID 0)
-- Dependencies: 270
-- Name: trimestre_idtrimestre_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trimestre_idtrimestre_seq OWNED BY public.trimestre.idtrimestre;


--
-- TOC entry 271 (class 1259 OID 33606)
-- Name: vista_division_politica; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vista_division_politica AS
SELECT d.descripcion AS departamento, p.descripcion AS provincia, dd.descripcion AS distrito, d.iddepartamento, p.idprovincia, dd.iddistrito FROM ((public.departamento d LEFT JOIN public.provincia p ON ((d.iddepartamento = p.iddepartamento))) LEFT JOIN public.distrito dd ON ((dd.idprovincia = p.idprovincia)));


ALTER TABLE public.vista_division_politica OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 33610)
-- Name: log_sistema; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.log_sistema (
    idlog integer NOT NULL,
    mensaje character varying(250) DEFAULT NULL::character varying,
    fecha timestamp without time zone,
    usuario character varying(20) DEFAULT NULL::character varying,
    nombres character varying(150) DEFAULT NULL::character varying,
    idperfil integer,
    idreferencia integer,
    ip character varying(50),
    operacion character varying(50),
    tabla character varying(50)
);


ALTER TABLE seguridad.log_sistema OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 33619)
-- Name: log_sistema_idlog_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.log_sistema_idlog_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.log_sistema_idlog_seq OWNER TO postgres;

--
-- TOC entry 2710 (class 0 OID 0)
-- Dependencies: 273
-- Name: log_sistema_idlog_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.log_sistema_idlog_seq OWNED BY seguridad.log_sistema.idlog;


--
-- TOC entry 274 (class 1259 OID 33621)
-- Name: modulos; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.modulos (
    modulo_id integer NOT NULL,
    modulo_nombre character varying(50),
    modulo_icono character varying(50),
    modulo_controlador character varying(50),
    modulo_padre integer,
    modulo_orden integer,
    modulo_route character varying(50),
    estado character(1) DEFAULT 'A'::bpchar
);


ALTER TABLE seguridad.modulos OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 33625)
-- Name: modulos_idiomas; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.modulos_idiomas (
    modulo_id integer,
    idioma_id integer,
    mi_descripcion character varying(100)
);


ALTER TABLE seguridad.modulos_idiomas OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 33628)
-- Name: modulos_modulo_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.modulos_modulo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.modulos_modulo_id_seq OWNER TO postgres;

--
-- TOC entry 2711 (class 0 OID 0)
-- Dependencies: 276
-- Name: modulos_modulo_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.modulos_modulo_id_seq OWNED BY seguridad.modulos.modulo_id;


--
-- TOC entry 277 (class 1259 OID 33630)
-- Name: perfiles; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.perfiles (
    perfil_id integer NOT NULL,
    perfil_descripcion character varying(50),
    estado character(1) DEFAULT 'A'::bpchar
);


ALTER TABLE seguridad.perfiles OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 33634)
-- Name: perfiles_idiomas; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.perfiles_idiomas (
    perfil_id integer,
    idioma_id integer,
    pi_descripcion character varying(100)
);


ALTER TABLE seguridad.perfiles_idiomas OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 33637)
-- Name: perfiles_perfil_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.perfiles_perfil_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.perfiles_perfil_id_seq OWNER TO postgres;

--
-- TOC entry 2712 (class 0 OID 0)
-- Dependencies: 279
-- Name: perfiles_perfil_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.perfiles_perfil_id_seq OWNED BY seguridad.perfiles.perfil_id;


--
-- TOC entry 280 (class 1259 OID 33639)
-- Name: permisos; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.permisos (
    perfil_id integer NOT NULL,
    modulo_id integer NOT NULL
);


ALTER TABLE seguridad.permisos OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 33642)
-- Name: tipoacceso; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.tipoacceso (
    idtipoacceso integer NOT NULL,
    descripcion character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE seguridad.tipoacceso OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 33646)
-- Name: tipoacceso_idtipoacceso_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.tipoacceso_idtipoacceso_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.tipoacceso_idtipoacceso_seq OWNER TO postgres;

--
-- TOC entry 2713 (class 0 OID 0)
-- Dependencies: 282
-- Name: tipoacceso_idtipoacceso_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.tipoacceso_idtipoacceso_seq OWNED BY seguridad.tipoacceso.idtipoacceso;


--
-- TOC entry 283 (class 1259 OID 33648)
-- Name: usuarios; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.usuarios (
    usuario_id integer NOT NULL,
    usuario_user character varying(50),
    usuario_pass character varying(200),
    usuario_nombres character varying(100),
    usuario_referencia text,
    perfil_id integer,
    estado character(1) DEFAULT 'A'::bpchar,
    idmiembro smallint,
    idtipoacceso smallint
);


ALTER TABLE seguridad.usuarios OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 33655)
-- Name: usuarios_usuario_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.usuarios_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.usuarios_usuario_id_seq OWNER TO postgres;

--
-- TOC entry 2714 (class 0 OID 0)
-- Dependencies: 284
-- Name: usuarios_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.usuarios_usuario_id_seq OWNED BY seguridad.usuarios.usuario_id;


--
-- TOC entry 2181 (class 2604 OID 33657)
-- Name: actividadmisionera idactividadmisionera; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.actividadmisionera ALTER COLUMN idactividadmisionera SET DEFAULT nextval('iglesias.actividadmisionera_idactividadmisionera_seq'::regclass);


--
-- TOC entry 2182 (class 2604 OID 33658)
-- Name: capacitacion_miembro idcapacitacion; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.capacitacion_miembro ALTER COLUMN idcapacitacion SET DEFAULT nextval('iglesias.capacitacion_miembro_idcapacitacion_seq'::regclass);


--
-- TOC entry 2184 (class 2604 OID 33659)
-- Name: cargo_miembro idcargomiembro; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.cargo_miembro ALTER COLUMN idcargomiembro SET DEFAULT nextval('iglesias.cargo_miembro_idcargomiembro_seq'::regclass);


--
-- TOC entry 2186 (class 2604 OID 33660)
-- Name: categoriaiglesia idcategoriaiglesia; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.categoriaiglesia ALTER COLUMN idcategoriaiglesia SET DEFAULT nextval('iglesias.categoriaiglesia_idcategoriaiglesia_seq'::regclass);


--
-- TOC entry 2188 (class 2604 OID 33661)
-- Name: condicioneclesiastica idcondicioneclesiastica; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.condicioneclesiastica ALTER COLUMN idcondicioneclesiastica SET DEFAULT nextval('iglesias.condicioneclesiastica_idcondicioneclesiastica_seq'::regclass);


--
-- TOC entry 2190 (class 2604 OID 33662)
-- Name: condicioninmueble idcondicioninmueble; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.condicioninmueble ALTER COLUMN idcondicioninmueble SET DEFAULT nextval('iglesias.condicioninmueble_idcondicioninmueble_seq'::regclass);


--
-- TOC entry 2192 (class 2604 OID 33663)
-- Name: control_traslados idcontrol; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.control_traslados ALTER COLUMN idcontrol SET DEFAULT nextval('iglesias.control_traslados_idcontrol_seq'::regclass);


--
-- TOC entry 2197 (class 2604 OID 33664)
-- Name: controlactmisionera idcontrolactmisionera; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.controlactmisionera ALTER COLUMN idcontrolactmisionera SET DEFAULT nextval('iglesias.controlactmisionera_idcontrolactmisionera_seq'::regclass);


--
-- TOC entry 2201 (class 2604 OID 33665)
-- Name: distritomisionero iddistritomisionero; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.distritomisionero ALTER COLUMN iddistritomisionero SET DEFAULT nextval('iglesias.distritomisionero_iddistritomisionero_seq'::regclass);


--
-- TOC entry 2202 (class 2604 OID 33666)
-- Name: division iddivision; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.division ALTER COLUMN iddivision SET DEFAULT nextval('iglesias.division_iddivision_seq'::regclass);


--
-- TOC entry 2203 (class 2604 OID 33667)
-- Name: educacion_miembro ideducacionmiembro; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.educacion_miembro ALTER COLUMN ideducacionmiembro SET DEFAULT nextval('iglesias.educacion_miembro_ideducacionmiembro_seq'::regclass);


--
-- TOC entry 2204 (class 2604 OID 33668)
-- Name: eleccion ideleccion; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.eleccion ALTER COLUMN ideleccion SET DEFAULT nextval('iglesias.eleccion_ideleccion_seq'::regclass);


--
-- TOC entry 2207 (class 2604 OID 33669)
-- Name: historial_altasybajas idhistorial; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.historial_altasybajas ALTER COLUMN idhistorial SET DEFAULT nextval('iglesias.historial_altasybajas_idhistorial_seq'::regclass);


--
-- TOC entry 2208 (class 2604 OID 33670)
-- Name: historial_traslados idtraslado; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.historial_traslados ALTER COLUMN idtraslado SET DEFAULT nextval('iglesias.historial_traslados_idtraslado_seq'::regclass);


--
-- TOC entry 2219 (class 2604 OID 33671)
-- Name: iglesia idiglesia; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.iglesia ALTER COLUMN idiglesia SET DEFAULT nextval('iglesias.iglesia_idiglesia_seq'::regclass);


--
-- TOC entry 2225 (class 2604 OID 33672)
-- Name: institucion idinstitucion; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.institucion ALTER COLUMN idinstitucion SET DEFAULT nextval('iglesias.institucion_idinstitucion_seq'::regclass);


--
-- TOC entry 2226 (class 2604 OID 33673)
-- Name: laboral_miembro idlaboralmiembro; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.laboral_miembro ALTER COLUMN idlaboralmiembro SET DEFAULT nextval('iglesias.laboral_miembro_idlaboralmiembro_seq'::regclass);


--
-- TOC entry 2250 (class 2604 OID 33674)
-- Name: miembro idmiembro; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.miembro ALTER COLUMN idmiembro SET DEFAULT nextval('iglesias.miembro_idmiembro_seq'::regclass);


--
-- TOC entry 2254 (class 2604 OID 33675)
-- Name: mision idmision; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.mision ALTER COLUMN idmision SET DEFAULT nextval('iglesias.mision_idmision_seq'::regclass);


--
-- TOC entry 2256 (class 2604 OID 33676)
-- Name: motivobaja idmotivobaja; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.motivobaja ALTER COLUMN idmotivobaja SET DEFAULT nextval('iglesias.motivobaja_idmotivobaja_seq'::regclass);


--
-- TOC entry 2257 (class 2604 OID 33677)
-- Name: otras_propiedades idotrapropiedad; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.otras_propiedades ALTER COLUMN idotrapropiedad SET DEFAULT nextval('iglesias."otras_propiedades_ idotrapropiedad_seq"'::regclass);


--
-- TOC entry 2262 (class 2604 OID 33678)
-- Name: otrospastores idotrospastores; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.otrospastores ALTER COLUMN idotrospastores SET DEFAULT nextval('iglesias.otrospastores_idotrospastores_seq'::regclass);


--
-- TOC entry 2265 (class 2604 OID 33679)
-- Name: paises pais_id; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.paises ALTER COLUMN pais_id SET DEFAULT nextval('iglesias.paises_pais_id_seq'::regclass);


--
-- TOC entry 2266 (class 2604 OID 33680)
-- Name: paises_jerarquia pj_id; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.paises_jerarquia ALTER COLUMN pj_id SET DEFAULT nextval('iglesias.paises_jerarquia_pj_id_seq'::regclass);


--
-- TOC entry 2267 (class 2604 OID 33681)
-- Name: parentesco_miembro idparentescomiembro; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.parentesco_miembro ALTER COLUMN idparentescomiembro SET DEFAULT nextval('iglesias.parentesco_miembro_idparentescomiembro_seq'::regclass);


--
-- TOC entry 2269 (class 2604 OID 33682)
-- Name: religion idreligion; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.religion ALTER COLUMN idreligion SET DEFAULT nextval('iglesias.religion_idreligion_seq'::regclass);


--
-- TOC entry 2270 (class 2604 OID 33683)
-- Name: temp_traslados idtemptraslados; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.temp_traslados ALTER COLUMN idtemptraslados SET DEFAULT nextval('iglesias.temp_traslados_idtemptraslados_seq'::regclass);


--
-- TOC entry 2272 (class 2604 OID 33684)
-- Name: union idunion; Type: DEFAULT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias."union" ALTER COLUMN idunion SET DEFAULT nextval('iglesias.union_idunion_seq'::regclass);


--
-- TOC entry 2277 (class 2604 OID 33685)
-- Name: cargo idcargo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargo ALTER COLUMN idcargo SET DEFAULT nextval('public.cargo_idcargo_seq'::regclass);


--
-- TOC entry 2279 (class 2604 OID 33686)
-- Name: condicioninmueble idcondicioninmueble; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condicioninmueble ALTER COLUMN idcondicioninmueble SET DEFAULT nextval('public.condicioninmueble_idcondicioninmueble_seq'::regclass);


--
-- TOC entry 2281 (class 2604 OID 33687)
-- Name: departamento iddepartamento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento ALTER COLUMN iddepartamento SET DEFAULT nextval('public.departamento_iddepartamento_seq'::regclass);


--
-- TOC entry 2284 (class 2604 OID 33688)
-- Name: distrito iddistrito; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distrito ALTER COLUMN iddistrito SET DEFAULT nextval('public.distrito_iddistrito_seq'::regclass);


--
-- TOC entry 2286 (class 2604 OID 33689)
-- Name: estadocivil idestadocivil; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estadocivil ALTER COLUMN idestadocivil SET DEFAULT nextval('public.estadocivil_idestadocivil_seq'::regclass);


--
-- TOC entry 2288 (class 2604 OID 33690)
-- Name: gradoinstruccion idgradoinstruccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gradoinstruccion ALTER COLUMN idgradoinstruccion SET DEFAULT nextval('public.gradoinstruccion_idgradoinstruccion_seq'::regclass);


--
-- TOC entry 2291 (class 2604 OID 33691)
-- Name: idiomas idioma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idiomas ALTER COLUMN idioma_id SET DEFAULT nextval('public.idiomas_idioma_id_seq'::regclass);


--
-- TOC entry 2293 (class 2604 OID 33692)
-- Name: nivel idnivel; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nivel ALTER COLUMN idnivel SET DEFAULT nextval('public.nivel_idnivel_seq'::regclass);


--
-- TOC entry 2295 (class 2604 OID 33693)
-- Name: ocupacion idocupacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ocupacion ALTER COLUMN idocupacion SET DEFAULT nextval('public.ocupacion_idocupacion_seq'::regclass);


--
-- TOC entry 2297 (class 2604 OID 33694)
-- Name: pais idpais; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pais ALTER COLUMN idpais SET DEFAULT nextval('public.pais_idpais_seq'::regclass);


--
-- TOC entry 2299 (class 2604 OID 33695)
-- Name: parentesco idparentesco; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parentesco ALTER COLUMN idparentesco SET DEFAULT nextval('public.parentesco_idparentesco_seq'::regclass);


--
-- TOC entry 2300 (class 2604 OID 33696)
-- Name: procesos proceso_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procesos ALTER COLUMN proceso_id SET DEFAULT nextval('public.procesos_proceso_id_seq'::regclass);


--
-- TOC entry 2302 (class 2604 OID 33697)
-- Name: provincia idprovincia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincia ALTER COLUMN idprovincia SET DEFAULT nextval('public.provincia_idprovincia_seq'::regclass);


--
-- TOC entry 2305 (class 2604 OID 33698)
-- Name: tipocargo idtipocargo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipocargo ALTER COLUMN idtipocargo SET DEFAULT nextval('public.tipocargo_idtipocargo_seq'::regclass);


--
-- TOC entry 2307 (class 2604 OID 33699)
-- Name: tipoconstruccion idtipoconstruccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipoconstruccion ALTER COLUMN idtipoconstruccion SET DEFAULT nextval('public.tipoconstruccion_idtipoconstruccion_seq'::regclass);


--
-- TOC entry 2274 (class 2604 OID 33700)
-- Name: tipodoc idtipodoc; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipodoc ALTER COLUMN idtipodoc SET DEFAULT nextval('public.tipodoc_idtipodoc_seq'::regclass);


--
-- TOC entry 2309 (class 2604 OID 33701)
-- Name: tipodocumentacion idtipodocumentacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipodocumentacion ALTER COLUMN idtipodocumentacion SET DEFAULT nextval('public.tipodocumentacion_idtipodocumentacion_seq'::regclass);


--
-- TOC entry 2311 (class 2604 OID 33702)
-- Name: tipoinmueble idtipoinmueble; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipoinmueble ALTER COLUMN idtipoinmueble SET DEFAULT nextval('public.tipoinmueble_idtipoinmueble_seq'::regclass);


--
-- TOC entry 2315 (class 2604 OID 33703)
-- Name: trimestre idtrimestre; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trimestre ALTER COLUMN idtrimestre SET DEFAULT nextval('public.trimestre_idtrimestre_seq'::regclass);


--
-- TOC entry 2319 (class 2604 OID 33704)
-- Name: log_sistema idlog; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.log_sistema ALTER COLUMN idlog SET DEFAULT nextval('seguridad.log_sistema_idlog_seq'::regclass);


--
-- TOC entry 2321 (class 2604 OID 33705)
-- Name: modulos modulo_id; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.modulos ALTER COLUMN modulo_id SET DEFAULT nextval('seguridad.modulos_modulo_id_seq'::regclass);


--
-- TOC entry 2323 (class 2604 OID 33706)
-- Name: perfiles perfil_id; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.perfiles ALTER COLUMN perfil_id SET DEFAULT nextval('seguridad.perfiles_perfil_id_seq'::regclass);


--
-- TOC entry 2325 (class 2604 OID 33707)
-- Name: tipoacceso idtipoacceso; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.tipoacceso ALTER COLUMN idtipoacceso SET DEFAULT nextval('seguridad.tipoacceso_idtipoacceso_seq'::regclass);


--
-- TOC entry 2327 (class 2604 OID 33708)
-- Name: usuarios usuario_id; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.usuarios ALTER COLUMN usuario_id SET DEFAULT nextval('seguridad.usuarios_usuario_id_seq'::regclass);


--
-- TOC entry 2541 (class 0 OID 33203)
-- Dependencies: 171
-- Data for Name: actividadmisionera; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.actividadmisionera (idactividadmisionera, descripcion, tipo) FROM stdin;
1	Estudios B??blicos	semanal
2	Visitas Misioneras	semanal
3	Visitas a enfermos Tratamientos	semanal
4	Visitas a Carceles	semanal
5	Contactos Misioneros	semanal
6	Inscritos al Curso B??blico	semanal
7	Personas Traidas a la Reuni??n	semanal
8	B??blias Regaladas	semanal
9	Libros Regalados	semanal
10	Revistas Repartidas	semanal
11	Volantes	semanal
12	Cartas Misioneras	semanal
13	Clase de Mestros. Esc. S??b.	semanal
14	Visitas resividas del Ministerio	semanal
15	Reuniones Especiales	actmasiva
16	Peque??os Grupos Misioneros Organizados	actmasiva
17	Grupos Familiares Organizados	actmasiva
18	Misioneros Laicos (actual)	actmasiva
19	Conferencias P??blicas	actmasiva2
20	Seminarios	actmasiva2
21	Capacitaciones	actmasiva2
22	Congresos	actmasiva2
23	Lecciones de Escuela Sab??tica Adultos	materialestudiado
24	Lecciones de Escuela Sab??tica Ni??os	materialestudiado
25	Lecciones de Escuela Sab??tica Infantes	materialestudiado
26	Folleto de Estudio	materialestudiado
27	Bolet??n Informativo	materialestudiado
28	Libros	dexterna
29	Revistas	dexterna
30	Volantes	dexterna
31	Lecciones de E. S.	dinterna
32	El Guar. Del Sab.	dinterna
33	Ancla Juvenil	dinterna
34	Reuniones juveniles	actjuveniles
35	S??bados juveniles	actjuveniles
36	Fin de sem. Juveniles	actjuveniles
37	Seminarios juveniles	actjuveniles
38	Congresos juveniles	actjuveniles
39	textos	textos
\.


--
-- TOC entry 2543 (class 0 OID 33210)
-- Dependencies: 173
-- Data for Name: capacitacion_miembro; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.capacitacion_miembro (idcapacitacion, idmiembro, anio, capacitacion, centro_estudios, observaciones_capacitacion) FROM stdin;
\.


--
-- TOC entry 2545 (class 0 OID 33218)
-- Dependencies: 175
-- Data for Name: cargo_miembro; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.cargo_miembro (idcargomiembro, idmiembro, idcargo, idinstitucion, observaciones_cargo, vigente, periodoini, periodofin, idiglesia_cargo, idnivel, idlugar, tabla, lugar, condicion, tiempo) FROM stdin;
\.


--
-- TOC entry 2547 (class 0 OID 33227)
-- Dependencies: 177
-- Data for Name: categoriaiglesia; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.categoriaiglesia (idcategoriaiglesia, descripcion) FROM stdin;
1	Iglesia
2	Grupo
3	Filial
4	Aislado/Interesado
0	No Determinado
5	Campo
\.


--
-- TOC entry 2549 (class 0 OID 33233)
-- Dependencies: 179
-- Data for Name: condicioneclesiastica; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.condicioneclesiastica (idcondicioneclesiastica, descripcion) FROM stdin;
0	Miembro de escuela
1	Bautizado
\.


--
-- TOC entry 2551 (class 0 OID 33239)
-- Dependencies: 181
-- Data for Name: condicioninmueble; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.condicioninmueble (idcondicioninmueble, descripcion) FROM stdin;
1	Construido
2	Semiconstruido
3	En Construcci??n
4	En Litigio
\.


--
-- TOC entry 2553 (class 0 OID 33245)
-- Dependencies: 183
-- Data for Name: control_traslados; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.control_traslados (idcontrol, idmiembro, idiglesiaanterior, idiglesiaactual, fecha, carta_traslado, carta_aceptacion, estado, iddivisionactual, pais_idactual, idunionactual, idmisionactual, iddistritomisioneroactual) FROM stdin;
\.


--
-- TOC entry 2555 (class 0 OID 33251)
-- Dependencies: 185
-- Data for Name: controlactmisionera; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.controlactmisionera (idcontrolactmisionera, idactividadmisionera, anio, trimestre, idiglesia, semana, valor, asistentes, interesados, mes, fecha_inicial, fecha_final, planes, informe_espiritual, iddivision, pais_id, idunion, idmision, iddistritomisionero) FROM stdin;
\.


--
-- TOC entry 2557 (class 0 OID 33263)
-- Dependencies: 187
-- Data for Name: distritomisionero; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.distritomisionero (iddistritomisionero, idmision, descripcion, estado) FROM stdin;
1	1	San Mart??n	1
3	5	Paris	1
5	3	Cusco	1
6	4	Tacna	1
7	6	Asunci??n	1
8	7	Mexico DF	1
9	8	Caracas	1
10	9	Metrofrontera	1
11	9	Magdalena Medio	1
12	9	Central	1
13	9	Caribe 1	1
14	9	Caribe 2	1
15	10	Boyaca	1
16	10	Capital	1
17	10	Cunditolima	1
18	10	Llanos	1
19	11	Antioquia	1
20	11	Caldas 1	1
21	11	Caldas 2	1
22	11	Valle	1
23	12	Huila	1
24	12	Caqueta	1
25	12	Putumayo	1
26	12	Suroccidente	1
27	13	Distrito 1	1
28	13	Distrito 2	1
29	13	Distrito 3	1
30	13	Distrito 4	1
31	13	Gal??pagos	1
32	14	Montevideo	1
33	14	Delta del Tigre	1
34	14	Pando 	1
35	14	Rosario	1
36	15	Sur	1
37	15	Norte	1
38	15	Occidente	1
39	15	Noroccidente	1
40	16	Norte Grande	1
41	16	Norte Chico	1
42	16	Metropolitano	1
43	16	Biobio	1
44	16	Araucania	1
45	16	Los R??os	1
46	17	Cochabamba	1
47	18	La Paz	1
48	19	Potosi	1
49	19	Tarija	1
50	20	Santa Cruz	1
51	20	Trinidad	1
52	21	Distrito 1	1
53	21	Distrito 2	1
54	21	Distrito 3	1
55	21	Distrito 4	1
\.


--
-- TOC entry 2559 (class 0 OID 33271)
-- Dependencies: 189
-- Data for Name: division; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.division (iddivision, descripcion, estado) FROM stdin;
1		1
0		1
\.


--
-- TOC entry 2561 (class 0 OID 33276)
-- Dependencies: 191
-- Data for Name: division_idiomas; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.division_idiomas (iddivision, idioma_id, di_descripcion) FROM stdin;
2	1	Europea
5	1	Asiatica
1	1	Latinoamerica
6	1	Africana
0	1	No Determinado
7	1	 chu
7	2	ccccu
8	1	c
\.


--
-- TOC entry 2562 (class 0 OID 33279)
-- Dependencies: 192
-- Data for Name: educacion_miembro; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.educacion_miembro (ideducacionmiembro, idmiembro, institucion, nivelestudios, profesion, estado, observacion) FROM stdin;
\.


--
-- TOC entry 2564 (class 0 OID 33287)
-- Dependencies: 194
-- Data for Name: eleccion; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.eleccion (ideleccion, fecha, fechaanterior, supervisor, feligresiaanterior, feligresiaactual, delegados, tiporeunion, comentarios, periodoini, periodofin, iddivision, pais_id, idunion, idmision, iddistritomisionero, idiglesia) FROM stdin;
\.


--
-- TOC entry 2566 (class 0 OID 33295)
-- Dependencies: 196
-- Data for Name: historial_altasybajas; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.historial_altasybajas (idhistorial, idmiembro, responsable, fecha, observaciones, alta, idmotivobaja, rebautizo, usuario, idcondicioneclesiastica, tabla) FROM stdin;
\.


--
-- TOC entry 2568 (class 0 OID 33305)
-- Dependencies: 198
-- Data for Name: historial_traslados; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.historial_traslados (idtraslado, idmiembro, idiglesiaanterior, idiglesiaactual, fecha, idcontrol) FROM stdin;
\.


--
-- TOC entry 2570 (class 0 OID 33310)
-- Dependencies: 200
-- Data for Name: iglesia; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.iglesia (idiglesia, telefono, descripcion, referencia, iddistrito, idcategoriaiglesia, idtipoconstruccion, idtipodocumentacion, idtipoinmueble, idcondicioninmueble, area, direccion, valor, observaciones, estado, iddepartamento, idprovincia, tipoestructura, documentopropiedad, iddivision, pais_id, idunion, idmision, iddistritomisionero) FROM stdin;
1		Barranca	esquina con Calle Jerusalen	1292	1	2	2	2	1	0	AV. pampa de lara N?? 301	0	fg	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
3		Ventanilla	2?? curva	683	2	4	1	0	0	\N	Psje.  9  Mz. I  Lt. 3,  AA.HH. Mois??s Wool			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1181		Santa Clara		1235	0	0	0	0	0	\N	Santa Clara	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
6		Huaral	FRENTE MOTOREPUESTOS MU??OZ	1325	1	2	1	2	3		PSJE. LUIS FALCON 321		dsf	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1178		Olmos		1244	0	0	0	0	0	\N	Olmos	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
10		San Pedro	paradero hogar	1273	2	2	2	2	1		Jr. Ayacucho Mz. J   Lt. 22 PANAMERICANA NORTE  Km. 37 y 1/2 			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
11		Zapallal	PARADERO LA PIEDRA	1273	2	2	4	2	1		Calle las Tunas  Mz. A Lt. 8D			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
44	054-251204	Cayma	la telef??nica 	333	1	2	9	5	1	154	Los Arces 242	193949.43	recojer el titulo del concejo	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	\N	Chuquibamba	\N	\N	2	1	1	0	0	\N	Chuquibamba			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
48	\N	Ciudad Municipal	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
49	\N	Pachac??tec	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
50	\N	Pedregal	\N	\N	2	1	1	0	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
51		Ilo		1499	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
52		moquegua		1482	1	2	6	2	1	117	Calle el Progreso Mz. \\"A\\" 1. Lte 7. 	1,200.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
53		Torata		1780	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
55	\N	Alto Alianza	\N	\N	2	1	1	0	0	\N	Tacna			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
56		San Roque	colegio willan prescon	1782	1	2	6	5	1	360	Jr. Buenos Aires Mz. \\"M\\"  Lote N??-.  9 y10	32,400		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
57	\N	Huaccamole	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
58	\N	Mu??apucro	\N	\N	2	1	1	0	0	\N				0	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	\N	Pomabamba	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
60		Andahuaylas		684	3	1	1	0	0	\N				0	\N	\N	\N	\N	\N	\N	\N	\N	\N
62		Calca		684	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
63		Cuzco		684	1	2	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
64	\N	Cusipata	\N	\N	2	0	0	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
65	\N	Huancarani	\N	\N	2	1	1	0	0	\N				0	\N	\N	\N	\N	\N	\N	\N	\N	\N
66	\N	Limatambo	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
67	\N	Quillabamba	\N	\N	3	1	1	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
68	\N	Sicuani	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
69		Az??ngaro		1609	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
70		Jr. Carabaya		1594	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
72		Juliaca A		1682	1	2	6	5	1	300	Av. Aviacion 717 Urb. Santa Adriana	donaci??n		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
73	\N	Alegr??a	\N	\N	2	3	1	2	1	1000.24		3560.85	Son Tres Totes	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
76	\N	Mavila	\N	\N	2	1	5	0	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1229		Retamas		1182	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
78		Puerto Maldonado		1471	1	3	1	5	1		CALLE LOS CEDROS Mz . h Lot.6 BARRIO NUEVO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
80		Nuevo San Lorenzo		1215	1	2	9	5	1	220.45	Av. San Antonio N?? 1694, Nvo. San Lorenzo - JLO.	260170.15		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
81		Jos?? Pardo		1211	1	0	8	3	0		Jos?? Pardo N?? 185			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
82		Medio Mundo		1215	1	2	6	2	1	324	Jayanca N?? 161 - J. L. O.	64040.94		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
83		Tercer Sector		1215	1	2	9	2	3	70.63	Jos?? Goicochea Lt. 32 Mz. \\"A\\" Habilitaci??n Urbana Salamanca - JLO.	25000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
84		Santa Ana		1215	1	2	6	2	1	165	San Salvador N?? 1324	30979.20		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1191		Yanas		905	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
87		Roca Eterna		1215	2	0	8	3	0		Entre la Avenida Chiclayo y Bolivar			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
89		Las Brisas		1216	2	0	8	3	0		Agust??n Vallejo Zavala N?? 645 			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1184		Chavin de Pariarca		920	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
94		El Bosque		1216	1	2	9	2	2	217.76	Av. Mayta Capac N?? 1881			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
95		Cayalt??		1226	2	2	3	2	3	225	Santa Rosa Baja  Alta frente al parque			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1197		Santiago		601	0	0	0	0	0	\N	caserio santiago (sector chilint??n)	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
98		Huaca Rajada		1219	2	0	8	3	0		HUACA RRAJADA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
99		Las Vegas	A UN COSTADO DE LA CARRETERA QUE VA A LAGUNAS	1217	2	0	8	3	0		LAS VEGAS			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
101		Nuevo Mocupe		1217	1	0	7	1	0	1440	CALLE TACNA S/N	6140.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
104		Nueva Esperanza		1217	2	0	5	1	0		Ref. Fundo Fujimori			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
105		Santa Rosa		1224	3	0	8	3	0		Santa Rosa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
106		Tumbes		1807	1	0	5	1	0		JR. GENERAL MORZAN  N?? 505			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
107		Los Geranios		1817	2	1	7	2	3	161	JUAN VELASCO ALVARADO MZ. C LT. 11 AA.HH. LOS GERANEOS			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
108		Villa Primavera		1817	2	1	7	2	1	1000	AA.HH VILLA PRIMAVERA MZ. T III ETAPA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
109	\N	Las Malvinas	\N	\N	2	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
111	\N	Pampas de Hospital	\N	\N	2	3	5	2	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
113		La Molina		1530	2	3	5	2	2		CALLE JERUSALEB MZ 33 LT. 3   ASOC. CIVIL DE LA MOLINA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
115		Cieneguillo Sur Alto		1574	2	1	5	2	1		cieneguillo sur			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
116		Corrales Canchaque		1550	2	0	8	3	0		Corrales Canchaque			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
117		 Piura		1530	2	2	6	5	1	201.25	ALEJANDRO TABOADA N?? 218 SAN MARTIN	1500.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
118		Sullana		1574	1	2	2	2	1	140.80	CALLE SAN PEDRO MZ B1 LT. 14 BARRIO JESUS MARIA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
119		Chirinos Suyo		1548	1	1	3	2	1	525	C.P. CHIRINOS MZ. 3 LT. 5	50000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
120		La Cruceta		1574	3	0	8	3	0		la cruceta			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
121		Los Cocos		632	1	1	3	2	1	140	LOS COCOS	200.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
122		Tail??n		632	1	1	3	2	1	180	TAILIN	200.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
123		La Alfalfilla		632	1	1	5	2	1		LA ALFALFILLA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
124		San Juan de Higuerones		1549	2	1	5	2	1		SAN JUAN DE HIGUERONES			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
125		Shimana		632	2	1	1	2	1	105	SHIMANA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
127		Chicope		1549	2	0	8	3	0		CHICOPE			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1189		SAN CRISTOBAL		905	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
129		Chalanmache		632	2	0	8	3	0		CHALANMACHE			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
130		Los M??jicos		632	2	1	3	2	1	300	LOS MEJICOS	200		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
132		Lipanga		1552	2	0	8	3	0		LIPANGA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
133		La Lima		632	3	0	8	3	0		La Lima			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
134		Progreso		632	3	0	8	3	0		PROGRESO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
135		Lanchez Bajo		658	2	1	3	2	1	448	Lanchez Bajo	20.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
136		Agua Azul		655	2	1	3	2	1	250	AGUA AZUL	800.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
137		La Granadilla		655	2	1	3	2	1	60	LA GRANADILLA	1500.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
138		Monta??a de Sequez		655	2	1	3	2	1	682	MONTA??A DE SEQUEZ	1100.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
139		Pampas de Sequez		655	2	1	3	2	1	170	PAMPA DE SEQUEZ			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
140		El Palmo		655	2	1	5	2	1		EL PALMO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
141		La Florida		655	2	1	3	5	1	499.10	JOSE GALVEZ MZ. 31 LT. 5	2200.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
142		La Laja		655	2	1	7	2	1	126	LA LAJA	70.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
143		Macuaco		655	2	1	7	2	1	650	MACUACO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
144		El Papayo		655	4	0	8	3	0		EL PAPAYO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
145		Cerro Negro		655	2	0	8	3	0		CERRO NEGRO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
146		Succha Pampa		655	2	1	5	2	1		SUCCHA PAMPA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
147		Callualoma		655	2	1	5	2	1		CALLUALOMA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
148		Lanchez C.P.M.		658	2	1	3	1	1	615	LANCHES C.P.M.	200		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
149		Miravalles		658	2	1	7	2	1	120	MIRAVALLES	1000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
150		El Padrio		658	2	1	5	2	1		EL PADRIO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
151		Bebedero		658	2	1	5	2	1		BEBEDERO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
152		El Poleo		658	3	0	8	3	0		EL POLEO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
153		Espinal		655	2	0	8	3	0		ESPINAL			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
154		La Alfalfilla		658	2	1	1	0	0	240	LA ALFALFILLA	100.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
155		Nueva Arica		1219	3	0	8	3	0		NUEVA ARICA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
156		Oyot??n		1220	4	0	8	3	0		Oyot??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
157		Quernoche		655	4	0	8	3	0		QUERNOCHE			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
158		Niepos		658	3	0	8	3	0		NIEPOS			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
159		Huambos		587	1	1	3	5	1	960	Jr. 24 de Junio 	1000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
160	\N	Pan de Az??car	\N	\N	1	1	5	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
166		Santa Cruz		667	2	0	6	1	0	175	jr. francisco Bolognesi d/n	5100.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
167	\N	El Obraje	\N	\N	2	1	5	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
170		Chococirca		587	1	1	7	2	1	400	Chococirca	100.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
173		Chota		579	2	0	8	3	0		Chota			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
174	\N	Chiribamba	\N	\N	2	0	8	3	0		Chiribamba			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
175	\N	Anguia	\N	\N	3	0	8	3	0		Angu??a			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
176		Pauquilla		670	2	1	3	2	1	200	pauquilla			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1417		Ollachea 		1631	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
179	\N	Sogos	\N	\N	3	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
180		Bagua Capital	AV. PRINCIPAL	22	1	2	9	5	1	600	AV. HEROES DEL CENEPA 1832	1200.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
181		Guadalupe	FRENTE A LA PLAZA DE ARMAS	22	1	1	1	2	1	174.54	GUADALUPE	2000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
182		Campo Redondo		44	2	1	1	0	0	\N	CAMPO REDONDO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
184		Chinganza		23	2	1	1	2	1	140	CHINGANZA	600.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
185		El Molino		635	2	1	1	2	1	150	EL MOLINO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
186		Soldado Oliva		23	2	1	1	2	1	600	Soldado Oliva			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
187		Muyo		23	2	1	1	0	0	240	EL MUYO	2400.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
188	\N	Panam??	\N	\N	2	1	1	0	0	\N				0	\N	\N	\N	\N	\N	\N	\N	\N	\N
189		Naranjos		27	2	1	1	2	1	300	NARANJOS	600.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
190		Vista Alegre		23	2	3	1	2	1	244	VISTA ALEGRE	5000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
191	\N	Alenya	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
192		Aramango		23	4	1	1	2	1	80	ARAMANGO	150.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
193		Reposo		22	2	0	7	1	0	750	EL REPOSO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
195		La Papaya		22	4	1	1	0	0	\N	LA PAPAYA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
196		Ja??n		624	1	2	6	5	1	560	Jr. Cajamarca N?? 812	12000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
197		Chirinos		637	1	2	1	2	1	600	CRIRI??OS			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
198		Tabacal		626	2	1	1	2	1	200	TABACAL	1000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
199		Platanurco		626	2	1	1	2	1	300	PLATANURCO	500.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
200	\N	Balsal/ Nva. Alianza	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
201		Bellavista		625	1	1	1	2	1	148.70	6 DE AGOSTO CUADRA 1	3331.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
202	\N	El Gilgal	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
203		Monterrico		639	2	1	3	2	1	250	MONTERRICO	1000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
204		Rumipite		639	2	1	3	2	1	380	Rumipite	4000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
205	\N	Flor de Selva	\N	\N	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
206	\N	Morroponcito de Huarango	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
207		Los ??ngeles		627	3	1	1	2	1	180	loas ??ngeles			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
209		Torre de Babel		641	4	1	1	2	1	195	Torre de babel	2000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
210		Chachapoyas		1	1	2	9	5	1	512	TENIENTE NICOLAS ARRIOLA S/N	49844.20		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
211		San Juan de Cheto		4	1	1	1	2	1	153	calle castilla s/n	5000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
212		Cohech??n	CAMINO AL C.E. 18113	47	1	1	1	2	1	299.5	COHECHAN	1500.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
213		Chocta		51	1	2	1	2	1	577.76	CHOCTA	5000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
214		Collacruz		11	1	1	1	2	1	1680	COLLACRUZ	2000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
215	\N	San Juan de Cachuc	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
216		Tinas		20	2	1	1	2	1	500	Tinas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
217		Carilda		47	2	1	1	0	0	\N	CARILDA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
218	\N	La Pampa	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
219		Cruz Pata	A UN COSTADO DE LA AV. EL TURISMO	65	2	1	1	2	1	500	CRUZ PARA	2000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
220		Luya		51	2	1	6	2	1	606	LUYA	1000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
221	\N	Ingilpata	\N	\N	4	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
222	\N	Jalca Grande	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
224	\N	Mendoza	\N	\N	4	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
225	\N	Onmia	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
226	\N	Plan Grande	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
228		Nuevo Gualulo		33	1	1	1	0	0	\N	NUEVO GUALULO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
318		La Morada		936	1	2	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
229		Pomacochas		33	1	1	3	2	1	354.62	JR POMACOCHAS MZ. 70 LT. 13	10000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
230		Pedro Ru??z		34	1	2	1	2	1	155	JR. CIRO ALEGRIA S/N			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
233		Chilac		28	1	1	1	2	1	200	Chilac			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
234	\N	San Jos?? Alto	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
235		San Jos?? Bajo		33	2	1	1	2	1	200	SAN JOSE BAJO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
237	\N	Beirut	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
238	\N	Jumbilla	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
240	\N	Fanre	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
242		La Florida		33	4	1	1	0	0	\N	La Florida			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
243		Tarapoto	Barrio Huayco	1761	1	2	9	5	3		Jr. Ricardo Palma 1076			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
244		La Esperanza	a Espalda del Colegio \\"Ni??os en Acci??n\\"	1132	1	1	9	2	1		Jos?? Mar??a Zapiola N?? 1901			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1218		Alto Trujillo (Barrio 2-B)		1129	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1219		Alto Trujillo B?? 4A		1129	0	1	1	2	3		Alto Trujillo B?? 4A			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
248	7934408	Pachacutec	Paradero Llantero   Antes del mercado Hatun Inca	683	2	2	9	2	1		Sector B Mz.  G Lt. 16 			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
249		Keiko Sof??a	Entrar por Km.  39 Panamericana Norte	683	2	2	9	2	3		Calle el Dorado  Mz. W  Lt 13  Segunda Etapa Pachacutec - Ventanilla			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1174		La Olleria		1242	0	0	0	0	0	\N	La Olleria - Morrope	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
252		Canto Grande	PARADERO 5  Mariscal C??ceres - S.J. Lurigancho	1280	1	3	7	2	1		MZ.  C LT. 8 AA.HH. Jes??s de Nazaret			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
253		Santa Clara		1251	2	2	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
254		Chosica		1251	2	2	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
255	7266293	Villa El Salvador Sector 6		1290	1	2	6	2	1		MZ.  N  LT. 24  GRUPO 8 			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
256	2920390	Villa El Salvador Sector 1		1290	1	2	6	5	1		MZ.  I  LT. 15 GRUPO 23			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
258		Huertos de Manchay	Av, Manchay, pasando Av, Naranjos , bajar en parad	1271	2	2	1	2	1		Mz.  F 11, Lt.  7  Sector F			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
259		Z??rate	DETRAS DE LA IGLESIA CATOLICA	1280	2	2	8	0	0	\N	Jr. Tahuantinsuyo N?? 522			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
260		Huacho	POR LA POSTA HUALMAY, 1 CUADRA A LA IZQUIERDA	1369	2	1	1	0	0	\N	PROLONG. GABRIEL AGUILAR 429			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
261		UNI??N BAJA		1379	2	1	1	0	0	\N	PALPAS			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
262		Paraiso		1292	2	2	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1367		MIRAFLORES		1751	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
269		San Isidro		976	1	2	4	2	1		JR. LIMA 1782			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
270		Pueblo Nuevo		969	1	1	1	0	0	\N	Chincha			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
980		Nanrr??		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
276		 Salas		979	1	0	8	3	0		SECTOR LOS BANCARIOS 			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
277	064-385087	Chilca	Altura Av. Pr??ceres Cdra. 10	1009	1	2	9	5	1	520	Jr. Ancash 1165 - Chilca 			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
278		Hualhuas	Paradero: Jr. Lima	1016	1	1	9	2	1	131.60	Av. Alfonso Ugarte 823 - Hualhuas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
279		Bellavista	Referencia: Pasando Estadio	1125	1	1	2	2	1	1,555	Av. Atahualpa s/n Bellavista.		esperando... se inicio tramites en Sunarp de desmembramiento de la Comunidad Campesina de Acac Bellavista, para ser considerados due??os leg??timos...	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
280		La Esperanza		1125	1	1	2	2	1	150	Carretera a Caser??o Paccha s/n - La Esperanza 		esperando... se inicio tramites en Sunarp de desmembramiento de la Comunidad Campesina de Acac Bellavista, para ser considerados due??os leg??timos...	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
281		Huamancaca Chico	Ref: I.E. N?? 30111 ???Cristo Rey???.	1123	1	0	2	1	0	139.50	Psje. Ram??n Castilla s/n Anexo Miraflores			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
282		Cerrito de La Libertad	Ref: Bajar por Psje Los Granizos	1005	1	2	9	2	1	101.70	Psje. Cordillera 175 ??? Barrio Las Rosas	18,969.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
283		San Juan de Jarpa	Refer: antes de la Garita.	1125	1	1	3	2	1	202.72	Av. Manco C??pac Mz: F, Lote: 3, Barrio Chacapampa.		esperando... se inicio tramites en Sunarp de desmembramiento de la Comunidad Campesina de Jarpa, para ser considerados due??os leg??timos...	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
284	064-830453	Pucacocha / Andamarca		1035	1	1	8	3	0	100	Jr. Jorge Ch??vez Darwin s/n - Plaza Principal de Pucacocha	1000		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
285		San Lorenzo / Jauja	Refer: Viniendo de Huancayo 18 Km antes de Jauja. 	1081	2	0	2	1	0	32	Jr. 2 de Mayo 1174 - (Paradero) Miraflores.			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
286		Pampas / Huancavelica	Refer: Entrada-Polic??a de Carreteras.	870	3	1	5	3	0		Av. Progreso 775, Tayacaja, Huancavelica.			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
287		Tarma Progreso		1100	1	2	9	5	1		Jr. Bellavista s/n    Barrio el  Progreso.			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
288		Huasahuasi		1103	2	1	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
289		Acracocha		1101	2	0	5	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
290		La Oroya		1109	2	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
970		chipaquillo		924	0	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
292		La Campi??a		1092	1	2	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
978		Las Tayas		601	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
294		Santa Ana		1049	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
295		Pichanaki	ALT. GRIFO LOZANO	1050	2	1	1	0	0	\N	AV. SANTA ROSA 778			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
296		Portillo Alto		1098	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
297		Sinchi Jaroki		1092	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
298		Atalaya		1827	3	2	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
300		Hu??nuco		886	1	2	9	5	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
301		Cabramayo		886	1	1	1	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
302		Cochas		886	1	1	1	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
303		Incajaman??		886	1	1	1	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
304		Llicua		886	1	1	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
305		Salapampa		886	2	1	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
307		Cauri		887	2	1	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
308		Margos		886	2	1	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
309		Taruca		886	2	1	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
310		Colpashpampa		899	2	1	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
311		Cayhuayna		886	2	1	2	2	2					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1196		San Juan de Contumaz??		598	0	0	0	0	0	\N	San Juan -- Contumaz??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
314		Ambo		897	2	1	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
316		Tingo Mar??a		929	1	2	9	2	1		jr. yurimaguas 767			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
451		Compartici??n		1140	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
317		Aucayacu	FRENTE AL COLEGIO SANTA ROSA	932	1	2	2	2	1		JR. HUANCAYO  S/N			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
319		PAMPAMARCA		924	2	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
321		Pueblo Nuevo		932	2	2	2	2	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
322		Pueblo Libre		1779	2	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
323		Castillo Grande		929	2	2	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
956		AV. CAMANA		360	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
325		La Florida		936	2	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
957		Espinar		740	0	0	0	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1402		Buenos aires		1752	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1382		ASUNCI??N		552	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1202		Villa Hermosa		1215	0	0	0	0	0	\N	Villa Hermosa	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1344		ARMANAYACU		1720	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
342		Pinto Recodo		1731	3	0	3	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1355		NUEVA VIDA		1721	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1356		PACHIZA	ESQUINA DEL CAMPO DEPORTIVO	1740	0	0	0	0	0	\N	JIRON SAN MARTIN	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1357		PISCUYACU		1723	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1358		NUEVO SAN MARTIN		1738	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1359		SANAMBO		1740	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1360		SANTA INEZ		1739	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1395		Poroto		1135	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1384		La Lucma del Guayabo		559	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1391		Catuay Bajo		1137	0	2	9	2	1				EST?? EN PROCESO LA SUB DIVISI??N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1392		Chinchango		1156	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1387		Alto Trujillo B 4B		1129	0	2	3	1	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1388		Allacday		1160	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
376		Iquitos		1420	1	2	9	5	1		Calle Diego de Almagro n?? 714			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
377		Triunfo		1430	3	0	2	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
380		Los Claveles		1703	1	2	9	5	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
388		Alamo		1708	2	2	7	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
389		Buenos Aires		1703	2	1	7	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1310		CAMPO ALEGRE		1706	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
392		Sugllaquiro		1703	3	1	7	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
396		Nuevo Ja??n		1708	3	2	7	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
397		Rioja 		1752	1	2	9	5	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
398		Nueva Cajamarca		1755	1	2	5	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
399		Alto Mayo		1753	2	1	7	0	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
400		Naranjos		1752	2	2	7	2	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
401		San Juan		1753	2	0	0	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
402		La Uni??n		1755	2	0	5	2	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
403		Nuevo Piura		1703	2	3	1	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
405		Valle Grande 		1754	2	1	5	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
406		San Fernando		1758	3	0	2	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
955		Naranjillo		1755	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1372		I.E. SAN MATEO TARAPOTO		1761	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
411		Bajo Espital		22	2	1	1	0	0	\N				0	\N	\N	\N	\N	\N	\N	\N	\N	\N
415	\N	Psje. Huascar	\N	\N	2	0	8	3	0		Mar??a Parado de Bellido # 169			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
416		Bethel - La Victoria		1216	1	2	9	2	1	94.67	Av. Pachacute N?? 1184			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
417	\N	Yerba Buena	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
420		El Prisma	al costado del Mercado de Papas-Chicago	1128	1	2	9	2	1	295.41	Mz: C, Lote: 6, Fundo El Prisma	173,344.08		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
421		Huanchaquito Alto	Paradero San Carlos	1131	2	1	1	2	2	119.50	Mz: 4, Lote: 1, Etapa II, San Carlos		CAMBIE LA RAZON SOCIAL EN HIDRANDINA, FALTA GESTIONAR AGUA POTABLE Y DESAGUE Y SANEAR DOCUMENTOS DE PROPIEDAD EN COFOPRI	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1063		Taul??s Calquis		655	0	0	0	0	0	\N	Taulis	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
424		El Milagro	a 3 Cuadras de Plaza de Armas de El Milagro	1131	2	2	9	2	1	302.20	Calle Manco Capac Mz: 23, Lote: 22, Sector V.	70367.20		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
425		Laredo	Paradero: Bodega \\"Marilyn\\" por Posta Medica.	1133	2	2	1	2	3	140	Urb. Santa Maria, Etapa I, Mz. C Lt. 9		HAY QUE HACER SUBDIVISI??N Y NUEVA ESCRITURA PARA INGRESAR A SUNARPP	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
426		V??ctor Ra??l de Huanchaco	por el Colegio Juana Mujica	1132	1	1	1	5	1		Calle Las Antaras Mz: 75, Lote: 10	3,500.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
427		Valdivia Alta	casa de Joaqu??n Ramos	1131	2	2	1	1	3		Calle Los Chincheros, Mz: 41, Lote: 11 Sector Valdivia Alta - V??ctor Ra??l de Huanchaco			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
429		Alto Salaverry (Alto Moche)	altura Paradero 11 de la Panamericana Norte	1136	2	1	9	2	3	198.50	Calle: El Porvenir Mz: J, Lote: 8, Sector I, c/esquina Santa Rosa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
430		Santa Sof??a	frente a Pesqueda, a espalda de una Loza deportiva	1128	2	1	9	2	1	297.45	Calle: 8, Mz: G, Lote: 6. Urb. Popular Santa Sof??a	41,180.23	existen 2 lotes, Urb. Popular Santa Sof??a, Mz: G, Lotes: 5-A y 6, el 6 ya est?? en RR.PP, est?? en proceso el saneamiento del otro lote 5-A.	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
432		Trujillo Centro	a 1/2 Cuadra del Ministerio de Transporte	1128	1	2	9	2	1	226.39	Jr. M??xico N?? 455 interior 4	78,114.95		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
434		Buenos Aires Sur	Frente al Parque La Poza	1138	1	1	9	2	1	334.020	Av. Bolivia N?? 880			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
435		Maracan??		1129	1	1	2	5	3	1548.12	Jr. San Luis 160 - Rio Seco - El Porvenir			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
436		Alan Garc??a	por la Poller??a \\"Gilberth\\"	1132	1	1	4	2	1		Urb. Tepro Parque Industrial Mz. K Lt. 9	7,000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
437		Florencia Alta	x Grifo \\"Mi Wilmercito\\" entrar 2 cuadras a la Izq	1130	1	2	2	2	3	374.320	Calle: 29 de Junio N?? 2031		AUTOVALUO AL DIA, INAFECTADO DE IMPUESTO PREDIAL MAS NO DE ARBITRIOS MUNICIPALES	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1397		Los Claveles		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
969		Cosp??n		554	0	0	0	0	0	\N	Cosp??n	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1320		SANTA ROSA		1704	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1398		Nuevo Huancabamba		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1338		ALTO PONAZA		1750	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1340		NV. CHANCHAMAYO		1751	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1368		N.V LAMBAYEQUE		1749	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
447		Conache	en casa de Hno. Germ??n y Esperanza	1133	2	1	5	4	2		Conache		PRESTADO POR LA UNICA FAMILIA DEL LUGAR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
449		La Botella		1140	3	1	1	0	0	\N	Caser??o La Botella			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
452		Huabalito		1140	2	1	1	0	0	\N	Caser??o Huabalito			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
454		Salinar A		1140	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
457		Paij??n	Distrito de Paij??n	1143	1	1	1	0	0	\N	Paij??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
458	943 322 738	Quebrada honda		1140	2	1	1	0	0	\N	Carretera a cascas. Paradero panaderia. El espejo.			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
459		Membrillar A		1140	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
460		Jaguey		1140	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
461		La Planta		1143	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
462		Sausal		1140	1	1	9	0	0		AA.HH. Alto Per?? Barrio 2, Mz: 10, Lote: 5			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
463		Mocan		1146	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
464		La Portada		602	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
465		Mirag??n		1168	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
466		Membrillar B		1140	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
467		Parrap??s		1168	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
468		Pampas de Jaguey		1140	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
470		Ascope	Ascope	1139	1	1	9	2	1		Buenos Aires 120			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
471		Huamachuco Centro		1188	1	1	9	0	0		Jr. San Mart??n 661			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
472		Curgos		1191	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
473		Coip??n Bajo		1188	1	1	1	0	0	\N	Caser??o Coip??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
478		Santo Domingo	Distrito Cachicad??n	1198	3	1	9	0	0		Caser??o Santo Domingo		FALTA SUB DIVIDIR.	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
479		Saz??n		1188	2	1	1	0	0	\N	Barrio Saz??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
480		Cascas		1204	1	1	1	0	0	\N	Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
483		Jolluco	Distrito Cascas	1204	1	1	1	0	0	\N	C.P.M. Jolluco			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
484		Huancay	Dist. Marmot - Prov. Gran Chim??	1204	1	1	1	0	0	\N	Caser??o Huancay			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
485		Panam??	Dist. Marmot - Prov. Gran Chim??	1204	2	1	1	0	0	\N	Caser??o Panam??			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
486		Pampas de Chepate	Distrito Cascas	1204	1	1	1	0	0	\N	C.P.M. Pampas de Chepate			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
489		La Laguna		1204	2	1	1	0	0	\N	Distrito de Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
490		Tillamp??		1204	2	1	1	0	0	\N	Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
491		Llacahu??n	se atiende desde Cascas	1160	2	1	1	0	0	\N	Pertenece al Distrito de Otuzco			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
492		El Molino		1204	3	1	1	0	0	\N	Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
493		Palmira		1204	2	1	1	0	0	\N	Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1012		Las Tunas		1204	0	0	0	0	0	\N	Cascas	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
498		Tambo Puquio		1204	2	1	1	0	0	\N	Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
500		Salitre		1204	2	1	1	0	0	\N	Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1237		Portachuelo		1189	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
505		Nueve de Octubre		1204	2	1	1	0	0	\N	Cascas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
509		Pampas del Bao (Paquisha)		1204	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
510		Corlas	Distrito Cascas	1204	2	1	1	0	0	\N	Caser??o Corlas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1235		Caucharatay		1189	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
514		Contumaz??	Cerca del colegio David Le??n (AGRO)	598	1	1	1	0	0	\N	Jr. Tantarica 115			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
515		Congadipe		601	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
519		Cruz Grande		601	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
521		Choloque		601	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
524		Ayambla		603	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
525		La Succha		601	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
526		Espino Largo		601	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1004		San Mart??n		1204	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
532		Yet??n		602	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1002		Quihuate		554	0	0	0	0	0	\N		\N	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N
1001		Cortaderas		623	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
535		La Pampa (Guzmango)		601	1	1	1	0	0	\N	Caser??o: La Pampa, cerca de Guzmango			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
536		Toledo		603	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1003		Huaycotito		554	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1225		Huayobamba		554	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
542		Guzmango		601	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
545		Cascabamba \\"A\\"		598	3	1	1	0	0	\N	Cascabamba, Contumaz??			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1289		PEBAS		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1290		NV-, HUAMACHUCO		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1049		CAMAN??	CERCA  A LA PANAMERICANA AL ESPALDA DE UN COLEGIO	361	0	0	6	1	0	200	LA RINCONADA DE HUACAPUY MZ  \\"C\\" LOTE 05.	10,000.00	POR CONSTRUIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
552	\N	Convento	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
553		Rosas-Cachimarca	Dist. Cochorco - Prov. S??nchez Carri??n	1190	1	1	1	0	0	\N	Caser??o de Purun Rosas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
554	\N	Uchuy	\N	\N	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
555		Soqui??n		1190	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
556	\N	Tayango	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
557	\N	Marcabal Grande CENTRO BETEL	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
558		Aricapampa		1190	2	1	9	0	0		Caserio de Aricapampa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
559	\N	Gloriabamba	\N	\N	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
560		Molino Viejo	Dist. Cochorco - Prov. S??nchez Carri??n	1190	2	1	1	0	0	\N	Caserio Molino Viejo			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
561	\N	Uchubamba	\N	\N	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
562	\N	La Pauca	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
563		Vista Florida	Dist. Chillia - Prov. Pat??z	1177	2	1	1	0	0	\N	Caserio Vista Florida			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
564		Ganz??l		1192	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
565		Cachipampa		1195	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
567		Vijus	Dist. Pat??z - Prov. Pat??z	1183	2	1	1	0	0	\N	Caser??o Vijus			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
568		Los Alisos	Dist. Parcoy - Prov. Pat??z	1182	2	1	1	0	0	\N	Caserio Los Alisos			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
569		La Cienaga	Dist. Pat??z - Prov. Pat??z	1183	2	1	1	0	0	\N	Caser??o La Cienaga			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
570		Zarumilla	Dist. Pat??z - Prov. Pat??z	1183	3	1	1	0	0	\N	Caser??o Zarumilla			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
571		Card??n		1195	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
574		Sartimbamba		1195	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
575		Puente el Oso	orillas del Mara????n - Dist. Pataz	1183	2	1	1	0	0	\N	Caserio Puente El Oso			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1255		Cruce el Milagro		1170	0	1	9	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
577		Shin Shil	Dist. Sar??n - Prov. S??nchez Carri??n	1194	2	1	1	0	0	\N	Caser??o de Shin Shil			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
578		Llant??n	Distrito de Sar??n	1194	2	1	1	0	0	\N	Caser??o Llant??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1248		Pampa Alegre		649	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
580		Nueva Uni??n	Distrito de Sar??n	1194	2	1	1	0	0	\N	Caser??o Nueva Uni??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
581		Nueva Esperanza	Por el Caser??o Cerpaquino	1194	1	1	9	0	0		Caser??o Nueva Esperanza			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
582		Succha Centro	Dist. Cochorco - Prov. S??nchez Carri??n	1190	2	1	1	0	0	\N	Caser??o Succha Centro			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
583		Sar??n	Distrito de Sar??n	1194	1	1	1	0	0	\N	Calle: Abelardo Gamarra Rond?? s/n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1249		Choctapampa		574	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
585		Pishauli		1189	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1256		Nuevo Pacasmayo		1173	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
587		Chugay		1189	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1239		Cochorco		1190	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
592		Pijobamba	Dist. Sitabamba - Prov. Stgo. Chuco	1203	1	1	1	0	0	\N	Caser??o Pijobamba			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1244		El Chirimoyo		643	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1241		El Card??n		649	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1242		La Cruz Blanca		564	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
596		Hualay	Distrito de Sar??n	1194	1	1	3	2	3		Caser??o Hualay			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
597		Poc Poc Centro	Distrito de Sar??n	1194	1	1	1	0	0	\N	Caser??o Poc Poc			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
598		Munmalca	Distrito de Sar??n	1194	1	1	1	0	0	\N	Caser??o Munmalca			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
599		Nuevo Bel??n	Distrito de Sar??n	1194	1	1	1	0	0	\N	Caser??o Nuevo Bel??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
600		Uruspampa	Distrito de Sar??n	1194	1	1	1	0	0	\N	Caser??o Uruspampa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
601		Cajamarca	Cajamarca	551	1	1	1	0	0	\N	Diego Ferr?? 267 - Sta. Elena			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
603		Choropampa Baja	Choropampa	584	1	1	1	0	0	\N	Flavio Castro s/n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1280		Chala - Bambamarca		621	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
612		Mollepata		552	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
613		Magdalena		559	1	2	3	2	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1352		EL DORADO		1720	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
616		La Shayhua		598	3	1	1	0	0	\N	Caser??o La Shayua, Dist. y Prov. Contumaz??			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
617		Succhabamba		559	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1234		Casgabamba		1194	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1283		Bellavista		598	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
623		Jes??s		556	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
624		Choropampa Alta		559	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1295		AMI??IO		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1292		LA LIBERTAD		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1236		Payures		1203	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1281		San Antonio		598	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
634		Santa B??rbara		558	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1294		ALAO		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
636		Namora		561	4	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
640		La Lima		564	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
645		Cajabamba		563	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
646		Santa Cruz		667	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
647		Campo Alegre		645	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
648		San Marcos		647	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
650		Azufre		643	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
651		El Sauce o Cachachi		564	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
653		Alto Yerba Buena		561	2	1	1	0	0	\N	Alto Yerba Buena			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
654		HUANGASHANGA		570	3	1	5	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1051		Alegria		1473	0	0	0	0	0	\N	Lote 8 Mz. x1. centro poblado Zona 2	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1257		Las Palmeras		1173	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
658		Nueva Jerusal??n		636	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
660		Pacay		641	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
662		Bolivar		1147	2	1	1	0	0	\N	Distrito Bolivar			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
663		La Morada		648	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
664		El Triunfo		649	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
665		Malat		649	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
666		La Pauca		643	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
668		Yal??n		1147	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
669		Ucuncha		651	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
670		Uchumarca		1151	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
671		San Francisco		551	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
673		Milauya		1147	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
674		El Pozo		1147	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1050		Fundo \\"El Ed??n\\"	Carretera al Cusco	1474	0	0	0	0	0	50,000	Kilometro 68	Donaci??n		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
676		Celendin		567	3	1	1	0	0	\N	Distrito de Celend??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
677		Llamactambo		1151	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
678		Callacat		578	2	1	1	0	0	\N	Callacat			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
679		San Vicente de Pa??l		1150	1	1	1	0	0	\N	C.P.M. San Vicente de Paul			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1317		PARAISO		1706	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
682		Tembladera		605	1	1	1	0	0	\N	Capital del Distrito Yon??n, Contumaz??			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
683		San Ju??n de Dios		1154	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
684		Nueva Jerusal??n		1172	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1348		CAMPANILLA		1738	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
686	\N	Ventanillas	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
687		Guadalupe		1171	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
688		Villa Hermosa		1153	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
689		Jun??n (Chep??n)		1153	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1311		CARACHUPA YACO		1706	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1312		CARRIZAL		1706	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1380		Parque Industrial - El Poso		1132	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
693		Zapotal		605	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
694		El Mango	a 30 minutos de Pacasmayo	605	2	1	1	0	0	\N	Fundo El Mango, Distrito de Yonan			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
695		El Truzt		1154	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
696		Santa Victoria		1172	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
697		Pay Pay		605	2	1	1	0	0	\N	Tembladera Capital del Distrito de Yon??n, Contumaz??			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
698		Yatahual		605	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
699		Salitre		1172	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
700		Pueblo Nuevo		1172	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
701		Miradorcito		1172	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
702	\N	Las Paltas	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
703		Villa los M??rtires		1172	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
704		El Sapo		604	3	1	1	0	0	\N	Caser??o El Sapo, Distrito Tantaricam, Contumaza			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
705		Pampa Larga		605	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1365		N.V LORETO		1712	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
709		Llall??n		605	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
710		Tahuantinsuyo		1172	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
711		Cerro Colorado		1154	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1343		SANTA ROSA		479	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
713		San Jos?? de Moro		1172	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
715		El Prado		600	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1264		Chilete		599	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
719		Campo Nuevo	Guadalupito - Vir??	1210	2	1	1	0	0	\N	C.P. Campo Nuevo			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
721		San Luis		231	2	1	9	2	2		Mz: H, Lote: 6, AA. HH. San Luis, Santa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1108		Hualalay		199	0	0	0	0	0	\N	Caser??o Hualalay, 	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
724		Chao		1209	2	1	1	0	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1275		Llapa		656	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1291		ROCA FUERTE		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1277		Rodeopampa Alta		656	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
729		Moro		228	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
732		Santa Rosa		231	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
734		Chimbote		224	1	2	9	5	1	135.40	Jr. Libertad 625, Mz: K, Lote: 36,  AA. HH. Pueblo Libre	35,000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1273		Cortadera		623	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1274		La Calzada		656	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
743		Sihuas		233	1	1	4	5	1	830	Distrito de Sihuas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
744		Manta	Distrito de Sihuas	233	1	1	2	2	1	2,073.75	Caser??o de Manta		EST?? PENDIENTE UNA TRANSFERENCIA DE LA FAMILIA ALEJOS A LA ASOCIACION. SE SAC?? EL CERTIFICADO DE POSESION EN COORDINACION CON EL HNO. TEOFILO ALEJOS. SE HIZO INSCRIPCION DE PREDIOS Y LUEGO INAFECTACI??N DE IMPUESTO PREDIAL	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1325		SANTA CATALINA		1709	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
747		Satipo		1092	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
748		Shanki		1092	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
947		Villa Rica		1529	0	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1166		Cutervillo		579	0	0	0	0	0	\N	Cutervillo	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
751		Puente Paucartambo		1051	1	0	5	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
752		Rio Perla		1049	2	0	2	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
753		Muruhuay		1101	2	0	9	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
754		Colcamar		46	1	1	1	2	1	112	COLCAMAR			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1070		La Flor		79	0	1	1	2	1	224	La Flor	150		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1319		SAN LORENZO (peaje)		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
758		Limbani   		1688	2	2	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
759		Chicchuy		886	1	1	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
760	\N	Aislados	\N	\N	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
761		Rio de Oro		934	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
762		Pacota		1776	2	2	2	2	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
763		Julio C.Tello		931	2	3	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
764		Cashapampa		924	1	1	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
765		La Primavera		932	2	3	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
766	\N	Nuevo Chirimoto	\N	\N	4	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
767	\N	Itamarati	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
768		Churuyacu		624	2	1	1	0	0	\N				0	\N	\N	\N	\N	\N	\N	\N	\N	\N
1269		Tangay		224	0	1	9	1	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1078		Catillambi		552	0	0	0	0	0	\N	Caser??o Catillambi, Dist. Asunci??n, Prov y Dep. Cajamarca	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
776		Piobamba		574	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
777		Tallambo		561	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
778		San Ignacio		636	2	1	1	0	0	\N	SAN IGNACIO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
779		Guadalupito		1210	2	1	1	0	0	\N	Guadalupito			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
780		Higuer??n Pampa		1555	2	1	5	2	1		HIGUERONPAMPA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
781		Nuevo Paraiso		632	2	0	8	3	0		NUEVO PARAISO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
782		Buenos Aires		22	3	1	1	0	0	\N				0	\N	\N	\N	\N	\N	\N	\N	\N	\N
784		Choco Morropon		1561	2	0	8	3	0		chocos morropon			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
786		Pashul		632	2	0	8	3	0		PASHUL			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
787		Maz??n		632	2	0	8	3	0		MAZIN			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
788		Tupac Amaru		632	2	1	3	2	3	300	TUPAC AMARU	150.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1167		La Arada Alta		1530	0	0	0	0	0	\N	La Arada Alta	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
792	\N	Querocoto	\N	\N	2	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
793		Challoaracra		587	2	1	7	2	1	128	Chalyoaracra			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
795		Cusilguan 		587	2	1	7	2	1	512	Cusilguan 	5000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
797	\N	San Pedro	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
798		Loma Larga		637	2	1	1	0	0	\N	LOMA LARGA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
799		Las Pirias		629	2	1	1	0	0	\N	LAS PIRIAS			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
800	\N	Virgen del Carmen	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
801		San Francisco		637	3	1	1	0	0	\N	San Francisco			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
802	\N	Las Palmas	\N	\N	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
803	\N	Santa Rosa	\N	\N	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1077		VON HUMBOL		1444	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
806		Coipin Alto		1188	2	1	1	0	0	\N	Caser??o Coip??n			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
807		Lomas de Wichanzao	ex Paradero de Ramiro Prial?? x iglesias.iglesias.iglesia Israelita	1132	2	1	9	1	3		AA. HH. Lomas de Wichanzo - Sector II, Mz: 3, Lote: 38		FALTA SUB - DIVISI??N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
808		Santa Rosa		1548	2	0	8	3	0		santa rosa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1183		LA ESPERANZA TANTAMAYO		908	0	0	0	0	0	\N	LA ESPERANZA	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
810		El Parco		25	3	1	1	2	1	90	El Parco	90.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
812		Huambocancha		551	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1250		Ciudad de Dios		1171	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
821		Paracoto		552	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1416		Amparani		1595	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1186		VISTA ALEGRE		905	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1066		Nuevo Progreso		54	0	0	0	0	0	\N	Nuevo Progreso	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
825		Fundo Familia Paredes		1172	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1267		Nuevo Horizonte (Buenos Aires)		1155	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1266		Santa Clemencia		224	0	0	0	0	0	\N	AA. HH. Santa Clemencia Jr. T??pac Yupanqui Mz: ??, Lote: 2. c/esquina Psje. Pachac??tec	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
830		Marcabal Grande Parte Alta		1192	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
831		Calquiche	Dist. Pat??z - Prov. Pat??z	1183	4	1	1	0	0	\N	Caser??o Calquiche			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
832		Santa Ana - Dos de Mayo		574	2	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
833		Las Malvinas-Sto. Domingo		1198	2	1	5	0	0	\N	Las Malvinas			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
835	\N	Monterrey	\N	\N	2	1	1	0	0	\N	Monterey			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
838		AA.HH. Sr. de Los Milagros		982	2	1	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
839		Santa Ana -  Laran		977	2	2	4	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
840		La Tingui??a - ICA		963	2	2	4	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
841		Pomabamba		311	3	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
842		El Taro		977	3	0	5	2	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1156		CUTIMARCA		904	0	0	0	0	0	\N	TOMAY KICHWA	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1198		LA HUACA		1140	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1195		Esechope		602	0	0	0	0	0	\N	Entre Yet??n y Choloque	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
849		Santa Lucia		1779	1	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
850		TOCACHE		1775	1	0	2	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
851		Bambamarca		1775	1	2	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1253		San Pedro de Lloc		1170	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
853		San Miguel de Tulumayo		933	1	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
854		Pucallpa	parque los rojos	1820	1	2	2	5	1		jr. padre amich 190 			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
855		Nolberth		1821	1	3	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
856		Contamana		1459	1	3	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
857		Guineal		1824	1	3	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
858		Neshuya o Monte Alegre		1821	1	0	2	1	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
859		Barrio Unido Aguaytia		1826	1	2	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
860		Campo Verde		1821	1	0	2	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
861		LEON DE JUDA		1820	1	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
862		Flor del Valle		1820	1	1	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
863		Santa Catalina		1824	1	3	2	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
864		Monte Sina??		1825	1	3	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
865		Jeric??		1824	1	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
866		luz divina		1826	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
867		Yuyapichis		1825	1	0	8	3	0					0	\N	\N	\N	\N	\N	\N	\N	\N	\N
960		CHULQUI		886	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
869		Cumbre Alegre		1826	1	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
870		Santa Rosa / Misquipata	Refer: Hno. Marcos Camayo.	1125	1	0	2	1	0	112	Carretera a Santa Rosa s/n.			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
871		Liguasnillo		1541	2	0	8	3	0		Liguancillo			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
872		Chupaca	Ref: Cancha Sint??tica ???El Golazo???.	1119	1	0	2	1	0	97	Jr. Antonio Raimondi 205 casi Av. Eternidad.			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
874		1ro de Diciembre		1267	1	3	2	1	3		mz H lt. 5, AA.HH. 1?? DE DICIEMBRE			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1254		Limoncarro		1171	0	1	9	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1155		LAS PALMAS		1092	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1404		Tumbaden		666	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
880		Cercado - Succhapampa		658	2	0	8	3	0		Cercado - Succhapampa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
881	\N	Sotopampa	\N	\N	2	0	8	3	0		Sotopampa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
882		San Mart??n de Pangoa		1097	1	1	1	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
884	7934408	Costa Azul	Paradero 8  Sector Angamos	683	1	0	9	1	3		Av. La Peruanidad  Mz. P  Lt. 11			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
887		Chontali		626	2	1	8	0	0	\N	Chontali			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
888	\N	Hualatan	\N	\N	2	1	8	0	0	\N	Hualatan			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
889		Agua Azul		626	4	1	1	0	0	\N	AGUA AZUL			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
890		Colasay		627	3	0	8	0	0	\N	Colasay			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
892		Sallique		632	3	0	8	3	0		Sallique			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
891		EMINEL CHANCAY	ENTRANDO POR LECHON DORADO - AL COSTADO DE CLINICA	1329	1	2	9	5	1	45 000	MOLINO HOSPITAL LT. 19 	$75 000		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
894		Silacot	A treinta minutos de Contumaz??	598	2	1	1	0	0	\N	Caser??o Silacot			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1205		Chachapoyas		224	0	1	9	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
897		Cristal Grande		603	3	1	5	0	0	\N	Cerca del Caser??o: \\"La Succha\\"			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1204		Cambio Puente		224	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
899		Calate		598	3	1	5	0	0	\N	Calate - yendo a Chilete			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1226		Las Huertas		554	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
901		Progreso (Tiopampa)		1192	2	1	1	0	0	\N	TIOPAMPA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
902		Los Arenales de la Pradera		1222	2	1	1	2	1	90	Mz. I Lt. 1 - LOS ARENALES DE LA PRADERA	5000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1223		Tablacucho	San Felipe	1204	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
903		Agua Blanca	Dist. Huamachuco	1188	3	1	5	0	0	\N	Caser??o Agua Blanca			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
904		Cruz Blanca		1188	3	1	5	0	0	\N	Barrio Cruz Blanca			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
905		Habana		1705	1	2	5	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
906		Jeric??		1707	2	3	3	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1411		ZAPOTAL		1153	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
912		Soritor 		1707	1	2	9	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
913	\N	Espinar	\N	\N	3	1	5	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
914	\N	URUBAMBA	\N	\N	3	1	5	0	0	\N				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
916		La Totora		643	2	1	5	0	0	\N	LA TOTORA			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
917		Clementina Peralta		1132	2	3	7	1	3		AA. HH. Clementina Peralta			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1062		Remigio Silva		1211	0	0	0	3	0		La Paz  N?? 396			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1177		Motupe		1243	0	0	0	0	0	\N	Motupe	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1064		El Porvenir		54	0	0	0	0	0	\N	El Porvenir	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
925		Ampliaci??n Ciudad de Dios-El Porvenir	por Paradero Final de Micros Cortijo: C1, C2, C3	1129	0	1	5	1	3	280.00	AA. HH. Ampliaci??n Ciudad de Dios-Alto Trujillo B?? 10 (Ex AA. HH. T??pac Amaru)			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1342		Chala		360	0	0	0	0	0	\N	AAHH Progreso MZ 8 Lt 35	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1168		Santa Elena-Nueva Esperanza		1530	0	0	0	0	0	\N	entre santa elena y nueva esperanza-Partidor	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
929		Calderon		1549	0	1	5	2	1		Calderon			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
930		corire		360	0	0	0	0	0	\N	pedregal aplau 	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
931		Pedrgal Mages	Fundo Huacan  el Bosque	360	0	2	6	1	3	300	Mz. 05 Lte. 16	6000.00		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
932		Chuquibamba	el vallesito	360	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
933		Chala		360	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1187		San Miguel de queroz		905	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1399		Nuevo Ja??n		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1054		El Salvador		1153	0	0	0	0	0	\N	Dist. Chep??n	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1330		PUEBLO LIBRE		1748	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1326		EL LIMON		1709	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
934		El Porvenir	Colegio San Mateo	1129	0	2	9	2	1	1650.29	Francisco de Zela N?? 1551	709,588.52		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1403		Muy Finca PntoCuatro	Entrada punto cuatro	1241	0	0	0	0	0	\N	Marginal	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
935		Victor Ra??l del Porvenir		1129	0	2	2	2	2	155.19	Mz: 14, Lote: 9, Etapa II - El Porvenir			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
936		Gran Chim??	cerca a la Plaza de Armas del lugar	1129	0	2	9	2	1	177.73	Independencia N?? 1912 - El Porvenir	61,619.55		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1335		KM 45 Valle del Pavo		1750	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1413		San Alejandro		1832	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1333		BARRANCA		1749	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1188		Pachas		908	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1117		China Alta		624	0	0	0	0	0	\N	China Alta	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1159		Balsas		3	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
941		RIMAC	Altura     Cuadra 2 de Tarapac??	1276	0	2	9	5	1		Calle Andres Corzo N?? 644 Villacmpa - Rimac - Lima			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
942		Cat??n		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1374		MU??APUCRO		260	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1377		San Jose de Quero	Refer: Restaurante \\"El Timoncito\\"	1046	0	0	0	0	0	\N	San Jose de Quero	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1378		Penal de Huamancaca	Av. 28 de Julio s/n.	1123	0	0	0	0	0	\N	Penal de Huamancaca.	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1379		ZUNGARO		1831	0	0	0	0	0	\N	ZUNGARO	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1217		Alto Trujillo (Barrio 1-A)		1129	0	2	9	2	3		MZ. R Lt. 25 Alto Trujillo			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1246		Jos?? Sabogal 		649	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1176		Mochum??		1241	0	0	0	0	0	\N	Mochum??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1172		Batan Grande		1235	0	0	0	0	0	\N	Batan Grande	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1173		Illimo		1239	0	0	0	0	0	\N	Illimo	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1182		Pueblo Nuevo		1814	0	0	0	0	0	\N	pueblo nuevo	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1190		LEGLISH		905	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1407		Jauja		1054	0	0	5	1	0	210				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1371		Nuevo Huaycho 		1192	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
977		El Sienque		603	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
976		Napaty		1092	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
979		Vision El R??o		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
959		MACARCANCHA		1507	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1199		Querripe		1168	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1203		LA HACIENDA		1258	0	0	0	0	0	\N	PARQUE LA HACIENDA	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
981		El Mar??n		601	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1035		CHIRIACO		26	0	0	0	4	0		CHIRIACO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
953		MISION	FALTAN   TRASLADAR	1249	0	0	0	0	0	\N	MISI??N CENTRAL	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
954		TRES  REGIONES		1273	0	2	8	3	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1302		ALIANZA		1433	0	0	0	0	0				ya no existe a sido invadido y por falta de documentos no se a puede recuperar	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
971		Nuevo Nazareth		1779	0	3	2	1	3					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
972		3 de mayo		1779	0	0	8	3	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
973		puente santa rosa		1775	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
974		Chillia	Dist. Chillia - Prov. Pat??z	1177	0	0	0	0	0	\N	Distrito de Chillia	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
975		Tayabamba	Dist. Tayabamba - Prov. Pat??z	1175	0	0	0	0	0	\N	Distrito de Tayabamba	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1383		QUIVINCHAN		562	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1362		SHEPTE		1739	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1361		SAPOSOA		1720	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
982		Totorillas		601	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
983		Casm??n		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
984		Chuquimango		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
985		Altamisas		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
986		Las Rosas		601	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
987		Cholol Alto		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
988		Cholol Bajo		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
989		La Queserilla		601	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
991		San Isidro		601	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
992		Tupo??e		604	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
994		Lirio Nuevo		603	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1222		Quesera		600	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1005		Santa de Cosp??n		554	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1006		Santo Domingo		554	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1007		Siracat		554	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1008		Sunchubamba		554	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1009		Pampas de San Isidro		1204	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1354		JUANJUI	ESQUINA COLEGIO HEROES DEL CENEPA	1737	0	0	0	0	0	\N	PROLONGACION LA MERCED CDRA 3	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1353		HUICUNGO		1739	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1351		CU??UMBUZA		1738	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1350		CRUCE PRADA		1737	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1349		CENTRO AMERICA		1710	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1245		La Quinua		574	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1164		Santo Tomas		1420	0	0	1	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1370		Huaycho Viejo		1189	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1247		Colpilla		574	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1243		Chuquibamba		564	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1251		Pacasmayo Centro		1173	0	0	9	2	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1316		MARONA		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1410		Tamburco		259	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1393		Julcan		1156	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1394		Pedregal		1137	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1390		Otuzco		1160	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1408		Santa Rosa		1224	0	0	0	0	0	\N	Carretera central	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1016		La Florida		1755	0	0	5	2	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1279		Yerba Buena		621	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1373	042523529	IGLESIA DE LA ASOCIACION	COLEGIO SAN MATEO	1761	0	0	0	0	0	\N	RICARDO PALMA 1076 EL HUYCO	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1363		SHITARI		1710	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1165		Fila Alta		624	0	0	0	0	0	\N	Fila Alta	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1386		Chochoconda		1188	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1282		El Mote		598	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1130		A??O NUEVO	PARADERO PARQUE	1258	0	0	0	0	0	\N	JR. JORGE IGNACIO N?? 310	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1180		Sandial		1235	0	0	0	0	0	\N	Sandial	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1179		Pomalca		1228	0	0	0	0	0	\N	C.P. La Uni??n	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1175		Lambayeque		1237	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1171		San Mateo		1139	0	0	0	0	0	\N	Chocope	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1201		ENAVE		1147	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1409		C.P Jelic		643	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1375		IGLESIA DE MISI??N		1128	0	2	6	6	1		SABOGAL 454			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1026		NV. ESPERANZA (Ponazapa)		1735	0	1	4	2	3		Caser??o Ponazapa			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1418		Pampayanamayo		1694	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1158		Tres de Mayo		570	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1423		Chejani		1690	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1420		Ilave		1641	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1169		Callayuc		607	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1068		El Balcon		79	0	1	0	2	1		El Balcon			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1069		Diamante Alto		79	0	2	1	2	1	300	Diamante Alto	800		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1067		Bagua Grande		78	0	1	6	2	1	300	las delicias N?? 495	7200		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1028		Cruz del Norte San Benito 		1254	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1406		Rodeopampa Baja		656	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1385		Catud??n		598	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1389		Canibamba		1169	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1047		Salinar B	Cruce Membrillar	1140	0	0	0	0	0	\N	Pampa Hermosa-Salinar Bajo	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1346		AUCARARCA		1712	0	0	0	0	0	\N	CARRETERA MARGINAL	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1364		SHAMBUYACO		1749	0	3	1	0	1	200				1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1309		ALTO GERILLO		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1412		Buenos Aires / Chupaca		1119	0	0	0	0	0	\N	Cruce de Huachac	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1366		ALFONZO UGARTE		1742	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1034		Nuevo Huancabamba		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1065		Selchocuzco		54	0	0	0	0	0	\N	Selchocuzco	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1303		MIGUEL GRAU KM.40		1433	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1038		San Carlos		1	0	0	0	4	0		San Carglos			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1039		Shipata		46	0	2	5	2	3		Shipata			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1040		NUEVO PROGRESO / MATAPALO		1818	0	3	5	2	1		NUEVO PROGRESO			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1415		Pueblo Libre		1755	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1221		Santiago de Chuco		1196	0	0	0	0	0	\N	Calle Luis de la Puente Uceda 1801 c/esq. Tungsteno	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1115		Udima		655	0	0	0	0	0	\N	Udima	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1116		Monte Cruz		1217	0	0	0	3	0		MONTE CRUZ			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1055		Penal El Milagro		1132	0	0	0	0	0	\N	Dist. La Esperanza	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1096		Los Conquistadores		232	0	0	0	0	0	\N	AA. HH. Los Conquistadores - Nuevo Chimbote	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1095		AISLADOS		1092	0	0	0	0	0	\N	VILLA SOL	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1318		RAMIREZ		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1071		La Florida		78	0	0	0	3	0		La Florida			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1072		La Uni??n		79	0	0	0	0	0	\N	La Uni??n	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1073		Quebrada Seca		78	0	1	0	2	1		Quebrada Seca			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1074		El Salao		82	0	2	0	2	3		El Salao			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1075		San Isidro		47	0	1	0	2	1		San isidro			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1076		Tambolic		82	0	1	1	2	1	493	Tambolic	5000		1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1299		ALTO PERU		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1080		San Jorge		551	0	0	0	0	0	\N	C.P. San Jorge, Dist. Cajamarca	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1422	957459877	Desaguadero		1	1	0	0	0	0	44	Jr. Ricardo Palma 509	44	NINGUNA	1	1	1	ESTRUCTURA FUERTE	4444	1	6	6	8	9
1298		ZANANGO		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1297		ZAPATERO		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1296		NV. JAEN		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1286		AYACUCHO		440	0	0	0	0	0	\N	AA.HH. COMPLEJO ARTESANAL MZ. E LT. 3	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1287		Alto Trujillo Barrio 7C		1129	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1086		Lech??n		598	0	0	0	0	0	\N	Caser??o Lech??n, Dist. y Prov. Contumaz??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1087		Lorito Huaz		551	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1088		Esterillas		598	0	0	0	0	0	\N	Caser??o Esterillas, Contumaz??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1265		Monte Alegre		650	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1090		Calani		562	0	0	0	0	0	\N	Caserio Calani, Dist. San Juan, Prov, Cajamarca	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1091		La Lucma		615	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1092		El Guayo		598	0	0	0	0	0	\N	C. P. El Guayo, Dist. y Prov. Contumaz??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1293		ALTO ROQUE		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1094		Aranmarca		562	0	0	0	0	0	\N	C.P. Aranmarca, Dist. San Juan, Prov. Cajamarca	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1369		PICOTA		1742	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1268		Pampa Dura		224	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1103		Ahijadero		601	0	0	0	0	0	\N	Pueblo de Ahijadero-Contumaz??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1104		Cascabamba \\"B\\"		598	0	0	0	0	0	\N	Cascabamba, Contumaz??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1227		San Antonio		1139	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1231		Shalar		1189	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1232		Cochabamba		1189	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1306		BARRANQUITA		1433	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1396		Alamo		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1109		V??ctor Ra??l de Vir??	preguntar en Nvo V??ctor R.de Vir?? Mz: J, Lote: 14	1208	0	2	5	4	3		MZ: 4, LOTE: 2, LOS PINOS - PARTE ALTA		PRESTADO POR LA FAMILIA INFANTES-SANDOVAL	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1111		Colpa-Lluychush	despu??s de Lluychush	109	0	0	3	1	0	180.00	Caser??o Colpa	200.00	se recibi?? como donaci??n un lote y una parte comprado por 200.00 nuevos soles al donante: Hn. Federico Portella	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1112		Huaraz		85	0	0	6	1	3				PENDIENTE: INSCRIPCION DE PREDIO EN MUNICIPALIDAD, EXONERAR E INAFECTAR DE IMPUESTOS PREVIO PAGOS RESPECTIVOS.	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1381		Miravalle		656	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1347		BAGAZAN		1740	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1118		Santa Elena		624	0	0	0	0	0	\N	Santa Elena	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1119		Chirinos Cordillera		637	0	0	0	0	0	\N	Chirinos Cordillera	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1120		ajosmayo		655	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1121		Los Olivos		1194	0	0	0	0	0	\N	Caser??o Nueva Esperanza	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1301		YURIMAGUAS		1433	0	3	9	2	1					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1206		Florencia de Mora (Baja)	Atr??s del colegio municipal	1130	0	2	9	2	3		Calle: 8 de Septiembre N?? 762			1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1276		Pabell??n Chico		656	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1272		Alto Per??		666	0	0	0	0	0	\N	Caser??o Alto Per??	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1270		Casma		139	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1345		ATAHUALPA		1740	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1300		NV ESPERANZA		1715	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1278		San Pablo		663	0	0	6	1	0					1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1233		Chir Chir		1194	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1122		Huabal		1171	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1123		Nueva Uni??n		74	0	0	0	0	0	\N	Caser??o Nueva Uni??n	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1124		Huaguil	Dist. Chugay, Prov. S??nchez Carri??n	1189	0	0	0	0	0	\N	Caserio Huaguil	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1125		Tiraca		1689	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1126		San Miguel de Phara		1690	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1127		Cocos Lanza	Pais Bolivia	1695	0	0	0	0	0	\N	Cocos Lanza - Bolivia	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1129		Progreso	MERCADO LA CUMBRE	1254	0	0	0	0	0	\N	jr. 3 de octubre N?? 323	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1131		COMAS	ESQUINA CON IGNACIO PRADO	1258	0	0	0	0	0	\N	jr. 28 de julio n?? 907	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1132	952646985	Parral 	INGRESO POR AV. TUPAC AMARU Y M??XICO	1258	0	0	0	0	0	\N	av. carabayllo 975  urb. el parral	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1133		ESMIRNA	MANCO INCA,  ALT. HOSPITAL LA SOLIDARIDAD - COMAS	1258	0	0	0	0	0	\N	C. 17 N?? 395 URB. CARABAILLO	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1134		ENRIQUE MILLA	COLEGIO ENRIQUE MILLA	1265	0	0	0	0	0	\N	MZ. 114 LT. 31 COMIT?? 6 - LOS OLIVOS	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1135		PRIMERA DE PRO	A 3 CUADRAS DEL PARADERO PRIMERA DE PRO PANAMERICA	1265	0	0	0	0	0	\N	JR. HONESTIDAD # 7951 PRO	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1136	5328063	LOS OLIVOS	CENTRO DE SALUD PRIMAVERA	1265	0	0	0	0	0	\N	C. LOS GUINDONES MZ. A  LT. 5  URB. VIRGEN DE LA PUERTA	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1137	6397430	NARANJAL	AV, MARA??ON  Y AV. UNIVERSITARIA	1265	0	0	0	0	0	\N	MZ. G LT. 26 ASOC. LOS PORTALES DEL NORTE	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1138	4209540	BELLAVISTA CALLAO		679	0	0	0	0	0	\N	mZ. E LT. 33 URB . CONFECCIONES MILITARES	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1140		DOMINICOS		1283	0	0	0	0	0	\N	mz. F LT. 7 LOS DOMINICOS SANTA ROSA	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1141		Huachis-Huari		156	0	0	0	0	0	\N	Distrito de Huachis - Huari	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1321		VALLE HERMOZO		1706	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1322		CALZADA		1704	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1323		JAZMINES		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1324		BELLAVISTA		1709	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1401		Sullaquiro		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1240		Cashapampa		551	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1313		EL SINAI		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1314		NV. SALINAS		1703	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1315		JEPELACIO		1706	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1259		Puente Olivares		1174	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1260		Alto Tamarindo		1171	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1261		Jag??ey		1174	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1262		Martha Ch??vez		1171	0	2	9	1	1				TERRENO DE UNA HECT??REA Y DEDIA APROX.	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1263		Hu??scar		1172	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1224		Lanche / San Felipe	San Felipe	1204	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1258		Verd??n		1174	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1327		LA LIBERTAD		1709	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1328		SAN JUAN se san hilarion		1709	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1142		Changomarca		606	0	0	0	0	0	\N	Changomarca	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1143		Chugur		606	0	0	0	0	0	\N	Chugur	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1144		Cochabamba		585	0	0	0	0	0	\N	Cochabamba	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1145		Cutervo		606	0	0	0	0	0	\N	Cutervo	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1146		La Merendana		606	0	0	0	0	0	\N	la merendana	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1147		La succha		606	0	0	0	0	0	\N	La Succha	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1148		Lanche		606	0	0	0	0	0	\N	Lanche	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1149		Llacancate		606	0	0	0	0	0	\N	Llacancate	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1150		Mamabamba		606	0	0	0	0	0	\N	Mamabamba	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1151		Payac		606	0	0	0	0	0	\N	Payac	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1414		San Juan de Potreros		1707	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
1421		Chijuyo Copapujo		1641	0	0	0	0	0	\N		\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N
2		Puente Piedra	Grifo Norte??o - PANAMERICANA NORTE	1273	1	2	4	5	1		Psje. San Miguel  Cdra. 1,  Mz. A , Lt. 2 			1	\N	\N	\N	\N	1	1	1	1	1
1426		San Pedro de Putina Punco		1	1	0	0	0	0	\N		\N	\N	1	1	1	\N	\N	1	1	1	3	5
1425	957459877	Puno		1594	1	0	0	0	0	44	Jr. Ricardo Palma 509	44	DD	1	1	1	ESTRUCTURA FUERTE	4444	1	13	5	7	8
1424	957459877	Camar??n		1694	1	0	0	0	0	44	Jr. Juan Vargas 405	\N	F	1	31	202	ESTRUCTURA FUERTE	4444	1	9	3	6	7
1427	957459877	Cabanillas		1	1	1	1	1	1	500	Jr. Ricardo Palma 509	\N	NINGUNA	1	1	1	ESTRUCTURA FUERTE	NRO	1	1	1	1	1
1428	\N	Gaitan	\N	0	1	0	0	\N	\N	\N		\N	\N	1	67	1064	\N	\N	1	15	7	9	10
1429	\N	C??cuta	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	10
1430	\N	Villa Del Rosario	\N	0	1	0	0	\N	\N	\N		\N	\N	1	64	1042	\N	\N	1	15	7	9	10
1431	\N	Lebrija	\N	0	4	0	0	\N	\N	\N		\N	\N	1	67	1102	\N	\N	1	15	7	9	10
1432	\N	Malaga	\N	0	4	0	0	\N	\N	\N		\N	\N	1	67	1105	\N	\N	1	15	7	9	10
1433	\N	Rionegro	\N	0	4	0	0	\N	\N	\N		\N	\N	1	47	341	\N	\N	1	15	7	9	10
1434	\N	Matanza	\N	0	4	0	0	\N	\N	\N		\N	\N	1	67	1106	\N	\N	1	15	7	9	10
1435	\N	Aburrido	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	10
1436	\N	Socorro	\N	0	4	0	0	\N	\N	\N		\N	\N	1	67	1129	\N	\N	1	15	7	9	10
1437	\N	Bucaramanga	\N	0	4	0	0	\N	\N	\N		\N	\N	1	67	1064	\N	\N	1	15	7	9	10
1438	\N	Los Patios	\N	0	4	0	0	\N	\N	\N		\N	\N	1	64	1026	\N	\N	1	15	7	9	10
1439	\N	Barrancabermeja	\N	0	1	0	0	\N	\N	\N		\N	\N	1	67	1068	\N	\N	1	15	7	9	11
1440	\N	San Pablo Bolivar	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	11
1441	\N	Santa Rosa Bolivar	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	11
1442	\N	Cimitarra	\N	0	2	0	0	\N	\N	\N		\N	\N	1	67	1077	\N	\N	1	15	7	9	11
1443	\N	El Guamo	\N	0	2	0	0	\N	\N	\N		\N	\N	1	50	438	\N	\N	1	15	7	9	11
1444	\N	San Juan	\N	0	2	0	0	\N	\N	\N		\N	\N	1	242	2964	\N	\N	1	15	7	9	11
1445	\N	La Gorgona	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	11
1446	\N	Puerto Wilches	\N	0	4	0	0	\N	\N	\N		\N	\N	1	67	1119	\N	\N	1	15	7	9	11
1447	\N	Montecarmelo	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	11
1448	\N	San Alberto	\N	0	1	0	0	\N	\N	\N		\N	\N	1	55	688	\N	\N	1	15	7	9	12
1449	\N	Trinidad	\N	0	1	0	0	\N	\N	\N		\N	\N	1	55	688	\N	\N	1	15	7	9	12
1450	\N	21 De Abril	\N	0	1	0	0	\N	\N	\N		\N	\N	1	55	688	\N	\N	1	15	7	9	12
1451	\N	Monserrate	\N	0	1	0	0	\N	\N	\N		\N	\N	1	55	688	\N	\N	1	15	7	9	12
1452	\N	Oca??a	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	12
1453	\N	Pailitas	\N	0	2	0	0	\N	\N	\N		\N	\N	1	55	683	\N	\N	1	15	7	9	12
1454	\N	Aguachica	\N	0	4	0	0	\N	\N	\N		\N	\N	1	55	688	\N	\N	1	15	7	9	12
1455	\N	Barranquilla	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	13
1456	\N	Valledupar	\N	0	1	0	0	\N	\N	\N		\N	\N	1	55	667	\N	\N	1	15	7	9	13
1457	\N	Cartagena	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	13
1458	\N	Pueblo Bello	\N	0	2	0	0	\N	\N	\N		\N	\N	1	55	685	\N	\N	1	15	7	9	13
1459	\N	Sabanalarga	\N	0	2	0	0	\N	\N	\N		\N	\N	1	47	342	\N	\N	1	15	7	9	13
1460	\N	Santa Marta	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	13
1461	\N	Santo Tomas	\N	0	2	0	0	\N	\N	\N		\N	\N	1	48	399	\N	\N	1	15	7	9	13
1462	\N	Sincelejo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	68	1138	\N	\N	1	15	7	9	14
1463	\N	Magangu??	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	14
1464	\N	Cerete	\N	0	2	0	0	\N	\N	\N		\N	\N	1	56	695	\N	\N	1	15	7	9	14
1465	\N	Monteria	\N	0	2	0	0	\N	\N	\N		\N	\N	1	56	692	\N	\N	1	15	7	9	14
1466	\N	San Gregorio	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	9	14
1467	\N	San Mateo	\N	0	2	0	0	\N	\N	\N		\N	\N	1	51	551	\N	\N	1	15	7	9	14
1468	\N	Pueblo Rico	\N	0	2	0	0	\N	\N	\N		\N	\N	1	66	1061	\N	\N	1	15	7	9	14
1469	\N	Providencia	\N	0	2	0	0	\N	\N	\N		\N	\N	1	63	989	\N	\N	1	15	7	9	14
1470	\N	Santana	\N	0	2	0	0	\N	\N	\N		\N	\N	1	51	554	\N	\N	1	15	7	9	14
1471	\N	Caucasia	\N	0	4	0	0	\N	\N	\N		\N	\N	1	47	291	\N	\N	1	15	7	9	14
1472	\N	Sogamoso	\N	0	1	0	0	\N	\N	\N		\N	\N	1	51	564	\N	\N	1	15	7	10	15
1473	\N	Ubate	\N	0	1	0	0	\N	\N	\N		\N	\N	1	57	817	\N	\N	1	15	7	10	15
1474	\N	Barbosa-Santana	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	15
1475	\N	Garagoa-Juntas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	15
1476	\N	Chiquinquir??	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	15
1477	\N	Bravo P??ez	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	16
1478	\N	Kennedy	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	16
1479	\N	El Portal	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	16
1480	\N	Leticia	\N	0	2	0	0	\N	\N	\N		\N	\N	1	75	1273	\N	\N	1	15	7	10	16
1481	\N	Caparrapi	\N	0	2	0	0	\N	\N	\N		\N	\N	1	57	729	\N	\N	1	15	7	10	16
1482	\N	Viota	\N	0	4	0	0	\N	\N	\N		\N	\N	1	57	825	\N	\N	1	15	7	10	16
1483	\N	Cundinamarca	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	16
1484	\N	Quebradanegra	\N	0	4	0	0	\N	\N	\N		\N	\N	1	57	785	\N	\N	1	15	7	10	16
1485	\N	La Mesa	\N	0	4	0	0	\N	\N	\N		\N	\N	1	57	764	\N	\N	1	15	7	10	16
1486	\N	Fusagasuga	\N	0	1	0	0	\N	\N	\N		\N	\N	1	57	747	\N	\N	1	15	7	10	17
1487	\N	Girardot	\N	0	1	0	0	\N	\N	\N		\N	\N	1	57	752	\N	\N	1	15	7	10	17
1488	\N	Ibagu??	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	17
1489	\N	San Bernardo	\N	0	2	0	0	\N	\N	\N		\N	\N	1	57	791	\N	\N	1	15	7	10	17
1490	\N	Icononzo	\N	0	2	0	0	\N	\N	\N		\N	\N	1	69	1180	\N	\N	1	15	7	10	17
1491	\N	Guamitos	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	17
1492	\N	Varsovia	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	17
1493	\N	Pueblo Nuevo	\N	0	2	0	0	\N	\N	\N		\N	\N	1	56	707	\N	\N	1	15	7	10	17
1494	\N	Guamo	\N	0	2	0	0	\N	\N	\N		\N	\N	1	69	1177	\N	\N	1	15	7	10	17
1495	\N	Los Alpes	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	10	17
1496	\N	Villavicencio	\N	0	1	0	0	\N	\N	\N		\N	\N	1	62	925	\N	\N	1	15	7	10	18
1497	\N	Acacias	\N	0	1	0	0	\N	\N	\N		\N	\N	1	62	926	\N	\N	1	15	7	10	18
1498	\N	Granada	\N	0	1	0	0	\N	\N	\N		\N	\N	1	47	309	\N	\N	1	15	7	10	18
1499	\N	Tame	\N	0	1	0	0	\N	\N	\N		\N	\N	1	71	1244	\N	\N	1	15	7	10	18
1500	\N	Fortul	\N	0	1	0	0	\N	\N	\N		\N	\N	1	71	1241	\N	\N	1	15	7	10	18
1501	\N	Saravena	\N	0	1	0	0	\N	\N	\N		\N	\N	1	71	1243	\N	\N	1	15	7	10	18
1502	\N	Aguazul	\N	0	2	0	0	\N	\N	\N		\N	\N	1	72	1246	\N	\N	1	15	7	10	18
1503	\N	Turbo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	47	369	\N	\N	1	15	7	11	19
1504	\N	Apartad??	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	19
1505	\N	Medell??n	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	19
1506	\N	Kennedy	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	19
1507	\N	Don Matias	\N	0	1	0	0	\N	\N	\N		\N	\N	1	47	299	\N	\N	1	15	7	11	19
1508	\N	San Roque	\N	0	1	0	0	\N	\N	\N		\N	\N	1	47	355	\N	\N	1	15	7	11	19
1509	\N	Quibd??	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	19
1510	\N	Armas	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	19
1511	\N	Peque	\N	0	4	0	0	\N	\N	\N		\N	\N	1	47	334	\N	\N	1	15	7	11	19
1512	\N	Santa Fe De Antioquia	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	19
1513	\N	Lejanias	\N	0	4	0	0	\N	\N	\N		\N	\N	1	62	940	\N	\N	1	15	7	11	19
1514	\N	Dosquebradas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	20
1515	\N	Cartago	\N	0	1	0	0	\N	\N	\N		\N	\N	1	70	1212	\N	\N	1	15	7	11	20
1516	\N	Alcal??	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	20
1517	\N	Tebaida	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	20
1518	\N	Calarc??	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	20
1519	\N	Manizales	\N	0	1	0	0	\N	\N	\N		\N	\N	1	52	590	\N	\N	1	15	7	11	20
1520	\N	Aranzazu	\N	0	2	0	0	\N	\N	\N		\N	\N	1	52	593	\N	\N	1	15	7	11	20
1521	\N	Manzanares	\N	0	2	0	0	\N	\N	\N		\N	\N	1	52	599	\N	\N	1	15	7	11	20
1522	\N	Santa Rosa	\N	0	1	0	0	\N	\N	\N		\N	\N	1	50	460	\N	\N	1	15	7	11	20
1523	\N	Neira	\N	0	2	0	0	\N	\N	\N		\N	\N	1	52	603	\N	\N	1	15	7	11	20
1524	\N	Quinchia	\N	0	1	0	0	\N	\N	\N		\N	\N	1	66	1062	\N	\N	1	15	7	11	21
1525	\N	Insetes	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	21
1526	\N	Anserma	\N	0	1	0	0	\N	\N	\N		\N	\N	1	52	592	\N	\N	1	15	7	11	21
1527	\N	Irra	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	21
1528	\N	Cali	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1529	\N	Tulu??	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1530	\N	Morroplancho	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1531	\N	La Union	\N	0	1	0	0	\N	\N	\N		\N	\N	1	4	42	\N	\N	1	15	7	11	22
1532	\N	Zarzal	\N	0	4	0	0	\N	\N	\N		\N	\N	1	70	1237	\N	\N	1	15	7	11	22
1533	\N	Toro	\N	0	4	0	0	\N	\N	\N		\N	\N	1	70	1229	\N	\N	1	15	7	11	22
1534	\N	El Cremal	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1535	\N	Campoalegre	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1536	\N	Corinto	\N	0	2	0	0	\N	\N	\N		\N	\N	1	54	639	\N	\N	1	15	7	11	22
1537	\N	Palmira	\N	0	4	0	0	\N	\N	\N		\N	\N	1	70	1224	\N	\N	1	15	7	11	22
1538	\N	Jamundi	\N	0	4	0	0	\N	\N	\N		\N	\N	1	70	1221	\N	\N	1	15	7	11	22
1539	\N	Yumbo	\N	0	4	0	0	\N	\N	\N		\N	\N	1	70	1236	\N	\N	1	15	7	11	22
1540	\N	Puente Velez	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1541	\N	Tocota	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1542	\N	Melenas	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1543	\N	Salonica	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1544	\N	Puente Loro	\N	0	4	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	11	22
1545	\N	Neiva	\N	0	1	0	0	\N	\N	\N		\N	\N	1	59	854	\N	\N	1	15	7	12	23
1546	\N	Planadas	\N	0	2	0	0	\N	\N	\N		\N	\N	1	69	1190	\N	\N	1	15	7	12	23
1547	\N	Garzon	\N	0	1	0	0	\N	\N	\N		\N	\N	1	59	864	\N	\N	1	15	7	12	23
1548	\N	Acevedo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	59	855	\N	\N	1	15	7	12	23
1549	\N	Pitalito	\N	0	1	0	0	\N	\N	\N		\N	\N	1	59	876	\N	\N	1	15	7	12	23
1550	\N	Algeciras	\N	0	1	0	0	\N	\N	\N		\N	\N	1	59	858	\N	\N	1	15	7	12	23
1551	\N	Piedramarcada	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	12	23
1552	\N	Palermo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	59	874	\N	\N	1	15	7	12	23
1553	\N	Canoas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	343	9874	\N	\N	1	15	7	12	23
1554	\N	La Plata	\N	0	1	0	0	\N	\N	\N		\N	\N	1	59	870	\N	\N	1	15	7	12	23
1555	\N	Guayabal	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	12	23
1556	\N	Santana	\N	0	4	0	0	\N	\N	\N		\N	\N	1	51	554	\N	\N	1	15	7	12	23
1557	\N	Florencia	\N	0	1	0	0	\N	\N	\N		\N	\N	1	53	617	\N	\N	1	15	7	12	24
1558	\N	Curillo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	53	621	\N	\N	1	15	7	12	24
1559	\N	Valpara??so	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	12	24
1560	\N	San Vicente	\N	0	1	0	0	\N	\N	\N		\N	\N	1	47	356	\N	\N	1	15	7	12	24
1561	\N	La Macarena	\N	0	1	0	0	\N	\N	\N		\N	\N	1	62	938	\N	\N	1	15	7	12	24
1562	\N	San Vicente	\N	0	1	0	0	\N	\N	\N		\N	\N	1	47	356	\N	\N	1	15	7	12	24
1563	\N	Belen	\N	0	2	0	0	\N	\N	\N		\N	\N	1	51	474	\N	\N	1	15	7	12	24
1564	\N	Mocoa	\N	0	1	0	0	\N	\N	\N		\N	\N	1	73	1262	\N	\N	1	15	7	12	25
1565	\N	Orito	\N	0	1	0	0	\N	\N	\N		\N	\N	1	73	1264	\N	\N	1	15	7	12	25
1566	\N	La Hormiga	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	12	25
1567	\N	Puerto Leguizamo	\N	0	2	0	0	\N	\N	\N		\N	\N	1	73	1268	\N	\N	1	15	7	12	25
1568	\N	Perlas	\N	0	2	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	12	25
1569	\N	Popayan	\N	0	1	0	0	\N	\N	\N		\N	\N	1	54	632	\N	\N	1	15	7	12	26
1570	\N	Pasto	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	15	7	12	26
1571	\N	El Llano	\N	0	1	0	0	\N	\N	\N		\N	\N	1	268	3251	\N	\N	1	15	7	12	26
1572	\N	San Felipe	\N	0	1	0	0	\N	\N	\N		\N	\N	1	76	1284	\N	\N	1	15	7	12	26
1573	\N	Ambato	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1574	\N	Cevallos	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1575	\N	Cojimies	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1576	\N	El Valle	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1577	\N	Esmeraldas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1578	\N	Golondrinas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1579	\N	Ibarra	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1580	\N	Juan Eulogio	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1581	\N	La Concordia	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1582	\N	La Magdalena	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1583	\N	Las Mercedes	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1584	\N	Monte Bello	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1585	\N	Pastocalle	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1586	\N	Pimampiro	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1587	\N	Puerto Quito	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1588	\N	Puerto Rico	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1589	\N	Quero	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1590	\N	Tabacundo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1591	\N	Tulc??n	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1592	\N	Unidad Nacional	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	27
1593	\N	Babahoyo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1594	\N	Bah??a	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1595	\N	Chone	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1596	\N	Dur??n	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1597	\N	El Deseo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1598	\N	Guabito	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1599	\N	Guasmo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1600	\N	Guayaquil	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1601	\N	La Man??	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1602	\N	Libertad	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1603	\N	Manta	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1604	\N	Mata de Cacao	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1605	\N	Portoviejo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1606	\N	Quevedo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1607	\N	Ventanas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	28
1608	\N	Arenillas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1609	\N	Nueva Unida Sur	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1610	\N	Catamayo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1611	\N	Cuenca	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1612	\N	Cumbe	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1613	\N	Huaquillas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1614	\N	Km 31	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1615	\N	Loja	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1616	\N	Machala	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1617	\N	Naranjito	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1618	\N	Reyes Vega	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1619	\N	Torres Causana	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1620	\N	Vilcabamba	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	29
1621	\N	Coca	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	30
1622	\N	Conambo	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	30
1623	\N	Joya de los Sachas	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	30
1624	\N	Lago Agrio	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	30
1625	\N	Las Mercedes	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	30
1626	\N	Loreto	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	30
1627	\N	Shushufindi	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	30
1628	\N	Santa Cruz	\N	0	1	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	3	8	13	31
1629	\N	Montevideo	\N	0	1	0	0	\N	\N	\N	Comercio 2286 esquina Agust??n Sosa	\N	\N	1	0	0	\N	\N	1	7	9	14	32
1630	\N	Delta	\N	0	1	0	0	\N	\N	\N	Samoa manzana 76 solar 28	\N	\N	1	0	0	\N	\N	1	7	9	14	33
1631	\N	Pando	\N	0	1	0	0	\N	\N	\N	Camino las Piedritas s/n ruta 7 km 32,5	\N	\N	1	0	0	\N	\N	1	7	9	14	34
1632	\N	Rosario	\N	0	1	0	0	\N	\N	\N	Grito de Asencio n?? 170	\N	\N	1	0	0	\N	\N	1	7	9	14	35
1633	\N	Chimaltenango	\N	0	1	0	0	\N	\N	\N	07 avenida Sociedad Mision, zona 8,  Chimaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1634	\N	Jutiapa	\N	0	1	0	0	\N	\N	\N	zona 3 de Jutiapa	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1635	\N	Campo Comapa	\N	0	5	0	0	\N	\N	\N	Aldea El Carrizal, Comapa Jutiapa	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1636	\N	Campo de San Luis Jilotepeque	\N	0	5	0	0	\N	\N	\N	Aldea Los Olivos San Luis Jilotepeque Jalapa.	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1637	\N	Campo San Diego	\N	0	5	0	0	\N	\N	\N	Aldea Los Olivos San Luis Jilotepeque Jalapa.	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1638	\N	La Repegua	\N	0	1	0	0	\N	\N	\N	Colonia la Repegua,Santo Tom??s de Castilla, Puerto Barrios  Izabal	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1639	\N	Morales	\N	0	1	0	0	\N	\N	\N	Colonia Santa Barbara, Morales Izabal	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1640	\N	Placa I	\N	0	1	0	0	\N	\N	\N	Placa uno  entre rios puerto barrios izabal	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1641	\N	San Jos?? Pinula	\N	0	1	0	0	\N	\N	\N	Sector 1 Lote 14 Los achotes Aldea El Platanar	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1642	\N	Villa Nueva	\N	0	1	0	0	\N	\N	\N	0 avenida "D" 1-59 zona 6, colonia herores de villa nueva	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1643	\N	Zona 18	\N	0	1	0	0	\N	\N	\N	Lote No.46, Seccion el Mirador, Colonia las ilusiones, zona 18	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1644	\N	Zona 7	\N	0	1	0	0	\N	\N	\N	9a. Calle 3-24 zona 7 colonia land??var	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1645	\N	Zona 2	\N	0	1	0	0	\N	\N	\N	8 av  0-62 zona 2 barrio moderno	\N	\N	1	0	0	\N	\N	1	19	10	15	35
1646	\N	Coatepeque	\N	0	1	0	0	\N	\N	\N	9. avenida 8-05 zona 4, Barrio Candelaria, Coatepeque Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1647	\N	Campo Finca la fe	\N	0	5	0	0	\N	\N	\N	Colonia de la Reforma, departamento de San Marcos	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1648	\N	Las Trochas	\N	0	1	0	0	\N	\N	\N	Trocha 2 calle vieja nueva concepci??n, Escuintla	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1649	\N	Pueblo Nuevo	\N	0	1	0	0	\N	\N	\N	Pueblo Nuevo Suchitep??quez, cant??n el Mangal zona 0 calle principal.	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1650	\N	Puerto de San Jos??	\N	0	1	0	0	\N	\N	\N	7 Calle Lote 15 Nazareth Pe??ate, Puerto San Jose	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1651	\N	Reposo	\N	0	1	0	0	\N	\N	\N	Parselamiento el Reposo sector B parsela B-46,G??nova costacuca, Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1652	\N	Tec??n Um??n	\N	0	1	0	0	\N	\N	\N	12 calle 3 y 4 ave. Zina 3. Colonia La Verde, Tecun Uman San Marcos	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1653	\N	Tiquisate	\N	0	1	0	0	\N	\N	\N	12 calle 4-14 zona 2, Tiquisate	\N	\N	1	0	0	\N	\N	1	19	10	15	36
1654	\N	Cob??n	\N	0	1	0	0	\N	\N	\N	10 avenida 2-70 zona 3, Barrio San Juan Acal??, Cob??n, Alta Verapaz	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1655	\N	Campo las Cruces P??ten	\N	0	5	0	0	\N	\N	\N	Municipio de Dolores Peten	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1656	\N	Miramar	\N	0	1	0	0	\N	\N	\N	Miramar lote 1 Panz??s Alta Verapaz	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1657	\N	Naranjales	\N	0	1	0	0	\N	\N	\N	Finca los Naranjales Municipio de Senah?? Alta Verapaz.	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1658	\N	Playa Grande	\N	0	1	0	0	\N	\N	\N	Lote 486 zona 2 Playa Grande Ixc??n Quiche.	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1659	\N	Campo P??ptun	\N	0	5	0	0	\N	\N	\N	aldea popt??n, Pet??n	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1660	\N	Rax??n S.M. Panzos	\N	0	1	0	0	\N	\N	\N	Parcelamiento Raxon San, Marcos municipio de Panz??s Alta verapaz\n\nMarcos municipio de Panz??s Alta verapaz\n\nParcelamiento Raxon San \n\nMarcos municipio de Panz??s Alta verapaz\n\nParcelamiento Raxon San \n\nMarcos municipio de Panz??s Alta verapaz	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1661	\N	Roberto Barrios	\N	0	1	0	0	\N	\N	\N	Palenque Chiapas, Roberto Barrios mexico.	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1662	\N	Salacuin	\N	0	1	0	0	\N	\N	\N	Sector 3, Aldea salacuim coban, Alta Verapaz.	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1663	\N	San Benito	\N	0	1	0	0	\N	\N	\N	Calzada Virgilio Rodriguez Macal, Barrio 3 de Abril, San Benito Pet??n	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1664	\N	San Vicente	\N	0	1	0	0	\N	\N	\N	Caser??o San Vicente 2 Municipio de la Tinta Alta Verapaz.	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1665	\N	Teleman	\N	0	1	0	0	\N	\N	\N	Aldea teleman municipio de panzos A V .barrio el centro	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1666	\N	Trinidad	\N	0	1	0	0	\N	\N	\N	Colonia la Trinidad II carcha, Alta Verapaz	\N	\N	1	0	0	\N	\N	1	19	10	15	37
1667	\N	El Mirador	\N	0	1	0	0	\N	\N	\N	Aldea Nueva San Antonio, de San Carlos Sija, Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1668	\N	Quetzaltenango zona 3	\N	0	1	0	0	\N	\N	\N	13 avenida "A" 8-42 Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1669	\N	Quetzaltenango zona 5	\N	0	1	0	0	\N	\N	\N	Diagonal 15, 7-68 zona 5 Quetzaltenango.	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1670	\N	Rachoaquel	\N	0	1	0	0	\N	\N	\N	Chuiaj caser??o rachoaquel, aldea xequemey??, municipio de momostenango, dpto. de Totonicapan	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1671	\N	San Carlos Sija	\N	0	1	0	0	\N	\N	\N	Aldea Chuicabal, Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1672	\N	Campo Pachute	\N	0	5	0	0	\N	\N	\N	Aldea Chuicabal, Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1673	\N	Campo Sibilia	\N	0	5	0	0	\N	\N	\N	Aldea Chuicabal, Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1674	\N	Campo Chuicabal	\N	0	5	0	0	\N	\N	\N	Aldea Chiucabal, municipio de sibilia departamento de Quetzaltenango	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1675	\N	San Ram??n	\N	0	1	0	0	\N	\N	\N	Cant??n San Ram??n,  San Crist??bal Totonicapan	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1676	\N	Totonicap??n	\N	0	1	0	0	\N	\N	\N	10 avenida Final zona 3 (por los ba??os antiguos)Totonicapan Totonicapan	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1677	\N	Xexacmalja	\N	0	1	0	0	\N	\N	\N	Canton Xesacmalja, sector 1 frente a la escuela, Totonicapan, Totonicapan	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1678	\N	Xetena	\N	0	1	0	0	\N	\N	\N	Carretera San vicente Nuevabaj (enfrente de la gasolina), Totonicapan, Totonicapan	\N	\N	1	0	0	\N	\N	1	19	10	15	38
1679	\N	Campo de Solol??	\N	0	5	0	0	\N	\N	\N		\N	\N	1	0	0	\N	\N	1	19	10	15	39
1680	\N	Chich??	\N	0	1	0	0	\N	\N	\N	Barrio la Joya, Chich?? Quich??	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1681	\N	Chichicastenango	\N	0	1	0	0	\N	\N	\N	Km. 148 Chulumal primero chichicastenango, Quich??	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1682	\N	Chiul	\N	0	1	0	0	\N	\N	\N	Aldea Chiul (frente a una farmacia municio), Cun??n Quiche	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1683	\N	El Mamaj	\N	0	1	0	0	\N	\N	\N	Canton Mamaj Aldea Chujuyub, Santa Cruz del Quiche .	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1684	\N	Las Minas	\N	0	1	0	0	\N	\N	\N	Canton las minas aldea chujuyub, departamento del quiche.	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1685	\N	Nebaj	\N	0	1	0	0	\N	\N	\N	Canton jactzal Nebaj el Quiche , Calle que va al rastro\nCalle que va al rastro	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1686	\N	Salinas	\N	0	1	0	0	\N	\N	\N	Segundo centro, Salinas magdalenas sacapulas, Quich??	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1687	\N	Santa Cruz del Quich??	\N	0	1	0	0	\N	\N	\N	3 avenida 2 calle zona 1, Santa Cruz del Quich??	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1688	\N	Santa Elena	\N	0	1	0	0	\N	\N	\N	Canton Mixcolaj??, municipio de San Andr??s Sajcabaj??, departamento de Quich??	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1689	\N	Tierra Caliente	\N	0	1	0	0	\N	\N	\N	Cant??n Los Reyes, Aldea chujuyub el Quich??	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1690	\N	Xatinap I	\N	0	1	0	0	\N	\N	\N	El Puente Xatinap Primero, Quich??	\N	\N	1	0	0	\N	\N	1	19	10	15	39
1691	\N	Alto Hospicio	\N	0	0	0	0	\N	\N	\N	Calle Alemania Mz 94 Sitio 7  Sector la Pampa	\N	\N	1	0	0	\N	\N	1	14	11	16	40
1692	\N	Calama	\N	0	0	0	0	\N	\N	\N	Pasaje Colonia Oriente 3442 Poblaci??n: Ren?? Schneider	\N	\N	1	0	0	\N	\N	1	14	11	16	40
1693	\N	Antofagasta	\N	0	0	0	0	\N	\N	\N	Campamento Am??ricas Unidas ??? Casa 25	\N	\N	1	0	0	\N	\N	1	14	11	16	40
1694	\N	Vallenar	\N	0	0	0	0	\N	\N	\N	Manutara 2393 Esquina Guacolda, Poblaci??n: Rafael Torre Blanca	\N	\N	1	0	0	\N	\N	1	14	11	16	41
1695	\N	La Serena	\N	0	0	0	0	\N	\N	\N	Calle Fot??grafo Mario Alegr??a 3494, Poblaci??n: El Toqui Compa????a	\N	\N	1	0	0	\N	\N	1	14	11	16	41
1696	\N	Santiago	\N	0	0	0	0	\N	\N	\N	Club H??pico 5181. Comuna: Pedro Aguirre Cerda	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1697	\N	Santiago Norte	\N	0	0	0	0	\N	\N	\N	Isabel Riquelme 4576. Comuna: Renca	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1698	\N	Talagante	\N	0	0	0	0	\N	\N	\N	Pasaje Los Suspiros 1149. Villa: Las Hortensias	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1699	\N	San Sebasti??n	\N	0	0	0	0	\N	\N	\N	Calle: 3ra Sur 137 Entre Par??s y Fin de Loteo. Cartagena	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1700	\N	Do??ihue	\N	0	0	0	0	\N	\N	\N	Pasaje Juan Pablo 1 Nro. 43.  Villa Carlos Schneider Rancagua	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1701	\N	Curic??	\N	0	0	0	0	\N	\N	\N	R??o Huasco 49 Poblaci??n: Sol de Septiembre	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1702	\N	Talca	\N	0	0	0	0	\N	\N	\N	11 Oriente 27 Poblaci??n: Cristi Gallo	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1703	\N	Linares	\N	0	0	0	0	\N	\N	\N	Abranquil 068  Poblaci??n: Yerba Buena	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1704	\N	Longav??	\N	0	0	0	0	\N	\N	\N	Poblaci??n: Villa Nueva Pasaje Los Boldos Con Los Sauces Casa 1	\N	\N	1	0	0	\N	\N	1	14	11	16	42
1705	\N	Arauco	\N	0	0	0	0	\N	\N	\N	Israel 46 Poblaci??n: Bel??n	\N	\N	1	0	0	\N	\N	1	14	11	16	43
1706	\N	Ca??ete	\N	0	0	0	0	\N	\N	\N	Tucapel Senda 2 Villa Magisterio S/N	\N	\N	1	0	0	\N	\N	1	14	11	16	43
1707	\N	Quidico	\N	0	0	0	0	\N	\N	\N	Avenida Costanera S/N	\N	\N	1	0	0	\N	\N	1	14	11	16	43
1708	\N	Chill??n	\N	0	0	0	0	\N	\N	\N	Ignacio Serrano 255 interior. Chill??n Viejo	\N	\N	1	0	0	\N	\N	1	14	11	16	43
1709	\N	Chiguayante-Penco-Las Quilas	\N	0	0	0	0	\N	\N	\N	Victor Burgos 22, detr??s del Easy	\N	\N	1	0	0	\N	\N	1	14	11	16	43
1710	\N	Los ??ngeles	\N	0	0	0	0	\N	\N	\N	Las Azaleas 759  Poblaci??n:  Santiago Bueras	\N	\N	1	0	0	\N	\N	1	14	11	16	44
1711	\N	Temuco	\N	0	0	0	0	\N	\N	\N	In??s de Suarez 310 Pedro de Valdivia	\N	\N	1	0	0	\N	\N	1	14	11	16	44
1712	\N	Labranza	\N	0	0	0	0	\N	\N	\N	Villa: Los Ap??stoles Calle: Esperanza 1011	\N	\N	1	0	0	\N	\N	1	14	11	16	44
1713	\N	R??o Claro	\N	0	0	0	0	\N	\N	\N	San Miguel de Unihue	\N	\N	1	0	0	\N	\N	1	14	11	16	44
1714	\N	Repocura	\N	0	0	0	0	\N	\N	\N	Repocura	\N	\N	1	0	0	\N	\N	1	14	11	16	44
1715	\N	Laja	\N	0	0	0	0	\N	\N	\N	Los Acacias 89	\N	\N	1	0	0	\N	\N	1	14	11	16	44
1716	\N	Katrirrehue	\N	0	0	0	0	\N	\N	\N	Comuna: De Saavedra	\N	\N	1	0	0	\N	\N	1	14	11	16	44
1717	\N	San Jos?? de la Mariquina	\N	0	0	0	0	\N	\N	\N	Ernesto Riquelme 1201	\N	\N	1	0	0	\N	\N	1	14	11	16	45
1733	\N	Central Pucara	\N	0	1	0	0	\N	\N	\N	Calle Innominada y Av. Panamericana	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1734	\N	Quillacollo	\N	0	1	0	0	\N	\N	\N	Z. Llauquenquiri lado del cementerio	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1735	\N	1ro de mayo	\N	0	1	0	0	\N	\N	\N	Z. 1ro de Mayo	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1736	\N	Sacaba	\N	0	1	0	0	\N	\N	\N	Av. America y Carretera Chapare	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1737	\N	Tolata	\N	0	1	0	0	\N	\N	\N	Carretera Punata, de la rotonda 4 cuadras norte	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1738	\N	Punata	\N	0	1	0	0	\N	\N	\N	Z. Chilcar chico	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1739	\N	Curiuma	\N	0	1	0	0	\N	\N	\N	Z. Coriuma	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1740	\N	Ivirgarzama	\N	0	1	0	0	\N	\N	\N	Av. Santa cruz	\N	\N	1	0	0	\N	\N	1	8	12	17	46
1741	\N	Quintanilla	\N	0	1	0	0	\N	\N	\N	Av. Quintanilla soasu antes de ex said	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1742	\N	La Fortuna	\N	0	1	0	0	\N	\N	\N	Carretera Copacabana Zona la Fortuna	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1743	\N	Viacha	\N	0	1	0	0	\N	\N	\N	Av. Bolivar entre calle 3	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1744	\N	Ancocala	\N	0	1	0	0	\N	\N	\N	Carretera desaguadero comunidad ancocala	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1745	\N	Rio Seco	\N	0	1	0	0	\N	\N	\N	Calle Luis espinal y Av. Juan Pablo II	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1746	\N	Villa Coroico	\N	0	1	0	0	\N	\N	\N	Comunidad Villa Coroico plena carretra	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1747	\N	Mu??ecas	\N	0	1	0	0	\N	\N	\N	Colonia Mu??ecas	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1748	\N	Caranavi	\N	0	1	0	0	\N	\N	\N	Calle Kennedi entre calle 2	\N	\N	1	0	0	\N	\N	1	8	12	18	47
1749	\N	Llallagua	\N	0	1	0	0	\N	\N	\N	Comunidad Llallagua	\N	\N	1	0	0	\N	\N	1	8	12	19	48
1750	\N	Potosi	\N	0	1	0	0	\N	\N	\N	Z. Potosi Alto	\N	\N	1	0	0	\N	\N	1	8	12	19	48
1751	\N	Tarija	\N	0	1	0	0	\N	\N	\N	Carretera San Mateo	\N	\N	1	0	0	\N	\N	1	8	12	19	49
1752	\N	Santa Cruz	\N	0	1	0	0	\N	\N	\N	Calle Virgen de Cotoca y Av. El Mechero	\N	\N	1	0	0	\N	\N	1	8	12	20	50
1753	\N	Trinidad	\N	0	1	0	0	\N	\N	\N	Av. Ejercito y calle La paz	\N	\N	1	0	0	\N	\N	1	8	12	20	51
1754	\N	Esteli	\N	0	1	0	0	\N	\N	\N	De donde fue el cine Nancy 2 cuadras al oeste	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1755	\N	San Luis	\N	0	1	0	0	\N	\N	\N	Comunidad San Luis - Esteli	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1756	\N	Somoto	\N	0	1	0	0	\N	\N	\N	Frente a Petronic - Somoto	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1757	\N	Las Chilcas	\N	0	1	0	0	\N	\N	\N	Comunidad Las Chilcas - Esteli	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1758	\N	El Pe??asco	\N	0	1	0	0	\N	\N	\N	Comunidad El Pe??asco - Esteli	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1759	\N	San Antonio	\N	0	1	0	0	\N	\N	\N	Comunidad San Antonio - Esteli	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1760	\N	Telpaneca	\N	0	1	0	0	\N	\N	\N	Comunidad Telpaneca - Somoto	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1761	\N	Sebaco	\N	0	1	0	0	\N	\N	\N	De los graneros 2 c al este y 1 al sur - Sebaco	\N	\N	1	0	0	\N	\N	1	21	13	21	52
1762	\N	San Miguel - El Vijao	\N	0	1	0	0	\N	\N	\N	Comunidad San Miguel El Vijao - Matagalpa	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1763	\N	San Mart??n - El Vijao	\N	0	1	0	0	\N	\N	\N	Comunidad San Mart??n - La Dalia	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1764	\N	La Dalia	\N	0	1	0	0	\N	\N	\N	De la Catedral 2c al este, y 1/2c al norte	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1765	\N	Piedra Luna	\N	0	1	0	0	\N	\N	\N	Comunidad Piedra Luna contiguo a la escuela - La Dalia	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1766	\N	El Tigre	\N	0	1	0	0	\N	\N	\N	Comunidad El Tigre - La Dalia	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1767	\N	Coyolar	\N	0	1	0	0	\N	\N	\N	Comunidad Coyolar - La Dalia	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1768	\N	Matagalpa	\N	0	1	0	0	\N	\N	\N	Costado oeste de maxi pali Matagalpa	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1769	\N	Piedra Colorada	\N	0	1	0	0	\N	\N	\N	Comunidad Piedra Colorada - Bocay - Jinotega	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1770	\N	Los Molejones	\N	0	1	0	0	\N	\N	\N	Comunidad Los Molejones - Jinotega	\N	\N	1	0	0	\N	\N	1	21	13	21	53
1771	\N	Nueva Guinea	\N	0	1	0	0	\N	\N	\N	Del mercado costado sur 5 c al norte	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1772	\N	El Rama	\N	0	1	0	0	\N	\N	\N	Rotonda El Rama 500 vrs al este	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1773	\N	La Fonseca	\N	0	1	0	0	\N	\N	\N	Comunidad San Antonio La Fonseca - Nueva Guinea	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1774	\N	Juigalpa	\N	0	1	0	0	\N	\N	\N	De Remasa 1 c al oeste	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1775	\N	Cuapa	\N	0	1	0	0	\N	\N	\N	Del centro de salud 200 vrs arriba	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1776	\N	Santo Tom??s	\N	0	1	0	0	\N	\N	\N	Frente a los lavanderos - Santo Tom??s	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1777	\N	Nuevo Le??n	\N	0	1	0	0	\N	\N	\N	De la comunal  100 vrs a Nueva Vista - Santo Tom??s	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1778	\N	Camoapa	\N	0	1	0	0	\N	\N	\N	Salida a Matamba 1/2 c al sur y 80 vrs al oeste	\N	\N	1	0	0	\N	\N	1	21	13	21	54
1779	\N	El Laurel Galan	\N	0	1	0	0	\N	\N	\N	Comunidad Laurel Galan - Managua	\N	\N	1	0	0	\N	\N	1	21	13	21	55
1780	\N	Bel??n Managua	\N	0	1	0	0	\N	\N	\N	Bo 14 de Septiembre, de la antena de Claro 2c y 1/2c arriba	\N	\N	1	0	0	\N	\N	1	21	13	21	55
1781	\N	Evenecer Managua	\N	0	1	0	0	\N	\N	\N	De los Sem??foros del Madro??o 3 c al sur	\N	\N	1	0	0	\N	\N	1	21	13	21	55
1782	\N	Soledad	\N	0	1	0	0	\N	\N	\N	Empalme de Santa Teresa 1 c al sur y 1 al este - Carazo	\N	\N	1	0	0	\N	\N	1	21	13	21	55
1783	\N	Posoltega	\N	0	1	0	0	\N	\N	\N	De donde fueron los rieles 1c al sur, 1c al oeste y 1/2c al sur	\N	\N	1	0	0	\N	\N	1	21	13	21	55
1784	\N	Le??n	\N	0	1	0	0	\N	\N	\N	Urbanizadora Metropolitana en Le??n	\N	\N	1	0	0	\N	\N	1	21	13	21	55
\.


--
-- TOC entry 2572 (class 0 OID 33328)
-- Dependencies: 202
-- Data for Name: institucion; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.institucion (idinstitucion, descripcion, sede, "direcci??n", telefono, email, iddivision, pais_id, idunion, idmision, iddistritomisionero, idiglesia, nombre, tipo) FROM stdin;
\.


--
-- TOC entry 2574 (class 0 OID 33341)
-- Dependencies: 204
-- Data for Name: laboral_miembro; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.laboral_miembro (idlaboralmiembro, idmiembro, cargo, sector, institucionlaboral, fechainicio, fechafin, periodoini, periodofin) FROM stdin;
\.


--
-- TOC entry 2576 (class 0 OID 33349)
-- Dependencies: 206
-- Data for Name: miembro; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.miembro (idmiembro, pais_id_nacionalidad, iddistritonacimiento, iddistritodomicilio, idtipodoc, idestadocivil, idocupacion, idgradoinstruccion, paterno, materno, nombres, foto, fechanacimiento, lugarnacimiento, sexo, nrodoc, direccion, referenciadireccion, telefono, celular, email, emailalternativo, idreligion, fechabautizo, idcondicioneclesiastica, encargado_recibimiento, observaciones, estado, estadoeliminado, idiglesia, fechaingresoiglesia, fecharegistro, tipolugarnac, ciudadnacextranjero, apellidos, iddepartamentodomicilio, idprovinciadomicilio, iddepartamentonacimiento, idprovincianacimiento, apellido_soltera, pais_id_nacimiento, iddivision, pais_id, idunion, idmision, iddistritomisionero, tabla_encargado_bautizo, encargado_bautizo, observaciones_bautizo, idiomas, texto_bautismal, pais_id_domicilio) FROM stdin;
\.


--
-- TOC entry 2578 (class 0 OID 33380)
-- Dependencies: 208
-- Data for Name: mision; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.mision (idmision, idunion, descripcion, direccion, estado, telefono, email, fax) FROM stdin;
1	1	Misi??n Oriente	JR. RICARDO PALMA 509	1	957459877	jmanuel.zsinarahua@gmail.com	\N
3	1	Misi??n Central	JR. RICARDO PALMA 509	1	957459877	bleonardo.gsinarahua@gmail.com	\N
4	1	Misi??n Sur	JR. RICARDO PALMA 509	1	936 676 722 - 041750004	soportedetallesperuserver@gmail.com	\N
6	3	Asociaci??n Paraguay	JR. RICARDO PALMA 509	1	957459877	jm.zs@hotmail.com	\N
7	5	Caribe??a	JR. RICARDO PALMA 509	1	957459877	jmanuel.zsinarahua@gmail.com	\N
8	6	Llanos-Andes	JR. RICARDO PALMA 509	1	957459877	jmanuel.zsinarahua@gmail.com	\N
9	7	Nororiental	\N	1	\N	\N	\N
10	7	Central	\N	1	\N	\N	\N
11	7	Occidental	\N	1	\N	\N	\N
12	7	Sur	\N	1	\N	\N	\N
13	8	Ecuatoriana	\N	1	\N	\N	\N
14	9	Uruguaya	\N	1	\N	\N	\N
15	10	Guatemalteca	\N	1	\N	\N	\N
16	11	Chilena	\N	1	\N	\N	\N
5	7	Asociaci??n Este	JR. RICARDO PALMA 509	1	998038402	jm.zs@hotmail.com	\N
17	12	Mision Central	\N	1	\N	\N	\N
18	12	Mision Oeste	\N	1	\N	\N	\N
19	12	Mision Sur	\N	1	\N	\N	\N
20	12	Mision Oriente	\N	1	\N	\N	\N
21	13	Nicarag??ense	\N	1	\N	\N	\N
0	0	No Determinado	\N	1	\N	\N	\N
\.


--
-- TOC entry 2580 (class 0 OID 33391)
-- Dependencies: 210
-- Data for Name: motivobaja; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.motivobaja (idmotivobaja, descripcion) FROM stdin;
1	Dimisi??n
3	Exclusi??n
4	Muerte
5	Otros Motivos
6	Renuncia
2	Indisciplina
\.


--
-- TOC entry 2582 (class 0 OID 33397)
-- Dependencies: 212
-- Data for Name: otras_propiedades; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.otras_propiedades (idotrapropiedad, descripcion, cantidad, tipo, iddivision, pais_id, idunion, idmision, iddistritomisionero, idiglesia) FROM stdin;
\.


--
-- TOC entry 2584 (class 0 OID 33402)
-- Dependencies: 214
-- Data for Name: otrospastores; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.otrospastores (idotrospastores, idcargo, nombrecompleto, observaciones, periodo, vigente, estado, idtipodoc, nrodoc) FROM stdin;
\.


--
-- TOC entry 2586 (class 0 OID 33414)
-- Dependencies: 216
-- Data for Name: paises; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.paises (pais_id, pais_descripcion, estado, idioma_id, iddivision, direccion, telefono, posee_union) FROM stdin;
13	M??xico	A	1	1	Jr. Ricardo Palma 509	957459877	S
9	Paraguay	A	1	1	Jr. Ricardo Palma 509	998038402	N
15	Colombia	A	1	1	Jr. Ricardo Palma 509	957459877	S
16	El Salvador	A	1	1	Jr. Ricardo Palma 509	957459877	S
17	Costa Rica	A	1	1	Jr. Ricardo Palma 509	957459877	S
6	Venezuela	A	1	1	Jr. Ricardo Palma 509	957459877	S
8	Bolivia	A	1	1	Jr. Ricardo Palma 509	957459877	S
18	Panama	A	1	1	Jr. Ricardo Palma 509	957459877	S
20	Honduras	A	1	1	Jr. Ricardo Palma 509	957459877	S
21	Nicaragua	A	1	1	Jr. Ricardo Palma 509	957459877	S
22	Argentina	A	1	1	Jr. Ricardo Palma 509	957459877	S
23	Brasil	A	1	1	Jr. Ricardo Palma 509	957459877	S
0	No Determinado	A	1	0	\N	\N	S
14	Chile	A	1	1	Jr. Ricardo Palma 509	957459877	N
3	Ecuador	A	1	1	JR. RICARDO PALMA 509	936 676 722 - 041750004	N
7	Uruguay	A	1	1	Jr. Ricardo Palma 509	957459877	N
19	Guatemala	A	1	1	Jr. Ricardo Palma 509	957459877	N
10	Francia	A	2	0	Jr. Ricardo Palma 509	988 617 534	S
1	Per??	A	1	1	JR. RICARDO PALMA 509	957459877	S
\.


--
-- TOC entry 2587 (class 0 OID 33419)
-- Dependencies: 217
-- Data for Name: paises_idiomas; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.paises_idiomas (pais_id, idioma_id, pai_descripcion) FROM stdin;
\.


--
-- TOC entry 2588 (class 0 OID 33422)
-- Dependencies: 218
-- Data for Name: paises_jerarquia; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.paises_jerarquia (pj_id, pais_id, pj_descripcion, pj_item) FROM stdin;
1	1	departamento	1
2	1	provincia	2
3	1	distrito	3
9	13	estado	1
10	13	municipio	2
11	9	departamento	1
12	9	municipio	2
19	15	departamento	1
20	15	municipio	2
24	16	departamento	1
25	16	distrito	2
26	16	municipio	3
27	17	provincia	1
28	17	canton	2
29	17	distrito	3
30	6	estado	1
31	6	municipio	2
32	6	parroquia	3
35	8	departamento	1
36	8	provincia	2
37	8	municipio	3
38	18	provincia_comarca	1
39	18	distrito	2
40	18	corregimientos	3
43	20	departamento	1
44	20	municipio	2
45	21	departamento	1
46	21	municipio	2
47	22	provincia	1
48	22	departamento_partido	2
49	22	municipio	3
50	23	estado	1
51	23	municipio	2
52	14	region	1
53	14	provincia	2
54	14	comuna	3
55	3	provincia	1
56	3	canton	2
57	3	parroquia	3
58	7	departamento	1
59	7	municipio	2
60	19	departamento	1
61	19	municipio	2
63	24	c	1
\.


--
-- TOC entry 2591 (class 0 OID 33429)
-- Dependencies: 221
-- Data for Name: parentesco_miembro; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.parentesco_miembro (idparentescomiembro, idmiembro, idparentesco, idpais, nombres, idtipodoc, nrodoc, fechanacimiento, lugarnacimiento) FROM stdin;
\.


--
-- TOC entry 2593 (class 0 OID 33437)
-- Dependencies: 223
-- Data for Name: religion; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.religion (idreligion, descripcion) FROM stdin;
1	Adventista
3	Cat??lico
4	Dominical
5	Isrraelita
6	Mormon
7	Otros
8	Reforma
9	Testigo de Jehov??
0	No Determinado
2	SMI
\.


--
-- TOC entry 2595 (class 0 OID 33443)
-- Dependencies: 225
-- Data for Name: temp_traslados; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.temp_traslados (idtemptraslados, idmiembro, idtipodoc, iddivision, pais_id, idunion, idmision, iddistritomisionero, idiglesia, nrodoc, division, pais, "union", mision, distritomisionero, iglesia, tipo_documento, usuario_id, tipo_traslado, iddivisiondestino, pais_iddestino, iduniondestino, idmisiondestino, iddistritomisionerodestino, idiglesiadestino, asociado) FROM stdin;
\.


--
-- TOC entry 2597 (class 0 OID 33451)
-- Dependencies: 227
-- Data for Name: union; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias."union" (idunion, descripcion, estado, direccion, telefono, email, fax) FROM stdin;
1	Uni??n Peruana	1	\N	\N	\N	\N
3	Uni??n Temporal Paraguay	1	\N	\N	\N	\N
5	Uni??n Mexicana	1	\N	\N	\N	\N
6	Uni??n Venezolana	1	\N	\N	\N	\N
11	Union Temporal Chilena	1	\N	\N	\N	\N
10	Union Temporal Guatemalteca	1	\N	\N	\N	\N
9	Union Temporal Uruguaya	1	\N	\N	\N	\N
8	Union Temporal Ecuatoriana	1	\N	\N	\N	\N
7	Colombiana	1	\N	\N	\N	\N
13	Union Temporal Nicaragua	1	\N	\N	\N	\N
12	Union Temporal Boliviana	1	\N	\N	\N	\N
0	No Determinado	1	\N	\N	\N	\N
\.


--
-- TOC entry 2599 (class 0 OID 33460)
-- Dependencies: 229
-- Data for Name: union_paises; Type: TABLE DATA; Schema: iglesias; Owner: postgres
--

COPY iglesias.union_paises (idunion, pais_id) FROM stdin;
1	1
3	9
4	6
5	13
6	6
11	14
10	19
9	7
8	3
7	15
2	0
13	21
12	8
0	0
15	14
\.


--
-- TOC entry 2601 (class 0 OID 33477)
-- Dependencies: 233
-- Data for Name: cargo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cargo (idcargo, descripcion, idtipocargo, estado, idnivel) FROM stdin;
8	Director de Escuela Sab??tica	2	1	\N
11	Director Buen Samaritano	2	1	\N
18	Tesorero	2	1	1
29	Delegado Suplente	2	1	1
28	Delegado Titular	2	1	2
45	Director Buensamaritano	1	1	8
25	Director de M??sica	2	1	6
27	Director de Seminario	2	1	3
44	Secretario Eminel	1	1	9
41	Director Eminel	1	1	12
26	Director de J??venes	2	1	4
43	Misionero Laico	1	1	10
15	Presidente	1	1	1
48	Divisionarios	2	1	1
49	Directores de Ministerios	2	1	1
50	Directores de Departamento	2	1	1
51	Miembros del Comit??	2	1	1
52	Auditor(es)	2	1	1
53	Comit?? de Finanzas	2	1	1
54	Presidente	2	1	2
55	Vicepresidente	2	1	2
56	Secretario	2	1	2
57	Tesorero	2	1	2
58	Miembro/s del Comit??	2	1	2
59	Presidente	2	1	4
60	Vicepresidente	2	1	4
61	Secretario	2	1	4
62	Tesorero	2	1	4
63	Presidentes de Asociaci??n	2	1	4
5	Director de Iglesia	2	1	7
6	Secretario de Iglesia	2	1	7
4	Anciano de Iglesia	1	1	14
46	Ministerial	1	1	8
65	Director de Escuela Sabatica	2	1	7
67	Comit?? de Iglesia	2	1	7
68	Delegado a la Asociaci??n	2	1	7
69	Presidente	2	1	5
19	Director Colportaje	2	1	4
71	Director de Obra Misionera	2	1	4
73	Director de Editorial	2	1	4
75	Nombre de la Editorial	2	1	4
76	Nombre de la Editorial	2	1	5
77	Di??cono/Director de Dorcas	2	1	4
21	Director de Salud	2	1	4
24	Director de Educaci??n	2	1	4
80	Auditor 1	2	1	4
81	Auditor 2	2	1	5
82	Comit?? de Uni??n	2	1	4
83	Comit?? de Asociaci??n	2	1	5
84	Comit?? Ejecutivo	2	1	4
85	Comit?? Ejecutivo	2	1	5
86	Comit?? de Finanzas	2	1	4
87	Comit?? de Finanzas	2	1	5
88	Comit?? Literario	2	1	4
89	Comit?? Literario	2	1	5
90	Comit?? de Salud	2	1	4
91	Comit?? de Salud	2	1	5
94	Delegado Substituto	2	1	4
93	Delegado	2	1	5
92	Delegado	2	1	4
95	Delegado Substituto	2	1	5
96	Auditor 1	2	1	5
97	Auditor 2	2	1	4
98	Vicepresidente	2	1	5
99	Secretario	2	1	5
100	Tesorero	2	1	5
101	Ministro	1	1	12
103	Empleado de Oficina	2	1	5
104	Anciano de Iglesia	1	1	12
22	Director de Familia	2	1	1
121	Director de Educaci??n	2	1	1
122	Director de Salud u Obra M??dico Misionera	2	1	1
3	Colportor	1	1	12
102	Obrero B??blico	1	1	12
123	Director de Dorcas o Buen Samaritano 	2	1	1
1	Pastor	1	1	8
106	Di??cono con Bendici??n	1	1	12
23	Director de Publicaciones	2	1	1
124	Director de Multimedia	2	1	1
7	Tesorero	2	1	7
16	Vice Presidente Primero	2	1	1
107	Vice Presidente Segundo	2	1	1
17	Secretario Primero	2	1	1
108	Secretario Segundo	2	1	1
109	Presidente de la Divisi??n Norteamerica-Caribe	2	1	1
110	Presidente de la Divisi??n Latinoamericana	2	1	1
111	Presidente de la Divisi??n Europea	2	1	1
112	Presidente de la Divisi??n Africana	2	1	1
113	Presidente de la Divisi??n Asi??tica	2	1	1
114	Presidente de la Divisi??n Oceania 	2	1	1
115	Director del Ministerio Misionero	2	1	1
116	Director del Ministerio Social	2	1	1
117	Director del Ministerio de Ayuda	2	1	1
118	Director de Obra Misionera o Evangelismo	2	1	1
119	Director de Colportaje	2	1	1
120	Director de J??venes	2	1	1
125	Ingeniero/Arquitecto de la Asociaci??n General	2	1	1
126	Director del Departamento de Obra Misionera o Evangelismo	2	1	4
127	Director del Departamento de Colportaje	2	1	4
128	Director del Departamento de Ni??os	2	1	4
129	Director del Departamento de J??venes	2	1	4
130	Director del Departamento de Familia	2	1	4
131	Director del Departamento de Educaci??n	2	1	4
132	Director del Departamento de Salud u Obra M??dico Misionera	2	1	4
133	Director del Departamento del Buen Samaritano	2	1	4
134	Director del Departamento de Publicaciones o Editorial	2	1	4
135	Director del Departamento de M??sica	2	1	4
136	Director del Departamento de Multimedia	2	1	4
137	Auditor (es) o Revisor (es) de Cuentas	2	1	4
138	Miembros del Comit?? Literario	2	1	4
72	Director del Departamento de Obra Misionera o Evangelismo	2	1	5
70	Director del Departamento de Colportaje	2	1	5
14	Director del Departamento de J??venes	2	1	5
13	Director del Departamento de Salud u Obra M??dico Misionera	2	1	5
66	Director del Departamento de J??venes	2	1	7
64	Di??cono/Diaconisa	2	1	7
9	Maestro(s) de Escuela Sab??tica	2	1	7
10	Maestro(s) de Escuela Sab??tica Infantil	2	1	7
139	Miembros del Comit?? de Finanzas	2	1	4
140	Miembros del Comit?? Plenario (o Directivo) de la Uni??n	2	1	4
141	Delegados a la Asociaci??n General	2	1	4
79	Director del Departamento de Educaci??n	2	1	5
78	Director del Departamento de Dorcas o Buen Samaritano	2	1	5
74	Director del Departamento de Publicaciones o Editorial	2	1	5
142	Director del Departamento de Ni??os	2	1	5
143	Director del Departamento de Familia	2	1	5
12	Director del Departamento de M??sica	2	1	5
144	Director del Departamento de Multimedia	2	1	5
145	Auditor (es) o Revisor (es) de Cuentas	2	1	5
146	Delegados a la Uni??n o a la Asociaci??n General	2	1	5
147	El Comit?? Plenario	2	1	5
20	Director del Departamento de Obra Misionera o Evangelismo	2	1	7
148	Anciano de Iglesia	2	1	7
149	Subdirector de Iglesia	2	1	7
150	Secretario de Escuela Sab??tica	2	1	7
151	Director del Departamento de Ni??os	2	1	7
152	Director del Departamento de Familia	2	1	7
153	Director del Departamento de Educaci??n	2	1	7
154	Director del Departamento de Salud u Obra M??dico Misionera	2	1	7
155	Director del Departamento de Buen Samaritano o Dorcas	2	1	7
156	Director del Departamento de M??sica	2	1	7
157	Director del Departamento de Multimedia	2	1	7
\.


--
-- TOC entry 2603 (class 0 OID 33489)
-- Dependencies: 236
-- Data for Name: condicioninmueble; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.condicioninmueble (idcondicioninmueble, descripcion) FROM stdin;
1	Construido
2	Semiconstruido
3	En Construcci??n
4	En Litigio
\.


--
-- TOC entry 2605 (class 0 OID 33495)
-- Dependencies: 238
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departamento (iddepartamento, descripcion, pais_id) FROM stdin;
1	AMAZONAS	1
2	ANCASH	1
3	APURIMAC	1
4	AREQUIPA	1
5	AYACUCHO	1
6	CAJAMARCA	1
7	CALLAO	1
8	CUSCO	1
9	HUANCAVELICA	1
10	HUANUCO	1
11	ICA	1
12	JUNIN	1
13	LA LIBERTAD	1
14	LAMBAYEQUE	1
15	LIMA	1
16	LORETO	1
17	MADRE DE DIOS	1
18	MOQUEGUA	1
19	PASCO	1
20	PIURA	1
21	PUNO	1
22	SAN MARTIN	1
23	TACNA	1
24	TUMBES	1
25	UCAYALI	1
32	Arica y Parinacota	14
33	Tarapac??	14
34	Antofagasta	14
35	Atacama	14
36	Coquimbo	14
37	Valpara??so	14
38	Regi??n del Libertador Gral. Bernardo O???Higgins	14
39	Regi??n del Maule	14
40	Regi??n del Biob??o	14
41	Regi??n de la Araucan??a	14
42	Regi??n de Los R??os	14
43	Regi??n de Los Lagos	14
44	Regi??n Ais??n del Gral. Carlos Ib????ez del Campo	14
45	Regi??n de Magallanes y de la Ant??rtica Chilena	14
46	Regi??n Metropolitana de Santiago	14
47	Antioquia	15
48	Atlantico	15
49	Santa Fe de Bogot??	15
50	Bolivar	15
51	Boyaca	15
52	Caldas	15
53	Caqueta	15
54	Cauca	15
55	Cesar	15
56	Cordova	15
57	Cundinamarca	15
58	Choco	15
59	Huila	15
60	La Guajira	15
61	Magdalena	15
62	Meta	15
63	Nari??o	15
64	Norte de Santander	15
65	Quindio	15
66	Risaralda	15
67	Santander	15
68	Sucre	15
69	Tolima	15
70	Valle	15
71	Arauca	15
72	Casanare	15
73	Putumayo	15
74	San Andres	15
75	Amazonas	15
76	Guainia	15
77	Guaviare	15
78	Vaupes	15
79	Vichada	15
80	AZUAY	3
81	BOLIVAR	3
82	CA??AR	3
83	CARCHI	3
84	COTOPAXI	3
85	CHIMBORAZO	3
86	EL ORO	3
87	ESMERALDAS	3
88	GUAYAS	3
89	IMBABURA	3
90	LOJA	3
91	LOS RIOS	3
92	MANABI	3
93	MORONA SANTIAGO	3
94	NAPO	3
95	PASTAZA	3
96	PICHINCHA	3
97	TUNGURAHUA	3
98	ZAMORA CHINCHIPE	3
99	GALAPAGOS	3
100	SUCUMBIOS	3
101	ORELLANA	3
102	NTO DOMINGO DE LOS TSACHIL	3
103	SANTA ELENA	3
104	ZONAS NO DELIMITADAS	3
105	Ahuachap??n	16
106	Sonsonate	16
107	Santa Ana	16
108	Chalatenango	16
109	La Libertad	16
110	San Salvador	16
111	Cuscatl??n	16
112	La Paz	16
113	Caba??as	16
114	San Vicente	16
115	Usulut??n	16
116	San Miguel	16
117	Moraz??n	16
118	La Uni??n	16
119	SAN JOSE	17
120	ALAJUELA	17
121	CARTAGO	17
122	HEREDIA	17
123	GUANACASTE	17
124	PUNTARENAS	17
125	LIMON	17
126	Amazonas	6
127	Anzo??tegui	6
128	Apure	6
129	Aragua	6
130	Barinas	6
131	Bol??var	6
132	Carabobo	6
133	Cojedes	6
134	Delta Amacuro	6
135	Distrito Capital	6
136	Falc??n	6
137	Gu??rico	6
138	La Guaira	6
139	Lara	6
140	M??rida	6
141	Miranda	6
142	Monagas	6
143	Nueva Esparta	6
144	Portuguesa	6
145	Sucre	6
146	T??chira	6
147	Trujillo	6
148	Yaracuy	6
149	Zulia	6
151	Artigas	7
152	Canelones	7
153	Cerro Largo	7
154	Colonia	7
155	Durazno	7
156	Flores	7
157	Florida	7
158	Lavalleja	7
159	Maldonado	7
160	Montevideo	7
161	Paysand??	7
162	R??o Negro	7
163	Rivera	7
164	Rocha	7
165	Salto	7
166	San Jos??	7
167	Soriano	7
168	Tacuaremb??	7
169	Treinta y Tres	7
170	Alto Paraguay	9
171	Alto Paran??	9
172	Amambay	9
173	Asunci??n	9
174	Boquer??n	9
175	Caaguaz??	9
176	Caazap??	9
177	Canindey??	9
178	Central	9
179	Concepci??n	9
180	Cordillera	9
181	Guair??	9
182	Itap??a	9
183	Misiones	9
184	??eembuc??	9
185	Paraguar??	9
186	Presidente Hayes	9
187	San Pedro	9
188	Beni	8
189	Chuquisaca	8
190	Cochabamba	8
191	La Paz	8
192	Oruro	8
193	Pando	8
194	Potos??	8
195	Santa Cruz	8
196	Tarija	8
197	Bocas del Toro	18
198	Chiriqu??	18
199	Cocl??	18
200	Col??n	18
201	Dari??n	18
202	Herrera	18
203	Los Santos	18
204	Panam??	18
205	Panam?? Oeste	18
206	Veraguas	18
207	Ember??-Wounaan	18
208	Guna Yala	18
209	Naso Tj??r Di	18
210	Ng??be-Bugl??	18
211	Alta Verapaz	19
212	Baja Verapaz	19
213	Chimaltenango	19
214	Chiquimula	19
215	El Progreso	19
216	Escuintla	19
217	Guatemala	19
218	Huehuetenango	19
219	Izabal	19
220	Jalapa	19
221	Jutiapa	19
222	Pet??n	19
223	Quetzaltenango	19
224	Quich??	19
225	Retalhuleu	19
226	Sacatep??quez	19
227	San Marcos	19
228	Santa Rosa	19
229	Solol??	19
230	Suchitep??quez	19
231	Totonicap??n	19
232	Zacapa	19
233	Atl??ntida	20
234	Col??n	20
235	Comayagua	20
236	Cop??n	20
237	Cort??s	20
238	Choluteca	20
239	El Para??so	20
240	Francisco Moraz??n	20
241	Gracias a Dios	20
242	Intibuc??	20
243	Islas de la Bah??a	20
244	La Paz	20
245	Lempira	20
246	Ocotepeque	20
247	Olancho	20
248	Santa B??rbara	20
249	Valle	20
250	Yoro	20
251	Boaco	21
252	Carazo	21
253	Chinandega	21
254	Chontales	21
255	Costa Caribe Norte	21
256	Costa Caribe Sur	21
257	Estel??	21
258	Granada	21
259	Jinotega	21
260	Le??n	21
261	Madriz	21
262	Managua	21
263	Masaya	21
264	Matagalpa	21
265	Nueva Segovia	21
266	R??o San Juan	21
267	Rivas	21
268	AGUASCALIENTES	13
269	BAJA CALIFORNIA	13
270	BAJA CALIFORNIA SUR	13
271	CAMPECHE	13
272	CHIAPAS	13
273	CHIHUAHUA	13
274	CIUDAD DE M??XICO	13
275	COAHULIA	13
276	COLIMA	13
277	DURANGO	13
278	GUANAJUATO	13
279	GUERRERO	13
280	HIDALGO	13
281	JALISCO	13
282	ESTADO DE M??XICO	13
283	MICHOAC??N	13
284	MORELOS	13
285	NAYARIT	13
286	NUEVO LE??N	13
287	OAXACA	13
288	PUEBLA	13
289	QUER??TARO	13
290	QUINTANA ROO	13
291	SAN LUIS POTOS??	13
292	SINALOA	13
293	SONORA	13
294	TABASCO	13
295	TAMAULIPAS	13
296	TLAXCALA	13
297	VERACRUZ	13
298	YUCAT??N	13
299	ZACATECAS	13
300	Buenos Aires	22
301	Catamarca	22
302	Chaco	22
303	Chubut	22
304	C??rdoba	22
305	Corrientes	22
306	Entre R??os	22
307	Formosa	22
308	Jujuy	22
309	La Pampa	22
310	La Rioja	22
311	Mendoza	22
312	Misiones	22
313	Neuqu??n	22
314	R??o Negro	22
315	Salta	22
316	San Juan	22
317	San Luis	22
318	Santa Cruz	22
319	Santa Fe	22
320	Santiago del Estero	22
321	Tierra del Fuego	22
322	Tucum??n	22
323	Acre	23
324	Alagoas	23
325	Amap??	23
326	Amazonas	23
327	Bah??a	23
328	Cear??	23
329	Distrito Federal	23
330	Esp??rito Santo	23
331	Goi??s	23
332	Maranh??o	23
333	Mato Grosso	23
334	Mato Grosso del Sur	23
335	Minas Gerais	23
336	Par??	23
337	Para??ba	23
338	Paran??	23
339	Pernambuco	23
340	Piau??	23
341	R??o de Janeiro	23
342	R??o Grande del Norte	23
343	R??o Grande del Sur	23
344	Rondonia	23
345	Roraima	23
346	Santa Catarina	23
347	Sergipe	23
348	Tocantins	23
349	S??o Paulo	23
0	No Determinado	0
\.


--
-- TOC entry 2607 (class 0 OID 33504)
-- Dependencies: 240
-- Data for Name: distrito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.distrito (iddistrito, idprovincia, descripcion) FROM stdin;
1	1	CHACHAPOYAS
2	1	ASUNCION
3	1	BALSAS
4	1	CHETO
5	1	CHILIQUIN
6	1	CHUQUIBAMBA
7	1	GRANADA
8	1	HUANCAS
9	1	LA JALCA
10	1	LEIMEBAMBA
11	1	LEVANTO
12	1	MAGDALENA
13	1	MARISCAL CASTILLA
14	1	MOLINOPAMPA
15	1	MONTEVIDEO
16	1	OLLEROS
17	1	QUINJALCA
18	1	SAN FRANCISCO DE DAGUAS
19	1	SAN ISIDRO DE MAINO
20	1	SOLOCO
21	1	SONCHE
22	2	BAGUA
23	2	ARAMANGO
24	2	COPALLIN
25	2	EL PARCO
26	2	IMAZA
27	2	LA PECA
28	3	JUMBILLA
29	3	CHISQUILLA
30	3	CHURUJA
31	3	COROSHA
32	3	CUISPES
33	3	FLORIDA
34	3	JAZAN
35	3	RECTA
36	3	SAN CARLOS
37	3	SHIPASBAMBA
38	3	VALERA
39	3	YAMBRASBAMBA
40	4	NIEVA
41	4	EL CENEPA
42	4	RIO SANTIAGO
43	5	LAMUD
44	5	CAMPORREDONDO
45	5	COCABAMBA
46	5	COLCAMAR
47	5	CONILA
48	5	INGUILPATA
49	5	LONGUITA
50	5	LONYA CHICO
51	5	LUYA
52	5	LUYA VIEJO
53	5	MARIA
54	5	OCALLI
55	5	OCUMAL
56	5	PISUQUIA
57	5	PROVIDENCIA
58	5	SAN CRISTOBAL
59	5	SAN FRANCISCO DEL YESO
60	5	SAN JERONIMO
61	5	SAN JUAN DE LOPECANCHA
62	5	SANTA CATALINA
63	5	SANTO TOMAS
64	5	TINGO
65	5	TRITA
66	6	SAN NICOLAS
67	6	CHIRIMOTO
68	6	COCHAMAL
69	6	HUAMBO
70	6	LIMABAMBA
71	6	LONGAR
72	6	MARISCAL BENAVIDES
73	6	MILPUC
74	6	OMIA
75	6	SANTA ROSA
76	6	TOTORA
77	6	VISTA ALEGRE
78	7	BAGUA GRANDE
79	7	CAJARURO
80	7	CUMBA
81	7	EL MILAGRO
82	7	JAMALCA
83	7	LONYA GRANDE
84	7	YAMON
85	8	HUARAZ
86	8	COCHABAMBA
87	8	COLCABAMBA
88	8	HUANCHAY
89	8	INDEPENDENCIA
90	8	JANGAS
91	8	LA LIBERTAD
92	8	OLLEROS
93	8	PAMPAS
94	8	PARIACOTO
95	8	PIRA
96	8	TARICA
97	9	AIJA
98	9	CORIS
99	9	HUACLLAN
100	9	LA MERCED
101	9	SUCCHA
102	10	LLAMELLIN
103	10	ACZO
104	10	CHACCHO
105	10	CHINGAS
106	10	MIRGAS
107	10	SAN JUAN DE RONTOY
108	11	CHACAS
109	11	ACOCHACA
110	12	CHIQUIAN
111	12	ABELARDO PARDO LEZAMETA
112	12	ANTONIO RAYMONDI
113	12	AQUIA
114	12	CAJACAY
115	12	CANIS
116	12	COLQUIOC
117	12	HUALLANCA
118	12	HUASTA
119	12	HUAYLLACAYAN
120	12	LA PRIMAVERA
121	12	MANGAS
122	12	PACLLON
123	12	SAN MIGUEL DE CORPANQUI
124	12	TICLLOS
125	13	CARHUAZ
126	13	ACOPAMPA
127	13	AMASHCA
128	13	ANTA
129	13	ATAQUERO
130	13	MARCARA
131	13	PARIAHUANCA
132	13	SAN MIGUEL DE ACO
133	13	SHILLA
134	13	TINCO
135	13	YUNGAR
136	14	SAN LUIS
137	14	SAN NICOLAS
138	14	YAUYA
139	15	CASMA
140	15	BUENA VISTA ALTA
141	15	COMANDANTE NOEL
142	15	YAUTAN
143	16	CORONGO
144	16	ACO
145	16	BAMBAS
146	16	CUSCA
147	16	LA PAMPA
148	16	YANAC
149	16	YUPAN
150	17	HUARI
151	17	ANRA
152	17	CAJAY
153	17	CHAVIN DE HUANTAR
154	17	HUACACHI
155	17	HUACCHIS
156	17	HUACHIS
157	17	HUANTAR
158	17	MASIN
159	17	PAUCAS
160	17	PONTO
161	17	RAHUAPAMPA
162	17	RAPAYAN
163	17	SAN MARCOS
164	17	SAN PEDRO DE CHANA
165	17	UCO
166	18	HUARMEY
167	18	COCHAPETI
168	18	CULEBRAS
169	18	HUAYAN
170	18	MALVAS
171	19	CARAZ
172	19	HUALLANCA
173	19	HUATA
174	19	HUAYLAS
175	19	MATO
176	19	PAMPAROMAS
177	19	PUEBLO LIBRE
178	19	SANTA CRUZ
179	19	SANTO TORIBIO
180	19	YURACMARCA
181	20	PISCOBAMBA
182	20	CASCA
183	20	ELEAZAR GUZMAN BARRON
184	20	FIDEL OLIVAS ESCUDERO
185	20	LLAMA
186	20	LLUMPA
187	20	LUCMA
188	20	MUSGA
189	21	OCROS
190	21	ACAS
191	21	CAJAMARQUILLA
192	21	CARHUAPAMPA
193	21	COCHAS
194	21	CONGAS
195	21	LLIPA
196	21	SAN CRISTOBAL DE RAJAN
197	21	SAN PEDRO
198	21	SANTIAGO DE CHILCAS
199	22	CABANA
200	22	BOLOGNESI
201	22	CONCHUCOS
202	22	HUACASCHUQUE
203	22	HUANDOVAL
204	22	LACABAMBA
205	22	LLAPO
206	22	PALLASCA
207	22	PAMPAS
208	22	SANTA ROSA
209	22	TAUCA
210	23	POMABAMBA
211	23	HUAYLLAN
212	23	PAROBAMBA
213	23	QUINUABAMBA
214	24	RECUAY
215	24	CATAC
216	24	COTAPARACO
217	24	HUAYLLAPAMPA
218	24	LLACLLIN
219	24	MARCA
220	24	PAMPAS CHICO
221	24	PARARIN
222	24	TAPACOCHA
223	24	TICAPAMPA
224	25	CHIMBOTE
225	25	CACERES DEL PERU
226	25	COISHCO
227	25	MACATE
228	25	MORO
229	25	NEPE??A
230	25	SAMANCO
231	25	SANTA
232	25	NUEVO CHIMBOTE
233	26	SIHUAS
234	26	ACOBAMBA
235	26	ALFONSO UGARTE
236	26	CASHAPAMPA
237	26	CHINGALPO
238	26	HUAYLLABAMBA
239	26	QUICHES
240	26	RAGASH
241	26	SAN JUAN
242	26	SICSIBAMBA
243	27	YUNGAY
244	27	CASCAPARA
245	27	MANCOS
246	27	MATACOTO
247	27	QUILLO
248	27	RANRAHIRCA
249	27	SHUPLUY
250	27	YANAMA
251	28	ABANCAY
252	28	CHACOCHE
253	28	CIRCA
254	28	CURAHUASI
255	28	HUANIPACA
256	28	LAMBRAMA
257	28	PICHIRHUA
258	28	SAN PEDRO DE CACHORA
259	28	TAMBURCO
260	29	ANDAHUAYLAS
261	29	ANDARAPA
262	29	CHIARA
263	29	HUANCARAMA
264	29	HUANCARAY
265	29	HUAYANA
266	29	KISHUARA
267	29	PACOBAMBA
268	29	PACUCHA
269	29	PAMPACHIRI
270	29	POMACOCHA
271	29	SAN ANTONIO DE CACHI
272	29	SAN JERONIMO
273	29	SAN MIGUEL DE CHACCRAMPA
274	29	SANTA MARIA DE CHICMO
275	29	TALAVERA
276	29	TUMAY HUARACA
277	29	TURPO
278	29	KAQUIABAMBA
279	30	ANTABAMBA
280	30	EL ORO
281	30	HUAQUIRCA
282	30	JUAN ESPINOZA MEDRANO
283	30	OROPESA
284	30	PACHACONAS
285	30	SABAINO
286	31	CHALHUANCA
287	31	CAPAYA
288	31	CARAYBAMBA
289	31	CHAPIMARCA
290	31	COLCABAMBA
291	31	COTARUSE
292	31	HUAYLLO
293	31	JUSTO APU SAHUARAURA
294	31	LUCRE
295	31	POCOHUANCA
296	31	SAN JUAN DE CHAC??A
297	31	SA??AYCA
298	31	SORAYA
299	31	TAPAIRIHUA
300	31	TINTAY
301	31	TORAYA
302	31	YANACA
303	32	TAMBOBAMBA
304	32	COTABAMBAS
305	32	COYLLURQUI
306	32	HAQUIRA
307	32	MARA
308	32	CHALLHUAHUACHO
309	33	CHINCHEROS
310	33	ANCO_HUALLO
311	33	COCHARCAS
312	33	HUACCANA
313	33	OCOBAMBA
314	33	ONGOY
315	33	URANMARCA
316	33	RANRACANCHA
317	34	CHUQUIBAMBILLA
318	34	CURPAHUASI
319	34	GAMARRA
320	34	HUAYLLATI
321	34	MAMARA
322	34	MICAELA BASTIDAS
323	34	PATAYPAMPA
324	34	PROGRESO
325	34	SAN ANTONIO
326	34	SANTA ROSA
327	34	TURPAY
328	34	VILCABAMBA
329	34	VIRUNDO
330	34	CURASCO
331	35	AREQUIPA
332	35	ALTO SELVA ALEGRE
333	35	CAYMA
334	35	CERRO COLORADO
335	35	CHARACATO
336	35	CHIGUATA
337	35	JACOBO HUNTER
338	35	LA JOYA
339	35	MARIANO MELGAR
340	35	MIRAFLORES
341	35	MOLLEBAYA
342	35	PAUCARPATA
343	35	POCSI
344	35	POLOBAYA
345	35	QUEQUE??A
346	35	SABANDIA
347	35	SACHACA
348	35	SAN JUAN DE SIGUAS
349	35	SAN JUAN DE TARUCANI
350	35	SANTA ISABEL DE SIGUAS
351	35	SANTA RITA DE SIGUAS
352	35	SOCABAYA
353	35	TIABAYA
354	35	UCHUMAYO
355	35	VITOR
356	35	YANAHUARA
357	35	YARABAMBA
358	35	YURA
359	35	JOSE LUIS BUSTAMANTE Y RIVERO
360	36	CAMANA
361	36	JOSE MARIA QUIMPER
362	36	MARIANO NICOLAS VALCARCEL
363	36	MARISCAL CACERES
364	36	NICOLAS DE PIEROLA
365	36	OCO??A
366	36	QUILCA
367	36	SAMUEL PASTOR
368	37	CARAVELI
369	37	ACARI
370	37	ATICO
371	37	ATIQUIPA
372	37	BELLA UNION
373	37	CAHUACHO
374	37	CHALA
375	37	CHAPARRA
376	37	HUANUHUANU
377	37	JAQUI
378	37	LOMAS
379	37	QUICACHA
380	37	YAUCA
381	38	APLAO
382	38	ANDAGUA
383	38	AYO
384	38	CHACHAS
385	38	CHILCAYMARCA
386	38	CHOCO
387	38	HUANCARQUI
388	38	MACHAGUAY
389	38	ORCOPAMPA
390	38	PAMPACOLCA
391	38	TIPAN
392	38	U??ON
393	38	URACA
394	38	VIRACO
395	39	CHIVAY
396	39	ACHOMA
397	39	CABANACONDE
398	39	CALLALLI
399	39	CAYLLOMA
400	39	COPORAQUE
401	39	HUAMBO
402	39	HUANCA
403	39	ICHUPAMPA
404	39	LARI
405	39	LLUTA
406	39	MACA
407	39	MADRIGAL
408	39	SAN ANTONIO DE CHUCA
409	39	SIBAYO
410	39	TAPAY
411	39	TISCO
412	39	TUTI
413	39	YANQUE
414	39	MAJES
415	40	CHUQUIBAMBA
416	40	ANDARAY
417	40	CAYARANI
418	40	CHICHAS
419	40	IRAY
420	40	RIO GRANDE
421	40	SALAMANCA
422	40	YANAQUIHUA
423	41	MOLLENDO
424	41	COCACHACRA
425	41	DEAN VALDIVIA
426	41	ISLAY
427	41	MEJIA
428	41	PUNTA DE BOMBON
429	42	COTAHUASI
430	42	ALCA
431	42	CHARCANA
432	42	HUAYNACOTAS
433	42	PAMPAMARCA
434	42	PUYCA
435	42	QUECHUALLA
436	42	SAYLA
437	42	TAURIA
438	42	TOMEPAMPA
439	42	TORO
440	43	AYACUCHO
441	43	ACOCRO
442	43	ACOS VINCHOS
443	43	CARMEN ALTO
444	43	CHIARA
445	43	OCROS
446	43	PACAYCASA
447	43	QUINUA
448	43	SAN JOSE DE TICLLAS
449	43	SAN JUAN BAUTISTA
450	43	SANTIAGO DE PISCHA
451	43	SOCOS
452	43	TAMBILLO
453	43	VINCHOS
454	43	JESUS NAZARENO
455	44	CANGALLO
456	44	CHUSCHI
457	44	LOS MOROCHUCOS
458	44	MARIA PARADO DE BELLIDO
459	44	PARAS
460	44	TOTOS
461	45	SANCOS
462	45	CARAPO
463	45	SACSAMARCA
464	45	SANTIAGO DE LUCANAMARCA
465	46	HUANTA
466	46	AYAHUANCO
467	46	HUAMANGUILLA
468	46	IGUAIN
469	46	LURICOCHA
470	46	SANTILLANA
471	46	SIVIA
472	46	LLOCHEGUA
473	47	SAN MIGUEL
474	47	ANCO
475	47	AYNA
476	47	CHILCAS
477	47	CHUNGUI
478	47	LUIS CARRANZA
479	47	SANTA ROSA
480	47	TAMBO
481	48	PUQUIO
482	48	AUCARA
483	48	CABANA
484	48	CARMEN SALCEDO
485	48	CHAVI??A
486	48	CHIPAO
487	48	HUAC-HUAS
488	48	LARAMATE
489	48	LEONCIO PRADO
490	48	LLAUTA
491	48	LUCANAS
492	48	OCA??A
493	48	OTOCA
494	48	SAISA
495	48	SAN CRISTOBAL
496	48	SAN JUAN
497	48	SAN PEDRO
498	48	SAN PEDRO DE PALCO
499	48	SANCOS
500	48	SANTA ANA DE HUAYCAHUACHO
501	48	SANTA LUCIA
502	49	CORACORA
503	49	CHUMPI
504	49	CORONEL CASTA??EDA
505	49	PACAPAUSA
506	49	PULLO
507	49	PUYUSCA
508	49	SAN FRANCISCO DE RAVACAYCO
509	49	UPAHUACHO
510	50	PAUSA
511	50	COLTA
512	50	CORCULLA
513	50	LAMPA
514	50	MARCABAMBA
515	50	OYOLO
516	50	PARARCA
517	50	SAN JAVIER DE ALPABAMBA
518	50	SAN JOSE DE USHUA
519	50	SARA SARA
520	51	QUEROBAMBA
521	51	BELEN
522	51	CHALCOS
523	51	CHILCAYOC
524	51	HUACA??A
525	51	MORCOLLA
526	51	PAICO
527	51	SAN PEDRO DE LARCAY
528	51	SAN SALVADOR DE QUIJE
529	51	SANTIAGO DE PAUCARAY
530	51	SORAS
531	52	HUANCAPI
532	52	ALCAMENCA
533	52	APONGO
534	52	ASQUIPATA
535	52	CANARIA
536	52	CAYARA
537	52	COLCA
538	52	HUAMANQUIQUIA
539	52	HUANCARAYLLA
540	52	HUAYA
541	52	SARHUA
542	52	VILCANCHOS
543	53	VILCAS HUAMAN
544	53	ACCOMARCA
545	53	CARHUANCA
546	53	CONCEPCION
547	53	HUAMBALPA
548	53	INDEPENDENCIA
549	53	SAURAMA
550	53	VISCHONGO
551	54	CAJAMARCA
552	54	ASUNCION
553	54	CHETILLA
554	54	COSPAN
555	54	ENCA??ADA
556	54	JESUS
557	54	LLACANORA
558	54	LOS BA??OS DEL INCA
559	54	MAGDALENA
560	54	MATARA
561	54	NAMORA
562	54	SAN JUAN
563	55	CAJABAMBA
564	55	CACHACHI
565	55	CONDEBAMBA
566	55	SITACOCHA
567	56	CELENDIN
568	56	CHUMUCH
569	56	CORTEGANA
570	56	HUASMIN
571	56	JORGE CHAVEZ
572	56	JOSE GALVEZ
573	56	MIGUEL IGLESIAS
574	56	OXAMARCA
575	56	SOROCHUCO
576	56	SUCRE
577	56	UTCO
578	56	LA LIBERTAD DE PALLAN
579	57	CHOTA
580	57	ANGUIA
581	57	CHADIN
582	57	CHIGUIRIP
583	57	CHIMBAN
584	57	CHOROPAMPA
585	57	COCHABAMBA
586	57	CONCHAN
587	57	HUAMBOS
588	57	LAJAS
589	57	LLAMA
590	57	MIRACOSTA
591	57	PACCHA
592	57	PION
593	57	QUEROCOTO
594	57	SAN JUAN DE LICUPIS
595	57	TACABAMBA
596	57	TOCMOCHE
597	57	CHALAMARCA
598	58	CONTUMAZA
599	58	CHILETE
600	58	CUPISNIQUE
601	58	GUZMANGO
602	58	SAN BENITO
603	58	SANTA CRUZ DE TOLED
604	58	TANTARICA
605	58	YONAN
606	59	CUTERVO
607	59	CALLAYUC
608	59	CHOROS
609	59	CUJILLO
610	59	LA RAMADA
611	59	PIMPINGOS
612	59	QUEROCOTILLO
613	59	SAN ANDRES DE CUTERVO
614	59	SAN JUAN DE CUTERVO
615	59	SAN LUIS DE LUCMA
616	59	SANTA CRUZ
617	59	SANTO DOMINGO DE LA CAPILLA
618	59	SANTO TOMAS
619	59	SOCOTA
620	59	TORIBIO CASANOVA
621	60	BAMBAMARCA
622	60	CHUGUR
623	60	HUALGAYOC
624	61	JAEN
625	61	BELLAVISTA
626	61	CHONTALI
627	61	COLASAY
628	61	HUABAL
629	61	LAS PIRIAS
630	61	POMAHUACA
631	61	PUCARA
632	61	SALLIQUE
633	61	SAN FELIPE
634	61	SAN JOSE DEL ALTO
635	61	SANTA ROSA
636	62	SAN IGNACIO
637	62	CHIRINOS
638	62	HUARANGO
639	62	LA COIPA
640	62	NAMBALLE
641	62	SAN JOSE DE LOURDES
642	62	TABACONAS
643	63	PEDRO GALVEZ
644	63	CHANCAY
645	63	EDUARDO VILLANUEVA
646	63	GREGORIO PITA
647	63	ICHOCAN
648	63	JOSE MANUEL QUIROZ
649	63	JOSE SABOGAL
650	64	SAN MIGUEL
651	64	BOLIVAR
652	64	CALQUIS
653	64	CATILLUC
654	64	EL PRADO
655	64	LA FLORIDA
656	64	LLAPA
657	64	NANCHOC
658	64	NIEPOS
659	64	SAN GREGORIO
660	64	SAN SILVESTRE DE COCHAN
661	64	TONGOD
662	64	UNION AGUA BLANCA
663	65	SAN PABLO
664	65	SAN BERNARDINO
665	65	SAN LUIS
666	65	TUMBADEN
667	66	SANTA CRUZ
668	66	ANDABAMBA
669	66	CATACHE
670	66	CHANCAYBA??OS
671	66	LA ESPERANZA
672	66	NINABAMBA
673	66	PULAN
674	66	SAUCEPAMPA
675	66	SEXI
676	66	UTICYACU
677	66	YAUYUCAN
678	67	CALLAO
679	67	BELLAVISTA
680	67	CARMEN DE LA LEGUA REYNOSO
681	67	LA PERLA
682	67	LA PUNTA
683	67	VENTANILLA
684	68	CUSCO
685	68	CCORCA
686	68	POROY
687	68	SAN JERONIMO
688	68	SAN SEBASTIAN
689	68	SANTIAGO
690	68	SAYLLA
691	68	WANCHAQ
692	69	ACOMAYO
693	69	ACOPIA
694	69	ACOS
695	69	MOSOC LLACTA
696	69	POMACANCHI
697	69	RONDOCAN
698	69	SANGARARA
699	70	ANTA
700	70	ANCAHUASI
701	70	CACHIMAYO
702	70	CHINCHAYPUJIO
703	70	HUAROCONDO
704	70	LIMATAMBO
705	70	MOLLEPATA
706	70	PUCYURA
707	70	ZURITE
708	71	CALCA
709	71	COYA
710	71	LAMAY
711	71	LARES
712	71	PISAC
713	71	SAN SALVADOR
714	71	TARAY
715	71	YANATILE
716	72	YANAOCA
717	72	CHECCA
718	72	KUNTURKANKI
719	72	LANGUI
720	72	LAYO
721	72	PAMPAMARCA
722	72	QUEHUE
723	72	TUPAC AMARU
724	73	SICUANI
725	73	CHECACUPE
726	73	COMBAPATA
727	73	MARANGANI
728	73	PITUMARCA
729	73	SAN PABLO
730	73	SAN PEDRO
731	73	TINTA
732	74	SANTO TOMAS
733	74	CAPACMARCA
734	74	CHAMACA
735	74	COLQUEMARCA
736	74	LIVITACA
737	74	LLUSCO
738	74	QUI??OTA
739	74	VELILLE
740	75	ESPINAR
741	75	CONDOROMA
742	75	COPORAQUE
743	75	OCORURO
744	75	PALLPATA
745	75	PICHIGUA
746	75	SUYCKUTAMBO
747	75	ALTO PICHIGUA
748	76	SANTA ANA
749	76	ECHARATE
750	76	HUAYOPATA
751	76	MARANURA
752	76	OCOBAMBA
753	76	QUELLOUNO
754	76	KIMBIRI
755	76	SANTA TERESA
756	76	VILCABAMBA
757	76	PICHARI
758	77	PARURO
759	77	ACCHA
760	77	CCAPI
761	77	COLCHA
762	77	HUANOQUITE
763	77	OMACHA
764	77	PACCARITAMBO
765	77	PILLPINTO
766	77	YAURISQUE
767	78	PAUCARTAMBO
768	78	CAICAY
769	78	CHALLABAMBA
770	78	COLQUEPATA
771	78	HUANCARANI
772	78	KOS??IPATA
773	79	URCOS
774	79	ANDAHUAYLILLAS
775	79	CAMANTI
776	79	CCARHUAYO
777	79	CCATCA
778	79	CUSIPATA
779	79	HUARO
780	79	LUCRE
781	79	MARCAPATA
782	79	OCONGATE
783	79	OROPESA
784	79	QUIQUIJANA
785	80	URUBAMBA
786	80	CHINCHERO
787	80	HUAYLLABAMBA
788	80	MACHUPICCHU
789	80	MARAS
790	80	OLLANTAYTAMBO
791	80	YUCAY
792	81	HUANCAVELICA
793	81	ACOBAMBILLA
794	81	ACORIA
795	81	CONAYCA
796	81	CUENCA
797	81	HUACHOCOLPA
798	81	HUAYLLAHUARA
799	81	IZCUCHACA
800	81	LARIA
801	81	MANTA
802	81	MARISCAL CACERES
803	81	MOYA
804	81	NUEVO OCCORO
805	81	PALCA
806	81	PILCHACA
807	81	VILCA
808	81	YAULI
809	81	ASCENSION
810	81	HUANDO
811	82	ACOBAMBA
812	82	ANDABAMBA
813	82	ANTA
814	82	CAJA
815	82	MARCAS
816	82	PAUCARA
817	82	POMACOCHA
818	82	ROSARIO
819	83	LIRCAY
820	83	ANCHONGA
821	83	CALLANMARCA
822	83	CCOCHACCASA
823	83	CHINCHO
824	83	CONGALLA
825	83	HUANCA-HUANCA
826	83	HUAYLLAY GRANDE
827	83	JULCAMARCA
828	83	SAN ANTONIO DE ANTAPARCO
829	83	SANTO TOMAS DE PATA
830	83	SECCLLA
831	84	CASTROVIRREYNA
832	84	ARMA
833	84	AURAHUA
834	84	CAPILLAS
835	84	CHUPAMARCA
836	84	COCAS
837	84	HUACHOS
838	84	HUAMATAMBO
839	84	MOLLEPAMPA
840	84	SAN JUAN
841	84	SANTA ANA
842	84	TANTARA
843	84	TICRAPO
844	85	CHURCAMPA
845	85	ANCO
846	85	CHINCHIHUASI
847	85	EL CARMEN
848	85	LA MERCED
849	85	LOCROJA
850	85	PAUCARBAMBA
851	85	SAN MIGUEL DE MAYOCC
852	85	SAN PEDRO DE CORIS
853	85	PACHAMARCA
854	86	HUAYTARA
855	86	AYAVI
856	86	CORDOVA
857	86	HUAYACUNDO ARMA
858	86	LARAMARCA
859	86	OCOYO
860	86	PILPICHACA
861	86	QUERCO
862	86	QUITO-ARMA
863	86	SAN ANTONIO DE CUSICANCHA
864	86	SAN FRANCISCO DE SANGAYAICO
865	86	SAN ISIDRO
866	86	SANTIAGO DE CHOCORVOS
867	86	SANTIAGO DE QUIRAHUARA
868	86	SANTO DOMINGO DE CAPILLAS
869	86	TAMBO
870	87	PAMPAS
871	87	ACOSTAMBO
872	87	ACRAQUIA
873	87	AHUAYCHA
874	87	COLCABAMBA
875	87	DANIEL HERNANDEZ
876	87	HUACHOCOLPA
877	87	HUARIBAMBA
878	87	??AHUIMPUQUIO
879	87	PAZOS
880	87	QUISHUAR
881	87	SALCABAMBA
882	87	SALCAHUASI
883	87	SAN MARCOS DE ROCCHAC
884	87	SURCUBAMBA
885	87	TINTAY PUNCU
886	88	HUANUCO
887	88	AMARILIS
888	88	CHINCHAO
889	88	CHURUBAMBA
890	88	MARGOS
891	88	QUISQUI
892	88	SAN FRANCISCO DE CAYRAN
893	88	SAN PEDRO DE CHAULAN
894	88	SANTA MARIA DEL VALLE
895	88	YARUMAYO
896	88	PILLCO MARCA
897	89	AMBO
898	89	CAYNA
899	89	COLPAS
900	89	CONCHAMARCA
901	89	HUACAR
902	89	SAN FRANCISCO
903	89	SAN RAFAEL
904	89	TOMAY KICHWA
905	90	LA UNION
906	90	CHUQUIS
907	90	MARIAS
908	90	PACHAS
909	90	QUIVILLA
910	90	RIPAN
911	90	SHUNQUI
912	90	SILLAPATA
913	90	YANAS
914	91	HUACAYBAMBA
915	91	CANCHABAMBA
916	91	COCHABAMBA
917	91	PINRA
918	92	LLATA
919	92	ARANCAY
920	92	CHAVIN DE PARIARCA
921	92	JACAS GRANDE
922	92	JIRCAN
923	92	MIRAFLORES
924	92	MONZON
925	92	PUNCHAO
926	92	PU??OS
927	92	SINGA
928	92	TANTAMAYO
929	93	RUPA-RUPA
930	93	DANIEL ALOMIAS ROBLES
931	93	HERMILIO VALDIZAN
932	93	JOSE CRESPO Y CASTILLO
933	93	LUYANDO
934	93	MARIANO DAMASO BERAUN
935	94	HUACRACHUCO
936	94	CHOLON
937	94	SAN BUENAVENTURA
938	95	PANAO
939	95	CHAGLLA
940	95	MOLINO
941	95	UMARI
942	96	PUERTO INCA
943	96	CODO DEL POZUZO
944	96	HONORIA
945	96	TOURNAVISTA
946	96	YUYAPICHIS
947	97	JESUS
948	97	BA??OS
949	97	JIVIA
950	97	QUEROPALCA
951	97	RONDOS
952	97	SAN FRANCISCO DE ASIS
953	97	SAN MIGUEL DE CAURI
954	98	CHAVINILLO
955	98	CAHUAC
956	98	CHACABAMBA
957	98	APARICIO POMARES
958	98	JACAS CHICO
959	98	OBAS
960	98	PAMPAMARCA
961	98	CHORAS
962	99	ICA
963	99	LA TINGUI??A
964	99	LOS AQUIJES
965	99	OCUCAJE
966	99	PACHACUTEC
967	99	PARCONA
968	99	PUEBLO NUEVO
969	99	SALAS
970	99	SAN JOSE DE LOS MOLINOS
971	99	SAN JUAN BAUTISTA
972	99	SANTIAGO
973	99	SUBTANJALLA
974	99	TATE
975	99	YAUCA DEL ROSARIO
976	100	CHINCHA ALTA
977	100	ALTO LARAN
978	100	CHAVIN
979	100	CHINCHA BAJA
980	100	EL CARMEN
981	100	GROCIO PRADO
982	100	PUEBLO NUEVO
983	100	SAN JUAN DE YANAC
984	100	SAN PEDRO DE HUACARPANA
985	100	SUNAMPE
986	100	TAMBO DE MORA
987	101	NAZCA
988	101	CHANGUILLO
989	101	EL INGENIO
990	101	MARCONA
991	101	VISTA ALEGRE
992	102	PALPA
993	102	LLIPATA
994	102	RIO GRANDE
995	102	SANTA CRUZ
996	102	TIBILLO
997	103	PISCO
998	103	HUANCANO
999	103	HUMAY
1000	103	INDEPENDENCIA
1001	103	PARACAS
1002	103	SAN ANDRES
1003	103	SAN CLEMENTE
1004	103	TUPAC AMARU INCA
1005	104	HUANCAYO
1006	104	CARHUACALLANGA
1007	104	CHACAPAMPA
1008	104	CHICCHE
1009	104	CHILCA
1010	104	CHONGOS ALTO
1011	104	CHUPURO
1012	104	COLCA
1013	104	CULLHUAS
1014	104	EL TAMBO
1015	104	HUACRAPUQUIO
1016	104	HUALHUAS
1017	104	HUANCAN
1018	104	HUASICANCHA
1019	104	HUAYUCACHI
1020	104	INGENIO
1021	104	PARIAHUANCA
1022	104	PILCOMAYO
1023	104	PUCARA
1024	104	QUICHUAY
1025	104	QUILCAS
1026	104	SAN AGUSTIN
1027	104	SAN JERONIMO DE TUNAN
1028	104	SA??O
1029	104	SAPALLANGA
1030	104	SICAYA
1031	104	SANTO DOMINGO DE ACOBAMBA
1032	104	VIQUES
1033	105	CONCEPCION
1034	105	ACO
1035	105	ANDAMARCA
1036	105	CHAMBARA
1037	105	COCHAS
1038	105	COMAS
1039	105	HEROINAS TOLEDO
1040	105	MANZANARES
1041	105	MARISCAL CASTILLA
1042	105	MATAHUASI
1043	105	MITO
1044	105	NUEVE DE JULIO
1045	105	ORCOTUNA
1046	105	SAN JOSE DE QUERO
1047	105	SANTA ROSA DE OCOPA
1048	106	CHANCHAMAYO
1049	106	PERENE
1050	106	PICHANAQUI
1051	106	SAN LUIS DE SHUARO
1052	106	SAN RAMON
1053	106	VITOC
1054	107	JAUJA
1055	107	ACOLLA
1056	107	APATA
1057	107	ATAURA
1058	107	CANCHAYLLO
1059	107	CURICACA
1060	107	EL MANTARO
1061	107	HUAMALI
1062	107	HUARIPAMPA
1063	107	HUERTAS
1064	107	JANJAILLO
1065	107	JULCAN
1066	107	LEONOR ORDO??EZ
1067	107	LLOCLLAPAMPA
1068	107	MARCO
1069	107	MASMA
1070	107	MASMA CHICCHE
1071	107	MOLINOS
1072	107	MONOBAMBA
1073	107	MUQUI
1074	107	MUQUIYAUYO
1075	107	PACA
1076	107	PACCHA
1077	107	PANCAN
1078	107	PARCO
1079	107	POMACANCHA
1080	107	RICRAN
1081	107	SAN LORENZO
1082	107	SAN PEDRO DE CHUNAN
1083	107	SAUSA
1084	107	SINCOS
1085	107	TUNAN MARCA
1086	107	YAULI
1087	107	YAUYOS
1088	108	JUNIN
1089	108	CARHUAMAYO
1090	108	ONDORES
1091	108	ULCUMAYO
1092	109	SATIPO
1093	109	COVIRIALI
1094	109	LLAYLLA
1095	109	MAZAMARI
1096	109	PAMPA HERMOSA
1097	109	PANGOA
1098	109	RIO NEGRO
1099	109	RIO TAMBO
1100	110	TARMA
1101	110	ACOBAMBA
1102	110	HUARICOLCA
1103	110	HUASAHUASI
1104	110	LA UNION
1105	110	PALCA
1106	110	PALCAMAYO
1107	110	SAN PEDRO DE CAJAS
1108	110	TAPO
1109	111	LA OROYA
1110	111	CHACAPALPA
1111	111	HUAY-HUAY
1112	111	MARCAPOMACOCHA
1113	111	MOROCOCHA
1114	111	PACCHA
1115	111	SANTA BARBARA DE CARHUACAYAN
1116	111	SANTA ROSA DE SACCO
1117	111	SUITUCANCHA
1118	111	YAULI
1119	112	CHUPACA
1120	112	AHUAC
1121	112	CHONGOS BAJO
1122	112	HUACHAC
1123	112	HUAMANCACA CHICO
1124	112	SAN JUAN DE YSCOS
1125	112	SAN JUAN DE JARPA
1126	112	TRES DE DICIEMBRE
1127	112	YANACANCHA
1128	113	TRUJILLO
1129	113	EL PORVENIR
1130	113	FLORENCIA DE MORA
1131	113	HUANCHACO
1132	113	LA ESPERANZA
1133	113	LAREDO
1134	113	MOCHE
1135	113	POROTO
1136	113	SALAVERRY
1137	113	SIMBAL
1138	113	VICTOR LARCO HERRERA
1139	114	ASCOPE
1140	114	CHICAMA
1141	114	CHOCOPE
1142	114	MAGDALENA DE CAO
1143	114	PAIJAN
1144	114	RAZURI
1145	114	SANTIAGO DE CAO
1146	114	CASA GRANDE
1147	115	BOLIVAR
1148	115	BAMBAMARCA
1149	115	CONDORMARCA
1150	115	LONGOTEA
1151	115	UCHUMARCA
1152	115	UCUNCHA
1153	116	CHEPEN
1154	116	PACANGA
1155	116	PUEBLO NUEVO
1156	117	JULCAN
1157	117	CALAMARCA
1158	117	CARABAMBA
1159	117	HUASO
1160	118	OTUZCO
1161	118	AGALLPAMPA
1162	118	CHARAT
1163	118	HUARANCHAL
1164	118	LA CUESTA
1165	118	MACHE
1166	118	PARANDAY
1167	118	SALPO
1168	118	SINSICAP
1169	118	USQUIL
1170	119	SAN PEDRO DE LLOC
1171	119	GUADALUPE
1172	119	JEQUETEPEQUE
1173	119	PACASMAYO
1174	119	SAN JOSE
1175	120	TAYABAMBA
1176	120	BULDIBUYO
1177	120	CHILLIA
1178	120	HUANCASPATA
1179	120	HUAYLILLAS
1180	120	HUAYO
1181	120	ONGON
1182	120	PARCOY
1183	120	PATAZ
1184	120	PIAS
1185	120	SANTIAGO DE CHALLAS
1186	120	TAURIJA
1187	120	URPAY
1188	121	HUAMACHUCO
1189	121	CHUGAY
1190	121	COCHORCO
1191	121	CURGOS
1192	121	MARCABAL
1193	121	SANAGORAN
1194	121	SARIN
1195	121	SARTIMBAMBA
1196	122	SANTIAGO DE CHUCO
1197	122	ANGASMARCA
1198	122	CACHICADAN
1199	122	MOLLEBAMBA
1200	122	MOLLEPATA
1201	122	QUIRUVILCA
1202	122	SANTA CRUZ DE CHUCA
1203	122	SITABAMBA
1204	123	CASCAS
1205	123	LUCMA
1206	123	MARMOT
1207	123	SAYAPULLO
1208	124	VIRU
1209	124	CHAO
1210	124	GUADALUPITO
1211	125	CHICLAYO
1212	125	CHONGOYAPE
1213	125	ETEN
1214	125	ETEN PUERTO
1215	125	JOSE LEONARDO ORTIZ
1216	125	LA VICTORIA
1217	125	LAGUNAS
1218	125	MONSEFU
1219	125	NUEVA ARICA
1220	125	OYOTUN
1221	125	PICSI
1222	125	PIMENTEL
1223	125	REQUE
1224	125	SANTA ROSA
1225	125	SA??A
1226	125	CAYALTI
1227	125	PATAPO
1228	125	POMALCA
1229	125	PUCALA
1230	125	TUMAN
1231	126	FERRE??AFE
1232	126	CA??ARIS
1233	126	INCAHUASI
1234	126	MANUEL ANTONIO MESONES MURO
1235	126	PITIPO
1236	126	PUEBLO NUEVO
1237	127	LAMBAYEQUE
1238	127	CHOCHOPE
1239	127	ILLIMO
1240	127	JAYANCA
1241	127	MOCHUMI
1242	127	MORROPE
1243	127	MOTUPE
1244	127	OLMOS
1245	127	PACORA
1246	127	SALAS
1247	127	SAN JOSE
1248	127	TUCUME
1249	128	LIMA
1250	128	ANCON
1251	128	ATE
1252	128	BARRANCO
1253	128	BRE??A
1254	128	CARABAYLLO
1255	128	CHACLACAYO
1256	128	CHORRILLOS
1257	128	CIENEGUILLA
1258	128	COMAS
1259	128	EL AGUSTINO
1260	128	INDEPENDENCIA
1261	128	JESUS MARIA
1262	128	LA MOLINA
1263	128	LA VICTORIA
1264	128	LINCE
1265	128	LOS OLIVOS
1266	128	LURIGANCHO
1267	128	LURIN
1268	128	MAGDALENA DEL MAR
1269	128	MAGDALENA VIEJA
1270	128	MIRAFLORES
1271	128	PACHACAMAC
1272	128	PUCUSANA
1273	128	PUENTE PIEDRA
1274	128	PUNTA HERMOSA
1275	128	PUNTA NEGRA
1276	128	RIMAC
1277	128	SAN BARTOLO
1278	128	SAN BORJA
1279	128	SAN ISIDRO
1280	128	SAN JUAN DE LURIGANCHO
1281	128	SAN JUAN DE MIRAFLORES
1282	128	SAN LUIS
1283	128	SAN MARTIN DE PORRES
1284	128	SAN MIGUEL
1285	128	SANTA ANITA
1286	128	SANTA MARIA DEL MAR
1287	128	SANTA ROSA
1288	128	SANTIAGO DE SURCO
1289	128	SURQUILLO
1290	128	VILLA EL SALVADOR
1291	128	VILLA MARIA DEL TRIUNFO
1292	129	BARRANCA
1293	129	PARAMONGA
1294	129	PATIVILCA
1295	129	SUPE
1296	129	SUPE PUERTO
1297	130	CAJATAMBO
1298	130	COPA
1299	130	GORGOR
1300	130	HUANCAPON
1301	130	MANAS
1302	131	CANTA
1303	131	ARAHUAY
1304	131	HUAMANTANGA
1305	131	HUAROS
1306	131	LACHAQUI
1307	131	SAN BUENAVENTURA
1308	131	SANTA ROSA DE QUIVES
1309	132	SAN VICENTE DE CA??ETE
1310	132	ASIA
1311	132	CALANGO
1312	132	CERRO AZUL
1313	132	CHILCA
1314	132	COAYLLO
1315	132	IMPERIAL
1316	132	LUNAHUANA
1317	132	MALA
1318	132	NUEVO IMPERIAL
1319	132	PACARAN
1320	132	QUILMANA
1321	132	SAN ANTONIO
1322	132	SAN LUIS
1323	132	SANTA CRUZ DE FLORES
1324	132	ZU??IGA
1325	133	HUARAL
1326	133	ATAVILLOS ALTO
1327	133	ATAVILLOS BAJO
1328	133	AUCALLAMA
1329	133	CHANCAY
1330	133	IHUARI
1331	133	LAMPIAN
1332	133	PACARAOS
1333	133	SAN MIGUEL DE ACOS
1334	133	SANTA CRUZ DE ANDAMARCA
1335	133	SUMBILCA
1336	133	VEINTISIETE DE NOVIEMBRE
1337	134	MATUCANA
1338	134	ANTIOQUIA
1339	134	CALLAHUANCA
1340	134	CARAMPOMA
1341	134	CHICLA
1342	134	CUENCA
1343	134	HUACHUPAMPA
1344	134	HUANZA
1345	134	HUAROCHIRI
1346	134	LAHUAYTAMBO
1347	134	LANGA
1348	134	LARAOS
1349	134	MARIATANA
1350	134	RICARDO PALMA
1351	134	SAN ANDRES DE TUPICOCHA
1352	134	SAN ANTONIO
1353	134	SAN BARTOLOME
1354	134	SAN DAMIAN
1355	134	SAN JUAN DE IRIS
1356	134	SAN JUAN DE TANTARANCHE
1357	134	SAN LORENZO DE QUINTI
1358	134	SAN MATEO
1359	134	SAN MATEO DE OTAO
1360	134	SAN PEDRO DE CASTA
1361	134	SAN PEDRO DE HUANCAYRE
1362	134	SANGALLAYA
1363	134	SANTA CRUZ DE COCACHACRA
1364	134	SANTA EULALIA
1365	134	SANTIAGO DE ANCHUCAYA
1366	134	SANTIAGO DE TUNA
1367	134	SANTO DOMINGO DE LOS OLLEROS
1368	134	SURCO
1369	135	HUACHO
1370	135	AMBAR
1371	135	CALETA DE CARQUIN
1372	135	CHECRAS
1373	135	HUALMAY
1374	135	HUAURA
1375	135	LEONCIO PRADO
1376	135	PACCHO
1377	135	SANTA LEONOR
1378	135	SANTA MARIA
1379	135	SAYAN
1380	135	VEGUETA
1381	136	OYON
1382	136	ANDAJES
1383	136	CAUJUL
1384	136	COCHAMARCA
1385	136	NAVAN
1386	136	PACHANGARA
1387	137	YAUYOS
1388	137	ALIS
1389	137	AYAUCA
1390	137	AYAVIRI
1391	137	AZANGARO
1392	137	CACRA
1393	137	CARANIA
1394	137	CATAHUASI
1395	137	CHOCOS
1396	137	COCHAS
1397	137	COLONIA
1398	137	HONGOS
1399	137	HUAMPARA
1400	137	HUANCAYA
1401	137	HUANGASCAR
1402	137	HUANTAN
1403	137	HUA??EC
1404	137	LARAOS
1405	137	LINCHA
1406	137	MADEAN
1407	137	MIRAFLORES
1408	137	OMAS
1409	137	PUTINZA
1410	137	QUINCHES
1411	137	QUINOCAY
1412	137	SAN JOAQUIN
1413	137	SAN PEDRO DE PILAS
1414	137	TANTA
1415	137	TAURIPAMPA
1416	137	TOMAS
1417	137	TUPE
1418	137	VI??AC
1419	137	VITIS
1420	138	IQUITOS
1421	138	ALTO NANAY
1422	138	FERNANDO LORES
1423	138	INDIANA
1424	138	LAS AMAZONAS
1425	138	MAZAN
1426	138	NAPO
1427	138	PUNCHANA
1428	138	PUTUMAYO
1429	138	TORRES CAUSANA
1430	138	BELEN
1431	138	SAN JUAN BAUTISTA
1432	138	TENIENTE MANUEL CLAVERO
1433	139	YURIMAGUAS
1434	139	BALSAPUERTO
1435	139	JEBEROS
1436	139	LAGUNAS
1437	139	SANTA CRUZ
1438	139	TENIENTE CESAR LOPEZ ROJAS
1439	140	NAUTA
1440	140	PARINARI
1441	140	TIGRE
1442	140	TROMPETEROS
1443	140	URARINAS
1444	141	RAMON CASTILLA
1445	141	PEBAS
1446	141	YAVARI
1447	141	SAN PABLO
1448	142	REQUENA
1449	142	ALTO TAPICHE
1450	142	CAPELO
1451	142	EMILIO SAN MARTIN
1452	142	MAQUIA
1453	142	PUINAHUA
1454	142	SAQUENA
1455	142	SOPLIN
1456	142	TAPICHE
1457	142	JENARO HERRERA
1458	142	YAQUERANA
1459	143	CONTAMANA
1460	143	INAHUAYA
1461	143	PADRE MARQUEZ
1462	143	PAMPA HERMOSA
1463	143	SARAYACU
1464	143	VARGAS GUERRA
1465	144	BARRANCA
1466	144	CAHUAPANAS
1467	144	MANSERICHE
1468	144	MORONA
1469	144	PASTAZA
1470	144	ANDOAS
1471	145	TAMBOPATA
1472	145	INAMBARI
1473	145	LAS PIEDRAS
1474	145	LABERINTO
1475	146	MANU
1476	146	FITZCARRALD
1477	146	MADRE DE DIOS
1478	146	HUEPETUHE
1479	147	I??APARI
1480	147	IBERIA
1481	147	TAHUAMANU
1482	148	MOQUEGUA
1483	148	CARUMAS
1484	148	CUCHUMBAYA
1485	148	SAMEGUA
1486	148	SAN CRISTOBAL
1487	148	TORATA
1488	149	OMATE
1489	149	CHOJATA
1490	149	COALAQUE
1491	149	ICHU??A
1492	149	LA CAPILLA
1493	149	LLOQUE
1494	149	MATALAQUE
1495	149	PUQUINA
1496	149	QUINISTAQUILLAS
1497	149	UBINAS
1498	149	YUNGA
1499	150	ILO
1500	150	EL ALGARROBAL
1501	150	PACOCHA
1502	151	CHAUPIMARCA
1503	151	HUACHON
1504	151	HUARIACA
1505	151	HUAYLLAY
1506	151	NINACACA
1507	151	PALLANCHACRA
1508	151	PAUCARTAMBO
1509	151	SAN FRANCISCO DE ASIS DE YARUSYACAN
1510	151	SIMON BOLIVAR
1511	151	TICLACAYAN
1512	151	TINYAHUARCO
1513	151	VICCO
1514	151	YANACANCHA
1515	152	YANAHUANCA
1516	152	CHACAYAN
1517	152	GOYLLARISQUIZGA
1518	152	PAUCAR
1519	152	SAN PEDRO DE PILLAO
1520	152	SANTA ANA DE TUSI
1521	152	TAPUC
1522	152	VILCABAMBA
1523	153	OXAPAMPA
1524	153	CHONTABAMBA
1525	153	HUANCABAMBA
1526	153	PALCAZU
1527	153	POZUZO
1528	153	PUERTO BERMUDEZ
1529	153	VILLA RICA
1530	154	PIURA
1531	154	CASTILLA
1532	154	CATACAOS
1533	154	CURA MORI
1534	154	EL TALLAN
1535	154	LA ARENA
1536	154	LA UNION
1537	154	LAS LOMAS
1538	154	TAMBO GRANDE
1539	155	AYABACA
1540	155	FRIAS
1541	155	JILILI
1542	155	LAGUNAS
1543	155	MONTERO
1544	155	PACAIPAMPA
1545	155	PAIMAS
1546	155	SAPILLICA
1547	155	SICCHEZ
1548	155	SUYO
1549	156	HUANCABAMBA
1550	156	CANCHAQUE
1551	156	EL CARMEN DE LA FRONTERA
1552	156	HUARMACA
1553	156	LALAQUIZ
1554	156	SAN MIGUEL DE EL FAIQUE
1555	156	SONDOR
1556	156	SONDORILLO
1557	157	CHULUCANAS
1558	157	BUENOS AIRES
1559	157	CHALACO
1560	157	LA MATANZA
1561	157	MORROPON
1562	157	SALITRAL
1563	157	SAN JUAN DE BIGOTE
1564	157	SANTA CATALINA DE MOSSA
1565	157	SANTO DOMINGO
1566	157	YAMANGO
1567	158	PAITA
1568	158	AMOTAPE
1569	158	ARENAL
1570	158	COLAN
1571	158	LA HUACA
1572	158	TAMARINDO
1573	158	VICHAYAL
1574	159	SULLANA
1575	159	BELLAVISTA
1576	159	IGNACIO ESCUDERO
1577	159	LANCONES
1578	159	MARCAVELICA
1579	159	MIGUEL CHECA
1580	159	QUERECOTILLO
1581	159	SALITRAL
1582	160	PARI??AS
1583	160	EL ALTO
1584	160	LA BREA
1585	160	LOBITOS
1586	160	LOS ORGANOS
1587	160	MANCORA
1588	161	SECHURA
1589	161	BELLAVISTA DE LA UNION
1590	161	BERNAL
1591	161	CRISTO NOS VALGA
1592	161	VICE
1593	161	RINCONADA LLICUAR
1594	162	PUNO
1595	162	ACORA
1596	162	AMANTANI
1597	162	ATUNCOLLA
1598	162	CAPACHICA
1599	162	CHUCUITO
1600	162	COATA
1601	162	HUATA
1602	162	MA??AZO
1603	162	PAUCARCOLLA
1604	162	PICHACANI
1605	162	PLATERIA
1606	162	SAN ANTONIO
1607	162	TIQUILLACA
1608	162	VILQUE
1609	163	AZANGARO
1610	163	ACHAYA
1611	163	ARAPA
1612	163	ASILLO
1613	163	CAMINACA
1614	163	CHUPA
1615	163	JOSE DOMINGO CHOQUEHUANCA
1616	163	MU??ANI
1617	163	POTONI
1618	163	SAMAN
1619	163	SAN ANTON
1620	163	SAN JOSE
1621	163	SAN JUAN DE SALINAS
1622	163	SANTIAGO DE PUPUJA
1623	163	TIRAPATA
1624	164	MACUSANI
1625	164	AJOYANI
1626	164	AYAPATA
1627	164	COASA
1628	164	CORANI
1629	164	CRUCERO
1630	164	ITUATA
1631	164	OLLACHEA
1632	164	SAN GABAN
1633	164	USICAYOS
1634	165	JULI
1635	165	DESAGUADERO
1636	165	HUACULLANI
1637	165	KELLUYO
1638	165	PISACOMA
1639	165	POMATA
1640	165	ZEPITA
1641	166	ILAVE
1642	166	CAPAZO
1643	166	PILCUYO
1644	166	SANTA ROSA
1645	166	CONDURIRI
1646	167	HUANCANE
1647	167	COJATA
1648	167	HUATASANI
1649	167	INCHUPALLA
1650	167	PUSI
1651	167	ROSASPATA
1652	167	TARACO
1653	167	VILQUE CHICO
1654	168	LAMPA
1655	168	CABANILLA
1656	168	CALAPUJA
1657	168	NICASIO
1658	168	OCUVIRI
1659	168	PALCA
1660	168	PARATIA
1661	168	PUCARA
1662	168	SANTA LUCIA
1663	168	VILAVILA
1664	169	AYAVIRI
1665	169	ANTAUTA
1666	169	CUPI
1667	169	LLALLI
1668	169	MACARI
1669	169	NU??OA
1670	169	ORURILLO
1671	169	SANTA ROSA
1672	169	UMACHIRI
1673	170	MOHO
1674	170	CONIMA
1675	170	HUAYRAPATA
1676	170	TILALI
1677	171	PUTINA
1678	171	ANANEA
1679	171	PEDRO VILCA APAZA
1680	171	QUILCAPUNCU
1681	171	SINA
1682	172	JULIACA
1683	172	CABANA
1684	172	CABANILLAS
1685	172	CARACOTO
1686	173	SANDIA
1687	173	CUYOCUYO
1688	173	LIMBANI
1689	173	PATAMBUCO
1690	173	PHARA
1691	173	QUIACA
1692	173	SAN JUAN DEL ORO
1693	173	YANAHUAYA
1694	173	ALTO INAMBARI
1695	173	SAN PEDRO DE PUTINA PUNCO
1696	174	YUNGUYO
1697	174	ANAPIA
1698	174	COPANI
1699	174	CUTURAPI
1700	174	OLLARAYA
1701	174	TINICACHI
1702	174	UNICACHI
1703	175	MOYOBAMBA
1704	175	CALZADA
1705	175	HABANA
1706	175	JEPELACIO
1707	175	SORITOR
1708	175	YANTALO
1709	176	BELLAVISTA
1710	176	ALTO BIAVO
1711	176	BAJO BIAVO
1712	176	HUALLAGA
1713	176	SAN PABLO
1714	176	SAN RAFAEL
1715	177	SAN JOSE DE SISA
1716	177	AGUA BLANCA
1717	177	SAN MARTIN
1718	177	SANTA ROSA
1719	177	SHATOJA
1720	178	SAPOSOA
1721	178	ALTO SAPOSOA
1722	178	EL ESLABON
1723	178	PISCOYACU
1724	178	SACANCHE
1725	178	TINGO DE SAPOSOA
1726	179	LAMAS
1727	179	ALONSO DE ALVARADO
1728	179	BARRANQUITA
1729	179	CAYNARACHI
1730	179	CU??UMBUQUI
1731	179	PINTO RECODO
1732	179	RUMISAPA
1733	179	SAN ROQUE DE CUMBAZA
1734	179	SHANAO
1735	179	TABALOSOS
1736	179	ZAPATERO
1737	180	JUANJUI
1738	180	CAMPANILLA
1739	180	HUICUNGO
1740	180	PACHIZA
1741	180	PAJARILLO
1742	181	PICOTA
1743	181	BUENOS AIRES
1744	181	CASPISAPA
1745	181	PILLUANA
1746	181	PUCACACA
1747	181	SAN CRISTOBAL
1748	181	SAN HILARION
1749	181	SHAMBOYACU
1750	181	TINGO DE PONASA
1751	181	TRES UNIDOS
1752	182	RIOJA
1753	182	AWAJUN
1754	182	ELIAS SOPLIN VARGAS
1755	182	NUEVA CAJAMARCA
1756	182	PARDO MIGUEL
1757	182	POSIC
1758	182	SAN FERNANDO
1759	182	YORONGOS
1760	182	YURACYACU
1761	183	TARAPOTO
1762	183	ALBERTO LEVEAU
1763	183	CACATACHI
1764	183	CHAZUTA
1765	183	CHIPURANA
1766	183	EL PORVENIR
1767	183	HUIMBAYOC
1768	183	JUAN GUERRA
1769	183	LA BANDA DE SHILCAYO
1770	183	MORALES
1771	183	PAPAPLAYA
1772	183	SAN ANTONIO
1773	183	SAUCE
1774	183	SHAPAJA
1775	184	TOCACHE
1776	184	NUEVO PROGRESO
1777	184	POLVORA
1778	184	SHUNTE
1779	184	UCHIZA
1780	185	TACNA
1781	185	ALTO DE LA ALIANZA
1782	185	CALANA
1783	185	CIUDAD NUEVA
1784	185	INCLAN
1785	185	PACHIA
1786	185	PALCA
1787	185	POCOLLAY
1788	185	SAMA
1789	185	CORONEL GREGORIO ALBARRACIN LANCHIPA
1790	186	CANDARAVE
1791	186	CAIRANI
1792	186	CAMILACA
1793	186	CURIBAYA
1794	186	HUANUARA
1795	186	QUILAHUANI
1796	187	LOCUMBA
1797	187	ILABAYA
1798	187	ITE
1799	188	TARATA
1800	188	HEROES ALBARRACIN
1801	188	ESTIQUE
1802	188	ESTIQUE-PAMPA
1803	188	SITAJARA
1804	188	SUSAPAYA
1805	188	TARUCACHI
1806	188	TICACO
1807	189	TUMBES
1808	189	CORRALES
1809	189	LA CRUZ
1810	189	PAMPAS DE HOSPITAL
1811	189	SAN JACINTO
1812	189	SAN JUAN DE LA VIRGEN
1813	190	ZORRITOS
1814	190	CASITAS
1815	190	CANOAS DE PUNTA SAL
1816	191	ZARUMILLA
1817	191	AGUAS VERDES
1818	191	MATAPALO
1819	191	PAPAYAL
1820	192	CALLERIA
1821	192	CAMPOVERDE
1822	192	IPARIA
1823	192	MASISEA
1824	192	YARINACOCHA
1825	192	NUEVA REQUENA
1826	192	MANANTAY
1827	193	RAYMONDI
1828	193	SEPAHUA
1829	193	TAHUANIA
1830	193	YURUA
1831	194	PADRE ABAD
1832	194	IRAZOLA
1833	194	CURIMANA
1834	195	PURUS
1835	128	PUEBLO LIBRE
1838	203	Arica
1839	203	Camarones
1840	204	Putre
1841	204	General Lagos
1842	205	Iquique
1843	205	Alto Hospicio
1844	206	Pozo Almonte
1845	206	Cami??a
1846	206	Colchane
1847	206	Huara
1848	206	Pica
1849	207	Antofagasta
1850	207	Mejillones
1851	207	Sierra Gorda
1852	207	Taltal
1853	208	Calama
1854	208	Ollag??e
1855	208	San Pedro de Atacama
1856	209	Tocopilla
1857	209	Mar??a Elena
1858	210	Copiap??
1859	210	Caldera
1860	210	Tierra Amarilla
1861	211	Cha??aral
1862	211	Diego de Almagro
1863	212	Vallenar
1864	212	Alto del Carmen
1865	212	Freirina
1866	212	Huasco
1867	213	La Serena
1868	213	Coquimbo
1869	213	Andacollo
1870	213	La Higuera
1871	213	Paiguano
1872	213	Vicu??a
1873	214	Illapel
1874	214	Canela
1875	214	Los Vilos
1876	214	Salamanca
1877	215	Ovalle
1878	215	Combarbal??
1879	215	Monte Patria
1880	215	Punitaqui
1881	215	R??o Hurtado
1882	216	Valpara??so
1883	216	Casablanca
1884	216	Conc??n
1885	216	Juan Fern??ndez
1886	216	Puchuncav??
1887	216	Quintero
1888	216	Vi??a del Mar
1889	217	Isla de Pascua
1890	218	Los Andes
1891	218	Calle Larga
1892	218	Rinconada
1893	218	San Esteban
1894	219	La Ligua
1895	219	Cabildo
1896	219	Papudo
1897	219	Petorca
1898	219	Zapallar
1899	220	Quillota
1900	220	Calera
1901	220	Hijuelas
1902	220	La Cruz
1903	220	Nogales
1904	221	San Antonio
1905	221	Algarrobo
1906	221	Cartagena
1907	221	El Quisco
1908	221	El Tabo
1909	221	Santo Domingo
1910	222	San Felipe
1911	222	Catemu
1912	222	Llaillay
1913	222	Panquehue
1914	222	Putaendo
1915	222	Santa Mar??a
1916	223	Quilpu??
1917	223	Limache
1918	223	Olmu??
1919	223	Villa Alemana
1920	224	Rancagua
1921	224	Codegua
1922	224	Coinco
1923	224	Coltauco
1924	224	Do??ihue
1925	224	Graneros
1926	224	Las Cabras
1927	224	Machal??
1928	224	Malloa
1929	224	Mostazal
1930	224	Olivar
1931	224	Peumo
1932	224	Pichidegua
1933	224	Quinta de Tilcoco
1934	224	Rengo
1935	224	Requ??noa
1936	224	San Vicente
1937	225	Pichilemu
1938	225	La Estrella
1939	225	Litueche
1940	225	Marchihue
1941	225	Navidad
1942	225	Paredones
1943	226	San Fernando
1944	226	Ch??pica
1945	226	Chimbarongo
1946	226	Lolol
1947	226	Nancagua
1948	226	Palmilla
1949	226	Peralillo
1950	226	Placilla
1951	226	Pumanque
1952	226	Santa Cruz
1953	227	Talca
1954	227	Constituci??n
1955	227	Curepto
1956	227	Empedrado
1957	227	Maule
1958	227	Pelarco
1959	227	Pencahue
1960	227	R??o Claro
1961	227	San Clemente
1962	227	San Rafael
1963	228	Cauquenes
1964	228	Chanco
1965	228	Pelluhue
1966	229	Curic??
1967	229	Huala????
1968	229	Licant??n
1969	229	Molina
1970	229	Rauco
1971	229	Romeral
1972	229	Sagrada Familia
1973	229	Teno
1974	229	Vichuqu??n
1975	230	Linares
1976	230	Colb??n
1977	230	Longav??
1978	230	Parral
1979	230	Retiro
1980	230	San Javier
1981	230	Villa Alegre
1982	230	Yerbas Buenas
1983	231	Concepci??n
1984	231	Coronel
1985	231	Chiguayante
1986	231	Florida
1987	231	Hualqui
1988	231	Lota
1989	231	Penco
1990	231	San Pedro de la Paz
1991	231	Santa Juana
1992	231	Talcahuano
1993	231	Tom??
1994	231	Hualp??n
1995	232	Lebu
1996	232	Arauco
1997	232	Ca??ete
1998	232	Contulmo
1999	232	Curanilahue
2000	232	Los ??lamos
2001	232	Tir??a
2002	233	Los ??ngeles
2003	233	Antuco
2004	233	Cabrero
2005	233	Laja
2006	233	Mulch??n
2007	233	Nacimiento
2008	233	Negrete
2009	233	Quilaco
2010	233	Quilleco
2011	233	San Rosendo
2012	233	Santa B??rbara
2013	233	Tucapel
2014	233	Yumbel
2015	233	Alto Biob??o
2016	234	Chill??n
2017	234	Bulnes
2018	234	Cobquecura
2019	234	Coelemu
2020	234	Coihueco
2021	234	Chill??n Viejo
2022	234	El Carmen
2023	234	Ninhue
2024	234	??iqu??n
2025	234	Pemuco
2026	234	Pinto
2027	234	Portezuelo
2028	234	Quill??n
2029	234	Quirihue
2030	234	R??nquil
2031	234	San Carlos
2032	234	San Fabi??n
2033	234	San Ignacio
2034	234	San Nicol??s
2035	234	Treguaco
2036	234	Yungay
2037	235	Temuco
2038	235	Carahue
2039	235	Cunco
2040	235	Curarrehue
2041	235	Freire
2042	235	Galvarino
2043	235	Gorbea
2044	235	Lautaro
2045	235	Loncoche
2046	235	Melipeuco
2047	235	Nueva Imperial
2048	235	Padre las Casas
2049	235	Perquenco
2050	235	Pitrufqu??n
2051	235	Puc??n
2052	235	Saavedra
2053	235	Teodoro Schmidt
2054	235	Tolt??n
2055	235	Vilc??n
2056	235	Villarrica
2057	235	Cholchol
2058	236	Angol
2059	236	Collipulli
2060	236	Curacaut??n
2061	236	Ercilla
2062	236	Lonquimay
2063	236	Los Sauces
2064	236	Lumaco
2065	236	Pur??n
2066	236	Renaico
2067	236	Traigu??n
2068	236	Victoria
2069	237	Valdivia
2070	237	Corral
2071	237	Lanco
2072	237	Los Lagos
2073	237	M??fil
2074	237	Mariquina
2075	237	Paillaco
2076	237	Panguipulli
2077	238	La Uni??n
2078	238	Futrono
2079	238	Lago Ranco
2080	238	R??o Bueno
2081	239	Puerto Montt
2082	239	Calbuco
2083	239	Cocham??
2084	239	Fresia
2085	239	Frutillar
2086	239	Los Muermos
2087	239	Llanquihue
2088	239	Maull??n
2089	239	Puerto Varas
2090	240	Castro
2091	240	Ancud
2092	240	Chonchi
2093	240	Curaco de V??lez
2094	240	Dalcahue
2095	240	Puqueld??n
2096	240	Queil??n
2097	240	Quell??n
2098	240	Quemchi
2099	240	Quinchao
2100	241	Osorno
2101	241	Puerto Octay
2102	241	Purranque
2103	241	Puyehue
2104	241	R??o Negro
2105	241	San Juan de la Costa
2106	241	San Pablo
2107	242	Chait??n
2108	242	Futaleuf??
2109	242	Hualaihu??
2110	242	Palena
2111	243	Coihaique
2112	243	Lago Verde
2113	244	Ais??n
2114	244	Cisnes
2115	244	Guaitecas
2116	245	Cochrane
2117	245	O???Higgins
2118	245	Tortel
2119	246	Chile Chico
2120	246	R??o Ib????ez
2121	247	Punta Arenas
2122	247	Laguna Blanca
2123	247	R??o Verde
2124	247	San Gregorio
2125	248	Cabo de Hornos (Ex Navarino)
2126	248	Ant??rtica
2127	249	Porvenir
2128	249	Primavera
2129	249	Timaukel
2130	250	Natales
2131	250	Torres del Paine
2132	251	Santiago
2133	251	Cerrillos
2134	251	Cerro Navia
2135	251	Conchal??
2136	251	El Bosque
2137	251	Estaci??n Central
2138	251	Huechuraba
2139	251	Independencia
2140	251	La Cisterna
2141	251	La Florida
2142	251	La Granja
2143	251	La Pintana
2144	251	La Reina
2145	251	Las Condes
2146	251	Lo Barnechea
2147	251	Lo Espejo
2148	251	Lo Prado
2149	251	Macul
2150	251	Maip??
2151	251	??u??oa
2152	251	Pedro Aguirre Cerda
2153	251	Pe??alol??n
2154	251	Providencia
2155	251	Pudahuel
2156	251	Quilicura
2157	251	Quinta Normal
2158	251	Recoleta
2159	251	Renca
2160	251	San Joaqu??n
2161	251	San Miguel
2162	251	San Ram??n
2163	251	Vitacura
2164	252	Puente Alto
2165	252	Pirque
2166	252	San Jos?? de Maipo
2167	253	Colina
2168	253	Lampa
2169	253	Tiltil
2170	254	San Bernardo
2171	254	Buin
2172	254	Calera de Tango
2173	254	Paine
2174	255	Melipilla
2175	255	Alhu??
2176	255	Curacav??
2177	255	Mar??a Pinto
2178	255	San Pedro
2179	256	Talagante
2180	256	El Monte
2181	256	Isla de Maipo
2182	256	Padre Hurtado
2183	1302	BELLAVISTA
2184	1302	CA??ARIBAMBA
2185	1302	EL BAT??N
2186	1302	EL SAGRARIO
2187	1302	EL VECINO
2188	1302	GIL RAM??REZ D??VALOS
2189	1302	HUAYNAC??PAC
2190	1302	MACH??NGARA
2191	1302	MONAY
2192	1302	SAN BLAS
2193	1302	SAN SEBASTI??N
2194	1302	SUCRE
2195	1302	TOTORACOCHA
2196	1302	YANUNCAY
2197	1302	HERMANO MIGUEL
2198	1302	CUENCA
2199	1302	BA??OS
2200	1302	CUMBE
2201	1302	CHAUCHA
2202	1302	CHECA (JIDCAY)
2203	1302	CHIQUINTAD
2204	1302	LLACAO
2205	1302	MOLLETURO
2206	1302	NULTI
2207	1302	OCTAVIO CORDERO PALACIOS (SANTA ROSA)
2208	1302	PACCHA
2209	1302	QUINGEO
2210	1302	RICAURTE
2211	1302	SAN JOAQU??N
2212	1302	SANTA ANA
2213	1302	SAYAUS??
2214	1302	SIDCAY
2215	1302	SININCAY
2216	1302	TARQUI
2217	1302	TURI
2218	1302	VALLE
2219	1302	VICTORIA DEL PORTETE (IRQUIS)
2220	1303	GIR??N
2221	1303	ASUNCI??N
2222	1303	SAN GERARDO
2223	1304	GUALACEO
2224	1304	CHORDELEG
2225	1304	DANIEL C??RDOVA TORAL (EL ORIENTE)
2226	1304	JAD??N
2227	1304	MARIANO MORENO
2228	1304	PRINCIPAL
2229	1304	REMIGIO CRESPO TORAL (G??LAG)
2230	1304	SAN JUAN
2231	1304	ZHIDMAD
2232	1304	LUIS CORDERO VEGA
2233	1304	SIM??N BOL??VAR (CAB. EN GA??ANZOL)
2234	1305	NAB??N
2235	1305	COCHAPATA
2236	1305	EL PROGRESO (CAB.EN ZHOTA)
2237	1305	LAS NIEVES (CHAYA)
2238	1305	O??A
2239	1306	PAUTE
2240	1306	AMALUZA
2241	1306	BUL??N (JOS?? V??CTOR IZQUIERDO)
2242	1306	CHIC??N (GUILLERMO ORTEGA)
2243	1306	EL CABO
2244	1306	GUACHAPALA
2245	1306	GUARAINAG
2246	1306	PALMAS
2247	1306	PAN
2248	1306	SAN CRIST??BAL (CARLOS ORD????EZ LAZO)
2249	1306	SEVILLA DE ORO
2250	1306	TOMEBAMBA
2251	1306	DUG DUG
2252	1307	PUCAR??
2253	1307	CAMILO PONCE ENR??QUEZ (CAB. EN R??O 7 DE MOLLEPONGO
2254	1307	SAN RAFAEL DE SHARUG
2255	1308	SAN FERNANDO
2256	1308	CHUMBL??N
2257	1309	SANTA ISABEL (CHAGUARURCO)
2258	1309	ABD??N CALDER??N (LA UNI??N)
2259	1309	EL CARMEN DE PIJIL??
2260	1309	ZHAGLLI (SHAGLLI)
2261	1309	SAN SALVADOR DE CA??ARIBAMBA
2262	1310	SIGSIG
2263	1310	CUCHIL (CUTCHIL)
2264	1310	GIMA
2265	1310	GUEL
2266	1310	LUDO
2267	1310	SAN BARTOLOM??
2268	1310	SAN JOS?? DE RARANGA
2269	1311	SAN FELIPE DE O??A CABECERA CANTONAL
2270	1311	SUSUDEL
2271	1312	LA UNI??N
2272	1312	LUIS GALARZA ORELLANA (CAB.EN DELEGSOL)
2273	1312	SAN MART??N DE PUZHIO
2274	1313	EL PAN
2275	1313	SAN VICENTE
2276	1316	CAMILO PONCE ENR??QUEZ
2277	1317	??NGEL POLIBIO CH??VES
2278	1317	GABRIEL IGNACIO VEINTIMILLA
2279	1317	GUANUJO
2280	1317	GUARANDA
2281	1317	FACUNDO VELA
2282	1317	JULIO E. MORENO (CATANAHU??N GRANDE)
2283	1317	LAS NAVES
2284	1317	SALINAS
2285	1317	SAN LORENZO
2286	1317	SAN SIM??N (YACOTO)
2287	1317	SANTA F?? (SANTA F??)
2288	1317	SIMI??TUG
2289	1317	SAN LUIS DE PAMBIL
2290	1318	CHILLANES
2291	1318	SAN JOS?? DEL TAMBO (TAMBOPAMBA)
2292	1319	SAN JOS?? DE CHIMBO
2293	1319	ASUNCI??N (ASANCOTO)
2294	1319	CALUMA
2295	1319	MAGDALENA (CHAPACOTO)
2296	1319	TELIMBELA
2297	1320	ECHEAND??A
2298	1321	SAN MIGUEL
2299	1321	BALSAPAMBA
2300	1321	BILOV??N
2301	1321	R??GULO DE MORA
2302	1321	SAN PABLO (SAN PABLO DE ATENAS)
2303	1321	SANTIAGO
2304	1323	LAS MERCEDES
2305	1324	AURELIO BAYAS MART??NEZ
2306	1324	AZOGUES
2307	1324	BORRERO
2308	1324	SAN FRANCISCO
2309	1324	COJITAMBO
2310	1324	D??LEG
2311	1324	GUAP??N
2312	1324	JAVIER LOYOLA (CHUQUIPATA)
2313	1324	LUIS CORDERO
2314	1324	PINDILIG
2315	1324	RIVERA
2316	1324	SOLANO
2317	1324	TADAY
2318	1325	BIBLI??N
2319	1325	NAZ??N (CAB. EN PAMPA DE DOM??NGUEZ)
2320	1325	SAN FRANCISCO DE SAGEO
2321	1325	TURUPAMBA
2322	1325	JERUSAL??N
2323	1326	CA??AR
2324	1326	CHONTAMARCA
2325	1326	CHOROCOPTE
2326	1326	GENERAL MORALES (SOCARTE)
2327	1326	GUALLETURO
2328	1326	HONORATO V??SQUEZ (TAMBO VIEJO)
2329	1326	INGAPIRCA
2330	1326	JUNCAL
2331	1326	SAN ANTONIO
2332	1326	SUSCAL
2333	1326	TAMBO
2334	1326	ZHUD
2335	1326	VENTURA
2336	1326	DUCUR
2337	1327	LA TRONCAL
2338	1327	MANUEL J. CALLE
2339	1327	PANCHO NEGRO
2340	1328	EL TAMBO
2341	1331	GONZ??LEZ SU??REZ
2342	1331	TULC??N
2343	1331	EL CARMELO (EL PUN)
2344	1331	HUACA
2345	1331	JULIO ANDRADE (OREJUELA)
2346	1331	MALDONADO
2347	1331	PIOTER
2348	1331	TOBAR DONOSO (LA BOCANA DE CAMUMB??)
2349	1331	TUFI??O
2350	1331	URBINA (TAYA)
2351	1331	EL CHICAL
2352	1331	MARISCAL SUCRE
2353	1331	SANTA MARTHA DE CUBA
2354	1332	BOL??VAR
2355	1332	GARC??A MORENO
2356	1332	LOS ANDES
2357	1332	MONTE OLIVO
2358	1332	SAN VICENTE DE PUSIR
2359	1332	SAN RAFAEL
2360	1333	EL ??NGEL
2361	1333	27 DE SEPTIEMBRE
2362	1333	EL ANGEL
2363	1333	EL GOALTAL
2364	1333	LA LIBERTAD (ALIZO)
2365	1333	SAN ISIDRO
2366	1334	MIRA (CHONTAHUASI)
2367	1334	CONCEPCI??N
2368	1334	JIJ??N Y CAAMA??O (CAB. EN R??O BLANCO)
2369	1334	JUAN MONTALVO (SAN IGNACIO DE QUIL)
2370	1335	SAN JOS??
2371	1335	SAN GABRIEL
2372	1335	CRIST??BAL COL??N
2373	1335	CHIT??N DE NAVARRETE
2374	1335	FERN??NDEZ SALVADOR
2375	1335	LA PAZ
2376	1335	PIARTAL
2377	1337	ELOY ALFARO (SAN FELIPE)
2378	1337	IGNACIO FLORES (PARQUE FLORES)
2379	1337	JUAN MONTALVO (SAN SEBASTI??N)
2380	1337	LA MATRIZ
2381	1337	SAN BUENAVENTURA
2382	1337	LATACUNGA
2383	1337	ALAQUES (AL??QUEZ)
2384	1337	BELISARIO QUEVEDO (GUANAIL??N)
2385	1337	GUAITACAMA (GUAYTACAMA)
2386	1337	JOSEGUANGO BAJO
2387	1337	LAS PAMPAS
2388	1337	MULAL??
2389	1337	11 DE NOVIEMBRE (ILINCHISI)
2390	1337	POAL??
2391	1337	SAN JUAN DE PASTOCALLE
2392	1337	SIGCHOS
2393	1337	TANICUCH??
2394	1337	TOACASO
2395	1337	PALO QUEMADO
2396	1338	EL CARMEN
2397	1338	LA MAN??
2398	1338	EL TRIUNFO
2399	1338	GUASAGANDA (CAB.EN GUASAGANDA
2400	1338	PUCAYACU
2401	1339	EL CORAZ??N
2402	1339	MORASPUNGO
2403	1339	PINLLOPATA
2404	1339	RAM??N CAMPA??A
2405	1340	PUJIL??
2406	1340	ANGAMARCA
2407	1340	CHUCCHIL??N (CHUGCHIL??N)
2408	1340	GUANGAJE
2409	1340	ISINLIB?? (ISINLIV??)
2410	1340	LA VICTORIA
2411	1340	PILAL??
2412	1340	TINGO
2413	1340	ZUMBAHUA
2414	1341	ANTONIO JOS?? HOLGU??N (SANTA LUC??A)
2415	1341	CUSUBAMBA
2416	1341	MULALILLO
2417	1341	MULLIQUINDIL (SANTA ANA)
2418	1341	PANSALEO
2419	1342	SAQUISIL??
2420	1342	CANCHAGUA
2421	1342	CHANTIL??N
2422	1342	COCHAPAMBA
2423	1343	CHUGCHILL??N
2424	1343	ISINLIV??
2425	1344	LIZARZABURU
2426	1344	VELASCO
2427	1344	VELOZ
2428	1344	YARUQU??ES
2429	1344	RIOBAMBA
2430	1344	CACHA (CAB. EN MACH??NGARA)
2431	1344	CALPI
2432	1344	CUBIJ??ES
2433	1344	FLORES
2434	1344	LIC??N
2435	1344	LICTO
2436	1344	PUNGAL??
2437	1344	PUN??N
2438	1344	QUIMIAG
2439	1344	SAN LUIS
2440	1345	ALAUS??
2441	1345	ACHUPALLAS
2442	1345	CUMAND??
2443	1345	GUASUNTOS
2444	1345	HUIGRA
2445	1345	MULTITUD
2446	1345	PISTISH?? (NARIZ DEL DIABLO)
2447	1345	PUMALLACTA
2448	1345	SEVILLA
2449	1345	SIBAMBE
2450	1345	TIX??N
2451	1346	CAJABAMBA
2452	1346	SICALPA
2453	1346	VILLA LA UNI??N (CAJABAMBA)
2454	1346	CA??I
2455	1346	COLUMBE
2456	1346	JUAN DE VELASCO (PANGOR)
2457	1346	SANTIAGO DE QUITO (CAB. EN SAN ANTONIO DE QUITO)
2458	1347	CHAMBO
2459	1348	CHUNCHI
2460	1348	CAPZOL
2461	1348	COMPUD
2462	1348	GONZOL
2463	1348	LLAGOS
2464	1349	GUAMOTE
2465	1349	CEBADAS
2466	1349	PALMIRA
2467	1350	EL ROSARIO
2468	1350	GUANO
2469	1350	GUANANDO
2470	1350	ILAPO
2471	1350	LA PROVIDENCIA
2472	1350	SAN ANDR??S
2473	1350	SAN GERARDO DE PACAICAGU??N
2474	1350	SAN ISIDRO DE PATUL??
2475	1350	SAN JOS?? DEL CHAZO
2476	1350	SANTA F?? DE GAL??N
2477	1350	VALPARA??SO
2478	1351	PALLATANGA
2479	1352	PENIPE
2480	1352	EL ALTAR
2481	1352	MATUS
2482	1352	PUELA
2483	1352	SAN ANTONIO DE BAYUSHIG
2484	1352	LA CANDELARIA
2485	1352	BILBAO (CAB.EN QUILLUYACU)
2486	1354	MACHALA
2487	1354	PUERTO BOL??VAR
2488	1354	NUEVE DE MAYO
2489	1354	EL CAMBIO
2490	1354	EL RETIRO
2491	1355	ARENILLAS
2492	1355	CHACRAS
2493	1355	LA LIBERTAD
2494	1355	LAS LAJAS (CAB. EN LA VICTORIA)
2495	1355	PALMALES
2496	1355	CARCAB??N
2497	1356	AYAPAMBA
2498	1356	CORDONCILLO
2499	1356	MILAGRO
2500	1356	SAN JUAN DE CERRO AZUL
2501	1357	BALSAS
2502	1357	BELLAMAR??A
2503	1358	CHILLA
2504	1359	EL GUABO
2505	1359	BARBONES (SUCRE)
2506	1359	LA IBERIA
2507	1359	TENDALES (CAB.EN PUERTO TENDALES)
2508	1359	R??O BONITO
2509	1360	ECUADOR
2510	1360	EL PARA??SO
2511	1360	HUALTACO
2512	1360	MILTON REYES
2513	1360	UNI??N LOJANA
2514	1360	HUAQUILLAS
2515	1361	MARCABEL??
2516	1361	EL INGENIO
2517	1362	LOMA DE FRANCO
2518	1362	OCHOA LE??N (MATRIZ)
2519	1362	TRES CERRITOS
2520	1362	PASAJE
2521	1362	BUENAVISTA
2522	1362	CASACAY
2523	1362	LA PEA??A
2524	1362	PROGRESO
2525	1362	UZHCURRUMI
2526	1362	CA??AQUEMADA
2527	1363	LA SUSAYA
2528	1363	PI??AS GRANDE
2529	1363	PI??AS
2530	1363	CAPIRO (CAB. EN LA CAPILLA DE CAPIRO)
2531	1363	LA BOCANA
2532	1363	MOROMORO (CAB. EN EL VADO)
2533	1363	PIEDRAS
2534	1363	SAN ROQUE (AMBROSIO MALDONADO)
2535	1363	SARACAY
2536	1364	PORTOVELO
2537	1364	CURTINCAPA
2538	1364	MORALES
2539	1364	SALAT??
2540	1365	SANTA ROSA
2541	1365	PUERTO JEL??
2542	1365	BALNEARIO JAMBEL?? (SAT??LITE)
2543	1365	JUM??N (SAT??LITE)
2544	1365	NUEVO SANTA ROSA
2545	1365	JAMBEL??
2546	1365	LA AVANZADA
2547	1365	TORATA
2548	1365	VICTORIA
2549	1366	ZARUMA
2550	1366	ABA????N
2551	1366	ARCAPAMBA
2552	1366	GUANAZ??N
2553	1366	GUIZHAGUI??A
2554	1366	HUERTAS
2555	1366	MALVAS
2556	1366	MULUNCAY GRANDE
2557	1366	SINSAO
2558	1366	SALVIAS
2559	1367	PLATANILLOS
2560	1367	VALLE HERMOSO
2561	1368	BARTOLOM?? RUIZ (C??SAR FRANCO CARRI??N)
2562	1368	5 DE AGOSTO
2563	1368	ESMERALDAS
2564	1368	LUIS TELLO (LAS PALMAS)
2565	1368	SIM??N PLATA TORRES
2566	1368	ATACAMES
2567	1368	CAMARONES (CAB. EN SAN VICENTE)
2568	1368	CRNEL. CARLOS CONCHA TORRES (CAB.EN HUELE)
2569	1368	CHINCA
2570	1368	CHONTADURO
2571	1368	CHUMUND??
2572	1368	LAGARTO
2573	1368	MAJUA
2574	1368	MONTALVO (CAB. EN HORQUETA)
2575	1368	R??O VERDE
2576	1368	ROCAFUERTE
2577	1368	SAN MATEO
2578	1368	S??A (CAB. EN LA BOCANA)
2579	1368	TABIAZO
2580	1368	TACHINA
2581	1368	TONCHIG??E
2582	1368	VUELTA LARGA
2583	1369	VALDEZ (LIMONES)
2584	1369	ANCHAYACU
2585	1369	ATAHUALPA (CAB. EN CAMARONES)
2586	1369	BORB??N
2587	1369	LA TOLA
2588	1369	LUIS VARGAS TORRES (CAB. EN PLAYA DE ORO)
2589	1369	PAMPANAL DE BOL??VAR
2590	1369	SAN FRANCISCO DE ONZOLE
2591	1369	SANTO DOMINGO DE ONZOLE
2592	1369	SELVA ALEGRE
2593	1369	TELEMB??
2594	1369	COL??N ELOY DEL MAR??A
2595	1369	SAN JOS?? DE CAYAPAS
2596	1369	TIMBIR??
2597	1370	MUISNE
2598	1370	DAULE
2599	1370	GALERA
2600	1370	QUINGUE (OLMEDO PERDOMO FRANCO)
2601	1370	SALIMA
2602	1370	SAN GREGORIO
2603	1370	SAN JOS?? DE CHAMANGA (CAB.EN CHAMANGA)
2604	1371	ROSA Z??RATE (QUININD??)
2605	1371	CUBE
2606	1371	CHURA (CHANCAMA) (CAB. EN EL YERBERO)
2607	1371	MALIMPIA
2608	1371	VICHE
2609	1372	ALTO TAMBO (CAB. EN GUADUAL)
2610	1372	ANC??N (PICHANGAL) (CAB. EN PALMA REAL)
2611	1372	CALDER??N
2612	1372	CARONDELET
2613	1372	5 DE JUNIO (CAB. EN UIMBI)
2614	1372	MATAJE (CAB. EN SANTANDER)
2615	1372	SAN JAVIER DE CACHAV?? (CAB. EN SAN JAVIER)
2616	1372	SANTA RITA
2617	1372	TAMBILLO
2618	1372	TULULB?? (CAB. EN RICAURTE)
2619	1372	URBINA
2620	1373	TONSUPA
2621	1374	RIOVERDE
2622	1375	LA CONCORDIA
2623	1375	MONTERREY
2624	1375	LA VILLEGAS
2625	1375	PLAN PILOTO
2626	1376	AYACUCHO
2627	1376	BOL??VAR (SAGRARIO)
2628	1376	CARBO (CONCEPCI??N)
2629	1376	FEBRES CORDERO
2630	1376	LETAMENDI
2631	1376	NUEVE DE OCTUBRE
2632	1376	OLMEDO (SAN ALEJO)
2633	1376	ROCA
2634	1376	URDANETA
2635	1376	XIMENA
2636	1376	PASCUALES
2637	1376	GUAYAQUIL
2638	1376	CHONG??N
2639	1376	JUAN G??MEZ REND??N (PROGRESO)
2640	1376	MORRO
2641	1376	PLAYAS (GRAL. VILLAMIL)
2642	1376	POSORJA
2643	1376	PUN??
2644	1376	TENGUEL
2645	1377	ALFREDO BAQUERIZO MORENO (JUJ??N)
2646	1378	BALAO
2647	1379	BALZAR
2648	1380	COLIMES
2649	1380	SAN JACINTO
2650	1381	LA AURORA (SAT??LITE)
2651	1381	BANIFE
2652	1381	EMILIANO CAICEDO MARCOS
2653	1381	MAGRO
2654	1381	PADRE JUAN BAUTISTA AGUIRRE
2655	1381	SANTA CLARA
2656	1381	VICENTE PIEDRAHITA
2657	1381	ISIDRO AYORA (SOLEDAD)
2658	1381	JUAN BAUTISTA AGUIRRE (LOS TINTOS)
2659	1381	LAUREL
2660	1381	LIMONAL
2661	1381	LOMAS DE SARGENTILLO
2662	1381	LOS LOJAS (ENRIQUE BAQUERIZO MORENO)
2663	1381	PIEDRAHITA (NOBOL)
2664	1382	ELOY ALFARO (DUR??N)
2665	1382	EL RECREO
2666	1383	VELASCO IBARRA (EL EMPALME)
2667	1383	GUAYAS (PUEBLO NUEVO)
2668	1385	CHOBO
2669	1385	GENERAL ELIZALDE (BUCAY)
2670	1385	MARISCAL SUCRE (HUAQUES)
2671	1385	ROBERTO ASTUDILLO (CAB. EN CRUCE DE VENECIA)
2672	1386	NARANJAL
2673	1386	JES??S MAR??A
2674	1386	SAN CARLOS
2675	1386	SANTA ROSA DE FLANDES
2676	1386	TAURA
2677	1387	NARANJITO
2678	1388	PALESTINA
2679	1389	PEDRO CARBO
2680	1389	VALLE DE LA VIRGEN
2681	1389	SABANILLA
2682	1390	SAMBOROND??N
2683	1390	LA PUNTILLA (SAT??LITE)
2684	1390	TARIFA
2685	1391	SANTA LUC??A
2686	1392	BOCANA
2687	1392	CANDILEJOS
2688	1392	CENTRAL
2689	1392	PARA??SO
2690	1392	EL SALITRE (LAS RAMAS)
2691	1392	GRAL. VERNAZA (DOS ESTEROS)
2692	1392	LA VICTORIA (??AUZA)
2693	1392	JUNQUILLAL
2694	1393	SAN JACINTO DE YAGUACHI
2695	1393	CRNEL. LORENZO DE GARAICOA (PEDREGAL)
2696	1393	CRNEL. MARCELINO MARIDUE??A (SAN CARLOS)
2697	1393	GRAL. PEDRO J. MONTERO (BOLICHE)
2698	1393	SIM??N BOL??VAR
2699	1393	YAGUACHI VIEJO (CONE)
2700	1393	VIRGEN DE F??TIMA
2701	1394	GENERAL VILLAMIL (PLAYAS)
2702	1395	CRNEL.LORENZO DE GARAICOA (PEDREGAL)
2703	1396	CORONEL MARCELINO MARIDUE??A (SAN CARLOS)
2704	1398	NARCISA DE JES??S
2705	1399	GENERAL ANTONIO ELIZALDE (BUCAY)
2706	1400	ISIDRO AYORA
2707	1401	CARANQUI
2708	1401	GUAYAQUIL DE ALPACHACA
2709	1401	SAGRARIO
2710	1401	LA DOLOROSA DEL PRIORATO
2711	1401	SAN MIGUEL DE IBARRA
2712	1401	AMBUQU??
2713	1401	ANGOCHAGUA
2714	1401	CAROLINA
2715	1401	LA ESPERANZA
2716	1401	LITA
2717	1402	ANDRADE MAR??N (LOURDES)
2718	1402	ATUNTAQUI
2719	1402	IMBAYA (SAN LUIS DE COBUENDO)
2720	1402	SAN FRANCISCO DE NATABUELA
2721	1402	SAN JOS?? DE CHALTURA
2722	1402	SAN ROQUE
2723	1403	COTACACHI
2724	1403	APUELA
2725	1403	GARC??A MORENO (LLURIMAGUA)
2726	1403	IMANTAG
2727	1403	PE??AHERRERA
2728	1403	PLAZA GUTI??RREZ (CALVARIO)
2729	1403	QUIROGA
2730	1403	6 DE JULIO DE CUELLAJE (CAB. EN CUELLAJE)
2731	1403	VACAS GALINDO (EL CHURO) (CAB.EN SAN MIGUEL ALTO
2732	1404	JORD??N
2733	1404	OTAVALO
2734	1404	DR. MIGUEL EGAS CABEZAS (PEGUCHE)
2735	1404	EUGENIO ESPEJO (CALPAQU??)
2736	1404	PATAQU??
2737	1404	SAN JOS?? DE QUICHINCHE
2738	1404	SAN JUAN DE ILUM??N
2739	1404	SAN PABLO
2740	1404	SELVA ALEGRE (CAB.EN SAN MIGUEL DE PAMPLONA)
2741	1405	PIMAMPIRO
2742	1405	CHUG??
2743	1405	MARIANO ACOSTA
2744	1405	SAN FRANCISCO DE SIGSIPAMBA
2745	1406	URCUQU?? CABECERA CANTONAL
2746	1406	CAHUASQU??
2747	1406	LA MERCED DE BUENOS AIRES
2748	1406	PABLO ARENAS
2749	1406	TUMBABIRO
2750	1407	LOJA
2751	1407	CHANTACO
2752	1407	CHUQUIRIBAMBA
2753	1407	EL CISNE
2754	1407	GUALEL
2755	1407	JIMBILLA
2756	1407	MALACATOS (VALLADOLID)
2757	1407	SAN LUCAS
2758	1407	SAN PEDRO DE VILCABAMBA
2759	1407	TAQUIL (MIGUEL RIOFR??O)
2760	1407	VILCABAMBA (VICTORIA)
2761	1407	YANGANA (ARSENIO CASTILLO)
2762	1407	QUINARA
2763	1408	CARIAMANGA
2764	1408	CHILE
2765	1408	COLAISACA
2766	1408	EL LUCERO
2767	1408	UTUANA
2768	1408	SANGUILL??N
2769	1409	CATAMAYO
2770	1409	CATAMAYO (LA TOMA)
2771	1409	GUAYQUICHUMA
2772	1409	SAN PEDRO DE LA BENDITA
2773	1409	ZAMBI
2774	1410	CELICA
2775	1410	CRUZPAMBA (CAB. EN CARLOS BUSTAMANTE)
2776	1410	CHAQUINAL
2777	1410	12 DE DICIEMBRE (CAB. EN ACHIOTES)
2778	1410	PINDAL (FEDERICO P??EZ)
2779	1410	POZUL (SAN JUAN DE POZUL)
2780	1410	TNTE. MAXIMILIANO RODR??GUEZ LOAIZA
2781	1411	CHAGUARPAMBA
2782	1411	SANTA RUFINA
2783	1411	AMARILLOS
2784	1412	JIMBURA
2785	1412	SANTA TERESITA
2786	1412	27 DE ABRIL (CAB. EN LA NARANJA)
2787	1412	EL AIRO
2788	1413	GONZANAM??
2789	1413	CHANGAIMINA (LA LIBERTAD)
2790	1413	FUNDOCHAMBA
2791	1413	NAMBACOLA
2792	1413	PURUNUMA (EGUIGUREN)
2793	1413	QUILANGA (LA PAZ)
2794	1413	SACAPALCA
2795	1413	SAN ANTONIO DE LAS ARADAS (CAB. EN LAS ARADAS)
2796	1414	GENERAL ELOY ALFARO (SAN SEBASTI??N)
2797	1414	MACAR?? (MANUEL ENRIQUE RENGEL SUQUILANDA)
2798	1414	MACAR??
2799	1414	LARAMA
2800	1414	SABIANGO (LA CAPILLA)
2801	1415	CATACOCHA
2802	1415	LOURDES
2803	1415	CANGONAM??
2804	1415	GUACHANAM??
2805	1415	LA TINGUE
2806	1415	LAURO GUERRERO
2807	1415	OLMEDO (SANTA B??RBARA)
2808	1415	ORIANGA
2809	1415	CASANGA
2810	1415	YAMANA
2811	1416	ALAMOR
2812	1416	CIANO
2813	1416	EL ARENAL
2814	1416	EL LIMO (MARIANA DE JES??S)
2815	1416	MERCADILLO
2816	1416	VICENTINO
2817	1417	SARAGURO
2818	1417	EL PARA??SO DE CEL??N
2819	1417	EL TABL??N
2820	1417	LLUZHAPA
2821	1417	MAN??
2822	1417	SAN ANTONIO DE QUMBE (CUMBE)
2823	1417	SAN PABLO DE TENTA
2824	1417	SAN SEBASTI??N DE Y??LUC
2825	1417	URDANETA (PAQUISHAPA)
2826	1417	SUMAYPAMBA
2827	1418	SOZORANGA
2828	1418	NUEVA F??TIMA
2829	1418	TACAMOROS
2830	1419	ZAPOTILLO
2831	1419	MANGAHURCO (CAZADEROS)
2832	1419	GARZAREAL
2833	1419	LIMONES
2834	1419	PALETILLAS
2835	1419	BOLASPAMBA
2836	1420	PINDAL
2837	1420	12 DE DICIEMBRE (CAB.EN ACHIOTES)
2838	1420	MILAGROS
2839	1421	QUILANGA
2840	1422	OLMEDO
2841	1423	CLEMENTE BAQUERIZO
2842	1423	DR. CAMILO PONCE
2843	1423	BARREIRO
2844	1423	EL SALTO
2845	1423	BABAHOYO
2846	1423	BARREIRO (SANTA RITA)
2847	1423	CARACOL
2848	1423	FEBRES CORDERO (LAS JUNTAS)
2849	1423	PIMOCHA
2850	1424	BABA
2851	1424	GUARE
2852	1424	ISLA DE BEJUCAL
2853	1425	MONTALVO
2854	1426	PUEBLOVIEJO
2855	1426	PUERTO PECHICHE
2856	1427	QUEVEDO
2857	1427	SAN CAMILO
2858	1427	GUAYAC??N
2859	1427	NICOL??S INFANTE D??AZ
2860	1427	SAN CRIST??BAL
2861	1427	SIETE DE OCTUBRE
2862	1427	24 DE MAYO
2863	1427	VENUS DEL R??O QUEVEDO
2864	1427	VIVA ALFARO
2865	1427	BUENA F??
2866	1427	MOCACHE
2867	1427	VALENCIA
2868	1428	CATARAMA
2869	1429	10 DE NOVIEMBRE
2870	1429	VENTANAS
2871	1429	QUINSALOMA
2872	1429	ZAPOTAL
2873	1429	CHACARITA
2874	1429	LOS ??NGELES
2875	1430	VINCES
2876	1430	ANTONIO SOTOMAYOR (CAB. EN PLAYAS DE VINCES)
2877	1430	PALENQUE
2878	1432	SAN JACINTO DE BUENA F??
2879	1432	7 DE AGOSTO
2880	1432	11 DE OCTUBRE
2881	1432	PATRICIA PILAR
2882	1436	PORTOVIEJO
2883	1436	12 DE MARZO
2884	1436	COL??N
2885	1436	PICOAZ??
2886	1436	ANDR??S DE VERA
2887	1436	FRANCISCO PACHECO
2888	1436	18 DE OCTUBRE
2889	1436	ABD??N CALDER??N (SAN FRANCISCO)
2890	1436	ALHAJUELA (BAJO GRANDE)
2891	1436	CRUCITA
2892	1436	PUEBLO NUEVO
2893	1436	RIOCHICO (R??O CHICO)
2894	1436	SAN PL??CIDO
2895	1436	CHIRIJOS
2896	1436	CALCETA
2897	1436	MEMBRILLO
2898	1437	CHONE
2899	1437	BOYAC??
2900	1437	CANUTO
2901	1437	CONVENTO
2902	1437	CHIBUNGA
2903	1437	ELOY ALFARO
2904	1438	4 DE DICIEMBRE
2905	1438	WILFRIDO LOOR MOREIRA (MAICITO)
2906	1438	SAN PEDRO DE SUMA
2907	1439	FLAVIO ALFARO
2908	1439	SAN FRANCISCO DE NOVILLO (CAB. EN
2909	1439	ZAPALLO
2910	1440	DR. MIGUEL MOR??N LUCIO
2911	1440	MANUEL INOCENCIO PARRALES Y GUALE
2912	1440	SAN LORENZO DE JIPIJAPA
2913	1440	JIPIJAPA
2914	1440	AM??RICA
2915	1440	EL ANEGADO (CAB. EN ELOY ALFARO)
2916	1440	JULCUY
2917	1440	MACHALILLA
2918	1440	MEMBRILLAL
2919	1440	PEDRO PABLO G??MEZ
2920	1440	PUERTO DE CAYO
2921	1440	PUERTO L??PEZ
2922	1441	JUN??N
2923	1442	LOS ESTEROS
2924	1442	MANTA
2925	1442	SANTA MARIANITA (BOCA DE PACOCHE)
2926	1443	ANIBAL SAN ANDR??S
2927	1443	MONTECRISTI
2928	1443	EL COLORADO
2929	1443	GENERAL ELOY ALFARO
2930	1443	LEONIDAS PROA??O
2931	1443	JARAMIJ??
2932	1443	LA PILA
2933	1444	PAJ??N
2934	1444	CAMPOZANO (LA PALMA DE PAJ??N)
2935	1444	CASCOL
2936	1444	GUALE
2937	1444	LASCANO
2938	1445	PICHINCHA
2939	1445	BARRAGANETE
2940	1447	LODANA
2941	1447	SANTA ANA DE VUELTA LARGA
2942	1447	HONORATO V??SQUEZ (CAB. EN V??SQUEZ)
2943	1447	SAN PABLO (CAB. EN PUEBLO NUEVO)
2944	1448	BAH??A DE CAR??QUEZ
2945	1448	LEONIDAS PLAZA GUTI??RREZ
2946	1448	CANOA
2947	1448	COJIM??ES
2948	1448	CHARAPOT??
2949	1448	10 DE AGOSTO
2950	1448	JAMA
2951	1448	PEDERNALES
2952	1449	TOSAGUA
2953	1449	BACHILLERO
2954	1449	ANGEL PEDRO GILER (LA ESTANCILLA)
2955	1450	NOBOA
2956	1450	ARQ. SIXTO DUR??N BALL??N
2957	1451	ATAHUALPA
2958	1452	SALANGO
2959	1456	MACAS
2960	1456	ALSHI (CAB. EN 9 DE OCTUBRE)
2961	1456	CHIGUAZA
2962	1456	GENERAL PROA??O
2963	1456	HUASAGA (CAB.EN WAMPUIK)
2964	1456	MACUMA
2965	1456	SEVILLA DON BOSCO
2966	1456	SINA??
2967	1456	TAISHA
2968	1456	ZU??A (Z????AC)
2969	1456	TUUTINENTZA
2970	1456	CUCHAENTZA
2971	1456	SAN JOS?? DE MORONA
2972	1456	R??O BLANCO
2973	1457	GUALAQUIZA
2974	1457	MERCEDES MOLINA
2975	1457	AMAZONAS (ROSARIO DE CUYES)
2976	1457	BERMEJOS
2977	1457	BOMBOIZA
2978	1457	CHIG??INDA
2979	1457	NUEVA TARQUI
2980	1457	SAN MIGUEL DE CUYES
2981	1457	EL IDEAL
2982	1458	GENERAL LEONIDAS PLAZA GUTI??RREZ (LIM??N)
2983	1458	INDANZA
2984	1458	PAN DE AZ??CAR
2985	1458	SAN ANTONIO (CAB. EN SAN ANTONIO CENTRO
2986	1458	SAN CARLOS DE LIM??N (SAN CARLOS DEL
2987	1458	SAN JUAN BOSCO
2988	1458	SAN MIGUEL DE CONCHAY
2989	1458	SANTA SUSANA DE CHIVIAZA (CAB. EN CHIVIAZA)
2990	1458	YUNGANZA (CAB. EN EL ROSARIO)
2991	1459	PALORA (METZERA)
2992	1459	ARAPICOS
2993	1459	CUMAND?? (CAB. EN COLONIA AGR??COLA SEVILLA DEL ORO)
2994	1459	HUAMBOYA
2995	1459	SANGAY (CAB. EN NAYAMANACA)
2996	1460	SANTIAGO DE M??NDEZ
2997	1460	COPAL
2998	1460	CHUPIANZA
2999	1460	PATUCA
3000	1460	SAN LUIS DE EL ACHO (CAB. EN EL ACHO)
3001	1460	TAYUZA
3002	1460	SAN FRANCISCO DE CHINIMBIMI
3003	1461	SUC??A
3004	1461	HUAMBI
3005	1461	LOGRO??O
3006	1461	YAUPI
3007	1461	SANTA MARIANITA DE JES??S
3008	1462	PABLO SEXTO
3009	1463	SAN CARLOS DE LIM??N
3010	1463	SAN JACINTO DE WAKAMBEIS
3011	1463	SANTIAGO DE PANANZA
3012	1464	HUASAGA (CAB. EN WAMPUIK)
3013	1464	PUMPUENTSA
3014	1465	SHIMPIS
3015	1468	TENA
3016	1468	AHUANO
3017	1468	CARLOS JULIO AROSEMENA TOLA (ZATZA-YACU)
3018	1468	CHONTAPUNTA
3019	1468	PANO
3020	1468	PUERTO MISAHUALLI
3021	1468	PUERTO NAPO
3022	1468	T??LAG
3023	1468	SAN JUAN DE MUYUNA
3024	1469	ARCHIDONA
3025	1469	AVILA
3026	1469	COTUNDO
3027	1469	LORETO
3028	1469	SAN PABLO DE USHPAYACU
3029	1469	PUERTO MURIALDO
3030	1470	EL CHACO
3031	1470	GONZALO D??AZ DE PINEDA (EL BOMB??N)
3032	1470	LINARES
3033	1470	OYACACHI
3034	1470	SARDINAS
3035	1471	BAEZA
3036	1471	COSANGA
3037	1471	CUYUJA
3038	1471	PAPALLACTA
3039	1471	SAN FRANCISCO DE BORJA (VIRGILIO D??VILA)
3040	1471	SAN JOS?? DEL PAYAMINO
3041	1471	SUMACO
3042	1472	CARLOS JULIO AROSEMENA TOLA
3043	1473	PUYO
3044	1473	ARAJUNO
3045	1473	CANELOS
3046	1473	CURARAY
3047	1473	DIEZ DE AGOSTO
3048	1473	F??TIMA
3049	1473	MONTALVO (ANDOAS)
3050	1473	POMONA
3051	1473	R??O CORRIENTES
3052	1473	R??O TIGRE
3053	1473	SARAYACU
3054	1473	SIM??N BOL??VAR (CAB. EN MUSHULLACTA)
3055	1473	TENIENTE HUGO ORTIZ
3056	1473	VERACRUZ (INDILLAMA) (CAB. EN INDILLAMA)
3057	1474	MERA
3058	1474	MADRE TIERRA
3059	1474	SHELL
3060	1477	BELISARIO QUEVEDO
3061	1477	CARCEL??N
3062	1477	CENTRO HIST??RICO
3063	1477	COMIT?? DEL PUEBLO
3064	1477	COTOCOLLAO
3065	1477	CHILIBULO
3066	1477	CHILLOGALLO
3067	1477	CHIMBACALLE
3068	1477	EL CONDADO
3069	1477	GUAMAN??
3070	1477	I??AQUITO
3071	1477	ITCHIMB??A
3072	1477	KENNEDY
3073	1477	LA ARGELIA
3074	1477	LA CONCEPCI??N
3075	1477	LA ECUATORIANA
3076	1477	LA FERROVIARIA
3077	1477	LA MAGDALENA
3078	1477	LA MENA
3079	1477	PONCEANO
3080	1477	PUENGAS??
3081	1477	QUITUMBE
3082	1477	RUMIPAMBA
3083	1477	SAN BARTOLO
3084	1477	SAN ISIDRO DEL INCA
3085	1477	SOLANDA
3086	1477	TURUBAMBA
3087	1477	QUITO DISTRITO METROPOLITANO
3088	1477	ALANGAS??
3089	1477	AMAGUA??A
3090	1477	CALACAL??
3091	1477	CONOCOTO
3092	1477	CUMBAY??
3093	1477	CHAVEZPAMBA
3094	1477	CHECA
3095	1477	EL QUINCHE
3096	1477	GUALEA
3097	1477	GUANGOPOLO
3098	1477	GUAYLLABAMBA
3099	1477	LA MERCED
3100	1477	LLANO CHICO
3101	1477	LLOA
3102	1477	MINDO
3103	1477	NANEGAL
3104	1477	NANEGALITO
3105	1477	NAY??N
3106	1477	NONO
3107	1477	PACTO
3108	1477	PEDRO VICENTE MALDONADO
3109	1477	PERUCHO
3110	1477	PIFO
3111	1477	P??NTAG
3112	1477	POMASQUI
3113	1477	PU??LLARO
3114	1477	PUEMBO
3115	1477	SAN JOS?? DE MINAS
3116	1477	SAN MIGUEL DE LOS BANCOS
3117	1477	TABABELA
3118	1477	TUMBACO
3119	1477	YARUQU??
3120	1477	ZAMBIZA
3121	1477	PUERTO QUITO
3122	1478	AYORA
3123	1478	CAYAMBE
3124	1478	JUAN MONTALVO
3125	1478	ASC??ZUBI
3126	1478	CANGAHUA
3127	1478	OLMEDO (PESILLO)
3128	1478	OT??N
3129	1478	SANTA ROSA DE CUZUBAMBA
3130	1479	MACHACHI
3131	1479	AL??AG
3132	1479	ALOAS??
3133	1479	CUTUGLAHUA
3134	1479	EL CHAUPI
3135	1479	MANUEL CORNEJO ASTORGA (TANDAPI)
3136	1479	UYUMBICHO
3137	1480	TABACUNDO
3138	1480	MALCHINGU??
3139	1480	TOCACHI
3140	1480	TUPIGACHI
3141	1481	SANGOLQU??
3142	1481	SAN PEDRO DE TABOADA
3143	1481	SANGOLQUI
3144	1481	COTOGCHOA
3145	1485	ATOCHA ??? FICOA
3146	1485	CELIANO MONGE
3147	1485	HUACHI CHICO
3148	1485	HUACHI LORETO
3149	1485	LA PEN??NSULA
3150	1485	MATRIZ
3151	1485	PISHILATA
3152	1485	AMBATO
3153	1485	AMBATILLO
3154	1485	ATAHUALPA (CHISALATA)
3155	1485	AUGUSTO N. MART??NEZ (MUNDUGLEO)
3156	1485	CONSTANTINO FERN??NDEZ (CAB. EN CULLITAHUA)
3157	1485	HUACHI GRANDE
3158	1485	IZAMBA
3159	1485	JUAN BENIGNO VELA
3160	1485	PASA
3161	1485	PICAIGUA
3162	1485	PILAG????N (PILAH????N)
3163	1485	QUISAPINCHA (QUIZAPINCHA)
3164	1485	SAN BARTOLOM?? DE PINLLOG
3165	1485	SAN FERNANDO (PASA SAN FERNANDO)
3166	1485	TOTORAS
3167	1485	CUNCHIBAMBA
3168	1485	UNAMUNCHO
3169	1486	BA??OS DE AGUA SANTA
3170	1486	LLIGUA
3171	1486	R??O NEGRO
3172	1486	ULBA
3173	1487	CEVALLOS
3174	1488	MOCHA
3175	1488	PINGUIL??
3176	1489	PATATE
3177	1489	LOS ANDES (CAB. EN POATUG)
3178	1489	SUCRE (CAB. EN SUCRE-PATATE URCU)
3179	1490	QUERO
3180	1490	YANAYACU - MOCHAPATA (CAB. EN YANAYACU)
3181	1491	PELILEO
3182	1491	PELILEO GRANDE
3183	1491	BEN??TEZ (PACHANLICA)
3184	1491	COTAL??
3185	1491	CHIQUICHA (CAB. EN CHIQUICHA GRANDE)
3186	1491	EL ROSARIO (RUMICHACA)
3187	1491	GARC??A MORENO (CHUMAQUI)
3188	1491	GUAMBAL?? (HUAMBAL??)
3189	1491	SALASACA
3190	1492	CIUDAD NUEVA
3191	1492	P??LLARO
3192	1492	BAQUERIZO MORENO
3193	1492	EMILIO MAR??A TER??N (RUMIPAMBA)
3194	1492	MARCOS ESPINEL (CHACATA)
3195	1492	PRESIDENTE URBINA (CHAGRAPAMBA -PATZUCUL)
3196	1492	SAN JOS?? DE POAL??
3197	1492	SAN MIGUELITO
3198	1493	TISALEO
3199	1493	QUINCHICOTO
3200	1494	EL LIM??N
3201	1494	ZAMORA
3202	1494	CUMBARATZA
3203	1494	GUADALUPE
3204	1494	IMBANA (LA VICTORIA DE IMBANA)
3205	1494	PAQUISHA
3206	1494	TIMBARA
3207	1494	ZUMBI
3208	1494	SAN CARLOS DE LAS MINAS
3209	1495	ZUMBA
3210	1495	CHITO
3211	1495	EL CHORRO
3212	1495	EL PORVENIR DEL CARMEN
3213	1495	LA CHONTA
3214	1495	PALANDA
3215	1495	PUCAPAMBA
3216	1495	SAN FRANCISCO DEL VERGEL
3217	1495	VALLADOLID
3218	1496	GUAYZIMI
3219	1496	ZURMI
3220	1496	NUEVO PARA??SO
3221	1497	28 DE MAYO (SAN JOS?? DE YACUAMBI)
3222	1497	TUTUPALI
3223	1498	YANTZAZA (YANZATZA)
3224	1498	CHICA??A
3225	1498	EL PANGUI
3226	1498	LOS ENCUENTROS
3227	1499	EL GUISME
3228	1499	PACHICUTZA
3229	1499	TUNDAYME
3230	1500	TRIUNFO-DORADO
3231	1500	PANGUINTZA
3232	1501	LA CANELA
3233	1502	NUEVO QUITO
3234	1503	PUERTO BAQUERIZO MORENO
3235	1503	EL PROGRESO
3236	1503	A SANTA MAR??A (FLOREANA) (CAB. EN PTO. VELASCO IBARR
3237	1504	PUERTO VILLAMIL
3238	1504	TOM??S DE BERLANGA (SANTO TOM??S)
3239	1505	PUERTO AYORA
3240	1505	SANTA ROSA (INCLUYE LA ISLA BALTRA)
3241	1506	NUEVA LOJA
3242	1506	CUYABENO
3243	1506	DURENO
3244	1506	GENERAL FARF??N
3245	1506	TARAPOA
3246	1506	EL ENO
3247	1506	PACAYACU
3248	1506	SANTA CECILIA
3249	1506	AGUAS NEGRAS
3250	1507	EL DORADO DE CASCALES
3251	1507	EL REVENTADOR
3252	1507	GONZALO PIZARRO
3253	1507	LUMBAQU??
3254	1507	PUERTO LIBRE
3255	1507	SANTA ROSA DE SUCUMB??OS
3256	1508	PUERTO EL CARMEN DEL PUTUMAYO
3257	1508	PALMA ROJA
3258	1508	PUERTO BOL??VAR (PUERTO MONT??FAR)
3259	1508	PUERTO RODR??GUEZ
3260	1508	SANTA ELENA
3261	1509	SHUSHUFINDI
3262	1509	LIMONCOCHA
3263	1509	PA??ACOCHA
3264	1509	SAN ROQUE (CAB. EN SAN VICENTE)
3265	1509	SAN PEDRO DE LOS COFANES
3266	1509	SIETE DE JULIO
3267	1510	LA BONITA
3268	1510	EL PLAY??N DE SAN FRANCISCO
3269	1510	LA SOF??A
3270	1510	ROSA FLORIDA
3271	1510	SANTA B??RBARA
3272	1513	PUERTO FRANCISCO DE ORELLANA (EL COCA)
3273	1513	DAYUMA
3274	1513	TARACOA (NUEVA ESPERANZA: YUCA)
3275	1513	ALEJANDRO LABAKA
3276	1513	EL DORADO
3277	1513	EL ED??N
3278	1513	IN??S ARANGO (CAB. EN WESTERN)
3279	1513	LA BELLEZA
3280	1513	NUEVO PARA??SO (CAB. EN UNI??N
3281	1513	SAN JOS?? DE GUAYUSA
3282	1513	SAN LUIS DE ARMENIA
3283	1514	TIPITINI
3284	1514	NUEVO ROCAFUERTE
3285	1514	CAPIT??N AUGUSTO RIVADENEYRA
3286	1514	CONONACO
3287	1514	SANTA MAR??A DE HUIRIRIMA
3288	1514	TIPUTINI
3289	1514	YASUN??
3290	1515	LA JOYA DE LOS SACHAS
3291	1515	ENOKANQUI
3292	1515	POMPEYA
3293	1515	SAN SEBASTI??N DEL COCA
3294	1515	LAGO SAN PEDRO
3295	1515	TRES DE NOVIEMBRE
3296	1515	UNI??N MILAGRE??A
3297	1516	AVILA (CAB. EN HUIRUNO)
3298	1516	SAN JOS?? DE PAYAMINO
3299	1516	SAN JOS?? DE DAHUANO
3300	1516	SAN VICENTE DE HUATICOCHA
3301	1517	ABRAHAM CALAZAC??N
3302	1517	BOMBOL??
3303	1517	CHIGUILPE
3304	1517	R??O TOACHI
3305	1517	SANTO DOMINGO DE LOS COLORADOS
3306	1517	ZARACAY
3307	1517	ALLURIQU??N
3308	1517	PUERTO LIM??N
3309	1517	LUZ DE AM??RICA
3310	1517	SAN JACINTO DEL B??A
3311	1517	EL ESFUERZO
3312	1517	SANTA MAR??A DEL TOACHI
3313	1518	BALLENITA
3314	1518	COLONCHE
3315	1518	CHANDUY
3316	1518	MANGLARALTO
3317	1518	SIM??N BOL??VAR (JULIO MORENO)
3318	1518	SAN JOS?? DE ANC??N
3319	1520	CARLOS ESPINOZA LARREA
3320	1520	GRAL. ALBERTO ENR??QUEZ GALLO
3321	1520	VICENTE ROCAFUERTE
3322	1520	ANCONCITO
3323	1520	JOS?? LUIS TAMAYO (MUEY)
3324	1521	LAS GOLONDRINAS
3325	1522	MANGA DEL CURA
3326	1523	Ahuachap??n
3327	1523	Tacuba
3328	1523	Concepci??n de Ataco
3329	1523	San Pedro Puxtla
3330	1523	Apaneca
3331	1523	Jujutla
3332	1523	San Francisco Men??ndez
3333	1523	Guaymango
3334	1524	Atiquizaya
3335	1524	Tur??n
3336	1524	San Lorenzo
3337	1524	El Refugio
3338	1525	Sonsonate
3339	1525	Nahuizalco
3340	1525	Acajutla
3341	1525	San Antonio del Monte
3342	1525	Santo Domingo de Guzm??n
3343	1525	Sonzacate
3344	1525	Nahuilingo
3345	1526	Izalco
3346	1526	Armenia
3347	1526	San Juli??n
3348	1526	Santa Isabel Ishuat??n
3349	1526	Cuisnahuat
3350	1526	Caluco
3351	1527	Juay??a
3352	1527	Santa Catarina Masahuat
3353	1527	Salcoatit??n
3354	1528	Santa Ana
3355	1528	Coatepeque
3356	1528	Texistepeque
3357	1528	El Congo
3358	1529	Chalchuapa
3359	1529	Candelaria de La Frontera
3360	1529	San Sebasti??n Salitrillo
3361	1529	El Porvenir
3362	1530	Metap??n
3363	1530	Santiago de La Frontera
3364	1530	Masahuat
3365	1530	Santa Rosa Guachipil??n
3366	1530	San Antonio Pajonal
3367	1531	Chalatenango
3368	1531	Arcatao
3369	1531	Concepci??n Quezaltepeque
3370	1531	San Miguel de Mercedes
3371	1531	San Francisco Lempa
3372	1531	San Isidro Labrado
3373	1531	Nueva Trinidad
3374	1531	Nombre de Jes??s
3375	1531	San Antonio Los Ranchos
3376	1531	El Carrizal
3377	1531	San Antonio de La Cruz
3378	1531	Las Vueltas
3379	1531	Potonico
3380	1531	San Luis del Carmen
3381	1531	Azacualpa
3382	1531	Cancasque
3383	1531	Ojos de Agua
3384	1531	Las Flores
3385	1532	Tejutla
3386	1532	Nueva Concepci??n
3387	1532	La Palma
3388	1532	Cital??
3389	1532	La Reina
3390	1532	San Ignacio
3391	1532	Agua Caliente
3392	1533	Dulce Nombre de Mar??a
3393	1533	San Fernando
3394	1533	La Laguna
3395	1533	El Para??so
3396	1533	San Francisco Moraz??n
3397	1533	San Rafael
3398	1533	Comalapa
3399	1534	Nueva San Salvador
3400	1534	Jayaque
3401	1534	La Libertad
3402	1534	Zaragoza
3403	1534	Antiguo Cuscatlan
3404	1534	Comasagua
3405	1534	Teotepeque
3406	1534	Huiz??car
3407	1534	Tepecoyo
3408	1534	Col??n
3409	1534	San Jos?? Villanueva
3410	1534	Tamanique
3411	1534	Chiltuipan
3412	1534	Nuevo Cuscatlan
3413	1534	Talnique
3414	1534	Jicalapa
3415	1534	Sacacoyo
3416	1535	Quezaltepeque
3417	1535	San Pablo Tacachico
3418	1536	San Juan Opico
3419	1537	San Salvador
3420	1537	Mejicanos
3421	1537	Soyapango
3422	1537	Delgado
3423	1537	Ayutuxtepeque
3424	1537	Cuscatancingo
3425	1538	Tonacatepeque
3426	1538	Guazapa
3427	1538	San Mart??n
3428	1538	Apopa
3429	1538	Nejapa
3430	1538	Aguilares
3431	1538	Ilopango
3432	1538	El Paisnal
3433	1539	Santo Tom??s
3434	1539	San Marcos
3435	1539	Panchimalco
3436	1539	Santiago Texacuangos
3437	1539	Rosario de Mora
3438	1540	Cojutepeque
3439	1540	San Rafael Perulap??n
3440	1540	San Rafael Cedros
3441	1540	Tenancingo
3442	1540	Candelaria
3443	1540	San Crist??bal
3444	1540	San Bartolom?? Perulap??a
3445	1540	Monte San Juan
3446	1540	El Carmen
3447	1540	Santa Cruz Michapa
3448	1540	San Ram??n
3449	1540	El Rosario
3450	1540	Santa Cruz Analquito
3451	1541	Suchitoto
3452	1541	San Jos?? Guayabal
3453	1541	Oratorio de Concepci??n
3454	1542	Zacatecoluca
3455	1542	Santiago Nonualco
3456	1542	San Juan Nonualco
3457	1542	San Rafael obrajuelo
3458	1542	San Luis La Herradura
3459	1543	Olocuilta
3460	1543	San Juan Talpa
3461	1543	Cuyultit??n
3462	1543	San Luis Talpa
3463	1543	San Francisco Chinameca
3464	1544	San Pedro Nonualco
3465	1544	Santa Mar??a Ostuma
3466	1544	San Emigdio
3467	1544	Para??so de Osorio
3468	1544	Jerusal??n
3469	1544	Mercedes La Ceiba
3470	1545	Tapahuaca
3471	1545	San Pedro Masahuat
3472	1545	San Miguel Tepezontes
3473	1545	San Juan Tepezontes
3474	1545	San Antonio Masahuat
3475	1546	Sensuntepeque
3476	1546	Victoria
3477	1546	Dolores
3478	1546	San Isidro
3479	1546	Guacotecti
3480	1547	Ilobasco
3481	1547	Tejutepeque
3482	1547	Jutiapa
3483	1547	Cinquera
3484	1548	San Vicente
3485	1548	Apastepeque
3486	1548	Guadalupe
3487	1548	Tecoluca
3488	1548	Verapaz
3489	1548	Tepetit??n
3490	1548	San Cayetano Istepeque
3491	1549	San Sebasti??n
3492	1549	Santo Domingo
3493	1549	San Esteban Catarina
3494	1549	San Idelfonso
3495	1549	Santa Clara
3496	1550	Usulut??n
3497	1550	Jiquilisco
3498	1550	Santa Elena
3499	1550	Santa Mar??a
3500	1550	Jucuar??n
3501	1550	Puerto El Triunfo
3502	1550	Concepci??n Batres
3503	1550	Ereguayqu??n
3504	1550	Ozatl??n
3505	1550	San Dionisio
3506	1551	Santiago de Mar??a
3507	1551	Alegr??a
3508	1551	Tecap??n
3509	1551	California
3510	1552	Berl??n
3511	1552	Mercedes Uma??a
3512	1552	San Agust??n
3513	1552	San Francisco Javier
3514	1553	Jucuapa
3515	1553	Estanzuelas
3516	1553	El Triunfo
3517	1553	Nueva Granada
3518	1553	San Buenaventura
3519	1554	San Miguel
3520	1554	Ciudad Barrios
3521	1554	Chapeltique
3522	1554	Moncagua
3523	1554	Chirilagua
3524	1554	Uluazapa
3525	1554	Quelepa
3526	1554	Comacar??n
3527	1555	Chinameca
3528	1555	San Rafael Oriente
3529	1555	Nueva Guadalupe
3530	1555	El Tr??nsito
3531	1555	Lolotique
3532	1555	San Jorge
3533	1556	Sesor??
3534	1556	San Luis de La Reina
3535	1556	Carolina
3536	1556	San Gerardo
3537	1556	Nuevo Ed??n de San Juan
3538	1556	San Antonio
3539	1557	San Francisco Gotera
3540	1557	Jocoro
3541	1557	Guatajiagua
3542	1557	Sociedad
3543	1557	San Carlos
3544	1557	Chilanga
3545	1557	El Divisadero
3546	1557	Yamabal
3547	1557	Sensembra
3548	1557	Lolotiquillo
3549	1558	Jocoaitique
3550	1558	Meanguera
3551	1558	Arambala
3552	1558	Perqu??n
3553	1558	Torola
3554	1558	Joateca
3555	1559	Osicala
3556	1559	Corinto
3557	1559	Cacaopera
3558	1559	San Sim??n
3559	1559	Yoloaiqu??n
3560	1559	Delicias de Concepci??n
3561	1559	Gualococti
3562	1560	La Uni??n
3563	1560	San Alejo
3564	1560	Yucuaiquin
3565	1560	Conchagua
3566	1560	Intipuc??
3567	1560	San Jos??
3568	1560	Yayantique
3569	1560	Bolivar
3570	1560	Meanguera del Golfo
3571	1561	Santa Rosa de Lima
3572	1561	Pasaquina
3573	1561	Anamor??s
3574	1561	Nueva Esparta
3575	1561	El Sauce
3576	1561	Concepci??n de Oriente
3577	1561	Polor??s
3578	1562	Carmen
3579	1562	Merced
3580	1562	Hospital
3581	1562	Catedral
3582	1562	Zapote
3583	1562	San Francisco de Dos R??os
3584	1562	Uruca
3585	1562	Mata Redonda
3586	1562	Pavas
3587	1562	Hatillo
3588	1562	San Sebasti??n
3589	1563	Escaz??
3590	1563	San Antonio
3591	1563	San Rafael
3592	1564	Desamparados
3593	1564	San Miguel
3594	1564	San Juan de Dios
3595	1564	San Rafael Arriba
3596	1564	Frailes
3597	1564	Patarr??
3598	1564	San Crist??bal
3599	1564	Rosario
3600	1564	Damas
3601	1564	San Rafael Abajo
3602	1564	Gravilias
3603	1564	Los Guido
3604	1565	Santiago
3605	1565	Mercedes Sur
3606	1565	Barbacoas
3607	1565	Grifo Alto
3608	1565	Candelaria
3609	1565	Desamparaditos
3610	1565	Chires
3611	1566	San Marcos
3612	1566	San Lorenzo
3613	1566	San Carlos
3614	1567	Aserr??
3615	1567	Tarbaca o Praga
3616	1567	Vuelta de Jorco
3617	1567	San Gabriel
3618	1567	La Legua
3619	1567	Monterrey
3620	1567	Salitrillos
3621	1568	Col??n
3622	1568	Guayabo
3623	1568	Tabarcia
3624	1568	Piedras Negras
3625	1568	Picagres
3626	1569	Guadalupe
3627	1569	San Francisco
3628	1569	Calle Blancos
3629	1569	Mata de Pl??tano
3630	1569	Ip??s
3631	1569	Rancho Redondo
3632	1569	Purral
3633	1570	Santa Ana
3634	1570	Salitral
3635	1570	Pozos o Concepci??n
3636	1570	Uruca o San Joaqu??n
3637	1570	Piedades
3638	1570	Brasil
3639	1571	Alajuelita
3640	1571	San Josecito
3641	1571	Concepci??n
3642	1571	San Felipe
3643	1572	San Isidro
3644	1572	Dulce Nombre o Jes??s
3645	1572	Patalillo
3646	1572	Cascajal
3647	1573	San Ignacio
3648	1573	Guaitil
3649	1573	Palmichal
3650	1573	Cangrejal
3651	1573	Sabanillas
3652	1574	San Juan
3653	1574	Cinco Esquinas
3654	1574	Anselmo Llorente
3655	1574	Le??n XIII
3656	1574	Colima
3657	1575	San Vicente
3658	1575	San Jer??nimo
3659	1575	La Trinidad
3660	1576	San Pedro
3661	1576	Sabanilla
3662	1576	Mercedes o Betania
3663	1577	San Pablo
3664	1577	San Juan de Mata
3665	1577	San Luis
3666	1577	Carara
3667	1578	Santa Mar??a
3668	1578	Jard??n
3669	1578	Copey
3670	1579	General
3671	1579	Daniel Flores
3672	1579	Rivas
3673	1579	Platanares
3674	1579	Pejibaye
3675	1579	Caj??n o Carmen
3676	1579	Bar??
3677	1579	R??o Nuevo
3678	1579	P??ramo
3679	1580	San Andr??s
3680	1580	Llano Bonito
3681	1580	Santa Cruz
3682	1581	Alajuela
3683	1581	San Jos??
3684	1581	Carrizal
3685	1581	Gu??cima
3686	1581	R??o Segundo
3687	1581	Turrucares
3688	1581	Tambor
3689	1581	La Garita
3690	1581	Sarapiqu??
3691	1582	San Ram??n
3692	1582	Piedades Norte
3693	1582	Piedades Sur
3694	1582	Angeles
3695	1582	Alfaro
3696	1582	Volio
3697	1582	Zapotal
3698	1582	San Isidro de Pe??as Blancas
3699	1583	Grecia
3700	1583	San Roque
3701	1583	Tacares
3702	1583	R??o Cuarto
3703	1583	Puente Piedra
3704	1583	Bol??var
3705	1584	San Mateo
3706	1584	Desmonte
3707	1584	Jes??s Mar??a
3708	1585	Atenas
3709	1585	Jes??s
3710	1585	Mercedes
3711	1585	Santa Eulalia
3712	1585	Escobal
3713	1586	Naranjo
3714	1586	Cirr?? Sur
3715	1587	Palmares
3716	1587	Zaragoza
3717	1587	Buenos Aires
3718	1587	Esquipulas
3719	1587	La Granja
3720	1588	Carrillos
3721	1588	Sabana Redonda
3722	1589	Orotina
3723	1589	Mastate
3724	1589	Hacienda Vieja
3725	1589	Coyolar
3726	1589	Ceiba
3727	1590	Quesada
3728	1590	Florencia
3729	1590	Buenavista
3730	1590	Aguas Zarcas
3731	1590	Venecia
3732	1590	Pital
3733	1590	Fortuna
3734	1590	Tigra
3735	1590	Palmera
3736	1590	Venado
3737	1590	Cutris
3738	1590	Pocosol
3739	1591	Zarcero
3740	1591	Laguna
3741	1591	Tapezco
3742	1591	Palmira
3743	1591	Brisas
3744	1592	Sarch?? Norte
3745	1592	Sarch?? Sur
3746	1592	Toro Amarillo
3747	1592	Rodr??guez
3748	1593	Upala
3749	1593	Aguas Claras
3750	1593	San Jos?? o Pizote
3751	1593	Bijagua
3752	1593	Delicias
3753	1593	Dos R??os
3754	1593	Yolillal
3755	1594	Los Chiles
3756	1594	Ca??o Negro
3757	1594	Amparo
3758	1594	San Jorge
3759	1595	Cote
3760	1596	Oriental
3761	1596	Occidental
3762	1596	San Nicol??s
3763	1596	Aguacaliente  (San Francisco)
3764	1596	Guadalupe  (Arenilla)
3765	1596	Corralillo
3766	1596	Tierra Blanca
3767	1596	Dulce Nombre
3768	1596	Llano Grande
3769	1596	Quebradilla
3770	1597	Para??so
3771	1597	Orosi
3772	1597	Cach??
3773	1597	Llanos de Sta Lucia
3774	1598	Tres R??os
3775	1598	San Diego
3776	1598	R??o Azul
3777	1599	Juan Vi??as
3778	1599	Tucurrique
3779	1600	Turrialba
3780	1600	La Suiza
3781	1600	Peralta
3782	1600	Santa Teresita
3783	1600	Pavones
3784	1600	Tuis
3785	1600	Tayutic
3786	1600	Santa Rosa
3787	1600	Tres Equis
3788	1600	La Isabel
3789	1600	Chirripo
3790	1601	Pacayas
3791	1601	Cervantes
3792	1601	Capellades
3793	1602	Cot
3794	1602	Potrero Cerrado
3795	1602	Cipreses
3796	1603	El Tejar
3797	1603	Tobosi
3798	1603	Patio de Agua
3799	1604	Heredia
3800	1604	Ulloa
3801	1604	Vara Blanca
3802	1605	Barva
3803	1605	Santa Luc??a
3804	1605	San Jos?? de la Monta??a
3805	1606	Santo Domingo
3806	1606	Paracito
3807	1606	Santo Tom??s
3808	1606	Tures
3809	1606	Par??
3810	1607	Santa B??rbara
3811	1607	Santo Domingo del Roble
3812	1607	Puraba
3813	1610	La Rivera
3814	1610	Asunci??n
3815	1611	San Joaqu??n
3816	1611	Barrantes
3817	1611	Llorente
3818	1613	Puerto Viejo
3819	1613	La Virgen
3820	1613	Horquetas
3821	1613	Llanuras del Gaspar
3822	1613	Cure??a
3823	1614	Liberia
3824	1614	Ca??as Dulces
3825	1614	Mayorga
3826	1614	Nacascolo
3827	1614	Curubande
3828	1615	Nicoya
3829	1615	Mansi??n
3830	1615	Quebrada Honda
3831	1615	S??mara
3832	1615	Nosara
3833	1615	Bel??n de Nosarita
3834	1616	Bols??n
3835	1616	Veintisiete de Abril
3836	1616	Tempate
3837	1616	Cartagena
3838	1616	Cuajiniquil
3839	1616	Diri??
3840	1616	Cabo Velas
3841	1616	Tamarindo
3842	1617	Bagaces
3843	1617	Mogote
3844	1617	R??o Naranjo
3845	1618	Filadelfia
3846	1618	Sardinal
3847	1618	Bel??n
3848	1619	Ca??as
3849	1619	Bebedero
3850	1619	Porozal
3851	1620	Juntas
3852	1620	Sierra
3853	1620	Colorado
3854	1621	Tilar??n
3855	1621	Quebrada Grande
3856	1621	Tronadora
3857	1621	L??bano
3858	1621	Tierras Morenas
3859	1621	Arenal
3860	1622	Carmona
3861	1622	Santa Rita
3862	1622	Porvenir
3863	1622	Bejuco
3864	1623	La Cruz
3865	1623	Santa Cecilia
3866	1623	Garita
3867	1623	Santa Elena
3868	1624	Hojancha
3869	1624	Monte Romo
3870	1624	Puerto Carrillo
3871	1624	Huacas
3872	1625	Puntarenas
3873	1625	Pitahaya
3874	1625	Chomes
3875	1625	Lepanto
3876	1625	Paquera
3877	1625	Manzanillo
3878	1625	Guacimal
3879	1625	Barranca
3880	1625	Monte Verde
3881	1625	Isla del Coco
3882	1625	C??bano
3883	1625	Chacarita
3884	1625	Chira (Isla)
3885	1625	Acapulco
3886	1625	El Roble
3887	1625	Arancibia
3888	1626	Esp??ritu Santo
3889	1626	San Juan Grande
3890	1626	Macacona
3891	1627	Volc??n
3892	1627	Potrero Grande
3893	1627	Boruca
3894	1627	Pilas
3895	1627	Colinas o Bajo de Ma??z
3896	1627	Ch??nguena
3897	1627	Bioley
3898	1627	Brunka
3899	1628	Miramar
3900	1628	Uni??n
3901	1629	Puerto Cort??s
3902	1629	Palmar
3903	1629	Sierpe
3904	1629	Bah??a Ballena
3905	1629	Piedras Blancas
3906	1630	Quepos
3907	1630	Savegre
3908	1630	Naranjito
3909	1631	Golfito
3910	1631	Puerto Jim??nez
3911	1631	Guaycar??
3912	1631	Pavones o Villa Conte
3913	1632	San Vito
3914	1632	Sabalito
3915	1632	Agua Buena
3916	1632	Limoncito
3917	1632	Pittier
3918	1633	Parrita
3919	1634	Corredores
3920	1634	La Cuesta
3921	1634	Paso Canoas
3922	1634	Laurel
3923	1635	Jac??
3924	1635	T??rcoles
3925	1636	Lim??n
3926	1636	Valle  La Estrella
3927	1636	R??o Blanco
3928	1636	Matama
3929	1637	Gu??piles
3930	1637	Jim??nez
3931	1637	Rita
3932	1637	Roxana
3933	1637	Cariari
3934	1638	Siquirres
3935	1638	Pacuarito
3936	1638	Florida
3937	1638	Germania
3938	1638	Cairo
3939	1638	Alegr??a
3940	1639	Bratsi
3941	1639	Sixaola
3942	1639	Cahuita
3943	1639	Telire
3944	1640	Matina
3945	1640	Bat??n
3946	1640	Carrand??
3947	1641	Gu??cimo
3948	1641	Pocora
3949	1641	R??o Jim??nez
3950	1642	Alto Orinoco
3951	1642	Huachamacare Acana??a
3952	1642	Marawaka Toky Shamana??a
3953	1642	Mavaka Mavaka
3954	1642	Sierra Parima Parimab??
3955	1643	Caname Guarinuma
3956	1643	Ucata Laja Lisa
3957	1643	Yapacana Macuruco
3958	1644	Fernando Gir??n Tovar
3959	1644	Luis Alberto G??mez
3960	1644	Pahue??a Lim??n de Parhue??a
3961	1644	Platanillal Platanillal
3962	1645	Guayapo
3963	1645	Munduapo
3964	1645	Samariapo
3965	1645	Sipapo
3966	1646	Alto Ventuari
3967	1646	Bajo Ventuari
3968	1646	Medio Ventuari
3969	1647	Comunidad
3970	1647	Victorino
3971	1648	Casiquiare
3972	1648	Cocuy
3973	1648	San Carlos de R??o Negro
3974	1648	Solano
3975	1649	Anaco
3976	1649	San Joaqu??n
3977	1650	Aragua de Barcelona
3978	1650	Cachipo
3979	1651	El Morro
3980	1651	Lecher??a
3981	1652	Puerto P??ritu
3982	1652	San Miguel
3983	1652	Sucre
3984	1653	Atapirire
3985	1653	Boca del Pao
3986	1653	El Pao
3987	1653	Pariagu??n
3988	1654	Santa B??rbara
3989	1654	Valle de Guanape
3990	1655	Calatrava
3991	1655	El Chaparro
3992	1655	Tom??s Alfaro
3993	1656	Chorrer??n
3994	1656	Guanta
3995	1657	Mamo
3996	1657	Soledad
3997	1658	Mapire
3998	1658	Piar
3999	1658	San Diego de Cabrutica
4000	1658	Santa Clara
4001	1658	Uverito
4002	1658	Zuata
4003	1659	Pozuelos
4004	1659	Puerto La Cruz
4005	1660	Onoto
4006	1660	San Pablo
4007	1661	El Carito
4008	1661	La Romere??a
4009	1661	San Mateo
4010	1661	Santa In??s
4011	1662	Clarines
4012	1662	Guanape
4013	1662	Sabana de Uchire
4014	1663	Cantaura
4015	1663	Libertador
4016	1663	Santa Rosa
4017	1663	Urica
4018	1664	P??ritu
4019	1664	San Francisco
4020	1665	San Jos?? de Guanipa
4021	1666	Boca de Ch??vez
4022	1666	Boca de Uchire
4023	1667	Pueblo Nuevo
4024	1667	Santa Ana
4025	1668	Bergant??n
4026	1668	Caigua
4027	1668	El Carmen
4028	1668	El Pilar
4029	1668	Naricual
4030	1668	San Crsit??bal
4031	1669	Edmundo Barrios
4032	1669	Miguel Otero Silva
4033	1670	Achaguas
4034	1670	Apurito
4035	1670	El Yagual
4036	1670	Guachara
4037	1670	Mucuritas
4038	1670	Queseras del medio
4039	1671	Biruaca
4040	1672	Bruzual
4041	1672	Mantecal
4042	1672	Quintero
4043	1672	Rinc??n Hondo
4044	1672	San Vicente
4045	1673	Aramendi
4046	1673	El Amparo
4047	1673	Guasdualito
4048	1673	San Camilo
4049	1673	Urdaneta
4050	1674	Codazzi
4051	1674	Cunaviche
4052	1674	San Juan de Payara
4053	1675	Elorza
4054	1675	La Trinidad
4055	1676	El Recreo
4056	1676	Pe??alver
4057	1676	San Fernando
4058	1676	San Rafael de Atamaica
4059	1677	Andr??s Eloy Blanco
4060	1677	Choron??
4061	1677	Joaqu??n Crespo
4062	1677	Jos?? Casanova Godoy
4063	1677	Las Delicias
4064	1677	Los Tacarigua
4065	1677	Madre Mar??a de San Jos??
4066	1677	Pedro Jos?? Ovalles
4067	1678	Bol??var
4068	1679	Camatagua
4069	1679	Carmen de Cura
4070	1680	Francisco de Miranda
4071	1680	Mose??or Feliciano Gonz??lez
4072	1680	Santa Rita
4073	1681	Santa Cruz
4074	1682	Castor Nieves R??os
4075	1682	Jos?? F??lix Ribas
4076	1682	Las Guacamayas
4077	1682	Pao de Z??rate
4078	1683	Jos?? Rafael Revenga
4079	1684	Palo Negro
4080	1684	San Mart??n de Porres
4081	1685	Ca??a de Az??car
4082	1685	El Lim??n
4083	1686	Ocumare de la Costa
4084	1687	G??iripa
4085	1687	Ollas de Caramacate
4086	1687	San Casimiro
4087	1687	Valle Mor??n
4088	1688	San Sebast??an
4089	1689	Alfredo Pacheco Miranda
4090	1689	Arevalo Aponte
4091	1689	Chuao
4092	1689	Sam??n de G??ere
4093	1689	Turmero
4094	1690	Santos Michelena
4095	1690	Tiara
4096	1691	Bella Vista
4097	1691	Cagua
4098	1692	Tovar
4099	1693	Las Pe??itas
4100	1693	San Francisco de Cara
4101	1693	Taguay
4102	1694	Augusto Mijares
4103	1694	Magdaleno
4104	1694	San Francisco de As??s
4105	1694	Valles de Tucutunemo
4106	1694	Zamora
4107	1695	Juan Antonio Rodr??guez Dom??nguez
4108	1695	Sabaneta
4109	1696	El Cant??n
4110	1696	Puerto Vivas
4111	1696	Santa Cruz de Guacas
4112	1697	Andr??s Bello
4113	1697	Nicol??s Pulido
4114	1697	Ticoporo
4115	1698	Arismendi
4116	1698	Guadarrama
4117	1698	La Uni??n
4118	1698	San Antonio
4119	1699	Alberto Arvelo Larriva
4120	1699	Alto Barinas
4121	1699	Barinas
4122	1699	Coraz??n de Jes??s
4123	1699	Dominga Ortiz de P??ez
4124	1699	Manuel Palacio Fajardo
4125	1699	Ram??n Ignacio M??ndez
4126	1699	R??mulo Betancourt
4127	1699	San Silvestre
4128	1699	Santa Luc??a
4129	1699	Torumos
4130	1699	Altamira de C??ceres
4131	1699	Barinitas
4132	1699	Calderas
4133	1700	Barrancas
4134	1700	El Socorro
4135	1700	Mazparrito
4136	1701	Jos?? Ignacio del Pumar
4137	1701	Pedro Brice??o M??ndez
4138	1702	El Real
4139	1702	Guasimitos
4140	1702	La Luz
4141	1702	Obispos
4142	1703	Ciudad Bol??via
4143	1703	Jos?? Ignacio Brice??o
4144	1703	P??ez
4145	1704	Dolores
4146	1704	Libertad
4147	1704	Palacio Fajardo
4148	1705	Ciudad de Nutrias
4149	1705	El Regalo
4150	1705	Puerto Nutrias
4151	1705	Santa Catalina
4152	1706	Barceloneta
4153	1706	Ra??l Leoni
4154	1707	5 de Julio
4155	1707	Cachamay
4156	1707	Chirica
4157	1707	Dalla Costa
4158	1707	Once de Abril
4159	1707	Pozo Verde
4160	1707	Sim??n Bol??var
4161	1707	Unare
4162	1707	Universidad
4163	1707	Vista al Sol
4164	1707	Yocoima
4165	1708	Altagracia
4166	1708	Ascensi??n Farreras
4167	1708	Cede??o
4168	1708	Guaniamo
4169	1708	La Urbana
4170	1708	Pijiguaos
4171	1709	El Callao
4172	1710	Gran Sabana
4173	1710	Ikabar??
4174	1711	Agua Salada
4175	1711	Catedral
4176	1711	Jos?? Antonio P??ez
4177	1711	La Sabanita
4178	1711	Marhuanta
4179	1711	Orinoco
4180	1711	Panapana
4181	1711	Vista Hermosa
4182	1711	Zea
4183	1712	Padre Pedro Chien
4184	1712	R??o Grande
4185	1713	Pedro Cova
4186	1714	Roscio
4187	1714	Sal??m
4188	1715	San Isidro
4189	1715	Sifontes
4190	1715	Aripao
4191	1715	Guarataro
4192	1715	Las Majadas
4193	1715	Moitaco
4194	1716	Bejuma
4195	1716	Canoabo
4196	1717	Carabobo
4197	1717	G??ig??e
4198	1717	Tacarigua
4199	1718	Aguas Calientes
4200	1718	Mariara
4201	1719	Ciudad Alianza
4202	1719	Guacara
4203	1719	Yagua
4204	1720	Mor??n
4205	1720	Independencia
4206	1720	Tocuyito
4207	1721	Los Guayos
4208	1722	Miranda
4209	1723	Montalb??n
4210	1724	Naguanagua
4211	1725	Bartolom?? Sal??m
4212	1725	Borburata
4213	1725	Democracia
4214	1725	Fraternidad
4215	1725	Goaigoaza
4216	1725	Juan Jos?? Flores
4217	1725	Patanemo
4218	1725	Uni??n
4219	1726	San Diego
4220	1728	Candelaria
4221	1728	Miguel Pe??a
4222	1728	Negro Primero
4223	1728	Rafael Urdaneta
4224	1728	San Blas
4225	1728	San Jos??
4226	1729	Cojedes
4227	1729	Juan de Mata Su??rez
4228	1730	El Ba??l
4229	1731	La Aguadita
4230	1731	Macapo
4231	1733	Libertad de Cojedes
4232	1733	R??mulo Gallegos
4233	1734	Juan ??ngel Bravo
4234	1734	Manuel Manrique
4235	1734	San Carlos de Austria
4236	1735	General en Jefe Jos?? Laurencio Silva
4237	1736	Tinaquillo
4238	1737	Almirante Luis Bri??n
4239	1737	Curiapo
4240	1737	Francisco Aniceto Lugo
4241	1737	Manuel Renaud
4242	1737	Padre Barral
4243	1737	Santos de Abelgas
4244	1738	Cinco de Julio
4245	1738	Imataca
4246	1738	Juan Bautista Arismendi
4247	1738	Manuel Piar
4248	1739	Luis Beltr??n Prieto Figueroa
4249	1739	Pedernales
4250	1740	Jos?? Vidal Marcano
4251	1740	Juan Mill??n
4252	1740	Leonardo Ru??z Pineda
4253	1740	Mariscal Antonio Jos?? de Sucre
4254	1740	Monse??or Argimiro Garc??a
4255	1740	San Jos?? (Delta Amacuro)
4256	1740	San Rafael (Delta Amacuro)
4257	1740	Virgen del Valle
4258	1740	23 de enero
4259	1740	Ant??mano
4260	1740	Caricuao
4261	1740	Coche
4262	1740	El Junquito
4263	1740	El Para??so
4264	1740	El Valle
4265	1740	La Candelaria
4266	1740	La Pastora
4267	1740	La Vega
4268	1740	Macarao
4269	1740	San Agust??n
4270	1740	San Bernardino
4271	1740	San Juan
4272	1740	San Pedro
4273	1740	Santa Rosal??a
4274	1740	Santa Teresa
4275	1740	Sucre (Catia)
4276	1741	Capadare
4277	1741	San Juan de los Cayos
4278	1741	Aracua
4279	1741	La Pe??a
4280	1741	San Luis
4281	1742	Bariro
4282	1742	Boroj??
4283	1742	Capat??rida
4284	1742	Guajiro
4285	1742	Seque
4286	1742	Valle de Eroa
4287	1742	Zaz??rida
4288	1743	Cacique Manaure
4289	1744	Carirubana
4290	1744	Norte
4291	1744	Urbana Punta Card??n
4292	1745	Acurigua
4293	1745	Guaibacoa
4294	1745	La Vela de Coro
4295	1745	Las Calderas
4296	1745	Macoruca
4297	1746	Dabajuro
4298	1747	Agua Clara
4299	1747	Avaria
4300	1747	Pedregal
4301	1747	Piedra Grande
4302	1747	Purureche
4303	1748	Adaure
4304	1748	Ad??cora
4305	1748	Baraived
4306	1748	Buena Vista
4307	1748	El Hato
4308	1748	El V??nculo
4309	1748	Jadacaquiva
4310	1748	Moruy
4311	1749	Agua Larga
4312	1749	Churuguara
4313	1749	El Pauj??
4314	1749	Maparar??
4315	1750	Agua Linda
4316	1750	Araurima
4317	1750	Jacura
4318	1751	Boca de Aroa
4319	1751	Tucacas
4320	1752	Judibana
4321	1752	Los Taques
4322	1753	Casigua
4323	1753	Mene de Mauroa
4324	1753	San F??lix
4325	1753	Guzm??n Guillermo
4326	1753	Mitare
4327	1753	R??o Seco
4328	1753	San Gabriel
4329	1754	Boca del Tocuyo
4330	1754	Chichiriviche
4331	1754	Tocuyo de la Costa
4332	1755	Palmasola
4333	1756	Cabure
4334	1756	Colina
4335	1756	Curimagua
4336	1756	San Jos?? de la Costa
4337	1757	Pecaya
4338	1758	Toc??pero
4339	1759	El Charal
4340	1759	Las Vegas del Tuy
4341	1759	Santa Cruz de Bucaral
4342	1760	Urumaco
4343	1760	La Ci??naga
4344	1760	La Soledad
4345	1760	Pueblo Cumarebo
4346	1760	Puerto Cumarebo
4347	1761	Camagu??n
4348	1761	Puerto Miranda
4349	1762	Chaguaramas
4350	1763	San Rafael de Laya
4351	1763	Tucupido
4352	1764	Altagracia de Orituco
4353	1764	Carlos Soublette
4354	1764	Libertad de Orituco
4355	1764	Paso Real de Macaira
4356	1764	San Francisco de Macaira
4357	1764	San Francisco Javier de Lezama
4358	1764	San Rafael de Orituco
4359	1765	Cantaclaro
4360	1765	Parapara
4361	1765	San Juan de los Morros
4362	1766	El Sombrero
4363	1766	Sosa
4364	1767	Cabruta
4365	1767	Las Mercedes
4366	1767	Santa Rita de Manapire
4367	1768	Espino
4368	1768	Valle de la Pascua
4369	1769	Ortiz
4370	1769	San Francisco de Tiznados
4371	1769	San Jos?? de Tiznados
4372	1769	San Lorenzo de Tiznados
4373	1770	San Jos?? de Unare
4374	1770	Zaraza
4375	1771	Cazorla
4376	1771	Guayabal
4377	1772	San Jos?? de Guaribe
4378	1772	Uveral
4379	1773	Altamira
4380	1773	Santa Mar??a de Ipire
4381	1774	Capital Urbana Calabozo
4382	1774	El Calvario
4383	1774	El Rastro
4384	1774	Guardatinajas
4385	1775	Caraballeda
4386	1775	Carayaca
4387	1775	Caruao Chuspa
4388	1775	Catia La Mar
4389	1775	El Junko
4390	1775	La Guaira
4391	1775	Macuto
4392	1775	Maiquet??a
4393	1775	Naiguat??
4394	1775	Urimare
4395	1775	P??o Tamayo
4396	1775	Quebrada Honda de Guache
4397	1775	Yacamb??
4398	1776	Fr??itez
4399	1776	Jos?? Mar??a Blanco
4400	1777	Aguedo Felipe Alvarado
4401	1777	Concepci??n
4402	1777	El Cuj??
4403	1777	Juan de Villegas
4404	1777	Ju??rez
4405	1777	Tamaca
4406	1778	Coronel Mariano Peraza 
4407	1778	Cuara
4408	1778	Diego de Lozada
4409	1778	Jos?? Bernardo Dorante
4410	1778	Juan Bautista Rodr??guez
4411	1778	Para??so de San Jos??
4412	1778	Tintorero
4413	1779	Anzo??tegui
4414	1779	Guarico
4415	1779	Hilario Luna y Luna
4416	1779	Humocaro Alto
4417	1779	Humocaro Bajo
4418	1779	Mor??n
4419	1780	Agua Viva
4420	1780	Cabudare
4421	1780	Jos?? Gregorio Bastidas
4422	1781	Bur??a
4423	1781	Gustavo Vegas Le??n
4424	1781	Sarare
4425	1782	Antonio D??az
4426	1782	Camacaro
4427	1782	Casta??eda
4428	1782	Cecilio Zubillaga
4429	1782	Chiquinquir??
4430	1782	El Blanco
4431	1782	Espinoza de los Monteros
4432	1782	Heriberto Arroyo
4433	1782	Lara
4434	1782	Manuel Morillo
4435	1782	Monta??a Verde
4436	1782	Montes de Oca
4437	1782	Reyes Vargas
4438	1782	Torres
4439	1782	Trinidad Samuel
4440	1782	Moroturo
4441	1782	Siquisique
4442	1782	Xaguas
4443	1783	Gabriel Pic??n Gonz??lez
4444	1783	H??ctor Amable Mora
4445	1783	Jos?? Nucete Sardi
4446	1783	Presidente Betancourt
4447	1783	Presidente P??ez
4448	1783	Presidente R??mulo Gallegos
4449	1783	Pulido M??ndez
4450	1784	La Azulita
4451	1785	Mesa Bol??var
4452	1785	Mesa de Las Palmas
4453	1785	Santa Cruz de Mora
4454	1786	Aricagua
4455	1787	Canagua
4456	1787	Capur??
4457	1787	Chacant??
4458	1787	El Molino
4459	1787	Guaimaral
4460	1787	Mucuchach??
4461	1787	Mucutuy
4462	1788	Acequias
4463	1788	Fern??ndez Pe??a
4464	1788	Jaj??
4465	1788	La Mesa
4466	1788	Matriz
4467	1788	San Jos?? del Sur
4468	1789	Florencio Ram??rez
4469	1789	Tucan??
4470	1790	Las Piedras
4471	1790	Santo Domingo
4472	1791	Guaraque
4473	1791	Mesa de Quintero
4474	1791	R??o Negro
4475	1792	Arapuey
4476	1792	Palmira
4477	1793	San Crist??bal de Torondoy
4478	1793	Torondoy
4479	1793	Antonio Spinetti Dini
4480	1793	Arias
4481	1793	Caracciolo Parra P??rez
4482	1793	Domingo Pe??a
4483	1793	El Llano
4484	1793	Gonzalo Pic??n Febres
4485	1793	Jacinto Plaza
4486	1793	Juan Rodr??guez Su??rez
4487	1793	Lasso de la Vega
4488	1793	Los Nevados
4489	1793	Mariano Pic??n Salas
4490	1793	Milla
4491	1793	Osuna Rodr??guez
4492	1793	Sagrario
4493	1793	La Venta
4494	1793	Pi??ango
4495	1793	Timotes
4496	1794	Eloy Paredes
4497	1794	San Rafael de Alc??zar
4498	1794	Santa Elena de Arenales
4499	1795	Santa Mar??a de Caparo
4500	1796	Pueblo Llano
4501	1797	Cacute
4502	1797	La Toma
4503	1797	Mucuch??es
4504	1797	Mucurub??
4505	1797	San Rafael
4506	1798	Bailadores
4507	1798	Ger??nimo Maldonado
4508	1799	Tabay
4509	1799	Chiguar??
4510	1799	Est??nquez
4511	1799	La Trampa
4512	1799	Lagunillas
4513	1799	Pueblo Nuevo del Sur
4514	1800	Mar??a de la Concepci??n Palacios Blanco
4515	1800	Nueva Bolivia
4516	1800	Santa Apolonia
4517	1801	Ca??o El Tigre
4518	1802	Arag??ita
4519	1802	Ar??valo Gonz??lez
4520	1802	Capaya
4521	1802	Caucagua
4522	1802	El Caf??
4523	1802	Marizapa
4524	1802	Panaquire
4525	1802	Ribas
4526	1802	Cumbo
4527	1802	San Jos?? de Barlovento
4528	1803	El Cafetal
4529	1803	Las Minas
4530	1803	Nuestra Se??ora del Rosario
4531	1804	Curiepe
4532	1804	Higuerote
4533	1804	Tacarigua de Bri??n
4534	1805	Mamporal
4535	1806	Carrizal
4536	1807	Chacao
4537	1808	Charallave
4538	1808	Las Brisas
4539	1809	El Hatillo
4540	1810	Altagracia de la Monta??a
4541	1810	Cecilio Acosta
4542	1810	El Jarillo
4543	1810	Los Teques
4544	1810	Paracotos
4545	1810	T??cata
4546	1810	Cartanal
4547	1810	Santa Teresa del Tuy
4548	1811	La Democracia
4549	1811	Ocumare del Tuy
4550	1812	San Antonio de los Altos
4551	1812	El Guapo
4552	1812	Paparo
4553	1812	R??o Chico
4554	1812	San Fernando del Guapo
4555	1812	Tacarigua de la Laguna
4556	1813	Santa Luc??a del Tuy
4557	1814	C??pira
4558	1814	Machurucuto
4559	1815	Guarenas
4560	1815	San Antonio de Yare
4561	1815	San Francisco de Yare
4562	1815	Caucag??ita
4563	1815	Filas de Mariche
4564	1815	La Dolorita
4565	1815	Leoncio Mart??nez
4566	1815	Petare
4567	1815	C??a
4568	1815	Nueva C??a
4569	1815	Guatire
4570	1815	San Antonio de Matur??n
4571	1815	San Francisco de Matur??n
4572	1816	Aguasay
4573	1816	Caripito
4574	1817	Caripe
4575	1817	El Gu??charo
4576	1817	La Guanota
4577	1817	Sabana de Piedra
4578	1817	Teresen
4579	1817	Areo
4580	1817	Capital Cede??o
4581	1817	San F??lix de Cantalicio
4582	1817	Viento Fresco
4583	1817	El Tejero
4584	1817	Punta de Mata
4585	1817	Las Alhuacas
4586	1817	Tabasca
4587	1817	Temblador
4588	1818	Alto de los Godos
4589	1818	Boquer??n
4590	1818	El Corozo
4591	1818	El Furrial
4592	1818	Jusep??n
4593	1818	La Cruz
4594	1818	La Pica
4595	1818	Las Cocuizas
4596	1818	San Sim??n
4597	1818	Aparicio
4598	1818	Aragua de Matur??n
4599	1818	Chaguamal
4600	1818	El Pinto
4601	1818	Guanaguana
4602	1818	La Toscana
4603	1818	Taguaya
4604	1819	Quiriquire
4605	1821	Los Barrancos de Fajardo
4606	1822	Uracoa
4607	1823	Antol??n del Campo
4608	1824	San Juan Bautista
4609	1824	Zabala
4610	1825	Francisco Fajardo
4611	1825	Garc??a
4612	1826	Guevara
4613	1826	Matasiete
4614	1827	Aguirre
4615	1827	Maneiro
4616	1828	Adri??n
4617	1828	Juan Griego
4618	1828	Yaguaraparo
4619	1829	Porlamar
4620	1830	Boca de R??o
4621	1830	San Francisco de Macanao
4622	1831	Los Baleales
4623	1831	Tubores
4624	1832	Vicente Fuentes
4625	1832	Villalba
4626	1833	Capital Araure
4627	1833	R??o Acarigua
4628	1834	Capital Esteller
4629	1835	C??rdoba
4630	1835	Guanare
4631	1835	San Jos?? de la Monta??a
4632	1835	San Juan de Guanaguanare
4633	1835	Virgen de la Coromoto
4634	1836	Divina Pastora
4635	1836	Guanarito
4636	1836	Trinidad de la Capilla
4637	1837	Monse??or Jos?? Vicente de Unda
4638	1837	Pe??a Blanca
4639	1838	Aparici??n
4640	1838	Capital Ospino
4641	1838	La Estaci??n
4642	1838	Payara
4643	1838	Pimpinela
4644	1838	Ram??n Peraza
4645	1839	Ca??o Delgadito
4646	1839	Papel??n
4647	1840	Antol??n Tovar
4648	1840	San Genaro de Boconoito
4649	1841	San Rafael de Onoto
4650	1841	Santa Fe
4651	1841	Thermo Morles
4652	1842	Florida
4653	1842	San Jos?? de Saguaz
4654	1842	San Rafael de Palo Alzado
4655	1842	Uvencio Antonio Vel??squez
4656	1842	Villa Rosa
4657	1843	Canelones
4658	1843	San Isidro Labrador
4659	1843	Tur??n
4660	1843	Mari??o
4661	1844	San Jos?? de Aerocuar
4662	1844	Tavera Acosta
4663	1844	Antonio Jos?? de Sucre
4664	1844	El Morro de Puerto Santo
4665	1844	Puerto Santo
4666	1844	R??o Caribe
4667	1844	San Juan de las Galdonas
4668	1845	El Rinc??n
4669	1845	General Francisco Antonio V??quez
4670	1845	Guara??nos
4671	1845	Tunapuicito
4672	1846	Maracapana
4673	1847	El Paujil
4674	1848	Chacopata
4675	1848	Cruz Salmer??n Acosta
4676	1848	Manicuare
4677	1848	Campo El??as
4678	1848	Tunapuy
4679	1848	Campo Claro
4680	1848	Irapa
4681	1848	Maraval
4682	1848	San Antonio de Irapa
4683	1848	Soro
4684	1849	Mej??a
4685	1850	Arenas
4686	1850	Cogollar
4687	1850	Cumanacoa
4688	1850	San Lorenzo
4689	1851	Catuaro
4690	1851	Rend??n
4691	1851	San Cruz
4692	1851	Santa Mar??a
4693	1851	Villa Frontado (Muelle de Cariaco)
4694	1851	Ayacucho
4695	1851	Gran Mariscal
4696	1851	Valent??n Valiente
4697	1852	Bideau
4698	1852	Crist??bal Col??n
4699	1852	G??iria
4700	1852	Punta de Piedras
4701	1853	Antonio R??mulo Costa
4702	1854	Rivas Berti
4703	1854	San Pedro del R??o
4704	1854	General Juan Vicente G??mez
4705	1854	Isa??as Medina Angarita
4706	1854	Palotal
4707	1855	Amenodoro ??ngel Lamus
4708	1855	C??rdenas
4709	1855	La Florida
4710	1857	Alberto Adriani
4711	1857	Fern??ndez Feo
4712	1858	Boca de Grita
4713	1858	Garc??a de Hevia
4714	1859	Gu??simos
4715	1859	Juan Germ??n Roscio
4716	1859	Rom??n C??rdenas
4717	1860	Emilio Constantino Guerrero
4718	1860	J??uregui
4719	1860	Monse??or Miguel Antonio Salas
4720	1861	Jos?? Mar??a Vargas
4721	1862	Bram??n
4722	1862	Jun??n
4723	1862	La Petr??lea
4724	1862	Quinimar??
4725	1862	Cipriano Castro
4726	1862	Manuel Felipe Rugeles
4727	1862	Doradas
4728	1862	Emeterio Ochoa
4729	1862	San Joaqu??n de Navay
4730	1863	Constituci??n
4731	1863	Lobatera
4732	1864	Michelena
4733	1865	La Palmita
4734	1865	Panamericano
4735	1866	Nueva Arcadia
4736	1866	Pedro Mar??a Ure??a
4737	1867	Delicias
4738	1868	Bocon??
4739	1868	Hern??ndez
4740	1868	Samuel Dar??o Maldonado
4741	1869	Dr. Francisco Romero Lobo
4742	1869	La Concordia
4743	1869	Pedro Mar??a Morantes
4744	1869	San Sebasti??n
4745	1870	San Judas Tadeo
4746	1871	Seboruco
4747	1871	Sim??n Rodr??guez
4748	1871	Eleazar L??pez Contreras
4749	1872	Torbes
4750	1873	Juan Pablo Pe??alosa
4751	1873	Potos??
4752	1873	Uribante
4753	1873	Araguaney
4754	1873	El Jaguito
4755	1873	La Esperanza
4756	1873	Santa Isabel
4757	1874	Burbusay
4758	1874	General Ribas
4759	1874	Guaramacal
4760	1874	Monse??or J??uregui
4761	1874	Mosquey
4762	1874	Rafael Rangel
4763	1874	Vega de Guaramacal
4764	1874	Chereg????
4765	1874	Granados
4766	1874	Sabana Grande
4767	1875	Arnoldo Gabald??n
4768	1875	Bolivia
4769	1875	Carrillo
4770	1875	Cegarra
4771	1875	Chejend??
4772	1875	Manuel Salvador Ulloa
4773	1876	Carache
4774	1876	Cuicas
4775	1876	La Concepci??n
4776	1876	Panamericana
4777	1877	Escuque
4778	1877	Sabana Libre
4779	1878	Los Caprichos
4780	1880	El Progreso
4781	1880	La Ceiba
4782	1880	Tres de Febrero
4783	1880	Agua Caliente
4784	1880	Agua Santa
4785	1880	El Cenizo
4786	1880	El Dividive
4787	1880	Valerita
4788	1881	Monte Carmelo
4789	1881	Santa Mar??a del Horc??n
4790	1882	El Ba??o
4791	1882	Jalisco
4792	1882	Motat??n
4793	1883	Flor de Patria
4794	1883	La Paz
4795	1883	Pamp??n
4796	1884	Pampanito
4797	1884	Pampanito II
4798	1885	Betijoque
4799	1885	Jos?? Gregorio Hern??ndez
4800	1885	La Pueblita
4801	1885	Los Cedros
4802	1886	Antonio Nicol??s Brice??o
4803	1886	Campo Alegre
4804	1886	Carvajal
4805	1886	Jos?? Leonardo Su??rez
4806	1886	Sabana de Mendoza
4807	1886	Valmore Rodr??guez
4808	1887	Andr??s Linares
4809	1887	Crist??bal Mendoza
4810	1887	Cruz Carrillo
4811	1887	Monse??or Carrillo
4812	1887	Tres Esquinas
4813	1887	Cabimb??
4814	1887	Jaj??
4815	1887	La Mesa de Esnujaque
4816	1887	La Quebrada
4817	1887	Santiago
4818	1887	Tu??ame
4819	1888	Juan Ignacio Montilla
4820	1888	La Beatriz
4821	1888	La Puerta
4822	1888	Mendoza del Valle de Momboy
4823	1888	Mercedes D??az
4824	1889	Ar??stides Bastidas
4825	1890	Chivacoa
4826	1891	Cocorote
4827	1893	El Guayabo
4828	1893	Farriar
4829	1895	Manuel Monge
4830	1896	Nirgua
4831	1896	Temerla
4832	1897	San Andr??s
4833	1897	Yaritagua
4834	1898	Albarico
4835	1898	San Felipe
4836	1898	San Javier
4837	1899	Urachiche
4838	1900	Isla de Toas
4839	1900	Monagas
4840	1901	General Urdaneta
4841	1901	Manuel Guanipa Matos
4842	1901	Marcelino Brice??o
4843	1901	San Timoteo
4844	1902	Ambrosio
4845	1902	Ar??stides Calvani
4846	1902	Carmen Herrera
4847	1902	Germ??n R??os Linares
4848	1902	Jorge Hern??ndez
4849	1902	La Rosa
4850	1902	Punta Gorda
4851	1902	San Benito
4852	1903	Encontrados
4853	1903	Ud??n P??rez
4854	1904	Moralito
4855	1904	San Carlos del Zulia
4856	1904	Santa Cruz del Zulia
4857	1904	Urribarr??
4858	1905	Carlos Quevedo
4859	1905	Francisco Javier Pulgar
4860	1905	Guamo-Gavilanes
4861	1906	Jos?? Ram??n Y??pez
4862	1906	Mariano Parra Le??n
4863	1907	Bar??
4864	1907	Jes??s Mar??a Sempr??n
4865	1908	El Carmelo
4866	1908	Potreritos
4867	1909	Alonso de Ojeda
4868	1909	Campo Lara
4869	1909	Venezuela
4870	1910	Bartolom?? de las Casas
4871	1910	San Jos?? de Perij??
4872	1911	La Sierrita
4873	1911	Las Parcelas
4874	1911	Luis de Vicente
4875	1911	Monse??or Marcos Sergio Godoy
4876	1911	Ricaurte
4877	1911	Tamare
4878	1912	Antonio Borjas Romero
4879	1912	Cacique Mara
4880	1912	Carracciolo Parra P??rez
4881	1912	Coquivacoa
4882	1912	Cristo de Aranza
4883	1912	Francisco Eugenio Bustamante
4884	1912	Idelfonzo V??squez
4885	1912	Juana de ??vila
4886	1912	Luis Hurtado Higuera
4887	1912	Manuel Dagnino
4888	1912	Olegario Villalobos
4889	1912	Venancio Pulgar
4890	1912	Ana Mar??a Campos
4891	1912	Far??a
4892	1912	Alta Guajira
4893	1912	El??as S??nchez Rubio
4894	1912	Guajira
4895	1912	Sinamaica
4896	1913	Donaldo Garc??a
4897	1913	El Rosario
4898	1913	Sixto Zambrano
4899	1913	Domitila Flores
4900	1913	El Bajo
4901	1913	Francisco Ochoa
4902	1913	Los Cortijos
4903	1913	Marcial Hern??ndez
4904	1914	El Mene
4905	1914	Jos?? Cenobio Urribarr??
4906	1914	Pedro Lucas Urribarr??
4907	1914	Rafael Maria Baralt
4908	1914	Bobures
4909	1914	El Batey
4910	1914	Gibraltar
4911	1914	Heras
4912	1914	Monse??or Arturo ??lvarez
4913	1915	La Victoria
4914	2297	San Javier
4915	2297	Trinidad
4916	2298	Reyes
4917	2298	Rurrenabaque
4918	2298	San Borja
4919	2298	Santa Rosa
4920	2299	Baures
4921	2299	Huacaraje
4922	2299	Magdalena
4923	2300	Puerto Siles
4924	2300	San Joaqu??n
4925	2300	San Ram??n
4926	2301	Loreto
4927	2301	San Andr??s
4928	2302	San Ignacio
4929	2303	Guayaramer??n
4930	2303	Riberalta
4931	2304	Exaltaci??n
4932	2304	Santa Ana
4933	2305	Tarvita
4934	2305	Villa Azurduy
4935	2306	Villa Serrano
4936	2307	Monteagudo
4937	2307	San Pablo de Huacareta
4938	2308	Huacaya
4939	2308	Macharet??
4940	2308	Villa Vaca Guzm??n (Muyupampa)
4941	2309	Camargo
4942	2309	Incahuasi
4943	2309	San Lucas
4944	2309	Villa Charcas
4945	2310	Poroma
4946	2310	Sucre
4947	2310	Yotala
4948	2311	Camataqui (Villa Abecia)
4949	2311	Culpina
4950	2311	Las Carreras
4951	2312	El Villar
4952	2312	Padilla
4953	2312	Sopachuy
4954	2312	Tomina
4955	2312	Villa Alcal??
4956	2313	Tarabuco
4957	2313	Yampar??ez
4958	2314	Icla
4959	2314	Presto
4960	2314	Villa Mojocoya
4961	2314	Villa Zuda??ez
4962	2315	Arani
4963	2315	Vacas
4964	2316	Arque
4965	2316	Tacopaya
4966	2317	Cocapata
4967	2317	Independencia
4968	2317	Morochata
4969	2318	Bol??var
4970	2319	Aiquile
4971	2319	Omereque
4972	2319	Pasorapa
4973	2320	Capinota
4974	2320	Santiva??ez
4975	2320	Sicaya
4976	2321	Chimor??
4977	2321	Entre R??os (Bulo Bulo)
4978	2321	Pocona
4979	2321	Pojo
4980	2321	Puerto Villarroel
4981	2321	Totora
4982	2321	Cochabamba
4983	2322	Colomi
4984	2322	Sacaba
4985	2322	Villa Tunari
4986	2323	Anzaldo
4987	2323	Arbieto
4988	2323	Sacabamba
4989	2323	Tarata
4990	2324	Cliza
4991	2324	Toco
4992	2324	Tolata
4993	2325	Alalay
4994	2325	Mizque
4995	2325	Vila Vila
4996	2326	Cuchumuela (Villa Gualberto Villarroel)
4997	2326	Punata
4998	2326	San Benito
4999	2326	Tacachi
5000	2326	Villa Rivero
5001	2327	Colcapirhua
5002	2327	Quillacollo
5003	2327	Sipe Sipe
5004	2327	Tiquipaya
5005	2327	Vinto
5006	2328	Tapacar??
5007	2329	Shinahota
5008	2329	Tiraque
5009	2330	Ixiamas
5010	2330	San Buenaventura
5011	2331	Ayo Ayo
5012	2331	Calamarca
5013	2331	Collana
5014	2331	Colquencha
5015	2331	Patacamaya
5016	2331	Sica Sica
5017	2331	Umala
5018	2332	Curva
5019	2332	Gral. Juan Jos?? Perez (Charazani)
5020	2333	Escoma
5021	2333	Humanata
5022	2333	Mocomoco
5023	2333	Puerto Acosta
5024	2333	Puerto Carabuco
5025	2334	Alto Beni
5026	2334	Caranavi
5027	2335	Apolo
5028	2335	Pelechuco
5029	2336	Catacora
5030	2336	Santiago de Machaca
5031	2337	Chacarilla
5032	2337	Papel Pampa
5033	2337	San Pedro de Curahuara
5034	2338	Desaguadero
5035	2338	Guaqui
5036	2338	Jes??s de Machaca
5037	2338	San Andr??s de Machaca
5038	2338	Taraco
5039	2338	Tiahuanacu
5040	2338	Viacha
5041	2339	Cajuata
5042	2339	Colquiri
5043	2339	Ichoca
5044	2339	Inquisivi
5045	2339	Licoma Pampa
5046	2339	Quime
5047	2340	Combaya
5048	2340	Guanay
5049	2340	Mapiri
5050	2340	Quiabaya
5051	2340	Sorata
5052	2340	Tacacoma
5053	2340	Teoponte
5054	2340	Tipuani
5055	2341	Cairoma
5056	2341	Luribay
5057	2341	Malla
5058	2341	Sapahaqui
5059	2341	Yaco
5060	2342	Batallas
5061	2342	Laja
5062	2342	Pucarani
5063	2342	Puerto P??rez
5064	2343	Copacabana
5065	2343	San Pedro de Tiquina
5066	2343	Tito Yupanqui
5067	2344	Aucapata
5068	2344	Ayata
5069	2344	Chuma
5070	2345	Achocalla
5071	2345	El Alto
5072	2345	La Paz
5073	2345	Mecapaca
5074	2345	Palca
5075	2346	Coripata
5076	2346	Coroico
5077	2347	Achacachi
5078	2347	Ancoraimes
5079	2347	Chua Cocani
5080	2347	Huarina
5081	2347	Huatajata
5082	2347	Santiago de Huata
5083	2348	Calacoto
5084	2348	Caquiaviri
5085	2348	Chara??a
5086	2348	Comanche
5087	2348	Coro Coro
5088	2348	Nazacara de Pacajes
5089	2348	Santiago de Callapa
5090	2348	Waldo Ballivi??n
5091	2349	Chulumani
5092	2349	Irupana
5093	2349	La Asunta
5094	2349	Palos Blancos
5095	2349	Yanacachi
5096	2350	Challapata
5097	2350	Santuario de Quillacas
5098	2351	Choquecota
5099	2351	Corque
5100	2351	Caracollo
5101	2351	El Choro
5102	2351	Oruro
5103	2351	Soracachi (Paria)
5104	2352	Pampa Aullagas
5105	2352	Salinas de Garci Mendoza
5106	2353	Cruz de Machacamarca
5107	2353	Escara
5108	2353	Esmeralda
5109	2353	Huachacalla
5110	2353	Yunguyo del Litoral
5111	2354	Carangas
5112	2354	La Rivera
5113	2354	Todos Santos
5114	2355	Santiago de Huayllamarca
5115	2356	Machacamarca
5116	2356	Villa Huanuni
5117	2357	Antequera
5118	2357	Paz??a
5119	2357	Villa Poop??
5120	2359	Chipaya
5121	2359	Coipasa
5122	2359	Sabaya
5123	2360	Curahuara de Carangas
5124	2360	Turco
5125	2361	Toledo
5126	2362	Santiago de Huari
5127	2363	Andamarca
5128	2363	Bel??n de Andamarca
5129	2364	Eucaliptus
5130	2365	Humaita (Ingavi)
5131	2365	Santa Rosa del Abun??
5132	2366	Nueva Esperanza
5133	2366	Santos Mercado (Reserva)
5134	2366	Villa Nueva (Loma Alta)
5135	2367	Blanca Flor (San Lorenzo)
5136	2367	El Sena
5137	2367	Puerto Gonzalo Moreno
5138	2368	Filadelfia
5139	2368	Puerto Rico
5140	2368	San Pedro
5141	2369	Bella Flor
5142	2369	Bolpebra
5143	2369	Cobija
5144	2369	Porvenir
5145	2370	Caripuyo
5146	2370	Sacaca
5147	2371	Porco
5148	2371	Tomave
5149	2371	Uyuni
5150	2372	San Pedro de Buena Vista
5151	2372	Toro Toro
5152	2373	Colquechaca
5153	2373	Ocur??
5154	2373	Pocoata
5155	2373	Ravelo
5156	2374	Betanzos
5157	2374	Chaqu??
5158	2374	Tacobamba
5159	2375	Llica
5160	2375	Tahua
5161	2376	San Agust??n
5162	2377	Acasio
5163	2377	Arampampa
5164	2378	Caiza "D"
5165	2378	Ckochas
5166	2378	Puna
5167	2379	Villaz??n
5168	2380	Cotagaita
5169	2380	Vitichi
5170	2381	Colcha "K"
5171	2381	San Pedro de Quemes
5172	2382	Chayanta
5173	2382	Chuquihuta Ayllu Jucumani
5174	2382	Llallagua
5175	2382	Unc??a
5176	2383	Atocha
5177	2383	Tupiza
5178	2384	Mojinete
5179	2384	San Antonio de Esmoruco
5180	2384	San Pablo de Lipez
5181	2385	Bel??n de Urmiri
5182	2385	Potos??
5183	2385	Tinguipaya
5184	2385	Villa de Yocalla
5185	2386	Cotoca
5186	2386	El Torno
5187	2386	La Guardia
5188	2386	Porongo (Ayacucho)
5189	2386	Santa Cruz de la Sierra
5190	2387	San Mat??as
5191	2388	Comarapa
5192	2388	Saipina
5193	2389	Pail??n
5194	2389	Robor??
5195	2389	San Jos??
5196	2390	Boyuibe
5197	2390	Cabezas
5198	2390	Camiri
5199	2390	Charagua
5200	2390	Cuevo
5201	2390	Guti??rrez
5202	2390	Lagunillas
5203	2391	Mairana
5204	2391	Pampa Grande
5205	2391	Quirusillas
5206	2391	Samaipata
5207	2392	Carmen Rivero Torres
5208	2392	Puerto Quijarro
5209	2392	Puerto Su??rez
5210	2393	Ascenci??n de Guarayos
5211	2393	El Puente
5212	2393	Urubich??
5213	2394	Buena Vista
5214	2394	San Carlos
5215	2394	San Juan
5216	2394	Yapacan??
5217	2395	Concepci??n
5218	2395	Cuatro Ca??adas
5219	2395	San Antonio de Lomer??o
5220	2395	San Juli??n
5221	2396	Gral. Saavedra
5222	2396	Mineros
5223	2396	Montero
5224	2396	Puerto Fern??ndez Alonso
5225	2397	Colpa B??lgica
5226	2397	Portachuelo
5227	2397	Santa Rosa del Sara
5228	2398	El Trigal
5229	2398	Moro Moro
5230	2398	Postrervalle
5231	2398	Pucar??
5232	2398	Vallegrande
5233	2399	San Miguel
5234	2399	San Rafael
5235	2400	Okinawa
5236	2400	Warnes
5237	2401	Bermejo
5238	2401	Padcaya
5239	2402	Uriondo (Concepci??n)
5240	2402	Yunchar??
5241	2403	Entre R??os
5242	2403	Tarija
5243	2404	Carapar??
5244	2404	Villamontes
5245	2404	Yacuiba
5246	2406	Almirante
5247	2406	Bajo Culubre
5248	2406	Barriada Guaym??
5249	2406	Barrio Franc??s
5250	2406	Cauchero
5251	2406	Ceiba
5252	2406	Miraflores
5253	2406	Nance de Risc??
5254	2406	Valle de Aguas Arriba
5255	2406	Valle de Risc??
5256	2407	Bastimentos
5257	2407	Bocas del Toro
5258	2407	Boca del Drago
5259	2407	Punta Laurel
5260	2407	Tierra Oscura
5261	2407	San Crist??bal
5262	2408	Barriada 4 de Abril
5263	2408	Barranco Adentro
5264	2408	Changuinola
5265	2408	Cochigro
5266	2408	El Empalme
5267	2408	El Silencio
5268	2408	Finca 4
5269	2408	Finca 6
5270	2408	Finca 12
5271	2408	Finca 30
5272	2408	Finca 51
5273	2408	Finca 60
5274	2408	Finca 66
5275	2408	Guabito
5276	2408	La Gloria
5277	2408	La Mesa
5278	2408	Las Delicias
5279	2408	Las Tablas
5280	2409	Bajo Cedro
5281	2409	Chiriqu?? Grande
5282	2409	Miramar
5283	2409	Punta Pe??a
5284	2409	Punta Robalo
5285	2409	Rambala
5286	2410	Alanje
5287	2410	Dival??
5288	2410	Canta Gallo
5289	2410	El Tejar
5290	2410	Guarumal
5291	2410	Nuevo M??xico
5292	2410	Quer??valo
5293	2410	Palo Grande
5294	2410	Santo Tom??s
5295	2411	Baco
5296	2411	Limones
5297	2411	Progreso
5298	2411	Puerto Armuelles
5299	2411	Rodolfo Aguilar Delgado
5300	2411	El Palmar
5301	2411	Manaca
5302	2412	B??gala
5303	2412	Boquer??n
5304	2412	Cordillera
5305	2412	Guabal
5306	2412	Guayabal
5307	2412	Para??so
5308	2412	Pedregal
5309	2412	Tijeras
5310	2413	Alto Boquete
5311	2413	Bajo Boquete
5312	2413	Caldera
5313	2413	Jaramillo
5314	2413	Los Naranjos
5315	2413	Palmira
5316	2414	Aserr??o de Garich??
5317	2414	Bugaba
5318	2414	El Bongo
5319	2414	G??mez
5320	2414	La Concepci??n
5321	2414	La Estrella
5322	2414	San Andr??s
5323	2414	Santa Marta
5324	2414	Santa Rosa
5325	2414	Santo Domingo
5326	2414	Sortov??
5327	2414	Solano
5328	2414	San Isidro
5329	2415	Bijagual
5330	2415	Cochea
5331	2415	Chiriqu??
5332	2415	Guac??
5333	2415	Las Lomas
5334	2415	San Carlos
5335	2415	David
5336	2415	David Este
5337	2415	David Sur
5338	2415	San Pablo Nuevo
5339	2415	San Pablo Viejo
5340	2416	Dolega
5341	2416	Dos R??os
5342	2416	Los Algarrobos
5343	2416	Los Anastacios
5344	2416	Potrerillos
5345	2416	Potrerillos Abajo
5346	2416	Rovira
5347	2416	Tinajas
5348	2417	Gualaca
5349	2417	Hornito
5350	2417	Los Angeles
5351	2417	Paja de Sombrero
5352	2417	Rinc??n
5353	2418	El Nancito
5354	2418	El Porvenir
5355	2418	El Puerto
5356	2418	Remedios
5357	2418	Santa Luc??a
5358	2419	Bre????n
5359	2419	Ca??as Gordas
5360	2419	Dominical
5361	2419	Monte Lirio
5362	2419	Plaza de Cais??n
5363	2419	R??o Sereno
5364	2419	Santa Cruz
5365	2419	Santa Clara
5366	2420	Las Lajas
5367	2420	Lajas Adentro
5368	2420	Juay
5369	2420	San F??lix
5370	2421	Boca Chica
5371	2421	Boca del Monte
5372	2421	Horconcitos
5373	2421	San Juan
5374	2421	San Lorenzo
5375	2422	Volc??n
5376	2422	Cerro Punta
5377	2422	Cuesta de Piedra
5378	2422	Nueva California
5379	2422	Paso Ancho
5380	2423	Bella Vista
5381	2423	Cerro Viejo
5382	2423	El Cristo
5383	2423	Justo Fidel Palacios
5384	2423	Lajas de Tol??
5385	2423	Potrero de Ca??a
5386	2423	Quebrada de Piedra
5387	2423	Tol??
5388	2423	Veladero
5389	2424	Aguadulce
5390	2424	Barrios Unidos
5391	2424	El Roble
5392	2424	El Hato de San Juan de Dios
5393	2424	Pocr??
5394	2424	Pueblos Unidos
5395	2424	Virgen del Carmen
5396	2425	Ant??n
5397	2425	Caballero
5398	2425	Cabuya
5399	2425	El Chir??
5400	2425	El Retiro
5401	2425	El Valle
5402	2425	Juan D??az
5403	2425	R??o Hato
5404	2425	San Juan de Dios
5405	2425	Santa Rita
5406	2426	El Harino
5407	2426	El Potrero
5408	2426	La Pintada
5409	2426	Llano Grande
5410	2426	Piedras Gordas
5411	2426	Llano Norte
5412	2427	Capellan??a
5413	2427	El Ca??o
5414	2427	Guzm??n
5415	2427	Las Huacas
5416	2427	Nat??
5417	2427	Toza
5418	2427	Villarreal
5419	2428	El Cop??
5420	2428	El Picacho
5421	2428	La Pava
5422	2428	Ol??
5423	2429	Ca??averal
5424	2429	Cocl??
5425	2429	Chiguir?? Arriba
5426	2429	El Coco
5427	2429	Pajonal
5428	2429	Penonom??
5429	2429	R??o Grande
5430	2429	R??o Indio
5431	2429	Toabr??
5432	2429	Tul??
5433	2430	Barrio Norte
5434	2430	Barrio Sur
5435	2430	Buena Vista
5436	2430	Cativ??
5437	2430	Ciricito
5438	2430	Crist??bal
5439	2430	Crist??bal Este
5440	2430	Escobal
5441	2430	Lim??n
5442	2430	Nueva Providencia
5443	2430	Puerto Pil??n
5444	2430	Sabanitas
5445	2430	Salamanca
5446	2431	Achiote
5447	2431	El Guabo
5448	2431	La Encantada
5449	2431	Nuevo Chagres
5450	2431	Palmas Bellas
5451	2431	Pi??a
5452	2431	Salud
5453	2432	Cocl?? del Norte
5454	2432	El Gu??simo
5455	2432	Gobea
5456	2432	Miguel de la Borda
5457	2433	Cacique
5458	2433	Garrote
5459	2433	Isla Grande
5460	2433	Mar??a Chiquita
5461	2433	Portobelo
5462	2434	Cuango
5463	2434	Nombre de Dios
5464	2434	Palenque
5465	2434	Playa Chiquita
5466	2434	Santa Isabel
5467	2434	Viento Fr??o
5468	2435	San Jos?? del General
5469	2435	San Juan de Turbe
5470	2435	Nueva Esperanza
5471	2436	Camogant??
5472	2436	Chepigana
5473	2436	Garachin??
5474	2436	Jaqu??
5475	2436	La Palma
5476	2436	Puerto Pi??a
5477	2436	Samb??
5478	2436	Setegant??
5479	2436	Taimat??
5480	2436	Tucut??
5481	2437	Boca de Cupe
5482	2437	El Real de Santa Mar??a
5483	2437	Metet??
5484	2437	Paya
5485	2437	Pinogana
5486	2437	P??curo
5487	2437	Yape
5488	2437	Yaviza
5489	2437	Wargand??
5490	2438	Agua Fr??a
5491	2438	Cucunat??
5492	2438	R??o Congo
5493	2438	R??o Congo Arriba
5494	2438	R??o Iglesias
5495	2438	Santa Fe
5496	2438	Zapallal
5497	2439	Chitr??
5498	2439	La Arena
5499	2439	Llano Bonito
5500	2439	San Juan Bautista
5501	2439	Monagrillo
5502	2440	Chepo
5503	2440	Chumical
5504	2440	El Toro
5505	2440	Las Minas
5506	2440	Leones
5507	2440	Quebrada del Rosario
5508	2440	Quebrada El Cipri??n
5509	2441	El Capur??
5510	2441	El Calabacito
5511	2441	El Cedro
5512	2441	La Pitaloza
5513	2441	Las Llanas
5514	2441	Los Cerritos
5515	2441	Los Cerros de Paja
5516	2441	Los Pozos
5517	2442	Cerro Largo
5518	2442	El Tijera
5519	2442	Entradero del Castillo
5520	2442	Los Llanos
5521	2442	Menchaca
5522	2442	Pe??as Chatas
5523	2442	Oc??
5524	2443	Los Castillos
5525	2443	Llano de la Cruz
5526	2443	Par??s
5527	2443	Parita
5528	2443	Portobelillo
5529	2443	Potuga
5530	2444	El Barrero
5531	2444	El Pedregoso
5532	2444	El Ciruelo
5533	2444	El P??jaro
5534	2444	Las Cabras
5535	2444	Pes??
5536	2444	Rinc??n Hondo
5537	2444	Sabanagrande
5538	2445	Chupampa
5539	2445	El Rinc??n
5540	2445	El Lim??n
5541	2445	Los Canelos
5542	2445	Santa Mar??a
5543	2446	El Espinal
5544	2446	El Hato
5545	2446	El Macano
5546	2446	Guarar??
5547	2446	Guarar?? Arriba
5548	2446	La Enea
5549	2446	La Pasera
5550	2446	Las Trancas
5551	2446	Llano Abajo
5552	2446	Perales
5553	2447	Bajo Corral
5554	2447	Bayano
5555	2447	El Carate
5556	2447	El Cocal
5557	2447	El Manantial
5558	2447	El Mu??oz
5559	2447	El Sesteadero
5560	2447	La Laja
5561	2447	La Miel
5562	2447	La Tiza
5563	2447	Las Palmitas
5564	2447	Las Tablas Abajo
5565	2447	Nuario
5566	2447	Pe??a Blanca
5567	2447	R??o Hondo
5568	2447	San Jos??
5569	2447	San Miguel
5570	2447	Valle Rico
5571	2447	Vallerriquito
5572	2448	El Ejido
5573	2448	La Colorada
5574	2448	La Espigadilla
5575	2448	La Villa de Los Santos
5576	2448	Las Cruces
5577	2448	Las Guabas
5578	2448	Los ??ngeles
5579	2448	Los Olivos
5580	2448	Llano Largo
5581	2448	Santa Ana
5582	2448	Tres Quebradas
5583	2448	Villa Lourdes
5584	2448	Agua Buena
5585	2449	Bah??a Honda
5586	2449	Bajos de G??era
5587	2449	Corozal
5588	2449	Chup??
5589	2449	Espino Amarillo
5590	2449	Las Palmas
5591	2449	Llano de Piedras
5592	2449	Macaracas
5593	2449	Mogoll??n
5594	2450	Los Asientos
5595	2450	Mariab??
5596	2450	Oria Arriba
5597	2450	Pedas??
5598	2450	Purio
5599	2451	El Ca??af??stulo
5600	2451	Lajamina
5601	2451	Paritilla
5602	2452	Altos de G??era
5603	2452	Cambutal
5604	2452	Ca??as
5605	2452	El Bebedero
5606	2452	El Cacao
5607	2452	El Cortezo
5608	2452	Flores
5609	2452	Gu??nico
5610	2452	Isla de Ca??as
5611	2452	La Tronosa
5612	2452	Tonos??
5613	2453	La Ensenada
5614	2453	La Esmeralda
5615	2453	La Guinea
5616	2453	Pedro Gonz??lez
5617	2453	Saboga
5618	2454	Ca??ita
5619	2454	Chepillo
5620	2454	El Llano
5621	2454	Las Margaritas
5622	2454	Santa Cruz de Chinina
5623	2454	Tort??
5624	2454	Madugand??
5625	2455	Brujas
5626	2455	Chim??n
5627	2455	Gonzalo V??squez
5628	2455	P??siga
5629	2455	Uni??n Sante??a
5630	2456	24 de Diciembre
5631	2456	Alcalde D??az
5632	2456	Anc??n
5633	2456	Betania
5634	2456	Calidonia
5635	2456	Caimitillo
5636	2456	Chilibre
5637	2456	Curund??
5638	2456	Don Bosco
5639	2456	El Chorrillo
5640	2456	Ernesto C??rdoba Campos
5641	2456	Las Cumbres
5642	2456	Las Garzas
5643	2456	Las Ma??anitas
5644	2456	Pacora
5645	2456	Parque Lefevre
5646	2456	Pueblo Nuevo
5647	2456	R??o Abajo
5648	2456	San Felipe
5649	2456	San Francisco
5650	2456	San Mart??n
5651	2456	Tocumen
5652	2457	Amelia Denis de Icaza
5653	2457	Arnulfo Arias
5654	2457	Belisario Fr??as
5655	2457	Belisario Porras
5656	2457	Jos?? Domingo Espinar
5657	2457	Mateo Iturralde
5658	2457	Omar Torrijos
5659	2457	Rufina Alfaro
5660	2457	Victoriano Lorenzo
5661	2458	Otoque Occidente
5662	2458	Otoque Oriente
5663	2458	Taboga
5664	2459	Arraij??n
5665	2459	Burunga
5666	2459	Cerro Silvestre
5667	2459	Juan Dem??stenes Arosemena
5668	2459	Nuevo Emperador
5669	2459	Veracruz
5670	2459	Vista Alegre
5671	2460	Caimito
5672	2460	Campana
5673	2460	Capira
5674	2460	Cerme??o
5675	2460	Cir?? de Los Sotos
5676	2460	Cir?? Grande
5677	2460	La Trinidad
5678	2460	Las Ollas Arriba
5679	2460	L??dice
5680	2460	Villa Carmen
5681	2460	Villa Rosario
5682	2461	Bejuco
5683	2461	Buenos Aires
5684	2461	Chame
5685	2461	Chic??
5686	2461	El L??bano
5687	2461	Nueva Gorgona
5688	2461	Punta Chame
5689	2461	Sajalices
5690	2461	Sor??
5691	2462	Amador
5692	2462	Arosemena
5693	2462	Barrio Balboa
5694	2462	Barrio Col??n
5695	2462	El Arado
5696	2462	Feuillet
5697	2462	Guadalupe
5698	2462	Herrera
5699	2462	Hurtado
5700	2462	Iturralde
5701	2462	La Represa
5702	2462	Los D??az
5703	2462	Mendoza
5704	2462	Obald??a
5705	2462	Playa Leona
5706	2462	Puerto Caimito
5707	2463	El Espino
5708	2463	El Higo
5709	2463	Guayabito
5710	2463	La Ermita
5711	2463	La Laguna
5712	2463	Las Uvas
5713	2463	Los Llanitos
5714	2464	Atalaya
5715	2464	El Barrito
5716	2464	La Carrillo
5717	2464	La Monta??uela
5718	2464	San Antonio
5719	2465	Barnizal
5720	2465	Calobre
5721	2465	Chitra
5722	2465	El Cocla
5723	2465	La Raya de Calobre
5724	2465	La Tetilla
5725	2465	La Yeguada
5726	2465	Las Gu??as
5727	2465	Monjar??s
5728	2466	Ca??azas
5729	2466	Cerro de Plata
5730	2466	El Aromillo
5731	2466	El Picador
5732	2466	Los Valles
5733	2466	San Marcelo
5734	2467	Bisvalles
5735	2467	Bor??
5736	2467	Los Milagros
5737	2467	San Bartolo
5738	2468	Cerro de Casa
5739	2468	El Mar??a
5740	2468	El Prado
5741	2468	Lol??
5742	2468	Manuel E. Amador Terrero
5743	2468	Pixvae
5744	2468	Puerto Vidal
5745	2468	San Mart??n de Porres
5746	2468	Vigu??
5747	2468	Zapotillo
5748	2469	Arenas
5749	2469	Mariato
5750	2469	Quebro
5751	2469	Tebario
5752	2470	C??baco
5753	2470	Costa Hermosa
5754	2470	Gobernadora
5755	2470	La Garceana
5756	2470	Montijo
5757	2470	Pil??n
5758	2470	Uni??n del Norte
5759	2471	Catorce de Noviembre
5760	2471	R??o de Jes??s
5761	2471	Utira
5762	2472	Corral Falso
5763	2472	Los Hatillos
5764	2472	Remance
5765	2472	Calov??bora
5766	2472	El Alto
5767	2472	El Cuay
5768	2472	El Pantano
5769	2472	Gatuncito
5770	2472	R??o Luis
5771	2472	Rub??n Cant??
5772	2473	Canto del Llano
5773	2473	Carlos Santana ??vila
5774	2473	Edwin F??brega
5775	2473	La Pe??a
5776	2473	La Raya de Santa Mar??a
5777	2473	Nuevo Santiago
5778	2473	Ponuga
5779	2473	San Pedro del Espino
5780	2473	Santiago
5781	2473	Santiago Este
5782	2473	Santiago Sur
5783	2473	Rodrigo Luque
5784	2473	Urrac??
5785	2474	Cativ??
5786	2474	El Mara????n
5787	2474	Hicaco
5788	2474	La Soledad
5789	2474	La Trinchera
5790	2474	Quebrada de Oro
5791	2474	Rodeo Viejo
5792	2474	Son??
5793	2475	Cirilo Guaynora
5794	2475	Lajas Blancas
5795	2475	Manuel Ortega
5796	2476	Jingurud??
5797	2476	R??o Sabalo
5798	2477	Ailigand??
5799	2477	Nargan??
5800	2477	Puerto Obald??a
5801	2477	Tubual??
5802	2478	Bonyik
5803	2478	San San Drui
5804	2478	El Teribe
5805	2479	Boca de Balsa
5806	2479	Cerro Banco
5807	2479	Cerro Patena
5808	2479	Camar??n Arriba
5809	2479	Emplanada de Chorcha
5810	2479	N??mnon??
5811	2479	Niba
5812	2479	Soloy
5813	2480	Bisira
5814	2480	Calante
5815	2480	Kankint??
5816	2480	Guoron??
5817	2480	M??n??n??
5818	2480	Piedra Roja
5819	2480	Tolote
5820	2481	Bah??a Azul
5821	2481	Kusap??n
5822	2481	R??o Chiriqu??
5823	2481	Tobob??
5824	2482	Cascabel
5825	2482	Hato Corot??
5826	2482	Hato Culantro
5827	2482	Hato Pil??n
5828	2482	Hato Jobo
5829	2482	Hato Jul??
5830	2482	Quebrada de Loro
5831	2482	Salto Dup??
5832	2483	Alto Caballero
5833	2483	Bakama
5834	2483	Cerro Ca??a
5835	2483	Cerro Puerco
5836	2483	Chichica
5837	2483	Kr??a
5838	2483	Maraca
5839	2483	Nibra
5840	2483	Roka
5841	2483	Sitio Prado
5842	2483	Uman??
5843	2483	Diko
5844	2483	Kikari
5845	2483	Dikeri
5846	2483	Mreeni
5847	2484	Cerro Iglesias
5848	2484	Hato Cham??
5849	2484	J??deberi
5850	2484	Lajero
5851	2484	Susama
5852	2485	Agua de Salud
5853	2485	Alto de Jes??s
5854	2485	Cerro Pelado
5855	2485	El Bale
5856	2485	El Pared??n
5857	2485	El Piro
5858	2485	G??ibale
5859	2485	El Pe????n
5860	2485	El Piro N??2
5861	2486	Bur??
5862	2486	Guariviara
5863	2486	Man Creek
5864	2486	Samboa
5865	2486	Tuwai
5866	2487	Alto Biling??e
5867	2487	Loma Yuca
5868	2487	San Pedrito
5869	2487	Valle Bonito
5870	5559	Carhu??
5871	5559	Colonia San Miguel Arc??ngel
5872	5559	Delf??n Huergo
5873	5559	Espartillar
5874	5559	Esteban Agust??n Gasc??n
5875	5559	La Pala
5876	5559	Maza
5877	5559	Rivera
5878	5559	Yutuyaco
5879	5560	Adolfo Gonzales Chaves??(Est. Chaves)
5880	5560	De la Garma
5881	5560	Juan E. Barra
5882	5560	V??squez
5883	5561	Alberti??(Est. Andr??s Vaccarezza)
5884	5561	Coronel Segu??
5885	5561	Mechita
5886	5561	Pla
5887	5561	Villa Grisol??a??(Est. Achupallas)
5888	5561	Villa Mar??a
5889	5561	Villa Ortiz??(Est. Coronel Mom)
5890	5562	Almirante Brown??(Adrogu??)
5891	5563	Arrecifes
5892	5563	Todd
5893	5563	Vi??a
5894	5564	Avellaneda
5895	5565	Ayacucho
5896	5565	La Constancia
5897	5565	Solanet
5898	5565	Udaquiola
5899	5566	16 de Julio
5900	5566	Ariel
5901	5566	Azul
5902	5566	Cachar??
5903	5566	Chillar
5904	5567	Bah??a Blanca
5905	5567	Cabildo
5906	5567	General Daniel Cerri??(Est. General Cerri)
5907	5568	Balcarce
5908	5568	Los Pinos
5909	5568	Napaleof??
5910	5568	Ramos Otero
5911	5568	San Agust??n
5912	5568	Villa Laguna La Brava
5913	5569	Baradero
5914	5569	Irineo Portela
5915	5569	Santa Coloma
5916	5569	Villa Alsina??(Est. Alsina)
5917	5570	Barker
5918	5570	Benito Ju??rez??(Est. Ju??rez)
5919	5570	L??pez
5920	5570	Ted??n Uriburu
5921	5570	Villa Cacique??(Est. Alfredo Fortabat)
5922	5571	Berazategui
5923	5572	Berisso
5924	5573	Hale
5925	5573	Juan F. Ibarra
5926	5573	Paula
5927	5573	Pirovano
5928	5573	San Carlos de Bol??var??(Est. Bol??var)
5929	5573	Urdampilleta
5930	5573	Villa Lynch Pueyrred??n
5931	5574	Asamblea
5932	5574	Bragado
5933	5574	Comodoro Py
5934	5574	General O'Brien
5935	5574	Irala
5936	5574	La Limpia
5937	5574	M??ximo Fern??ndez??(Est. Juan F. Salaberry)
5938	5574	Mechita??(Est. Mecha)
5939	5574	Olascoaga
5940	5574	Warnes
5941	5575	Altamirano
5942	5575	Barrio El Mirador
5943	5575	Barrio Las Golondrinas
5944	5575	Barrio Los Bosquecitos
5945	5575	Barrio Parque Las Acacias
5946	5575	Campos de Roca
5947	5575	Club de Campo las Malvinas
5948	5575	Coronel Brandsen
5949	5575	G??mez
5950	5575	Jeppener
5951	5575	Oliden
5952	5575	Posada de Los Lagos
5953	5575	Samboromb??n
5954	5576	Comuna 1
5955	5576	Comuna 10
5956	5576	Comuna 11
5957	5576	Comuna 12
5958	5576	Comuna 13
5959	5576	Comuna 14
5960	5576	Comuna 15
5961	5576	Comuna 2
5962	5576	Comuna 3
5963	5576	Comuna 4
5964	5576	Comuna 5
5965	5576	Comuna 6
5966	5576	Comuna 7
5967	5576	Comuna 8
5968	5576	Comuna 9
5969	5577	Barrio Los Pioneros??(Barrio Tavella)
5970	5577	Campana
5971	5577	Chacras del R??o Luj??n
5972	5577	Lomas del R??o Luj??n??(Est. R??o Luj??n)
5973	5577	Los Cardales
5974	5578	Alejandro Peti??n
5975	5578	Barrio El Taladro
5976	5578	Ca??uelas
5977	5578	Gobernador Udaondo
5978	5578	M??ximo Paz??(- Barrio Belgrano)
5979	5578	Santa Rosa
5980	5578	Uribelarrea
5981	5578	Vicente Casares
5982	5579	Capit??n Sarmiento
5983	5579	La Luisa
5984	5580	Bellocq
5985	5580	Cadret
5986	5580	Carlos Casares
5987	5580	Colonia Mauricio
5988	5580	Hortensia
5989	5580	La Sof??a
5990	5580	Mauricio Hirsch
5991	5580	Moctezuma
5992	5580	Ordoqui
5993	5580	Santo Tomas
5994	5580	Smith
5995	5581	Carlos Tejedor
5996	5581	Colonia Ser??
5997	5581	Curar??
5998	5581	Timote
5999	5581	Tres Algarrobos??(Est. Cuenca)
6000	5582	Carmen de Areco
6001	5582	Pueblo Gouin
6002	5582	Tres Sargentos
6003	5583	Castelli
6004	5583	Centro Guerrero
6005	5583	Cerro de la Gloria
6006	5584	Castilla
6007	5584	Chacabuco
6008	5584	Los ??ngeles
6009	5584	O'Higgins
6010	5584	Rawson
6011	5585	Barrio Lomas Altas
6012	5585	Chascom??s
6013	5585	Laguna Vitel
6014	5585	Manuel J. Cobo??(Est. Lezama)
6015	5585	Villa Parque Girado
6016	5586	Benitez
6017	5586	Chivilcoy
6018	5586	Emilio Ayarza
6019	5586	Gorostiaga
6020	5586	La Rica
6021	5586	Moquehu??
6022	5586	Ram??n Biaus
6023	5586	San Sebasti??n
6024	5587	Col??n
6025	5587	Pearson
6026	5587	Sarasa
6027	5587	Villa Manuel Pomar??(El Arbolito)
6028	5588	Bajo Hondo
6029	5588	Balneario Pehuen-C??
6030	5588	Pago Chico??(Villa del Mar)
6031	5588	Punta Alta??(Est. Almirante Solier)
6032	5588	Villa General Arias??(Est. Kil??metro 638)
6033	5589	Aparicio
6034	5589	Coronel Dorrego
6035	5589	El Perdido??(Est. Jos?? A. Guisasola)
6036	5589	Faro
6037	5589	Irene
6038	5589	Marisol
6039	5589	Oriente
6040	5589	Paraje la Ruta
6041	5589	San Rom??n
6042	5590	Coronel Pringles??(Est. Pringles)
6043	5590	El Divisorio
6044	5590	El Pensamiento
6045	5590	Indio Rico
6046	5590	Lartigau
6047	5591	Cascadas
6048	5591	Coronel Su??rez
6049	5591	Cura Malal
6050	5591	D'Orbigny
6051	5591	Huanguel??n
6052	5591	Pasman
6053	5591	San Jos??
6054	5591	Santa Mar??a
6055	5591	Santa Trinidad
6056	5591	Villa La Arcadia
6057	5592	Andant
6058	5592	Arboledas
6059	5592	Daireaux
6060	5592	La Larga
6061	5592	Salazar
6062	5593	Dolores
6063	5593	Sevigne
6064	5594	Ensenada
6065	5595	Escobar??(Bel??n de Escobar)
6066	5596	Esteban Echeverr??a??(Monte Grande)
6067	5597	Arroyo de la Cruz
6068	5597	Capilla del Se??or??(Est. Capilla)
6069	5597	Diego Gaynor
6070	5597	Parada Orlando
6071	5597	Parada Robles??(- Pav??n)
6072	5598	Ezeiza
6073	5599	Florencio Varela
6074	5600	Blaquier
6075	5600	Florentino Ameghino
6076	5600	Porvenir
6077	5601	Centinela del Mar
6078	5601	Comandante Nicanor Otamendi
6079	5601	Mar del Sur
6080	5601	Mechongu??
6081	5601	Miramar
6082	5602	General Alvear
6083	5603	Arribe??os
6084	5603	Ascensi??n
6085	5603	Estaci??n Arenales
6086	5603	Ferr??
6087	5603	General Arenales
6088	5603	La Angelita
6089	5603	La Trinidad
6090	5604	General Belgrano
6091	5604	Gorchs
6092	5605	General Guido
6093	5605	Labard??n
6094	5606	General Juan Madariaga
6095	5607	General La Madrid
6096	5607	La Colina
6097	5607	Las Martinetas
6098	5607	L??bano
6099	5607	Pontaut
6100	5608	General Hornos
6101	5608	General Las Heras??(Est. Las Heras)
6102	5608	La Choza
6103	5608	Plomer
6104	5608	Villars
6105	5609	General Lavalle
6106	5609	Pav??n
6107	5610	Barrio R??o Salado
6108	5610	Loma Verde
6109	5610	Ranchos
6110	5610	Villanueva??(Ap. R??o Salado)
6111	5611	Colonia San Ricardo??(Est. Iriarte)
6112	5611	General Pinto
6113	5611	Germania??(Est. Mayor Jos?? Orellano)
6114	5611	Gunther
6115	5611	Villa Francia??(Est. Coronel Granada)
6116	5611	Villa Roth??(Est. Ingeniero Balb??n)
6117	5612	Barrio El Boquer??n
6118	5612	Barrio La Gloria
6119	5612	Barrio Santa Paula
6120	5612	Bat??n
6121	5612	Chapadmalal
6122	5612	El Marquesado
6123	5612	Estaci??n Chapadmalal
6124	5612	Mar del Plata
6125	5612	Sierra de los Padres
6126	5613	General Rodr??guez
6127	5614	General San Mart??n
6128	5615	Baigorrita
6129	5615	La Delfina
6130	5615	Los Toldos
6131	5615	San Emilio
6132	5615	Zaval??a
6133	5616	Banderal??
6134	5616	Ca??ada Seca
6135	5616	Coronel Charlone
6136	5616	Emilio V. Bunge
6137	5616	General Villegas??(Est. Villegas)
6138	5616	Massey??(Est. Elordi)
6139	5616	Pichincha
6140	5616	Piedritas
6141	5616	Santa Eleodora
6142	5616	Santa Regina
6143	5616	Villa Saboya
6144	5616	Villa Sauze
6145	5617	Arroyo Venado
6146	5617	Casbas
6147	5617	Garr??
6148	5617	Guamin??
6149	5617	Laguna Alsina??(Est. Bonifacio)
6150	5618	Henderson
6151	5618	Herrera Vegas
6152	5619	Hurlingham
6153	5620	Ituzaing??
6154	5621	Jos?? C. Paz
6155	5622	Agust??n Roca
6156	5622	Agustina
6157	5622	Balneario Laguna de G??mez
6158	5622	Fort??n Tiburcio
6159	5622	Jun??n
6160	5622	Laplacette
6161	5622	Morse
6162	5622	Paraje La Agraria
6163	5622	Saforcada
6164	5623	Las Toninas
6165	5623	Mar de Aj????(- San Bernardo)
6166	5623	San Clemente del Tuy??
6167	5623	Santa Teresita??(- Mar del Tuy??)
6168	5624	La Matanza??(San Justo)
6169	5625	Country Club El Rodeo
6170	5625	Ignacio Correas
6171	5625	La Plata
6172	5625	Lomas de Copello
6173	5625	Ruta Sol??(incl. Barrio El Peligro)
6174	5626	Lan??s
6175	5627	Laprida
6176	5627	Pueblo Nuevo
6177	5627	Pueblo San Jorge
6178	5628	Coronel Boerr
6179	5628	El Trigo
6180	5628	Las Flores
6181	5628	Pardo
6182	5629	Alberdi Viejo
6183	5629	El Dorado
6184	5629	Fort??n Acha
6185	5629	Juan Bautista Alberdi??(Est. Alberdi)
6186	5629	Leandro N. Alem
6187	5629	Vedia
6188	5630	Arenaza
6189	5630	Bayauca
6190	5630	Berm??dez
6191	5630	Carlos Salas
6192	5630	Coronel Mart??nez de Hoz??(Ap. Kil??metro 322)
6193	5630	El Triunfo
6194	5630	Las Toscas
6195	5630	Lincoln
6196	5630	Pasteur
6197	5630	Roberts
6198	5630	Triunvirato
6199	5631	Arenas Verdes
6200	5631	Licenciado Matienzo
6201	5631	Lober??a
6202	5631	Pieres
6203	5631	San Manuel
6204	5631	Tamanguey??
6205	5632	Antonio Carboni
6206	5632	Elvira
6207	5632	Laguna de Lobos
6208	5632	Lobos
6209	5632	Salvador Mar??a
6210	5633	Lomas de Zamora
6211	5634	Carlos Keen
6212	5634	Club de Campo Los Puentes
6213	5634	Luj??n
6214	5634	Olivera
6215	5634	Torres
6216	5635	Atalaya
6217	5635	General Mansilla??(Est. Bartolom?? Bavio)
6218	5635	Los Naranjos
6219	5635	Magdalena
6220	5635	Roberto J. Payr??
6221	5635	Vieytes
6222	5636	Las Armas
6223	5636	Maip??
6224	5636	Santo Domingo
6225	5637	Malvinas Argentinas??(Los Polvorines)
6226	5638	Coronel Vidal
6227	5638	General Pir??n
6228	5638	La Armon??a
6229	5638	Mar Chiquita
6230	5638	Mar de Cobo
6231	5638	Santa Clara del Mar
6232	5638	Vivorat??
6233	5639	Barrio Santa Rosa
6234	5639	Marcos Paz
6235	5640	Goldney
6236	5640	Gowland
6237	5640	Jorge Born??(Tom??s Jofr??)
6238	5640	Mercedes
6239	5641	Merlo
6240	5642	Abbott
6241	5642	San Miguel del Monte??(Est. Monte)
6242	5642	Zen??n Videla Dorna
6243	5643	Balneario Sauce Grande
6244	5643	Monte Hermoso
6245	5644	Moreno
6246	5645	Mor??n
6247	5646	Jos?? Juan Almeyra
6248	5646	Las Marianas
6249	5646	Navarro
6250	5646	Villa Moll??(Est. Moll)
6251	5647	Claraz
6252	5647	Energia
6253	5647	Juan Nepomuceno Fern??ndez
6254	5647	Necochea??(- Quequ??n)
6255	5647	Nicanor Olivera??(Est. La Dulce)
6256	5647	Ram??n Santamarina
6257	5648	12 de Octubre
6258	5648	9 de Julio??(Nueve de Julio)
6259	5648	Alfredo Demarchi??(Est. Facundo Quiroga)
6260	5648	Carlos Mar??a Na??n
6261	5648	Dudignac
6262	5648	La Aurora??(Est. La Ni??a)
6263	5648	Manuel B. Gonnet??(Est. French)
6264	5648	Marcelino Ugarte??(Est. Dennehy)
6265	5648	Morea
6266	5648	Norumbega
6267	5648	Patricios
6268	5648	Villa Fournier??(Est. 9 de Julio Sud)
6269	5649	Blancagrande
6270	5649	Colonia Nievas
6271	5649	Colonia San Miguel
6272	5649	Espigas
6273	5649	Hinojo
6274	5649	Olavarr??a
6275	5649	Recalde
6276	5649	Santa Luisa
6277	5649	Sierra Chica
6278	5649	Sierras Bayas
6279	5649	Villa Alfredo Fortabat??(Loma Negra)
6280	5649	Villa La Serran??a
6281	5650	Bah??a San Blas
6282	5650	Cardenal Cagliero
6283	5650	Carmen de Patagones
6284	5650	Jos?? B. Casas
6285	5650	Juan A. Pradere
6286	5650	Stroeder
6287	5650	Villalonga
6288	5651	Capit??n Castro
6289	5651	Francisco Madero
6290	5651	Inocencio Sosa
6291	5651	Juan Jos?? Paso
6292	5651	Magdala
6293	5651	Mones Caz??n
6294	5651	Nueva Plata
6295	5651	Pehuaj??
6296	5651	San Bernardo??(Est. Guanaco)
6297	5651	San Esteban??(Chiclana)
6298	5652	Bocayuva
6299	5652	De Bary
6300	5652	Pellegrini
6301	5653	Acevedo
6302	5653	Fontezuela
6303	5653	Guerrico
6304	5653	Juan A. de la Pe??a
6305	5653	Juan Anchorena??(Est. Urquiza)
6306	5653	La Violeta
6307	5653	Manuel Ocampo
6308	5653	Mariano Ben??tez
6309	5653	Mariano H. Alfonzo??(Est. San Patricio)
6310	5653	Pergamino
6311	5653	Pinz??n
6312	5653	Rancagua
6313	5653	Villa Ang??lica??(Est. El Socorro)
6314	5653	Villa San Jos??
6315	5654	Casalins
6316	5654	Pila
6317	5655	Pilar
6318	5656	Pinamar
6319	5657	Presidente Per??n??(Guernica)
6320	5658	17 de Agosto
6321	5658	Azopardo
6322	5658	Bordenave
6323	5658	Darregueira
6324	5658	Estela
6325	5658	Felipe Sol??
6326	5658	L??pez Lecube
6327	5658	Puan
6328	5658	San Germ??n
6329	5658	Villa Castelar??(Est. Erize)
6330	5658	Villa Iris
6331	5659	Alvarez Jonte
6332	5659	Pipinas
6333	5659	Punta Indio
6334	5659	Ver??nica
6335	5660	Quilmes
6336	5661	El Para??so
6337	5661	Las Bahamas
6338	5661	P??rez Mill??n
6339	5661	Ramallo
6340	5661	Villa General Savio??(Est. S??nchez)
6341	5661	Villa Ramallo
6342	5662	Rauch
6343	5663	Am??rica
6344	5663	Fort??n Olavarr??a
6345	5663	Gonz??lez Moreno
6346	5663	Mira Pampa
6347	5663	Roosevelt
6348	5663	San Mauricio
6349	5663	Sansinena
6350	5663	Sundblad
6351	5664	La Beba
6352	5664	Las Carabelas
6353	5664	Los Indios
6354	5664	Rafael Obligado
6355	5664	Roberto Cano
6356	5664	Rojas
6357	5664	Sol de Mayo
6358	5664	Villa Manuel Pomar
6359	5665	Carlos Beguerie
6360	5665	Roque P??rez
6361	5666	Arroyo Corto
6362	5666	Colonia San Mart??n
6363	5666	Dufaur
6364	5666	Goyena
6365	5666	Las Encadenadas
6366	5666	Pig????
6367	5666	Saavedra
6368	5667	??lvarez de Toledo
6369	5667	Caz??n
6370	5667	Del Carril
6371	5667	Polvaredas
6372	5667	Saladillo
6373	5668	Quenum??
6374	5668	Salliquel??
6375	5669	Arroyo Dulce
6376	5669	Berdier
6377	5669	Gahan
6378	5669	In??s Indart
6379	5669	La Invencible
6380	5669	Salto
6381	5670	Azcu??naga
6382	5670	Culull??
6383	5670	Franklin
6384	5670	San Andr??s de Giles
6385	5670	Sol??s
6386	5670	Villa Espil
6387	5670	Villa Ruiz
6388	5671	Duggan
6389	5671	San Antonio de Areco
6390	5671	Villa L??a
6391	5672	Balneario San Cayetano
6392	5672	Ochand??o
6393	5672	San Cayetano
6394	5673	San Fernando
6395	5674	San Isidro
6396	5675	San Miguel
6397	5676	Conesa
6398	5676	Er??zcano
6399	5676	General Rojo
6400	5676	La Emilia
6401	5676	San Nicol??s de los Arroyos
6402	5676	Villa Esperanza
6403	5677	Gobernador Castro
6404	5677	Ingeniero Moneta
6405	5677	Obligado
6406	5677	Pueblo Doyle
6407	5677	R??o Tala
6408	5677	San Pedro
6409	5677	Santa Luc??a
6410	5678	San Vicente
6411	5679	General Rivas
6412	5679	Suipacha
6413	5680	De la Canal
6414	5680	Gardey
6415	5680	Mar??a Ignacia??(Est. Vela)
6416	5680	Tandil
6417	5681	Crotto
6418	5681	Tapalqu??
6419	5681	Velloso
6420	5682	Tigre
6421	5683	General Conesa
6422	5684	Chasic??
6423	5684	La Gruta??(Villa Serrana)
6424	5684	Saldungaray
6425	5684	Sierra de la Ventana
6426	5684	Tornquist
6427	5684	Tres Picos
6428	5684	Villa Ventana
6429	5685	30 de Agosto??(Treinta de Agosto)
6430	5685	Berutti
6431	5685	Girodias
6432	5685	La Carreta
6433	5685	Trenque Lauquen
6434	5685	Trong??
6435	5686	Balneario Orense
6436	5686	Claromec??
6437	5686	Copetonas
6438	5686	Micaela Cascallares??(Est. Cascallares)
6439	5686	Orense
6440	5686	Reta
6441	5686	San Francisco de Bellocq
6442	5686	San Mayol
6443	5686	Tres Arroyos
6444	5686	Villa Rodr??guez??(Est. Barrow)
6445	5687	Tres de Febrero??(Caseros)
6446	5688	Ingeniero Thompson
6447	5688	Tres Lomas
6448	5689	25 de Mayo??(Villa Veinticinco de Mayo)
6449	5689	Agust??n Mosconi
6450	5689	Del Valle
6451	5689	Ernestina
6452	5689	Gobernador Ugarte
6453	5689	Lucas Monteverde
6454	5689	Norberto de la Riestra
6455	5689	Pedernales
6456	5689	San Enrique
6457	5689	Vald??s
6458	5690	Vicente L??pez??(Olivos)
6459	5691	Mar Azul
6460	5691	Villa Gesell
6461	5692	Argerich
6462	5692	Colonia San Adolfo
6463	5692	Country Los Medanos
6464	5692	Hilario Ascasubi
6465	5692	Juan Coust????(Est. Algarrobo)
6466	5692	Mayor Buratovich
6467	5692	M??danos
6468	5692	Pedro Luro
6469	5692	Teniente Origone
6470	5693	Country Club El Casco
6471	5693	Escalada
6472	5693	Lima
6473	5693	Z??rate
6474	5694	Chuchucaruana
6475	5694	Colpes
6476	5694	El Bols??n
6477	5694	El Rodeo
6478	5694	Huaycama
6479	5694	La Puerta
6480	5694	Las Chacritas
6481	5694	Las Juntas
6482	5694	Los Castillos
6483	5694	Los Talas
6484	5694	Los Varela
6485	5694	Singuil
6486	5695	Ancasti
6487	5695	Anquincila
6488	5695	La Candelaria
6489	5695	La Majada
6490	5696	Amanao
6491	5696	Andalgal??
6492	5696	Chaquiago
6493	5696	Choya
6494	5696	El Alamito
6495	5696	El Lindero
6496	5696	El Potrero
6497	5696	La Aguada
6498	5697	Antofagasta de la Sierra
6499	5697	Antofalla
6500	5697	El Pe????n
6501	5697	Los Nacimientos
6502	5698	Barranca Larga
6503	5698	Bel??n
6504	5698	C??ndor Huasi
6505	5698	Corral Quemado
6506	5698	El Durazno
6507	5698	Farall??n Negro
6508	5698	Hualf??n
6509	5698	Jacipunco
6510	5698	La Puntilla
6511	5698	Londres
6512	5698	Puerta de Corral Quemado
6513	5698	Puerta de San Jos??
6514	5698	Villa Vil
6515	5699	Adolfo E. Carranza
6516	5699	Balde de la Punta
6517	5699	Capay??n
6518	5699	Chumbicha
6519	5699	Colonia del Valle
6520	5699	Colonia Nueva Coneta
6521	5699	Concepci??n
6522	5699	Coneta
6523	5699	El Ba??ado
6524	5699	Huillapima
6525	5699	Miraflores
6526	5699	San Mart??n
6527	5699	San Pablo
6528	5700	Catamarca??(San Fernando del Valle de Catamarca)
6529	5700	El Pantanillo
6530	5701	El Alto
6531	5701	Guayamba
6532	5701	Infanz??n
6533	5701	Los Corrales
6534	5701	Tapso
6535	5701	Vilism??n
6536	5702	Collagasta
6537	5702	Pomancillo Este
6538	5702	Pomancillo Oeste
6539	5702	Villa Las Pirquitas
6540	5703	Casa de Piedra
6541	5703	El Aybal
6542	5703	El Divisadero
6543	5703	El Quimilo
6544	5703	Esqui??
6545	5703	Ica??o
6546	5703	La Dorada
6547	5703	La Guardia
6548	5703	Las Esquinas
6549	5703	Las Palmitas
6550	5703	Quir??s
6551	5703	Ramblones
6552	5703	Recreo
6553	5703	San Antonio
6554	5704	Amadores
6555	5704	El Rosario
6556	5704	La Bajada
6557	5704	La Higuera
6558	5704	La Merced
6559	5704	La Vi??a
6560	5704	Las Lajas
6561	5704	Monte Potrero
6562	5704	Palo Labrado
6563	5704	Villa de Balcozna
6564	5705	Apoyaco
6565	5705	Colana
6566	5705	El Pajonal??(Est. Pom??n)
6567	5705	Joyango
6568	5705	Mutqu??n
6569	5705	Pom??n
6570	5705	Rinc??n
6571	5705	Saujil
6572	5705	Sij??n
6573	5706	Andalhual??
6574	5706	Caspichango
6575	5706	Cha??ar Punco
6576	5706	El Caj??n
6577	5706	El Desmonte
6578	5706	El Puesto
6579	5706	Famatanca
6580	5706	Fuerte Quemado
6581	5706	La Hoyada
6582	5706	La Loma
6583	5706	Las Mojarras
6584	5706	Loro Huasi
6585	5706	Punta de Balasto
6586	5706	Yapes
6587	5707	Alijil??n
6588	5707	Ba??ado de Ovanta
6589	5707	Las Ca??as
6590	5707	Lavalle
6591	5707	Los Altos
6592	5707	Manantiales
6593	5707	San Pedro??(San Pedro de Guasay??n)
6594	5708	Anillaco
6595	5708	Antinaco
6596	5708	Banda de Lucero
6597	5708	Cerro Negro
6598	5708	Copacabana
6599	5708	Cordobita
6600	5708	Costa de Reyes
6601	5708	El Pueblito
6602	5708	El Salado
6603	5708	Fiambal??
6604	5708	Los Balverdis
6605	5708	Medanitos
6606	5708	Palo Blanco
6607	5708	Punta del Agua
6608	5708	Tat??n
6609	5708	Tinogasta
6610	5709	El Portezuelo
6611	5709	Las Tejas
6612	5709	Santa Cruz
6613	5709	Concepci??n del Bermejo
6614	5709	Los Frentones
6615	5709	Pampa del Infierno
6616	5709	R??o Muerto
6617	5709	Taco Pozo
6618	5710	General Vedia
6619	5710	Isla del Cerrito
6620	5710	La Leonesa
6621	5710	Las Palmas
6622	5710	Puerto Bermejo Nuevo
6623	5710	Puerto Bermejo Viejo
6624	5710	Puerto Eva Per??n
6625	5710	Charata
6626	5711	Presidencia Roque S??enz Pe??a
6627	5712	Gancedo
6628	5712	General Capdevila
6629	5712	General Pinedo
6630	5712	Mes??n de Fierro
6631	5712	Pampa Landriel
6632	5713	Hermoso Campo
6633	5713	It??n
6634	5714	Chorotis
6635	5714	Santa Sylvina
6636	5714	Venados Grandes
6637	5714	Corzuela
6638	5715	La Escondida
6639	5715	La Verde
6640	5715	Lapachito
6641	5715	Makall??
6642	5716	El Espinillo
6643	5716	El Sauzal
6644	5716	El Sauzalito
6645	5716	Fort??n Lavalle
6646	5716	Fuerte Esperanza
6647	5716	Juan Jos?? Castelli
6648	5716	Nueva Pompeya
6649	5716	Villa R??o Bermejito
6650	5716	Wich??
6651	5716	Zaparinqui
6652	5717	Avia Terai
6653	5717	Campo Largo
6654	5717	Fort??n Las Chu??as
6655	5717	Napenay
6656	5718	Colonia Popular
6657	5718	Estaci??n General Obligado
6658	5718	Laguna Blanca
6659	5718	Puerto Tirol
6660	5719	Ciervo Petiso
6661	5719	General Jos?? de San Mart??n
6662	5719	La Eduvigis
6663	5719	Laguna Limpia
6664	5719	Pampa Almir??n
6665	5719	Pampa del Indio
6666	5719	Presidencia Roca
6667	5719	Selvas del R??o de Oro
6668	5719	Tres Isletas
6669	5720	Coronel Du Graty
6670	5720	Enrique Uri??n
6671	5720	Villa ??ngela
6672	5720	Las Bre??as
6673	5721	La Clotilde
6674	5721	La Tigra
6675	5721	San Bernardo
6676	5722	Presidencia de la Plaza
6677	5723	Barrio de los Pescadores
6678	5723	Colonia Ben??tez
6679	5723	Margarita Bel??n
6680	5724	Quitilipi
6681	5724	Villa El Palmar
6682	5724	Barranqueras
6683	5724	Basail
6684	5724	Colonia Baranda
6685	5724	Fontana
6686	5724	Puerto Vilelas
6687	5724	Resistencia
6688	5725	Samuh??
6689	5725	Villa Berthet
6690	5726	Capit??n Solari
6691	5726	Colonia Elisa
6692	5726	Colonias Unidas
6693	5726	Ingeniero Barbet
6694	5726	Las Garcitas
6695	5727	Charadai
6696	5727	Cote Lai
6697	5727	Haumon??a
6698	5727	Horquilla
6699	5727	La Sabana
6700	5727	Colonia Aborigen
6701	5727	Machagai
6702	5727	Napalp??
6703	5728	Arroyo Verde
6704	5728	Puerto Madryn
6705	5728	Puerto Pir??mides
6706	5728	Quinta El Mirador
6707	5728	Reserva Area Protegida El Doradillo
6708	5729	Buenos Aires Chico
6709	5729	Cholila
6710	5729	Costa del Chubut
6711	5729	Cushamen Centro
6712	5729	El Hoyo
6713	5729	El Mait??n
6714	5729	Epuy??n
6715	5729	Fofo Cahuel
6716	5729	Gualjaina
6717	5729	Lago Epuy??n
6718	5729	Lago Puelo
6719	5729	Leleque
6720	5730	Astra
6721	5730	Bah??a Bustamante
6722	5730	Comodoro Rivadavia
6723	5730	Diadema Argentina
6724	5730	Rada Tilly
6725	5730	Camarones
6726	5730	Garayalde
6727	5731	Aldea Escolar??(Losr??pidos)
6728	5731	Corcovado
6729	5731	Esquel
6730	5731	Lago Rosario
6731	5731	Los Cipreses
6732	5731	Trevelin
6733	5731	Villa Futalaufquen
6734	5732	28 de Julio
6735	5732	Dique Florentino Ameghino
6736	5732	Dolavon
6737	5732	Gaiman
6738	5733	Blancuntre
6739	5733	El Escorial
6740	5733	Gastre
6741	5733	Lagunita Salada
6742	5733	Yala Laubat
6743	5734	Aldea Epulef
6744	5734	Carrenleuf??
6745	5734	Colan Conhu??
6746	5734	Paso del Sapo
6747	5734	Tecka
6748	5735	El Mirasol
6749	5735	Las Plumas
6750	5736	Cerro C??ndor
6751	5736	Los Altares
6752	5736	Paso de Indios
6753	5737	Playa Magagna
6754	5737	Playa Uni??n
6755	5737	Trelew
6756	5738	Aldea Apeleg
6757	5738	Aldea Beleiro
6758	5738	Alto R??o Senguer
6759	5738	Doctor Ricardo Rojas
6760	5738	Facundo
6761	5738	Lago Blanco
6762	5738	R??o Mayo
6763	5739	Buen Pasto
6764	5739	Sarmiento
6765	5740	Doctor Oscar Atilio Viglione??(Frontera de R??o Pico)
6766	5740	Gobernador Costa
6767	5740	Jos?? de San Mart??n
6768	5740	R??o Pico
6769	5741	Gan Gan
6770	5741	Telsen
6771	5742	Amboy
6772	5742	Ca??ada del Sauce
6773	5742	Capilla Vieja
6774	5742	El Corcovado - El Torre??n
6775	5742	Embalse
6776	5742	La Cruz
6777	5742	La Cumbrecita
6778	5742	Las Bajadas
6779	5742	Las Caleras
6780	5742	Los C??ndores
6781	5742	Los Molinos
6782	5742	Los Reartes
6783	5742	Lutti
6784	5742	Parque Calmayo
6785	5742	R??o de los Sauces
6786	5742	San Ignacio??(Loteo San Javier)
6787	5742	Santa Rosa de Calamuchita
6788	5742	Segunda Usina
6789	5742	Solar de los Molinos
6790	5742	Villa Alpina
6791	5742	Villa Amancay
6792	5742	Villa Berna
6793	5742	Villa Ciudad Parque Los Reartes
6794	5742	Villa del Dique
6795	5742	Villa El Tala
6796	5742	Villa General Belgrano
6797	5742	Villa La Rivera
6798	5742	Villa Quillinzo
6799	5742	Villa Rumipal
6800	5742	Villa Yacanto??(Yacanto de Calamuchita)
6801	5742	C??rdoba
6802	5742	Agua de Oro
6803	5742	Ascochinga
6804	5742	Barrio Nuevo Rio Ceballos
6805	5742	Canteras El Sauce
6806	5742	Casa Bamba
6807	5742	Colonia Caroya
6808	5742	Colonia Tirolesa
6809	5742	Colonia Vicente Ag??ero
6810	5742	Country Chacras de la Villa??(- Country San Isidro)
6811	5742	El Manzano
6812	5742	Estaci??n Colonia Tirolesa
6813	5742	General Paz
6814	5742	Jes??s Mar??a
6815	5742	La Calera
6816	5742	La Granja
6817	5742	La Morada
6818	5742	Las Corzuelas
6819	5742	Los Molles
6820	5742	Malvinas Argentinas
6821	5742	Mendiolaza
6822	5742	Mi Granja
6823	5742	Pajas Blancas
6824	5742	R??o Ceballos
6825	5742	Sald??n
6826	5742	Salsipuedes
6827	5742	Santa Elena
6828	5742	Tinoco
6829	5742	Unquillo
6830	5742	Villa Allende
6831	5742	Villa Cerro Azul
6832	5742	Villa Corazon de Maria
6833	5742	Villa El Fachinal??(- Parque Norte - Gui??az?? Norte)
6834	5742	Villa Los Llanos??(- Ju??rez Celman)
6835	5743	Alto de los Quebrachos
6836	5743	Ba??ado de Soto
6837	5743	Canteras Quilpo
6838	5743	Cruz de Ca??a
6839	5743	Cruz del Eje
6840	5743	El Brete
6841	5743	El Rinc??n
6842	5743	Guanaco Muerto
6843	5743	La Banda
6844	5743	La Batea
6845	5743	Las Ca??adas
6846	5743	Las Playas
6847	5743	Los Cha??aritos
6848	5743	Media Naranja
6849	5743	Paso Viejo
6850	5743	San Marcos Sierra
6851	5743	Serrezuela
6852	5743	Tuclame
6853	5743	Villa de Soto
6854	5744	Del Campillo
6855	5744	Estaci??n Lecueder
6856	5744	Hip??lito Bouchard??(Buchardo)
6857	5744	Huinca Renanc??
6858	5744	Ital??
6859	5744	Mattaldi
6860	5744	Nicol??s Bruzzone
6861	5744	Onagoity
6862	5744	Pinc??n
6863	5744	Ranqueles
6864	5744	Santa Magdalena??(Est. Jovita)
6865	5744	Villa Huidobro
6866	5744	Villa Sarmiento
6867	5744	Villa Valeria
6868	5744	Arroyo Algod??n
6869	5744	Arroyo Cabral
6870	5744	Ausonia
6871	5744	Chaz??n
6872	5744	Etruria
6873	5744	La Laguna
6874	5744	La Palestina
6875	5744	La Playosa
6876	5744	Luca
6877	5744	Pasco
6878	5744	Sanabria
6879	5744	Silvio Pellico
6880	5744	Ticino
6881	5744	T??o Pujio
6882	5744	Villa Albertina
6883	5744	Villa Nueva
6884	5744	Villa Oeste
6885	5745	Ca??ada de R??o Pinto
6886	5745	Chu??a
6887	5745	De??n Funes
6888	5745	Esquina del Alambre
6889	5745	Los Pozos
6890	5745	Olivares de San Nicol??s
6891	5745	Quilino
6892	5745	San Pedro de Toyos
6893	5745	Villa Guti??rrez
6894	5745	Villa Quilino
6895	5746	Alejandro Roca??(Est. Alejandro)
6896	5746	Assunta
6897	5746	Bengolea
6898	5746	Carnerillo
6899	5746	Charras
6900	5746	El Rastreador
6901	5746	General Cabrera
6902	5746	General Deheza
6903	5746	Huanchillas
6904	5746	La Carlota
6905	5746	Los Cisnes
6906	5746	Olaeta
6907	5746	Pacheco de Melo
6908	5746	Paso del Durazno
6909	5746	Santa Eufemia
6910	5746	Ucacha
6911	5746	Villa Reducci??n
6912	5747	Alejo Ledesma
6913	5747	Arias
6914	5747	Camilo Aldao
6915	5747	Capit??n General Bernardo O'Higgins
6916	5747	Cavanagh
6917	5747	Colonia Barge
6918	5747	Colonia Italiana
6919	5747	Colonia Veinticinco
6920	5747	Corral de Bustos
6921	5747	Cruz Alta
6922	5747	General Baldissera
6923	5747	General Roca
6924	5747	Guatimoz??n
6925	5747	Inriville
6926	5747	Isla Verde
6927	5747	Leones
6928	5747	Los Surgentes
6929	5747	Marcos Ju??rez
6930	5747	Monte Buey
6931	5747	Saira
6932	5747	Villa Elisa
6933	5748	Ci??naga del Coro
6934	5748	El Chacho
6935	5748	Estancia de Guadalupe
6936	5748	Guasapampa
6937	5748	La Playa
6938	5748	San Carlos Minas
6939	5748	Talaini
6940	5748	Tosno
6941	5749	Chancan??
6942	5749	Los Talares
6943	5749	Salsacate
6944	5749	San Ger??nimo
6945	5749	Tala Ca??ada
6946	5749	Taninga
6947	5749	Villa de Pocho
6948	5750	General Levalle
6949	5750	La Cesira
6950	5750	Laboulaye
6951	5750	Leguizam??n
6952	5750	Melo
6953	5750	R??o Bamba
6954	5750	Rosales
6955	5750	San Joaqu??n
6956	5750	Serrano
6957	5750	Villa Rossi
6958	5751	Barrio Santa Isabel
6959	5751	Bialet Mass??
6960	5751	Cabalango
6961	5751	Capilla del Monte
6962	5751	Casa Grande
6963	5751	Charbonier
6964	5751	Cosqu??n
6965	5751	Cuesta Blanca
6966	5751	Estancia Vieja
6967	5751	Huerta Grande
6968	5751	La Cumbre
6969	5751	La Falda
6970	5751	Las Jarillas
6971	5751	Los Cocos
6972	5751	Mall??n
6973	5751	Mayu Sumaj
6974	5751	Quebrada de Luna
6975	5751	San Antonio de Arredondo
6976	5751	San Esteban
6977	5751	San Roque
6978	5751	Santa Mar??a de Punilla
6979	5751	Tala Huasi
6980	5751	Tanti
6981	5751	Valle Hermoso
6982	5751	Villa Carlos Paz
6983	5751	Villa Flor Serrana
6984	5751	Villa Giardino
6985	5751	Villa Lago Azul
6986	5751	Villa Parque S??quiman
6987	5751	Villa R??o Icho Cruz
6988	5751	Villa San Jos????(San Jos?? de los R??os)
6989	5751	Villa Santa Cruz del Lago
6990	5752	Achiras
6991	5752	Adelia Mar??a
6992	5752	Alcira??(Gigena)
6993	5752	Alpa Corral
6994	5752	Berrotar??n
6995	5752	Bulnes
6996	5752	Chaj??n
6997	5752	Chucul
6998	5752	Coronel Baigorria
6999	5752	Coronel Moldes
7000	5752	Elena
7001	5752	La Carolina
7002	5752	La Cautiva
7003	5752	La Gilda
7004	5752	Las Acequias
7005	5752	Las Albahacas
7006	5752	Las Higueras
7007	5752	Las Pe??as??(Sud)
7008	5752	Las Vertientes
7009	5752	Malena
7010	5752	Monte de los Gauchos
7011	5752	R??o Cuarto
7012	5752	Sampacho
7013	5752	San Basilio
7014	5752	Santa Catalina??(Holmberg)
7015	5752	Suco
7016	5752	Tosquitas
7017	5752	Vicu??a Mackenna
7018	5752	Villa El Chacay
7019	5752	Villa Santa Eugenia
7020	5752	Washington
7021	5753	Atahona
7022	5753	Ca??ada de Machado
7023	5753	Capilla de los Remedios
7024	5753	Chalacea
7025	5753	Colonia Las Cuatro Esquinas
7026	5753	Diego de Rojas
7027	5753	El Alcalde??(Est. Tala Norte)
7028	5753	El Crisp??n
7029	5753	Esquina
7030	5753	Kil??metro 658
7031	5753	La Para
7032	5753	La Posta
7033	5753	La Quinta
7034	5753	Las Gramillas
7035	5753	Las Saladas
7036	5753	Maquinista Gallini
7037	5753	Monte Cristo
7038	5753	Monte del Rosario
7039	5753	Obispo Trejo
7040	5753	Piquill??n
7041	5753	Plaza de Mercedes
7042	5753	Pueblo Comechingones
7043	5753	R??o Primero
7044	5753	Sagrada Familia
7045	5753	Santa Rosa de R??o Primero
7046	5753	Villa Fontana
7047	5754	Cerro Colorado
7048	5754	Cha??ar Viejo
7049	5754	Eufrasio Loza
7050	5754	Gutemberg
7051	5754	La Rinconada
7052	5754	Los Hoyos
7053	5754	Puesto de Castro
7054	5754	Rayo Cortado
7055	5754	San Pedro de G??temberg
7056	5754	Sebasti??n Elcano
7057	5754	Villa Candelaria
7058	5754	Villa de Mar??a
7059	5755	Calch??n
7060	5755	Calch??n Oeste
7061	5755	Capilla del Carmen
7062	5755	Carrilobo
7063	5755	Colazo
7064	5755	Colonia Videla
7065	5755	Costa Sacate
7066	5755	Impira
7067	5755	Laguna Larga
7068	5755	Las Junturas
7069	5755	Luque
7070	5755	Manfredi
7071	5755	Matorrales
7072	5755	Oncativo
7073	5755	Pozo del Molle
7074	5755	R??o Segundo
7075	5755	Santiago Temple
7076	5755	Villa del Rosario
7077	5756	??mbul
7078	5756	Arroyo Los Patos
7079	5756	El Huayco
7080	5756	La Cortadera
7081	5756	Las Calles
7082	5756	Las Oscuras
7083	5756	Las Rabonas
7084	5756	Los Callejones
7085	5756	Mina Clavero
7086	5756	Mussi
7087	5756	Nono
7088	5756	Panaholma
7089	5756	San Huberto
7090	5756	San Lorenzo
7091	5756	Sauce Arriba
7092	5756	Tasna
7093	5756	Villa Cura Brochero
7094	5757	Conlara
7095	5757	Cruz Ca??a
7096	5757	Dos Arroyos
7097	5757	La Paz
7098	5757	La Poblaci??n
7099	5757	La Ramada
7100	5757	La Traves??a
7101	5757	Las Chacras
7102	5757	Las Tapias
7103	5757	Loma Bola
7104	5757	Los Cerrillos
7105	5757	Los Hornillos
7106	5757	Luyaba
7107	5757	Quebracho Ladeado
7108	5757	Quebrada de los Pozos
7109	5757	San Javier y Yacanto
7110	5757	Villa de Las Rosas
7111	5757	Villa Dolores
7112	5757	Villa La Vi??a
7113	5758	Alicia
7114	5758	Altos de Chipi??n
7115	5758	Arroyito
7116	5758	Balnearia
7117	5758	Brinkmann
7118	5758	Colonia 10 de Julio
7119	5758	Colonia Anita
7120	5758	Colonia Iturraspe
7121	5758	Colonia Las Pichanas
7122	5758	Colonia Marina
7123	5758	Colonia Prosperidad
7124	5758	Colonia San Bartolom??
7125	5758	Colonia San Pedro
7126	5758	Colonia Santa Mar??a
7127	5758	Colonia Valtelina
7128	5758	Colonia Vignaud
7129	5758	Devoto
7130	5758	El Ara??ado
7131	5758	El Fort??n
7132	5758	El Fuertecito
7133	5758	El T??o
7134	5758	Estaci??n Luxardo
7135	5758	Freyre
7136	5758	La Francia
7137	5758	La Paquita
7138	5758	La Tordilla
7139	5758	Las Varas
7140	5758	Las Varillas
7141	5758	Marull
7142	5758	Morteros
7143	5758	Plaza Luxardo
7144	5758	Plaza San Francisco
7145	5758	Porte??a
7146	5758	Quebracho Herrado
7147	5758	Sacanta
7148	5758	San Francisco
7149	5758	Saturnino Mar??a Laspiur
7150	5758	Seeber
7151	5758	Toro Pujio
7152	5758	Tr??nsito
7153	5758	Villa Concepci??n del T??o
7154	5758	Villa del Tr??nsito
7155	5758	Villa San Esteban
7156	5758	Alta Gracia
7157	5758	Anisacate
7158	5758	Barrio Gilbert??(- Tejas Tres; 1?? de Mayo)
7159	5758	Bouwer
7160	5758	Campos del Virrey
7161	5758	Caseros Centro
7162	5758	Causana
7163	5758	Costa Azul
7164	5758	Despe??aderos
7165	5758	Dique Chico
7166	5758	El Potrerillo
7167	5758	Falda del Ca??ete
7168	5758	Falda del Carmen
7169	5758	Jos?? de la Quintana
7170	5758	La Boca del R??o
7171	5758	La Carbonada
7172	5758	La Paisanita
7173	5758	La Perla
7174	5758	La Rancherita y Las Cascadas
7175	5758	La Serranita
7176	5758	Los Cedros
7177	5758	Lozada
7178	5758	Malague??o
7179	5758	Monte Ralo
7180	5758	Potrero de Garay
7181	5758	Rafael Garc??a
7182	5758	San Clemente
7183	5758	San Nicol??s??(- Tierra Alta)
7184	5758	Socavones
7185	5758	Toledo
7186	5758	Valle Alegre
7187	5758	Valle de Anisacate
7188	5758	Villa Ciudad de Am??rica??(Loteo Diego de Rojas)
7189	5758	Villa del Prado
7190	5758	Villa La Bolsa
7191	5758	Villa Los Aromos
7192	5758	Villa Parque Santa Ana
7193	5758	Villa San Isidro
7194	5758	Villa Sierras de Oro
7195	5758	Yocsina
7196	5759	Caminiaga
7197	5759	Chu??a Huasi
7198	5759	Pozo Nuevo
7199	5759	San Francisco del Cha??ar
7200	5760	Almafuerte
7201	5760	Colonia Almada
7202	5760	Corralito
7203	5760	Dalmacio V??lez
7204	5760	General Fotheringham
7205	5760	Hernando
7206	5760	James Craik
7207	5760	Las Isletillas
7208	5760	Las Perdices
7209	5760	Los Zorros
7210	5760	Oliva
7211	5760	Pampayasta Norte
7212	5760	Pampayasta Sur
7213	5760	R??o Tercero
7214	5760	Tancacha
7215	5760	Villa Ascasubi
7216	5761	Candelaria Sur
7217	5761	Ca??ada de Luque
7218	5761	Capilla de Sit??n
7219	5761	La Pampa
7220	5761	Las Pe??as
7221	5761	Los Mistoles
7222	5761	Santa Catalina
7223	5761	Simbolar
7224	5761	Sinsacate
7225	5761	Villa del Totoral
7226	5762	Churqui Ca??ada
7227	5762	El Tuscal
7228	5762	Las Arrias
7229	5762	Lucio V. Mansilla
7230	5762	Rosario del Saladillo
7231	5762	San Jos?? de la Dormida
7232	5762	San Jos?? de las Salinas
7233	5762	San Pedro Norte
7234	5762	Villa Tulumba
7235	5763	Aldea Santa Mar??a
7236	5763	Alto Alegre
7237	5763	Ana Zumar??n
7238	5763	Ballesteros
7239	5763	Ballesteros Sur
7240	5763	Bell Ville
7241	5763	Benjam??n Gould
7242	5763	Canals
7243	5763	Chilibroste
7244	5763	Cintra
7245	5763	Colonia Bismarck
7246	5763	Colonia Bremen
7247	5763	Idiaz??bal
7248	5763	Justiniano Posse
7249	5763	Laborde
7250	5763	Monte Le??a
7251	5763	Monte Ma??z
7252	5763	Morrison
7253	5763	Noetinger
7254	5763	Ord????ez
7255	5763	Pascanas
7256	5763	Pueblo Italiano
7257	5763	Ram??n J. C??rcano
7258	5763	San Antonio de Lit??n
7259	5763	San Marcos
7260	5763	San Severo
7261	5763	Viamonte
7262	5763	Villa Los Patos
7263	5763	Wenceslao Escalante
7264	5764	Bella Vista
7265	5765	Ber??n de Astrada
7266	5765	Yahap??
7267	5765	Corrientes
7268	5765	Laguna Brava
7269	5765	Riachuelo
7270	5766	Tabay
7271	5766	Tatacu??
7272	5767	Cazadores Correntinos
7273	5767	Curuz?? Cuati??
7274	5767	Perugorr??a
7275	5768	El Sombrero
7276	5768	Empedrado
7277	5769	Pueblo Libertador
7278	5769	Alvear
7279	5769	Estaci??n Torrent
7280	5769	It?? Ibat??
7281	5769	Lomas de Vallejos
7282	5769	Nuestra Se??ora del Rosario de Ca?? Cat??
7283	5769	Palmar Grande
7284	5770	Carolina
7285	5770	Goya
7286	5771	Itat??
7287	5771	Ramada Paso
7288	5771	Colonia Liebig's
7289	5771	San Carlos
7290	5771	Villa Olivari
7291	5772	Cruz de los Milagros
7292	5772	Gobernador Juan E. Mart??nez
7293	5772	Villa C??rdoba
7294	5772	Yatayti Calle
7295	5773	Mburucuy??
7296	5773	Felipe Yofre
7297	5773	Mariano I. Loza??(Est. Justino Solari)
7298	5774	Colonia Libertad
7299	5774	Estaci??n Libertad
7300	5774	Juan Pujol
7301	5774	Mocoret??
7302	5774	Monte Caseros
7303	5774	Parada Acu??a
7304	5774	Parada Labougle
7305	5775	Bonpland
7306	5775	Parada Pucheta
7307	5775	Paso de los Libres
7308	5775	Tapebicu??
7309	5776	Saladas
7310	5777	Ingenio Primer Correntino
7311	5777	Paso de la Patria
7312	5777	San Cosme
7313	5777	Santa Ana
7314	5778	San Luis del Palmar
7315	5779	Colonia Carlos Pellegrini
7316	5779	Guavirav??
7317	5779	Yapey??
7318	5779	Loreto
7319	5780	9 de Julio??(Est. Pueblo 9 de Julio)
7320	5780	Chavarr??a
7321	5780	Colonia Pando
7322	5780	Pedro R. Fern??ndez??(Est. Manuel F. Mantilla)
7323	5781	Garruchos
7324	5781	Gobernador Igr. Valent??n Virasoro
7325	5781	Jos?? Rafael G??mez??(Garab??)
7326	5781	Santo Tom??
7327	5782	Sauce
7328	5782	Arroyo Bar??
7329	5782	Colonia Hugues
7330	5782	Hambis
7331	5782	Hocker
7332	5782	La Clarita
7333	5782	Pueblo Cazes
7334	5782	Pueblo Liebig's
7335	5782	Ubajay
7336	5783	Calabacilla
7337	5783	Clodomiro Ledesma
7338	5783	Colonia Ayu??
7339	5783	Colonia General Roca
7340	5783	Concordia
7341	5783	Estaci??n Yeru??
7342	5783	Estaci??n Yuquer??
7343	5783	Estancia Grande??(Colonia Yeru??)
7344	5783	La Criolla
7345	5783	Los Charr??as
7346	5783	Nueva Escocia
7347	5783	Osvaldo Magnasco
7348	5783	Pedernal
7349	5783	Puerto Yeru??
7350	5784	Aldea Brasilera
7351	5784	Aldea Grapschental
7352	5784	Aldea Protestante
7353	5784	Aldea Salto
7354	5784	Aldea San Francisco
7355	5784	Aldea Spatzenkutter
7356	5784	Aldea Valle Mar??a
7357	5784	Colonia Ensayo
7358	5784	Diamante
7359	5784	Estaci??n Camps
7360	5784	General Alvear??(Puerto Alvear)
7361	5784	General Racedo??(El Carmen)
7362	5784	General Ram??rez
7363	5784	La Juanita
7364	5784	Las Jaulas
7365	5784	Paraje La Virgen
7366	5784	Puerto Las Cuevas
7367	5784	Villa Libertador San Mart??n
7368	5785	Chajar??
7369	5785	Colonia Alemana
7370	5785	Colonia La Argentina
7371	5785	Colonia Pe??a
7372	5785	Federaci??n
7373	5785	Los Conquistadores
7374	5785	San Jaime de la Frontera
7375	5785	San Ram??n
7376	5786	Aldea San Isidro??(El Cimarr??n)
7377	5786	Conscripto Bernardi
7378	5786	Federal
7379	5786	Nueva Vizcaya
7380	5786	Sauce de Luna
7381	5787	San Jos?? de Feliciano
7382	5787	San V??ctor
7383	5788	Aldea Asunci??n
7384	5788	Estaci??n Lazo
7385	5788	General Galarza
7386	5788	Gualeguay
7387	5788	Puerto Ruiz
7388	5789	Aldea San Antonio
7389	5789	Aldea San Juan
7390	5789	Enrique Carb??
7391	5789	Estaci??n Escri??a
7392	5789	Faustino M. Parera
7393	5789	General Almada
7394	5789	Gilbert
7395	5789	Gualeguaych??
7396	5789	Irazusta
7397	5789	Larroque
7398	5789	Pastor Britos
7399	5789	Pueblo General Belgrano
7400	5789	Urdinarrain
7401	5790	Ceibas
7402	5790	Ibicuy
7403	5790	Villa Paranacito
7404	5790	Bovril
7405	5790	Colonia Avigdor
7406	5790	El Solar
7407	5790	Piedras Blancas
7408	5790	Pueblo Arr??a??(Est. Alcaraz)
7409	5790	San Gustavo
7410	5790	Sir Leonard
7411	5791	Aranguren
7412	5791	Betbeder
7413	5791	Don Crist??bal
7414	5791	Febr??
7415	5791	Hern??ndez
7416	5791	Lucas Gonz??lez
7417	5791	Nogoy??
7418	5791	XX de Setiembre
7419	5792	Aldea Mar??a Luisa
7420	5792	Aldea San Rafael
7421	5792	Aldea Santa Rosa
7422	5792	Cerrito
7423	5792	Colonia Avellaneda
7424	5792	Colonia Crespo
7425	5792	Crespo
7426	5792	El Palenque
7427	5792	El Pingo
7428	5792	El Rambl??n
7429	5792	Hasenkamp
7430	5792	Hernandarias
7431	5792	La Picada
7432	5792	Las Tunas
7433	5792	Mar??a Grande
7434	5792	Oro Verde
7435	5792	Paran??
7436	5792	Pueblo Bellocq??(Est. Las Garzas)
7437	5792	Pueblo Brugo
7438	5792	Pueblo General San Mart??n
7439	5792	San Benito
7440	5792	Sauce Montrull
7441	5792	Sauce Pinto
7442	5792	Segu??
7443	5792	Sosa
7444	5792	Tabossi
7445	5792	Tezanos Pinto
7446	5792	Viale
7447	5792	Villa Gobernador Luis F. Etchevehere
7448	5792	Villa Urquiza
7449	5793	General Campos
7450	5793	San Salvador
7451	5794	Altamirano Sur
7452	5794	Durazno
7453	5794	Estaci??n Arroyo Cl??
7454	5794	Gobernador Echag??e
7455	5794	Gobernador Mansilla
7456	5794	Gobernador Sola
7457	5794	Guardamonte
7458	5794	Las Guachas
7459	5794	Maci??
7460	5794	Rosario del Tala
7461	5795	1?? de Mayo??(Primero de Mayo)
7462	5795	Basavilbaso
7463	5795	Caseros
7464	5795	Colonia El??a
7465	5795	Concepci??n del Uruguay
7466	5795	Herrera
7467	5795	Las Moscas
7468	5795	L??baros
7469	5795	Pronunciamiento
7470	5795	Rocamora
7471	5795	Santa Anita
7472	5795	Villa Mantero
7473	5795	Villa San Justo
7474	5795	Villa San Marcial??(Est. Gobernador Urquiza)
7475	5796	Antelo
7476	5796	Molino Doll
7477	5796	Victoria
7478	5797	Estaci??n Ra??ces
7479	5797	Ingeniero Miguel Sajaroff
7480	5797	Jubileo
7481	5797	Paso de la Laguna
7482	5797	Villa Clara
7483	5797	Villa Dom??nguez
7484	5797	Villaguay
7485	5797	Fort??n Soledad
7486	5797	Guadalcazar
7487	5797	Laguna Yema
7488	5797	Lamadrid
7489	5797	Los Chiriguanos
7490	5797	Pozo de Maza
7491	5797	Pozo del Mortero
7492	5797	Vaca Perdida
7493	5798	Colonia Pastoril
7494	5798	Formosa
7495	5798	Gran Guardia
7496	5798	Mariano Boedo
7497	5798	Moj??n de Fierro
7498	5798	San Hilario
7499	5798	Villa del Carmen
7500	5799	Banco Payagu??
7501	5799	General Lucio Victorio Mansilla
7502	5799	Herradura
7503	5799	San Francisco de Laishi
7504	5799	Tatan??
7505	5799	Villa Escolar
7506	5800	Ingeniero Guillermo N. Ju??rez
7507	5801	Bartolom?? de las Casas
7508	5801	Colonia Sarmiento
7509	5801	Comandante Fontana
7510	5801	El Recreo
7511	5801	Estanislao del Campo
7512	5801	Fort??n Cabo 1?? Lugones
7513	5801	Fort??n Sargento 1?? Leyes
7514	5801	Ibarreta
7515	5801	Juan G. Baz??n
7516	5801	Las Lomitas
7517	5801	Posta Cambio Zalazar
7518	5801	Pozo del Tigre
7519	5801	San Mart??n I
7520	5801	San Mart??n II
7521	5801	Subteniente Per??n
7522	5801	Villa General G??emes
7523	5801	Villa General Manuel Belgrano
7524	5802	Buena Vista
7525	5802	Laguna Gallo
7526	5802	Misi??n Tacaagl??
7527	5802	Port??n Negro
7528	5802	Tres Lagunas
7529	5803	Clorinda
7530	5803	Laguna Naick-Neck
7531	5803	Palma Sola
7532	5803	Puerto Pilcomayo
7533	5803	Riacho He-He
7534	5803	Riacho Negro
7535	5803	Siete Palmas
7536	5804	Colonia Campo Villafa??e??(Mayor Vicente Villafa??e)
7537	5804	El Colorado
7538	5804	Palo Santo
7539	5804	Piran??
7540	5804	Villa Kil??metro 213??(Villa Dos Trece)
7541	5805	El Potrillo
7542	5805	El Quebracho
7543	5805	General Mosconi
7544	5806	Abd??n Castro Tolay
7545	5806	Abra Pampa
7546	5806	Abralaite
7547	5806	Agua de Castilla
7548	5806	Casabindo
7549	5806	Cochinoca
7550	5806	La Redonda
7551	5806	Puesto del Marqu??z
7552	5806	Quebrale??a
7553	5806	Quera
7554	5806	Rinconadillas
7555	5806	San Francisco de Alfarcito
7556	5806	Santa Ana de la Puna
7557	5806	Santuario de Tres Pozos
7558	5806	Tambillos
7559	5806	Tusaquillas
7560	5807	Guerrero
7561	5807	La Almona
7562	5807	Le??n
7563	5807	Lozano??(Ap. Cha??i)
7564	5807	Ocloyas
7565	5807	San Salvador de Jujuy??(Est. Jujuy)
7566	5807	Tesorero
7567	5807	Yala
7568	5808	Aguas Calientes
7569	5808	Barrio El Milagro??(La Ovejer??a)
7570	5808	Barrio La Uni??n
7571	5808	El Carmen
7572	5808	Los Lapachos??(Est. Maquinista Ver??)
7573	5808	Loteo San Vicente
7574	5808	Monterrico
7575	5808	Pampa Blanca
7576	5808	Perico
7577	5808	Puesto Viejo
7578	5808	San Juancito
7579	5809	Aparzo
7580	5809	Cianzo
7581	5809	Coctaca
7582	5809	El Aguilar
7583	5809	Hip??lito Yrigoyen??(Est. Iturbe)
7584	5809	Humahuaca
7585	5809	Palca de Aparzo
7586	5809	Palca de Varas
7587	5809	Rodero
7588	5809	Tres Cruces
7589	5809	Uqu??a??(Est. Senador P??rez)
7590	5810	Bananal
7591	5810	Bermejito
7592	5810	Caimancito
7593	5810	Calilegua
7594	5810	Chalic??n
7595	5810	Fraile Pintado
7596	5810	Libertad
7597	5810	Libertador General San Mart??n??(Est. Ledesma)
7598	5810	Paulina
7599	5810	Yuto
7600	5811	Carahunco
7601	5811	Centro Forestal
7602	5811	Palpal????(Est. Gral. Manuel N. Savio)
7603	5812	Casa Colorada
7604	5812	Coyaguaima
7605	5812	Lagunillas de Farall??n
7606	5812	Liviara
7607	5812	Loma Blanca
7608	5812	Nuevo Pirquitas??(Mina Pirquitas)
7609	5812	Orosmayo
7610	5812	Rinconada
7611	5813	El Ceibal
7612	5813	Los Alisos
7613	5813	Loteo Navea??(Los Alisos)
7614	5813	Nuestra Se??ora del Rosario
7615	5813	Arrayanal
7616	5813	Arroyo Colorado
7617	5813	Don Emilio
7618	5813	El Acheral
7619	5813	El Quemado
7620	5813	La Esperanza
7621	5813	La Manga
7622	5813	La Mendieta
7623	5813	Palos Blancos
7624	5813	Parapet??
7625	5813	Rode??to
7626	5813	Rosario de R??o Grande??(Barro Negro)
7627	5813	San Lucas
7628	5813	San Pedro??(Est. San Pedro de Jujuy)
7629	5813	Sauzal
7630	5814	El Fuerte
7631	5814	El Piquete
7632	5814	El Talar
7633	5814	Puente Lavay??n
7634	5814	Santa Clara
7635	5814	Vinalito
7636	5815	Casira
7637	5815	Ci??nega de Paicone
7638	5815	Cieneguillas
7639	5815	Cusi Cusi
7640	5815	El Angosto
7641	5815	La Ci??nega
7642	5815	Misarrumi
7643	5815	Oratorio
7644	5815	Paicone
7645	5815	San Juan de Oros
7646	5815	Yoscaba
7647	5816	Catua
7648	5816	Coranzul??
7649	5816	El Toro
7650	5816	Hu??ncar
7651	5816	Jama
7652	5816	Mina Providencia
7653	5816	Olacapato
7654	5816	Olaroz Chico
7655	5816	Pastos Chicos
7656	5816	Puesto Sey
7657	5816	San Juan de Quillaqu??s
7658	5816	Susques
7659	5817	Colonia San Jos??
7660	5817	Huacalera
7661	5817	Juella
7662	5817	Maimar??
7663	5817	Tilcara
7664	5818	B??rcena
7665	5818	El Moreno
7666	5818	Puerta de Colorados
7667	5818	Purmamarca
7668	5818	Tumbaya
7669	5818	Volc??n
7670	5819	Caspal??
7671	5819	Pampichuela
7672	5819	Valle Colorado
7673	5819	Valle Grande
7674	5820	Barrios
7675	5820	Cangrejillos
7676	5820	El C??ndor
7677	5820	La Intermedia
7678	5820	La Quiaca
7679	5820	Llulluchayoc
7680	5820	Pumahuasi
7681	5820	Yavi
7682	5820	Yavi Chico
7683	5821	Doblas
7684	5821	Macach??n
7685	5821	Miguel Riglos
7686	5821	Rol??n
7687	5821	Tom??s Manuel de Anchorena
7688	5822	Anzo??tegui
7689	5822	La Adela
7690	5822	Anguil
7691	5823	Catril??
7692	5823	La Gloria
7693	5823	Lonquimay
7694	5823	Uriburu
7695	5824	Santa Isabel
7696	5825	Bernardo Larroud??
7697	5825	Ceballos
7698	5825	Coronel Hilario Lagos??(Est. Aguas Buenas)
7699	5825	Intendente Alvear
7700	5825	Sarah
7701	5825	V??rtiz
7702	5826	Algarrobo del ??guila
7703	5826	La Humada
7704	5827	Conhelo
7705	5827	Eduardo Castex
7706	5827	Mauricio Mayer
7707	5827	Monte Nievas
7708	5827	Rucanelo
7709	5827	Winifreda
7710	5828	Gobernador Duval
7711	5828	Puelches
7712	5829	Alpachiri
7713	5829	General Manuel J. Campos
7714	5829	Guatrach??
7715	5829	Per??
7716	5829	Santa Teresa
7717	5830	Abramo
7718	5830	Bernasconi
7719	5830	General San Mart??n??(Est. Villa Alba)
7720	5830	Hucal
7721	5830	Jacinto Ar??uz
7722	5831	Cuchillo-C??
7723	5832	La Reforma
7724	5832	Limay Mahuida
7725	5833	Carro Quemado
7726	5833	Loventu??
7727	5833	Luan Toro
7728	5833	Tel??n
7729	5833	Victorica
7730	5834	Agustoni
7731	5834	Dorila
7732	5834	General Pico
7733	5834	Speluzzi
7734	5834	Trebolares
7735	5835	Puel??n
7736	5836	Colonia Bar??n
7737	5836	Miguel Can??
7738	5836	Quem?? Quem??
7739	5836	Relmo
7740	5836	Villa Mirasol
7741	5837	Caleuf??
7742	5837	Ingeniero Foster
7743	5837	La Maruja
7744	5837	Parera
7745	5837	Pichi Huinca
7746	5837	Quetrequ??n
7747	5837	Rancul
7748	5838	Adolfo Van Praet
7749	5838	Alta Italia
7750	5838	Dami??n Maisonave??(Est. Simson)
7751	5838	Embajador Martini
7752	5838	Falucho
7753	5838	Ingeniero Luiggi
7754	5838	Ojeda
7755	5838	Realic??
7756	5839	Cachirulo
7757	5839	Naic??
7758	5839	Toay
7759	5840	Arata
7760	5840	Metileo
7761	5840	Trenel
7762	5841	Ataliva Roca
7763	5841	Chacharramendi
7764	5841	General Acha
7765	5841	Quehu??
7766	5841	Unanu??
7767	5842	Aimogasta
7768	5842	Arauco
7769	5842	Ba??ado de los Pantanos
7770	5842	Estaci??n Maz??n
7771	5842	Termas Santa Teresita
7772	5842	Villa Maz??n
7773	5842	La Rioja
7774	5843	Aminga
7775	5843	Anjull??n
7776	5843	Chuquis
7777	5843	Pinchas
7778	5843	Santa Vera Cruz
7779	5844	Chamical
7780	5844	Polco
7781	5845	Chilecito
7782	5845	Colonia Anguin??n
7783	5845	Colonia Catinzaco
7784	5845	Colonia Malligasta
7785	5845	Colonia Vichigasta
7786	5845	Guanch??n
7787	5845	Malligasta
7788	5845	Miranda
7789	5845	Nonogasta
7790	5845	San Nicol??s
7791	5845	Santa Florentina
7792	5845	Sa??ogasta
7793	5845	Tilimuqui
7794	5845	Vichigasta
7795	5846	Aicu??a
7796	5846	Guandacol
7797	5846	Los Palacios
7798	5846	Pagancillo
7799	5846	Villa Uni??n
7800	5847	Alto Carrizal
7801	5847	Angulos
7802	5847	Bajo Carrizal
7803	5847	Campanas
7804	5847	Cha??armuyo
7805	5847	Famatina
7806	5847	La Cuadra
7807	5847	Pituil
7808	5847	Plaza Vieja
7809	5848	Punta de los Llanos
7810	5848	Tama
7811	5848	Castro Barros
7812	5848	Cha??ar
7813	5848	Olta
7814	5849	Malanz??n
7815	5849	N??cate
7816	5849	Portezuelo
7817	5850	Villa Castelli
7818	5851	Ambil
7819	5851	Colonia Ortiz de Ocampo
7820	5851	Milagro
7821	5851	Olpas
7822	5851	Santa Rita de Catuna
7823	5851	Ulapes
7824	5851	Aman??
7825	5851	Patqu??a
7826	5852	Chepes
7827	5852	Desiderio Tello
7828	5853	Salicas??(- San Blas)
7829	5854	Villa Sanagasta
7830	5855	Jag????
7831	5855	Villa San Jos?? de Vinchina
7832	5855	Mendoza
7833	5855	Bowen
7834	5855	Carmensa
7835	5855	Los Compartos
7836	5856	Godoy Cruz
7837	5857	Colonia Segovia
7838	5857	Guaymall??n??(Villa Nueva)
7839	5857	La Primavera
7840	5857	Los Corralitos
7841	5857	Puente de Hierro
7842	5857	Ingeniero Giagnoni
7843	5857	La Colonia
7844	5857	Los Barriales
7845	5857	Medrano
7846	5857	Phillips
7847	5857	Rodr??guez Pe??a
7848	5857	Desaguadero
7849	5857	Villa Antigua
7850	5858	Blanco Encalada
7851	5858	Jocol??
7852	5858	Las Cuevas
7853	5858	Las Heras
7854	5858	Los Penitentes
7855	5858	Puente del Inca
7856	5858	Punta de Vacas
7857	5858	Uspallata
7858	5858	3 de Mayo
7859	5858	Barrio Alto del Olvido
7860	5858	Barrio Jocol?? II
7861	5858	Barrio La Palmera
7862	5858	Barrio La Pega
7863	5858	Barrio Lagunas de Bartoluzzi
7864	5858	Barrio Los Jarilleros
7865	5858	Barrio Los Olivos
7866	5858	Barrio Virgen del Rosario
7867	5858	Costa de Araujo
7868	5858	El Paramillo
7869	5858	El Vergel
7870	5858	Ingeniero Gustavo Andr??
7871	5858	Jocol?? Viejo
7872	5858	Las Violetas
7873	5858	Villa Tulumaya
7874	5859	Agrelo
7875	5859	Barrio Perdriel IV
7876	5859	Cacheuta
7877	5859	Costa Flores
7878	5859	El Carrizal
7879	5859	El Salto
7880	5859	Las Compuertas
7881	5859	Las Vegas
7882	5859	Luj??n de Cuyo
7883	5859	Perdriel
7884	5859	Potrerillos
7885	5859	Ugarteche
7886	5859	Barrancas
7887	5859	Barrio Jes??s de Nazaret
7888	5859	Cruz de Piedra
7889	5859	El Pedregal
7890	5859	Fray Luis Beltr??n
7891	5859	Rodeo del Medio
7892	5859	Russell
7893	5859	Villa Teresa
7894	5860	Agua Escondida
7895	5860	Las Le??as
7896	5860	Malarg??e
7897	5860	Andrade
7898	5860	Barrio Cooperativa Los Campamentos
7899	5860	Barrio Rivadavia
7900	5860	El Mirador
7901	5860	La Central
7902	5860	La Florida
7903	5860	La Libertad
7904	5860	Los ??rboles
7905	5860	Los Campamentos
7906	5860	Mundo Nuevo
7907	5860	Reducci??n de Abajo
7908	5860	Rivadavia
7909	5860	Santa Mar??a de Oro
7910	5861	Barrio Carrasco
7911	5861	Barrio El Cepillo
7912	5861	Eugenio Bustos
7913	5861	La Consulta
7914	5861	Pareditas
7915	5861	Alto Verde
7916	5861	Barrio Chivilcoy
7917	5861	Barrio Emanuel
7918	5861	Barrio la Estaci??n
7919	5861	Barrio Los Charabones
7920	5861	Barrio Nuestra Se??ora de F??tima
7921	5861	Chapanay
7922	5861	El Espino
7923	5861	Montecaseros
7924	5861	Nueva California??(Est. Moluches)
7925	5861	Tres Porte??as
7926	5862	Barrio Campos El Toledano
7927	5862	Barrio El Nevado
7928	5862	Barrio Empleados de Comercio
7929	5862	Barrio Intendencia
7930	5862	Capit??n Montoya
7931	5862	Cuadro Benegas
7932	5862	El Nihuil
7933	5862	El Sosneado
7934	5862	El Tropez??n
7935	5862	Goudge
7936	5862	Jaime Prats
7937	5862	La Llave Nueva
7938	5862	Las Malvinas
7939	5862	Los Reyunos
7940	5862	Monte Com??n
7941	5862	Pobre Diablo
7942	5862	Rama Ca??da
7943	5862	Real del Padre
7944	5862	Salto de las Rosas
7945	5862	San Rafael
7946	5862	Villa Atuel
7947	5862	Villa Atuel Norte
7948	5862	Barrio 12 de Octubre
7949	5862	Barrio Mar??a Auxiliadora
7950	5862	Barrio Molina Cabrera
7951	5862	La Dormida
7952	5862	Las Catitas
7953	5863	Barrio San Cayetano
7954	5863	Campo Los Andes
7955	5863	Colonia Las Rosas
7956	5863	Los Sauces
7957	5863	Tunuy??n
7958	5863	Vista Flores
7959	5864	Barrio Belgrano Norte
7960	5864	Cord??n del Plata
7961	5864	El Peral
7962	5864	El Zampal
7963	5864	La Arboleda
7964	5864	Tupungato
7965	5865	Ap??stoles
7966	5865	Azara
7967	5865	Barrio Rural
7968	5865	Estaci??n Ap??stoles
7969	5865	Pindapoy
7970	5865	Rinc??n de Azara??(Puerto Azara)
7971	5865	Tres Capones
7972	5866	Arist??bulo del Valle
7973	5866	Campo Grande
7974	5866	Dos de Mayo
7975	5866	Dos de Mayo N??cleo III??(Barrio Bernardino Rivadavia)
7976	5866	Kil??metro 17
7977	5866	Pueblo Illia
7978	5866	Salto Encantado
7979	5867	Barrio del Lago
7980	5867	Candelaria
7981	5867	Cerro Cor??
7982	5867	M??rtires
7983	5867	Profundidad
7984	5867	Puerto Santa Ana
7985	5867	Barrio Nuevo Garupa
7986	5867	Garup??
7987	5867	Nemesio Parma
7988	5867	Posadas
7989	5867	Posadas (Expansi??n)
7990	5867	Barra Concepci??n
7991	5867	Concepci??n de la Sierra
7992	5867	La Corita
7993	5868	9 de Julio Kil??metro 20??(Nueve de Julio Kil??metro 20)
7994	5868	9 de Julio Kil??metro 28??(Nueve de Julio Kil??metro 28)
7995	5868	Colonia Victoria
7996	5868	Eldorado
7997	5868	Mar??a Magdalena??(Colonia Delicia)
7998	5868	Nueva Delicia
7999	5868	Puerto Mado
8000	5868	Puerto Pinares
8001	5868	Santiago de Liniers
8002	5868	Villa Roulet
8003	5869	Bernardo de Irigoyen
8004	5869	Caburei
8005	5869	Comandante Andresito??(Almirante Brown)
8006	5869	Dos Hermanas
8007	5869	Integraci??n
8008	5869	Pi??alito Norte
8009	5869	Puerto Andresito
8010	5869	Puerto Deseado
8011	5870	El Soberbio
8012	5870	Fracr??n
8013	5871	Colonia Wanda
8014	5871	Puerto Esperanza
8015	5871	Puerto Iguaz??
8016	5871	Puerto Libertad
8017	5871	Villa Cooperativa
8018	5871	Arroyo del Medio
8019	5871	Ca?? - Yar??
8020	5871	Cerro Azul
8021	5871	Gobernador L??pez
8022	5871	Olegario V. Andrade
8023	5871	Villa Libertad (Municipio Ca?? Yar??)
8024	5871	Capiov??
8025	5871	Copiovici??o
8026	5871	El Alc??zar
8027	5871	Garuhap??
8028	5871	Mbopicu??
8029	5871	Puerto Leoni
8030	5871	Puerto Rico
8031	5871	Ruiz de Montoya
8032	5871	San Alberto
8033	5871	San Gotardo
8034	5871	San Miguel??(Garuhap??-Mi)
8035	5871	Villa Akerman
8036	5871	Villa Urrutia
8037	5872	Barrio Cuatro Bocas
8038	5872	Barrio Guatamb??
8039	5872	Barrio It??
8040	5872	Caraguatay
8041	5872	Laharrague
8042	5872	Montecarlo
8043	5872	Piray Kil??metro 18
8044	5872	Puerto Piray
8045	5872	Tarum??
8046	5872	Villa Parodi
8047	5873	Barrio Escuela 461
8048	5873	Barrio Escuela 633
8049	5873	Campo Ram??n
8050	5873	Campo Viera
8051	5873	Colonia Alberdi
8052	5873	Guaran??
8053	5873	Los Helechos
8054	5873	Ober??
8055	5873	Panamb??
8056	5873	Panamb?? Kil??metro 15
8057	5873	Panamb?? Kil??metro 8
8058	5873	Villa Bonita
8059	5874	Barrio Tungoil
8060	5874	Colonia Polana
8061	5874	Corpus
8062	5874	Domingo Savio
8063	5874	General Urquiza
8064	5874	Gobernador Roca
8065	5874	Helvecia??(Barrio Eva Per??n)
8066	5874	Hip??lito Yrigoyen
8067	5874	Jard??n Am??rica
8068	5874	Oasis
8069	5874	Roca Chica
8070	5874	San Ignacio
8071	5874	Santo Pip??
8072	5874	Itacaruar??
8073	5874	Moj??n Grande
8074	5874	San Javier
8075	5874	Cruce Caballero
8076	5874	Para??so
8077	5874	Pi??alito Sur
8078	5874	Tobuna
8079	5874	Alba Posse
8080	5874	Alicia Alta
8081	5874	Alicia Baja
8082	5874	Colonia Aurora
8083	5874	San Francisco de As??s
8084	5874	Santa Rita
8085	5875	Alumin??
8086	5875	Moquehue
8087	5875	Villa Pehuenia
8088	5876	Aguada San Roque
8089	5876	A??elo
8090	5876	San Patricio del Cha??ar
8091	5877	Las Coloradas
8092	5878	Chos Malal
8093	5878	Tricao Malal
8094	5878	Villa del Curi Leuv??
8095	5879	Piedra del ??guila
8096	5879	Santo Tom??s
8097	5880	11 de Octubre
8098	5880	Barrio Ruca Luh??
8099	5880	Centenario
8100	5880	Cutral C??
8101	5880	El Choc??n??(Barrio Llequen)
8102	5880	Mari Menuco
8103	5880	Neuqu??n
8104	5880	Plaza Huincul
8105	5880	Plottier
8106	5880	Senillosa
8107	5880	Villa El Choc??n
8108	5880	Vista Alegre Norte
8109	5880	Vista Alegre Sur
8110	5881	Jun??n de los Andes
8111	5882	San Mart??n de los Andes
8112	5882	Villa Lago Meliquina
8113	5883	Chorriaca
8114	5883	Loncopu??
8115	5884	Villa La Angostura
8116	5884	Villa Traful
8117	5884	Andacollo
8118	5884	Huinganco
8119	5884	Las Ovejas
8120	5884	Los Miches
8121	5884	Manzano Amargo
8122	5884	Varvarco
8123	5884	Villa Nahueve
8124	5885	Caviahue
8125	5885	Copahue
8126	5885	El Cholar
8127	5885	El Huec??
8128	5885	Taquimil??n
8129	5886	Buta Ranquil
8130	5886	Octavio Pico
8131	5886	Rinc??n de los Sauces
8132	5887	El Sauce
8133	5887	Paso Aguerre
8134	5887	Pic??n Leuf??
8135	5888	Bajada del Agrio
8136	5888	La Buitrera
8137	5888	Quili Malal
8138	5889	Los Catutos
8139	5889	Mariano Moreno
8140	5889	Ram??n M. Castro
8141	5889	Zapala
8142	5889	Bah??a Creek
8143	5889	El Juncal
8144	5889	Guardia Mitre
8145	5889	La Lober??a
8146	5889	Loteo Costa de R??o
8147	5889	Pozo Salado
8148	5889	Viedma
8149	5889	Barrio Uni??n
8150	5889	Chelfor??
8151	5889	Chimpay
8152	5889	Choele Choel
8153	5889	Coronel Belisle
8154	5889	Darwin
8155	5889	Lamarque
8156	5889	Luis Beltr??n
8157	5889	Pomona
8158	5890	Arelauquen
8159	5890	Barrio El Pilar
8160	5890	Colonia Suiza
8161	5890	El Foyel
8162	5890	Mallin Ahogado
8163	5890	R??o Villegas
8164	5890	San Carlos de Bariloche
8165	5890	Villa Catedral
8166	5890	Villa Los Coihues
8167	5890	Villa Mascardi
8168	5891	Barrio Colonia Conesa
8169	5891	Barrio Planta Compresora de Gas
8170	5892	Aguada Guzm??n
8171	5892	Cerro Polic??a
8172	5892	El Cuy
8173	5892	Las Perlas
8174	5892	Mencu??
8175	5892	Naupa Huen
8176	5892	Paso C??rdova??(Paso C??rdoba)
8177	5892	Valle Azul
8178	5892	Allen
8179	5892	Barda del Medio
8180	5892	Barrio Blanco
8181	5892	Barrio Calle Ciega N?? 10
8182	5892	Barrio Calle Ciega N?? 6
8183	5892	Barrio Canale
8184	5892	Barrio Chacra Monte
8185	5892	Barrio Costa Este
8186	5892	Barrio Costa Linda
8187	5892	Barrio Costa Oeste
8188	5892	Barrio Destacamento
8189	5892	Barrio El Labrador
8190	5892	Barrio El Maruchito
8191	5892	Barrio El Petr??leo
8192	5892	Barrio Emergente
8193	5892	Barrio F??tima
8194	5892	Barrio Frontera
8195	5892	Barrio Guerrico
8196	5892	Barrio Isla 10
8197	5892	Barrio La Barda
8198	5892	Barrio La Costa (Municipio General Roca)
8199	5892	Barrio La Costa (Municipio Ingeniero Huergo)
8200	5892	Barrio La Defensa
8201	5892	Barrio la Herradura
8202	5892	Barrio La Ribera - Barrio Apycar
8203	5892	Barrio Luisillo
8204	5892	Barrio Mar del Plata
8205	5892	Barrio Mar??a Elvira
8206	5892	Barrio Mo??o Azul
8207	5892	Barrio Mosconi
8208	5892	Barrio Norte (Municipio de Cinco Saltos)
8209	5892	Barrio Pinar
8210	5892	Barrio Porvenir
8211	5892	Barrio Puente 83
8212	5892	Barrio Santa Luc??a
8213	5892	Barrio Santa Rita
8214	5892	Catriel
8215	5892	Cervantes
8216	5892	Chichinales
8217	5892	Cinco Saltos
8218	5892	Cipolletti
8219	5892	Contralmirante Cordero
8220	5892	Ferri
8221	5892	General Enrique Godoy
8222	5892	General Fern??ndez Oro
8223	5892	Ingeniero Luis A. Huergo
8224	5892	Ingeniero Otto Krause
8225	5892	Mainqu??
8226	5892	Paraje Arroy??n??(Bajo San Cayetano)
8227	5892	Pen??nsula Ruca Co
8228	5892	Puente Cero??(Barrio Las Angustias)
8229	5892	Sargento Vidal
8230	5892	Villa Alberdi
8231	5892	Villa del Parque
8232	5892	Villa Manzano
8233	5892	Villa Regina
8234	5892	Comic??
8235	5892	Cona Niyeu
8236	5892	Ministro Ramos Mex??a
8237	5892	Prahuaniyeu
8238	5892	Sierra Colorada
8239	5892	Treneta
8240	5892	Yaminu??
8241	5893	Las Bayas
8242	5893	Mamuel Choique
8243	5893	??orquinc??
8244	5893	Ojos de Agua
8245	5893	R??o Chico??(Est. Cerro Mesa)
8246	5894	Barrio Esperanza
8247	5894	Colonia Juli?? y Echarren
8248	5894	Juventud Unida
8249	5894	Pichi Mahuida
8250	5894	R??o Colorado
8251	5894	Salto Andersen
8252	5895	Ca??ad??n Chileno
8253	5895	Comallo
8254	5895	Dina Huapi
8255	5895	??irihuau
8256	5895	Pilcaniyeu
8257	5895	Pilquiniyeu del Limay
8258	5895	Villa Llanqu??n
8259	5895	El Empalme
8260	5895	Las Grutas
8261	5895	Playas Doradas
8262	5895	Puerto San Antonio Este
8263	5895	Punta Colorada
8264	5895	Saco Viejo
8265	5895	San Antonio Oeste
8266	5895	Sierra Grande
8267	5896	Aguada Cecilio
8268	5896	Arroyo Los Berros
8269	5896	Arroyo Ventana
8270	5896	Nahuel Niyeu
8271	5896	Sierra Pailem??n
8272	5896	Valcheta
8273	5896	Aguada de Guerra
8274	5896	Clemente Onelli
8275	5896	Colan Conhue
8276	5896	El Ca??n
8277	5896	Ingeniero Jacobacci
8278	5896	Los Menucos
8279	5896	Maquinchao
8280	5896	Mina Santa Teresita
8281	5896	Pilquiniyeu
8282	5897	Apolinario Saravia
8283	5897	Ceibalito
8284	5897	Centro 25 de Junio
8285	5897	Coronel Mollinedo
8286	5897	Coronel Olleros
8287	5897	El Quebrachal
8288	5897	Gaona
8289	5897	General Pizarro
8290	5897	Joaqu??n V. Gonz??lez
8291	5897	Las Lajitas
8292	5897	Luis Burela
8293	5897	Macapillo
8294	5897	Nuestra Se??ora de Talavera
8295	5897	Piquete Cabado
8296	5897	R??o del Valle
8297	5897	Tolloche
8298	5898	Cachi
8299	5898	Payogasta
8300	5899	Cafayate
8301	5899	Tolomb??m
8302	5899	Atocha
8303	5899	La Ci??naga y Barrio San Rafael
8304	5899	Las Costas
8305	5899	Salta
8306	5899	Villa San Lorenzo
8307	5900	Cerrillos
8308	5900	Villa Los ??lamos??(- El Congreso - Las Tunas)
8309	5901	Barrio Finca la Maroma
8310	5901	Barrio la Rotonda
8311	5901	Barrio Santa Teresita
8312	5901	Chicoana
8313	5901	El Carril
8314	5901	Campo Santo
8315	5901	Cobos
8316	5901	El Bordo
8317	5901	General G??emes
8318	5902	Aguaray
8319	5902	Campamento Vespucio
8320	5902	Campichuelo
8321	5902	Campo Dur??n
8322	5902	Capiazuti
8323	5902	Carboncito
8324	5902	Coronel Cornejo
8325	5902	Dragones
8326	5902	Embarcaci??n
8327	5902	General Ballivi??n
8328	5902	Hickman
8329	5902	Misi??n Chaque??a
8330	5902	Misi??n El Cruce??(- El Milagro - El Jard??n de San Mart??n)
8331	5902	Misi??n Kil??metro 6
8332	5902	Pacar??
8333	5902	Padre Lozano
8334	5902	Piquirenda
8335	5902	Profesor Salvador Mazza
8336	5902	Tartagal
8337	5902	Tobantirenda
8338	5902	Tranquitas
8339	5902	Yacuy
8340	5903	Guachipas
8341	5904	Iruya
8342	5904	Isla de Ca??as
8343	5904	Pueblo Viejo
8344	5905	La Caldera
8345	5905	Vaqueros
8346	5906	El Jard??n
8347	5906	El Tala
8348	5907	Cobres
8349	5907	La Poma
8350	5908	Ampascachi
8351	5908	Cabra Corral
8352	5908	Talapampa
8353	5909	San Antonio de los Cobres
8354	5909	Santa Rosa de los Pastos Grandes
8355	5909	Tolar Grande
8356	5910	El Galp??n
8357	5910	El Tunal
8358	5910	Lumbreras
8359	5910	Met??n Viejo
8360	5910	R??o Piedras
8361	5910	San Jos?? de Met??n
8362	5910	San Jos?? de Orquera
8363	5911	Molinos
8364	5911	Seclant??s
8365	5912	Aguas Blancas
8366	5912	Colonia Santa Rosa
8367	5912	El Tabacal
8368	5912	Pichanal
8369	5912	San Ram??n de la Nueva Or??n
8370	5912	Urundel
8371	5912	Alto de la Sierra
8372	5912	Capit??n Juan Pag??
8373	5912	Coronel Juan Sol??
8374	5912	Hito 1
8375	5912	La Uni??n
8376	5912	Los Blancos
8377	5912	Pluma de Pato
8378	5912	Santa Victoria Este
8379	5913	Antilla
8380	5913	Copo Quile
8381	5913	El Naranjo
8382	5913	El Potrero??(Apeadero Cochabamba)
8383	5913	Rosario de la Frontera
8384	5913	San Felipe
8385	5914	Campo Quijano
8386	5914	La Merced del Enc??n
8387	5914	La Silleta
8388	5914	Rosario de Lerma
8389	5914	Angastaco
8390	5914	Animan??
8391	5914	El Barrial
8392	5915	Acoyte
8393	5915	Campo La Cruz
8394	5915	Nazareno
8395	5915	Poscaya
8396	5915	Santa Victoria
8397	5916	Villa General San Mart??n??(- Campo Afuera)
8398	5917	Villa El Salvador??(- Villa Sefair)
8399	5918	Barreal??(- Villa Pituil)
8400	5918	Calingasta
8401	5918	Tamber??as
8402	5918	San Juan
8403	5919	Barrio Justo P. Castro IV
8404	5919	Bermejo
8405	5919	Caucete
8406	5919	Las Talas - Los M??danos
8407	5919	Marayes
8408	5919	Pie de Palo
8409	5919	Vallecito
8410	5919	Villa Independencia
8411	5920	Chimbas
8412	5921	Angualasto
8413	5921	Iglesia
8414	5921	Pismanta
8415	5921	Rodeo
8416	5921	Tudcum
8417	5922	El M??dano
8418	5922	Gran China
8419	5922	Huaco
8420	5922	Mogna
8421	5922	Niquivil
8422	5922	Pampa Vieja
8423	5922	San Jos?? de J??chal
8424	5922	Villa Malvinas Argentinas
8425	5922	Villa Mercedes
8426	5922	Alto de Sierra
8427	5922	Colonia Fiorito
8428	5923	Barrio Municipal
8429	5923	Barrio Ruta 40
8430	5923	Carpinter??a
8431	5923	Las Piedritas
8432	5923	Quinto Cuartel
8433	5923	Villa Aberastain??(- La Rinconada)
8434	5923	Villa Barboza??(- Villa Nacusi)
8435	5923	Villa Centenario
8436	5923	Rawson??(Villa Krause)
8437	5923	Villa Bola??os??(M??dano de Oro)
8438	5923	Barrio Sadop??(- Bella Vista)
8439	5923	Dos Acequias??(Est. Los Angacos)
8440	5923	San Isidro??(Est. Los Angacos)
8441	5923	Villa del Salvador
8442	5923	Villa Dominguito??(Est. Puntilla Blanca)
8443	5923	Villa Don Bosco??(Est. Angaco Sud)
8444	5923	Villa San Mart??n
8445	5924	Ca??ada Honda
8446	5924	Cienaguita
8447	5924	Colonia Fiscal
8448	5924	Divisadero
8449	5924	Guanacache
8450	5924	Las Lagunas
8451	5924	Los Berros
8452	5924	Punta del M??dano
8453	5924	Villa Media Agua
8454	5925	Villa Ib????ez
8455	5926	Astica
8456	5926	Balde del Rosario
8457	5926	Chucuma
8458	5926	Los Baldecitos
8459	5926	Usno
8460	5926	Villa San Agust??n
8461	5926	El Enc??n
8462	5926	Tupel??
8463	5926	Villa Borjas??(- La Chimbera)
8464	5926	Villa El Tango
8465	5926	Villa Santa Rosa
8466	5927	Villa Basilio Nievas
8467	5927	Quines
8468	5927	San Francisco del Monte de Oro
8469	5928	Nogol??
8470	5928	Villa de la Quebrada
8471	5928	Villa General Roca
8472	5928	Concar??n
8473	5928	Cortaderas
8474	5928	Naschel
8475	5928	Papagayos
8476	5928	Renca
8477	5928	Tilisarao
8478	5928	Villa Larca
8479	5928	El Trapiche
8480	5928	Estancia Grande
8481	5928	Fraga
8482	5928	La Toma
8483	5928	R??o Grande
8484	5928	Riocito
8485	5929	Juan Jorba
8486	5929	Juan Llerena
8487	5929	Justo Daract
8488	5929	La Punilla
8489	5929	Lavaisse
8490	5929	Naci??n Ranquel
8491	5929	San Jos?? del Morro
8492	5929	Villa Reynolds
8493	5929	Villa Salles
8494	5930	Anchorena
8495	5930	Arizona
8496	5930	Bagual
8497	5930	Batavia
8498	5930	Buena Esperanza
8499	5930	Fort??n El Patria
8500	5930	Fortuna
8501	5930	La Maroma
8502	5930	Los Overos
8503	5930	Mart??n de Loyola
8504	5930	Nahuel Map??
8505	5930	Navia
8506	5930	Nueva Galia
8507	5930	Uni??n
8508	5930	Cerro de Oro
8509	5930	Lafinur
8510	5930	Los Cajones
8511	5930	Santa Rosa del Conlara
8512	5930	Talita
8513	5931	Alto Pelado
8514	5931	Alto Pencoso
8515	5931	Balde
8516	5931	Beazley
8517	5931	Cazador
8518	5931	Chosmes
8519	5931	El Volc??n
8520	5931	Jarilla
8521	5931	Juana Koslay
8522	5931	La Punta
8523	5931	Mosmota
8524	5931	Potrero de los Funes
8525	5931	Salinas del Bebedero
8526	5931	San Jer??nimo
8527	5931	San Luis
8528	5931	Zanjitas
8529	5931	La Vertiente
8530	5931	Las Aguadas
8531	5931	Paso Grande
8532	5931	Potrerillo
8533	5931	Villa de Praga
8534	5932	Comandante Luis Piedrabuena
8535	5932	Puerto Santa Cruz
8536	5933	Caleta Olivia
8537	5933	Ca??ad??n Seco
8538	5933	Fitz Roy
8539	5933	Jaramillo
8540	5933	Koluel Kaike
8541	5933	Pico Truncado
8542	5933	Tellier
8543	5934	28 de Noviembre??(Veintiocho de Noviembre)
8544	5934	El Turbio??(Est. Gobernador Mayer)
8545	5934	Julia Dufour
8546	5934	Mina 3
8547	5934	R??o Gallegos
8548	5934	Rospentek
8549	5934	Yacimientos R??o Turbio
8550	5935	El Calafate
8551	5935	El Chalt??n
8552	5935	Tres Lagos
8553	5936	Los Antiguos
8554	5936	Perito Moreno
8555	5937	Puerto San Juli??n
8556	5938	Bajo Caracoles
8557	5938	Gobernador Gregores
8558	5938	Armstrong
8559	5938	Bouquet
8560	5938	Las Parejas
8561	5938	Las Rosas
8562	5938	Montes de Oca
8563	5938	Tortugas
8564	5939	Arequito
8565	5939	Arteaga
8566	5939	Berabev??
8567	5939	Bigand
8568	5939	Casilda
8569	5939	Chab??s
8570	5939	Cha??ar Ladeado
8571	5939	G??deken
8572	5939	Los Nogales
8573	5939	Los Quirquinchos
8574	5939	San Jos?? de la Esquina
8575	5939	Sanford
8576	5939	Villada
8577	5940	Aldao??(Est. Casablanca)
8578	5940	Ang??lica
8579	5940	Ataliva
8580	5940	Aurelia
8581	5940	Barrios Acapulco y Veracruz
8582	5940	Bauer y Sigel
8583	5940	Bella Italia
8584	5940	Castellanos
8585	5940	Colonia Bicha
8586	5940	Colonia Cello
8587	5940	Colonia Margarita
8588	5940	Colonia Raquel
8589	5940	Coronel Fraga
8590	5940	Egusquiza
8591	5940	Esmeralda
8592	5940	Estaci??n Clucellas
8593	5940	Estaci??n Saguier
8594	5940	Eusebia y Carolina
8595	5940	Eustolia
8596	5940	Frontera
8597	5940	Garibaldi
8598	5940	Humberto Primo
8599	5940	Josefina
8600	5940	Lehmann
8601	5940	Mar??a Juana
8602	5940	Nueva Lehmann
8603	5940	Plaza Clucellas
8604	5940	Plaza Saguier
8605	5940	Presidente Roca
8606	5940	Pueblo Marini
8607	5940	Rafaela
8608	5940	Ramona
8609	5940	Santa Clara de Saguier
8610	5940	Sunchales
8611	5940	Susana
8612	5940	Tacural
8613	5940	Vila
8614	5940	Villa Josefina
8615	5940	Virginia
8616	5940	Zen??n Pereyra
8617	5941	Alcorta
8618	5941	Barrio Arroyo del Medio
8619	5941	Barrio Mitre
8620	5941	Bombal
8621	5941	Ca??ada Rica
8622	5941	Cepeda
8623	5941	Empalme Villa Constituci??n
8624	5941	Firmat
8625	5941	General Gelly
8626	5941	Godoy
8627	5941	Juan Bernab?? Molina
8628	5941	Juncal
8629	5941	La Vanguardia
8630	5941	M??ximo Paz??(Est. Paz)
8631	5941	Pav??n Arriba
8632	5941	Peyrano
8633	5941	Rueda
8634	5941	Sargento Cabral
8635	5941	Stephenson
8636	5941	Theobald
8637	5941	Villa Constituci??n
8638	5942	Cayast??
8639	5942	Helvecia
8640	5942	Los Zapallos
8641	5942	Saladero Mariano Cabal
8642	5942	Santa Rosa de Calchines
8643	5943	Aar??n Castellanos??(Est. Castellanos)
8644	5943	Amen??bar
8645	5943	Cafferata
8646	5943	Ca??ada del Ucle
8647	5943	Carmen
8648	5943	Carreras
8649	5943	Chapuy
8650	5943	Chovet
8651	5943	Christophersen
8652	5943	Diego de Alvear
8653	5943	Elortondo
8654	5943	Hughes
8655	5943	La Chispa
8656	5943	Labordeboy
8657	5943	Lazzarino
8658	5943	Maggiolo
8659	5943	Mar??a Teresa
8660	5943	Melincu????(Est. San Urbano)
8661	5943	Miguel Torres
8662	5943	Murphy
8663	5943	Rufino
8664	5943	San Eduardo
8665	5943	San Francisco de Santa Fe
8666	5943	San Gregorio
8667	5943	Sancti Spiritu
8668	5943	Teodelina
8669	5943	Venado Tuerto
8670	5943	Villa Ca????s
8671	5943	Wheelwright
8672	5944	Arroyo Ceibal
8673	5944	Avellaneda??(Est. Ewald)
8674	5944	Berna
8675	5944	El Araz??
8676	5944	El Rab??n
8677	5944	Florencia
8678	5944	Guadalupe Norte
8679	5944	Ingeniero Chanourdie
8680	5944	La Isleta
8681	5944	La Sarita
8682	5944	Lanteri
8683	5944	Las Garzas
8684	5944	Los Laureles
8685	5944	Malabrigo
8686	5944	Paraje San Manuel
8687	5944	Puerto Reconquista
8688	5944	Reconquista
8689	5944	San Antonio de Obligado
8690	5944	Tacuarend????(Emb. Kil??metro 421)
8691	5944	Villa Ana
8692	5944	Villa Guillermina
8693	5944	Villa Ocampo
8694	5945	Barrio Cicarelli
8695	5945	Bustinza
8696	5945	Ca??ada de G??mez
8697	5945	Carrizales??(Est. Clarke)
8698	5945	Classon
8699	5945	Colonia M??dici
8700	5945	Correa
8701	5945	Largu??a
8702	5945	Lucio V. L??pez
8703	5945	Oliveros
8704	5945	Pueblo Andino
8705	5945	Salto Grande
8706	5945	Serodino
8707	5945	Totoras
8708	5945	Villa Elo??sa
8709	5945	Villa la Rivera (Comuna Oliveros)??(Villa La Ribera)
8710	5945	Villa la Rivera (Comuna Pueblo Andino)??(Villa La Ribera)
8711	5945	??ngel Gallardo
8712	5945	Arroyo Aguiar
8713	5945	Arroyo Leyes
8714	5945	Cabal
8715	5945	Campo Andino
8716	5945	Candioti
8717	5945	Emilia
8718	5945	Laguna Paiva
8719	5945	Llambi Campbell
8720	5945	Monte Vera
8721	5945	Nelson
8722	5945	Paraje Chaco Chico
8723	5945	Paraje La Costa
8724	5945	Rinc??n Potrero
8725	5945	San Jos?? del Rinc??n
8726	5945	Santa Fe
8727	5945	Sauce Viejo
8728	5945	Villa Laura??(Est. Constituyentes)
8729	5946	Cavour
8730	5946	Culul??
8731	5946	Elisa
8732	5946	Empalme San Carlos
8733	5946	Esperanza
8734	5946	Felicia
8735	5946	Franck
8736	5946	Grutly
8737	5946	Hipatia
8738	5946	Humboldt
8739	5946	Jacinto L. Ar??uz
8740	5946	La Pelada
8741	5946	Mar??a Luisa
8742	5946	Matilde
8743	5946	Nuevo Torino
8744	5946	Plaza Matilde
8745	5946	Progreso
8746	5946	Providencia
8747	5946	Sa Pereira
8748	5946	San Carlos Centro
8749	5946	San Carlos Norte
8750	5946	San Carlos Sud
8751	5946	San Jer??nimo del Sauce
8752	5946	San Jer??nimo Norte
8753	5946	San Mariano
8754	5946	Santa Clara de Buena Vista
8755	5946	Esteban Rams
8756	5946	Gato Colorado
8757	5946	Gregoria P??rez de Denis??(Est. El Nochero)
8758	5946	Logro??o
8759	5946	Montefiore
8760	5946	Pozo Borrado
8761	5946	Santa Margarita
8762	5946	Tostado
8763	5946	Villa Minetti
8764	5947	Acebal
8765	5947	Albarellos
8766	5947	??lvarez
8767	5947	Arbilla
8768	5947	Arminda
8769	5947	Arroyo Seco
8770	5947	Carmen del Sauce
8771	5947	Coronel Bogado
8772	5947	Coronel Rodolfo S. Dom??nguez
8773	5947	Cuatro Esquinas
8774	5947	El Caramelo
8775	5947	Fighiera
8776	5947	Funes
8777	5947	General Lagos
8778	5947	Granadero Baigorria
8779	5947	Ibarlucea
8780	5947	Kil??metro 101
8781	5947	Los Muchachos - La Alborada
8782	5947	Monte Flores
8783	5947	P??rez
8784	5947	Pi??ero??(Est. Erasto)
8785	5947	Pueblo Esther
8786	5947	Pueblo Mu??oz??(Est. Bernard)
8787	5947	Pueblo Uranga
8788	5947	Puerto Arroyo Seco
8789	5947	Rosario
8790	5947	Soldini
8791	5947	Villa Amelia
8792	5947	Villa del Plata
8793	5947	Villa Gobernador G??lvez
8794	5947	Zavalla
8795	5948	Aguar?? Grande
8796	5948	Ambrosetti
8797	5948	Arruf??
8798	5948	Balneario La Verde
8799	5948	Capivara
8800	5948	Ceres
8801	5948	Colonia Ana
8802	5948	Colonia Bossi
8803	5948	Colonia Rosa
8804	5948	Constanza
8805	5948	Curupayt??
8806	5948	Hersilia
8807	5948	Huanqueros
8808	5948	La Cabral
8809	5948	La Lucila
8810	5948	La Rubia
8811	5948	Las Avispas
8812	5948	Las Palmeras
8813	5948	Mois??s Ville
8814	5948	Monigotes
8815	5948	??anducita
8816	5948	Palacios
8817	5948	San Crist??bal
8818	5948	San Guillermo
8819	5948	Santurce
8820	5948	Soledad
8821	5948	Suardi
8822	5948	Villa Saralegui
8823	5948	Villa Trinidad
8824	5948	Alejandra
8825	5948	Cacique Ariacaiqu??n
8826	5948	Colonia Dur??n
8827	5948	La Brava
8828	5948	Romang
8829	5949	Arocena
8830	5949	Balneario Monje
8831	5949	Barrio Caima
8832	5949	Barrio El Paca?? - Barrio Comipini
8833	5949	Bernardo de Irigoyen??(Est. Irigoyen)
8834	5949	Casalegno
8835	5949	Centeno
8836	5949	Coronda
8837	5949	Desv??o Arij??n
8838	5949	D??az
8839	5949	Gaboto
8840	5949	G??lvez
8841	5949	Gessler
8842	5949	Irigoyen
8843	5949	Larrechea
8844	5949	Loma Alta
8845	5949	L??pez??(Est. San Mart??n de Tours)
8846	5949	Maciel
8847	5949	Monje
8848	5949	Puerto Arag??n
8849	5949	San Eugenio
8850	5949	San Fabi??n
8851	5949	San Genaro
8852	5949	San Genaro Norte
8853	5949	Angeloni
8854	5949	Cayastacito
8855	5949	Colonia Dolores
8856	5949	Esther
8857	5949	Gobernador Crespo
8858	5949	La Criolla??(Est. Ca??adita)
8859	5949	La Penca y Caraguat??
8860	5949	Marcelino Escalada
8861	5949	Nar??
8862	5949	Pedro G??mez Cello
8863	5949	Ramay??n
8864	5949	San Justo
8865	5949	San Mart??n Norte
8866	5949	Silva??(Est. Abipones)
8867	5949	Vera y Pintado??(Est. Guaran??es)
8868	5949	Videla
8869	5949	Aldao
8870	5949	Capit??n Berm??dez
8871	5949	Carcara????
8872	5949	Coronel Arnold
8873	5949	Fuentes
8874	5949	Luis Palacios??(Est. La Salada)
8875	5949	Puerto General San Mart??n
8876	5949	Pujato
8877	5949	Ricardone
8878	5949	Rold??n
8879	5949	San Jer??nimo Sud
8880	5949	Timb??es
8881	5949	Villa Elvira
8882	5949	Villa Mugueta
8883	5949	Ca??ada Rosqu??n
8884	5949	Carlos Pellegrini
8885	5949	Casas
8886	5949	Castelar
8887	5949	Colonia Belgrano
8888	5949	Crispi
8889	5949	El Tr??bol
8890	5949	Landeta
8891	5949	Las Bandurrias
8892	5949	Las Petacas
8893	5949	Los Cardos
8894	5949	Mar??a Susana
8895	5949	Piamonte
8896	5949	San Jorge
8897	5949	San Mart??n de las Escobas
8898	5949	Sastre
8899	5949	Traill
8900	5949	Wildermuth??(Est. Granadero B. Bustos)
8901	5950	Calchaqu??
8902	5950	Ca??ada Omb??
8903	5950	Colmena
8904	5950	Fort??n Olmos
8905	5950	Garabato
8906	5950	Golondrina
8907	5950	Intiyaco
8908	5950	Kil??metro 115
8909	5950	La Gallareta
8910	5950	Los Amores
8911	5950	Margarita
8912	5950	Paraje 29
8913	5950	Pozo de los Indios
8914	5950	Pueblo Santa Luc??a
8915	5950	Tartagal??(Est. El Tajamar)
8916	5950	Toba
8917	5950	Vera??(Est. Gobernador Vera)
8918	5951	Argentina
8919	5951	Casares
8920	5951	Malbr??n
8921	5951	Villa General Mitre??(Est. Pinto)
8922	5952	Campo Gallo
8923	5952	Coronel Manuel L. Rico
8924	5952	Donadeu
8925	5952	Sach??yoj
8926	5952	Santos Lugares
8927	5953	Estaci??n Atamisqui
8928	5953	Medell??n
8929	5953	Villa Atamisqui
8930	5953	Colonia Dora
8931	5953	Lugones
8932	5953	Real Sayana
8933	5953	Villa Mail??n
8934	5954	Abra Grande
8935	5954	Antaj??
8936	5954	Ardiles
8937	5954	Ca??ada Escobar
8938	5954	Chaupi Pozo
8939	5954	Clodomira
8940	5954	Huyamampa
8941	5954	La Aurora
8942	5954	La D??rsena
8943	5954	Los Quiroga
8944	5954	Los Soria
8945	5954	Tramo 16
8946	5954	Tramo 20
8947	5954	Bandera
8948	5954	Cuatro Bocas
8949	5954	Fort??n Inca
8950	5954	Guardia Escolta
8951	5954	El De??n
8952	5954	El Moj??n
8953	5954	El Zanj??n
8954	5954	Los Cardozos
8955	5954	Maco
8956	5954	Maquito
8957	5954	Morales
8958	5954	Puesto de San Antonio
8959	5954	Santiago del Estero
8960	5954	Vuelta de la Barranca
8961	5954	Yanda
8962	5955	Ancaj??n
8963	5955	Estaci??n La Punta
8964	5955	Fr??as
8965	5955	Villa La Punta
8966	5956	El Cabur??
8967	5956	La Firmeza
8968	5956	Los Pirpintos
8969	5956	Los Tigres
8970	5956	Monte Quemado
8971	5956	Nueva Esperanza
8972	5956	Pampa de los Guanacos
8973	5956	San Jos?? del Boquer??n
8974	5956	Uruta??
8975	5957	Bandera Bajada
8976	5957	Caspi Corral
8977	5957	Colonia San Juan
8978	5957	El Crucero
8979	5957	Kil??metro 30
8980	5957	La Ca??ada
8981	5957	La Invernada
8982	5957	Minerva
8983	5957	Vaca Hua??una
8984	5957	Villa Figueroa
8985	5958	A??atuya
8986	5958	Aver??as
8987	5958	Estaci??n Taca??itas
8988	5958	La Nena
8989	5958	Los Jur??es
8990	5958	Tom??s Young
8991	5960	El Arenal
8992	5960	El Bobadal
8993	5960	El Charco
8994	5960	Gramilla
8995	5960	Isca Yacu
8996	5960	Isca Yacu Semaul
8997	5960	Pozo Hondo
8998	5961	El Cuadrado
8999	5961	Matar??
9000	5961	Suncho Corral
9001	5961	Vilelas
9002	5961	Yuch??n
9003	5962	Villa San Mart??n??(Est. Loreto)
9004	5963	Aerolito
9005	5963	Alhuampa
9006	5963	Hasse
9007	5963	Hern??n Mej??a Miraval
9008	5963	Las Tinajas
9009	5963	Lilo Viejo
9010	5963	Patay
9011	5963	Pueblo Pablo Torelo??(Est. Otumpa)
9012	5963	Quimil??
9013	5963	Roversi
9014	5963	Tintina
9015	5963	Weisburd
9016	5964	El 49
9017	5964	Sol de Julio
9018	5964	Villa Ojo de Agua
9019	5964	Las Delicias
9020	5964	Pozo Betbeder
9021	5964	Rapelli
9022	5965	Ram??rez de Velazco
9023	5965	Sumampa
9024	5965	Sumampa Viejo
9025	5966	Cha??ar Pozo de Abajo
9026	5966	Chauchillas
9027	5966	Colonia Tinco
9028	5966	La Nueva Donosa
9029	5966	Los Miranda
9030	5966	Los N????ez
9031	5966	Mansupa
9032	5966	Pozuelos
9033	5966	Rodeo de Valdez
9034	5966	Termas de R??o Hondo
9035	5966	Villa Gim??nez
9036	5966	Villa R??o Hondo
9037	5966	Villa Tur??stica del Embalse
9038	5966	Vinar??
9039	5966	Colonia Alpina
9040	5966	Palo Negro
9041	5966	Selva
9042	5967	Beltr??n
9043	5967	Colonia El Simbolar
9044	5967	Fern??ndez
9045	5967	Ingeniero Forres??(Est. Chaguar Punco)
9046	5967	Vilmer
9047	5968	Chilca Juliana
9048	5968	Los Telares
9049	5968	Villa Salavina
9050	5968	Brea Pozo
9051	5968	Estaci??n Robles
9052	5968	Estaci??n Taboada
9053	5968	Garza
9054	5969	??rraga
9055	5969	Nueva Francia
9056	5969	Simbol
9057	5969	Sumamao
9058	5969	Villa Sil??pica
9059	5970	Tolhuin
9060	5971	Laguna Escondida
9061	5971	Ushuaia
9062	5972	7 de Abril??(Siete de Abril)
9063	5972	Barrio San Jorge
9064	5972	El Cha??ar
9065	5972	Garmendia
9066	5972	Macomitas
9067	5972	Piedrabuena
9068	5972	Villa Benjam??n Ar??oz
9069	5972	Villa Burruyac??
9070	5972	Villa Padre Monti
9071	5972	San Miguel de Tucum??n??(Est. Tucum??n)
9072	5973	Arcadia
9073	5973	Barrio San Roque
9074	5973	Iltico
9075	5973	Medinas
9076	5974	Alderetes
9077	5974	Banda del R??o Sal??
9078	5974	Colombres
9079	5974	Colonia Mayo - Barrio La Milagrosa
9080	5974	Delf??n Gallo
9081	5974	El Bracho
9082	5974	Las Cejas
9083	5974	Los Ralos
9084	5974	Ranchillos
9085	5974	San Andr??s
9086	5975	Barrio Casa Rosada
9087	5975	Campo de Herrera
9088	5975	Famaill??
9089	5975	Ingenio Fronterita
9090	5976	Graneros
9091	5976	Taco Ralo
9092	5977	Juan Bautista Alberdi
9093	5977	Villa Belgrano
9094	5978	La Cocha
9095	5978	San Jos?? de La Cocha
9096	5979	Estaci??n Ar??oz
9097	5979	Los Puestos
9098	5979	Manuel Garc??a Fern??ndez
9099	5979	Pala Pala
9100	5979	Santa Rosa de Leales
9101	5979	Villa de Leales
9102	5979	Villa Fiad??(- Ingenio Leales)
9103	5980	Barrio San Felipe
9104	5980	El Manantial
9105	5980	Ingenio San Pablo
9106	5980	La Reducci??n
9107	5980	Lules
9108	5981	Acheral
9109	5981	Capit??n C??ceres
9110	5981	Monteros
9111	5981	Pueblo Independencia??(Santa Rosa y Los Rojo)
9112	5981	R??o Seco
9113	5981	Sargento Moya
9114	5981	Soldado Maldonado
9115	5981	Teniente Berdina
9116	5981	Villa Quinteros
9117	5981	Aguilares
9118	5981	Los Sarmientos
9119	5981	R??o Chico
9120	5981	Villa Clodomiro Hileret
9121	5982	Monteagudo
9122	5982	Nueva Trinidad
9123	5982	Simoca
9124	5982	Villa Chicligasta
9125	5983	Amaicha del Valle
9126	5983	Colalao del Valle
9127	5983	El Mollar
9128	5983	Taf?? del Valle
9129	5984	Barrio El Cruce
9130	5984	Barrio Lomas de Taf??
9131	5984	Barrio Mutual San Mart??n
9132	5984	Barrio Parada 14
9133	5984	Barrio U.T.A. II
9134	5984	Diagonal Norte??(- Luz y Fuerza - Los Pocitos - Villa Nueva Italia)
9135	5984	El Cadillal
9136	5984	Taf?? Viejo
9137	5984	Villa Las Flores
9138	5984	Villa Mariano Moreno??(- El Colmenar)
9139	5985	Choromoro
9140	5985	San Pedro de Colalao
9141	5985	Villa de Trancas
9142	5986	Barrio San Jos?? III
9143	5986	Villa Carmela??(Cebil Redondo)
0	0	No Determinado
\.


--
-- TOC entry 2609 (class 0 OID 33514)
-- Dependencies: 242
-- Data for Name: estadocivil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estadocivil (idestadocivil, descripcion) FROM stdin;
1	Soltero(a)
2	Casado(a)
3	Conviviente
4	Viudo(a)
5	Divorciado(a)
0	No Determinado
\.


--
-- TOC entry 2611 (class 0 OID 33520)
-- Dependencies: 244
-- Data for Name: gradoinstruccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gradoinstruccion (idgradoinstruccion, descripcion) FROM stdin;
1	Superior Univesitario
2	Superior Tecnico
3	Secundaria Completa
4	Secundaria Incompleta
5	Primaria Completa
6	Primaria Incompleta
9	Educaci??n Inicial
7	Sin Instrucci??n
8	Ninguno
0	No Determinado
\.


--
-- TOC entry 2613 (class 0 OID 33526)
-- Dependencies: 246
-- Data for Name: idiomas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.idiomas (idioma_id, idioma_codigo, idioma_descripcion, estado, por_defecto) FROM stdin;
1	es        	Espa??ol	A	S
2	en        	Ingl??s	A	N
\.


--
-- TOC entry 2615 (class 0 OID 33533)
-- Dependencies: 248
-- Data for Name: nivel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nivel (idnivel, descripcion, estado, idtipocargo) FROM stdin;
1	ASOCIACI??N GENERAL	1	2
2	DIVISI??N	1	2
4	UNI??N	1	2
8	ASOCIACION GENERAL	1	1
6	DISTRITO MISIONERO	0	2
5	ASOCIACI??N	1	2
9	DIVISI??N	1	1
11	UNI??N	1	1
12	ASOCIACI??N	1	1
13	DISTRITO MISIONERO	0	1
14	IGLESIA	1	1
7	IGLESIA	1	2
10	PA??S	0	1
3	PAIS	0	2
\.


--
-- TOC entry 2617 (class 0 OID 33539)
-- Dependencies: 250
-- Data for Name: ocupacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ocupacion (idocupacion, descripcion) FROM stdin;
2	Alba??il
4	Carpintero
5	Chofer
6	Colportor
7	Comerciante
12	Estudiante
13	Evanista
14	Fisioterapia
15	Independiente
16	Ingeniero
17	Masoterapia
18	Mec??nico
19	Medico
21	Modista
23	Otro
24	Panadero
25	Pastor
26	Peluquero
27	Periodista
29	Sastre
30	Su Casa
31	Zapatero
33	Agricultor
1	Abogado
3	Campesino
8	Desocupado
9	Empleado
10	Empresario
11	Enfermera
28	Profesor
32	Contador
0	No Determinado
22	Obrero Misionero
\.


--
-- TOC entry 2619 (class 0 OID 33545)
-- Dependencies: 252
-- Data for Name: pais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pais (idpais, descripcion) FROM stdin;
1	Alemania
2	Argentina
3	Australia
4	Bolivia
5	Brasil
6	Canada
7	Chile
8	China
9	Colombia
10	Corea
11	Costa Rica
12	Cuba
13	Ecuador
14	Egipto
15	El Salvador
16	Espa??a
17	Estados Unidos
18	Francia
19	Guatemala
20	Haiti
21	Holanda
22	Honduras
23	Inglaterra
24	Italia
25	Japon
26	Mexico
27	Nicaragua
28	Noruega
29	Nueva Zelanda
30	Panama
31	Paraguay
33	Portugal
34	Puerto Rico
35	Republica Dominicana
36	Rusia
37	Uruguay
38	Venezuela
32	Per??
0	No Determinado
\.


--
-- TOC entry 2621 (class 0 OID 33551)
-- Dependencies: 254
-- Data for Name: parentesco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parentesco (idparentesco, descripcion, estado) FROM stdin;
1	Esposo(a)	1
2	Hijo(a)	1
3	T??o(a)	1
4	Pap??	1
5	Mam??	1
6	Abuelo(a)	1
7	Sobrino(a)	1
8	Suegro(a)	1
9	Yerno	1
10	Nuera	1
11	Nieto(a)	1
12	Hermano(a)	1
13	Cu??ado(a)	1
\.


--
-- TOC entry 2623 (class 0 OID 33557)
-- Dependencies: 256
-- Data for Name: procesos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procesos (proceso_id, proceso_total_elementos_procesar, proceso_numero_elementos_procesados, proceso_porcentaje_actual_progreso, proceso_fecha_comienzo, proceso_fecha_actualizacion, proceso_tiempo_transcurrido) FROM stdin;
\.


--
-- TOC entry 2625 (class 0 OID 33562)
-- Dependencies: 258
-- Data for Name: provincia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provincia (idprovincia, iddepartamento, descripcion) FROM stdin;
1	1	CHACHAPOYAS
2	1	BAGUA
3	1	BONGARA
4	1	CONDORCANQUI
5	1	LUYA
6	1	RODRIGUEZ DE MENDOZA
7	1	UTCUBAMBA
8	2	HUARAZ
9	2	AIJA
10	2	ANTONIO RAYMONDI
11	2	ASUNCION
12	2	BOLOGNESI
13	2	CARHUAZ
14	2	CARLOS FERMIN FITZCARRALD
15	2	CASMA
16	2	CORONGO
17	2	HUARI
18	2	HUARMEY
19	2	HUAYLAS
20	2	MARISCAL LUZURIAGA
21	2	OCROS
22	2	PALLASCA
23	2	POMABAMBA
24	2	RECUAY
25	2	SANTA
26	2	SIHUAS
27	2	YUNGAY
28	3	ABANCAY
29	3	ANDAHUAYLAS
30	3	ANTABAMBA
31	3	AYMARAES
32	3	COTABAMBAS
33	3	CHINCHEROS
34	3	GRAU
35	4	AREQUIPA
36	4	CAMANA
37	4	CARAVELI
38	4	CASTILLA
39	4	CAYLLOMA
40	4	CONDESUYOS
41	4	ISLAY
42	4	LA UNION
43	5	HUAMANGA
44	5	CANGALLO
45	5	HUANCA SANCOS
46	5	HUANTA
47	5	LA MAR
48	5	LUCANAS
49	5	PARINACOCHAS
50	5	PAUCAR DEL SARA SARA
51	5	SUCRE
52	5	VICTOR FAJARDO
53	5	VILCAS HUAMAN
54	6	CAJAMARCA
55	6	CAJABAMBA
56	6	CELENDIN
57	6	CHOTA
58	6	CONTUMAZA
59	6	CUTERVO
60	6	HUALGAYOC
61	6	JAEN
62	6	SAN IGNACIO
63	6	SAN MARCOS
64	6	SAN MIGUEL
65	6	SAN PABLO
66	6	SANTA CRUZ
67	7	CALLAO
68	8	CUSCO
69	8	ACOMAYO
70	8	ANTA
71	8	CALCA
72	8	CANAS
73	8	CANCHIS
74	8	CHUMBIVILCAS
75	8	ESPINAR
76	8	LA CONVENCION
77	8	PARURO
78	8	PAUCARTAMBO
79	8	QUISPICANCHI
80	8	URUBAMBA
81	9	HUANCAVELICA
82	9	ACOBAMBA
83	9	ANGARAES
84	9	CASTROVIRREYNA
85	9	CHURCAMPA
86	9	HUAYTARA
87	9	TAYACAJA
88	10	HUANUCO
89	10	AMBO
90	10	DOS DE MAYO
91	10	HUACAYBAMBA
92	10	HUAMALIES
93	10	LEONCIO PRADO
94	10	MARA??ON
95	10	PACHITEA
96	10	PUERTO INCA
97	10	LAURICOCHA
98	10	YAROWILCA
99	11	ICA
100	11	CHINCHA
101	11	NAZCA
102	11	PALPA
103	11	PISCO
104	12	HUANCAYO
105	12	CONCEPCION
106	12	CHANCHAMAYO
107	12	JAUJA
108	12	JUNIN
109	12	SATIPO
110	12	TARMA
111	12	YAULI
112	12	CHUPACA
113	13	TRUJILLO
114	13	ASCOPE
115	13	BOLIVAR
116	13	CHEPEN
117	13	JULCAN
118	13	OTUZCO
119	13	PACASMAYO
120	13	PATAZ
121	13	SANCHEZ CARRION
122	13	SANTIAGO DE CHUCO
123	13	GRAN CHIMU
124	13	VIRU
125	14	CHICLAYO
126	14	FERRE??AFE
127	14	LAMBAYEQUE
128	15	LIMA
129	15	BARRANCA
130	15	CAJATAMBO
131	15	CANTA
132	15	CA??ETE
133	15	HUARAL
134	15	HUAROCHIRI
135	15	HUAURA
136	15	OYON
137	15	YAUYOS
138	16	MAYNAS
139	16	ALTO AMAZONAS
140	16	LORETO
141	16	MARISCAL RAMON CASTILLA
142	16	REQUENA
143	16	UCAYALI
144	16	DATEM DEL MARA??ON
145	17	TAMBOPATA
146	17	MANU
147	17	TAHUAMANU
148	18	MARISCAL NIETO
149	18	GENERAL SANCHEZ CERRO
150	18	ILO
151	19	PASCO
152	19	DANIEL ALCIDES CARRION
153	19	OXAPAMPA
154	20	PIURA
155	20	AYABACA
156	20	HUANCABAMBA
157	20	MORROPON
158	20	PAITA
159	20	SULLANA
160	20	TALARA
161	20	SECHURA
162	21	PUNO
163	21	AZANGARO
164	21	CARABAYA
165	21	CHUCUITO
166	21	EL COLLAO
167	21	HUANCANE
168	21	LAMPA
169	21	MELGAR
170	21	MOHO
171	21	SAN ANTONIO DE PUTINA
172	21	SAN ROMAN
173	21	SANDIA
174	21	YUNGUYO
175	22	MOYOBAMBA
176	22	BELLAVISTA
177	22	EL DORADO
178	22	HUALLAGA
179	22	LAMAS
180	22	MARISCAL CACERES
181	22	PICOTA
182	22	RIOJA
183	22	SAN MARTIN
184	22	TOCACHE
185	23	TACNA
186	23	CANDARAVE
187	23	JORGE BASADRE
188	23	TARATA
189	24	TUMBES
190	24	CONTRALMIRANTE VILLAR
191	24	ZARUMILLA
192	25	CORONEL PORTILLO
193	25	ATALAYA
194	25	PADRE ABAD
195	25	PURUS
203	32	Arica
204	32	Parinacota
205	33	Iquique
206	33	Tamarugal
207	34	Antofagasta
208	34	El Loa
209	34	Tocopilla
210	35	Copiap??
211	35	Cha??aral
212	35	Huasco
213	36	Elqui
214	36	Choapa
215	36	Limar??
216	37	Valpara??so
217	37	Isla de Pascua
218	37	Los Andes
219	37	Petorca
220	37	Quillota
221	37	San Antonio
222	37	San Felipe de Aconcagua
223	37	Marga Marga
224	38	Cachapoal
225	38	Cardenal Caro
226	38	Colchagua
227	39	Talca
228	39	Cauquenes
229	39	Curic??
230	39	Linares
231	40	Concepci??n
232	40	Arauco
233	40	Biob??o
234	40	??uble
235	41	Caut??n
236	41	Malleco
237	42	Valdivia
238	42	Ranco
239	43	Llanquihue
240	43	Chilo??
241	43	Osorno
242	43	Palena
243	44	Coihaique
244	44	Ais??n
245	44	Capit??n Prat
246	44	General Carrera
247	45	Magallanes
248	45	Ant??rtica Chilena
249	45	Tierra del Fuego
250	45	??ltima Esperanza
251	46	Santiago
252	46	Cordillera
253	46	Chacabuco
254	46	Maipo
255	46	Melipilla
256	46	Talagante
257	47	MEDELLIN
258	47	ABEJORRAL
259	47	ABRIAQUI
260	47	ALEJANDRIA
261	47	AMAGA
262	47	AMALFI
263	47	ANDES
264	47	ANGELOPOLIS
265	47	ANGOSTURA
266	47	ANORI
267	47	ANTIOQUIA
268	47	ANZA
269	47	APARTADO
270	47	ARBOLETES
271	47	ARGELIA
272	47	ARMENIA
273	47	BARBOSA
274	47	BELMIRA
275	47	BELLO
276	47	BETANIA
277	47	BETULIA
278	47	BOLIVAR
279	47	BRICE??O
280	47	BURITICA
281	47	CACERES
282	47	CAICEDO
283	47	CALDAS
284	47	CAMPAMENTO
285	47	CA??ASGORDAS
286	47	CARACOLI
287	47	CARAMANTA
288	47	CAREPA
289	47	CARMEN DE VIBORAL
290	47	CAROLINA
291	47	CAUCASIA
292	47	CHIGORODO
293	47	CISNEROS
294	47	COCORNA
295	47	CONCEPCION
296	47	CONCORDIA
297	47	COPACABANA
298	47	DABEIBA
299	47	DON MATIAS
300	47	EBEJICO
301	47	EL BAGRE
302	47	ENTRERRIOS
303	47	ENVIGADO
304	47	FREDONIA
305	47	FRONTINO
306	47	GIRALDO
307	47	GIRARDOTA
308	47	GOMEZ PLATA
309	47	GRANADA
310	47	GUADALUPE
311	47	GUARNE
312	47	GUATAPE
313	47	HELICONIA
314	47	HISPANIA
315	47	ITAGUI
316	47	ITUANGO
317	47	JARDIN
318	47	JERICO
319	47	LA CEJA
320	47	LA ESTRELLA
321	47	LA PINTADA
322	47	LA UNION
323	47	LIBORINA
324	47	MACEO
325	47	MARINILLA
326	47	MONTEBELLO
327	47	MURINDO
328	47	MUTATA
329	47	NARI??O
330	47	NECOCLI
331	47	NECHI
332	47	OLAYA
333	47	PE??OL
334	47	PEQUE
335	47	PUEBLORRICO
336	47	PUERTO BERRIO
337	47	PUERTO NARE (LA MAGDALENA)
338	47	PUERTO TRIUNFO
339	47	REMEDIOS
340	47	RETIRO
341	47	RIONEGRO
342	47	SABANALARGA
343	47	SABANETA
344	47	SALGAR
345	47	SAN ANDRES
346	47	SAN CARLOS
347	47	SAN FRANCISCO
348	47	SAN JERONIMO
349	47	SAN JOSE DE LA MONTA??A
350	47	SAN JUAN DE URABA
351	47	SAN LUIS
352	47	SAN PEDRO
353	47	SAN PEDRO DE URABA
354	47	SAN RAFAEL
355	47	SAN ROQUE
356	47	SAN VICENTE
357	47	SANTA BARBARA
358	47	SANTA ROSA DE OSOS
359	47	SANTO DOMINGO
360	47	SANTUARIO
361	47	SEGOVIA
362	47	SONSON
363	47	SOPETRAN
364	47	TAMESIS
365	47	TARAZA
366	47	TARSO
367	47	TITIRIBI
368	47	TOLEDO
369	47	TURBO
370	47	URAMITA
371	47	URRAO
372	47	VALDIVIA
373	47	VALPARAISO
374	47	VEGACHI
375	47	VENECIA
376	47	VIGIA DEL FUERTE
377	47	YALI
378	47	YARUMAL
379	47	YOLOMBO
380	47	YONDO
381	47	ZARAGOZA
382	48	BARRANQUILLA (DISTRITO ESPECIAL, INDUSTRIAL Y PORTUARIO DE BARRANQUILLA)
383	48	BARANOA
384	48	CAMPO DE LA CRUZ
385	48	CANDELARIA
386	48	GALAPA
387	48	JUAN DE ACOSTA
388	48	LURUACO
389	48	MALAMBO
390	48	MANATI
391	48	PALMAR DE VARELA
392	48	PIOJO
393	48	POLO NUEVO
394	48	PONEDERA
395	48	PUERTO COLOMBIA
396	48	REPELON
397	48	SABANAGRANDE
398	48	SANTA LUCIA
399	48	SANTO TOMAS
400	48	SOLEDAD
401	48	SUAN
402	48	TUBARA
403	48	USIACURI
404	49	SANTA FE DE BOGOTA, D. C.
405	49	SANTAFE DE BOGOTA D.C.- USAQUEN
406	49	SANTAFE DE BOGOTA D.C.- CHAPINERO
407	49	SANTAFE DE BOGOTA D.C.- SANTA FE
408	49	SANTAFE DE BOGOTA D.C.- SAN CRISTOBAL
409	49	SANTAFE DE BOGOTA D.C.- USME
410	49	SANTAFE DE BOGOTA D.C.- TUNJUELITO
411	49	SANTAFE DE BOGOTA D.C.- BOSA
412	49	SANTAFE DE BOGOTA D.C.- KENNEDY
413	49	SANTAFE DE BOGOTA D.C.- FONTIBON
414	49	SANTAFE DE BOGOTA D.C.- ENGATIVA
415	49	SANTAFE DE BOGOTA D.C.- SUBA
416	49	SANTAFE DE BOGOTA D.C.- BARRIOS UNIDOS
417	49	SANTAFE DE BOGOTA D.C.- TEUSAQUILLO
418	49	SANTAFE DE BOGOTA D.C.- MARTIRES
419	49	SANTAFE DE BOGOTA D.C.- ANTONIO NARI??O
420	49	SANTAFE DE BOGOTA D.C.- PUENTE ARANDA
421	49	SANTAFE DE BOGOTA D.C.- CANDELARIA
422	49	SANTAFE DE BOGOTA D.C.- RAFAEL URIBE
423	49	SANTAFE DE BOGOTA D.C.- CIUDAD BOLIVAR
424	49	SANTAFE DE BOGOTA D.C.- SUMAPAZ
425	50	CARTAGENA (DISTRITO TURISTICO Y CULTURAL DE CARTAGENA)
426	50	ACHI
427	50	ALTOS DEL ROSARIO
428	50	ARENAL
429	50	ARJONA
430	50	ARROYOHONDO
431	50	BARRANCO DE LOBA
432	50	CALAMAR
433	50	CANTAGALLO
434	50	CICUCO
435	50	CORDOBA
436	50	CLEMENCIA
437	50	EL CARMEN DE BOLIVAR
438	50	EL GUAMO
439	50	EL PE??ON
440	50	HATILLO DE LOBA
441	50	MAGANGUE
442	50	MAHATES
443	50	MARGARITA
444	50	MARIA LA BAJA
445	50	MONTECRISTO
446	50	MOMPOS
447	50	MORALES
448	50	PINILLOS
449	50	REGIDOR
450	50	RIO VIEJO
451	50	SAN CRISTOBAL
452	50	SAN ESTANISLAO
453	50	SAN FERNANDO
454	50	SAN JACINTO
455	50	SAN JACINTO DEL CAUCA
456	50	SAN JUAN NEPOMUCENO
457	50	SAN MARTIN DE LOBA
458	50	SAN PABLO
459	50	SANTA CATALINA
460	50	SANTA ROSA
461	50	SANTA ROSA DEL SUR
462	50	SIMITI
463	50	SOPLAVIENTO
464	50	TALAIGUA NUEVO
465	50	TIQUISIO (PUERTO RICO)
466	50	TURBACO
467	50	TURBANA
468	50	VILLANUEVA
469	50	ZAMBRANO
470	51	TUNJA
471	51	ALMEIDA
472	51	AQUITANIA
473	51	ARCABUCO
474	51	BELEN
475	51	BERBEO
476	51	BETEITIVA
477	51	BOAVITA
478	51	BOYACA
479	51	BUENAVISTA
480	51	BUSBANZA
481	51	CAMPOHERMOSO
482	51	CERINZA
483	51	CHINAVITA
484	51	CHIQUINQUIRA
485	51	CHISCAS
486	51	CHITA
487	51	CHITARAQUE
488	51	CHIVATA
489	51	CIENEGA
490	51	COMBITA
491	51	COPER
492	51	CORRALES
493	51	COVARACHIA
494	51	CUBARA
495	51	CUCAITA
496	51	CUITIVA
497	51	CHIQUIZA
498	51	CHIVOR
499	51	DUITAMA
500	51	EL COCUY
501	51	EL ESPINO
502	51	FIRAVITOBA
503	51	FLORESTA
504	51	GACHANTIVA
505	51	GAMEZA
506	51	GARAGOA
507	51	GUACAMAYAS
508	51	GUATEQUE
509	51	GUAYATA
510	51	GUICAN
511	51	IZA
512	51	JENESANO
513	51	LABRANZAGRANDE
514	51	LA CAPILLA
515	51	LA VICTORIA
516	51	LA UVITA
517	51	VILLA DE LEIVA
518	51	MACANAL
519	51	MARIPI
520	51	MIRAFLORES
521	51	MONGUA
522	51	MONGUI
523	51	MONIQUIRA
524	51	MOTAVITA
525	51	MUZO
526	51	NOBSA
527	51	NUEVO COLON
528	51	OICATA
529	51	OTANCHE
530	51	PACHAVITA
531	51	PAEZ
532	51	PAIPA
533	51	PAJARITO
534	51	PANQUEBA
535	51	PAUNA
536	51	PAYA
537	51	PAZ DEL RIO
538	51	PESCA
539	51	PISBA
540	51	PUERTO BOYACA
541	51	QUIPAMA
542	51	RAMIRIQUI
543	51	RAQUIRA
544	51	RONDON
545	51	SABOYA
546	51	SACHICA
547	51	SAMACA
548	51	SAN EDUARDO
549	51	SAN JOSE DE PARE
550	51	SAN LUIS DE GACENO
551	51	SAN MATEO
552	51	SAN MIGUEL DE SEMA
553	51	SAN PABLO DE BORBUR
554	51	SANTANA
555	51	SANTA MARIA
556	51	SANTA ROSA DE VITERBO
557	51	SANTA SOFIA
558	51	SATIVANORTE
559	51	SATIVASUR
560	51	SIACHOQUE
561	51	SOATA
562	51	SOCOTA
563	51	SOCHA
564	51	SOGAMOSO
565	51	SOMONDOCO
566	51	SORA
567	51	SOTAQUIRA
568	51	SORACA
569	51	SUSACON
570	51	SUTAMARCHAN
571	51	SUTATENZA
572	51	TASCO
573	51	TENZA
574	51	TIBANA
575	51	TIBASOSA
576	51	TINJACA
577	51	TIPACOQUE
578	51	TOCA
579	51	TOGUI
580	51	TOPAGA
581	51	TOTA
582	51	TUNUNGUA
583	51	TURMEQUE
584	51	TUTA
585	51	TUTASA
586	51	UMBITA
587	51	VENTAQUEMADA
588	51	VIRACACHA
589	51	ZETAQUIRA
590	52	MANIZALES
591	52	AGUADAS
592	52	ANSERMA
593	52	ARANZAZU
594	52	BELALCAZAR
595	52	CHINCHINA
596	52	FILADELFIA
597	52	LA DORADA
598	52	LA MERCED
599	52	MANZANARES
600	52	MARMATO
601	52	MARQUETALIA
602	52	MARULANDA
603	52	NEIRA
604	52	NORCASIA
605	52	PACORA
606	52	PALESTINA
607	52	PENSILVANIA
608	52	RIOSUCIO
609	52	RISARALDA
610	52	SALAMINA
611	52	SAMANA
612	52	SAN JOSE
613	52	SUPIA
614	52	VICTORIA
615	52	VILLAMARIA
616	52	VITERBO
617	53	FLORENCIA
618	53	ALBANIA
619	53	BELEN DE LOS ANDAQUIES
620	53	CARTAGENA DEL CHAIRA
621	53	CURILLO
622	53	EL DONCELLO
623	53	EL PAUJIL
624	53	LA MONTA??ITA
625	53	MILAN
626	53	MORELIA
627	53	PUERTO RICO
628	53	SAN JOSE DE FRAGUA
629	53	SAN  VICENTE DEL CAGUAN
630	53	SOLANO
631	53	SOLITA
632	54	POPAYAN
633	54	ALMAGUER
634	54	BALBOA
635	54	BUENOS AIRES
636	54	CAJIBIO
637	54	CALDONO
638	54	CALOTO
639	54	CORINTO
640	54	EL TAMBO
641	54	GUAPI
642	54	INZA
643	54	JAMBALO
644	54	LA SIERRA
645	54	LA VEGA
646	54	LOPEZ (MICAY)
647	54	MERCADERES
648	54	MIRANDA
649	54	PADILLA
650	54	PAEZ (BELALCAZAR)
651	54	PATIA (EL BORDO)
652	54	PIAMONTE
653	54	PIENDAMO
654	54	PUERTO TEJADA
655	54	PURACE (COCONUCO)
656	54	ROSAS
657	54	SAN SEBASTIAN
658	54	SANTANDER DE QUILICHAO
659	54	SILVIA
660	54	SOTARA (PAISPAMBA)
661	54	SUAREZ
662	54	TIMBIO
663	54	TIMBIQUI
664	54	TORIBIO
665	54	TOTORO
666	54	VILLARICA
667	55	VALLEDUPAR
668	55	AGUACHICA
669	55	AGUSTIN CODAZZI
670	55	ASTREA
671	55	BECERRIL
672	55	BOSCONIA
673	55	CHIMICHAGUA
674	55	CHIRIGUANA
675	55	CURUMANI
676	55	EL COPEY
677	55	EL PASO
678	55	GAMARRA
679	55	GONZALEZ
680	55	LA GLORIA
681	55	LA JAGUA IBIRICO
682	55	MANAURE (BALCON DEL CESAR)
683	55	PAILITAS
684	55	PELAYA
685	55	PUEBLO BELLO
686	55	RIO DE ORO
687	55	LA PAZ (ROBLES)
688	55	SAN ALBERTO
689	55	SAN DIEGO
690	55	SAN MARTIN
691	55	TAMALAMEQUE
692	56	MONTERIA
693	56	AYAPEL
694	56	CANALETE
695	56	CERETE
696	56	CHIMA
697	56	CHINU
698	56	CIENAGA DE ORO
699	56	COTORRA
700	56	LA APARTADA
701	56	LORICA
702	56	LOS CORDOBAS
703	56	MOMIL
704	56	MONTELIBANO
705	56	MO??ITOS
706	56	PLANETA RICA
707	56	PUEBLO NUEVO
708	56	PUERTO ESCONDIDO
709	56	PUERTO LIBERTADOR
710	56	PURISIMA
711	56	SAHAGUN
712	56	SAN ANDRES SOTAVENTO
713	56	SAN ANTERO
714	56	SAN BERNARDO DEL VIENTO
715	56	SAN PELAYO
716	56	TIERRALTA
717	56	VALENCIA
718	57	AGUA DE DIOS
719	57	ALBAN
720	57	ANAPOIMA
721	57	ANOLAIMA
722	57	ARBELAEZ
723	57	BELTRAN
724	57	BITUIMA
725	57	BOJACA
726	57	CABRERA
727	57	CACHIPAY
728	57	CAJICA
729	57	CAPARRAPI
730	57	CAQUEZA
731	57	CARMEN DE CARUPA
732	57	CHAGUANI
733	57	CHIA
734	57	CHIPAQUE
735	57	CHOACHI
736	57	CHOCONTA
737	57	COGUA
738	57	COTA
739	57	CUCUNUBA
740	57	EL COLEGIO
741	57	EL ROSAL
742	57	FACATATIVA
743	57	FOMEQUE
744	57	FOSCA
745	57	FUNZA
746	57	FUQUENE
747	57	FUSAGASUGA
748	57	GACHALA
749	57	GACHANCIPA
750	57	GACHETA
751	57	GAMA
752	57	GIRARDOT
753	57	GUACHETA
754	57	GUADUAS
755	57	GUASCA
756	57	GUATAQUI
757	57	GUATAVITA
758	57	GUAYABAL DE SIQUIMA
759	57	GUAYABETAL
760	57	GUTIERREZ
761	57	JERUSALEN
762	57	JUNIN
763	57	LA CALERA
764	57	LA MESA
765	57	LA PALMA
766	57	LA PE??A
767	57	LENGUAZAQUE
768	57	MACHETA
769	57	MADRID
770	57	MANTA
771	57	MEDINA
772	57	MOSQUERA
773	57	NEMOCON
774	57	NILO
775	57	NIMAIMA
776	57	NOCAIMA
777	57	VENECIA (OSPINA PEREZ)
778	57	PACHO
779	57	PAIME
780	57	PANDI
781	57	PARATEBUENO
782	57	PASCA
783	57	PUERTO SALGAR
784	57	PULI
785	57	QUEBRADANEGRA
786	57	QUETAME
787	57	QUIPILE
788	57	APULO (RAFAEL REYES)
789	57	RICAURTE
790	57	SAN  ANTONIO DEL TEQUENDAMA
791	57	SAN BERNARDO
792	57	SAN CAYETANO
793	57	SAN JUAN DE RIOSECO
794	57	SASAIMA
795	57	SESQUILE
796	57	SIBATE
797	57	SILVANIA
798	57	SIMIJACA
799	57	SOACHA
800	57	SOPO
801	57	SUBACHOQUE
802	57	SUESCA
803	57	SUPATA
804	57	SUSA
805	57	SUTATAUSA
806	57	TABIO
807	57	TAUSA
808	57	TENA
809	57	TENJO
810	57	TIBACUY
811	57	TIBIRITA
812	57	TOCAIMA
813	57	TOCANCIPA
814	57	TOPAIPI
815	57	UBALA
816	57	UBAQUE
817	57	UBATE
818	57	UNE
819	57	UTICA
820	57	VERGARA
821	57	VIANI
822	57	VILLAGOMEZ
823	57	VILLAPINZON
824	57	VILLETA
825	57	VIOTA
826	57	YACOPI
827	57	ZIPACON
828	57	ZIPAQUIRA
829	58	QUIBDO (SAN FRANCISCO DE QUIBDO)
830	58	ACANDI
831	58	ALTO BAUDO (PIE DE PATO)
832	58	ATRATO
833	58	BAGADO
834	58	BAHIA SOLANO (MUTIS)
835	58	BAJO BAUDO (PIZARRO)
836	58	BOJAYA (BELLAVISTA)
837	58	CANTON DE SAN PABLO (MANAGRU)
838	58	CONDOTO
839	58	EL CARMEN DE ATRATO
840	58	LITORAL DEL BAJO SAN JUAN (SANTA GENOVEVA DE DOCORDO)
841	58	ISTMINA
842	58	JURADO
843	58	LLORO
844	58	MEDIO ATRATO
845	58	MEDIO BAUDO
846	58	NOVITA
847	58	NUQUI
848	58	RIOQUITO
849	58	SAN JOSE DEL PALMAR
850	58	SIPI
851	58	TADO
852	58	UNGUIA
853	58	UNION PANAMERICANA
854	59	NEIVA
855	59	ACEVEDO
856	59	AGRADO
857	59	AIPE
858	59	ALGECIRAS
859	59	ALTAMIRA
860	59	BARAYA
861	59	CAMPOALEGRE
862	59	COLOMBIA
863	59	ELIAS
864	59	GARZON
865	59	GIGANTE
866	59	HOBO
867	59	IQUIRA
868	59	ISNOS (SAN JOSE DE ISNOS)
869	59	LA ARGENTINA
870	59	LA PLATA
871	59	NATAGA
872	59	OPORAPA
873	59	PAICOL
874	59	PALERMO
875	59	PITAL
876	59	PITALITO
877	59	RIVERA
878	59	SALADOBLANCO
879	59	SAN AGUSTIN
880	59	SUAZA
881	59	TARQUI
882	59	TESALIA
883	59	TELLO
884	59	TERUEL
885	59	TIMANA
886	59	VILLAVIEJA
887	59	YAGUARA
888	60	RIOHACHA
889	60	BARRANCAS
890	60	DIBULLA
891	60	DISTRACCION
892	60	EL MOLINO
893	60	FONSECA
894	60	HATONUEVO
895	60	LA JAGUA DEL PILAR
896	60	MAICAO
897	60	MANAURE
898	60	SAN JUAN DEL CESAR
899	60	URIBIA
900	60	URUMITA
901	61	SANTA MARTA (DISTRITO TURISTICO, CULTURAL E HISTORICODE SANTA MARTA)
902	61	ALGARROBO
903	61	ARACATACA
904	61	ARIGUANI (EL DIFICIL)
905	61	CERRO SAN ANTONIO
906	61	CHIVOLO
907	61	CIENAGA
908	61	EL BANCO
909	61	EL PI??ON
910	61	EL RETEN
911	61	FUNDACION
912	61	GUAMAL
913	61	PEDRAZA
914	61	PIJI??O DEL CARMEN (PIJI??O)
915	61	PIVIJAY
916	61	PLATO
917	61	PUEBLOVIEJO
918	61	REMOLINO
919	61	SABANAS DE SAN ANGEL
920	61	SAN SEBASTIAN DE BUENAVISTA
921	61	SAN ZENON
922	61	SANTA ANA
923	61	SITIONUEVO
924	61	TENERIFE
925	62	VILLAVICENCIO
926	62	ACACIAS
927	62	BARRANCA DE UPIA
928	62	CABUYARO
929	62	CASTILLA LA NUEVA
930	62	SAN LUIS DE CUBARRAL
931	62	CUMARAL
932	62	EL CALVARIO
933	62	EL CASTILLO
934	62	EL DORADO
935	62	FUENTE DE ORO
936	62	MAPIRIPAN
937	62	MESETAS
938	62	LA MACARENA
939	62	LA URIBE
940	62	LEJANIAS
941	62	PUERTO CONCORDIA
942	62	PUERTO GAITAN
943	62	PUERTO LOPEZ
944	62	PUERTO LLERAS
945	62	RESTREPO
946	62	SAN CARLOS DE GUAROA
947	62	SAN  JUAN DE ARAMA
948	62	SAN JUANITO
949	62	VISTAHERMOSA
950	63	PASTO (SAN JUAN DE PASTO)
951	63	ALBAN (SAN JOSE)
952	63	ALDANA
953	63	ANCUYA
954	63	ARBOLEDA (BERRUECOS)
955	63	BARBACOAS
956	63	BUESACO
957	63	COLON (GENOVA)
958	63	CONSACA
959	63	CONTADERO
960	63	CUASPUD (CARLOSAMA)
961	63	CUMBAL
962	63	CUMBITARA
963	63	CHACHAGUI
964	63	EL CHARCO
965	63	EL PE??OL
966	63	EL ROSARIO
967	63	EL TABLON
968	63	FUNES
969	63	GUACHUCAL
970	63	GUAITARILLA
971	63	GUALMATAN
972	63	ILES
973	63	IMUES
974	63	IPIALES
975	63	LA CRUZ
976	63	LA FLORIDA
977	63	LA LLANADA
978	63	LA TOLA
979	63	LEIVA
980	63	LINARES
981	63	LOS ANDES (SOTOMAYOR)
982	63	MAGUI (PAYAN)
983	63	MALLAMA (PIEDRANCHA)
984	63	OLAYA HERRERA (BOCAS DE SATINGA)
985	63	OSPINA
986	63	FRANCISCO PIZARRO (SALAHONDA)
987	63	POLICARPA
988	63	POTOSI
989	63	PROVIDENCIA
990	63	PUERRES
991	63	PUPIALES
992	63	ROBERTO PAYAN (SAN JOSE)
993	63	SAMANIEGO
994	63	SANDONA
995	63	SAN LORENZO
996	63	SAN PEDRO DE CARTAGO
997	63	SANTA BARBARA (ISCUANDE)
998	63	SANTA CRUZ (GUACHAVES)
999	63	SAPUYES
1000	63	TAMINANGO
1001	63	TANGUA
1002	63	TUMACO
1003	63	TUQUERRES
1004	63	YACUANQUER
1005	64	CUCUTA
1006	64	ABREGO
1007	64	ARBOLEDAS
1008	64	BOCHALEMA
1009	64	BUCARASICA
1010	64	CACOTA
1011	64	CACHIRA
1012	64	CHINACOTA
1013	64	CHITAGA
1014	64	CONVENCION
1015	64	CUCUTILLA
1016	64	DURANIA
1017	64	EL CARMEN
1018	64	EL TARRA
1019	64	EL ZULIA
1020	64	GRAMALOTE
1021	64	HACARI
1022	64	HERRAN
1023	64	LABATECA
1024	64	LA ESPERANZA
1025	64	LA PLAYA
1026	64	LOS PATIOS
1027	64	LOURDES
1028	64	MUTISCUA
1029	64	OCA??A
1030	64	PAMPLONA
1031	64	PAMPLONITA
1032	64	PUERTO SANTANDER
1033	64	RAGONVALIA
1034	64	SALAZAR
1035	64	SAN CALIXTO
1036	64	SANTIAGO
1037	64	SARDINATA
1038	64	SILOS
1039	64	TEORAMA
1040	64	TIBU
1041	64	VILLACARO
1042	64	VILLA DEL ROSARIO
1043	65	CALARCA
1044	65	CIRCASIA
1045	65	FILANDIA
1046	65	GENOVA
1047	65	LA TEBAIDA
1048	65	MONTENEGRO
1049	65	PIJAO
1050	65	QUIMBAYA
1051	65	SALENTO
1052	66	PEREIRA
1053	66	APIA
1054	66	BELEN DE UMBRIA
1055	66	DOS QUEBRADAS
1056	66	GUATICA
1057	66	LA CELIA
1058	66	LA VIRGINIA
1059	66	MARSELLA
1060	66	MISTRATO
1061	66	PUEBLO RICO
1062	66	QUINCHIA
1063	66	SANTA ROSA DE CABAL
1064	67	BUCARAMANGA
1065	67	AGUADA
1066	67	ARATOCA
1067	67	BARICHARA
1068	67	BARRANCABERMEJA
1069	67	CALIFORNIA
1070	67	CAPITANEJO
1071	67	CARCASI
1072	67	CEPITA
1073	67	CERRITO
1074	67	CHARALA
1075	67	CHARTA
1076	67	CHIPATA
1077	67	CIMITARRA
1078	67	CONFINES
1079	67	CONTRATACION
1080	67	COROMORO
1081	67	CURITI
1082	67	EL CARMEN DE CHUCURY
1083	67	EL GUACAMAYO
1084	67	EL PLAYON
1085	67	ENCINO
1086	67	ENCISO
1087	67	FLORIAN
1088	67	FLORIDABLANCA
1089	67	GALAN
1090	67	GAMBITA
1091	67	GIRON
1092	67	GUACA
1093	67	GUAPOTA
1094	67	GUAVATA
1095	67	GUEPSA
1096	67	HATO
1097	67	JESUS MARIA
1098	67	JORDAN
1099	67	LA BELLEZA
1100	67	LANDAZURI
1101	67	LA PAZ
1102	67	LEBRIJA
1103	67	LOS SANTOS
1104	67	MACARAVITA
1105	67	MALAGA
1106	67	MATANZA
1107	67	MOGOTES
1108	67	MOLAGAVITA
1109	67	OCAMONTE
1110	67	OIBA
1111	67	ONZAGA
1112	67	PALMAR
1113	67	PALMAS DEL SOCORRO
1114	67	PARAMO
1115	67	PIEDECUESTA
1116	67	PINCHOTE
1117	67	PUENTE NACIONAL
1118	67	PUERTO PARRA
1119	67	PUERTO WILCHES
1120	67	SABANA DE TORRES
1121	67	SAN BENITO
1122	67	SAN GIL
1123	67	SAN JOAQUIN
1124	67	SAN JOSE DE MIRANDA
1125	67	SAN MIGUEL
1126	67	SAN VICENTE DE CHUCURI
1127	67	SANTA HELENA DEL OPON
1128	67	SIMACOTA
1129	67	SOCORRO
1130	67	SUAITA
1131	67	SUCRE
1132	67	SURATA
1133	67	TONA
1134	67	VALLE SAN JOSE
1135	67	VELEZ
1136	67	VETAS
1137	67	ZAPATOCA
1138	68	SINCELEJO
1139	68	CAIMITO
1140	68	COLOSO (RICAURTE)
1141	68	COROZAL
1142	68	CHALAN
1143	68	GALERAS (NUEVA GRANADA)
1144	68	GUARANDA
1145	68	LOS PALMITOS
1146	68	MAJAGUAL
1147	68	MORROA
1148	68	OVEJAS
1149	68	PALMITO
1150	68	SAMPUES
1151	68	SAN BENITO ABAD
1152	68	SAN JUAN DE BETULIA
1153	68	SAN MARCOS
1154	68	SAN ONOFRE
1155	68	SINCE
1156	68	TOLU
1157	68	TOLUVIEJO
1158	69	IBAGUE
1159	69	ALPUJARRA
1160	69	ALVARADO
1161	69	AMBALEMA
1162	69	ANZOATEGUI
1163	69	ARMERO (GUAYABAL)
1164	69	ATACO
1165	69	CAJAMARCA
1166	69	CARMEN APICALA
1167	69	CASABIANCA
1168	69	CHAPARRAL
1169	69	COELLO
1170	69	COYAIMA
1171	69	CUNDAY
1172	69	DOLORES
1173	69	ESPINAL
1174	69	FALAN
1175	69	FLANDES
1176	69	FRESNO
1177	69	GUAMO
1178	69	HERVEO
1179	69	HONDA
1180	69	ICONONZO
1181	69	LERIDA
1182	69	LIBANO
1183	69	MARIQUITA
1184	69	MELGAR
1185	69	MURILLO
1186	69	NATAGAIMA
1187	69	ORTEGA
1188	69	PALOCABILDO
1189	69	PIEDRAS
1190	69	PLANADAS
1191	69	PRADO
1192	69	PURIFICACION
1193	69	RIOBLANCO
1194	69	RONCESVALLES
1195	69	ROVIRA
1196	69	SALDA??A
1197	69	SAN ANTONIO
1198	69	SANTA ISABEL
1199	69	VALLE DE SAN JUAN
1200	69	VENADILLO
1201	69	VILLAHERMOSA
1202	69	VILLARRICA
1203	70	CALI (SANTIAGO DE CALI)
1204	70	ALCALA
1205	70	ANDALUCIA
1206	70	ANSERMANUEVO
1207	70	BUENAVENTURA
1208	70	BUGA
1209	70	BUGALAGRANDE
1210	70	CAICEDONIA
1211	70	CALIMA (DARIEN)
1212	70	CARTAGO
1213	70	DAGUA
1214	70	EL AGUILA
1215	70	EL CAIRO
1216	70	EL CERRITO
1217	70	EL DOVIO
1218	70	FLORIDA
1219	70	GINEBRA
1220	70	GUACARI
1221	70	JAMUNDI
1222	70	LA CUMBRE
1223	70	OBANDO
1224	70	PALMIRA
1225	70	PRADERA
1226	70	RIOFRIO
1227	70	ROLDANILLO
1228	70	SEVILLA
1229	70	TORO
1230	70	TRUJILLO
1231	70	TULUA
1232	70	ULLOA
1233	70	VERSALLES
1234	70	VIJES
1235	70	YOTOCO
1236	70	YUMBO
1237	70	ZARZAL
1238	71	ARAUCA
1239	71	ARAUQUITA
1240	71	CRAVO NORTE
1241	71	FORTUL
1242	71	PUERTO RONDON
1243	71	SARAVENA
1244	71	TAME
1245	72	YOPAL
1246	72	AGUAZUL
1247	72	CHAMEZA
1248	72	HATO COROZAL
1249	72	LA SALINA
1250	72	MANI
1251	72	MONTERREY
1252	72	NUNCHIA
1253	72	OROCUE
1254	72	PAZ DE ARIPORO
1255	72	PORE
1256	72	RECETOR
1257	72	SACAMA
1258	72	SAN LUIS DE PALENQUE
1259	72	TAMARA
1260	72	TAURAMENA
1261	72	TRINIDAD
1262	73	MOCOA
1263	73	COLON
1264	73	ORITO
1265	73	PUERTO ASIS
1266	73	PUERTO CAICEDO
1267	73	PUERTO GUZMAN
1268	73	PUERTO LEGUIZAMO
1269	73	SIBUNDOY
1270	73	SAN MIGUEL (LA DORADA)
1271	73	LA HORMIGA (VALLE DEL GUAMUEZ)
1272	73	VILLAGARZON
1273	75	LETICIA
1274	75	EL ENCANTO
1275	75	LA CHORRERA
1276	75	LA PEDRERA
1277	75	MIRITI-PARANA
1278	75	PUERTO ALEGRIA
1279	75	PUERTO ARICA
1280	75	PUERTO NARI??O
1281	75	TARAPACA
1282	76	PUERTO INIRIDA
1283	76	BARRANCO MINAS
1284	76	SAN FELIPE
1285	76	LA GUADALUPE
1286	76	CACAHUAL
1287	76	PANA PANA (CAMPO ALEGRE)
1288	76	MORICHAL (MORICHAL NUEVO)
1289	77	SAN JOSE DEL GUAVIARE
1290	77	EL RETORNO
1291	78	MITU
1292	78	CARURU
1293	78	PACOA
1294	78	TARAIRA
1295	78	PAPUNAUA (MORICHAL)
1296	78	YAVARATE
1297	79	PUERTO CARRE??O
1298	79	LA PRIMAVERA
1299	79	SANTA RITA
1300	79	SANTA ROSALIA
1301	79	SAN JOSE DE OCUNE
1302	80	CUENCA
1303	80	GIR??N
1304	80	GUALACEO
1305	80	NAB??N
1306	80	PAUTE
1307	80	PUCARA
1308	80	SAN FERNANDO
1309	80	SANTA ISABEL
1310	80	SIGSIG
1311	80	O??A
1312	80	CHORDELEG
1313	80	EL PAN
1314	80	SEVILLA DE ORO
1315	80	GUACHAPALA
1316	80	CAMILO PONCE ENR??QUEZ
1317	81	GUARANDA
1318	81	CHILLANES
1319	81	CHIMBO
1320	81	ECHEAND??A
1321	81	SAN MIGUEL
1322	81	CALUMA
1323	81	LAS NAVES
1324	82	AZOGUES
1325	82	BIBLI??N
1326	82	CA??AR
1327	82	LA TRONCAL
1328	82	EL TAMBO
1329	82	D??LEG
1330	82	SUSCAL
1331	83	TULC??N
1332	83	BOL??VAR
1333	83	ESPEJO
1334	83	MIRA
1335	83	MONT??FAR
1336	83	SAN PEDRO DE HUACA
1337	84	LATACUNGA
1338	84	LA MAN??
1339	84	PANGUA
1340	84	PUJILI
1341	84	SALCEDO
1342	84	SAQUISIL??
1343	84	SIGCHOS
1344	85	RIOBAMBA
1345	85	ALAUSI
1346	85	COLTA
1347	85	CHAMBO
1348	85	CHUNCHI
1349	85	GUAMOTE
1350	85	GUANO
1351	85	PALLATANGA
1352	85	PENIPE
1353	85	CUMAND??
1354	86	MACHALA
1355	86	ARENILLAS
1356	86	ATAHUALPA
1357	86	BALSAS
1358	86	CHILLA
1359	86	EL GUABO
1360	86	HUAQUILLAS
1361	86	MARCABEL??
1362	86	PASAJE
1363	86	PI??AS
1364	86	PORTOVELO
1365	86	SANTA ROSA
1366	86	ZARUMA
1367	86	LAS LAJAS
1368	87	ESMERALDAS
1369	87	ELOY ALFARO
1370	87	MUISNE
1371	87	QUININD??
1372	87	SAN LORENZO
1373	87	ATACAMES
1374	87	RIOVERDE
1375	87	LA CONCORDIA
1376	88	GUAYAQUIL
1377	88	ALFREDO BAQUERIZO MORENO (JUJ??N)
1378	88	BALAO
1379	88	BALZAR
1380	88	COLIMES
1381	88	DAULE
1382	88	DUR??N
1383	88	EL EMPALME
1384	88	EL TRIUNFO
1385	88	MILAGRO
1386	88	NARANJAL
1387	88	NARANJITO
1388	88	PALESTINA
1389	88	PEDRO CARBO
1390	88	SAMBOROND??N
1391	88	SANTA LUC??A
1392	88	SALITRE (URBINA JADO)
1393	88	SAN JACINTO DE YAGUACHI
1394	88	PLAYAS
1395	88	SIM??N BOL??VAR
1396	88	ORONEL MARCELINO MARIDUE
1397	88	LOMAS DE SARGENTILLO
1398	88	NOBOL
1399	88	GENERAL ANTONIO ELIZALDE
1400	88	ISIDRO AYORA
1401	89	IBARRA
1402	89	ANTONIO ANTE
1403	89	COTACACHI
1404	89	OTAVALO
1405	89	PIMAMPIRO
1406	89	SAN MIGUEL DE URCUQU??
1407	90	LOJA
1408	90	CALVAS
1409	90	CATAMAYO
1410	90	CELICA
1411	90	CHAGUARPAMBA
1412	90	ESP??NDOLA
1413	90	GONZANAM??
1414	90	MACAR??
1415	90	PALTAS
1416	90	PUYANGO
1417	90	SARAGURO
1418	90	SOZORANGA
1419	90	ZAPOTILLO
1420	90	PINDAL
1421	90	QUILANGA
1422	90	OLMEDO
1423	91	BABAHOYO
1424	91	BABA
1425	91	MONTALVO
1426	91	PUEBLOVIEJO
1427	91	QUEVEDO
1428	91	URDANETA
1429	91	VENTANAS
1430	91	V??NCES
1431	91	PALENQUE
1432	91	BUENA F??
1433	91	VALENCIA
1434	91	MOCACHE
1435	91	QUINSALOMA
1436	92	PORTOVIEJO
1437	92	CHONE
1438	92	EL CARMEN
1439	92	FLAVIO ALFARO
1440	92	JIPIJAPA
1441	92	JUN??N
1442	92	MANTA
1443	92	MONTECRISTI
1444	92	PAJ??N
1445	92	PICHINCHA
1446	92	ROCAFUERTE
1447	92	SANTA ANA
1448	92	SUCRE
1449	92	TOSAGUA
1450	92	24 DE MAYO
1451	92	PEDERNALES
1452	92	PUERTO L??PEZ
1453	92	JAMA
1454	92	JARAMIJ??
1455	92	SAN VICENTE
1456	93	MORONA
1457	93	GUALAQUIZA
1458	93	LIM??N INDANZA
1459	93	PALORA
1460	93	SANTIAGO
1461	93	SUC??A
1462	93	HUAMBOYA
1463	93	SAN JUAN BOSCO
1464	93	TAISHA
1465	93	LOGRO??O
1466	93	PABLO SEXTO
1467	93	TIWINTZA
1468	94	TENA
1469	94	ARCHIDONA
1470	94	EL CHACO
1471	94	QUIJOS
1472	94	ARLOS JULIO AROSEMENA TOL
1473	95	PASTAZA
1474	95	MERA
1475	95	SANTA CLARA
1476	95	ARAJUNO
1477	96	QUITO
1478	96	CAYAMBE
1479	96	MEJIA
1480	96	PEDRO MONCAYO
1481	96	RUMI??AHUI
1482	96	SAN MIGUEL DE LOS BANCOS
1483	96	PEDRO VICENTE MALDONADO
1484	96	PUERTO QUITO
1485	97	AMBATO
1486	97	BA??OS DE AGUA SANTA
1487	97	CEVALLOS
1488	97	MOCHA
1489	97	PATATE
1490	97	QUERO
1491	97	SAN PEDRO DE PELILEO
1492	97	SANTIAGO DE P??LLARO
1493	97	TISALEO
1494	98	ZAMORA
1495	98	CHINCHIPE
1496	98	NANGARITZA
1497	98	YACUAMBI
1498	98	YANTZAZA (YANZATZA)
1499	98	EL PANGUI
1500	98	CENTINELA DEL C??NDOR
1501	98	PALANDA
1502	98	PAQUISHA
1503	99	SAN CRIST??BAL
1504	99	ISABELA
1505	99	SANTA CRUZ
1506	100	LAGO AGRIO
1507	100	GONZALO PIZARRO
1508	100	PUTUMAYO
1509	100	SHUSHUFINDI
1510	100	SUCUMB??OS
1511	100	CASCALES
1512	100	CUYABENO
1513	101	ORELLANA
1514	101	AGUARICO
1515	101	LA JOYA DE LOS SACHAS
1516	101	LORETO
1517	102	SANTO DOMINGO
1518	103	SANTA ELENA
1519	103	LA LIBERTAD
1520	103	SALINAS
1521	104	LAS GOLONDRINAS
1522	104	MANGA DEL CURA
1523	105	Ahuachap??n
1524	105	Atiquizaya
1525	106	Sonsonate
1526	106	Izalco
1527	106	Juay??a
1528	107	Santa Ana
1529	107	Chalchuapa
1530	107	Metap??n
1531	108	Chalatenango
1532	108	Tejutla
1533	108	Dulce Nombre de Mar??a
1534	109	Nueva San Salvador
1535	109	Quezaltepeque
1536	109	San Juan Opico
1537	110	San Salvador
1538	110	Tonacatepeque
1539	110	Santo Tom??s
1540	111	Cojutepeque
1541	111	Suchitoto
1542	112	Zacatecoluca
1543	112	Olocuilta
1544	112	San Pedro Nonualco
1545	112	San Pedro Masahuat
1546	113	Sensuntepeque
1547	113	Ilobasco
1548	114	San Vicente
1549	114	San Sebasti??n
1550	115	Usulut??n
1551	115	Santiago de Mar??a
1552	115	Berl??n
1553	115	Jucuapa
1554	116	San Miguel
1555	116	Chinameca
1556	116	Sesor??
1557	117	San Francisco Gotera
1558	117	Jocoaitique
1559	117	Osicala
1560	118	La Uni??n
1561	118	Santa Rosa de Lima
1562	119	SAN JOSE
1563	119	ESCAZU
1564	119	DESAMPARADOS
1565	119	PURISCAL
1566	119	TARRAZU
1567	119	ASERRI
1568	119	MORA
1569	119	GOICOECHEA
1570	119	SANTA ANA
1571	119	ALAJUELITA
1572	119	CORONADO
1573	119	ACOSTA
1574	119	TIBAS
1575	119	MORAVIA
1576	119	MONTES DE OCA
1577	119	TURRUBARES
1578	119	DOTA
1579	119	PEREZ ZELEDON
1580	119	LEON CORTES
1581	120	ALAJUELA
1582	120	SAN RAMON
1583	120	GRECIA
1584	120	SAN MATEO
1585	120	ATENAS
1586	120	NARANJO
1587	120	PALMARES
1588	120	POAS
1589	120	OROTINA
1590	120	SAN CARLOS
1591	120	ALFARO RUIZ
1592	120	VALVERDE VEGA
1593	120	UPALA
1594	120	LOS CHILES
1595	120	GUATUSO
1596	121	CARTAGO
1597	121	PARAISO
1598	121	LA UNION
1599	121	JIMENEZ
1600	121	TURRIALBA
1601	121	ALVARADO
1602	121	OREAMUNO
1603	121	EL GUARCO
1604	122	HEREDIA
1605	122	BARVA
1606	122	SANTO DOMINGO
1607	122	SANTA BARBARA
1608	122	SAN RAFAEL
1609	122	SAN ISIDRO
1610	122	BELEN
1611	122	FLORES
1612	122	SAN PABLO
1613	122	SARAPIQUI
1614	123	LIBERIA
1615	123	NICOYA
1616	123	SANTA CRUZ
1617	123	BAGACES
1618	123	CARRILLO
1619	123	CA??AS
1620	123	ABANGARES
1621	123	TILARAN
1622	123	NANDAYURE
1623	123	LA CRUZ
1624	123	HOJANCHA
1625	124	PUNTARENAS
1626	124	ESPARZA
1627	124	BUENOS AIRES
1628	124	MONTES DE ORO
1629	124	OSA
1630	124	AGUIRRE
1631	124	GOLFITO
1632	124	COTO BRUS
1633	124	PARRITA
1634	124	CORREDORES
1635	124	GARABITO
1636	125	LIMON
1637	125	POCOCI
1638	125	SIQUIRRES
1639	125	TALAMANCA
1640	125	MATINA
1641	125	GUACIMO
1642	126	Alto Orinoco
1643	126	Atabapo
1644	126	Atures
1645	126	Autana
1646	126	Manapiare
1647	126	Maroa
1648	126	R??o Negro
1649	127	Anaco
1650	127	Aragua
1651	127	Diego Bautista Urbaneja
1652	127	Fernando Pe??alver
1653	127	Francisco de Miranda
1654	127	Francisco Del Carmen Carvajal
1655	127	General Sir Arthur McGregor
1656	127	Guanta
1657	127	Independencia
1658	127	Jos?? Gregorio Monagas
1659	127	Juan Antonio Sotillo
1660	127	Juan Manuel Cajigal
1661	127	Libertad
1662	127	Manuel Ezequiel Bruzual
1663	127	Pedro Mar??a Freites
1664	127	P??ritu
1665	127	San Jos?? de Guanipa
1666	127	San Juan de Capistrano
1667	127	Santa Ana
1668	127	Sim??n Bol??var
1669	127	Sim??n Rodr??guez
1670	128	Achaguas
1671	128	Biruaca
1672	128	Mu????z
1673	128	P??ez
1674	128	Pedro Camejo
1675	128	R??mulo Gallegos
1676	128	San Fernando
1677	129	Atanasio Girardot
1678	129	Bol??var
1679	129	Camatagua
1680	129	Francisco Linares Alc??ntara
1681	129	Jos?? ??ngel Lamas
1682	129	Jos?? F??lix Ribas
1683	129	Jos?? Rafael Revenga
1684	129	Libertador
1685	129	Mario Brice??o Iragorry
1686	129	Ocumare de la Costa de Oro
1687	129	San Casimiro
1688	129	San Sebasti??n
1689	129	Santiago Mari??o
1690	129	Santos Michelena
1691	129	Sucre
1692	129	Tovar
1693	129	Urdaneta
1694	129	Zamora
1695	130	Alberto Arvelo Torrealba
1696	130	Andr??s Eloy Blanco
1697	130	Antonio Jos?? de Sucre
1698	130	Arismendi
1699	130	Barinas
1700	130	Cruz Paredes
1701	130	Ezequiel Zamora
1702	130	Obispos
1703	130	Pedraza
1704	130	Rojas
1705	130	Sosa
1706	131	Angostura (Ra??l Leoni)
1707	131	Caron??
1708	131	Cede??o
1709	131	El Callao
1710	131	Gran Sabana
1711	131	Heres
1712	131	Padre Pedro Chien
1713	131	Piar
1714	131	Roscio
1715	131	Sifontes
1716	132	Bejuma
1717	132	Carlos Arvelo
1718	132	Diego Ibarra
1719	132	Guacara
1720	132	Juan Jos?? Mora
1721	132	Los Guayos
1722	132	Miranda
1723	132	Montalb??n
1724	132	Naguanagua
1725	132	Puerto Cabello
1726	132	San Diego
1727	132	San Joaqu??n
1728	132	Valencia
1729	133	Anzo??tegui
1730	133	Girardot
1731	133	Lima Blanco
1732	133	Pao de San Juan Bautista
1733	133	Ricaurte
1734	133	San Carlos
1735	133	Tinaco
1736	133	Tinaquillo
1737	134	Antonio D??az
1738	134	Casacoima
1739	134	Pedernales
1740	134	Tucupita
1741	136	Acosta
1742	136	Buchivacoa
1743	136	Cacique Manaure
1744	136	Carirubana
1745	136	Colina
1746	136	Dabajuro
1747	136	Democracia
1748	136	Falc??n
1749	136	Federaci??n
1750	136	Jacura
1751	136	Jos?? Laurencio Silva
1752	136	Los Taques
1753	136	Mauroa
1754	136	Monse??or Iturriza
1755	136	Palmasola
1756	136	Petit
1757	136	San Francisco
1758	136	Toc??pero
1759	136	Uni??n
1760	136	Urumaco
1761	137	Camagu??n
1762	137	Chaguaramas
1763	137	El Socorro
1764	137	Jos?? Tadeo Monagas
1765	137	Juan Germ??n Roscio
1766	137	Juli??n Mellado
1767	137	Las Mercedes
1768	137	Leonardo Infante
1769	137	Ort??z
1770	137	Pedro Zaraza
1771	137	San Ger??nimo de Guayabal
1772	137	San Jos?? de Guaribe
1773	137	Santa Mar??a de Ipire
1774	137	Sebasti??n Francisco de Miranda
1775	138	Vargas
1776	139	Crespo
1777	139	Iribarren
1778	139	Jim??nez
1779	139	Mor??n
1780	139	Palavecino
1781	139	Sim??n Planas
1782	139	Torres
1783	140	Alberto Adriani
1784	140	Andr??s Bello
1785	140	Antonio Pinto Salinas
1786	140	Aricagua
1787	140	Arzobispo Chac??n
1788	140	Campo El??as
1789	140	Caracciolo Parra Olmedo
1790	140	Cardenal Quintero
1791	140	Guaraque
1792	140	Julio C??sar Salas
1793	140	Justo Brice??o
1794	140	Obispo Ramos de Lora
1795	140	Padre Noguera
1796	140	Pueblo Llano
1797	140	Rangel
1798	140	Rivas D??vila
1799	140	Santos Marquina
1800	140	Tulio Febres Cordero
1801	140	Zea
1802	141	Acevedo
1803	141	Baruta
1804	141	Bri??n
1805	141	Buroz
1806	141	Carrizal
1807	141	Chacao
1808	141	Crist??bal Rojas
1809	141	El Hatillo
1810	141	Guaicaipuro
1811	141	Lander
1812	141	Los Salias
1813	141	Paz Castillo
1814	141	Pedro Gual
1815	141	Plaza
1816	142	Aguasay
1817	142	Caripe
1818	142	Matur??n
1819	142	Punceres
1820	142	Santa B??rbara
1821	142	Sotillo
1822	142	Uracoa
1823	143	Antol??n del Campo
1824	143	D??az
1825	143	Garc??a
1826	143	G??mez
1827	143	Maneiro
1828	143	Marcano
1829	143	Mari??o
1830	143	Pen??nsula de Macanao
1831	143	Tubores
1832	143	Villalba
1833	144	Araure
1834	144	Esteller
1835	144	Guanare
1836	144	Guanarito
1837	144	Monse??or Jos?? Vicente de Unda
1838	144	Ospino
1839	144	Papel??n
1840	144	San Genaro de Bocono??to
1841	144	San Rafael de Onoto
1842	144	Santa Rosal??a
1843	144	Tur??n
1844	145	Andr??s Mata
1845	145	Ben??tez
1846	145	Berm??dez
1847	145	Cajigal
1848	145	Cruz Salmer??n Acosta
1849	145	Mej??a
1850	145	Montes
1851	145	Ribero
1852	145	Vald??z
1853	146	Antonio R??mulo Costa
1854	146	Ayacucho
1855	146	C??rdenas
1856	146	C??rdoba
1857	146	Fern??ndez Feo
1858	146	Garc??a de Hevia
1859	146	Gu??simos
1860	146	J??uregui
1861	146	Jos?? Mar??a Vargas
1862	146	Jun??n
1863	146	Lobatera
1864	146	Michelena
1865	146	Panamericano
1866	146	Pedro Mar??a Ure??a
1867	146	Rafael Urdaneta
1868	146	Samuel Dar??o Maldonado
1869	146	San Crist??bal
1870	146	San Judas Tadeo
1871	146	Seboruco
1872	146	Torbes
1873	146	Uribante
1874	147	Bocon??
1875	147	Candelaria
1876	147	Carache
1877	147	Escuque
1878	147	Jos?? Felipe M??rquez Ca??izalez
1879	147	Juan Vicente Campos El??as
1880	147	La Ceiba
1881	147	Monte Carmelo
1882	147	Motat??n
1883	147	Pamp??n
1884	147	Pampanito
1885	147	Rafael Rangel
1886	147	San Rafael de Carvajal
1887	147	Trujillo
1888	147	Valera
1889	148	Ar??stides Bastidas
1890	148	Bruzual
1891	148	Cocorote
1892	148	Jos?? Antonio P??ez
1893	148	Jos?? Joaqu??n Veroes
1894	148	La Trinidad
1895	148	Manuel Monge
1896	148	Nirgua
1897	148	Pe??a
1898	148	San Felipe
1899	148	Urachiche
1900	149	Almirante Padilla
1901	149	Baralt
1902	149	Cabimas
1903	149	Catatumbo
1904	149	Col??n
1905	149	Francisco Javier Pulgar
1906	149	Jes??s Enrique Losada
1907	149	Jes??s Mar??a Sempr??n
1908	149	La Ca??ada de Urdaneta
1909	149	Lagunillas
1910	149	Machiques de Perij??
1911	149	Mara
1912	149	Maracaibo
1913	149	Rosario de Perij??
1914	149	Santa Rita
1915	149	Valmore Rodr??guez
1917	151	Baltasar Brum
1918	151	Bella Uni??n
1919	151	Tom??s Gomensoro
1920	152	18 de Mayo
1921	152	Aguas Corrientes
1922	152	Atl??ntida
1923	152	Barros Blancos
1924	152	Canelones
1925	152	Ciudad de la Costa
1926	152	Colonia Nicolich
1927	152	Empalme Olmos
1928	152	La Floresta
1929	152	La Paz
1930	152	Las Piedras
1931	152	Los Cerrillos
1932	152	Migues
1933	152	Montes
1934	152	Pando
1935	152	Parque del Plata
1936	152	Paso Carrasco
1937	152	Progreso
1938	152	Salinas
1939	152	San Antonio
1940	152	San Bautista
1941	152	San Jacinto
1942	152	San Ram??n
1943	152	Santa Luc??a
1944	152	Santa Rosa
1945	152	Sauce
1946	152	Soca
1947	152	Su??rez
1948	152	Tala
1949	152	Toledo
1950	153	Acegu??
1951	153	Arbolito
1952	153	Ar??valo
1953	153	Ba??ado de Medina
1954	153	Centuri??n
1955	153	Cerro de las Cuentas
1956	153	Fraile Muerto
1957	153	Isidoro Nobl??a
1958	153	Las Ca??as
1959	153	Pl??cido Rosas
1960	153	Quebracho
1961	153	Ram??n Trigo
1962	153	R??o Branco
1963	153	Tres Islas
1964	153	Tupamba??
1965	154	Carmelo
1966	154	Colonia Valdense
1967	154	Florencio S??nchez
1968	154	Juan L. Lacaze
1969	154	Colonia Miguelete
1970	154	Nueva Helvecia
1971	154	Nueva Palmira
1972	154	Omb??es de Lavalle
1973	154	Rosario
1974	154	Tarariras
1975	155	Sarand?? del Y??
1976	155	Villa del Carmen
1977	156	Ismael Cortinas
1978	157	Casup??
1979	157	Fray Marcos
1980	157	Sarand?? Grande
1981	158	Jos?? Batlle y Ord????ez
1982	158	Jos?? Pedro Varela
1983	158	Mariscala
1984	158	Sol??s de Mataojo
1985	159	Aigu??
1986	159	Garz??n
1987	159	Maldonado
1988	159	Pan de Az??car
1989	159	Piri??polis
1990	159	Punta del Este
1991	159	San Carlos
1992	159	Sol??s Grande
1993	160	Municipio A
1994	160	Municipio B
1995	160	Municipio C
1996	160	Municipio CH
1997	160	Municipio D
1998	160	Municipio E
1999	160	Municipio F
2000	160	Municipio G
2001	161	Chapicuy
2002	161	Guich??n
2003	161	Lorenzo Geyres
2004	161	Piedras Coloradas
2005	161	Porvenir
2006	161	Tambores
2007	162	Nuevo Berl??n
2008	162	San Javier
2009	162	Young
2010	163	Minas de Corrales
2011	163	Tranqueras
2012	163	Vichadero
2013	164	Castillos
2014	164	Chuy
2015	164	La Paloma
2016	164	Lascano
2017	165	Colonia Lavalleja
2018	165	Mataojo
2019	165	Pueblo Bel??n
2020	165	Pueblo Rinc??n de Valent??n
2021	165	Pueblo San Antonio
2022	165	Villa Constituci??n
2023	166	Ciudad del Plata
2024	166	Ecilda Paullier
2025	166	Libertad
2026	166	Rodr??guez
2027	167	Cardona
2028	167	Dolores
2029	167	Jos?? Enrique Rod??
2030	167	Palmitas
2031	168	Ansina
2032	168	Paso de los Toros
2033	168	San Gregorio de Polanco
2034	169	Cerro Chato
2035	169	General Enrique Mart??nez
2036	169	Rinc??n
2037	169	Santa Clara de Olimar
2038	169	Vergara
2039	170	Bah??a Negra
2040	170	Capit??n Carmelo Peralta
2041	170	Fuerte Olimpo
2042	170	Puerto Casado
2043	171	Ciudad del Este
2044	171	Doctor Juan Le??n Mallorqu??n
2045	171	Doctor Ra??l Pe??a
2046	171	Domingo Mart??nez de Irala
2047	171	Hernandarias
2048	171	Iru??a
2049	171	Itakyry
2050	171	Juan Emiliano O'Leary
2051	171	Los Cedrales
2052	171	Mbaracay??
2053	171	Minga Guaz??
2054	171	Minga Por??
2055	171	Naranjal
2056	171	??acunday
2057	171	Presidente Franco
2058	171	San Alberto
2059	171	Santa Fe del Paran??
2060	171	Santa Rita
2061	171	Santa Rosa del Monday
2062	171	Tavapy
2063	171	Yguaz??
2064	172	Bella Vista Norte
2065	172	Capit??n Bado
2066	172	Cerro Cor??
2067	172	Karapa??
2068	172	Pedro Juan Caballero
2069	172	Zanja Pyt??
2070	173	Asunci??n
2071	174	Boquer??n
2072	174	Filadelfia
2073	174	Loma Plata
2074	174	Mariscal Jos?? F??lix Estigarribia
2075	175	Caaguaz??
2076	175	Caraya??
2077	175	Coronel Oviedo
2078	175	Doctor Cecilio B??ez
2079	175	Doctor Juan Eulogio Estigarribia
2080	175	Doctor Juan Manuel Frutos
2081	175	Jos?? Domingo Ocampos
2082	175	La Pastora
2083	175	Mariscal Francisco Solano L??pez
2084	175	Nueva Londres
2085	175	Nueva Toledo
2086	175	Ra??l Arsenio Oviedo
2087	175	Regimiento de Infanter??a Tres Corrales
2088	175	Repatriaci??n
2089	175	San Jos?? de los Arroyos
2090	175	Santa Rosa del Mbutuy
2091	175	Sim??n Bol??var
2092	175	Tembiapor??
2093	175	Tres de Febrero
2094	175	Vaquer??a
2095	175	Yh??
2096	176	Aba??
2097	176	Buena Vista
2098	176	Caazap??
2099	176	Doctor Mois??s Santiago Bertoni
2100	176	Fulgencio Yegros
2101	176	General Higinio Mor??nigo
2102	176	Maciel
2103	176	San Juan Nepomuceno
2104	176	Tava??
2105	176	Tres de Mayo
2106	176	Yuty
2107	177	Corpus Christi
2108	177	Curuguaty
2109	177	General Francisco Caballero ??lvarez
2110	177	Itanar??
2111	177	Katuet??
2112	177	La Paloma del Esp??ritu Santo
2113	177	Laurel
2114	177	Maracan??
2115	177	Nueva Esperanza
2116	177	Puerto Adela
2117	177	Salto del Guair??
2118	177	Villa Ygatim??
2119	177	Yasy Ca??y
2120	177	Yby Pyt??
2121	177	Ybyraroban??
2122	177	Ypejh??
2123	178	Aregu??
2124	178	Capiat??
2125	178	Fernando de la Mora
2126	178	Guarambar??
2127	178	It??
2128	178	Itaugu??
2129	178	Juli??n Augusto Sald??var
2130	178	Lambar??
2131	178	Limpio
2132	178	Luque
2133	178	Mariano Roque Alonso
2134	178	Nueva Italia
2135	178	??emby
2136	178	San Antonio
2137	178	San Lorenzo
2138	178	Villa Elisa
2139	178	Villeta
2140	178	Ypacara??
2141	178	Ypan??
2142	179	Arroyito
2143	179	Azotey
2144	179	Bel??n
2145	179	Concepci??n
2146	179	Horqueta
2147	179	Loreto
2148	179	Paso Horqueta
2149	179	San Alfredo
2150	179	San Carlos del Apa
2151	179	San L??zaro
2152	179	Sargento Jos?? F??lix L??pez
2153	179	Yby Ya??
2154	180	Altos
2155	180	Arroyos y Esteros
2156	180	Atyr??
2157	180	Caacup??
2158	180	Caraguatay
2159	180	Emboscada
2160	180	Eusebio Ayala
2161	180	Isla Puc??
2162	180	Itacurub?? de la Cordillera
2163	180	Juan de Mena
2164	180	Loma Grande
2165	180	Mbocayaty del Yhaguy
2166	180	Nueva Colombia
2167	180	Piribebuy
2168	180	Primero de Marzo
2169	180	San Bernardino
2170	180	San Jos?? Obrero
2171	180	Santa Elena
2172	180	Tobat??
2173	180	Valenzuela
2174	181	Borja
2175	181	Capit??n Mauricio Jos?? Troche
2176	181	Coronel Mart??nez
2177	181	Doctor Botrell
2178	181	F??lix P??rez Cardozo
2179	181	General Eugenio Alejandrino Garay
2180	181	Independencia
2181	181	Itap??
2182	181	Iturbe
2183	181	Jos?? A. Fassardi
2184	181	Mbocayaty del Guair??
2185	181	Natalicio Talavera
2186	181	??um??
2187	181	Paso Yob??i
2188	181	San Salvador
2189	181	Tebicuary
2190	181	Villarrica
2191	181	Yataity del Guair??
2192	182	Alto Ver??
2193	182	Bella Vista
2194	182	Cambyret??
2195	182	Capit??n Meza
2196	182	Capit??n Miranda
2197	182	Carlos Antonio L??pez
2198	182	Carmen del Paran??
2199	182	Coronel Jos?? F??lix Bogado
2200	182	Edelira
2201	182	Encarnaci??n
2202	182	Fram
2203	182	General Artigas
2204	182	General Delgado
2205	182	Hohenau
2206	182	Itap??a Poty
2207	182	Jes??s de Tavarang????
2208	182	Jos?? Leandro Oviedo
2209	182	La Paz
2210	182	Mayor Julio Dionisio Ota??o
2211	182	Natalio
2212	182	Nueva Alborada
2213	182	Obligado
2214	182	Pirap??
2215	182	San Cosme y Dami??n
2216	182	San Juan del Paran??
2217	182	San Pedro del Paran??
2218	182	San Rafael del Paran??
2219	182	Tom??s Romero Pereira
2220	182	Trinidad
2221	182	Yatytay
2222	183	Ayolas
2223	183	San Ignacio Guaz??
2224	183	San Juan Bautista
2225	183	San Miguel
2226	183	San Patricio
2227	183	Santa Mar??a de Fe
2228	183	Santa Rosa de Lima
2229	183	Santiago
2230	183	Villa Florida
2231	183	Yabebyry
2232	184	Alberdi
2233	184	Cerrito
2234	184	Desmochados
2235	184	General Jos?? Eduvigis D??az
2236	184	Guaz?? Cu??
2237	184	Humait??
2238	184	Isla Umb??
2239	184	Laureles
2240	184	Mayor Jos?? Mart??nez
2241	184	Paso de Patria
2242	184	Pilar
2243	184	San Juan Bautista de ??eembuc??
2244	184	Tacuaras
2245	184	Villa Franca
2246	184	Villa Oliva
2247	184	Villalb??n
2248	185	Acahay
2249	185	Caapuc??
2250	185	Carapegu??
2251	185	Escobar
2252	185	General Bernardino Caballero
2253	185	La Colmena
2254	185	Mar??a Antonia
2255	185	Mbuyapey
2256	185	Paraguar??
2257	185	Piray??
2258	185	Quiindy
2259	185	Quyquyh??
2260	185	San Roque Gonz??lez de Santa Cruz
2261	185	Sapucai
2262	185	Tebicuarym??
2263	185	Yaguar??n
2264	185	Ybycu??
2265	185	Ybytym??
2266	186	Benjam??n Aceval
2267	186	Campo Aceval
2268	186	General Jos?? Mar??a Bruguez
2269	186	Jos?? Falc??n
2270	186	Nanawa
2271	186	Nueva Asunci??n5???
2272	186	Puerto Pinasco
2273	186	Teniente Esteban Mart??nez
2274	186	Teniente Primero Manuel Irala Fern??ndez
2275	186	Villa Hayes
2276	187	Antequera
2277	187	Capiibary
2278	187	Chor??
2279	187	General Elizardo Aquino
2280	187	General Isidoro Resqu??n
2281	187	Guayaib??
2282	187	Itacurub?? del Rosario
2283	187	Liberaci??n
2284	187	Lima
2285	187	Nueva Germania
2286	187	San Jos?? del Rosario
2287	187	San Estanislao
2288	187	San Pablo
2289	187	San Pedro de Ycuamandiy??
2290	187	San Vicente Pancholo
2291	187	Santa Rosa del Aguaray
2292	187	Tacuat??
2293	187	Uni??n
2294	187	Veinticinco de Diciembre
2295	187	Villa del Rosario
2296	187	Yataity del Norte
2297	188	Cercado
2298	188	Gral. J. Ballivian
2299	188	Itenez
2300	188	Mamore
2301	188	Marban
2302	188	Moxos
2303	188	Vaca Diez
2304	188	Yacuma
2305	189	Azurduy
2306	189	Belisario Boeto
2307	189	Hernando Siles
2308	189	Luis Calvo
2309	189	Nor Cinti
2310	189	Oropeza
2311	189	Sud Cinti
2312	189	Tomina
2313	189	Yamparaez
2314	189	Zuda??ez
2315	190	Arani
2316	190	Arque
2317	190	Ayopaya
2318	190	Bolivar
2319	190	Campero
2320	190	Capinota
2321	190	Carrasco
2322	190	Chapare
2323	190	Esteban Arce
2324	190	German Jordan
2325	190	Mizque
2326	190	Punata
2327	190	Quillacollo
2328	190	Tapacari
2329	190	Tiraque
2330	191	Abel Iturralde
2331	191	Aroma
2332	191	Bautista Saavedra
2333	191	Camacho
2334	191	Caranavi
2335	191	Franz Tamayo
2336	191	Gral. J. Manuel Pando
2337	191	Gualberto Villarroel
2338	191	Ingavi
2339	191	Inquisivi
2340	191	Larecaja
2341	191	Loayza
2342	191	Los Andes
2343	191	Manco Kapac
2344	191	Mu??ecas
2345	191	Murillo
2346	191	Nor Yungas
2347	191	Omasuyos
2348	191	Pacajes
2349	191	Sur Yungas
2350	192	Abaroa
2351	192	Carangas
2352	192	Ladislao Cabrera
2353	192	Litoral
2354	192	Mejillones
2355	192	Nor Carangas
2356	192	Pantaleon Dalence
2357	192	Poopo
2358	192	S. Pedro de Totora
2359	192	Sabaya
2360	192	Sajama
2361	192	Saucari
2362	192	Sebastian Pagador
2363	192	Sur Carangas
2364	192	Tomas Barron
2365	193	Abuna
2366	193	Gral. Federico Roman
2367	193	Madre de Dios
2368	193	Manuripi
2369	193	Nicolas Suarez
2370	194	Alonzo de Iba??ez
2371	194	Antonio Quijarro
2372	194	Charcas
2373	194	Chayanta
2374	194	Cornelio Saavedra
2375	194	Daniel Campos
2376	194	Enrique Baldiviezo
2377	194	Gral. B. Bilbao
2378	194	Jose Maria Linares
2379	194	Modesto Omiste
2380	194	Nor Chichas
2381	194	Nor Lipez
2382	194	Rafael Bustillo
2383	194	Sur Chichas
2384	194	Sur Lipez
2385	194	Tomas Frias
2386	195	Andres Iba??ez
2387	195	Angel Sandoval
2388	195	Caballero
2389	195	Chiquitos
2390	195	Cordillera
2391	195	Florida
2392	195	German Busch
2393	195	Guarayos
2394	195	Ichilo
2395	195	??uflo de Chavez
2396	195	Obispo Santiestevan
2397	195	Sara
2398	195	Vallegrande
2399	195	Velasco
2400	195	Warnes
2401	196	Arce
2402	196	Avilez
2403	196	Burnet O' Connor
2404	196	Gran Chaco
2405	196	Mendez
2406	197	Almirante
2407	197	Bocas del Toro
2408	197	Changuinola
2409	197	Chiriqu?? Grande
2410	198	Alanje
2411	198	Bar??
2412	198	Boquer??n
2413	198	Boquete
2414	198	Bugaba
2415	198	David
2416	198	Dolega
2417	198	Gualaca
2418	198	Remedios
2419	198	Renacimiento
2420	198	San F??lix
2421	198	San Lorenzo
2422	198	Tierras Altas
2423	198	Tol??
2424	199	Aguadulce
2425	199	Ant??n
2426	199	La Pintada
2427	199	Nat??
2428	199	Ol??
2429	199	Penonom??
2430	200	Col??n
2431	200	Chagres
2432	200	Donoso
2433	200	Portobelo
2434	200	Santa Isabel
2435	200	Omar Torrijos Herrera
2436	201	Chepigana
2437	201	Pinogana
2438	201	Santa Fe
2439	202	Chitr??
2440	202	Las Minas
2441	202	Los Pozos
2442	202	Oc??
2443	202	Parita
2444	202	Pes??
2445	202	Santa Mar??a
2446	203	Guarar??
2447	203	Las Tablas
2448	203	Los Santos
2449	203	Macaracas
2450	203	Pedas??
2451	203	Pocr??
2452	203	Tonos??
2453	204	Balboa
2454	204	Chepo
2455	204	Chim??n
2456	204	Panam??
2457	204	San Miguelito
2458	204	Taboga
2459	205	Arraij??n
2460	205	Capira
2461	205	Chame
2462	205	La Chorrera
2463	205	San Carlos
2464	206	Atalaya
2465	206	Calobre
2466	206	Ca??azas
2467	206	La Mesa
2468	206	Las Palmas
2469	206	Mariato
2470	206	Montijo
2471	206	R??o de Jes??s
2472	206	San Francisco
2473	206	Santiago
2474	206	Son??
2475	207	C??maco
2476	207	Samb??
2477	208	(Ninguno)
2478	209	Naso Tj??r Di
2479	210	Besik??
2480	210	Kankint??
2481	210	Kusap??n
2482	210	Miron??
2483	210	M??na
2484	210	Nole D??ima
2485	210	????r??m
2486	210	Jirondai
2487	210	Santa Catalina o Calov??bora
2488	211	Chahal
2489	211	Chisec
2490	211	Cob??na???
2491	211	Fray Bartolom?? de las Casas
2492	211	La Tinta
2493	211	Lanqu??n
2494	211	Panz??s
2495	211	Raxruh??
2496	211	San Juan Chamelco
2497	211	San Pedro Carch??
2498	211	Santa Cruz Verapaz
2499	211	Santa Mar??a Cahab??n
2500	211	Senah??
2501	211	Tamah??
2502	211	Tactic
2503	211	Tucur??
2504	212	Cubulco
2505	212	Granados
2506	212	Purulh??
2507	212	Rabinal
2508	212	Salam??a???
2509	212	San Jer??nimo
2510	212	San Miguel Chicaj
2511	212	Santa Cruz el Chol
2512	213	Acatenango
2513	213	Chimaltenangoa???
2514	213	El Tejar
2515	213	Parramos
2516	213	Patzic??a
2517	213	Patz??n
2518	213	Pochuta
2519	213	San Andr??s Itzapa
2520	213	San Jos?? Poaqu??l
2521	213	San Juan Comalapa
2522	213	San Mart??n Jilotepeque
2523	213	Santa Apolonia
2524	213	Santa Cruz Balany??
2525	213	Tecp??n
2526	213	Yepocapa
2527	213	Zaragoza
2528	214	Camot??n
2529	214	Chiquimulaa???
2530	214	Concepci??n Las Minas
2531	214	Esquipulas
2532	214	Ipala
2533	214	Olopa
2534	214	Quetzaltepeque
2535	214	San Jacinto
2536	214	San Jos?? la Arada
2537	214	San Juan Ermita
2538	215	El J??caro
2539	215	Guastatoyaa???
2540	215	Moraz??n
2541	215	San Agust??n Acasaguastl??n
2542	215	San Antonio La Paz
2543	215	San Crist??bal Acasaguastl??n
2544	215	Sanarate
2545	215	Sansare
2546	216	Escuintlaa???
2547	216	Guanagazapa
2548	216	Iztapa
2549	216	La Democracia
2550	216	La Gomera
2551	216	Masagua
2552	216	Nueva Concepci??n
2553	216	Pal??n
2554	216	San Jos??
2555	216	San Vicente Pacaya
2556	216	Santa Luc??a Cotzumalguapa
2557	216	Sipacate
2558	216	Siquinal??
2559	216	Tiquisate
2560	217	Amatitl??n
2561	217	Chinautla
2562	217	Chuarrancho
2563	217	Ciudad de Guatemalaa???
2564	217	Fraijanes
2565	217	Mixco
2566	217	Palencia
2567	217	San Jos?? del Golfo
2568	217	San Jos?? Pinula
2569	217	San Juan Sacatep??quez
2570	217	San Miguel Petapa
2571	217	San Pedro Ayampuc
2572	217	San Pedro Sacatep??quez
2573	217	San Raymundo
2574	217	Santa Catarina Pinula
2575	217	Villa Canales
2576	217	Villa Nueva
2577	218	Aguacat??n
2578	218	Chiantla
2579	218	Colotenango
2580	218	Concepci??n Huista
2581	218	Cuilco
2582	218	Huehuetenangoa???
2583	218	Jacaltenango
2584	218	La Libertad
2585	218	Malacatancito
2586	218	Nent??n
2587	218	Petat??n
2588	218	San Antonio Huista
2589	218	San Gaspar Ixchil
2590	218	San Ildefonso Ixtahuac??n
2591	218	San Juan Atit??n
2592	218	San Juan Ixcoy
2593	218	San Mateo Ixtat??n
2594	218	San Miguel Acat??n
2595	218	San Pedro N??cta
2596	218	San Pedro Soloma
2597	218	San Rafael La Independencia
2598	218	San Rafael P??tzal
2599	218	San Sebasti??n Coat??n
2600	218	San Sebasti??n Huehuetenango
2601	218	Santa Ana Huista
2602	218	Santa B??rbara
2603	218	Santa Cruz Barillas
2604	218	Santa Eulalia
2605	218	Santiago Chimaltenango
2606	218	Tectit??n
2607	218	Todos Santos Cuchumat??n
2608	218	Uni??n Cantinil
2609	219	El Estor
2610	219	Livingston
2611	219	Los Amates
2612	219	Morales
2613	219	Puerto Barriosa???
2614	220	Jalapaa???
2615	220	Mataquescuintla
2616	220	Monjas
2617	220	San Carlos Alzatate
2618	220	San Luis Jilotepeque
2619	220	San Manuel Chaparr??n
2620	220	San Pedro Pinula
2621	221	Agua Blanca
2622	221	Asunci??n Mita
2623	221	Atescatempa
2624	221	Comapa
2625	221	Conguaco
2626	221	El Adelanto
2627	221	El Progreso
2628	221	Jalpatagua
2629	221	Jerez
2630	221	Jutiapaa???
2631	221	Moyuta
2632	221	Pasaco
2633	221	Quesada
2634	221	San Jos?? Acatempa
2635	221	Santa Catarina Mita
2636	221	Yupiltepeque
2637	221	Zapotitl??n
2638	222	Dolores
2639	222	El Chal
2640	222	Isla de Flores,??Santa Elena de la Cruza???
2641	222	Las Cruces
2642	222	Melchor de Mencos
2643	222	Popt??n
2644	222	San Andr??sh???
2645	222	San Benito
2646	222	San Francisco
2647	222	San Luis
2648	222	Santa Ana
2649	222	Sayaxch??
2650	223	Almolonga
2651	223	Cabric??n
2652	223	Cajol??
2653	223	Cantel
2654	223	Coatepeque
2655	223	Colomba Costa Cuca
2656	223	Concepci??n Chiquirichapa
2657	223	El Palmar
2658	223	Flores Costa Cuca
2659	223	G??nova
2660	223	Huit??n
2661	223	La Esperanza
2662	223	Olintepeque
2663	223	Palestina de Los Altos
2664	223	Quetzaltenangoa???
2665	223	Salcaj??
2666	223	San Carlos Sija
2667	223	San Francisco La Uni??n
2668	223	San Juan Ostuncalco
2669	223	San Mart??n Sacatep??quez
2670	223	San Mateo
2671	223	San Miguel Sig??il??
2672	223	Sibilia
2673	223	Zunil
2674	224	Canill??
2675	224	Chajul
2676	224	Chicam??n
2677	224	Chich??
2678	224	Santo Tom??s Chichicastenango
2679	224	Chinique
2680	224	Cun??n
2681	224	Ixc??n
2682	224	Joyabaj
2683	224	Nebaj
2684	224	Pachalum
2685	224	Patzit??
2686	224	Sacapulas
2687	224	San Andr??s Sajcabaj??
2688	224	San Antonio Ilotenango
2689	224	San Bartolom?? Jocotenango
2690	224	San Juan Cotzal
2691	224	San Pedro Jocopilas
2692	224	Santa Cruz del Quich??a???
2693	224	Uspant??n
2694	224	Zacualpa
2695	225	Champerico
2696	225	El Asintal
2697	225	Nuevo San Carlos
2698	225	Retalhuleua???
2699	225	San Andr??s Villa Seca
2700	225	San Felipe
2701	225	San Mart??n Zapotitl??n
2702	225	San Sebasti??n
2703	225	Santa Cruz Mulu??
2704	226	Alotenango
2705	226	Ciudad Vieja
2706	226	Jocotenango
2707	226	Antigua Guatemalaa???
2708	226	Magdalena Milpas Altas
2709	226	Pastores
2710	226	San Antonio Aguas Calientes
2711	226	San Bartolom?? Milpas Altas
2712	226	San Lucas Sacatep??quez
2713	226	San Miguel Due??as
2714	226	Santa Catarina Barahona
2715	226	Santa Luc??a Milpas Altas
2716	226	Santa Mar??a de Jes??s
2717	226	Santiago Sacatep??quez
2718	226	Santo Domingo Xenacoj
2719	226	Sumpango
2720	227	Ayutla
2721	227	Catarina
2722	227	Comitancillo
2723	227	Concepci??n Tutuapa
2724	227	El Quetzal
2725	227	El Tumbador
2726	227	Esquipulas Palo Gordo
2727	227	Ixchigu??n
2728	227	La Blanca
2729	227	La Reforma
2730	227	Malacat??n
2731	227	Nuevo Progreso
2732	227	Oc??s
2733	227	Pajapita
2734	227	R??o Blanco
2735	227	San Antonio Sacatep??quez
2736	227	San Crist??bal Cucho
2737	227	San Jos?? El Rodeo
2738	227	San Jos?? Ojetenam
2739	227	San Lorenzo
2740	227	San Marcosa???
2741	227	San Miguel Ixtahuac??n
2742	227	San Pablo
2743	227	San Rafael Pie de la Cuesta
2744	227	Sibinal
2745	227	Sipacapa
2746	227	Tacan??
2747	227	Tajumulco
2748	227	Tejutla
2749	228	Barberena
2750	228	Casillas
2751	228	Chiquimulilla
2752	228	Cuilapaa???
2753	228	Guazacap??n
2754	228	Nueva Santa Rosa
2755	228	Oratorio
2756	228	Pueblo Nuevo Vi??as
2757	228	San Juan Tecuaco
2758	228	San Rafael las Flores
2759	228	Santa Cruz Naranjo
2760	228	Santa Mar??a Ixhuat??n
2761	228	Santa Rosa de Lima
2762	228	Taxisco
2763	229	Concepci??n
2764	229	Nahual??
2765	229	Panajachel
2766	229	San Andr??s Semetabaj
2767	229	San Antonio Palop??
2768	229	San Jos?? Chacay??
2769	229	San Juan La Laguna
2770	229	San Lucas Tolim??n
2771	229	San Marcos La Laguna
2772	229	San Pablo La Laguna
2773	229	San Pedro La Laguna
2774	229	Santa Catarina Ixtahuac??n
2775	229	Santa Catarina Palop??
2776	229	Santa Clara La Laguna
2777	229	Santa Cruz La Laguna
2778	229	Santa Luc??a Utatl??n
2779	229	Santa Mar??a Visitaci??n
2780	229	Santiago Atitl??n
2781	229	Solol??a???
2782	230	Chicacao
2783	230	Cuyotenango
2784	230	Mazatenangoa???
2785	230	Patulul
2786	230	Pueblo Nuevo
2787	230	R??o Bravo
2788	230	Samayac
2789	230	San Antonio Suchitep??quez
2790	230	San Bernardino
2791	230	San Francisco Zapotitl??n
2792	230	San Gabriel
2793	230	San Jos?? El ??dolo
2794	230	San Jos?? La M??quina
2795	230	San Juan Bautista
2796	230	San Miguel Pan??n
2797	230	San Pablo Jocopilas
2798	230	Santo Domingo Suchitep??quez
2799	230	Santo Tom??s La Uni??n
2800	230	Zunilito
2801	231	Momostenango
2802	231	San Andr??s Xecul
2803	231	San Bartolo
2804	231	San Crist??bal Totonicap??n
2805	231	San Francisco El Alto
2806	231	Santa Luc??a La Reforma
2807	231	Santa Mar??a Chiquimula
2808	231	Totonicap??na???
2809	232	Caba??as
2810	232	Estanzuela
2811	232	Gual??n
2812	232	Huit??
2813	232	La Uni??n
2814	232	R??o Hondo
2815	232	San Diego
2816	232	San Jorge
2817	232	Teculut??n
2818	232	Usumatl??n
2819	233	La Ceiba
2820	233	Tela
2821	233	Jutiapa
2822	233	La Masica
2823	233	San Francisco
2824	233	Arizona
2825	233	Esparta
2826	233	El Porvenir
2827	234	Trujillo
2828	234	Balfate
2829	234	Iriona
2830	234	Lim??n
2831	234	Sab??
2832	234	Santa Fe
2833	234	Santa Rosa de Agu??n
2834	234	Sonaguera
2835	234	Tocoa
2836	234	Bonito Oriental
2837	235	Comayagua
2838	235	Ajuterique
2839	235	El Rosario
2840	235	Esqu??as
2841	235	Humuya
2842	235	La libertad
2843	235	Laman??
2844	235	La Trinidad
2845	235	Lejamani
2846	235	Meambar
2847	235	Minas de Oro
2848	235	Ojos de Agua
2849	235	San Jer??nimo (Honduras)
2850	235	San Jos?? de Comayagua
2851	235	San Jos?? del Potrero
2852	235	San Luis
2853	235	San Sebasti??n
2854	235	Siguatepeque
2855	235	Villa de San Antonio
2856	235	Las Lajas
2857	235	Taulab??
2858	236	Santa Rosa de Cop??n
2859	236	Caba??as
2860	236	Concepci??n
2861	236	Cop??n Ruinas
2862	236	Corqu??n
2863	236	Cucuyagua
2864	236	Dolores
2865	236	Dulce Nombre
2866	236	El Para??so
2867	236	Florida
2868	236	La Jigua
2869	236	La Uni??n
2870	236	Nueva Arcadia
2871	236	San Agust??n
2872	236	San Antonio
2873	236	San Jer??nimo
2874	236	San Jos??
2875	236	San Juan de Opoa
2876	236	San Nicol??s
2877	236	San Pedro
2878	236	Santa Rita
2879	236	Trinidad de Cop??n
2880	236	Veracruz
2881	237	San Pedro Sula
2882	237	Choloma
2883	237	Omoa
2884	237	Pimienta
2885	237	Potrerillos
2886	237	Puerto Cort??s
2887	237	San Antonio de Cort??s
2888	237	San Francisco de Yojoa
2889	237	San Manuel
2890	237	Santa Cruz de Yojoa
2891	237	Villanueva
2892	237	La Lima
2893	238	Choluteca
2894	238	Apacilagua
2895	238	Concepci??n de Mar??a
2896	238	Duyure
2897	238	El Corpus
2898	238	El Triunfo
2899	238	Marcovia
2900	238	Morolica
2901	238	Namasigue
2902	238	Orocuina
2903	238	Pespire
2904	238	San Antonio de Flores
2905	238	San Isidro
2906	238	San Marcos de Col??n
2907	238	Santa Ana de Yusguare
2908	239	Yuscar??n
2909	239	Alauca
2910	239	Danl??
2911	239	G??inope
2912	239	Jacaleapa
2913	239	Liure
2914	239	Morocel??
2915	239	Oropol??
2916	239	San Lucas
2917	239	San Mat??as
2918	239	Soledad
2919	239	Teupasenti
2920	239	Texiguat
2921	239	Vado Ancho
2922	239	Yauyupe
2923	239	Trojes
2924	240	Distrito Central
2925	240	Alubar??n
2926	240	Cedros
2927	240	Curar??n
2928	240	Guaimaca
2929	240	La Libertad
2930	240	La Venta
2931	240	Lepaterique
2932	240	Maraita
2933	240	Marale
2934	240	Nueva Armenia
2935	240	Ojojona
2936	240	Orica
2937	240	Reitoca
2938	240	Sabanagrande
2939	240	San Antonio de Oriente
2940	240	San Buenaventura
2941	240	San Ignacio
2942	240	San Juan de Flores
2943	240	San Miguelito
2944	240	Santa Ana
2945	240	Santa Luc??a
2946	240	Talanga
2947	240	Tatumbla
2948	240	Valle de ??ngeles
2949	240	Villa de San Francisco
2950	240	Vallecillo
2951	241	Puerto Lempira
2952	241	Brus Laguna
2953	241	Ahuas
2954	241	Juan Francisco Bulnes
2955	241	Ram??n Villeda Morales
2956	241	Wampusirpe
2957	242	La Esperanza
2958	242	Camasca
2959	242	Colomoncagua
2960	242	Intibuc??
2961	242	Jes??s de Otoro
2962	242	Magdalena
2963	242	Masaguara
2964	242	San Juan
2965	242	San Marcos de la Sierra
2966	242	San Miguel Guancapla
2967	242	Yamaranguila
2968	242	San Francisco de Opalaca
2969	243	Roat??n
2970	243	Guanaja
2971	243	Jos?? Santos Guardiola
2972	243	Utila
2973	244	La Paz
2974	244	Aguanqueterique
2975	244	Cane
2976	244	Chinacla
2977	244	Guajiquiro
2978	244	Lauterique
2979	244	Marcala
2980	244	Mercedes de Oriente
2981	244	Opatoro
2982	244	San Antonio del Norte
2983	244	San Pedro de Tutule
2984	244	Santa Elena
2985	244	Santa Mar??a
2986	244	Santiago de Puringla
2987	244	Yarula
2988	245	Gracias
2989	245	Bel??n
2990	245	Candelaria
2991	245	Cololaca
2992	245	Erandique
2993	245	Gualcince
2994	245	Guarita
2995	245	La Campa
2996	245	La Iguala
2997	245	Las Flores
2998	245	La Virtud
2999	245	Lepaera
3000	245	Mapulaca
3001	245	Piraera
3002	245	San Andr??s
3003	245	San Juan Guarita
3004	245	San Manuel Colohete
3005	245	San Rafael
3006	245	Santa Cruz
3007	245	Talgua
3008	245	Tambla
3009	245	Tomal??
3010	245	Valladolid
3011	245	Virginia
3012	245	San Marcos de Caiqu??n
3013	246	Ocotepeque
3014	246	Bel??n Gualcho
3015	246	Dolores Merend??n
3016	246	Fraternidad
3017	246	La Encarnaci??n
3018	246	La Labor
3019	246	Lucerna
3020	246	Mercedes
3021	246	San Fernando
3022	246	San Francisco del Valle
3023	246	San Jorge
3024	246	San Marcos
3025	246	Sensenti
3026	246	Sinuapa
3027	247	Juticalpa
3028	247	Campamento
3029	247	Catacamas
3030	247	Concordia
3031	247	Dulce Nombre de Culm??
3032	247	Esquipulas del Norte
3033	247	Gualaco
3034	247	Guarizama
3035	247	Guata
3036	247	Guayape
3037	247	Jano
3038	247	Mangulile
3039	247	Manto
3040	247	Salam??
3041	247	San Esteban
3042	247	San Francisco de Becerra
3043	247	San Francisco de la Paz
3044	247	Santa Mar??a del Real
3045	247	Silca
3046	247	Yoc??n
3047	247	Patuca
3048	248	Santa B??rbara
3049	248	Arada
3050	248	Atima
3051	248	Azacualpa
3052	248	Ceguaca
3053	248	Concepci??n del Norte
3054	248	Concepci??n del Sur
3055	248	Chinda
3056	248	El N??spero
3057	248	Gualala
3058	248	Ilama
3059	248	Las Vegas
3060	248	Macuelizo
3061	248	Naranjito
3062	248	Nuevo Celilac
3063	248	Nueva Frontera
3064	248	Petoa
3065	248	Protecci??n
3066	248	Quimist??n
3067	248	San Francisco de Ojuera
3068	248	San Jos?? de las Colinas
3069	248	San Pedro Zacapa
3070	248	San Vicente Centenario
3071	248	Trinidad
3072	249	Nacaome
3073	249	Alianza
3074	249	Amapala
3075	249	Aramecina
3076	249	Caridad
3077	249	Goascor??n
3078	249	Langue
3079	249	San Francisco de Coray
3080	249	San Lorenzo
3081	250	Yoro
3082	250	Arenal
3083	250	El Negrito
3084	250	El Progreso
3085	250	Joc??n
3086	250	Moraz??n
3087	250	Olanchito
3088	250	Sulaco
3089	250	Victoria
3090	251	Boaco
3091	251	Camoapa
3092	251	San Jos?? de los Remates
3093	251	San Lorenzo
3094	251	Santa Luc??a
3095	251	Teustepe
3096	252	Diriamba
3097	252	Dolores
3098	252	El Rosario
3099	252	Jinotepe
3100	252	La Conquista
3101	252	La Paz de Oriente
3102	252	San Marcos
3103	252	Santa Teresa
3104	253	Chichigalpa
3105	253	Chinandega
3106	253	Cinco Pinos
3107	253	Corinto
3108	253	El Realejo
3109	253	El Viejo
3110	253	Posoltega
3111	253	Puerto Moraz??n
3112	253	San Francisco del Norte
3113	253	San Pedro del Norte
3114	253	Santo Tom??s del Norte
3115	253	Somotillo
3116	253	Villanueva
3117	254	Acoyapa
3118	254	Comalapa
3119	254	Cuapa
3120	254	El Coral
3121	254	Juigalpa
3122	254	La Libertad
3123	254	San Pedro de L??vago
3124	254	Santo Domingo
3125	254	Santo Tom??s
3126	254	Villa Sandino
3127	255	Bonanza
3128	255	Mulukuk??
3129	255	Prinzapolka
3130	255	Puerto Cabezas
3131	255	Rosita
3132	255	Siuna
3133	255	Waslala
3134	255	Wasp??n
3135	256	Bluefields
3136	256	Desembocadura de R??o Grande
3137	256	El Ayote
3138	256	El Rama
3139	256	El Tortuguero
3140	256	Islas del Ma??z
3141	256	Kukra Hill
3142	256	La Cruz de R??o Grande
3143	256	Laguna de Perlas
3144	256	Muelle de los Bueyes
3145	256	Nueva Guinea
3146	256	Paiwas
3147	257	Condega
3148	257	Estel??
3149	257	La Trinidad
3150	257	Pueblo Nuevo
3151	257	San Juan de Limay
3152	257	San Nicol??s
3153	258	Diri??
3154	258	Diriomo
3155	258	Granada
3156	258	Nandaime
3157	259	El Cu??
3158	259	Jinotega
3159	259	La Concordia
3160	259	San Jos?? de Bocay
3161	259	San Rafael del Norte
3162	259	San Sebasti??n de Yal??
3163	259	Santa Mar??a de Pantasma
3164	259	Wiwil?? de Jinotega
3165	260	Achuapa
3166	260	El Jicaral
3167	260	El Sauce
3168	260	La Paz Centro
3169	260	Larreynaga
3170	260	Le??n
3171	260	Nagarote
3172	260	Quezalguaque
3173	260	Santa Rosa del Pe????n
3174	260	Telica
3175	261	Las Sabanas
3176	261	Palacag??ina
3177	261	San Jos?? de Cusmapa
3178	261	San Juan de R??o Coco
3179	261	San Lucas
3180	261	Somoto
3181	261	Telpaneca
3182	261	Totogalpa
3183	261	Yalag??ina
3184	262	Ciudad Sandino
3185	262	El Crucero
3186	262	Managua
3187	262	Mateare
3188	262	San Francisco Libre
3189	262	San Rafael del Sur
3190	262	Ticuantepe
3191	262	Tipitapa
3192	262	Villa El Carmen
3193	263	Catarina
3194	263	La Concepci??n
3195	263	Masatepe
3196	263	Masaya
3197	263	Nandasmo
3198	263	Nindir??
3199	263	Niquinohomo
3200	263	San Juan de Oriente
3201	263	Tisma
3202	264	Ciudad Dar??o
3203	264	El Tuma - La Dalia
3204	264	Esquipulas
3205	264	Matagalpa
3206	264	Matigu??s
3207	264	Muy Muy
3208	264	Rancho Grande
3209	264	R??o Blanco
3210	264	San Dionisio
3211	264	San Isidro
3212	264	San Ram??n
3213	264	S??baco
3214	264	Terrabona
3215	265	Ciudad Antigua
3216	265	Dipilto
3217	265	El J??caro
3218	265	Jalapa
3219	265	Macuelizo
3220	265	Mozonte
3221	265	Murra
3222	265	Ocotal
3223	265	Quilal??
3224	265	San Fernando
3225	265	Santa Mar??a
3226	265	Wiwil??
3227	266	El Almendro
3228	266	El Castillo
3229	266	Morrito
3230	266	San Carlos
3231	266	San Juan del Norte
3232	266	San Miguelito
3233	267	Altagracia
3234	267	Bel??n
3235	267	Buenos Aires
3236	267	C??rdenas
3237	267	Moyogalpa
3238	267	Potos??
3239	267	Rivas
3240	267	San Jorge
3241	267	San Juan del Sur
3242	268	AGUASCALIENTES
3243	268	ASIENTOS
3244	268	CALVILLO
3245	268	COS??O
3246	268	JES??S MAR??A
3247	268	PABELL??N DE ARTEAGA
3248	268	RINC??N DE ROMOS
3249	268	SAN JOS?? DE GRACIA
3250	268	TEPEZAL??
3251	268	EL LLANO
3252	268	SAN FRANCISCO DE LOS ROMO
3253	269	ENSENADA
3254	269	MEXICALI
3255	269	TECATE
3256	269	TIJUANA
3257	269	PLAYAS DE ROSARITO
3258	270	COMOND??
3259	270	MULEG??
3260	270	LA PAZ
3261	270	LOS CABOS
3262	270	LORETO
3263	271	CALKIN??
3264	271	CAMPECHE
3265	271	CARMEN
3266	271	CHAMPOT??N
3267	271	HECELCHAK??N
3268	271	HOPELCH??N
3269	271	PALIZADA
3270	271	TENABO
3271	271	ESC??RCEGA
3272	271	CALAKMUL
3273	271	CANDELARIA
3274	272	ACACOYAGUA
3275	272	ACALA
3276	272	ACAPETAHUA
3277	272	ALTAMIRANO
3278	272	AMAT??N
3279	272	AMATENANGO DE LA FRONTERA
3280	272	AMATENANGO DEL VALLE
3281	272	ANGEL ALBINO CORZO
3282	272	ARRIAGA
3283	272	BEJUCAL DE OCAMPO
3284	272	BELLA VISTA
3285	272	BERRIOZ??BAL
3286	272	BOCHIL
3287	272	EL BOSQUE
3288	272	CACAHOAT??N
3289	272	CATAZAJ??
3290	272	CINTALAPA
3291	272	COAPILLA
3292	272	COMIT??N DE DOM??NGUEZ
3293	272	LA CONCORDIA
3294	272	COPAINAL??
3295	272	CHALCHIHUIT??N
3296	272	CHAMULA
3297	272	CHANAL
3298	272	CHAPULTENANGO
3299	272	CHENALH??
3300	272	CHIAPA DE CORZO
3301	272	CHIAPILLA
3302	272	CHICOAS??N
3303	272	CHICOMUSELO
3304	272	CHIL??N
3305	272	ESCUINTLA
3306	272	FRANCISCO LE??N
3307	272	FRONTERA COMALAPA
3308	272	FRONTERA HIDALGO
3309	272	LA GRANDEZA
3310	272	HUEHUET??N
3311	272	HUIXT??N
3312	272	HUITIUP??N
3313	272	HUIXTLA
3314	272	LA INDEPENDENCIA
3315	272	IXHUAT??N
3316	272	IXTACOMIT??N
3317	272	IXTAPA
3318	272	IXTAPANGAJOYA
3319	272	JIQUIPILAS
3320	272	JITOTOL
3321	272	JU??REZ
3322	272	LARR??INZAR
3323	272	LA LIBERTAD
3324	272	MAPASTEPEC
3325	272	LAS MARGARITAS
3326	272	MAZAPA DE MADERO
3327	272	MAZAT??N
3328	272	METAPA
3329	272	MITONTIC
3330	272	MOTOZINTLA
3331	272	NICOL??S RU??Z
3332	272	OCOSINGO
3333	272	OCOTEPEC
3334	272	OCOZOCOAUTLA DE ESPINOSA
3335	272	OSTUAC??N
3336	272	OSUMACINTA
3337	272	OXCHUC
3338	272	PALENQUE
3339	272	PANTELH??
3340	272	PANTEPEC
3341	272	PICHUCALCO
3342	272	PIJIJIAPAN
3343	272	EL PORVENIR
3344	272	VILLA COMALTITL??N
3345	272	PUEBLO NUEVO SOLISTAHUAC??N
3346	272	RAY??N
3347	272	REFORMA
3348	272	LAS ROSAS
3349	272	SABANILLA
3350	272	SALTO DE AGUA
3351	272	SAN CRIST??BAL DE LAS CASAS
3352	272	SAN FERNANDO
3353	272	SILTEPEC
3354	272	SIMOJOVEL
3355	272	SITAL??
3356	272	SOCOLTENANGO
3357	272	SOLOSUCHIAPA
3358	272	SOYAL??
3359	272	SUCHIAPA
3360	272	SUCHIATE
3361	272	SUNUAPA
3362	272	TAPACHULA
3363	272	TAPALAPA
3364	272	TAPILULA
3365	272	TECPAT??N
3366	272	TENEJAPA
3367	272	TEOPISCA
3368	272	TILA
3369	272	TONAL??
3370	272	TOTOLAPA
3371	272	LA TRINITARIA
3372	272	TUMBAL??
3373	272	TUXTLA GUTI??RREZ
3374	272	TUXTLA CHICO
3375	272	TUZANT??N
3376	272	TZIMOL
3377	272	UNI??N JU??REZ
3378	272	VENUSTIANO CARRANZA
3379	272	VILLA CORZO
3380	272	VILLAFLORES
3381	272	YAJAL??N
3382	272	SAN LUCAS
3383	272	ZINACANT??N
3384	272	SAN JUAN CANCUC
3385	272	ALDAMA
3386	272	BENEM??RITO DE LAS AM??RICAS
3387	272	MARAVILLA TENEJAPA
3388	272	MARQU??S DE COMILLAS
3389	272	MONTECRISTO DE GUERRERO
3390	272	SAN ANDR??S DURAZNAL
3391	272	SANTIAGO EL PINAR
3392	273	AHUMADA
3393	273	ALLENDE
3394	273	AQUILES SERD??N
3395	273	ASCENSI??N
3396	273	BACH??NIVA
3397	273	BALLEZA
3398	273	BATOPILAS
3399	273	BOCOYNA
3400	273	BUENAVENTURA
3401	273	CAMARGO
3402	273	CARICH??
3403	273	CASAS GRANDES
3404	273	CORONADO
3405	273	COYAME DEL SOTOL
3406	273	LA CRUZ
3407	273	CUAUHT??MOC
3408	273	CUSIHUIRIACHI
3409	273	CHIHUAHUA
3410	273	CH??NIPAS
3411	273	DELICIAS
3412	273	DR. BELISARIO DOM??NGUEZ
3413	273	GALEANA
3414	273	SANTA ISABEL
3415	273	G??MEZ FAR??AS
3416	273	GRAN MORELOS
3417	273	GUACHOCHI
3418	273	GUADALUPE
3419	273	GUADALUPE Y CALVO
3420	273	GUAZAPARES
3421	273	GUERRERO
3422	273	HIDALGO DEL PARRAL
3423	273	HUEJOTIT??N
3424	273	IGNACIO ZARAGOZA
3425	273	JANOS
3426	273	JIM??NEZ
3427	273	JULIMES
3428	273	L??PEZ
3429	273	MADERA
3430	273	MAGUARICHI
3431	273	MANUEL BENAVIDES
3432	273	MATACH??
3433	273	MATAMOROS
3434	273	MEOQUI
3435	273	MORELOS
3436	273	MORIS
3437	273	NAMIQUIPA
3438	273	NONOAVA
3439	273	NUEVO CASAS GRANDES
3440	273	OCAMPO
3441	273	OJINAGA
3442	273	PRAXEDIS G. GUERRERO
3443	273	RIVA PALACIO
3444	273	ROSALES
3445	273	ROSARIO
3446	273	SAN FRANCISCO DE BORJA
3447	273	SAN FRANCISCO DE CONCHOS
3448	273	SAN FRANCISCO DEL ORO
3449	273	SANTA B??RBARA
3450	273	SATEV??
3451	273	SAUCILLO
3452	273	TEM??SACHIC
3453	273	EL TULE
3454	273	URIQUE
3455	273	URUACHI
3456	273	VALLE DE ZARAGOZA
3457	274	AZCAPOTZALCO
3458	274	COYOAC??N
3459	274	CUAJIMALPA DE MORELOS
3460	274	GUSTAVO A. MADERO
3461	274	IZTACALCO
3462	274	IZTAPALAPA
3463	274	LA MAGDALENA CONTRERAS
3464	274	MILPA ALTA
3465	274	??LVARO OBREG??N
3466	274	TL??HUAC
3467	274	TLALPAN
3468	274	XOCHIMILCO
3469	274	BENITO JU??REZ
3470	274	MIGUEL HIDALGO
3471	275	ABASOLO
3472	275	ACU??A
3473	275	ARTEAGA
3474	275	CANDELA
3475	275	CASTA??OS
3476	275	CUATRO CI??NEGAS
3477	275	ESCOBEDO
3478	275	FRANCISCO I. MADERO
3479	275	FRONTERA
3480	275	GENERAL CEPEDA
3481	275	HIDALGO
3482	275	LAMADRID
3483	275	MONCLOVA
3484	275	M??ZQUIZ
3485	275	NADADORES
3486	275	NAVA
3487	275	PARRAS
3488	275	PIEDRAS NEGRAS
3489	275	PROGRESO
3490	275	RAMOS ARIZPE
3491	275	SABINAS
3492	275	SACRAMENTO
3493	275	SALTILLO
3494	275	SAN BUENAVENTURA
3495	275	SAN JUAN DE SABINAS
3496	275	SAN PEDRO
3497	275	SIERRA MOJADA
3498	275	TORRE??N
3499	275	VIESCA
3500	275	VILLA UNI??N
3501	275	ZARAGOZA
3502	276	ARMER??A
3503	276	COLIMA
3504	276	COMALA
3505	276	COQUIMATL??N
3506	276	IXTLAHUAC??N
3507	276	MANZANILLO
3508	276	MINATITL??N
3509	276	TECOM??N
3510	276	VILLA DE ??LVAREZ
3511	277	DURANGO
3512	277	CANATL??N
3513	277	CANELAS
3514	277	CONETO DE COMONFORT
3515	277	CUENCAM??
3516	277	GENERAL SIM??N BOL??VAR
3517	277	G??MEZ PALACIO
3518	277	GUADALUPE VICTORIA
3519	277	GUANACEV??
3520	277	IND??
3521	277	LERDO
3522	277	MAPIM??
3523	277	MEZQUITAL
3524	277	NAZAS
3525	277	NOMBRE DE DIOS
3526	277	EL ORO
3527	277	OT??EZ
3528	277	P??NUCO DE CORONADO
3529	277	PE????N BLANCO
3530	277	POANAS
3531	277	PUEBLO NUEVO
3532	277	RODEO
3533	277	SAN BERNARDO
3534	277	SAN DIMAS
3535	277	SAN JUAN DE GUADALUPE
3536	277	SAN JUAN DEL R??O
3537	277	SAN LUIS DEL CORDERO
3538	277	SAN PEDRO DEL GALLO
3539	277	SANTA CLARA
3540	277	SANTIAGO PAPASQUIARO
3541	277	S??CHIL
3542	277	TAMAZULA
3543	277	TEPEHUANES
3544	277	TLAHUALILO
3545	277	TOPIA
3546	277	VICENTE GUERRERO
3547	277	NUEVO IDEAL
3548	278	AC??MBARO
3549	278	SAN MIGUEL DE ALLENDE
3550	278	APASEO EL ALTO
3551	278	APASEO EL GRANDE
3552	278	ATARJEA
3553	278	CELAYA
3554	278	MANUEL DOBLADO
3555	278	COMONFORT
3556	278	CORONEO
3557	278	CORTAZAR
3558	278	CUER??MARO
3559	278	DOCTOR MORA
3560	278	DOLORES HIDALGO CUNA DE LA INDEPENDENCIA NACIONAL
3561	278	GUANAJUATO
3562	278	HUAN??MARO
3563	278	IRAPUATO
3564	278	JARAL DEL PROGRESO
3565	278	JER??CUARO
3566	278	LE??N
3567	278	MOROLE??N
3568	278	P??NJAMO
3569	278	PUR??SIMA DEL RINC??N
3570	278	ROMITA
3571	278	SALAMANCA
3572	278	SALVATIERRA
3573	278	SAN DIEGO DE LA UNI??N
3574	278	SAN FELIPE
3575	278	SAN FRANCISCO DEL RINC??N
3576	278	SAN JOS?? ITURBIDE
3577	278	SAN LUIS DE LA PAZ
3578	278	SANTA CATARINA
3579	278	SANTA CRUZ DE JUVENTINO ROSAS
3580	278	SANTIAGO MARAVAT??O
3581	278	SILAO DE LA VICTORIA
3582	278	TARANDACUAO
3583	278	TARIMORO
3584	278	TIERRA BLANCA
3585	278	URIANGATO
3586	278	VALLE DE SANTIAGO
3587	278	VICTORIA
3588	278	VILLAGR??N
3589	278	XICH??
3590	278	YURIRIA
3591	279	ACAPULCO DE JU??REZ
3592	279	AHUACUOTZINGO
3593	279	AJUCHITL??N DEL PROGRESO
3594	279	ALCOZAUCA DE GUERRERO
3595	279	ALPOYECA
3596	279	APAXTLA
3597	279	ARCELIA
3598	279	ATENANGO DEL R??O
3599	279	ATLAMAJALCINGO DEL MONTE
3600	279	ATLIXTAC
3601	279	ATOYAC DE ??LVAREZ
3602	279	AYUTLA DE LOS LIBRES
3603	279	AZOY??
3604	279	BUENAVISTA DE CU??LLAR
3605	279	COAHUAYUTLA DE JOS?? MAR??A IZAZAGA
3606	279	COCULA
3607	279	COPALA
3608	279	COPALILLO
3609	279	COPANATOYAC
3610	279	COYUCA DE BEN??TEZ
3611	279	COYUCA DE CATAL??N
3612	279	CUAJINICUILAPA
3613	279	CUAL??C
3614	279	CUAUTEPEC
3615	279	CUETZALA DEL PROGRESO
3616	279	CUTZAMALA DE PINZ??N
3617	279	CHILAPA DE ??LVAREZ
3618	279	CHILPANCINGO DE LOS BRAVO
3619	279	FLORENCIO VILLARREAL
3620	279	GENERAL CANUTO A. NERI
3621	279	GENERAL HELIODORO CASTILLO
3622	279	HUAMUXTITL??N
3623	279	HUITZUCO DE LOS FIGUEROA
3624	279	IGUALA DE LA INDEPENDENCIA
3625	279	IGUALAPA
3626	279	IXCATEOPAN DE CUAUHT??MOC
3627	279	ZIHUATANEJO DE AZUETA
3628	279	JUAN R. ESCUDERO
3629	279	LEONARDO BRAVO
3630	279	MALINALTEPEC
3631	279	M??RTIR DE CUILAPAN
3632	279	METLAT??NOC
3633	279	MOCHITL??N
3634	279	OLINAL??
3635	279	OMETEPEC
3636	279	PEDRO ASCENCIO ALQUISIRAS
3637	279	PETATL??N
3638	279	PILCAYA
3639	279	PUNGARABATO
3640	279	QUECHULTENANGO
3641	279	SAN LUIS ACATL??N
3642	279	SAN MARCOS
3643	279	SAN MIGUEL TOTOLAPAN
3644	279	TAXCO DE ALARC??N
3645	279	TECOANAPA
3646	279	T??CPAN DE GALEANA
3647	279	TELOLOAPAN
3648	279	TEPECOACUILCO DE TRUJANO
3649	279	TETIPAC
3650	279	TIXTLA DE GUERRERO
3651	279	TLACOACHISTLAHUACA
3652	279	TLACOAPA
3653	279	TLALCHAPA
3654	279	TLALIXTAQUILLA DE MALDONADO
3655	279	TLAPA DE COMONFORT
3656	279	TLAPEHUALA
3657	279	LA UNI??N DE ISIDORO MONTES DE OCA
3658	279	XALPATL??HUAC
3659	279	XOCHIHUEHUETL??N
3660	279	XOCHISTLAHUACA
3661	279	ZAPOTITL??N TABLAS
3662	279	ZIR??NDARO
3663	279	ZITLALA
3664	279	EDUARDO NERI
3665	279	ACATEPEC
3666	279	MARQUELIA
3667	279	COCHOAPA EL GRANDE
3668	279	JOS?? JOAQU??N DE HERRERA
3669	279	JUCHIT??N
3670	279	ILIATENCO
3671	280	ACATL??N
3672	280	ACAXOCHITL??N
3673	280	ACTOPAN
3674	280	AGUA BLANCA DE ITURBIDE
3675	280	AJACUBA
3676	280	ALFAJAYUCAN
3677	280	ALMOLOYA
3678	280	APAN
3679	280	EL ARENAL
3680	280	ATITALAQUIA
3681	280	ATLAPEXCO
3682	280	ATOTONILCO EL GRANDE
3683	280	ATOTONILCO DE TULA
3684	280	CALNALI
3685	280	CARDONAL
3686	280	CUAUTEPEC DE HINOJOSA
3687	280	CHAPANTONGO
3688	280	CHAPULHUAC??N
3689	280	CHILCUAUTLA
3690	280	ELOXOCHITL??N
3691	280	EMILIANO ZAPATA
3692	280	EPAZOYUCAN
3693	280	HUASCA DE OCAMPO
3694	280	HUAUTLA
3695	280	HUAZALINGO
3696	280	HUEHUETLA
3697	280	HUEJUTLA DE REYES
3698	280	HUICHAPAN
3699	280	IXMIQUILPAN
3700	280	JACALA DE LEDEZMA
3701	280	JALTOC??N
3702	280	JU??REZ HIDALGO
3703	280	LOLOTLA
3704	280	METEPEC
3705	280	SAN AGUST??N METZQUITITL??N
3706	280	METZTITL??N
3707	280	MINERAL DEL CHICO
3708	280	MINERAL DEL MONTE
3709	280	LA MISI??N
3710	280	MIXQUIAHUALA DE JU??REZ
3711	280	MOLANGO DE ESCAMILLA
3712	280	NICOL??S FLORES
3713	280	NOPALA DE VILLAGR??N
3714	280	OMITL??N DE JU??REZ
3715	280	SAN FELIPE ORIZATL??N
3716	280	PACULA
3717	280	PACHUCA DE SOTO
3718	280	PISAFLORES
3719	280	PROGRESO DE OBREG??N
3720	280	MINERAL DE LA REFORMA
3721	280	SAN AGUST??N TLAXIACA
3722	280	SAN BARTOLO TUTOTEPEC
3723	280	SAN SALVADOR
3724	280	SANTIAGO DE ANAYA
3725	280	SANTIAGO TULANTEPEC DE LUGO GUERRERO
3726	280	SINGUILUCAN
3727	280	TASQUILLO
3728	280	TECOZAUTLA
3729	280	TENANGO DE DORIA
3730	280	TEPEAPULCO
3731	280	TEPEHUAC??N DE GUERRERO
3732	280	TEPEJI DEL R??O DE OCAMPO
3733	280	TEPETITL??N
3734	280	TETEPANGO
3735	280	VILLA DE TEZONTEPEC
3736	280	TEZONTEPEC DE ALDAMA
3737	280	TIANGUISTENGO
3738	280	TIZAYUCA
3739	280	TLAHUELILPAN
3740	280	TLAHUILTEPA
3741	280	TLANALAPA
3742	280	TLANCHINOL
3743	280	TLAXCOAPAN
3744	280	TOLCAYUCA
3745	280	TULA DE ALLENDE
3746	280	TULANCINGO DE BRAVO
3747	280	XOCHIATIPAN
3748	280	XOCHICOATL??N
3749	280	YAHUALICA
3750	280	ZACUALTIP??N DE ??NGELES
3751	280	ZAPOTL??N DE JU??REZ
3752	280	ZEMPOALA
3753	280	ZIMAP??N
3754	281	ACATIC
3755	281	ACATL??N DE JU??REZ
3756	281	AHUALULCO DE MERCADO
3757	281	AMACUECA
3758	281	AMATIT??N
3759	281	AMECA
3760	281	SAN JUANITO DE ESCOBEDO
3761	281	ARANDAS
3762	281	ATEMAJAC DE BRIZUELA
3763	281	ATENGO
3764	281	ATENGUILLO
3765	281	ATOTONILCO EL ALTO
3766	281	ATOYAC
3767	281	AUTL??N DE NAVARRO
3768	281	AYOTL??N
3769	281	AYUTLA
3770	281	LA BARCA
3771	281	BOLA??OS
3772	281	CABO CORRIENTES
3773	281	CASIMIRO CASTILLO
3774	281	CIHUATL??N
3775	281	ZAPOTL??N EL GRANDE
3776	281	COLOTL??N
3777	281	CONCEPCI??N DE BUENOS AIRES
3778	281	CUAUTITL??N DE GARC??A BARRAG??N
3779	281	CUAUTLA
3780	281	CUQU??O
3781	281	CHAPALA
3782	281	CHIMALTIT??N
3783	281	CHIQUILISTL??N
3784	281	DEGOLLADO
3785	281	EJUTLA
3786	281	ENCARNACI??N DE D??AZ
3787	281	ETZATL??N
3788	281	EL GRULLO
3789	281	GUACHINANGO
3790	281	GUADALAJARA
3791	281	HOSTOTIPAQUILLO
3792	281	HUEJ??CAR
3793	281	HUEJUQUILLA EL ALTO
3794	281	LA HUERTA
3795	281	IXTLAHUAC??N DE LOS MEMBRILLOS
3796	281	IXTLAHUAC??N DEL R??O
3797	281	JALOSTOTITL??N
3798	281	JAMAY
3799	281	JILOTL??N DE LOS DOLORES
3800	281	JOCOTEPEC
3801	281	JUANACATL??N
3802	281	JUCHITL??N
3803	281	LAGOS DE MORENO
3804	281	EL LIM??N
3805	281	MAGDALENA
3806	281	SANTA MAR??A DEL ORO
3807	281	LA MANZANILLA DE LA PAZ
3808	281	MASCOTA
3809	281	MAZAMITLA
3810	281	MEXTICAC??N
3811	281	MEZQUITIC
3812	281	MIXTL??N
3813	281	OCOTL??N
3814	281	OJUELOS DE JALISCO
3815	281	PIHUAMO
3816	281	PONCITL??N
3817	281	PUERTO VALLARTA
3818	281	VILLA PURIFICACI??N
3819	281	QUITUPAN
3820	281	EL SALTO
3821	281	SAN CRIST??BAL DE LA BARRANCA
3822	281	SAN DIEGO DE ALEJANDR??A
3823	281	SAN JUAN DE LOS LAGOS
3824	281	SAN JULI??N
3825	281	SAN MART??N DE BOLA??OS
3826	281	SAN MART??N HIDALGO
3827	281	SAN MIGUEL EL ALTO
3828	281	SAN SEBASTI??N DEL OESTE
3829	281	SANTA MAR??A DE LOS ??NGELES
3830	281	SAYULA
3831	281	TALA
3832	281	TALPA DE ALLENDE
3833	281	TAMAZULA DE GORDIANO
3834	281	TAPALPA
3835	281	TECALITL??N
3836	281	TECOLOTL??N
3837	281	TECHALUTA DE MONTENEGRO
3838	281	TENAMAXTL??N
3839	281	TEOCALTICHE
3840	281	TEOCUITATL??N DE CORONA
3841	281	TEPATITL??N DE MORELOS
3842	281	TEQUILA
3843	281	TEUCHITL??N
3844	281	TIZAP??N EL ALTO
3845	281	TLAJOMULCO DE Z????IGA
3846	281	SAN PEDRO TLAQUEPAQUE
3847	281	TOLIM??N
3848	281	TOMATL??N
3849	281	TONAYA
3850	281	TONILA
3851	281	TOTATICHE
3852	281	TOTOTL??N
3853	281	TUXCACUESCO
3854	281	TUXCUECA
3855	281	TUXPAN
3856	281	UNI??N DE SAN ANTONIO
3857	281	UNI??N DE TULA
3858	281	VALLE DE GUADALUPE
3859	281	VALLE DE JU??REZ
3860	281	SAN GABRIEL
3861	281	VILLA CORONA
3862	281	VILLA GUERRERO
3863	281	VILLA HIDALGO
3864	281	CA??ADAS DE OBREG??N
3865	281	YAHUALICA DE GONZ??LEZ GALLO
3866	281	ZACOALCO DE TORRES
3867	281	ZAPOPAN
3868	281	ZAPOTILTIC
3869	281	ZAPOTITL??N DE VADILLO
3870	281	ZAPOTL??N DEL REY
3871	281	ZAPOTLANEJO
3872	281	SAN IGNACIO CERRO GORDO
3873	282	ACAMBAY DE RU??Z CASTA??EDA
3874	282	ACOLMAN
3875	282	ACULCO
3876	282	ALMOLOYA DE ALQUISIRAS
3877	282	ALMOLOYA DE JU??REZ
3878	282	ALMOLOYA DEL R??O
3879	282	AMANALCO
3880	282	AMATEPEC
3881	282	AMECAMECA
3882	282	APAXCO
3883	282	ATENCO
3884	282	ATIZAP??N
3885	282	ATIZAP??N DE ZARAGOZA
3886	282	ATLACOMULCO
3887	282	ATLAUTLA
3888	282	AXAPUSCO
3889	282	AYAPANGO
3890	282	CALIMAYA
3891	282	CAPULHUAC
3892	282	COACALCO DE BERRIOZ??BAL
3893	282	COATEPEC HARINAS
3894	282	COCOTITL??N
3895	282	COYOTEPEC
3896	282	CUAUTITL??N
3897	282	CHALCO
3898	282	CHAPA DE MOTA
3899	282	CHAPULTEPEC
3900	282	CHIAUTLA
3901	282	CHICOLOAPAN
3902	282	CHICONCUAC
3903	282	CHIMALHUAC??N
3904	282	DONATO GUERRA
3905	282	ECATEPEC DE MORELOS
3906	282	ECATZINGO
3907	282	HUEHUETOCA
3908	282	HUEYPOXTLA
3909	282	HUIXQUILUCAN
3910	282	ISIDRO FABELA
3911	282	IXTAPALUCA
3912	282	IXTAPAN DE LA SAL
3913	282	IXTAPAN DEL ORO
3914	282	IXTLAHUACA
3915	282	XALATLACO
3916	282	JALTENCO
3917	282	JILOTEPEC
3918	282	JILOTZINGO
3919	282	JIQUIPILCO
3920	282	JOCOTITL??N
3921	282	JOQUICINGO
3922	282	JUCHITEPEC
3923	282	LERMA
3924	282	MALINALCO
3925	282	MELCHOR OCAMPO
3926	282	MEXICALTZINGO
3927	282	NAUCALPAN DE JU??REZ
3928	282	NEZAHUALC??YOTL
3929	282	NEXTLALPAN
3930	282	NICOL??S ROMERO
3931	282	NOPALTEPEC
3932	282	OCOYOACAC
3933	282	OCUILAN
3934	282	OTUMBA
3935	282	OTZOLOAPAN
3936	282	OTZOLOTEPEC
3937	282	OZUMBA
3938	282	PAPALOTLA
3939	282	POLOTITL??N
3940	282	SAN ANTONIO LA ISLA
3941	282	SAN FELIPE DEL PROGRESO
3942	282	SAN MART??N DE LAS PIR??MIDES
3943	282	SAN MATEO ATENCO
3944	282	SAN SIM??N DE GUERRERO
3945	282	SANTO TOM??S
3946	282	SOYANIQUILPAN DE JU??REZ
3947	282	SULTEPEC
3948	282	TEC??MAC
3949	282	TEJUPILCO
3950	282	TEMAMATLA
3951	282	TEMASCALAPA
3952	282	TEMASCALCINGO
3953	282	TEMASCALTEPEC
3954	282	TEMOAYA
3955	282	TENANCINGO
3956	282	TENANGO DEL AIRE
3957	282	TENANGO DEL VALLE
3958	282	TEOLOYUCAN
3959	282	TEOTIHUAC??N
3960	282	TEPETLAOXTOC
3961	282	TEPETLIXPA
3962	282	TEPOTZOTL??N
3963	282	TEQUIXQUIAC
3964	282	TEXCALTITL??N
3965	282	TEXCALYACAC
3966	282	TEXCOCO
3967	282	TEZOYUCA
3968	282	TIANGUISTENCO
3969	282	TIMILPAN
3970	282	TLALMANALCO
3971	282	TLALNEPANTLA DE BAZ
3972	282	TLATLAYA
3973	282	TOLUCA
3974	282	TONATICO
3975	282	TULTEPEC
3976	282	TULTITL??N
3977	282	VALLE DE BRAVO
3978	282	VILLA DE ALLENDE
3979	282	VILLA DEL CARB??N
3980	282	VILLA VICTORIA
3981	282	XONACATL??N
3982	282	ZACAZONAPAN
3983	282	ZACUALPAN
3984	282	ZINACANTEPEC
3985	282	ZUMPAHUAC??N
3986	282	ZUMPANGO
3987	282	CUAUTITL??N IZCALLI
3988	282	VALLE DE CHALCO SOLIDARIDAD
3989	282	LUVIANOS
3990	282	SAN JOS?? DEL RINC??N
3991	282	TONANITLA
3992	283	ACUITZIO
3993	283	AGUILILLA
3994	283	ANGAMACUTIRO
3995	283	ANGANGUEO
3996	283	APATZING??N
3997	283	APORO
3998	283	AQUILA
3999	283	ARIO
4000	283	BRISE??AS
4001	283	BUENAVISTA
4002	283	CAR??CUARO
4003	283	COAHUAYANA
4004	283	COALCOM??N DE V??ZQUEZ PALLARES
4005	283	COENEO
4006	283	CONTEPEC
4007	283	COP??NDARO
4008	283	COTIJA
4009	283	CUITZEO
4010	283	CHARAPAN
4011	283	CHARO
4012	283	CHAVINDA
4013	283	CHER??N
4014	283	CHILCHOTA
4015	283	CHINICUILA
4016	283	CHUC??NDIRO
4017	283	CHURINTZIO
4018	283	CHURUMUCO
4019	283	ECUANDUREO
4020	283	EPITACIO HUERTA
4021	283	ERONGAR??CUARO
4022	283	GABRIEL ZAMORA
4023	283	LA HUACANA
4024	283	HUANDACAREO
4025	283	HUANIQUEO
4026	283	HUETAMO
4027	283	HUIRAMBA
4028	283	INDAPARAPEO
4029	283	IRIMBO
4030	283	IXTL??N
4031	283	JACONA
4032	283	JIQUILPAN
4033	283	JUNGAPEO
4034	283	LAGUNILLAS
4035	283	MADERO
4036	283	MARAVAT??O
4037	283	MARCOS CASTELLANOS
4038	283	L??ZARO C??RDENAS
4039	283	MORELIA
4040	283	M??GICA
4041	283	NAHUATZEN
4042	283	NOCUP??TARO
4043	283	NUEVO PARANGARICUTIRO
4044	283	NUEVO URECHO
4045	283	NUMAR??N
4046	283	PAJACUAR??N
4047	283	PANIND??CUARO
4048	283	PAR??CUARO
4049	283	PARACHO
4050	283	P??TZCUARO
4051	283	PENJAMILLO
4052	283	PERIB??N
4053	283	LA PIEDAD
4054	283	PUR??PERO
4055	283	PURU??NDIRO
4056	283	QUER??NDARO
4057	283	QUIROGA
4058	283	COJUMATL??N DE R??GULES
4059	283	LOS REYES
4060	283	SAHUAYO
4061	283	SANTA ANA MAYA
4062	283	SALVADOR ESCALANTE
4063	283	SENGUIO
4064	283	SUSUPUATO
4065	283	TAC??MBARO
4066	283	TANC??TARO
4067	283	TANGAMANDAPIO
4068	283	TANGANC??CUARO
4069	283	TANHUATO
4070	283	TARETAN
4071	283	TAR??MBARO
4072	283	TEPALCATEPEC
4073	283	TINGAMBATO
4074	283	TING??IND??N
4075	283	TIQUICHEO DE NICOL??S ROMERO
4076	283	TLALPUJAHUA
4077	283	TLAZAZALCA
4078	283	TOCUMBO
4079	283	TUMBISCAT??O
4080	283	TURICATO
4081	283	TUZANTLA
4082	283	TZINTZUNTZAN
4083	283	TZITZIO
4084	283	URUAPAN
4085	283	VILLAMAR
4086	283	VISTA HERMOSA
4087	283	YUR??CUARO
4088	283	ZACAPU
4089	283	ZAMORA
4090	283	ZIN??PARO
4091	283	ZINAP??CUARO
4092	283	ZIRACUARETIRO
4093	283	ZIT??CUARO
4094	283	JOS?? SIXTO VERDUZCO
4095	284	AMACUZAC
4096	284	ATLATLAHUCAN
4097	284	AXOCHIAPAN
4098	284	AYALA
4099	284	COATL??N DEL R??O
4100	284	CUERNAVACA
4101	284	HUITZILAC
4102	284	JANTETELCO
4103	284	JIUTEPEC
4104	284	JOJUTLA
4105	284	JONACATEPEC DE LEANDRO VALLE
4106	284	MAZATEPEC
4107	284	MIACATL??N
4108	284	OCUITUCO
4109	284	PUENTE DE IXTLA
4110	284	TEMIXCO
4111	284	TEPALCINGO
4112	284	TEPOZTL??N
4113	284	TETECALA
4114	284	TETELA DEL VOLC??N
4115	284	TLALNEPANTLA
4116	284	TLALTIZAP??N DE ZAPATA
4117	284	TLAQUILTENANGO
4118	284	TLAYACAPAN
4119	284	TOTOLAPAN
4120	284	XOCHITEPEC
4121	284	YAUTEPEC
4122	284	YECAPIXTLA
4123	284	ZACATEPEC
4124	284	ZACUALPAN DE AMILPAS
4125	284	TEMOAC
4126	285	ACAPONETA
4127	285	AHUACATL??N
4128	285	AMATL??N DE CA??AS
4129	285	COMPOSTELA
4130	285	HUAJICORI
4131	285	IXTL??N DEL R??O
4132	285	JALA
4133	285	XALISCO
4134	285	DEL NAYAR
4135	285	ROSAMORADA
4136	285	RU??Z
4137	285	SAN BLAS
4138	285	SAN PEDRO LAGUNILLAS
4139	285	SANTIAGO IXCUINTLA
4140	285	TECUALA
4141	285	TEPIC
4142	285	LA YESCA
4143	285	BAH??A DE BANDERAS
4144	286	AGUALEGUAS
4145	286	LOS ALDAMAS
4146	286	AN??HUAC
4147	286	APODACA
4148	286	ARAMBERRI
4149	286	BUSTAMANTE
4150	286	CADEREYTA JIM??NEZ
4151	286	EL CARMEN
4152	286	CERRALVO
4153	286	CI??NEGA DE FLORES
4154	286	CHINA
4155	286	DOCTOR ARROYO
4156	286	DOCTOR COSS
4157	286	DOCTOR GONZ??LEZ
4158	286	GARC??A
4159	286	SAN PEDRO GARZA GARC??A
4160	286	GENERAL BRAVO
4161	286	GENERAL ESCOBEDO
4162	286	GENERAL TER??N
4163	286	GENERAL TREVI??O
4164	286	GENERAL ZARAGOZA
4165	286	GENERAL ZUAZUA
4166	286	LOS HERRERAS
4167	286	HIGUERAS
4168	286	HUALAHUISES
4169	286	ITURBIDE
4170	286	LAMPAZOS DE NARANJO
4171	286	LINARES
4172	286	MAR??N
4173	286	MIER Y NORIEGA
4174	286	MINA
4175	286	MONTEMORELOS
4176	286	MONTERREY
4177	286	PAR??S
4178	286	PESQUER??A
4179	286	LOS RAMONES
4180	286	RAYONES
4181	286	SABINAS HIDALGO
4182	286	SALINAS VICTORIA
4183	286	SAN NICOL??S DE LOS GARZA
4184	286	SANTIAGO
4185	286	VALLECILLO
4186	286	VILLALDAMA
4187	287	ABEJONES
4188	287	ACATL??N DE P??REZ FIGUEROA
4189	287	ASUNCI??N CACALOTEPEC
4190	287	ASUNCI??N CUYOTEPEJI
4191	287	ASUNCI??N IXTALTEPEC
4192	287	ASUNCI??N NOCHIXTL??N
4193	287	ASUNCI??N OCOTL??N
4194	287	ASUNCI??N TLACOLULITA
4195	287	AYOTZINTEPEC
4196	287	EL BARRIO DE LA SOLEDAD
4197	287	CALIHUAL??
4198	287	CANDELARIA LOXICHA
4199	287	CI??NEGA DE ZIMATL??N
4200	287	CIUDAD IXTEPEC
4201	287	COATECAS ALTAS
4202	287	COICOY??N DE LAS FLORES
4203	287	LA COMPA????A
4204	287	CONCEPCI??N BUENAVISTA
4205	287	CONCEPCI??N P??PALO
4206	287	CONSTANCIA DEL ROSARIO
4207	287	COSOLAPA
4208	287	COSOLTEPEC
4209	287	CUIL??PAM DE GUERRERO
4210	287	CUYAMECALCO VILLA DE ZARAGOZA
4211	287	CHAHUITES
4212	287	CHALCATONGO DE HIDALGO
4213	287	CHIQUIHUITL??N DE BENITO JU??REZ
4214	287	HEROICA CIUDAD DE EJUTLA DE CRESPO
4215	287	ELOXOCHITL??N DE FLORES MAG??N
4216	287	EL ESPINAL
4217	287	TAMAZUL??PAM DEL ESP??RITU SANTO
4218	287	FRESNILLO DE TRUJANO
4219	287	GUADALUPE ETLA
4220	287	GUADALUPE DE RAM??REZ
4221	287	GUELATAO DE JU??REZ
4222	287	GUEVEA DE HUMBOLDT
4223	287	MESONES HIDALGO
4224	287	HEROICA CIUDAD DE HUAJUAPAN DE LE??N
4225	287	HUAUTEPEC
4226	287	HUAUTLA DE JIM??NEZ
4227	287	IXTL??N DE JU??REZ
4228	287	HEROICA CIUDAD DE JUCHIT??N DE ZARAGOZA
4229	287	LOMA BONITA
4230	287	MAGDALENA APASCO
4231	287	MAGDALENA JALTEPEC
4232	287	SANTA MAGDALENA JICOTL??N
4233	287	MAGDALENA MIXTEPEC
4234	287	MAGDALENA OCOTL??N
4235	287	MAGDALENA PE??ASCO
4236	287	MAGDALENA TEITIPAC
4237	287	MAGDALENA TEQUISISTL??N
4238	287	MAGDALENA TLACOTEPEC
4239	287	MAGDALENA ZAHUATL??N
4240	287	MARISCALA DE JU??REZ
4241	287	M??RTIRES DE TACUBAYA
4242	287	MAT??AS ROMERO AVENDA??O
4243	287	MAZATL??N VILLA DE FLORES
4244	287	MIAHUATL??N DE PORFIRIO D??AZ
4245	287	MIXISTL??N DE LA REFORMA
4246	287	MONJAS
4247	287	NATIVIDAD
4248	287	NAZARENO ETLA
4249	287	NEJAPA DE MADERO
4250	287	IXPANTEPEC NIEVES
4251	287	SANTIAGO NILTEPEC
4252	287	OAXACA DE JU??REZ
4253	287	OCOTL??N DE MORELOS
4254	287	LA PE
4255	287	PINOTEPA DE DON LUIS
4256	287	PLUMA HIDALGO
4257	287	SAN JOS?? DEL PROGRESO
4258	287	PUTLA VILLA DE GUERRERO
4259	287	SANTA CATARINA QUIOQUITANI
4260	287	REFORMA DE PINEDA
4261	287	LA REFORMA
4262	287	REYES ETLA
4263	287	ROJAS DE CUAUHT??MOC
4264	287	SALINA CRUZ
4265	287	SAN AGUST??N AMATENGO
4266	287	SAN AGUST??N ATENANGO
4267	287	SAN AGUST??N CHAYUCO
4268	287	SAN AGUST??N DE LAS JUNTAS
4269	287	SAN AGUST??N ETLA
4270	287	SAN AGUST??N LOXICHA
4271	287	SAN AGUST??N TLACOTEPEC
4272	287	SAN AGUST??N YATARENI
4273	287	SAN ANDR??S CABECERA NUEVA
4274	287	SAN ANDR??S DINICUITI
4275	287	SAN ANDR??S HUAXPALTEPEC
4276	287	SAN ANDR??S HUAY??PAM
4277	287	SAN ANDR??S IXTLAHUACA
4278	287	SAN ANDR??S LAGUNAS
4279	287	SAN ANDR??S NUXI??O
4280	287	SAN ANDR??S PAXTL??N
4281	287	SAN ANDR??S SINAXTLA
4282	287	SAN ANDR??S SOLAGA
4283	287	SAN ANDR??S TEOTIL??LPAM
4284	287	SAN ANDR??S TEPETLAPA
4285	287	SAN ANDR??S YA??
4286	287	SAN ANDR??S ZABACHE
4287	287	SAN ANDR??S ZAUTLA
4288	287	SAN ANTONINO CASTILLO VELASCO
4289	287	SAN ANTONINO EL ALTO
4290	287	SAN ANTONINO MONTE VERDE
4291	287	SAN ANTONIO ACUTLA
4292	287	SAN ANTONIO DE LA CAL
4293	287	SAN ANTONIO HUITEPEC
4294	287	SAN ANTONIO NANAHUAT??PAM
4295	287	SAN ANTONIO SINICAHUA
4296	287	SAN ANTONIO TEPETLAPA
4297	287	SAN BALTAZAR CHICHIC??PAM
4298	287	SAN BALTAZAR LOXICHA
4299	287	SAN BALTAZAR YATZACHI EL BAJO
4300	287	SAN BARTOLO COYOTEPEC
4301	287	SAN BARTOLOM?? AYAUTLA
4302	287	SAN BARTOLOM?? LOXICHA
4303	287	SAN BARTOLOM?? QUIALANA
4304	287	SAN BARTOLOM?? YUCUA??E
4305	287	SAN BARTOLOM?? ZOOGOCHO
4306	287	SAN BARTOLO SOYALTEPEC
4307	287	SAN BARTOLO YAUTEPEC
4308	287	SAN BERNARDO MIXTEPEC
4309	287	SAN BLAS ATEMPA
4310	287	SAN CARLOS YAUTEPEC
4311	287	SAN CRIST??BAL AMATL??N
4312	287	SAN CRIST??BAL AMOLTEPEC
4313	287	SAN CRIST??BAL LACHIRIOAG
4314	287	SAN CRIST??BAL SUCHIXTLAHUACA
4315	287	SAN DIONISIO DEL MAR
4316	287	SAN DIONISIO OCOTEPEC
4317	287	SAN DIONISIO OCOTL??N
4318	287	SAN ESTEBAN ATATLAHUCA
4319	287	SAN FELIPE JALAPA DE D??AZ
4320	287	SAN FELIPE TEJAL??PAM
4321	287	SAN FELIPE USILA
4322	287	SAN FRANCISCO CAHUACU??
4323	287	SAN FRANCISCO CAJONOS
4324	287	SAN FRANCISCO CHAPULAPA
4325	287	SAN FRANCISCO CHIND??A
4326	287	SAN FRANCISCO DEL MAR
4327	287	SAN FRANCISCO HUEHUETL??N
4328	287	SAN FRANCISCO IXHUAT??N
4329	287	SAN FRANCISCO JALTEPETONGO
4330	287	SAN FRANCISCO LACHIGOL??
4331	287	SAN FRANCISCO LOGUECHE
4332	287	SAN FRANCISCO NUXA??O
4333	287	SAN FRANCISCO OZOLOTEPEC
4334	287	SAN FRANCISCO SOLA
4335	287	SAN FRANCISCO TELIXTLAHUACA
4336	287	SAN FRANCISCO TEOPAN
4337	287	SAN FRANCISCO TLAPANCINGO
4338	287	SAN GABRIEL MIXTEPEC
4339	287	SAN ILDEFONSO AMATL??N
4340	287	SAN ILDEFONSO SOLA
4341	287	SAN ILDEFONSO VILLA ALTA
4342	287	SAN JACINTO AMILPAS
4343	287	SAN JACINTO TLACOTEPEC
4344	287	SAN JER??NIMO COATL??N
4345	287	SAN JER??NIMO SILACAYOAPILLA
4346	287	SAN JER??NIMO SOSOLA
4347	287	SAN JER??NIMO TAVICHE
4348	287	SAN JER??NIMO TEC??ATL
4349	287	SAN JORGE NUCHITA
4350	287	SAN JOS?? AYUQUILA
4351	287	SAN JOS?? CHILTEPEC
4352	287	SAN JOS?? DEL PE??ASCO
4353	287	SAN JOS?? ESTANCIA GRANDE
4354	287	SAN JOS?? INDEPENDENCIA
4355	287	SAN JOS?? LACHIGUIRI
4356	287	SAN JOS?? TENANGO
4357	287	SAN JUAN ACHIUTLA
4358	287	SAN JUAN ATEPEC
4359	287	??NIMAS TRUJANO
4360	287	SAN JUAN BAUTISTA ATATLAHUCA
4361	287	SAN JUAN BAUTISTA COIXTLAHUACA
4362	287	SAN JUAN BAUTISTA CUICATL??N
4363	287	SAN JUAN BAUTISTA GUELACHE
4364	287	SAN JUAN BAUTISTA JAYACATL??N
4365	287	SAN JUAN BAUTISTA LO DE SOTO
4366	287	SAN JUAN BAUTISTA SUCHITEPEC
4367	287	SAN JUAN BAUTISTA TLACOATZINTEPEC
4368	287	SAN JUAN BAUTISTA TLACHICHILCO
4369	287	SAN JUAN BAUTISTA TUXTEPEC
4370	287	SAN JUAN CACAHUATEPEC
4371	287	SAN JUAN CIENEGUILLA
4372	287	SAN JUAN COATZ??SPAM
4373	287	SAN JUAN COLORADO
4374	287	SAN JUAN COMALTEPEC
4375	287	SAN JUAN COTZOC??N
4376	287	SAN JUAN CHICOMEZ??CHIL
4377	287	SAN JUAN CHILATECA
4378	287	SAN JUAN DEL ESTADO
4379	287	SAN JUAN DIUXI
4380	287	SAN JUAN EVANGELISTA ANALCO
4381	287	SAN JUAN GUELAV??A
4382	287	SAN JUAN GUICHICOVI
4383	287	SAN JUAN IHUALTEPEC
4384	287	SAN JUAN JUQUILA MIXES
4385	287	SAN JUAN JUQUILA VIJANOS
4386	287	SAN JUAN LACHAO
4387	287	SAN JUAN LACHIGALLA
4388	287	SAN JUAN LAJARCIA
4389	287	SAN JUAN LALANA
4390	287	SAN JUAN DE LOS CU??S
4391	287	SAN JUAN MAZATL??N
4392	287	SAN JUAN MIXTEPEC
4393	287	SAN JUAN ??UM??
4394	287	SAN JUAN OZOLOTEPEC
4395	287	SAN JUAN PETLAPA
4396	287	SAN JUAN QUIAHIJE
4397	287	SAN JUAN QUIOTEPEC
4398	287	SAN JUAN SAYULTEPEC
4399	287	SAN JUAN TABA??
4400	287	SAN JUAN TAMAZOLA
4401	287	SAN JUAN TEITA
4402	287	SAN JUAN TEITIPAC
4403	287	SAN JUAN TEPEUXILA
4404	287	SAN JUAN TEPOSCOLULA
4405	287	SAN JUAN YAE??
4406	287	SAN JUAN YATZONA
4407	287	SAN JUAN YUCUITA
4408	287	SAN LORENZO
4409	287	SAN LORENZO ALBARRADAS
4410	287	SAN LORENZO CACAOTEPEC
4411	287	SAN LORENZO CUAUNECUILTITLA
4412	287	SAN LORENZO TEXMEL??CAN
4413	287	SAN LORENZO VICTORIA
4414	287	SAN LUCAS CAMOTL??N
4415	287	SAN LUCAS OJITL??N
4416	287	SAN LUCAS QUIAVIN??
4417	287	SAN LUCAS ZOQUI??PAM
4418	287	SAN LUIS AMATL??N
4419	287	SAN MARCIAL OZOLOTEPEC
4420	287	SAN MARCOS ARTEAGA
4421	287	SAN MART??N DE LOS CANSECOS
4422	287	SAN MART??N HUAMEL??LPAM
4423	287	SAN MART??N ITUNYOSO
4424	287	SAN MART??N LACHIL??
4425	287	SAN MART??N PERAS
4426	287	SAN MART??N TILCAJETE
4427	287	SAN MART??N TOXPALAN
4428	287	SAN MART??N ZACATEPEC
4429	287	SAN MATEO CAJONOS
4430	287	CAPUL??LPAM DE M??NDEZ
4431	287	SAN MATEO DEL MAR
4432	287	SAN MATEO YOLOXOCHITL??N
4433	287	SAN MATEO ETLATONGO
4434	287	SAN MATEO NEJ??PAM
4435	287	SAN MATEO PE??ASCO
4436	287	SAN MATEO PI??AS
4437	287	SAN MATEO R??O HONDO
4438	287	SAN MATEO SINDIHUI
4439	287	SAN MATEO TLAPILTEPEC
4440	287	SAN MELCHOR BETAZA
4441	287	SAN MIGUEL ACHIUTLA
4442	287	SAN MIGUEL AHUEHUETITL??N
4443	287	SAN MIGUEL ALO??PAM
4444	287	SAN MIGUEL AMATITL??N
4445	287	SAN MIGUEL AMATL??N
4446	287	SAN MIGUEL COATL??N
4447	287	SAN MIGUEL CHICAHUA
4448	287	SAN MIGUEL CHIMALAPA
4449	287	SAN MIGUEL DEL PUERTO
4450	287	SAN MIGUEL DEL R??O
4451	287	SAN MIGUEL EJUTLA
4452	287	SAN MIGUEL EL GRANDE
4453	287	SAN MIGUEL HUAUTLA
4454	287	SAN MIGUEL MIXTEPEC
4455	287	SAN MIGUEL PANIXTLAHUACA
4456	287	SAN MIGUEL PERAS
4457	287	SAN MIGUEL PIEDRAS
4458	287	SAN MIGUEL QUETZALTEPEC
4459	287	SAN MIGUEL SANTA FLOR
4460	287	VILLA SOLA DE VEGA
4461	287	SAN MIGUEL SOYALTEPEC
4462	287	SAN MIGUEL SUCHIXTEPEC
4463	287	VILLA TALEA DE CASTRO
4464	287	SAN MIGUEL TECOMATL??N
4465	287	SAN MIGUEL TENANGO
4466	287	SAN MIGUEL TEQUIXTEPEC
4467	287	SAN MIGUEL TILQUI??PAM
4468	287	SAN MIGUEL TLACAMAMA
4469	287	SAN MIGUEL TLACOTEPEC
4470	287	SAN MIGUEL TULANCINGO
4471	287	SAN MIGUEL YOTAO
4472	287	SAN NICOL??S
4473	287	SAN NICOL??S HIDALGO
4474	287	SAN PABLO COATL??N
4475	287	SAN PABLO CUATRO VENADOS
4476	287	SAN PABLO ETLA
4477	287	SAN PABLO HUITZO
4478	287	SAN PABLO HUIXTEPEC
4479	287	SAN PABLO MACUILTIANGUIS
4480	287	SAN PABLO TIJALTEPEC
4481	287	SAN PABLO VILLA DE MITLA
4482	287	SAN PABLO YAGANIZA
4483	287	SAN PEDRO AMUZGOS
4484	287	SAN PEDRO AP??STOL
4485	287	SAN PEDRO ATOYAC
4486	287	SAN PEDRO CAJONOS
4487	287	SAN PEDRO COXCALTEPEC C??NTAROS
4488	287	SAN PEDRO COMITANCILLO
4489	287	SAN PEDRO EL ALTO
4490	287	SAN PEDRO HUAMELULA
4491	287	SAN PEDRO HUILOTEPEC
4492	287	SAN PEDRO IXCATL??N
4493	287	SAN PEDRO IXTLAHUACA
4494	287	SAN PEDRO JALTEPETONGO
4495	287	SAN PEDRO JICAY??N
4496	287	SAN PEDRO JOCOTIPAC
4497	287	SAN PEDRO JUCHATENGO
4498	287	SAN PEDRO M??RTIR
4499	287	SAN PEDRO M??RTIR QUIECHAPA
4500	287	SAN PEDRO M??RTIR YUCUXACO
4501	287	SAN PEDRO MIXTEPEC
4502	287	SAN PEDRO MOLINOS
4503	287	SAN PEDRO NOPALA
4504	287	SAN PEDRO OCOPETATILLO
4505	287	SAN PEDRO OCOTEPEC
4506	287	SAN PEDRO POCHUTLA
4507	287	SAN PEDRO QUIATONI
4508	287	SAN PEDRO SOCHI??PAM
4509	287	SAN PEDRO TAPANATEPEC
4510	287	SAN PEDRO TAVICHE
4511	287	SAN PEDRO TEOZACOALCO
4512	287	SAN PEDRO TEUTILA
4513	287	SAN PEDRO TIDA??
4514	287	SAN PEDRO TOPILTEPEC
4515	287	SAN PEDRO TOTOL??PAM
4516	287	VILLA DE TUTUTEPEC
4517	287	SAN PEDRO YANERI
4518	287	SAN PEDRO Y??LOX
4519	287	SAN PEDRO Y SAN PABLO AYUTLA
4520	287	VILLA DE ETLA
4521	287	SAN PEDRO Y SAN PABLO TEPOSCOLULA
4522	287	SAN PEDRO Y SAN PABLO TEQUIXTEPEC
4523	287	SAN PEDRO YUCUNAMA
4524	287	SAN RAYMUNDO JALPAN
4525	287	SAN SEBASTI??N ABASOLO
4526	287	SAN SEBASTI??N COATL??N
4527	287	SAN SEBASTI??N IXCAPA
4528	287	SAN SEBASTI??N NICANANDUTA
4529	287	SAN SEBASTI??N R??O HONDO
4530	287	SAN SEBASTI??N TECOMAXTLAHUACA
4531	287	SAN SEBASTI??N TEITIPAC
4532	287	SAN SEBASTI??N TUTLA
4533	287	SAN SIM??N ALMOLONGAS
4534	287	SAN SIM??N ZAHUATL??N
4535	287	SANTA ANA
4536	287	SANTA ANA ATEIXTLAHUACA
4537	287	SANTA ANA CUAUHT??MOC
4538	287	SANTA ANA DEL VALLE
4539	287	SANTA ANA TAVELA
4540	287	SANTA ANA TLAPACOYAN
4541	287	SANTA ANA YARENI
4542	287	SANTA ANA ZEGACHE
4543	287	SANTA CATALINA QUIER??
4544	287	SANTA CATARINA CUIXTLA
4545	287	SANTA CATARINA IXTEPEJI
4546	287	SANTA CATARINA JUQUILA
4547	287	SANTA CATARINA LACHATAO
4548	287	SANTA CATARINA LOXICHA
4549	287	SANTA CATARINA MECHOAC??N
4550	287	SANTA CATARINA MINAS
4551	287	SANTA CATARINA QUIAN??
4552	287	SANTA CATARINA TAYATA
4553	287	SANTA CATARINA TICU??
4554	287	SANTA CATARINA YOSONOT??
4555	287	SANTA CATARINA ZAPOQUILA
4556	287	SANTA CRUZ ACATEPEC
4557	287	SANTA CRUZ AMILPAS
4558	287	SANTA CRUZ DE BRAVO
4559	287	SANTA CRUZ ITUNDUJIA
4560	287	SANTA CRUZ MIXTEPEC
4561	287	SANTA CRUZ NUNDACO
4562	287	SANTA CRUZ PAPALUTLA
4563	287	SANTA CRUZ TACACHE DE MINA
4564	287	SANTA CRUZ TACAHUA
4565	287	SANTA CRUZ TAYATA
4566	287	SANTA CRUZ XITLA
4567	287	SANTA CRUZ XOXOCOTL??N
4568	287	SANTA CRUZ ZENZONTEPEC
4569	287	SANTA GERTRUDIS
4570	287	SANTA IN??S DEL MONTE
4571	287	SANTA IN??S YATZECHE
4572	287	SANTA LUC??A DEL CAMINO
4573	287	SANTA LUC??A MIAHUATL??N
4574	287	SANTA LUC??A MONTEVERDE
4575	287	SANTA LUC??A OCOTL??N
4576	287	SANTA MAR??A ALOTEPEC
4577	287	SANTA MAR??A APAZCO
4578	287	SANTA MAR??A LA ASUNCI??N
4579	287	HEROICA CIUDAD DE TLAXIACO
4580	287	AYOQUEZCO DE ALDAMA
4581	287	SANTA MAR??A ATZOMPA
4582	287	SANTA MAR??A CAMOTL??N
4583	287	SANTA MAR??A COLOTEPEC
4584	287	SANTA MAR??A CORTIJO
4585	287	SANTA MAR??A COYOTEPEC
4586	287	SANTA MAR??A CHACHO??PAM
4587	287	VILLA DE CHILAPA DE D??AZ
4588	287	SANTA MAR??A CHILCHOTLA
4589	287	SANTA MAR??A CHIMALAPA
4590	287	SANTA MAR??A DEL ROSARIO
4591	287	SANTA MAR??A DEL TULE
4592	287	SANTA MAR??A ECATEPEC
4593	287	SANTA MAR??A GUELAC??
4594	287	SANTA MAR??A GUIENAGATI
4595	287	SANTA MAR??A HUATULCO
4596	287	SANTA MAR??A HUAZOLOTITL??N
4597	287	SANTA MAR??A IPALAPA
4598	287	SANTA MAR??A IXCATL??N
4599	287	SANTA MAR??A JACATEPEC
4600	287	SANTA MAR??A JALAPA DEL MARQU??S
4601	287	SANTA MAR??A JALTIANGUIS
4602	287	SANTA MAR??A LACHIX??O
4603	287	SANTA MAR??A MIXTEQUILLA
4604	287	SANTA MAR??A NATIVITAS
4605	287	SANTA MAR??A NDUAYACO
4606	287	SANTA MAR??A OZOLOTEPEC
4607	287	SANTA MAR??A P??PALO
4608	287	SANTA MAR??A PE??OLES
4609	287	SANTA MAR??A PETAPA
4610	287	SANTA MAR??A QUIEGOLANI
4611	287	SANTA MAR??A SOLA
4612	287	SANTA MAR??A TATALTEPEC
4613	287	SANTA MAR??A TECOMAVACA
4614	287	SANTA MAR??A TEMAXCALAPA
4615	287	SANTA MAR??A TEMAXCALTEPEC
4616	287	SANTA MAR??A TEOPOXCO
4617	287	SANTA MAR??A TEPANTLALI
4618	287	SANTA MAR??A TEXCATITL??N
4619	287	SANTA MAR??A TLAHUITOLTEPEC
4620	287	SANTA MAR??A TLALIXTAC
4621	287	SANTA MAR??A TONAMECA
4622	287	SANTA MAR??A TOTOLAPILLA
4623	287	SANTA MAR??A XADANI
4624	287	SANTA MAR??A YALINA
4625	287	SANTA MAR??A YAVES??A
4626	287	SANTA MAR??A YOLOTEPEC
4627	287	SANTA MAR??A YOSOY??A
4628	287	SANTA MAR??A YUCUHITI
4629	287	SANTA MAR??A ZACATEPEC
4630	287	SANTA MAR??A ZANIZA
4631	287	SANTA MAR??A ZOQUITL??N
4632	287	SANTIAGO AMOLTEPEC
4633	287	SANTIAGO APOALA
4634	287	SANTIAGO AP??STOL
4635	287	SANTIAGO ASTATA
4636	287	SANTIAGO ATITL??N
4637	287	SANTIAGO AYUQUILILLA
4638	287	SANTIAGO CACALOXTEPEC
4639	287	SANTIAGO CAMOTL??N
4640	287	SANTIAGO COMALTEPEC
4641	287	SANTIAGO CHAZUMBA
4642	287	SANTIAGO CHO??PAM
4643	287	SANTIAGO DEL R??O
4644	287	SANTIAGO HUAJOLOTITL??N
4645	287	SANTIAGO HUAUCLILLA
4646	287	SANTIAGO IHUITL??N PLUMAS
4647	287	SANTIAGO IXCUINTEPEC
4648	287	SANTIAGO IXTAYUTLA
4649	287	SANTIAGO JAMILTEPEC
4650	287	SANTIAGO JOCOTEPEC
4651	287	SANTIAGO JUXTLAHUACA
4652	287	SANTIAGO LACHIGUIRI
4653	287	SANTIAGO LALOPA
4654	287	SANTIAGO LAOLLAGA
4655	287	SANTIAGO LAXOPA
4656	287	SANTIAGO LLANO GRANDE
4657	287	SANTIAGO MATATL??N
4658	287	SANTIAGO MILTEPEC
4659	287	SANTIAGO MINAS
4660	287	SANTIAGO NACALTEPEC
4661	287	SANTIAGO NEJAPILLA
4662	287	SANTIAGO NUNDICHE
4663	287	SANTIAGO NUYO??
4664	287	SANTIAGO PINOTEPA NACIONAL
4665	287	SANTIAGO SUCHILQUITONGO
4666	287	SANTIAGO TAMAZOLA
4667	287	SANTIAGO TAPEXTLA
4668	287	VILLA TEJ??PAM DE LA UNI??N
4669	287	SANTIAGO TENANGO
4670	287	SANTIAGO TEPETLAPA
4671	287	SANTIAGO TETEPEC
4672	287	SANTIAGO TEXCALCINGO
4673	287	SANTIAGO TEXTITL??N
4674	287	SANTIAGO TILANTONGO
4675	287	SANTIAGO TILLO
4676	287	SANTIAGO TLAZOYALTEPEC
4677	287	SANTIAGO XANICA
4678	287	SANTIAGO XIACU??
4679	287	SANTIAGO YAITEPEC
4680	287	SANTIAGO YAVEO
4681	287	SANTIAGO YOLOM??CATL
4682	287	SANTIAGO YOSOND??A
4683	287	SANTIAGO YUCUYACHI
4684	287	SANTIAGO ZACATEPEC
4685	287	SANTIAGO ZOOCHILA
4686	287	NUEVO ZOQUI??PAM
4687	287	SANTO DOMINGO INGENIO
4688	287	SANTO DOMINGO ALBARRADAS
4689	287	SANTO DOMINGO ARMENTA
4690	287	SANTO DOMINGO CHIHUIT??N
4691	287	SANTO DOMINGO DE MORELOS
4692	287	SANTO DOMINGO IXCATL??N
4693	287	SANTO DOMINGO NUXA??
4694	287	SANTO DOMINGO OZOLOTEPEC
4695	287	SANTO DOMINGO PETAPA
4696	287	SANTO DOMINGO ROAYAGA
4697	287	SANTO DOMINGO TEHUANTEPEC
4698	287	SANTO DOMINGO TEOJOMULCO
4699	287	SANTO DOMINGO TEPUXTEPEC
4700	287	SANTO DOMINGO TLATAY??PAM
4701	287	SANTO DOMINGO TOMALTEPEC
4702	287	SANTO DOMINGO TONAL??
4703	287	SANTO DOMINGO TONALTEPEC
4704	287	SANTO DOMINGO XAGAC??A
4705	287	SANTO DOMINGO YANHUITL??N
4706	287	SANTO DOMINGO YODOHINO
4707	287	SANTO DOMINGO ZANATEPEC
4708	287	SANTOS REYES NOPALA
4709	287	SANTOS REYES P??PALO
4710	287	SANTOS REYES TEPEJILLO
4711	287	SANTOS REYES YUCUN??
4712	287	SANTO TOM??S JALIEZA
4713	287	SANTO TOM??S MAZALTEPEC
4714	287	SANTO TOM??S OCOTEPEC
4715	287	SANTO TOM??S TAMAZULAPAN
4716	287	SAN VICENTE COATL??N
4717	287	SAN VICENTE LACHIX??O
4718	287	SAN VICENTE NU????
4719	287	SILACAYO??PAM
4720	287	SITIO DE XITLAPEHUA
4721	287	SOLEDAD ETLA
4722	287	VILLA DE TAMAZUL??PAM DEL PROGRESO
4723	287	TANETZE DE ZARAGOZA
4724	287	TANICHE
4725	287	TATALTEPEC DE VALD??S
4726	287	TEOCOCUILCO DE MARCOS P??REZ
4727	287	TEOTITL??N DE FLORES MAG??N
4728	287	TEOTITL??N DEL VALLE
4729	287	TEOTONGO
4730	287	TEPELMEME VILLA DE MORELOS
4731	287	VILLA TEZOATL??N DE SEGURA Y LUNA
4732	287	SAN JER??NIMO TLACOCHAHUAYA
4733	287	TLACOLULA DE MATAMOROS
4734	287	TLACOTEPEC PLUMAS
4735	287	TLALIXTAC DE CABRERA
4736	287	TOTONTEPEC VILLA DE MORELOS
4737	287	TRINIDAD ZAACHILA
4738	287	LA TRINIDAD VISTA HERMOSA
4739	287	UNI??N HIDALGO
4740	287	VALERIO TRUJANO
4741	287	SAN JUAN BAUTISTA VALLE NACIONAL
4742	287	VILLA D??AZ ORDAZ
4743	287	YAXE
4744	287	MAGDALENA YODOCONO DE PORFIRIO D??AZ
4745	287	YOGANA
4746	287	YUTANDUCHI DE GUERRERO
4747	287	VILLA DE ZAACHILA
4748	287	SAN MATEO YUCUTINDOO
4749	287	ZAPOTITL??N LAGUNAS
4750	287	ZAPOTITL??N PALMAS
4751	287	SANTA IN??S DE ZARAGOZA
4752	287	ZIMATL??N DE ??LVAREZ
4753	288	ACAJETE
4754	288	ACATENO
4755	288	ACATZINGO
4756	288	ACTEOPAN
4757	288	AHUATL??N
4758	288	AHUAZOTEPEC
4759	288	AHUEHUETITLA
4760	288	AJALPAN
4761	288	ALBINO ZERTUCHE
4762	288	ALJOJUCA
4763	288	ALTEPEXI
4764	288	AMIXTL??N
4765	288	AMOZOC
4766	288	AQUIXTLA
4767	288	ATEMPAN
4768	288	ATEXCAL
4769	288	ATLIXCO
4770	288	ATOYATEMPAN
4771	288	ATZALA
4772	288	ATZITZIHUAC??N
4773	288	ATZITZINTLA
4774	288	AXUTLA
4775	288	AYOTOXCO DE GUERRERO
4776	288	CALPAN
4777	288	CALTEPEC
4778	288	CAMOCUAUTLA
4779	288	CAXHUACAN
4780	288	COATEPEC
4781	288	COATZINGO
4782	288	COHETZALA
4783	288	COHUECAN
4784	288	CORONANGO
4785	288	COXCATL??N
4786	288	COYOMEAPAN
4787	288	CUAPIAXTLA DE MADERO
4788	288	CUAUTEMPAN
4789	288	CUAUTINCH??N
4790	288	CUAUTLANCINGO
4791	288	CUAYUCA DE ANDRADE
4792	288	CUETZALAN DEL PROGRESO
4793	288	CUYOACO
4794	288	CHALCHICOMULA DE SESMA
4795	288	CHAPULCO
4796	288	CHIAUTZINGO
4797	288	CHICONCUAUTLA
4798	288	CHICHIQUILA
4799	288	CHIETLA
4800	288	CHIGMECATITL??N
4801	288	CHIGNAHUAPAN
4802	288	CHIGNAUTLA
4803	288	CHILA
4804	288	CHILA DE LA SAL
4805	288	HONEY
4806	288	CHILCHOTLA
4807	288	CHINANTLA
4808	288	DOMINGO ARENAS
4809	288	EPATL??N
4810	288	ESPERANZA
4811	288	FRANCISCO Z. MENA
4812	288	GENERAL FELIPE ??NGELES
4813	288	HERMENEGILDO GALEANA
4814	288	HUAQUECHULA
4815	288	HUATLATLAUCA
4816	288	HUAUCHINANGO
4817	288	HUEHUETL??N EL CHICO
4818	288	HUEJOTZINGO
4819	288	HUEYAPAN
4820	288	HUEYTAMALCO
4821	288	HUEYTLALPAN
4822	288	HUITZILAN DE SERD??N
4823	288	HUITZILTEPEC
4824	288	ATLEQUIZAYAN
4825	288	IXCAMILPA DE GUERRERO
4826	288	IXCAQUIXTLA
4827	288	IXTACAMAXTITL??N
4828	288	IXTEPEC
4829	288	IZ??CAR DE MATAMOROS
4830	288	JALPAN
4831	288	JOLALPAN
4832	288	JONOTLA
4833	288	JOPALA
4834	288	JUAN C. BONILLA
4835	288	JUAN GALINDO
4836	288	JUAN N. M??NDEZ
4837	288	LAFRAGUA
4838	288	LIBRES
4839	288	LA MAGDALENA TLATLAUQUITEPEC
4840	288	MAZAPILTEPEC DE JU??REZ
4841	288	MIXTLA
4842	288	MOLCAXAC
4843	288	CA??ADA MORELOS
4844	288	NAUPAN
4845	288	NAUZONTLA
4846	288	NEALTICAN
4847	288	NICOL??S BRAVO
4848	288	NOPALUCAN
4849	288	OCOYUCAN
4850	288	OLINTLA
4851	288	ORIENTAL
4852	288	PAHUATL??N
4853	288	PALMAR DE BRAVO
4854	288	PETLALCINGO
4855	288	PIAXTLA
4856	288	PUEBLA
4857	288	QUECHOLAC
4858	288	QUIMIXTL??N
4859	288	RAFAEL LARA GRAJALES
4860	288	LOS REYES DE JU??REZ
4861	288	SAN ANDR??S CHOLULA
4862	288	SAN ANTONIO CA??ADA
4863	288	SAN DIEGO LA MESA TOCHIMILTZINGO
4864	288	SAN FELIPE TEOTLALCINGO
4865	288	SAN FELIPE TEPATL??N
4866	288	SAN GABRIEL CHILAC
4867	288	SAN GREGORIO ATZOMPA
4868	288	SAN JER??NIMO TECUANIPAN
4869	288	SAN JER??NIMO XAYACATL??N
4870	288	SAN JOS?? CHIAPA
4871	288	SAN JOS?? MIAHUATL??N
4872	288	SAN JUAN ATENCO
4873	288	SAN JUAN ATZOMPA
4874	288	SAN MART??N TEXMELUCAN
4875	288	SAN MART??N TOTOLTEPEC
4876	288	SAN MAT??AS TLALANCALECA
4877	288	SAN MIGUEL IXITL??N
4878	288	SAN MIGUEL XOXTLA
4879	288	SAN NICOL??S BUENOS AIRES
4880	288	SAN NICOL??S DE LOS RANCHOS
4881	288	SAN PABLO ANICANO
4882	288	SAN PEDRO CHOLULA
4883	288	SAN PEDRO YELOIXTLAHUACA
4884	288	SAN SALVADOR EL SECO
4885	288	SAN SALVADOR EL VERDE
4886	288	SAN SALVADOR HUIXCOLOTLA
4887	288	SAN SEBASTI??N TLACOTEPEC
4888	288	SANTA CATARINA TLALTEMPAN
4889	288	SANTA IN??S AHUATEMPAN
4890	288	SANTA ISABEL CHOLULA
4891	288	SANTIAGO MIAHUATL??N
4892	288	HUEHUETL??N EL GRANDE
4893	288	SANTO TOM??S HUEYOTLIPAN
4894	288	SOLTEPEC
4895	288	TECALI DE HERRERA
4896	288	TECAMACHALCO
4897	288	TECOMATL??N
4898	288	TEHUAC??N
4899	288	TEHUITZINGO
4900	288	TENAMPULCO
4901	288	TEOPANTL??N
4902	288	TEOTLALCO
4903	288	TEPANCO DE L??PEZ
4904	288	TEPANGO DE RODR??GUEZ
4905	288	TEPATLAXCO DE HIDALGO
4906	288	TEPEACA
4907	288	TEPEMAXALCO
4908	288	TEPEOJUMA
4909	288	TEPETZINTLA
4910	288	TEPEXCO
4911	288	TEPEXI DE RODR??GUEZ
4912	288	TEPEYAHUALCO
4913	288	TEPEYAHUALCO DE CUAUHT??MOC
4914	288	TETELA DE OCAMPO
4915	288	TETELES DE AVILA CASTILLO
4916	288	TEZIUTL??N
4917	288	TIANGUISMANALCO
4918	288	TILAPA
4919	288	TLACOTEPEC DE BENITO JU??REZ
4920	288	TLACUILOTEPEC
4921	288	TLACHICHUCA
4922	288	TLAHUAPAN
4923	288	TLALTENANGO
4924	288	TLANEPANTLA
4925	288	TLAOLA
4926	288	TLAPACOYA
4927	288	TLAPANAL??
4928	288	TLATLAUQUITEPEC
4929	288	TLAXCO
4930	288	TOCHIMILCO
4931	288	TOCHTEPEC
4932	288	TOTOLTEPEC DE GUERRERO
4933	288	TULCINGO
4934	288	TUZAMAPAN DE GALEANA
4935	288	TZICATLACOYAN
4936	288	XAYACATL??N DE BRAVO
4937	288	XICOTEPEC
4938	288	XICOTL??N
4939	288	XIUTETELCO
4940	288	XOCHIAPULCO
4941	288	XOCHILTEPEC
4942	288	XOCHITL??N DE VICENTE SU??REZ
4943	288	XOCHITL??N TODOS SANTOS
4944	288	YAON??HUAC
4945	288	YEHUALTEPEC
4946	288	ZACAPALA
4947	288	ZACAPOAXTLA
4948	288	ZACATL??N
4949	288	ZAPOTITL??N
4950	288	ZAPOTITL??N DE M??NDEZ
4951	288	ZAUTLA
4952	288	ZIHUATEUTLA
4953	288	ZINACATEPEC
4954	288	ZONGOZOTLA
4955	288	ZOQUIAPAN
4956	288	ZOQUITL??N
4957	289	AMEALCO DE BONFIL
4958	289	PINAL DE AMOLES
4959	289	ARROYO SECO
4960	289	CADEREYTA DE MONTES
4961	289	COL??N
4962	289	CORREGIDORA
4963	289	EZEQUIEL MONTES
4964	289	HUIMILPAN
4965	289	JALPAN DE SERRA
4966	289	LANDA DE MATAMOROS
4967	289	EL MARQU??S
4968	289	PEDRO ESCOBEDO
4969	289	PE??AMILLER
4970	289	QUER??TARO
4971	289	SAN JOAQU??N
4972	289	TEQUISQUIAPAN
4973	290	COZUMEL
4974	290	FELIPE CARRILLO PUERTO
4975	290	ISLA MUJERES
4976	290	OTH??N P. BLANCO
4977	290	JOS?? MAR??A MORELOS
4978	290	SOLIDARIDAD
4979	290	TULUM
4980	290	BACALAR
4981	290	PUERTO MORELOS
4982	291	SAN LUIS POTOS??
4983	291	AHUALULCO
4984	291	ALAQUINES
4985	291	AQUISM??N
4986	291	ARMADILLO DE LOS INFANTE
4987	291	C??RDENAS
4988	291	CATORCE
4989	291	CEDRAL
4990	291	CERRITOS
4991	291	CERRO DE SAN PEDRO
4992	291	CIUDAD DEL MA??Z
4993	291	CIUDAD FERN??NDEZ
4994	291	TANCANHUITZ
4995	291	CIUDAD VALLES
4996	291	CHARCAS
4997	291	EBANO
4998	291	GUADALC??ZAR
4999	291	HUEHUETL??N
5000	291	MATEHUALA
5001	291	MEXQUITIC DE CARMONA
5002	291	MOCTEZUMA
5003	291	RIOVERDE
5004	291	SALINAS
5005	291	SAN ANTONIO
5006	291	SAN CIRO DE ACOSTA
5007	291	SAN MART??N CHALCHICUAUTLA
5008	291	SAN NICOL??S TOLENTINO
5009	291	SANTA MAR??A DEL R??O
5010	291	SANTO DOMINGO
5011	291	SAN VICENTE TANCUAYALAB
5012	291	SOLEDAD DE GRACIANO S??NCHEZ
5013	291	TAMASOPO
5014	291	TAMAZUNCHALE
5015	291	TAMPAC??N
5016	291	TAMPAMOL??N CORONA
5017	291	TAMU??N
5018	291	TANLAJ??S
5019	291	TANQUI??N DE ESCOBEDO
5020	291	TIERRA NUEVA
5021	291	VANEGAS
5022	291	VENADO
5023	291	VILLA DE ARRIAGA
5024	291	VILLA DE GUADALUPE
5025	291	VILLA DE LA PAZ
5026	291	VILLA DE RAMOS
5027	291	VILLA DE REYES
5028	291	VILLA JU??REZ
5029	291	AXTLA DE TERRAZAS
5030	291	XILITLA
5031	291	VILLA DE ARISTA
5032	291	MATLAPA
5033	291	EL NARANJO
5034	292	AHOME
5035	292	ANGOSTURA
5036	292	BADIRAGUATO
5037	292	CONCORDIA
5038	292	COSAL??
5039	292	CULIAC??N
5040	292	CHOIX
5041	292	ELOTA
5042	292	ESCUINAPA
5043	292	EL FUERTE
5044	292	GUASAVE
5045	292	MAZATL??N
5046	292	MOCORITO
5047	292	SALVADOR ALVARADO
5048	292	SAN IGNACIO
5049	292	SINALOA
5050	292	NAVOLATO
5051	293	ACONCHI
5052	293	AGUA PRIETA
5053	293	ALAMOS
5054	293	ALTAR
5055	293	ARIVECHI
5056	293	ARIZPE
5057	293	ATIL
5058	293	BACAD??HUACHI
5059	293	BACANORA
5060	293	BACERAC
5061	293	BACOACHI
5062	293	B??CUM
5063	293	BAN??MICHI
5064	293	BAVI??CORA
5065	293	BAVISPE
5066	293	BENJAM??N HILL
5067	293	CABORCA
5068	293	CAJEME
5069	293	CANANEA
5070	293	CARB??
5071	293	LA COLORADA
5072	293	CUCURPE
5073	293	CUMPAS
5074	293	DIVISADEROS
5075	293	EMPALME
5076	293	ETCHOJOA
5077	293	FRONTERAS
5078	293	GRANADOS
5079	293	GUAYMAS
5080	293	HERMOSILLO
5081	293	HUACHINERA
5082	293	HU??SABAS
5083	293	HUATABAMPO
5084	293	HU??PAC
5085	293	IMURIS
5086	293	NACO
5087	293	N??CORI CHICO
5088	293	NACOZARI DE GARC??A
5089	293	NAVOJOA
5090	293	NOGALES
5091	293	ONAVAS
5092	293	OPODEPE
5093	293	OQUITOA
5094	293	PITIQUITO
5095	293	PUERTO PE??ASCO
5096	293	QUIRIEGO
5097	293	SAHUARIPA
5098	293	SAN FELIPE DE JES??S
5099	293	SAN JAVIER
5100	293	SAN LUIS R??O COLORADO
5101	293	SAN MIGUEL DE HORCASITAS
5102	293	SAN PEDRO DE LA CUEVA
5103	293	SANTA CRUZ
5104	293	S??RIC
5105	293	SOYOPA
5106	293	SUAQUI GRANDE
5107	293	TEPACHE
5108	293	TRINCHERAS
5109	293	TUBUTAMA
5110	293	URES
5111	293	VILLA PESQUEIRA
5112	293	Y??CORA
5113	293	GENERAL PLUTARCO EL??AS CALLES
5114	293	SAN IGNACIO R??O MUERTO
5115	294	BALANC??N
5116	294	CENTLA
5117	294	CENTRO
5118	294	COMALCALCO
5119	294	CUNDUAC??N
5120	294	HUIMANGUILLO
5121	294	JALAPA
5122	294	JALPA DE M??NDEZ
5123	294	JONUTA
5124	294	MACUSPANA
5125	294	NACAJUCA
5126	294	PARA??SO
5127	294	TACOTALPA
5128	294	TEAPA
5129	294	TENOSIQUE
5130	295	ALTAMIRA
5131	295	ANTIGUO MORELOS
5132	295	BURGOS
5133	295	CASAS
5134	295	CIUDAD MADERO
5135	295	CRUILLAS
5136	295	GONZ??LEZ
5137	295	G????MEZ
5138	295	GUSTAVO D??AZ ORDAZ
5139	295	JAUMAVE
5140	295	LLERA
5141	295	MAINERO
5142	295	EL MANTE
5143	295	M??NDEZ
5144	295	MIER
5145	295	MIGUEL ALEM??N
5146	295	MIQUIHUANA
5147	295	NUEVO LAREDO
5148	295	NUEVO MORELOS
5149	295	PADILLA
5150	295	PALMILLAS
5151	295	REYNOSA
5152	295	R??O BRAVO
5153	295	SAN CARLOS
5154	295	SOTO LA MARINA
5155	295	TAMPICO
5156	295	TULA
5157	295	VALLE HERMOSO
5158	295	XICOT??NCATL
5159	296	AMAXAC DE GUERRERO
5160	296	APETATITL??N DE ANTONIO CARVAJAL
5161	296	ATLANGATEPEC
5162	296	ATLTZAYANCA
5163	296	APIZACO
5164	296	CALPULALPAN
5165	296	EL CARMEN TEQUEXQUITLA
5166	296	CUAPIAXTLA
5167	296	CUAXOMULCO
5168	296	CHIAUTEMPAN
5169	296	MU??OZ DE DOMINGO ARENAS
5170	296	ESPA??ITA
5171	296	HUAMANTLA
5172	296	HUEYOTLIPAN
5173	296	IXTACUIXTLA DE MARIANO MATAMOROS
5174	296	IXTENCO
5175	296	MAZATECOCHCO DE JOS?? MAR??A MORELOS
5176	296	CONTLA DE JUAN CUAMATZI
5177	296	TEPETITLA DE LARDIZ??BAL
5178	296	SANCT??RUM DE L??ZARO C??RDENAS
5179	296	NANACAMILPA DE MARIANO ARISTA
5180	296	ACUAMANALA DE MIGUEL HIDALGO
5181	296	NAT??VITAS
5182	296	PANOTLA
5183	296	SAN PABLO DEL MONTE
5184	296	SANTA CRUZ TLAXCALA
5185	296	TEOLOCHOLCO
5186	296	TEPEYANCO
5187	296	TERRENATE
5188	296	TETLA DE LA SOLIDARIDAD
5189	296	TETLATLAHUCA
5190	296	TLAXCALA
5191	296	TOCATL??N
5192	296	TOTOLAC
5193	296	ZILTLALT??PEC DE TRINIDAD S??NCHEZ SANTOS
5194	296	TZOMPANTEPEC
5195	296	XALOZTOC
5196	296	XALTOCAN
5197	296	PAPALOTLA DE XICOHT??NCATL
5198	296	XICOHTZINCO
5199	296	YAUHQUEMEHCAN
5200	296	ZACATELCO
5201	296	LA MAGDALENA TLALTELULCO
5202	296	SAN DAMI??N TEX??LOC
5203	296	SAN FRANCISCO TETLANOHCAN
5204	296	SAN JER??NIMO ZACUALPAN
5205	296	SAN JOS?? TEACALCO
5206	296	SAN JUAN HUACTZINCO
5207	296	SAN LORENZO AXOCOMANITLA
5208	296	SAN LUCAS TECOPILCO
5209	296	SANTA ANA NOPALUCAN
5210	296	SANTA APOLONIA TEACALCO
5211	296	SANTA CATARINA AYOMETLA
5212	296	SANTA CRUZ QUILEHTLA
5213	296	SANTA ISABEL XILOXOXTLA
5214	297	ACAYUCAN
5215	297	ACULA
5216	297	ACULTZINGO
5217	297	CAMAR??N DE TEJEDA
5218	297	ALPATL??HUAC
5219	297	ALTO LUCERO DE GUTI??RREZ BARRIOS
5220	297	ALTOTONGA
5221	297	ALVARADO
5222	297	AMATITL??N
5223	297	NARANJOS AMATL??N
5224	297	AMATL??N DE LOS REYES
5225	297	ANGEL R. CABADA
5226	297	LA ANTIGUA
5227	297	APAZAPAN
5228	297	ASTACINGA
5229	297	ATLAHUILCO
5230	297	ATZACAN
5231	297	ATZALAN
5232	297	TLALTETELA
5233	297	AYAHUALULCO
5234	297	BANDERILLA
5235	297	BOCA DEL R??O
5236	297	CALCAHUALCO
5237	297	CAMERINO Z. MENDOZA
5238	297	CARRILLO PUERTO
5239	297	CATEMACO
5240	297	CAZONES DE HERRERA
5241	297	CERRO AZUL
5242	297	CITLALT??PETL
5243	297	COACOATZINTLA
5244	297	COAHUITL??N
5245	297	COATZACOALCOS
5246	297	COATZINTLA
5247	297	COETZALA
5248	297	COLIPA
5249	297	COMAPA
5250	297	C??RDOBA
5251	297	COSAMALOAPAN DE CARPIO
5252	297	COSAUTL??N DE CARVAJAL
5253	297	COSCOMATEPEC
5254	297	COSOLEACAQUE
5255	297	COTAXTLA
5256	297	COXQUIHUI
5257	297	COYUTLA
5258	297	CUICHAPA
5259	297	CUITL??HUAC
5260	297	CHACALTIANGUIS
5261	297	CHALMA
5262	297	CHICONAMEL
5263	297	CHICONQUIACO
5264	297	CHICONTEPEC
5265	297	CHINAMECA
5266	297	CHINAMPA DE GOROSTIZA
5267	297	LAS CHOAPAS
5268	297	CHOCAM??N
5269	297	CHONTLA
5270	297	CHUMATL??N
5271	297	ESPINAL
5272	297	FILOMENO MATA
5273	297	FORT??N
5274	297	GUTI??RREZ ZAMORA
5275	297	HIDALGOTITL??N
5276	297	HUATUSCO
5277	297	HUAYACOCOTLA
5278	297	HUEYAPAN DE OCAMPO
5279	297	HUILOAPAN DE CUAUHT??MOC
5280	297	IGNACIO DE LA LLAVE
5281	297	ILAMATL??N
5282	297	ISLA
5283	297	IXCATEPEC
5284	297	IXHUAC??N DE LOS REYES
5285	297	IXHUATL??N DEL CAF??
5286	297	IXHUATLANCILLO
5287	297	IXHUATL??N DEL SURESTE
5288	297	IXHUATL??N DE MADERO
5289	297	IXMATLAHUACAN
5290	297	IXTACZOQUITL??N
5291	297	JALACINGO
5292	297	XALAPA
5293	297	JALCOMULCO
5294	297	J??LTIPAN
5295	297	JAMAPA
5296	297	JES??S CARRANZA
5297	297	XICO
5298	297	JUAN RODR??GUEZ CLARA
5299	297	JUCHIQUE DE FERRER
5300	297	LANDERO Y COSS
5301	297	LERDO DE TEJADA
5302	297	MALTRATA
5303	297	MANLIO FABIO ALTAMIRANO
5304	297	MARIANO ESCOBEDO
5305	297	MART??NEZ DE LA TORRE
5306	297	MECATL??N
5307	297	MECAYAPAN
5308	297	MEDELL??N DE BRAVO
5309	297	MIAHUATL??N
5310	297	LAS MINAS
5311	297	MISANTLA
5312	297	MIXTLA DE ALTAMIRANO
5313	297	MOLOAC??N
5314	297	NAOLINCO
5315	297	NARANJAL
5316	297	NAUTLA
5317	297	OLUTA
5318	297	OMEALCA
5319	297	ORIZABA
5320	297	OTATITL??N
5321	297	OTEAPAN
5322	297	OZULUAMA DE MASCARE??AS
5323	297	PAJAPAN
5324	297	P??NUCO
5325	297	PAPANTLA
5326	297	PASO DEL MACHO
5327	297	PASO DE OVEJAS
5328	297	LA PERLA
5329	297	PEROTE
5330	297	PLAT??N S??NCHEZ
5331	297	PLAYA VICENTE
5332	297	POZA RICA DE HIDALGO
5333	297	LAS VIGAS DE RAM??REZ
5334	297	PUEBLO VIEJO
5335	297	PUENTE NACIONAL
5336	297	RAFAEL DELGADO
5337	297	RAFAEL LUCIO
5338	297	R??O BLANCO
5339	297	SALTABARRANCA
5340	297	SAN ANDR??S TENEJAPAN
5341	297	SAN ANDR??S TUXTLA
5342	297	SAN JUAN EVANGELISTA
5343	297	SANTIAGO TUXTLA
5344	297	SAYULA DE ALEM??N
5345	297	SOCONUSCO
5346	297	SOCHIAPA
5347	297	SOLEDAD ATZOMPA
5348	297	SOLEDAD DE DOBLADO
5349	297	SOTEAPAN
5350	297	TAMAL??N
5351	297	TAMIAHUA
5352	297	TAMPICO ALTO
5353	297	TANCOCO
5354	297	TANTIMA
5355	297	TANTOYUCA
5356	297	TATATILA
5357	297	CASTILLO DE TEAYO
5358	297	TECOLUTLA
5359	297	TEHUIPANGO
5360	297	??LAMO TEMAPACHE
5361	297	TEMPOAL
5362	297	TENAMPA
5363	297	TENOCHTITL??N
5364	297	TEOCELO
5365	297	TEPATLAXCO
5366	297	TEPETL??N
5367	297	JOS?? AZUETA
5368	297	TEXCATEPEC
5369	297	TEXHUAC??N
5370	297	TEXISTEPEC
5371	297	TEZONAPA
5372	297	TIHUATL??N
5373	297	TLACOJALPAN
5374	297	TLACOLULAN
5375	297	TLACOTALPAN
5376	297	TLACOTEPEC DE MEJ??A
5377	297	TLACHICHILCO
5378	297	TLALIXCOYAN
5379	297	TLALNELHUAYOCAN
5380	297	TLAPACOYAN
5381	297	TLAQUILPA
5382	297	TLILAPAN
5383	297	TONAY??N
5384	297	TOTUTLA
5385	297	TUXTILLA
5386	297	URSULO GALV??N
5387	297	VEGA DE ALATORRE
5388	297	VERACRUZ
5389	297	VILLA ALDAMA
5390	297	XOXOCOTLA
5391	297	YANGA
5392	297	YECUATLA
5393	297	ZENTLA
5394	297	ZONGOLICA
5395	297	ZONTECOMATL??N DE L??PEZ Y FUENTES
5396	297	ZOZOCOLCO DE HIDALGO
5397	297	AGUA DULCE
5398	297	EL HIGO
5399	297	NANCHITAL DE L??ZARO C??RDENAS DEL R??O
5400	297	TRES VALLES
5401	297	CARLOS A. CARRILLO
5402	297	TATAHUICAPAN DE JU??REZ
5403	297	UXPANAPA
5404	297	SAN RAFAEL
5405	297	SANTIAGO SOCHIAPAN
5406	298	ABAL??
5407	298	ACANCEH
5408	298	AKIL
5409	298	BACA
5410	298	BOKOB??
5411	298	BUCTZOTZ
5412	298	CACALCH??N
5413	298	CALOTMUL
5414	298	CANSAHCAB
5415	298	CANTAMAYEC
5416	298	CELEST??N
5417	298	CENOTILLO
5418	298	CONKAL
5419	298	CUNCUNUL
5420	298	CUZAM??
5421	298	CHACSINK??N
5422	298	CHANKOM
5423	298	CHAPAB
5424	298	CHEMAX
5425	298	CHICXULUB PUEBLO
5426	298	CHICHIMIL??
5427	298	CHIKINDZONOT
5428	298	CHOCHOL??
5429	298	CHUMAYEL
5430	298	DZ??N
5431	298	DZEMUL
5432	298	DZIDZANT??N
5433	298	DZILAM DE BRAVO
5434	298	DZILAM GONZ??LEZ
5435	298	DZIT??S
5436	298	DZONCAUICH
5437	298	ESPITA
5438	298	HALACH??
5439	298	HOCAB??
5440	298	HOCT??N
5441	298	HOM??N
5442	298	HUH??
5443	298	HUNUCM??
5444	298	IXIL
5445	298	IZAMAL
5446	298	KANAS??N
5447	298	KANTUNIL
5448	298	KAUA
5449	298	KINCHIL
5450	298	KOPOM??
5451	298	MAMA
5452	298	MAN??
5453	298	MAXCAN??
5454	298	MAYAP??N
5455	298	M??RIDA
5456	298	MOCOCH??
5457	298	MOTUL
5458	298	MUNA
5459	298	MUXUPIP
5460	298	OPICH??N
5461	298	OXKUTZCAB
5462	298	PANAB??
5463	298	PETO
5464	298	QUINTANA ROO
5465	298	R??O LAGARTOS
5466	298	SACALUM
5467	298	SAMAHIL
5468	298	SANAHCAT
5469	298	SANTA ELENA
5470	298	SEY??
5471	298	SINANCH??
5472	298	SOTUTA
5473	298	SUCIL??
5474	298	SUDZAL
5475	298	SUMA
5476	298	TAHDZI??
5477	298	TAHMEK
5478	298	TEABO
5479	298	TECOH
5480	298	TEKAL DE VENEGAS
5481	298	TEKANT??
5482	298	TEKAX
5483	298	TEKIT
5484	298	TEKOM
5485	298	TELCHAC PUEBLO
5486	298	TELCHAC PUERTO
5487	298	TEMAX
5488	298	TEMOZ??N
5489	298	TEPAK??N
5490	298	TETIZ
5491	298	TEYA
5492	298	TICUL
5493	298	TIMUCUY
5494	298	TINUM
5495	298	TIXCACALCUPUL
5496	298	TIXKOKOB
5497	298	TIXMEHUAC
5498	298	TIXP??HUAL
5499	298	TIZIM??N
5500	298	TUNK??S
5501	298	TZUCACAB
5502	298	UAYMA
5503	298	UC??
5504	298	UM??N
5505	298	VALLADOLID
5506	298	XOCCHEL
5507	298	YAXCAB??
5508	298	YAXKUKUL
5509	298	YOBA??N
5510	299	APOZOL
5511	299	APULCO
5512	299	ATOLINGA
5513	299	CALERA
5514	299	CA??ITAS DE FELIPE PESCADOR
5515	299	CONCEPCI??N DEL ORO
5516	299	CHALCHIHUITES
5517	299	FRESNILLO
5518	299	TRINIDAD GARC??A DE LA CADENA
5519	299	GENARO CODINA
5520	299	GENERAL ENRIQUE ESTRADA
5521	299	GENERAL FRANCISCO R. MURGU??A
5522	299	EL PLATEADO DE JOAQU??N AMARO
5523	299	GENERAL P??NFILO NATERA
5524	299	HUANUSCO
5525	299	JALPA
5526	299	JEREZ
5527	299	JIM??NEZ DEL TEUL
5528	299	JUAN ALDAMA
5529	299	JUCHIPILA
5530	299	LUIS MOYA
5531	299	MAZAPIL
5532	299	MEZQUITAL DEL ORO
5533	299	MIGUEL AUZA
5534	299	MOMAX
5535	299	MONTE ESCOBEDO
5536	299	MOYAHUA DE ESTRADA
5537	299	NOCHISTL??N DE MEJ??A
5538	299	NORIA DE ??NGELES
5539	299	OJOCALIENTE
5540	299	PINOS
5541	299	R??O GRANDE
5542	299	SAIN ALTO
5543	299	EL SALVADOR
5544	299	SOMBRERETE
5545	299	SUSTICAC??N
5546	299	TABASCO
5547	299	TEPECHITL??N
5548	299	TEPETONGO
5549	299	TE??L DE GONZ??LEZ ORTEGA
5550	299	TLALTENANGO DE S??NCHEZ ROM??N
5551	299	VALPARA??SO
5552	299	VETAGRANDE
5553	299	VILLA DE COS
5554	299	VILLA GARC??A
5555	299	VILLA GONZ??LEZ ORTEGA
5556	299	VILLANUEVA
5557	299	ZACATECAS
5558	299	TRANCOSO
5559	300	Adolfo Alsina
5560	300	Adolfo Gonzales Chaves
5561	300	Alberti
5562	300	Almirante Brown
5563	300	Arrecifes
5564	300	Avellaneda
5565	300	Ayacucho
5566	300	Azul
5567	300	Bah??a Blanca
5568	300	Balcarce
5569	300	Baradero
5570	300	Benito Ju??rez
5571	300	Berazategui
5572	300	Berisso
5573	300	Bol??var
5574	300	Bragado
5575	300	Brandsen
5576	300	Buenos Aires
5577	300	Campana
5578	300	Ca??uelas
5579	300	Capit??n Sarmiento Carlos
5580	300	Carlos Casares
5581	300	Carlos Tejedor
5582	300	Carmen de Areco
5583	300	Castelli
5584	300	Chacabuco
5585	300	Chascom??s
5586	300	Chivilcoy
5587	300	Col??n
5588	300	Coronel de Marina Leonardo Rosales
5589	300	Coronel Dorrego
5590	300	Coronel Pringles
5591	300	Coronel Su??rez
5592	300	Daireaux
5593	300	Dolores
5594	300	Ensenada
5595	300	Escobar
5596	300	Esteban Echeverr??a
5597	300	Exaltaci??n de la Cruz
5598	300	Ezeiza
5599	300	Florencio Varela
5600	300	Florentino Ameghino
5601	300	General Alvarado
5602	300	General Alvear
5603	300	General Arenales
5604	300	General Belgrano
5605	300	General Guido
5606	300	General Juan Madariaga
5607	300	General La Madrid
5608	300	General Las Heras
5609	300	General Lavalle
5610	300	General Paz
5611	300	General Pinto
5612	300	General Pueyrred??n
5613	300	General Rodr??guez
5614	300	General San Mart??n
5615	300	General Viamonte
5616	300	General Villegas
5617	300	Guamin??
5618	300	Hip??lito Yrigoyen
5619	300	Hurlingham
5620	300	Ituzaing??
5621	300	Jos?? C. Paz
5622	300	Jun??n
5623	300	La Costa
5624	300	La Matanza
5625	300	La Plata
5626	300	Lan??s
5627	300	Laprida
5628	300	Las Flores
5629	300	Leandro N. Alem
5630	300	Lincoln
5631	300	Lober??a
5632	300	Lobos
5633	300	Lomas de Zamora
5634	300	Luj??n
5635	300	Magdalena
5636	300	Maip??
5637	300	Malvinas Argentinas
5638	300	Mar Chiquita
5639	300	Marcos Paz
5640	300	Mercedes
5641	300	Merlo
5642	300	Monte
5643	300	Monte Hermoso
5644	300	Moreno
5645	300	Mor??n
5646	300	Navarro
5647	300	Necochea
5648	300	Nueve de Julio
5649	300	Olavarr??a
5650	300	Patagones
5651	300	Pehuaj??
5652	300	Pellegrini
5653	300	Pergamino
5654	300	Pila
5655	300	Pilar
5656	300	Pinamar
5657	300	Presidente Per??n
5658	300	Puan
5659	300	Punta Indio
5660	300	Quilmes
5661	300	Ramallo
5662	300	Rauch
5663	300	Rivadavia
5664	300	Rojas
5665	300	Roque P??rez
5666	300	Saavedra
5667	300	Saladillo
5668	300	Salliquel??
5669	300	Salto
5670	300	San Andr??s de Giles
5671	300	San Antonio de Areco
5672	300	San Cayetano
5673	300	San Fernando
5674	300	San Isidro
5675	300	San Miguel
5676	300	San Nicol??s
5677	300	San Pedro
5678	300	San Vicente
5679	300	Suipacha
5680	300	Tandil
5681	300	Tapalqu??
5682	300	Tigre
5683	300	Tordillo
5684	300	Tornquist
5685	300	Trenque Lauquen
5686	300	Tres Arroyos
5687	300	Tres de Febrero
5688	300	Tres Lomas
5689	300	Veinticinco de Mayo
5690	300	Vicente L??pez
5691	300	Villa Gesell
5692	300	Villarino
5693	300	Z??rate
5694	301	Ambato
5695	301	Ancasti
5696	301	Andalgal??
5697	301	Antofagasta de la Sierra
5698	301	Bel??n
5699	301	Capay??n
5700	301	Capital
5701	301	El Alto
5702	301	Fray Mamerto Esqui??
5703	301	La Paz
5704	301	Pacl??n
5705	301	Pom??n
5706	301	Santa Mar??a
5707	301	Santa Rosa
5708	301	Tinogasta
5709	301	Valle Viejo
5710	302	Bermejo
5711	302	Comandante Fern??ndez
5712	302	Doce de Octubre
5713	302	Dos de Abril
5714	302	Fray Justo Santa Mar??a de Oro
5715	302	General Donovan
5716	302	General G??emes
5717	302	Independencia
5718	302	Libertad
5719	302	Libertador General San Mart??n
5720	302	Mayor Luis Jorge Fontana
5721	302	O'Higgins
5722	302	Presidencia de la Plaza
5723	302	Primero de Mayo
5724	302	Quitilipi
5725	302	San Lorenzo
5726	302	Sargento Cabral
5727	302	Tapenag??
5728	303	Biedma
5729	303	Cushamen
5730	303	Escalante
5731	303	Futaleuf??
5732	303	Gaiman
5733	303	Gastre
5734	303	Langui??eo
5735	303	M??rtires
5736	303	Paso de Indios
5737	303	Rawson
5738	303	R??o Senguer
5739	303	Sarmiento
5740	303	Tehuelches
5741	303	Telsen
5742	304	Calamuchita
5743	304	Cruz del Eje
5744	304	General Roca
5745	304	Ischil??n
5746	304	Ju??rez Celman
5747	304	Marcos Ju??rez
5748	304	Minas
5749	304	Pocho
5750	304	Presidente Roque S??enz Pe??a
5751	304	Punilla
5752	304	R??o Cuarto
5753	304	R??o Primero
5754	304	R??o Seco
5755	304	R??o Segundo
5756	304	San Alberto
5757	304	San Javier
5758	304	San Justo
5759	304	Sobremonte
5760	304	Tercero Arriba
5761	304	Totoral
5762	304	Tulumba
5763	304	Uni??n
5764	305	Bella Vista
5765	305	Ber??n de Astrada
5766	305	Concepci??n
5767	305	Curuz?? Cuati??
5768	305	Empedrado
5769	305	Esquina
5770	305	Goya
5771	305	Itat??
5772	305	Lavalle
5773	305	Mburucuy??
5774	305	Monte Caseros
5775	305	Paso de los Libres
5776	305	Saladas
5777	305	San Cosme
5778	305	San Luis del Palmar
5779	305	San Mart??n
5780	305	San Roque
5781	305	Santo Tom??
5782	305	Sauce
5783	306	Concordia
5784	306	Diamante
5785	306	Federaci??n
5786	306	Federal
5787	306	Feliciano
5788	306	Gualeguay
5789	306	Gualeguaych??
5790	306	Islas del Ibicuy
5791	306	Nogoy??
5792	306	Paran??
5793	306	San Salvador
5794	306	Tala
5795	306	Uruguay
5796	306	Victoria
5797	306	Villaguay
5798	307	Formosa
5799	307	Laishi
5800	307	Matacos
5801	307	Pati??o
5802	307	Pilag??s
5803	307	Pilcomayo
5804	307	Piran??
5805	307	Ram??n Lista
5806	308	Cochinoca
5807	308	Doctor Manuel Belgrano
5808	308	El Carmen
5809	308	Humahuaca
5810	308	Ledesma
5811	308	Palpal??
5812	308	Rinconada
5813	308	San Antonio
5814	308	Santa B??rbara
5815	308	Santa Catalina
5816	308	Susques
5817	308	Tilcara
5818	308	Tumbaya
5819	308	Valle Grande
5820	308	Yavi
5821	309	Atreuc??
5822	309	Caleu Caleu
5823	309	Catril??
5824	309	Chalileo
5825	309	Chapaleuf??
5826	309	Chical Co
5827	309	Conhelo
5828	309	Curac??
5829	309	Guatrach??
5830	309	Hucal
5831	309	Lihuel Calel
5832	309	Limay Mahuida
5833	309	Loventu??
5834	309	Marac??
5835	309	Puel??n
5836	309	Quem?? Quem??
5837	309	Rancul
5838	309	Realic??
5839	309	Toay
5840	309	Trenel
5841	309	Utrac??n
5842	310	Arauco
5843	310	Castro Barros
5844	310	Chamical
5845	310	Chilecito
5846	310	Coronel Felipe Varela
5847	310	Famatina
5848	310	General ??ngel V. Pe??aloza
5849	310	General Juan Facundo Quiroga
5850	310	General Lamadrid
5851	310	General Ocampo
5852	310	Rosario Vera Pe??aloza
5853	310	San Blas de los Sauces
5854	310	Sanagasta
5855	310	Vinchina
5856	311	Godoy Cruz
5857	311	Guaymall??n
5858	311	Las Heras
5859	311	Luj??n de Cuyo
5860	311	Malarg??e
5861	311	San Carlos
5862	311	San Rafael
5863	311	Tunuy??n
5864	311	Tupungato
5865	312	Ap??stoles
5866	312	Caingu??s
5867	312	Candelaria
5868	312	Eldorado
5869	312	General Manuel Belgrano
5870	312	Guaran??
5871	312	Iguaz??
5872	312	Montecarlo
5873	312	Ober??
5874	312	San Ignacio
5875	313	Alumin??
5876	313	A??elo
5877	313	Cat??n Lil
5878	313	Chos Malal
5879	313	Coll??n Cur??
5880	313	Confluencia
5881	313	Huiliches
5882	313	L??car
5883	313	Loncopu??
5884	313	Los Lagos
5885	313	??orqu??n
5886	313	Pehuenches
5887	313	Pic??n Leuf??
5888	313	Picunches
5889	313	Zapala
5890	314	Bariloche
5891	314	Conesa
5892	314	El Cuy
5893	314	??orquinc??
5894	314	Pichi Mahuida
5895	314	Pilcaniyeu
5896	314	Valcheta
5897	315	Anta
5898	315	Cachi
5899	315	Cafayate
5900	315	Cerrillos
5901	315	Chicoana
5902	315	General Jos?? de San Mart??n
5903	315	Guachipas
5904	315	Iruya
5905	315	La Caldera
5906	315	La Candelaria
5907	315	La Poma
5908	315	La Vi??a
5909	315	Los Andes
5910	315	Met??n
5911	315	Molinos
5912	315	Or??n
5913	315	Rosario de la Frontera
5914	315	Rosario de Lerma
5915	315	Santa Victoria
5916	316	Albard??n
5917	316	Angaco
5918	316	Calingasta
5919	316	Caucete
5920	316	Chimbas
5921	316	Iglesia
5922	316	J??chal
5923	316	Pocito
5924	316	Santa Luc??a
5925	316	Ullum
5926	316	Valle F??rtil
5927	316	Zonda
5928	317	Belgrano
5929	317	General Pedernera
5930	317	Gobernador Dupuy
5931	317	La Capital
5932	318	Corpen Aike
5933	318	Deseado
5934	318	G??er Aike
5935	318	Lago Argentino
5936	318	Lago Buenos Aires
5937	318	Magallanes
5938	318	R??o Chico
5939	319	Caseros
5940	319	Castellanos
5941	319	Constituci??n
5942	319	Garay
5943	319	General L??pez
5944	319	General Obligado
5945	319	Iriondo
5946	319	Las Colonias
5947	319	Rosario
5948	319	San Crist??bal
5949	319	San Jer??nimo
5950	319	Vera
5951	320	Aguirre
5952	320	Alberdi
5953	320	Atamisqui
5954	320	Banda
5955	320	Choya
5956	320	Copo
5957	320	Figueroa
5958	320	General Taboada
5959	320	Guasay??n
5960	320	Jim??nez
5961	320	Juan F. Ibarra
5962	320	Loreto
5963	320	Mitre
5964	320	Ojo de Agua
5965	320	Quebrachos
5966	320	R??o Hondo
5967	320	Robles
5968	320	Salavina
5969	320	Sil??pica
5970	321	R??o Grande
5971	321	Ushuaia
5972	322	Burruyac??
5973	322	Chicligasta
5974	322	Cruz Alta
5975	322	Famaill??
5976	322	Graneros
5977	322	Juan Bautista Alberdi
5978	322	La Cocha
5979	322	Leales
5980	322	Lules
5981	322	Monteros
5982	322	Simoca
5983	322	Taf?? del Valle
5984	322	Taf?? Viejo
5985	322	Trancas
5986	322	Yerba Buena
5987	323	Assis Brasil
5988	323	Brasil??ia
5989	323	Epitaciol??ndia
5990	323	Xapuri
5991	323	Acrel??ndia
5992	323	Bujari
5993	323	Capixaba
5994	323	Pl??cido de Castro
5995	323	Porto Acre
5996	323	Rio Branco??(Capital)
5997	323	Senador Guiomard
5998	323	Manoel Urbano
5999	323	Santa Rosa do Purus
6000	323	Sena Madureira
6001	323	Cruzeiro do Sul
6002	323	M??ncio Lima
6003	323	Marechal Thaumaturgo
6004	323	Porto Walter
6005	323	Rodrigues Alves
6006	323	Feij??
6007	323	Jord??o
6008	323	Tarauac??
6009	324	Arapiraca
6010	324	Campo Grande
6011	324	Coit?? do N??ia
6012	324	Cra??bas
6013	324	Feira Grande
6014	324	Girau do Ponciano
6015	324	Lagoa da Canoa
6016	324	Limoeiro de Anadia
6017	324	S??o Sebasti??o
6018	324	Taquarana
6019	324	Bel??m
6020	324	Cacimbinhas
6021	324	Estrela de Alagoas
6022	324	Igaci
6023	324	Mar Vermelho
6024	324	Maribondo
6025	324	Minador do Negr??o
6026	324	Palmeira dos ??ndios
6027	324	Paulo Jacinto
6028	324	Quebrangulo
6029	324	Tanque d'Arca
6030	324	Olho d'??gua Grande
6031	324	S??o Br??s
6032	324	Traipu
6033	324	Japaratinga
6034	324	Maragogi
6035	324	Passo de Camaragibe
6036	324	Porto de Pedras
6037	324	S??o Miguel dos Milagres
6038	324	Barra de Santo Ant??nio
6039	324	Barra de S??o Miguel
6040	324	Coqueiro Seco
6041	324	Macei????(capital estatal)
6042	324	Marechal Deodoro
6043	324	Paripueira
6044	324	Pilar
6045	324	Rio Largo
6046	324	Santa Luzia do Norte
6047	324	Satuba
6048	324	Atalaia
6049	324	Branquinha
6050	324	Cajueiro
6051	324	Campestre
6052	324	Capela
6053	324	Col??nia Leopoldina
6054	324	Flexeiras
6055	324	Jacu??pe
6056	324	Joaquim Gomes
6057	324	Jundi??
6058	324	Matriz de Camaragibe
6059	324	Messias
6060	324	Murici
6061	324	Novo Lino
6062	324	Porto Calvo
6063	324	S??o Lu??s do Quitunde
6064	324	Feliz Deserto
6065	324	Igreja Nova
6066	324	Penedo
6067	324	Pia??abu??u
6068	324	Porto Real do Col??gio
6069	324	Anadia
6070	324	Boca da Mata
6071	324	Campo Alegre
6072	324	Coruripe
6073	324	Jequi?? da Praia
6074	324	Junqueiro
6075	324	Roteiro
6076	324	S??o Miguel dos Campos
6077	324	Teot??nio Vilela
6078	324	Ch?? Preta
6079	324	Ibateguara
6080	324	Pindoba
6081	324	Santana do Munda??
6082	324	S??o Jos?? da Laje
6083	324	Uni??o dos Palmares
6084	324	Vi??osa
6085	324	Delmiro Gouveia
6086	324	Olho d'??gua do Casado
6087	324	Piranhas
6088	324	Batalha
6089	324	Belo Monte
6090	324	Jacar?? dos Homens
6091	324	Jaramataia
6092	324	Major Isidoro
6093	324	Monteir??polis
6094	324	Olho d'??gua das Flores
6095	324	Oliven??a
6096	324	Carneiros
6097	324	Dois Riachos
6098	324	Maravilha
6099	324	Ouro Branco
6100	324	Palestina
6101	324	P??o de A????car
6102	324	Po??o das Trincheiras
6103	324	Santana do Ipanema
6104	324	S??o Jos?? da Tapera
6105	324	Senador Rui Palmeira
6106	324	??gua Branca
6107	324	Canapi
6108	324	Inhapi
6109	324	Mata Grande
6110	324	Pariconha
6111	325	Amap??
6112	325	Cal??oene
6113	325	Cutias
6114	325	Ferreira Gomes
6115	325	Itaubal
6116	325	Laranjal do Jari
6117	325	Macap??
6118	325	Mazag??o
6119	325	Oiapoque
6120	325	Pedra Branca do Amapari
6121	325	Porto Grande
6122	325	Pracu??ba
6123	325	Santana
6124	325	Serra do Navio
6125	325	Tartarugalzinho
6126	325	Vit??ria do Jari
6127	326	Alvar??es
6128	326	Amatur??
6129	326	Anam??
6130	326	Anori
6131	326	Apu??
6132	326	Atalaia do Norte
6133	326	Autazes
6134	326	Barcelos
6135	326	Barreirinha
6136	326	Benjamin Constant
6137	326	Beruri
6138	326	Boa Vista do Ramos
6139	326	Boca do Acre
6140	326	Borba
6141	326	Caapiranga
6142	326	Canutama
6143	326	Carauari
6144	326	Careiro
6145	326	Careiro da V??rzea
6146	326	Coari
6147	326	Codaj??s
6148	326	Eirunep??
6149	326	Envira
6150	326	Fonte Boa
6151	326	Guajar??
6152	326	Humait??
6153	326	Ipixuna
6154	326	Iranduba
6155	326	Itacoatiara
6156	326	Itamarati
6157	326	Itapiranga
6158	326	Japur??
6159	326	Juru??
6160	326	Juta??
6161	326	L??brea
6162	326	Manacapuru
6163	326	Manaquiri
6164	326	Manaus
6165	326	Manicor??
6166	326	Mara??
6167	326	Mau??s
6168	326	Nhamund??
6169	326	Nova Olinda do Norte
6170	326	Novo Air??o
6171	326	Novo Aripuan??
6172	326	Parintins
6173	326	Pauini
6174	326	Presidente Figueiredo
6175	326	Rio Preto da Eva
6176	326	Santa Isabel do Rio Negro
6177	326	Santo Ant??nio do I????
6178	326	S??o Gabriel da Cachoeira
6179	326	S??o Paulo de Oliven??a
6180	326	S??o Sebasti??o do Uatum??
6181	326	Silves
6182	326	Tabatinga
6183	326	Tapau??
6184	326	Tef??
6185	326	Tonantins
6186	326	Uarini
6187	326	Urucar??
6188	326	Urucurituba
6189	327	??gua Fria
6190	327	Am??lia Rodrigues
6191	327	Anguera
6192	327	Ant??nio Cardoso
6193	327	Concei????o da Feira
6194	327	Cora????o de Maria
6195	327	El??sio Medrado
6196	327	Feira de Santana
6197	327	Ipecaet??
6198	327	Ipir??
6199	327	Irar??
6200	327	Itatim
6201	327	Ouri??angas
6202	327	Pedr??o
6203	327	Pintadas
6204	327	Rafael Jambeiro
6205	327	Santa B??rbara
6206	327	Santa Teresinha
6207	327	Santan??polis
6208	327	Santo Est??v??o
6209	327	S??o Gon??alo dos Campos
6210	327	Serra Preta
6211	327	Tanquinho
6212	327	Teodoro Sampaio
6213	327	Am??rica Dourada
6214	327	Barra do Mendes
6215	327	Barro Alto
6216	327	Cafarnaum
6217	327	Canarana
6218	327	Central
6219	327	Gentio do Ouro
6220	327	Ibipeba
6221	327	Ibitit??
6222	327	Iraquara
6223	327	Irec??
6224	327	Jo??o Dourado
6225	327	Jussara
6226	327	Lap??o
6227	327	Mulungu do Morro
6228	327	Presidente Dutra
6229	327	S??o Gabriel
6230	327	Souto Soares
6231	327	Uiba??
6232	327	Baixa Grande
6233	327	Boa Vista do Tupim
6234	327	Ia??u
6235	327	Ibiquera
6236	327	Itaberaba
6237	327	Lajedinho
6238	327	Macajuba
6239	327	Mairi
6240	327	Mundo Novo
6241	327	Ruy Barbosa
6242	327	Tapiramut??
6243	327	V??rzea da Ro??a
6244	327	Ca??m
6245	327	Caldeir??o Grande
6246	327	Capim Grosso
6247	327	Jacobina
6248	327	Miguel Calmon
6249	327	Mirangaba
6250	327	Morro do Chap??u
6251	327	Ourol??ndia
6252	327	Piritiba
6253	327	Ponto Novo
6254	327	Quixabeira
6255	327	S??o Jos?? do Jacu??pe
6256	327	Sa??de
6257	327	Serrol??ndia
6258	327	V??rzea do Po??o
6259	327	V??rzea Nova
6260	327	Andorinha
6261	327	Ant??nio Gon??alves
6262	327	Campo Formoso
6263	327	Filad??lfia
6264	327	Iti??ba
6265	327	Jaguarari
6266	327	Pindoba??u
6267	327	Senhor do Bonfim
6268	327	Umburanas
6269	327	Boquira
6270	327	Botupor??
6271	327	Brotas de Maca??bas
6272	327	Caturama
6273	327	Ibipitanga
6274	327	Ibitiara
6275	327	Ipupiara
6276	327	Maca??bas
6277	327	Novo Horizonte
6278	327	Oliveira dos Brejinhos
6279	327	Tanque Novo
6280	327	Aracatu
6281	327	Brumado
6282	327	Cara??bas
6283	327	Conde??ba
6284	327	Cordeiros
6285	327	Guajeru
6286	327	Itua??u
6287	327	Maetinga
6288	327	Malhada de Pedras
6289	327	Pirip??
6290	327	Presidente J??nio Quadros
6291	327	Rio do Ant??nio
6292	327	Tanha??u
6293	327	Tremedal
6294	327	Cacul??
6295	327	Caetit??
6296	327	Candiba
6297	327	Guanambi
6298	327	Ibiassuc??
6299	327	Igapor??
6300	327	Iui??
6301	327	Jacaraci
6302	327	Lagoa Real
6303	327	Lic??nio de Almeida
6304	327	Malhada
6305	327	Matina
6306	327	Mortugaba
6307	327	Palmas de Monte Alto
6308	327	Pinda??
6309	327	Riacho de Santana
6310	327	Sebasti??o Laranjeiras
6311	327	Urandi
6312	327	Encruzilhada
6313	327	Itamb??
6314	327	Itapetinga
6315	327	Itarantim
6316	327	Itoror??
6317	327	Macarani
6318	327	Maiquinique
6319	327	Potiragu??
6320	327	Ribeir??o do Largo
6321	327	Aiquara
6322	327	Amargosa
6323	327	Apuarema
6324	327	Brej??es
6325	327	Cravol??ndia
6326	327	Irajuba
6327	327	Iramaia
6328	327	Itagi
6329	327	Itaquara
6330	327	Itiru??u
6331	327	Jaguaquara
6332	327	Jequi??
6333	327	Jiquiri????
6334	327	Jita??na
6335	327	Lafaiete Coutinho
6336	327	Laje
6337	327	Lajedo do Tabocal
6338	327	Marac??s
6339	327	Marcion??lio Souza
6340	327	Milagres
6341	327	Mutu??pe
6342	327	Nova Itarana
6343	327	Planaltino
6344	327	Santa In??s
6345	327	S??o Miguel das Matas
6346	327	Uba??ra
6347	327	Dom Bas??lio
6348	327	??rico Cardoso
6349	327	Livramento de Nossa Senhora
6350	327	Paramirim
6351	327	Rio do Pires
6352	327	Aba??ra
6353	327	Andara??
6354	327	Barra da Estiva
6355	327	Boninal
6356	327	Bonito
6357	327	Contendas do Sincor??
6358	327	Ibicoara
6359	327	Itaet??
6360	327	Jussiape
6361	327	Len????is
6362	327	Mucug??
6363	327	Nova Reden????o
6364	327	Palmeiras
6365	327	Piat??
6366	327	Rio de Contas
6367	327	Seabra
6368	327	Utinga
6369	327	Wagner
6370	327	Anag??
6371	327	Barra do Cho??a
6372	327	Belo Campo
6373	327	Boa Nova
6374	327	Bom Jesus da Serra
6375	327	Caatiba
6376	327	Caetanos
6377	327	C??ndido Sales
6378	327	D??rio Meira
6379	327	Ibicu??
6380	327	Igua??
6381	327	Manoel Vitorino
6382	327	Mirante
6383	327	Nova Cana??
6384	327	Planalto
6385	327	Po????es
6386	327	Vit??ria da Conquista
6387	327	Baian??polis
6388	327	Barreiras
6389	327	Catol??ndia
6390	327	Formosa do Rio Preto
6391	327	Lu??s Eduardo Magalh??es
6392	327	Riach??o das Neves
6393	327	S??o Desid??rio
6394	327	Angical
6395	327	Brejol??ndia
6396	327	Cotegipe
6397	327	Crist??polis
6398	327	Mansid??o
6399	327	Santa Rita de C??ssia
6400	327	Tabocas do Brejo Velho
6401	327	Wanderley
6402	327	Can??polis
6403	327	Cocos
6404	327	Coribe
6405	327	Correntina
6406	327	Jaborandi
6407	327	Santa Maria da Vit??ria
6408	327	S??o F??lix do Coribe
6409	327	Serra Dourada
6410	327	Catu
6411	327	Concei????o do Jacu??pe
6412	327	Itanagra
6413	327	Mata de S??o Jo??o
6414	327	Pojuca
6415	327	S??o Sebasti??o do Pass??
6416	327	Terra Nova
6417	327	Cama??ari
6418	327	Candeias
6419	327	Dias d'??vila
6420	327	Itaparica
6421	327	Lauro de Freitas
6422	327	Madre de Deus
6423	327	Salvador??(capital estatal)
6424	327	S??o Francisco do Conde
6425	327	Sim??es Filho
6426	327	Vera Cruz
6427	327	Aratu??pe
6428	327	Cabaceiras do Paragua??u
6429	327	Cachoeira
6430	327	Castro Alves
6431	327	Concei????o do Almeida
6432	327	Cruz das Almas
6433	327	Dom Macedo Costa
6434	327	Governador Mangabeira
6435	327	Jaguaripe
6436	327	Maragogipe
6437	327	Muniz Ferreira
6438	327	Muritiba
6439	327	Nazar??
6440	327	Salinas da Margarida
6441	327	Santo Amaro
6442	327	Santo Ant??nio de Jesus
6443	327	S??o Felipe
6444	327	S??o F??lix
6445	327	Sapea??u
6446	327	Saubara
6447	327	Varzedo
6448	327	Acajutiba
6449	327	Alagoinhas
6450	327	Apor??
6451	327	Ara??as
6452	327	Aramari
6453	327	Barrocas
6454	327	Cris??polis
6455	327	Inhambupe
6456	327	Rio Real
6457	327	S??tiro Dias
6458	327	Cardeal da Silva
6459	327	Conde
6460	327	Entre Rios
6461	327	Esplanada
6462	327	Janda??ra
6463	327	Cansan????o
6464	327	Canudos
6465	327	Euclides da Cunha
6466	327	Monte Santo
6467	327	Nordestina
6468	327	Queimadas
6469	327	Quijingue
6470	327	Tucano
6471	327	Uau??
6472	327	Coronel Jo??o S??
6473	327	Jeremoabo
6474	327	Pedro Alexandre
6475	327	Santa Br??gida
6476	327	S??tio do Quinto
6477	327	Adustina
6478	327	Antas
6479	327	Banza??
6480	327	C??cero Dantas
6481	327	Cip??
6482	327	F??tima
6483	327	Heli??polis
6484	327	Itapicuru
6485	327	Nova Soure
6486	327	Novo Triunfo
6487	327	Olindina
6488	327	Paripiranga
6489	327	Ribeira do Amparo
6490	327	Ribeira do Pombal
6491	327	Araci
6492	327	Biritinga
6493	327	Candeal
6494	327	Capela do Alto Alegre
6495	327	Concei????o do Coit??
6496	327	Gavi??o
6497	327	Ichu
6498	327	Lamar??o
6499	327	Nova F??tima
6500	327	P?? de Serra
6501	327	Retirol??ndia
6502	327	Riach??o do Jacu??pe
6503	327	Santaluz
6504	327	S??o Domingos
6505	327	Serrinha
6506	327	Teofil??ndia
6507	327	Valente
6508	327	Almadina
6509	327	Arataca
6510	327	Aurelino Leal
6511	327	Barra do Rocha
6512	327	Belmonte
6513	327	Buerarema
6514	327	Camacan
6515	327	Canavieiras
6516	327	Coaraci
6517	327	Firmino Alves
6518	327	Floresta Azul
6519	327	Gandu
6520	327	Gongogi
6521	327	Governador Lomanto J??nior
6522	327	Ibicara??
6523	327	Ibirapitanga
6524	327	Ibirataia
6525	327	Ilh??us
6526	327	Ipia??
6527	327	Itabuna
6528	327	Itacar??
6529	327	Itagib??
6530	327	Itaju do Col??nia
6531	327	Itaju??pe
6532	327	Itamari
6533	327	Itap??
6534	327	Itapebi
6535	327	Itapitanga
6536	327	Jussari
6537	327	Mascote
6538	327	Nova Ibi??
6539	327	Pau Brasil
6540	327	Santa Cruz da Vit??ria
6541	327	Santa Luzia
6542	327	S??o Jos?? da Vit??ria
6543	327	Teol??ndia
6544	327	Ubaitaba
6545	327	Ubat??
6546	327	Una
6547	327	Uru??uca
6548	327	Wenceslau Guimar??es
6549	327	Alcoba??a
6550	327	Caravelas
6551	327	Eun??polis
6552	327	Guaratinga
6553	327	Ibirapu??
6554	327	Itabela
6555	327	Itagimirim
6556	327	Itamaraju
6557	327	Itanh??m
6558	327	Jucuru??u
6559	327	Lajed??o
6560	327	Medeiros Neto
6561	327	Mucuri
6562	327	Nova Vi??osa
6563	327	Porto Seguro
6564	327	Prado
6565	327	Santa Cruz Cabr??lia
6566	327	Teixeira de Freitas
6567	327	Vereda
6568	327	Cairu
6569	327	Camamu
6570	327	Igrapi??na
6571	327	Ituber??
6572	327	Mara??
6573	327	Nilo Pe??anha
6574	327	Pira?? do Norte
6575	327	Presidente Tancredo Neves
6576	327	Tapero??
6577	327	Valen??a
6578	327	Barra
6579	327	Buritirama
6580	327	Ibotirama
6581	327	Itagua??u da Bahia
6582	327	Morpar??
6583	327	Muqu??m de S??o Francisco
6584	327	Xique-Xique
6585	327	Bom Jesus da Lapa
6586	327	Carinhanha
6587	327	Feira da Mata
6588	327	Paratinga
6589	327	Serra do Ramalho
6590	327	S??tio do Mato
6591	327	Campo Alegre de Lourdes
6592	327	Casa Nova
6593	327	Cura????
6594	327	Juazeiro
6595	327	Pil??o Arcado
6596	327	Remanso
6597	327	Sento S??
6598	327	Sobradinho
6599	327	Abar??
6600	327	Chorroch??
6601	327	Gl??ria
6602	327	Macurur??
6603	327	Paulo Afonso
6604	327	Rodelas
6605	328	Cedro
6606	328	Ic??
6607	328	Iguatu
6608	328	Or??s
6609	328	Quixel??
6610	328	Baixio
6611	328	Ipaumirim
6612	328	Lavras da Mangabeira
6613	328	Umari
6614	328	Antonina do Norte
6615	328	Cari??s
6616	328	Juc??s
6617	328	Tarrafas
6618	328	V??rzea Alegre
6619	328	Alto Santo
6620	328	Ibicuitinga
6621	328	Jaguaruana
6622	328	Limoeiro do Norte
6623	328	Morada Nova
6624	328	Palhano
6625	328	Quixer??
6626	328	Russas
6627	328	S??o Jo??o do Jaguaribe
6628	328	Tabuleiro do Norte
6629	328	Aracati
6630	328	Fortim
6631	328	Icapu??
6632	328	Itai??aba
6633	328	Jaguaretama
6634	328	Jaguaribara
6635	328	Jaguaribe
6636	328	Erer??
6637	328	Iracema
6638	328	Pereiro
6639	328	Potiretama
6640	328	Aquiraz
6641	328	Caucaia
6642	328	Eus??bio
6643	328	Fortaleza
6644	328	(capital estatal)
6645	328	Guai??ba
6646	328	Itaitinga
6647	328	Maracana??
6648	328	Maranguape
6649	328	Pacatuba
6650	328	Horizonte
6651	328	Pacaj??s
6652	328	Corea??
6653	328	Frecheirinha
6654	328	Mora??jo
6655	328	Uruoca
6656	328	Carnaubal
6657	328	Croat??
6658	328	Guaraciaba do Norte
6659	328	Ibiapina
6660	328	S??o Benedito
6661	328	Tiangu??
6662	328	Ubajara
6663	328	Vi??osa do Cear??
6664	328	Ip??
6665	328	Ipueiras
6666	328	Pires Ferreira
6667	328	Poranga
6668	328	Reriutaba
6669	328	Varjota
6670	328	Acara??
6671	328	Barroquinha
6672	328	Bela Cruz
6673	328	Camocim
6674	328	Chaval
6675	328	Cruz
6676	328	Granja
6677	328	Itarema
6678	328	Jijoca de Jericoacoara
6679	328	Marco
6680	328	Martin??pole
6681	328	Morrinhos
6682	328	Alc??ntaras
6683	328	Meruoca
6684	328	Catunda
6685	328	Hidrol??ndia
6686	328	Santa Quit??ria
6687	328	Carir??
6688	328	Forquilha
6689	328	Gra??a
6690	328	Groa??ras
6691	328	Irau??uba
6692	328	Massap??
6693	328	Mira??ma
6694	328	Mucambo
6695	328	Pacuj??
6696	328	Santana do Acara??
6697	328	Senador S??
6698	328	Sobral
6699	328	Paracuru
6700	328	Paraipaba
6701	328	S??o Gon??alo do Amarante
6702	328	Acarap??
6703	328	Ara??oiaba
6704	328	Aratuba
6705	328	Baturit??
6706	328	Capistrano
6707	328	Guaramiranga
6708	328	Itapi??na
6709	328	Mulungu
6710	328	Pacoti
6711	328	Palm??cia
6712	328	Reden????o
6713	328	Canind??
6714	328	Caridade
6715	328	Itatira
6716	328	Paramoti
6717	328	Beberibe
6718	328	Cascavel
6719	328	Pindoretama
6720	328	Barreira
6721	328	Chorozinho
6722	328	Ocara
6723	328	Amontada
6724	328	Itapipoca
6725	328	Trairi
6726	328	Apuiar??s
6727	328	General Sampaio
6728	328	Pentecoste
6729	328	S??o Lu??s do Curu
6730	328	Teju??uoca
6731	328	Itapag??
6732	328	Tururu
6733	328	Umirim
6734	328	Uruburetama
6735	328	Ararend??
6736	328	Crate??s
6737	328	Independ??ncia
6738	328	Ipaporanga
6739	328	Monsenhor Tabosa
6740	328	Nova Russas
6741	328	Novo Oriente
6742	328	Quiterian??polis
6743	328	Tamboril
6744	328	Aiuaba
6745	328	Arneiroz
6746	328	Catarina
6747	328	Parambu
6748	328	Saboeiro
6749	328	Tau??
6750	328	Banabui??
6751	328	Boa Viagem
6752	328	Chor??
6753	328	Ibaretama
6754	328	Madalena
6755	328	Quixad??
6756	328	Quixeramobim
6757	328	Acopiara
6758	328	Deputado Irapuan Pinheiro
6759	328	Milh??
6760	328	Momba??a
6761	328	Pedra Branca
6762	328	Piquet Carneiro
6763	328	Senador Pompeu
6764	328	Solon??pole
6765	328	Aurora
6766	328	Barro
6767	328	Mauriti
6768	328	Abaiara
6769	328	Brejo Santo
6770	328	Jati
6771	328	Penaforte
6772	328	Barbalha
6773	328	Crato
6774	328	Jardim
6775	328	Juazeiro do Norte
6776	328	Miss??o Velha
6777	328	Nova Olinda
6778	328	Porteiras
6779	328	Santana do Cariri
6780	328	Altaneira
6781	328	Cariria????
6782	328	Farias Brito
6783	328	Granjeiro
6784	328	Araripe
6785	328	Assar??
6786	328	Campos Sales
6787	328	Potengi
6788	328	Salitre
6789	329	Bras??lia
6790	329	Gama
6791	329	Taguatinga
6792	329	Brazl??ndia
6793	329	Planaltina
6794	329	Parano??
6795	329	N??cleo Bandeirante
6796	329	Ceil??ndia
6797	329	Guar??
6798	329	Cruzeiro
6799	329	Samambaia
6800	329	Santa Maria
6801	329	Recanto das Emas
6802	329	Lago Sul
6803	329	Riacho Fundo
6804	329	Lago Norte
6805	329	Candangol??ndia
6806	329	??guas Claras
6807	329	Riacho Fundo II
6808	329	Sudoeste/Octogonal
6809	329	Varj??o
6810	329	Park Way
6811	329	SCIA
6812	329	Sobradinho II
6813	329	Jardim Bot??nico
6814	329	Itapo??
6815	329	SIA
6816	329	Vicente Pires
6817	329	Fercal
6818	330	Afonso Cl??udio
6819	330	Brejetuba
6820	330	Concei????o do Castelo
6821	330	Domingos Martins
6822	330	Laranja da Terra
6823	330	Marechal Floriano
6824	330	Venda Nova do Imigrante
6825	330	Alfredo Chaves
6826	330	Anchieta
6827	330	Guarapari
6828	330	Iconha
6829	330	Pi??ma
6830	330	Rio Novo do Sul
6831	330	Itagua??u
6832	330	Itarana
6833	330	Santa Leopoldina
6834	330	Santa Maria do Jetib??
6835	330	Santa Teresa
6836	330	S??o Roque do Cana??
6837	330	Cariacica
6838	330	Serra
6839	330	Viana
6840	330	Vila Velha
6841	330	Vit??ria??(State Capital)
6842	330	Aracruz
6843	330	Fund??o
6844	330	Ibira??u
6845	330	Jo??o Neiva
6846	330	Linhares
6847	330	Rio Bananal
6848	330	Sooretama
6849	330	Montanha
6850	330	Mucurici
6851	330	Pinheiros
6852	330	Ponto Belo
6853	330	Concei????o da Barra
6854	330	Jaguar??
6855	330	Pedro Can??rio
6856	330	S??o Mateus
6857	330	??gua Doce do Norte
6858	330	Barra de S??o Francisco
6859	330	Ecoporanga
6860	330	Manten??polis
6861	330	Alto Rio Novo
6862	330	Baixo Guandu
6863	330	Colatina
6864	330	Governador Lindenberg
6865	330	Maril??ndia
6866	330	Pancas
6867	330	S??o Domingos do Norte
6868	330	??guia Branca
6869	330	Boa Esperan??a
6870	330	Nova Ven??cia
6871	330	S??o Gabriel da Palha
6872	330	Vila Pav??o
6873	330	Vila Val??rio
6874	330	Alegre
6875	330	Divino de S??o Louren??o
6876	330	Dores do Rio Preto
6877	330	Gua??u??
6878	330	Ibatiba
6879	330	Ibitirama
6880	330	Irupi
6881	330	I??na
6882	330	Muniz Freire
6883	330	Apiac??
6884	330	Atilio Vivacqua
6885	330	Bom Jesus do Norte
6886	330	Cachoeiro de Itapemirim
6887	330	Castelo
6888	330	Jer??nimo Monteiro
6889	330	Mimoso do Sul
6890	330	Muqui
6891	330	S??o Jos?? do Cal??ado
6892	330	Vargem Alta
6893	330	Itapemirim
6894	330	Marata??zes
6895	330	Presidente Kennedy
6896	331	An??polis
6897	331	Ara??u
6898	331	Brazabrantes
6899	331	Campo Limpo de Goi??s
6900	331	Catura??
6901	331	Damol??ndia
6902	331	Heitora??
6903	331	Inhumas
6904	331	Itabera??
6905	331	Itaguari
6906	331	Itaguaru
6907	331	Itau??u
6908	331	Jaragu??
6909	331	Jes??polis
6910	331	Nova Veneza
6911	331	Ouro Verde de Goi??s
6912	331	Petrolina de Goi??s
6913	331	Santa Rosa de Goi??s
6914	331	S??o Francisco de Goi??s
6915	331	Taquaral de Goi??s
6916	331	Adel??ndia
6917	331	Americano do Brasil
6918	331	Anicuns
6919	331	Auril??ndia
6920	331	Avelin??polis
6921	331	Buriti de Goi??s
6922	331	Firmin??polis
6923	331	Moss??medes
6924	331	Naz??rio
6925	331	Sanclerl??ndia
6926	331	Santa B??rbara de Goi??s
6927	331	S??o Lu??s de Montes Belos
6928	331	Turv??nia
6929	331	Carmo do Rio Verde
6930	331	Ceres
6931	331	Goian??sia
6932	331	Guara??ta
6933	331	Guarinos
6934	331	Hidrolina
6935	331	Ipiranga de Goi??s
6936	331	Itapaci
6937	331	Itapuranga
6938	331	Morro Agudo de Goi??s
6939	331	Nova Am??rica
6940	331	Nova Gl??ria
6941	331	Pilar de Goi??s
6942	331	Rialma
6943	331	Rian??polis
6944	331	Rubiataba
6945	331	Santa Isabel
6946	331	Santa Rita do Novo Destino
6947	331	S??o Lu??z do Norte
6948	331	S??o Patr??cio
6949	331	Uruana
6950	331	Abadia de Goi??s
6951	331	Aparecida de Goi??nia
6952	331	Aragoi??nia
6953	331	Bela Vista de Goi??s
6954	331	Bonfin??polis
6955	331	Caldazinha
6956	331	Goian??polis
6957	331	Goi??nia
6958	331	Goianira
6959	331	Guap??
6960	331	Leopoldo de Bulh??es
6961	331	Ner??polis
6962	331	Santo Ant??nio de Goi??s
6963	331	Senador Canedo
6964	331	Terez??polis de Goi??s
6965	331	Trindade
6966	331	Amorin??polis
6967	331	Cachoeira de Goi??s
6968	331	C??rrego do Ouro
6969	331	Fazenda Nova
6970	331	Ipor??
6971	331	Israel??ndia
6972	331	Ivol??ndia
6973	331	Jaupaci
6974	331	Moipor??
6975	331	Novo Brasil
6976	331	Abadi??nia
6977	331	??gua Fria de Goi??s
6978	331	??guas Lindas de Goi??s
6979	331	Alex??nia
6980	331	Cabeceiras
6981	331	Cidade Ocidental
6982	331	Cocalzinho de Goi??s
6983	331	Corumb?? de Goi??s
6984	331	Cristalina
6985	331	Formosa
6986	331	Luzi??nia
6987	331	Mimoso de Goi??s
6988	331	Novo Gama
6989	331	Padre Bernardo
6990	331	Piren??polis
6991	331	Santo Ant??nio do Descoberto
6992	331	Valpara??so de Goi??s
6993	331	Vila Boa
6994	331	Vila Prop??cio
6995	331	Alvorada do Norte
6996	331	Buritin??polis
6997	331	Damian??polis
6998	331	Divin??polis de Goi??s
6999	331	Flores de Goi??s
7000	331	Guarani de Goi??s
7001	331	Iaciara
7002	331	Mamba??
7003	331	Posse
7004	331	Simol??ndia
7005	331	S??tio d'Abadia
7006	331	Aragar??as
7007	331	Aren??polis
7008	331	Baliza
7009	331	Bom Jardim de Goi??s
7010	331	Diorama
7011	331	Montes Claros de Goi??s
7012	331	Araguapaz
7013	331	Aruan??
7014	331	Brit??nia
7015	331	Faina
7016	331	Goi??s
7017	331	Itapirapu??
7018	331	Matrinch??
7019	331	Santa F?? de Goi??s
7020	331	Crix??s
7021	331	Mozarl??ndia
7022	331	Nova Crix??s
7023	331	Novo Planalto
7024	331	S??o Miguel do Araguaia
7025	331	Uirapuru
7026	331	Alto Para??so de Goi??s
7027	331	Campos Belos
7028	331	Cavalcante
7029	331	Colinas do Sul
7030	331	Monte Alegre de Goi??s
7031	331	Nova Roma
7032	331	S??o Jo??o d'Alian??a
7033	331	Teresina de Goi??s
7034	331	Alto Horizonte
7035	331	Amaralina
7036	331	Bon??polis
7037	331	Campina??u
7038	331	Campinorte
7039	331	Campos Verdes
7040	331	Estrela do Norte
7041	331	Formoso
7042	331	Mara Rosa
7043	331	Mina??u
7044	331	Montividiu do Norte
7045	331	Mutun??polis
7046	331	Niquel??ndia
7047	331	Nova Igua??u de Goi??s
7048	331	Porangatu
7049	331	Santa Tereza de Goi??s
7050	331	Santa Terezinha de Goi??s
7051	331	Trombas
7052	331	Urua??u
7053	331	Anhanguera
7054	331	Campo Alegre de Goi??s
7055	331	Catal??o
7056	331	Corumba??ba
7057	331	Cumari
7058	331	Davin??polis
7059	331	Goiandira
7060	331	Ipameri
7061	331	Nova Aurora
7062	331	Ouvidor
7063	331	Tr??s Ranchos
7064	331	??gua Limpa
7065	331	Alo??ndia
7066	331	Bom Jesus de Goi??s
7067	331	Buriti Alegre
7068	331	Cachoeira Dourada
7069	331	Caldas Novas
7070	331	Crom??nia
7071	331	Goiatuba
7072	331	Inaciol??ndia
7073	331	Itumbiara
7074	331	Jovi??nia
7075	331	Mairipotaba
7076	331	Marzag??o
7077	331	Panam??
7078	331	Piracanjuba
7079	331	Pontalina
7080	331	Porteir??o
7081	331	Professor Jamil
7082	331	Rio Quente
7083	331	Vicentin??polis
7084	331	Cristian??polis
7085	331	Gameleira de Goi??s
7086	331	Orizona
7087	331	Palmelo
7088	331	Pires do Rio
7089	331	Santa Cruz de Goi??s
7090	331	S??o Miguel do Passa Quatro
7091	331	Silv??nia
7092	331	Uruta??
7093	331	Vian??polis
7094	331	Cachoeira Alta
7095	331	Ca??u
7096	331	Gouvel??ndia
7097	331	Itaj??
7098	331	Itarum??
7099	331	Lagoa Santa
7100	331	Paranaiguara
7101	331	Quirin??polis
7102	331	S??o Sim??o
7103	331	Aparecida do Rio Doce
7104	331	Apor??
7105	331	Caiap??nia
7106	331	Castel??ndia
7107	331	Chapad??o do C??u
7108	331	Doverl??ndia
7109	331	Jata??
7110	331	Mauril??ndia
7111	331	Mineiros
7112	331	Montividiu
7113	331	Palestina de Goi??s
7114	331	Perol??ndia
7115	331	Portel??ndia
7116	331	Rio Verde
7117	331	Santa Helena de Goi??s
7118	331	Santa Rita do Araguaia
7119	331	Santo Ant??nio da Barra
7120	331	Serran??polis
7121	331	Acre??na
7122	331	Campestre de Goi??s
7123	331	Cezarina
7124	331	Edealina
7125	331	Ed??ia
7126	331	Indiara
7127	331	Jandaia
7128	331	Palmeiras de Goi??s
7129	331	Palmin??polis
7130	331	Para??na
7131	331	S??o Jo??o da Para??na
7132	331	Turvel??ndia
7133	332	Arame
7134	332	Barra do Corda
7135	332	Fernando Falc??o
7136	332	Formosa da Serra Negra
7137	332	Graja??
7138	332	Itaipava do Graja??
7139	332	Jenipapo dos Vieiras
7140	332	Josel??ndia
7141	332	Santa Filomena do Maranh??o
7142	332	S??tio Novo
7143	332	Tuntum
7144	332	Bacabal
7145	332	Bernardo do Mearim
7146	332	Bom Lugar
7147	332	Esperantin??polis
7148	332	Igarap?? Grande
7149	332	Lago do Junco
7150	332	Lago dos Rodrigues
7151	332	Lago Verde
7152	332	Lima Campos
7153	332	Olho d'??gua das Cunh??s
7154	332	Pedreiras
7155	332	Pio XII
7156	332	Po????o de Pedras
7157	332	Santo Ant??nio dos Lopes
7158	332	S??o Lu??s Gonzaga do Maranh??o
7159	332	S??o Mateus do Maranh??o
7160	332	S??o Raimundo do Doca Bezerra
7161	332	S??o Roberto
7162	332	Satubinha
7163	332	Trizidela do Vale
7164	332	Dom Pedro
7165	332	Fortuna
7166	332	Gon??alves Dias
7167	332	Governador Archer
7168	332	Governador Eug??nio Barros
7169	332	Governador Luiz Rocha
7170	332	Gra??a Aranha
7171	332	Senador Alexandre Costa
7172	332	S??o Domingos do Maranh??o
7173	332	S??o Jos?? dos Bas??lios
7174	332	??gua Doce do Maranh??o
7175	332	Araioses
7176	332	Magalh??es de Almeida
7177	332	Santa Quit??ria do Maranh??o
7178	332	Santana do Maranh??o
7179	332	S??o Bernardo
7180	332	Buriti Bravo
7181	332	Caxias
7182	332	Mat??es
7183	332	Parnarama
7184	332	S??o Jo??o do Soter
7185	332	Timon
7186	332	Bar??o de Graja??
7187	332	Colinas
7188	332	Jatob??
7189	332	Lagoa do Mato
7190	332	Mirador
7191	332	Nova Iorque
7192	332	Paraibano
7193	332	Passagem Franca
7194	332	Pastos Bons
7195	332	S??o Francisco do Maranh??o
7196	332	S??o Jo??o dos Patos
7197	332	Sucupira do Norte
7198	332	Sucupira do Riach??o
7199	332	Anapurus
7200	332	Bel??gua
7201	332	Brejo
7202	332	Buriti
7203	332	Chapadinha
7204	332	Mata Roma
7205	332	Milagres do Maranh??o
7206	332	S??o Benedito do Rio Preto
7207	332	Urbano Santos
7208	332	Alto Alegre do Maranh??o
7209	332	Capinzal do Norte
7210	332	Cod??
7211	332	Coroat??
7212	332	Peritor??
7213	332	Timbiras
7214	332	Afonso Cunha
7215	332	Aldeias Altas
7216	332	Coelho Neto
7217	332	Duque Bacelar
7218	332	Pa??o do Lumiar
7219	332	Raposa (Maranh??o)
7220	332	S??o Jos?? de Ribamar
7221	332	S??o Lu??s
7222	332	Anajatuba
7223	332	Arari
7224	332	Bela Vista do Maranh??o
7225	332	Cajari
7226	332	Concei????o do Lago-A??u
7227	332	Igarap?? do Meio
7228	332	Matinha
7229	332	Mon????o
7230	332	Olinda Nova do Maranh??o
7231	332	Palmeir??ndia
7232	332	Pedro do Ros??rio
7233	332	Penalva
7234	332	Peri Mirim
7235	332	Pinheiro
7236	332	Presidente Sarney
7237	332	Santa Helena
7238	332	S??o Bento
7239	332	S??o Jo??o Batista
7240	332	S??o Vicente Ferrer
7241	332	Vit??ria do Mearim
7242	332	Cantanhede
7243	332	Itapecuru Mirim
7244	332	Mat??es do Norte
7245	332	Miranda do Norte
7246	332	Nina Rodrigues
7247	332	Pirapemas
7248	332	Presidente Vargas
7249	332	Vargem Grande
7250	332	Barreirinhas
7251	332	Humberto de Campos
7252	332	Paulino Neves
7253	332	Primeira Cruz
7254	332	Santo Amaro do Maranh??o
7255	332	Tut??ia
7256	332	Alc??ntara
7257	332	Apicum-A??u
7258	332	Bacuri
7259	332	Bacurituba
7260	332	Bequim??o
7261	332	Cajapi??
7262	332	Cedral
7263	332	Central do Maranh??o
7264	332	Cururupu
7265	332	Guimar??es
7266	332	Mirinzal
7267	332	Porto Rico do Maranh??o
7268	332	Serrano do Maranh??o
7269	332	Axix??
7270	332	Bacabeira
7271	332	Cachoeira Grande
7272	332	Icatu
7273	332	Morros
7274	332	Presidente Juscelino
7275	332	Ros??rio
7276	332	Santa Rita
7277	332	Amap?? do Maranh??o
7278	332	Boa Vista do Gurupi
7279	332	C??ndido Mendes
7280	332	Carutapera
7281	332	Centro do Guilherme
7282	332	Centro Novo do Maranh??o
7283	332	Godofredo Viana
7284	332	Governador Nunes Freire
7285	332	Junco do Maranh??o
7286	332	Lu??s Domingues
7287	332	Maraca??um??
7288	332	Maranh??ozinho
7289	332	Turia??u
7290	332	Turil??ndia
7291	332	A??ail??ndia
7292	332	Amarante do Maranh??o
7293	332	Buritirana
7294	332	Cidel??ndia
7295	332	Governador Edison Lob??o
7296	332	Imperatriz
7297	332	Itinga do Maranh??o
7298	332	Jo??o Lisboa
7299	332	Lajeado Novo
7300	332	Montes Altos
7301	332	Ribamar Fiquene
7302	332	S??o Francisco do Brej??o
7303	332	S??o Pedro da ??gua Branca
7304	332	Senador La Rocque
7305	332	Vila Nova dos Mart??rios
7306	332	Altamira do Maranh??o
7307	332	Alto Alegre do Pindar??
7308	332	Araguan??
7309	332	Bom Jardim
7310	332	Bom Jesus das Selvas
7311	332	Brejo de Areia
7312	332	Buriticupu
7313	332	Governador Newton Bello
7314	332	Lagoa Grande do Maranh??o
7315	332	Lago da Pedra
7316	332	Maraj?? do Sena
7317	332	Nova Olinda do Maranh??o
7318	332	Paulo Ramos
7319	332	Pindar??-Mirim
7320	332	Presidente M??dici
7321	332	Santa Luzia do Paru??
7322	332	S??o Jo??o do Car??
7323	332	Tufil??ndia
7324	332	Vitorino Freire
7325	332	Z?? Doca
7326	332	Benedito Leite
7327	332	Fortaleza dos Nogueiras
7328	332	Loreto
7329	332	Nova Colinas
7330	332	Samba??ba
7331	332	S??o Domingos do Azeit??o
7332	332	S??o F??lix de Balsas
7333	332	S??o Raimundo das Mangabeiras
7334	332	Alto Parna??ba
7335	332	Balsas
7336	332	Feira Nova do Maranh??o
7337	332	Riach??o
7338	332	Tasso Fragoso
7339	332	Campestre do Maranh??o
7340	332	Carolina
7341	332	Estreito
7342	332	Porto Franco
7343	332	S??o Jo??o do Para??so
7344	332	S??o Pedro dos Crentes
7345	333	Acorizal
7346	333	??gua Boa
7347	333	Alta Floresta
7348	333	Alto Araguaia
7349	333	Alto da Boa Vista
7350	333	Alto Gar??as
7351	333	Alto Paraguai
7352	333	Alto Taquari
7353	333	Apiac??s
7354	333	Araguaiana
7355	333	Araguainha
7356	333	Araputanga
7357	333	Aren??polis
7358	333	Aripuan??
7359	333	Bar??o de Melga??o
7360	333	Barra do Bugres
7361	333	Barra do Gar??as
7362	333	Bom Jesus do Araguaia
7363	333	Brasnorte
7364	333	C??ceres
7365	333	Campin??polis
7366	333	Campo Novo do Parecis
7367	333	Campo Verde
7368	333	Campos de J??lio
7369	333	Canabrava do Norte
7370	333	Carlinda
7371	333	Castanheira
7372	333	Chapada dos Guimar??es
7373	333	Cl??udia
7374	333	Cocalinho
7375	333	Col??der
7376	333	Colniza
7377	333	Comodoro
7378	333	Confresa
7379	333	Conquista d'Oeste
7380	333	Cotrigua??u
7381	333	Cuiab??
7382	333	Curvel??ndia
7383	333	Denise
7384	333	Diamantino
7385	333	Dom Aquino
7386	333	Feliz Natal
7387	333	Figueir??polis d'Oeste
7388	333	Ga??cha do Norte
7389	333	General Carneiro
7390	333	Gl??ria d'Oeste
7391	333	Guarant?? do Norte
7392	333	Guiratinga
7393	333	Indiava??
7394	333	Ipiranga do Norte
7395	333	Itanhang??
7396	333	Ita??ba
7397	333	Itiquira
7398	333	Jaciara
7399	333	Jangada
7400	333	Jauru
7401	333	Juara
7402	333	Ju??na
7403	333	Juruena
7404	333	Juscimeira
7405	333	Lambari d'Oeste
7406	333	Lucas do Rio Verde
7407	333	Luciara
7408	333	Marcel??ndia
7409	333	Matup??
7410	333	Mirassol d'Oeste
7411	333	Nobres
7412	333	Nortel??ndia
7413	333	Nossa Senhora do Livramento
7414	333	Nova Bandeirantes
7415	333	Nova Brasil??ndia
7416	333	Nova Cana?? do Norte
7417	333	Nova Fronteira
7418	333	Nova Guarita
7419	333	Nova Lacerda
7420	333	Nova Maril??ndia
7421	333	Nova Maring??
7422	333	Nova Monte Verde
7423	333	Nova Mutum
7424	333	Nova Nazar??
7425	333	Nova Ol??mpia
7426	333	Nova Santa Helena
7427	333	Nova Ubirat??
7428	333	Nova Xavantina
7429	333	Novo Horizonte do Norte
7430	333	Novo Mundo
7431	333	Novo Santo Ant??nio
7432	333	Novo S??o Joaquim
7433	333	Parana??ta
7434	333	Paranatinga
7435	333	Pedra Preta
7436	333	Peixoto de Azevedo
7437	333	Planalto da Serra
7438	333	Pocon??
7439	333	Pontal do Araguaia
7440	333	Ponte Branca
7441	333	Pontes e Lacerda
7442	333	Porto Alegre do Norte
7443	333	Porto dos Ga??chos
7444	333	Porto Esperidi??o
7445	333	Porto Estrela
7446	333	Poxor??u
7447	333	Primavera do Leste
7448	333	Quer??ncia
7449	333	Reserva do Caba??al
7450	333	Ribeir??o Cascalheira
7451	333	Ribeir??ozinho
7452	333	Rio Branco
7453	333	Rondol??ndia
7454	333	Rondon??polis
7455	333	Ros??rio Oeste
7456	333	Salto do C??u
7457	333	Santa Carmem
7458	333	Santa Cruz do Xingu
7459	333	Santa Rita do Trivelato
7460	333	Santa Terezinha
7461	333	Santo Afonso
7462	333	Santo Ant??nio do Leste
7463	333	Santo Ant??nio do Leverger
7464	333	S??o F??lix do Araguaia
7465	333	S??o Jos?? do Povo
7466	333	S??o Jos?? do Rio Claro
7467	333	S??o Jos?? do Xingu
7468	333	S??o Jos?? dos Quatro Marcos
7469	333	S??o Pedro da Cipa
7470	333	Sapezal
7471	333	Serra Nova Dourada
7472	333	Sinop
7473	333	Sorriso
7474	333	Tabapor??
7475	333	Tangar?? da Serra
7476	333	Tapurah
7477	333	Terra Nova do Norte
7478	333	Tesouro
7479	333	Torixor??u
7480	333	Uni??o do Sul
7481	333	Vale de S??o Domingos
7482	333	V??rzea Grande
7483	333	Vera
7484	333	Vila Bela da Sant??ssima Trindade
7485	333	Vila Rica
7486	334	??gua Clara
7487	334	Alcin??polis
7488	334	Amambai
7489	334	Anast??cio
7490	334	Anauril??ndia
7491	334	Ang??lica
7492	334	Ant??nio Jo??o
7493	334	Aparecida do Taboado
7494	334	Aquidauana
7495	334	Aral Moreira
7496	334	Bandeirantes
7497	334	Bataguassu
7498	334	Bataypor??
7499	334	Bela Vista
7500	334	Bodoquena
7501	334	Brasil??ndia
7502	334	Caarap??
7503	334	Camapu??
7504	334	Caracol
7505	334	Cassil??ndia
7506	334	Chapad??o do Sul
7507	334	Corguinho
7508	334	Coronel Sapucaia
7509	334	Corumb??
7510	334	Costa Rica
7511	334	Coxim
7512	334	Deod??polis
7513	334	Dois Irm??os do Buriti
7514	334	Douradina
7515	334	Dourados
7516	334	Eldorado
7517	334	F??tima do Sul
7518	334	Figueir??o
7519	334	Gl??ria de Dourados
7520	334	Guia Lopes da Laguna
7521	334	Iguatemi
7522	334	Inoc??ncia
7523	334	Itapor??
7524	334	Itaquira??
7525	334	Ivinhema
7526	334	Japor??
7527	334	Jaraguari
7528	334	Jate??
7529	334	Juti
7530	334	Lad??rio
7531	334	Laguna Carap??
7532	334	Maracaju
7533	334	Miranda
7534	334	Navira??
7535	334	Nioaque
7536	334	Nova Alvorada do Sul
7537	334	Nova Andradina
7538	334	Novo Horizonte do Sul
7539	334	Para??so das ??guas
7540	334	Parana??ba
7541	334	Paranhos
7542	334	Pedro Gomes
7543	334	Ponta Por??
7544	334	Porto Murtinho
7545	334	Ribas do Rio Pardo
7546	334	Rio Brilhante
7547	334	Rio Negro
7548	334	Rio Verde de Mato Grosso
7549	334	Rochedo
7550	334	Santa Rita do Pardo
7551	334	S??o Gabriel do Oeste
7552	334	Selv??ria
7553	334	Sete Quedas
7554	334	Sidrol??ndia
7555	334	Sonora
7556	334	Tacuru
7557	334	Taquarussu
7558	334	Terrenos
7559	334	Tr??s Lagoas
7560	334	Vicentina
7561	335	Alfredo Vasconcelos
7562	335	Ant??nio Carlos
7563	335	Barbacena
7564	335	Barroso
7565	335	Capela Nova
7566	335	Carana??ba
7567	335	Caranda??
7568	335	Desterro do Melo
7569	335	Ibertioga
7570	335	Ressaquinha
7571	335	Santa B??rbara do Tug??rio
7572	335	Senhora dos Rem??dios
7573	335	Carrancas
7574	335	Ijaci
7575	335	Inga??
7576	335	Itumirim
7577	335	Itutinga
7578	335	Lavras
7579	335	Lumin??rias
7580	335	Nepomuceno
7581	335	Ribeir??o Vermelho
7582	335	Concei????o da Barra de Minas
7583	335	Coronel Xavier Chaves
7584	335	Dores de Campos
7585	335	Lagoa Dourada
7586	335	Madre de Deus de Minas
7587	335	Nazareno
7588	335	Piedade do Rio Grande
7589	335	Prados
7590	335	Resende Costa
7591	335	Rit??polis
7592	335	Santa Cruz de Minas
7593	335	Santana do Garamb??u
7594	335	S??o Jo??o del Rei
7595	335	S??o Tiago
7596	335	Tiradentes
7597	335	Ara??jos
7598	335	Bom Despacho
7599	335	Dores do Indai??
7600	335	Estrela do Indai??
7601	335	Japara??ba
7602	335	Lagoa da Prata
7603	335	Leandro Ferreira
7604	335	Luz
7605	335	Martinho Campos
7606	335	Moema
7607	335	Quartel Geral
7608	335	Serra da Saudade
7609	335	Augusto de Lima
7610	335	Buen??polis
7611	335	Corinto
7612	335	Curvelo
7613	335	Felixl??ndia
7614	335	Inimutaba
7615	335	Joaquim Fel??cio
7616	335	Monjolos
7617	335	Morro da Gar??a
7618	335	Santo Hip??lito
7619	335	Abaet??
7620	335	Biquinhas
7621	335	Cedro do Abaet??
7622	335	Morada Nova de Minas
7623	335	Paineiras
7624	335	Pomp??u
7625	335	Tr??s Marias
7626	335	Almenara
7627	335	Bandeira
7628	335	Divis??polis
7629	335	Felisburgo
7630	335	Jacinto
7631	335	Jequitinhonha
7632	335	Joa??ma
7633	335	Jord??nia
7634	335	Mata Verde
7635	335	Monte Formoso
7636	335	Palm??polis
7637	335	Rio do Prado
7638	335	Rubim
7639	335	Salto da Divisa
7640	335	Santa Maria do Salto
7641	335	Santo Ant??nio do Jacinto
7642	335	Ara??ua??
7643	335	Cara??
7644	335	Coronel Murta
7645	335	Itinga
7646	335	Novo Cruzeiro
7647	335	Padre Para??so
7648	335	Ponto dos Volantes
7649	335	Virgem da Lapa
7650	335	Angel??ndia
7651	335	Aricanduva
7652	335	Berilo
7653	335	Capelinha
7654	335	Carbonita
7655	335	Chapada do Norte
7656	335	Francisco Badar??
7657	335	Itamarandiba
7658	335	Jenipapo de Minas
7659	335	Jos?? Gon??alves de Minas
7660	335	Leme do Prado
7661	335	Minas Novas
7662	335	Turmalina
7663	335	Veredinha
7664	335	Couto de Magalhaes de Minas
7665	335	Datas
7666	335	Diamantina
7667	335	Fel??cio dos Santos
7668	335	Gouveia
7669	335	Presidente Kubitschek
7670	335	S??o Gon??alo do Rio Preto
7671	335	Senador Modestino Gon??alves
7672	335	Cachoeira de Paje??
7673	335	Comercinho
7674	335	Itaobim
7675	335	Medina
7676	335	Pedra Azul
7677	335	Belo Horizonte
7678	335	(State Capital)
7679	335	Betim
7680	335	Brumadinho
7681	335	Caet??
7682	335	Confins
7683	335	Contagem
7684	335	Esmeraldas
7685	335	Ibirit??
7686	335	Igarap??
7687	335	Juatuba
7688	335	M??rio Campos
7689	335	Mateus Leme
7690	335	Nova Lima
7691	335	Pedro Leopoldo
7692	335	Raposos
7693	335	Ribeir??o das Neves
7694	335	Rio ??cima
7695	335	Sabar??
7696	335	S??o Joaquim de Bicas
7697	335	S??o Jos?? da Lapa
7698	335	Sarzedo
7699	335	Vespasiano
7700	335	Alvorada de Minas
7701	335	Concei????o do Mato Dentro
7702	335	Congonhas do Norte
7703	335	Dom Joaquim
7704	335	Itamb?? do Mato Dentro
7705	335	Morro do Pilar
7706	335	Passab??m
7707	335	Rio Vermelho
7708	335	Santo Ant??nio do Itamb??
7709	335	Santo Ant??nio do Rio Abaixo
7710	335	S??o Sebasti??o do Rio Preto
7711	335	Serra Azul de Minas
7712	335	Serro
7713	335	Casa Grande
7714	335	Catas Altas da Noruega
7715	335	Congonhas
7716	335	Conselheiro Lafaiete
7717	335	Cristiano Otoni
7718	335	Desterro de Entre Rios
7719	335	Entre Rios de Minas
7720	335	Itaverava
7721	335	Queluzito
7722	335	Santana dos Montes
7723	335	S??o Br??s do Sua??u??
7724	335	Alvin??polis
7725	335	Bar??o de Cocais
7726	335	Bela Vista de Minas
7727	335	Bom Jesus do Amparo
7728	335	Catas Altas
7729	335	Dion??sio
7730	335	Ferros
7731	335	Itabira
7732	335	Jo??o Monlevade
7733	335	Nova Era
7734	335	Nova Uni??o
7735	335	Rio Piracicaba
7736	335	Santa Maria de Itabira
7737	335	S??o Domingos do Prata
7738	335	S??o Gon??alo do Rio Abaixo
7739	335	S??o Jos?? do Goiabal
7740	335	Taquara??u de Minas
7741	335	Belo Vale
7742	335	Bonfim
7743	335	Crucil??ndia
7744	335	Itaguara
7745	335	Itatiaiu??u
7746	335	Jeceaba
7747	335	Moeda
7748	335	Piedade dos Gerais
7749	335	Rio Manso
7750	335	Diogo de Vasconcelos
7751	335	Itabirito
7752	335	Mariana
7753	335	Ouro Preto
7754	335	Florestal
7755	335	On??a de Pitangui
7756	335	Par?? de Minas
7757	335	Pitangui
7758	335	S??o Jos?? da Varginha
7759	335	Ara??a??
7760	335	Baldim
7761	335	Cachoeira da Prata
7762	335	Caetan??polis
7763	335	Capim Branco
7764	335	Cordisburgo
7765	335	Fortuna de Minas
7766	335	Funil??ndia
7767	335	Inha??ma
7768	335	Jaboticatubas
7769	335	Jequitib??
7770	335	Maravilhas
7771	335	Matozinhos
7772	335	Papagaios
7773	335	Paraopeba
7774	335	Pequi
7775	335	Prudente de Morais
7776	335	Santana de Pirapama
7777	335	Santana do Riacho
7778	335	Sete Lagoas
7779	335	Brasil??ndia de Minas
7780	335	Guarda-Mor
7781	335	Jo??o Pinheiro
7782	335	Lagamar
7783	335	Lagoa Grande
7784	335	Paracatu
7785	335	Presidente Oleg??rio
7786	335	S??o Gon??alo do Abaet??
7787	335	Varj??o de Minas
7788	335	Vazante
7789	335	Arinos
7790	335	Bonfin??polis de Minas
7791	335	Buritis
7792	335	Cabeceira Grande
7793	335	Dom Bosco
7794	335	Natal??ndia
7795	335	Una??
7796	335	Uruana de Minas
7797	335	Bocai??va
7798	335	Engenheiro Navarro
7799	335	Francisco Dumont
7800	335	Guaraciama
7801	335	Olhos-d'??gua
7802	335	Botumirim
7803	335	Crist??lia
7804	335	Gr??o Mogol
7805	335	Itacambira
7806	335	Josen??polis
7807	335	Padre Carvalho
7808	335	Catuti
7809	335	Espinosa
7810	335	Gameleiras
7811	335	Ja??ba
7812	335	Jana??ba
7813	335	Mamonas
7814	335	Mato Verde
7815	335	Monte Azul
7816	335	Nova Porteirinha
7817	335	Pai Pedro
7818	335	Porteirinha
7819	335	Riacho dos Machados
7820	335	Serran??polis de Minas
7821	335	Bonito de Minas
7822	335	Chapada Ga??cha
7823	335	C??nego Marinho
7824	335	Icara?? de Minas
7825	335	Itacarambi
7826	335	Janu??ria
7827	335	Juven??lia
7828	335	Manga
7829	335	Matias Cardoso
7830	335	Mirav??nia
7831	335	Montalv??nia
7832	335	Pedras de Maria da Cruz
7833	335	Pint??polis
7834	335	S??o Francisco
7835	335	S??o Jo??o das Miss??es
7836	335	Urucuia
7837	335	Bras??lia de Minas
7838	335	Campo Azul
7839	335	Capit??o En??as
7840	335	Claro dos Po????es
7841	335	Cora????o de Jesus
7842	335	Francisco S??
7843	335	Glaucil??ndia
7844	335	Ibiracatu
7845	335	Japonvar
7846	335	Juramento
7847	335	Lontra
7848	335	Luisl??ndia
7849	335	Mirabela
7850	335	Montes Claros
7851	335	Patis
7852	335	Ponto Chique
7853	335	S??o Jo??o da Lagoa
7854	335	S??o Jo??o da Ponte
7855	335	S??o Jo??o do Pacu??
7856	335	Uba??
7857	335	Varzel??ndia
7858	335	Verdel??ndia
7859	335	Buritizeiro
7860	335	Ibia??
7861	335	Jequita??
7862	335	Lagoa dos Patos
7863	335	Lassance
7864	335	Pirapora
7865	335	Riachinho
7866	335	Santa F?? de Minas
7867	335	S??o Rom??o
7868	335	V??rzea da Palma
7869	335	??guas Vermelhas
7870	335	Berizal
7871	335	Curral de Dentro
7872	335	Divisa Alegre
7873	335	Fruta de Leite
7874	335	Indaiabira
7875	335	Montezuma
7876	335	Ninheira
7877	335	Novorizonte
7878	335	Rio Pardo de Minas
7879	335	Rubelita
7880	335	Salinas
7881	335	Santa Cruz de Salinas
7882	335	Santo Ant??nio do Retiro
7883	335	Taiobeiras
7884	335	Vargem Grande do Rio Pardo
7885	335	Aguanil
7886	335	Campo Belo
7887	335	Cana Verde
7888	335	Cristais
7889	335	Perd??es
7890	335	Santana do Jacar??
7891	335	Carmo do Cajuru
7892	335	Cl??udio
7893	335	Concei????o do Par??
7894	335	Divin??polis
7895	335	Igaratinga
7896	335	Ita??na
7897	335	Nova Serrana
7898	335	Perdig??o
7899	335	Santo Ant??nio do Monte
7900	335	S??o Gon??alo do Par??
7901	335	S??o Sebasti??o do Oeste
7902	335	Arcos
7903	335	Camacho
7904	335	C??rrego Fundo
7905	335	Formiga
7906	335	Itapecerica
7907	335	Pains
7908	335	Pedra do Indai??
7909	335	Pimenta
7910	335	Bom Sucesso
7911	335	Carmo da Mata
7912	335	Carm??polis de Minas
7913	335	Ibituruna
7914	335	Oliveira
7915	335	Passa Tempo
7916	335	Piracema
7917	335	Santo Ant??nio do Amparo
7918	335	S??o Francisco de Paula
7919	335	Bambu??
7920	335	C??rrego Danta
7921	335	Dores??polis
7922	335	Iguatama
7923	335	Medeiros
7924	335	Piumhi
7925	335	S??o Roque de Minas
7926	335	Tapira??
7927	335	Vargem Bonita
7928	335	Alfenas
7929	335	Alterosa
7930	335	Areado
7931	335	Carmo do Rio Claro
7932	335	Carvalh??polis
7933	335	Concei????o da Aparecida
7934	335	Divisa Nova
7935	335	Fama
7936	335	Machado
7937	335	Paragua??u
7938	335	Po??o Fundo
7939	335	Serrania
7940	335	Aiuruoca
7941	335	Andrel??ndia
7942	335	Arantina
7943	335	Bocaina de Minas
7944	335	Bom Jardim de Minas
7945	335	Carvalhos
7946	335	Cruz??lia
7947	335	Liberdade
7948	335	Minduri
7949	335	Passa-Vinte
7950	335	S??o Vicente de Minas
7951	335	Seritinga
7952	335	Serranos
7953	335	Bras??polis
7954	335	Consola????o
7955	335	Cristina
7956	335	Delfim Moreira
7957	335	Dom Vi??oso
7958	335	Itajub??
7959	335	Maria da F??
7960	335	Marmel??polis
7961	335	Parais??polis
7962	335	Pirangu??u
7963	335	Piranguinho
7964	335	Virg??nia
7965	335	Wenceslau Braz
7966	335	Alpin??polis
7967	335	Bom Jesus da Penha
7968	335	Capetinga
7969	335	Capit??lio
7970	335	C??ssia
7971	335	Claraval
7972	335	Delfin??polis
7973	335	Fortaleza de Minas
7974	335	Ibiraci
7975	335	Ita?? de Minas
7976	335	Passos
7977	335	Prat??polis
7978	335	S??o Jo??o Batista do Gl??ria
7979	335	S??o Jos?? da Barra
7980	335	Albertina
7981	335	Andradas
7982	335	Bandeira do Sul
7983	335	Botelhos
7984	335	Caldas
7985	335	Ibiti??ra de Minas
7986	335	Inconfidentes
7987	335	Jacutinga
7988	335	Monte Si??o
7989	335	Ouro Fino
7990	335	Po??os de Caldas
7991	335	Santa Rita de Caldas
7992	335	Bom Repouso
7993	335	Borda da Mata
7994	335	Bueno Brand??o
7995	335	Camanducaia
7996	335	Cambu??
7997	335	Congonhal
7998	335	C??rrego do Bom Jesus
7999	335	Esp??rito Santo do Dourado
8000	335	Estiva
8001	335	Extrema
8002	335	Gon??alves
8003	335	Ipui??na
8004	335	Itapeva
8005	335	Munhoz
8006	335	Pouso Alegre
8007	335	Sapuca??-Mirim
8008	335	Senador Amaral
8009	335	Senador Jos?? Bento
8010	335	Tocos do Moji
8011	335	Toledo
8012	335	Cachoeira de Minas
8013	335	Carea??u
8014	335	Concei????o das Pedras
8015	335	Concei????o dos Ouros
8016	335	Cordisl??ndia
8017	335	Heliodora
8018	335	Nat??rcia
8019	335	Pedralva
8020	335	Santa Rita do Sapuca??
8021	335	S??o Gon??alo do Sapuca??
8022	335	S??o Jo??o da Mata
8023	335	S??o Jos?? do Alegre
8024	335	S??o Sebasti??o da Bela Vista
8025	335	Silvian??polis
8026	335	Turvol??ndia
8027	335	Alagoa
8028	335	Baependi
8029	335	Cambuquira
8030	335	Carmo de Minas
8031	335	Caxambu
8032	335	Concei????o do Rio Verde
8033	335	Itamonte
8034	335	Itanhandu
8035	335	Jesu??nia
8036	335	Lambari
8037	335	Ol??mpio Noronha
8038	335	Passa Quatro
8039	335	Pouso Alto
8040	335	S??o Louren??o
8041	335	S??o Sebasti??o do Rio Verde
8042	335	Soledade de Minas
8043	335	Arceburgo
8044	335	Cabo Verde
8045	335	Guaranesia
8046	335	Guaxup??
8047	335	Itamogi
8048	335	Jacu??
8049	335	Juruaia
8050	335	Monte Belo
8051	335	Monte Santo de Minas
8052	335	Muzambinho
8053	335	Nova Resende
8054	335	S??o Pedro da Uni??o
8055	335	S??o Sebasti??o do Para??so
8056	335	S??o Tom??s de Aquino
8057	335	Campanha
8058	335	Campo do Meio
8059	335	Campos Gerais
8060	335	Carmo da Cachoeira
8061	335	Coqueiral
8062	335	El??i Mendes
8063	335	Guap??
8064	335	Ilic??nea
8065	335	Monsenhor Paulo
8066	335	Santana da Vargem
8067	335	S??o Bento Abade
8068	335	S??o Thom?? das Letras
8069	335	Tr??s Cora????es
8070	335	Tr??s Pontas
8071	335	Varginha
8072	335	Arax??
8073	335	Campos Altos
8074	335	Ibi??
8075	335	Nova Ponte
8076	335	Pedrin??polis
8077	335	Perdizes
8078	335	Pratinha
8079	335	Sacramento
8080	335	Santa Juliana
8081	335	Tapira
8082	335	Campina Verde
8083	335	Carneirinho
8084	335	Comendador Gomes
8085	335	Fronteira
8086	335	Frutal
8087	335	Itapagipe
8088	335	Iturama
8089	335	Limeira do Oeste
8090	335	Pirajuba
8091	335	Planura
8092	335	S??o Francisco de Sales
8093	335	Uni??o de Minas
8094	335	Capin??polis
8095	335	Gurinhat??
8096	335	Ipia??u
8097	335	Ituiutaba
8098	335	Santa Vit??ria
8099	335	Arapu??
8100	335	Carmo do Parana??ba
8101	335	Guimar??nia
8102	335	Lagoa Formosa
8103	335	Matutina
8104	335	Patos de Minas
8105	335	Rio Parana??ba
8106	335	Santa Rosa da Serra
8107	335	Major Porto
8108	335	S??o Gotardo
8109	335	Tiros
8110	335	Abadia dos Dourados
8111	335	Coromandel
8112	335	Cruzeiro da Fortaleza
8113	335	Douradoquara
8114	335	Estrela do Sul
8115	335	Grupiara
8116	335	Ira?? de Minas
8117	335	Monte Carmelo
8118	335	Patroc??nio
8119	335	Romaria
8120	335	Serra do Salitre
8121	335	??gua Comprida
8122	335	Campo Florido
8123	335	Concei????o das Alagoas
8124	335	Conquista
8125	335	Delta
8126	335	Uberaba
8127	335	Ver??ssimo
8128	335	Araguari
8129	335	Arapor??
8130	335	Cascalho Rico
8131	335	Centralina
8132	335	Indian??polis
8133	335	Monte Alegre de Minas
8134	335	Prata
8135	335	Tupaciguara
8136	335	Uberl??ndia
8137	335	??guas Formosas
8138	335	Bert??polis
8139	335	Carlos Chagas
8140	335	Cris??lita
8141	335	Fronteira dos Vales
8142	335	Machacalis
8143	335	Nanuque
8144	335	Santa Helena de Minas
8145	335	Serra dos Aimor??s
8146	335	Umburatiba
8147	335	Atal??ia
8148	335	Catuji
8149	335	Francisc??polis
8150	335	Frei Gaspar
8151	335	Itaip??
8152	335	Ladainha
8153	335	Malacacheta
8154	335	Novo Oriente de Minas
8155	335	Ouro Verde de Minas
8156	335	Pav??o
8157	335	Pot??
8158	335	Setubinha
8159	335	Te??filo Otoni
8160	335	Aimor??s
8161	335	Alvarenga
8162	335	Concei????o de Ipanema
8163	335	Conselheiro Pena
8164	335	Cuparaque
8165	335	Goiabeira
8166	335	Ipanema
8167	335	Itueta
8168	335	Mutum
8169	335	Pocrane
8170	335	Resplendor
8171	335	Santa Rita do Itueto
8172	335	Taparuba
8173	335	Bom Jesus do Galho
8174	335	Bugre
8175	335	Caratinga
8176	335	C??rrego Novo
8177	335	Dom Cavati
8178	335	Entre Folhas
8179	335	Iapu
8180	335	Imb?? de Minas
8181	335	Inhapim
8182	335	Ipaba
8183	335	Piedade de Caratinga
8184	335	Pingo-d'??gua
8185	335	Santa B??rbara do Leste
8186	335	Santa Rita de Minas
8187	335	S??o Domingos das Dores
8188	335	S??o Jo??o do Oriente
8189	335	S??o Sebasti??o do Anta
8190	335	Tarumirim
8191	335	Ubaporanga
8192	335	Vargem Alegre
8193	335	Alpercata
8194	335	Campan??rio
8195	335	Capit??o Andrade
8196	335	Coroaci
8197	335	Divino das Laranjeiras
8198	335	Engenheiro Caldas
8199	335	Fernandes Tourinho
8200	335	Frei Inoc??ncio
8201	335	Galil??ia
8202	335	Governador Valadares
8203	335	Itambacuri
8204	335	Itanhomi
8205	335	Jampruca
8206	335	Marilac
8207	335	Mathias Lobato
8208	335	Nacip Raydan
8209	335	Nova M??dica
8210	335	Pescador
8211	335	S??o Geraldo da Piedade
8212	335	S??o Geraldo do Baixio
8213	335	S??o Jos?? da Safira
8214	335	S??o Jos?? do Divino
8215	335	Sobr??lia
8216	335	Tumiritinga
8217	335	Virgol??ndia
8218	335	Bra??nas
8219	335	Carm??sia
8220	335	Coluna
8221	335	Divinol??ndia de Minas
8222	335	Dores de Guanh??es
8223	335	Gonzaga
8224	335	Guanh??es
8225	335	Materl??ndia
8226	335	Paulistas
8227	335	Sabin??polis
8228	335	Santa Efig??nia de Minas
8229	335	S??o Jo??o Evangelista
8230	335	Sardo??
8231	335	Senhora do Porto
8232	335	Virgin??polis
8233	335	A??ucena
8234	335	Ant??nio Dias
8235	335	Belo Oriente
8236	335	Coronel Fabriciano
8237	335	Ipatinga
8238	335	Jaguara??u
8239	335	Joan??sia
8240	335	Marli??ria
8241	335	Mesquita
8242	335	Naque
8243	335	Periquito
8244	335	Santana do Para??so
8245	335	Tim??teo
8246	335	Central de Minas
8247	335	Itabirinha de Mantena
8248	335	Mantena
8249	335	Mendes Pimentel
8250	335	Nova Bel??m
8251	335	S??o F??lix de Minas
8252	335	S??o Jo??o do Manteninha
8253	335	Cantagalo
8254	335	Frei Lagonegro
8255	335	Jos?? Raydan
8256	335	Pe??anha
8257	335	Santa Maria do Sua??u??
8258	335	S??o Jos?? do Jacuri
8259	335	S??o Pedro do Sua??u??
8260	335	S??o Sebasti??o do Maranh??o
8261	335	Al??m Para??ba
8262	335	Argirita
8263	335	Cataguases
8264	335	Dona Eus??bia
8265	335	Estrela Dalva
8266	335	Itamarati de Minas
8267	335	Laranjal
8268	335	Leopoldina
8269	335	Palma
8270	335	Pirapetinga
8271	335	Recreio
8272	335	Santana de Cataguases
8273	335	Santo Ant??nio do Aventureiro
8274	335	Volta Grande
8275	335	Aracitaba
8276	335	Belmiro Braga
8277	335	Bias Fortes
8278	335	Bicas
8279	335	Ch??cara
8280	335	Chiador
8281	335	Coronel Pacheco
8282	335	Descoberto
8283	335	Ewbank da C??mara
8284	335	Goian??
8285	335	Guarar??
8286	335	Juiz de Fora
8287	335	Lima Duarte
8288	335	Mar de Espanha
8289	335	Marip?? de Minas
8290	335	Matias Barbosa
8291	335	Olaria
8292	335	Oliveira Fortes
8293	335	Paiva
8294	335	Pedro Teixeira
8295	335	Pequeri
8296	335	Piau
8297	335	Rio Novo
8298	335	Rio Preto
8299	335	Rochedo de Minas
8300	335	Santa B??rbara do Monte Verde
8301	335	Santa Rita de Ibitipoca
8302	335	Santa Rita de Jacutinga
8303	335	Santana do Deserto
8304	335	Santos Dumont
8305	335	S??o Jo??o Nepomuceno
8306	335	Senador Cortes
8307	335	Sim??o Pereira
8308	335	Abre Campo
8309	335	Alto Capara??
8310	335	Alto Jequitib??
8311	335	Capara??
8312	335	Caputira
8313	335	Chal??
8314	335	Durand??
8315	335	Lajinha
8316	335	Luisburgo
8317	335	Manhua??u
8318	335	Manhumirim
8319	335	Martins Soares
8320	335	Matip??
8321	335	Pedra Bonita
8322	335	Reduto
8323	335	Santa Margarida
8324	335	Santana do Manhua??u
8325	335	S??o Jo??o do Manhua??u
8326	335	S??o Jos?? do Mantimento
8327	335	Simon??sia
8328	335	Ant??nio Prado de Minas
8329	335	Bar??o de Monte Alto
8330	335	Caiana
8331	335	Carangola
8332	335	Divino
8333	335	Espera Feliz
8334	335	Eugen??polis
8335	335	Faria Lemos
8336	335	Fervedouro
8337	335	Miradouro
8338	335	Mira??
8339	335	Muria??
8340	335	Oriz??nia
8341	335	Patroc??nio do Muria??
8342	335	Pedra Dourada
8343	335	Ros??rio da Limeira
8344	335	S??o Francisco do Gl??ria
8345	335	S??o Sebasti??o da Vargem Alegre
8346	335	Tombos
8347	335	Vieiras
8348	335	Acaiaca
8349	335	Barra Longa
8350	335	Dom Silv??rio
8351	335	Guaraciaba
8352	335	Jequeri
8353	335	Orat??rios
8354	335	Piedade de Ponte Nova
8355	335	Ponte Nova
8356	335	Raul Soares
8357	335	Rio Casca
8358	335	Rio Doce
8359	335	Santa Cruz do Escalvado
8360	335	Santo Ant??nio do Grama
8361	335	S??o Pedro dos Ferros
8362	335	Sem-Peixe
8363	335	Sericita
8364	335	Uruc??nia
8365	335	Vermelho Novo
8366	335	Astolfo Dutra
8367	335	Divin??sia
8368	335	Dores do Turvo
8369	335	Guarani
8370	335	Guidoval
8371	335	Guiricema
8372	335	Merc??s
8373	335	Pira??ba
8374	335	Rio Pomba
8375	335	Rodeiro
8376	335	S??o Geraldo
8377	335	Senador Firmino
8378	335	Silveir??nia
8379	335	Tabuleiro
8380	335	Tocantins
8381	335	Ub??
8382	335	Visconde do Rio Branco
8383	335	Alto Rio Doce
8384	335	Amparo do Serra
8385	335	Araponga
8386	335	Br??s Pires
8387	335	Cajuri
8388	335	Cana??
8389	335	Cipot??nea
8390	335	Co??mbra
8391	335	Erv??lia
8392	335	Lamim
8393	335	Paula C??ndido
8394	335	Pedra do Anta
8395	335	Piranga
8396	335	Porto Firme
8397	335	Presidente Bernardes
8398	335	Rio Espera
8399	335	S??o Miguel do Anta
8400	335	Senhora de Oliveira
8401	335	Teixeiras
8402	336	Almeirim
8403	336	Porto de Moz
8404	336	Faro
8405	336	Juruti
8406	336	??bidos
8407	336	Oriximin??
8408	336	Terra Santa
8409	336	Alenquer
8410	336	Belterra
8411	336	Curu??
8412	336	Moju?? dos Campos
8413	336	Monte Alegre
8414	336	Placas
8415	336	Prainha
8416	336	Santar??m
8417	336	Cachoeira do Arari
8418	336	Chaves
8419	336	Muan??
8420	336	Ponta de Pedras
8421	336	Salvaterra
8422	336	Santa Cruz do Arari
8423	336	Soure
8424	336	Afu??
8425	336	Anaj??s
8426	336	Breves
8427	336	Curralinho
8428	336	S??o Sebasti??o da Boa Vista
8429	336	Bagre
8430	336	Gurup??
8431	336	Melga??o
8432	336	Portel
8433	336	Ananindeua
8434	336	Barcarena
8435	336	Bel??m??(capital estatal)
8436	336	Benevides
8437	336	Marituba
8438	336	Santa B??rbara do Par??
8439	336	Bujaru
8440	336	Castanhal
8441	336	Inhangapi
8442	336	Santa Isabel do Par??
8443	336	Santo Ant??nio do Tau??
8444	336	Augusto Corr??a
8445	336	Bragan??a
8446	336	Capanema
8447	336	Igarap??-A??u
8448	336	Nova Timboteua
8449	336	Peixe-Boi
8450	336	Primavera
8451	336	Quatipuru
8452	336	Santa Maria do Par??
8453	336	Santar??m Novo
8454	336	S??o Francisco do Par??
8455	336	Tracuateua
8456	336	Abaetetuba
8457	336	Bai??o
8458	336	Camet??
8459	336	Igarap??-Miri
8460	336	Limoeiro do Ajuru
8461	336	Mocajuba
8462	336	Oeiras do Par??
8463	336	Aurora do Par??
8464	336	Cachoeira do Piri??
8465	336	Capit??o Po??o
8466	336	Garraf??o do Norte
8467	336	Ipixuna do Par??
8468	336	Irituia
8469	336	M??e do Rio
8470	336	Nova Esperan??a do Piri??
8471	336	Our??m
8472	336	Santa Luzia do Par??
8473	336	S??o Domingos do Capim
8474	336	S??o Miguel do Guam??
8475	336	Viseu
8476	336	Colares
8477	336	Curu????
8478	336	Magalh??es Barata
8479	336	Maracan??
8480	336	Marapanim
8481	336	Salin??polis
8482	336	S??o Caetano de Odivelas
8483	336	S??o Jo??o da Ponta
8484	336	S??o Jo??o de Pirabas
8485	336	Terra Alta
8486	336	Vigia
8487	336	Acar??
8488	336	Conc??rdia do Par??
8489	336	Moju
8490	336	Tail??ndia
8491	336	Tom??-A??u
8492	336	Concei????o do Araguaia
8493	336	Floresta do Araguaia
8494	336	Santa Maria das Barreiras
8495	336	Santana do Araguaia
8496	336	Brejo Grande do Araguaia
8497	336	Marab??
8498	336	Palestina do Par??
8499	336	S??o Domingos do Araguaia
8500	336	S??o Jo??o do Araguaia
8501	336	Abel Figueiredo
8502	336	Bom Jesus do Tocantins
8503	336	Dom Eliseu
8504	336	Goian??sia do Par??
8505	336	Paragominas
8506	336	Rondon do Par??
8507	336	Ulian??polis
8508	336	??gua Azul do Norte
8509	336	Cana?? dos Caraj??s
8510	336	Curion??polis
8511	336	Eldorado dos Caraj??s
8512	336	Parauapebas
8513	336	Pau-d'Arco
8514	336	Pi??arra
8515	336	Rio Maria
8516	336	S??o Geraldo do Araguaia
8517	336	Sapucaia
8518	336	Xinguara
8519	336	Bannach
8520	336	Cumaru do Norte
8521	336	Ouril??ndia do Norte
8522	336	S??o F??lix do Xingu
8523	336	Tucum??
8524	336	Breu Branco
8525	336	Itupiranga
8526	336	Jacund??
8527	336	Nova Ipixuna
8528	336	Novo Repartimento
8529	336	Tucuru??
8530	336	Altamira
8531	336	Anapu
8532	336	Brasil Novo
8533	336	Medicil??ndia
8534	336	Pacaj??
8535	336	Senador Jos?? Porf??rio
8536	336	Uruar??
8537	336	Vit??ria do Xingu
8538	336	Aveiro
8539	336	Itaituba
8540	336	Jacareacanga
8541	336	Novo Progresso
8542	336	Rur??polis
8543	336	Trair??o
8544	337	Alagoa Grande
8545	337	Alagoa Nova
8546	337	Areia
8547	337	Bananeiras
8548	337	Borborema
8549	337	Matinhas
8550	337	Pil??es
8551	337	Serraria
8552	337	Boa Vista
8553	337	Campina Grande
8554	337	Fagundes
8555	337	Lagoa Seca
8556	337	Massaranduba
8557	337	Puxinan??
8558	337	Serra Redonda
8559	337	Algod??o de Janda??ra
8560	337	Arara
8561	337	Barra de Santa Rosa
8562	337	Cuit??
8563	337	Dami??o
8564	337	Nova Floresta
8565	337	Olivedos
8566	337	Pocinhos
8567	337	Rem??gio
8568	337	Soledade
8569	337	Soss??go
8570	337	Araruna
8571	337	Cacimba de Dentro
8572	337	Campo de Santana
8573	337	Casserengue
8574	337	Dona In??s
8575	337	Sol??nea
8576	337	Areial
8577	337	Esperan??a
8578	337	Montadas
8579	337	S??o Sebasti??o de Lagoa de Ro??a
8580	337	Alagoinha
8581	337	Ara??agi
8582	337	Cai??ara
8583	337	Cuitegi
8584	337	Duas Estradas
8585	337	Guarabira
8586	337	Lagoa de Dentro
8587	337	Logradouro
8588	337	Pil??ezinhos
8589	337	Pirpirituba
8590	337	Serra da Raiz
8591	337	Sert??ozinho
8592	337	Caldas Brand??o
8593	337	Gurinh??m
8594	337	Ing??
8595	337	Itabaiana
8596	337	Itatuba
8597	337	Juarez T??vora
8598	337	Mogeiro
8599	337	Riach??o do Bacamarte
8600	337	Salgado de S??o F??lix
8601	337	Aroeiras
8602	337	Gado Bravo
8603	337	Natuba
8604	337	Santa Cec??lia
8605	337	Umbuzeiro
8606	337	Amparo
8607	337	Assun????o
8608	337	Camala??
8609	337	Congo
8610	337	Coxixola
8611	337	Livramento
8612	337	Monteiro
8613	337	Ouro Velho
8614	337	Parari
8615	337	S??o Jo??o do Tigre
8616	337	S??o Jos?? dos Cordeiros
8617	337	S??o Sebasti??o do Umbuzeiro
8618	337	Serra Branca
8619	337	Sum??
8620	337	Zabel??
8621	337	Alcantil
8622	337	Barra de Santana
8623	337	Boqueir??o
8624	337	Cabaceiras
8625	337	Cara??bas
8626	337	Caturit??
8627	337	Gurj??o
8628	337	Riacho de Santo Ant??nio
8629	337	Santo Andr??
8630	337	S??o Domingos do Cariri
8631	337	S??o Jo??o do Cariri
8632	337	Junco do Serid??
8633	337	Salgadinho
8634	337	S??o Jos?? do Sabugi
8635	337	S??o Mamede
8636	337	V??rzea
8637	337	Bara??na
8638	337	Cubati
8639	337	Frei Martinho
8640	337	Juazeirinho
8641	337	Nova Palmeira
8642	337	Pedra Lavrada
8643	337	Picu??
8644	337	Serid??
8645	337	Ten??rio
8646	337	Bayeux
8647	337	Cabedelo
8648	337	Jo??o Pessoa??(capital estatal)
8649	337	Lucena
8650	337	Ba??a da Trai????o
8651	337	Capim
8652	337	Cuit?? de Mamanguape
8653	337	Curral de Cima
8654	337	Itapororoca
8655	337	Jacara??
8656	337	Mamanguape
8657	337	Marca????o
8658	337	Mataraca
8659	337	Pedro R??gis
8660	337	Rio Tinto
8661	337	Alahandra
8662	337	Caapor??
8663	337	Pedras de Fogo
8664	337	Pitimbu
8665	337	Cruz do Esp??rito Santo
8666	337	Juripiranga
8667	337	Mari
8668	337	Riach??o do Po??o
8669	337	S??o Jos?? dos Ramos
8670	337	S??o Miguel de Taipu
8671	337	Sap??
8672	337	Sobrado
8673	337	Bernardino Batista
8674	337	Bom Jesus
8675	337	Bonito de Santa F??
8676	337	Cachoeira dos ??ndios
8677	337	Cajazeiras
8678	337	Carrapateira
8679	337	Monte Horebe
8680	337	Po??o Dantas
8681	337	Po??o de Jos?? de Moura
8682	337	S??o Jo??o do Rio do Peixe
8683	337	S??o Jos?? de Piranhas
8684	337	Triunfo
8685	337	Uira??na
8686	337	Bel??m do Brejo do Cruz
8687	337	Brejo do Cruz
8688	337	Brejo dos Santos
8689	337	Catol?? do Rocha
8690	337	Jeric??
8691	337	Lagoa
8692	337	Mato Grosso
8693	337	Riacho dos Cavalos
8694	337	S??o Jos?? do Brejo do Cruz
8695	337	Boa Ventura
8696	337	Concei????o
8697	337	Curral Velho
8698	337	Diamante
8699	337	Ibiara
8700	337	Itaporanga
8701	337	Santana de Mangueira
8702	337	S??o Jos?? de Caiana
8703	337	Serra Grande
8704	337	Areia de Bara??nas
8705	337	Cacimba de Areia
8706	337	M??e d'??gua
8707	337	Passagem
8708	337	Patos
8709	337	Quixab??
8710	337	S??o Jos?? de Espinharas
8711	337	S??o Jos?? do Bonfim
8712	337	Aguiar
8713	337	Catingueira
8714	337	Coremas
8715	337	Emas
8716	337	Igaracy
8717	337	Olho d'??gua
8718	337	Pianc??
8719	337	Santana dos Garrotes
8720	337	Cacimbas
8721	337	Desterro
8722	337	Imaculada
8723	337	Juru
8724	337	Mana??ra
8725	337	Matur??ia
8726	337	Princesa Isabel
8727	337	S??o Jos?? de Princesa
8728	337	Tavares
8729	337	Teixeira
8730	337	Aparecida
8731	337	Cajazeirinhas
8732	337	Condado
8733	337	Lastro
8734	337	Malta
8735	337	Mariz??polis
8736	337	Nazarezinho
8737	337	Paulista
8738	337	Pombal
8739	337	Santa Cruz
8740	337	S??o Bentinho
8741	337	S??o Domingos de Pombal
8742	337	S??o Jos?? da Lagoa Tapada
8743	337	Sousa
8744	337	Vieir??polis
8745	337	Vista Serrana
8746	338	Barbosa Ferraz
8747	338	Campo Mour??o
8748	338	Corumbata?? do Sul
8749	338	Engenheiro Beltr??o
8750	338	Farol
8751	338	F??nix
8752	338	Iretama
8753	338	Luiziana
8754	338	Mambor??
8755	338	Peabiru
8756	338	Quinta do Sol
8757	338	Roncador
8758	338	Terra Boa
8759	338	Altamira do Paran??
8760	338	Campina da Lagoa
8761	338	Goioer??
8762	338	Jani??polis
8763	338	Juranda
8764	338	Moreira Sales
8765	338	Nova Cantu
8766	338	Quarto Centen??rio
8767	338	Rancho Alegre d'Oeste
8768	338	Ubirat??
8769	338	Arapoti
8770	338	Jaguaria??va
8771	338	Pira?? do Sul
8772	338	Seng??s
8773	338	Carambe??
8774	338	Castro
8775	338	Palmeira
8776	338	Ponta Grossa
8777	338	Imba??
8778	338	Ortigueira
8779	338	Reserva
8780	338	Tel??maco Borba
8781	338	Tibagi
8782	338	Ventania
8783	338	Campina do Sim??o
8784	338	Cand??i
8785	338	Espig??o Alto do Igua??u
8786	338	Foz do Jord??o
8787	338	Goioxim
8788	338	Guarapuava
8789	338	In??cio Martins
8790	338	Laranjeiras do Sul
8791	338	Marquinho
8792	338	Nova Laranjeiras
8793	338	Pinh??o
8794	338	Porto Barreiro
8795	338	Quedas do Igua??u
8796	338	Reserva do Igua??u
8797	338	Rio Bonito do Igua??u
8798	338	Turvo
8799	338	Virmond
8800	338	Clevel??ndia
8801	338	Coronel Domingos Soares
8802	338	Hon??rio Serpa
8803	338	Mangueirinha
8804	338	Palmas
8805	338	Boa Ventura de S??o Roque
8806	338	Mato Rico
8807	338	Palmital
8808	338	Pitanga
8809	338	Santa Maria do Oeste
8810	338	Adrian??polis
8811	338	Cerro Azul
8812	338	Doutor Ulysses
8813	338	Almirante Tamandar??
8814	338	Arauc??ria
8815	338	Balsa Nova
8816	338	Bocai??va do Sul
8817	338	Campina Grande do Sul
8818	338	Campo Largo
8819	338	Campo Magro
8820	338	Colombo
8821	338	Contenda
8822	338	Curitiba??(capital estatal)
8823	338	Fazenda Rio Grande
8824	338	Itaperu??u
8825	338	Mandirituba
8826	338	Pinhais
8827	338	Piraquara
8828	338	Quatro Barras
8829	338	Rio Branco do Sul
8830	338	S??o Jos?? dos Pinhais
8831	338	Tunas do Paran??
8832	338	Lapa
8833	338	Porto Amazonas
8834	338	Antonina
8835	338	Guaraque??aba
8836	338	Guaratuba
8837	338	Matinhos
8838	338	Morretes
8839	338	Paranagu??
8840	338	Pontal do Paran??
8841	338	Agudos do Sul
8842	338	Campo do Tenente
8843	338	Pi??n
8844	338	Quitandinha
8845	338	Tijucas do Sul
8846	338	Cianorte
8847	338	Cidade Ga??cha
8848	338	Guaporema
8849	338	Rondon
8850	338	S??o Manoel do Paran??
8851	338	S??o Tom??
8852	338	Tapejara
8853	338	Tuneiras do Oeste
8854	338	Alto Paran??
8855	338	Amapor??
8856	338	Diamante do Norte
8857	338	Guaira????
8858	338	Inaj??
8859	338	Ita??na do Sul
8860	338	Jardim Olinda
8861	338	Loanda
8862	338	Marilena
8863	338	Nova Alian??a do Iva??
8864	338	Nova Londrina
8865	338	Para??so do Norte
8866	338	Paranacity
8867	338	Paranapoema
8868	338	Paranava??
8869	338	Planaltina do Paran??
8870	338	Porto Rico
8871	338	Quer??ncia do Norte
8872	338	Santa Cruz do Monte Castelo
8873	338	Santa Isabel do Iva??
8874	338	Santa M??nica
8875	338	Santo Ant??nio do Caiu??
8876	338	S??o Carlos do Iva??
8877	338	S??o Jo??o do Caiu??
8878	338	S??o Pedro do Paran??
8879	338	Tamboara
8880	338	Terra Rica
8881	338	Alto Para??so
8882	338	Alto Piquiri
8883	338	Alt??nia
8884	338	Brasil??ndia do Sul
8885	338	Cafezal do Sul
8886	338	Cruzeiro do Oeste
8887	338	Esperan??a Nova
8888	338	Francisco Alves
8889	338	Icara??ma
8890	338	Ipor??
8891	338	Ivat??
8892	338	Maria Helena
8893	338	Mariluz
8894	338	Perobal
8895	338	P??rola
8896	338	S??o Jorge do Patroc??nio
8897	338	Umuarama
8898	338	Xambr??
8899	338	Apucarana
8900	338	Arapongas
8901	338	Calif??rnia
8902	338	Cambira
8903	338	Jandaia do Sul
8904	338	Maril??ndia do Sul
8905	338	Mau?? da Serra
8906	338	Novo Itacolomi
8907	338	Sab??udia
8908	338	??ngulo
8909	338	Astorga
8910	338	Cafeara
8911	338	Centen??rio do Sul
8912	338	Colorado
8913	338	Fl??rida
8914	338	Guaraci
8915	338	Iguara??u
8916	338	Itaguaj??
8917	338	Jaguapit??
8918	338	Lobato
8919	338	Lupion??polis
8920	338	Mandagua??u
8921	338	Munhoz de Melo
8922	338	Nossa Senhora das Gra??as
8923	338	Nova Esperan??a
8924	338	Presidente Castelo Branco
8925	338	Santa F??
8926	338	Santo In??cio
8927	338	Uniflor
8928	338	Borraz??polis
8929	338	Cruzmaltina
8930	338	Faxinal
8931	338	Kalor??
8932	338	Marumbi
8933	338	Rio Bom
8934	338	Doutor Camargo
8935	338	Flora??
8936	338	Floresta
8937	338	Ivatuba
8938	338	Ourizona
8939	338	S??o Jorge do Iva??
8940	338	Arapu??
8941	338	Ariranha do Iva??
8942	338	C??ndido de Abreu
8943	338	Godoy Moreira
8944	338	Grandes Rios
8945	338	Ivaipor??
8946	338	Jardim Alegre
8947	338	Lidian??polis
8948	338	Lunardelli
8949	338	Manoel Ribas
8950	338	Nova Tebas
8951	338	Rio Branco do Iva??
8952	338	Ros??rio do Iva??
8953	338	S??o Jo??o do Iva??
8954	338	S??o Pedro do Iva??
8955	338	Camb??
8956	338	Ibipor??
8957	338	Londrina
8958	338	Pitangueiras
8959	338	Rol??ndia
8960	338	Tamarana
8961	338	Mandaguari
8962	338	Marialva
8963	338	Maring??
8964	338	Pai??andu
8965	338	Sarandi
8966	338	Alvorada do Sul
8967	338	Bela Vista do Para??so
8968	338	Florest??polis
8969	338	Miraselva
8970	338	Porecatu
8971	338	Prado Ferreira
8972	338	Primeiro de Maio
8973	338	Sertan??polis
8974	338	Assa??
8975	338	Jataizinho
8976	338	Nova Santa B??rbara
8977	338	Rancho Alegre
8978	338	Santa Cec??lia do Pav??o
8979	338	S??o Jer??nimo da Serra
8980	338	S??o Sebasti??o da Amoreira
8981	338	Ura??
8982	338	Abati??
8983	338	Andir??
8984	338	Congonhinhas
8985	338	Corn??lio Proc??pio
8986	338	Itambarac??
8987	338	Le??polis
8988	338	Nova Am??rica da Colina
8989	338	Ribeir??o do Pinhal
8990	338	Santa Am??lia
8991	338	Santa Mariana
8992	338	Santo Ant??nio do Para??so
8993	338	Sertaneja
8994	338	Conselheiro Mairinck
8995	338	Curi??va
8996	338	Figueira
8997	338	Ibaiti
8998	338	Jaboti
8999	338	Japira
9000	338	Pinhal??o
9001	338	Sapopema
9002	338	Barra do Jacar??
9003	338	Cambar??
9004	338	Jacarezinho
9005	338	Jundia?? do Sul
9006	338	Ribeir??o Claro
9007	338	Santo Ant??nio da Platina
9008	338	Carl??polis
9009	338	Guapirama
9010	338	Joaquim T??vora
9011	338	Quatigu??
9012	338	Salto do Itarar??
9013	338	Santana do Itarar??
9014	338	S??o Jos?? da Boa Vista
9015	338	Siqueira Campos
9016	338	Tomazina
9017	338	Anahy
9018	338	Boa Vista da Aparecida
9019	338	Braganey
9020	338	Cafel??ndia
9021	338	Campo Bonito
9022	338	Capit??o Le??nidas Marques
9023	338	Catanduvas
9024	338	Corb??lia
9025	338	Diamante do Sul
9026	338	Guarania??u
9027	338	Ibema
9028	338	Lindoeste
9029	338	Santa L??cia
9030	338	Santa Tereza do Oeste
9031	338	Tr??s Barras do Paran??
9032	338	C??u Azul
9033	338	Foz do Igua??u
9034	338	Itaipul??ndia
9035	338	Matel??ndia
9036	338	Medianeira
9037	338	Missal
9038	338	Ramil??ndia
9039	338	Santa Terezinha de Itaipu
9040	338	S??o Miguel do Igua??u
9041	338	Serran??polis do Igua??u
9042	338	Vera Cruz do Oeste
9043	338	Assis Chateaubriand
9044	338	Diamante d'Oeste
9045	338	Entre Rios do Oeste
9046	338	Formosa do Oeste
9047	338	Gua??ra
9048	338	Iracema do Oeste
9049	338	Jesu??tas
9050	338	Marechal C??ndido Rondon
9051	338	Marip??
9052	338	Mercedes
9053	338	Nova Santa Rosa
9054	338	Ouro Verde do Oeste
9055	338	Palotina
9056	338	Pato Bragado
9057	338	Quatro Pontes
9058	338	S??o Jos?? das Palmeiras
9059	338	S??o Pedro do Igua??u
9060	338	Terra Roxa
9061	338	Tup??ssi
9062	338	Irati
9063	338	Mallet
9064	338	Rebou??as
9065	338	Rio Azul
9066	338	Fernandes Pinheiro
9067	338	Guamiranga
9068	338	Imbituva
9069	338	Ipiranga
9070	338	Iva??
9071	338	Prudent??polis
9072	338	Teixeira Soares
9073	338	Ant??nio Olinto
9074	338	S??o Jo??o do Triunfo
9075	338	S??o Mateus do Sul
9076	338	Bituruna
9077	338	Cruz Machado
9078	338	Paula Freitas
9079	338	Paulo Frontin
9080	338	Porto Vit??ria
9081	338	Uni??o da Vit??ria
9082	338	Amp??re
9083	338	Bela Vista da Caroba
9084	338	P??rola d'Oeste
9085	338	Pranchita
9086	338	Realeza
9087	338	Santa Izabel do Oeste
9088	338	Barrac??o
9089	338	Boa Esperan??a do Igua??u
9090	338	Bom Jesus do Sul
9091	338	Cruzeiro do Igua??u
9092	338	Dois Vizinhos
9093	338	En??as Marques
9094	338	Flor da Serra do Sul
9095	338	Francisco Beltr??o
9096	338	Manfrin??polis
9097	338	Marmeleiro
9098	338	Nova Esperan??a do Sudoeste
9099	338	Nova Prata do Igua??u
9100	338	Pinhal de S??o Bento
9101	338	Renascen??a
9102	338	Salgado Filho
9103	338	Salto do Lontra
9104	338	Santo Ant??nio do Sudoeste
9105	338	S??o Jorge d'Oeste
9106	338	Ver??
9107	338	Bom Sucesso do Sul
9108	338	Chopinzinho
9109	338	Coronel Vivida
9110	338	Itapejara d'Oeste
9111	338	Mari??polis
9112	338	Pato Branco
9113	338	S??o Jo??o
9114	338	Saudade do Igua??u
9115	338	Sulina
9116	338	Vitorino
9117	339	Abreu e Lima
9118	339	Afogados da Ingazeira
9119	339	Afr??nio
9120	339	Agrestina
9121	339	??gua Preta
9122	339	??guas Belas
9123	339	Alian??a
9124	339	Altinho
9125	339	Amaraji
9126	339	Angelim
9127	339	Araripina
9128	339	Arcoverde
9129	339	Barra de Guabiraba
9130	339	Barreiros
9131	339	Bel??m de Maria
9132	339	Bel??m de S??o Francisco
9133	339	Belo Jardim
9134	339	Bet??nia
9135	339	Bezerros
9136	339	Bodoc??
9137	339	Bom Conselho
9138	339	Brej??o
9139	339	Brejinho
9140	339	Brejo da Madre de Deus
9141	339	Buenos Aires
9142	339	Bu??que
9143	339	Cabo de Santo Agostinho
9144	339	Cabrob??
9145	339	Cachoeirinha
9146	339	Caet??s
9147	339	Cal??ado
9148	339	Calumbi
9149	339	Camaragibe
9150	339	Camocim de S??o F??lix
9151	339	Camutanga
9152	339	Canhotinho
9153	339	Capoeiras
9154	339	Carna??ba
9155	339	Carnaubeira da Penha
9156	339	Carpina
9157	339	Caruaru
9158	339	Casinhas
9159	339	Catende
9160	339	Ch?? de Alegria
9161	339	Ch?? Grande
9162	339	Correntes
9163	339	Cort??s
9164	339	Cumaru
9165	339	Cupira
9166	339	Cust??dia
9167	339	Dormentes
9168	339	Escada
9169	339	Exu
9170	339	Feira Nova
9171	339	Fernando de Noronha
9172	339	Ferreiros
9173	339	Flores
9174	339	Frei Miguelinho
9175	339	Gameleira
9176	339	Garanhuns
9177	339	Gl??ria do Goit??
9178	339	Goiana
9179	339	Granito
9180	339	Gravat??
9181	339	Iati
9182	339	Ibimirim
9183	339	Ibirajuba
9184	339	Igarassu
9185	339	Iguaraci
9186	339	Ingazeira
9187	339	Ipojuca
9188	339	Ipubi
9189	339	Itacuruba
9190	339	Ita??ba
9191	339	Ilha de Itamarac??
9192	339	Itapetim
9193	339	Itapissuma
9194	339	Itaquitinga
9195	339	Jaboat??o dos Guararapes
9196	339	Jaqueira
9197	339	Jata??ba
9198	339	Jo??o Alfredo
9199	339	Joaquim Nabuco
9200	339	Jucati
9201	339	Jupi
9202	339	Jurema
9203	339	Lagoa do Carro
9204	339	Lagoa de Itaenga
9205	339	Lagoa do Ouro
9206	339	Lagoa dos Gatos
9207	339	Lajedo
9208	339	Limoeiro
9209	339	Macaparana
9210	339	Machados
9211	339	Manari
9212	339	Maraial
9213	339	Mirandiba
9214	339	Moreil??ndia
9215	339	Moreno
9216	339	Nazar?? da Mata
9217	339	Olinda
9218	339	Orob??
9219	339	Oroc??
9220	339	Ouricuri
9221	339	Palmares
9222	339	Palmeirina
9223	339	Panelas
9224	339	Paranatama
9225	339	Parnamirim
9226	339	Passira
9227	339	Paudalho
9228	339	Pedra
9229	339	Pesqueira
9230	339	Petrol??ndia
9231	339	Petrolina
9232	339	Po????o
9233	339	Pombos
9234	339	Quipap??
9235	339	Quixaba
9236	339	Recife
9237	339	Riacho das Almas
9238	339	Ribeir??o
9239	339	Rio Formoso
9240	339	Sair??
9241	339	Salgueiro
9242	339	Salo??
9243	339	Sanhar??
9244	339	Santa Cruz da Baixa Verde
9245	339	Santa Cruz do Capibaribe
9246	339	Santa Filomena
9247	339	Santa Maria da Boa Vista
9248	339	Santa Maria do Cambuc??
9249	339	S??o Benedito do Sul
9250	339	S??o Bento do Una
9251	339	S??o Caetano
9252	339	S??o Joaquim do Monte
9253	339	S??o Jos?? da Coroa Grande
9254	339	S??o Jos?? do Belmonte
9255	339	S??o Jos?? do Egito
9256	339	S??o Louren??o da Mata
9257	339	S??o Vicente F??rrer
9258	339	Serra Talhada
9259	339	Serrita
9260	339	Sert??nia
9261	339	Sirinha??m
9262	339	Solid??o
9263	339	Surubim
9264	339	Tabira
9265	339	Tacaimb??
9266	339	Tacaratu
9267	339	Tamandar??
9268	339	Taquaritinga do Norte
9269	339	Terezinha
9270	339	Timba??ba
9271	339	Toritama
9272	339	Tracunha??m
9273	339	Tupanatinga
9274	339	Tuparetama
9275	339	Venturosa
9276	339	Verdejante
9277	339	Vertente do L??rio
9278	339	Vertentes
9279	339	Vic??ncia
9280	339	Vit??ria de Santo Ant??o
9281	339	Xex??u
9282	340	Alto Long??
9283	340	Assun????o do Piau??
9284	340	Boqueir??o do Piau??
9285	340	Buriti dos Montes
9286	340	Campo Maior
9287	340	Capit??o de Campos
9288	340	Castelo do Piau??
9289	340	Cocal de Telha
9290	340	Domingos Mour??o
9291	340	Jatob?? do Piau??
9292	340	Juazeiro do Piau??
9293	340	Lagoa de S??o Francisco
9294	340	Milton Brand??o
9295	340	Nossa Senhora de Nazar??
9296	340	Pau d'Arco do Piau??
9297	340	Pedro II
9298	340	S??o Jo??o da Serra
9299	340	S??o Miguel do Tapuio
9300	340	Sigefredo Pacheco
9301	340	Agricol??ndia
9302	340	Amarante
9303	340	Angical do Piau??
9304	340	Arraial
9305	340	Barro Duro
9306	340	Francisco Ayres
9307	340	Hugo Napole??o
9308	340	Jardim do Mulato
9309	340	Lagoinha do Piau??
9310	340	Olho d'??gua do Piau??
9311	340	Palmeirais
9312	340	Passagem Franca do Piau??
9313	340	Regenera????o
9314	340	Santo Ant??nio dos Milagres
9315	340	S??o Gon??alo do Piau??
9316	340	S??o Pedro do Piau??
9317	340	Altos
9318	340	Beneditinos
9319	340	Coivaras
9320	340	Curralinhos
9321	340	Demerval Lob??o
9322	340	Jos?? de Freitas
9323	340	Lagoa Alegre
9324	340	Lagoa do Piau??
9325	340	Miguel Le??o
9326	340	Monsenhor Gil
9327	340	Teresina??(capital del estado)
9328	340	Uni??o
9329	340	Aroazes
9330	340	Barra d'Alc??ntara
9331	340	Elesb??o Veloso
9332	340	Francin??polis
9333	340	Inhuma
9334	340	Lagoa do S??tio
9335	340	Novo Oriente do Piau??
9336	340	Pimenteiras
9337	340	Prata do Piau??
9338	340	Santa Cruz dos Milagres
9339	340	S??o F??lix do Piau??
9340	340	S??o Miguel da Baixa Grande
9341	340	Valen??a do Piau??
9342	340	Barras
9343	340	Boa Hora
9344	340	Brasileira
9345	340	Cabeceiras do Piau??
9346	340	Campo Largo do Piau??
9347	340	Esperantina
9348	340	Joaquim Pires
9349	340	Joca Marques
9350	340	Luzil??ndia
9351	340	Madeiro
9352	340	Matias Ol??mpio
9353	340	Miguel Alves
9354	340	Morro do Chap??u do Piau??
9355	340	Nossa Senhora dos Rem??dios
9356	340	Piripiri
9357	340	Porto
9358	340	S??o Jo??o do Arraial
9359	340	Bom Princ??pio do Piau??
9360	340	Buriti dos Lopes
9361	340	Cajueiro da Praia
9362	340	Cara??bas do Piau??
9363	340	Caxing??
9364	340	Cocal
9365	340	Cocal dos Alves
9366	340	Ilha Grande
9367	340	Lu??s Correia
9368	340	Murici dos Portelas
9369	340	Parna??ba
9370	340	Piracuruca
9371	340	S??o Jo??o da Fronteira
9372	340	Acau??
9373	340	Bela Vista do Piau??
9374	340	Bel??m do Piau??
9375	340	Bet??nia do Piau??
9376	340	Caldeir??o Grande do Piau??
9377	340	Campinas do Piau??
9378	340	Campo Alegre do Fidalgo
9379	340	Campo Grande do Piau??
9380	340	Capit??o Gerv??sio Oliveira
9381	340	Caridade do Piau??
9382	340	Concei????o do Canind??
9383	340	Curral Novo do Piau??
9384	340	Floresta do Piau??
9385	340	Francisco Mac??do
9386	340	Fronteiras
9387	340	Isa??as Coelho
9388	340	Itain??polis
9389	340	Jacobina do Piau??
9390	340	Jaic??s
9391	340	Jo??o Costa
9392	340	Lagoa do Barro do Piau??
9393	340	Marcol??ndia
9394	340	Massap?? do Piau??
9395	340	Nova Santa Rita
9396	340	Padre Marcos
9397	340	Paes Landim
9398	340	Patos do Piau??
9399	340	Paulistana
9400	340	Pedro Laurentino
9401	340	Queimada Nova
9402	340	Ribeira do Piau??
9403	340	Santo In??cio do Piau??
9404	340	S??o Francisco de Assis do Piau??
9405	340	S??o Jo??o do Piau??
9406	340	Sim??es
9407	340	Simpl??cio Mendes
9408	340	Socorro do Piau??
9409	340	Vera Mendes
9410	340	Vila Nova do Piau??
9411	340	Aroeiras do Itaim
9412	340	Bocaina
9413	340	Cajazeiras do Piau??
9414	340	Col??nia do Piau??
9415	340	Dom Expedito Lopes
9416	340	Geminiano
9417	340	Ipiranga do Piau??
9418	340	Oeiras
9419	340	Paquet??
9420	340	Picos
9421	340	Santa Cruz do Piau??
9422	340	Santa Rosa do Piau??
9423	340	Santana do Piau??
9424	340	S??o Jo??o da Canabrava
9425	340	S??o Jo??o da Varjota
9426	340	S??o Jos?? do Piau??
9427	340	S??o Lu??s do Piau??
9428	340	Sussuapara
9429	340	Tanque do Piau??
9430	340	Wall Ferraz
9431	340	Alagoinha do Piau??
9432	340	Alegrete do Piau??
9433	340	Francisco Santos
9434	340	Monsenhor Hip??lito
9435	340	Pio IX
9436	340	Santo Ant??nio de Lisboa
9437	340	S??o Juli??o
9438	340	Alvorada do Gurgu??ia
9439	340	Barreiras do Piau??
9440	340	Cristino Castro
9441	340	Currais
9442	340	Gilbu??s
9443	340	Monte Alegre do Piau??
9444	340	Palmeira do Piau??
9445	340	Reden????o do Gurgu??ia
9446	340	Santa Luz
9447	340	S??o Gon??alo do Gurgu??ia
9448	340	Baixa Grande do Ribeiro
9449	340	Ribeiro Gon??alves
9450	340	Uru??u??
9451	340	Ant??nio Almeida
9452	340	Bertol??nia
9453	340	Col??nia do Gurgu??ia
9454	340	Eliseu Martins
9455	340	Landri Sales
9456	340	Manoel Em??dio
9457	340	Marcos Parente
9458	340	Porto Alegre do Piau??
9459	340	Sebasti??o Leal
9460	340	Avelino Lopes
9461	340	Corrente
9462	340	Cristal??ndia do Piau??
9463	340	Curimat??
9464	340	J??lio Borges
9465	340	Morro Cabe??a no Tempo
9466	340	Parnagu??
9467	340	Riacho Frio
9468	340	Sebasti??o Barros
9469	340	Canavieira
9470	340	Flores do Piau??
9471	340	Floriano
9472	340	Guadalupe
9473	340	Itaueira
9474	340	Jerumenha
9475	340	Nazar?? do Piau??
9476	340	Pavussu
9477	340	Rio Grande do Piau??
9478	340	S??o Francisco do Piau??
9479	340	S??o Jos?? do Peixe
9480	340	S??o Miguel do Fidalgo
9481	340	An??sio de Abreu
9482	340	Bonfim do Piau??
9483	340	Brejo do Piau??
9484	340	Canto do Buriti
9485	340	Coronel Jos?? Dias
9486	340	Dirceu Arcoverde
9487	340	Dom Inoc??ncio
9488	340	Fartura do Piau??
9489	340	Guaribas
9490	340	Paje?? do Piau??
9491	340	S??o Braz do Piau??
9492	340	S??o Louren??o do Piau??
9493	340	S??o Raimundo Nonato
9494	340	Tamboril do Piau??
9495	340	V??rzea Branca
9496	341	Casimiro de Abreu
9497	341	Rio das Ostras
9498	341	Silva Jardim
9499	341	Araruama
9500	341	Arma????o dos B??zios
9501	341	Arraial do Cabo
9502	341	Cabo Fr??o
9503	341	Iguaba Grande
9504	341	S??o Pedro da Aldeia
9505	341	Saquarema
9506	341	Carmo
9507	341	Cordeiro
9508	341	Macuco
9509	341	Duas Barras
9510	341	Nova Friburgo
9511	341	Sumidouro
9512	341	Santa Maria Madalena
9513	341	S??o Sebasti??o do Alto
9514	341	Trajano de Morais
9515	341	Areal
9516	341	Comendador Levy Gasparian
9517	341	Para??ba do Sul
9518	341	Tr??s Rios
9519	341	Itagua??
9520	341	Mangaratiba
9521	341	Serop??dica
9522	341	Cachoeiras de Macacu
9523	341	Rio Bonito
9524	341	Belford Roxo
9525	341	Duque de Caxias
9526	341	Guapimirim
9527	341	Itabora??
9528	341	Japeri
9529	341	Mag??
9530	341	Maric??
9531	341	Nil??polis
9532	341	Niter??i
9533	341	Nova Igua??u
9534	341	Queimados
9535	341	R??o de Janeiro??(capital estatal)
9536	341	S??o Gon??alo
9537	341	S??o Jo??o de Meriti
9538	341	Tangu??
9539	341	Petr??polis
9540	341	S??o Jos?? do Vale do Rio Preto
9541	341	Teres??polis
9542	341	Engenheiro Paulo de Frontin
9543	341	Mendes
9544	341	Miguel Pereira
9545	341	Paracambi
9546	341	Paty do Alferes
9547	341	Vassouras
9548	341	Bom Jesus do Itabapoana
9549	341	Italva
9550	341	Itaperuna
9551	341	Laje do Muria??
9552	341	Natividade
9553	341	Porci??ncula
9554	341	Varre-Sai
9555	341	Aperib??
9556	341	Cambuci
9557	341	Itaocara
9558	341	Miracema
9559	341	Santo Ant??nio de P??dua
9560	341	S??o Jos?? de Ub??
9561	341	Campos dos Goytacazes
9562	341	Cardoso Moreira
9563	341	S??o Fid??lis
9564	341	S??o Francisco de Itabapoana
9565	341	S??o Jo??o da Barra
9566	341	Carapebus
9567	341	Concei????o de Macabu
9568	341	Maca??
9569	341	Quissam??
9570	341	Angra dos Reis
9571	341	Parati
9572	341	Barra do Pira??
9573	341	Rio das Flores
9574	341	Barra Mansa
9575	341	Itatiaia
9576	341	Pinheiral
9577	341	Pira??
9578	341	Porto Real
9579	341	Quatis
9580	341	Resende
9581	341	R??o Claro
9582	341	Volta Redonda
9583	342	Acari
9584	342	Afonso Bezerra
9585	342	??gua Nova
9586	342	Alexandria
9587	342	Almino Afonso
9588	342	Alto do Rodrigues
9589	342	Angicos
9590	342	Ant??nio Martins
9591	342	Apodi
9592	342	Areia Branca
9593	342	Ar??s
9594	342	Assu
9595	342	Ba??a Formosa
9596	342	Barcelona
9597	342	Bento Fernandes
9598	342	Boa Sa??de
9599	342	Bod??
9600	342	Cai??ara do Norte
9601	342	Cai??ara do Rio do Vento
9602	342	Caic??
9603	342	Campo Redondo
9604	342	Canguaretama
9605	342	Carna??ba dos Dantas
9606	342	Carnaubais
9607	342	Cear??-Mirim
9608	342	Cerro Cor??
9609	342	Coronel Ezequiel
9610	342	Coronel Jo??o Pessoa
9611	342	Cruzeta
9612	342	Currais Novos
9613	342	Doutor Severiano
9614	342	Encanto
9615	342	Equador
9616	342	Esp??rito Santo
9617	342	Extremoz
9618	342	Felipe Guerra
9619	342	Fernando Pedroza
9620	342	Flor??nia
9621	342	Francisco Dantas
9622	342	Frutuoso Gomes
9623	342	Galinhos
9624	342	Goianinha
9625	342	Governador Dix-Sept Rosado
9626	342	Grossos
9627	342	Guamar??
9628	342	Ielmo Marinho
9629	342	Ipangua??u
9630	342	Ipueira
9631	342	Ita??
9632	342	Ja??an??
9633	342	Jandu??s
9634	342	Japi
9635	342	Jardim de Angicos
9636	342	Jardim de Piranhas
9637	342	Jardim do Serid??
9638	342	Jo??o C??mara
9639	342	Jo??o Dias
9640	342	Jos?? da Penha
9641	342	Jucurutu
9642	342	Lagoa d'Anta
9643	342	Lagoa de Pedras
9644	342	Lagoa de Velhos
9645	342	Lagoa Nova
9646	342	Lagoa Salgada
9647	342	Lajes
9648	342	Lajes Pintadas
9649	342	Lucr??cia
9650	342	Lu??s Gomes
9651	342	Maca??ba
9652	342	Macau
9653	342	Major Sales
9654	342	Marcelino Vieira
9655	342	Martins
9656	342	Maxaranguape
9657	342	Messias Targino
9658	342	Montanhas
9659	342	Monte das Gameleiras
9660	342	Mossor??
9661	342	Natal
9662	342	N??sia Floresta
9663	342	Nova Cruz
9664	342	Olho-d'??gua do Borges
9665	342	Paran??
9666	342	Para??
9667	342	Parazinho
9668	342	Parelhas
9669	342	Passa e Fica
9670	342	Patu
9671	342	Pau dos Ferros
9672	342	Pedra Grande
9673	342	Pedro Avelino
9674	342	Pedro Velho
9675	342	Pend??ncias
9676	342	Po??o Branco
9677	342	Portalegre
9678	342	Porto do Mangue
9679	342	Pureza
9680	342	Rafael Fernandes
9681	342	Rafael Godeiro
9682	342	Riacho da Cruz
9683	342	Riachuelo
9684	342	Rio do Fogo
9685	342	Rodolfo Fernandes
9686	342	Santana do Matos
9687	342	Santana do Serid??
9688	342	Santo Ant??nio
9689	342	S??o Bento do Norte
9690	342	S??o Bento do Trairi
9691	342	S??o Fernando
9692	342	S??o Francisco do Oeste
9693	342	S??o Jo??o do Sabugi
9694	342	S??o Jos?? de Mipibu
9695	342	S??o Jos?? do Campestre
9696	342	S??o Jos?? do Serid??
9697	342	S??o Miguel
9698	342	S??o Miguel do Gostoso
9699	342	S??o Paulo do Potengi
9700	342	S??o Pedro
9701	342	S??o Rafael
9702	342	S??o Vicente
9703	342	Senador El??i de Souza
9704	342	Senador Georgino Avelino
9705	342	Serra Caiada
9706	342	Serra de S??o Bento
9707	342	Serra do Mel
9708	342	Serra Negra do Norte
9709	342	Serrinha dos Pintos
9710	342	Severiano Melo
9711	342	Taboleiro Grande
9712	342	Taipu
9713	342	Tangar??
9714	342	Tenente Ananias
9715	342	Tenente Laurentino Cruz
9716	342	Tibau
9717	342	Tibau do Sul
9718	342	Timba??ba dos Batistas
9719	342	Touros
9720	342	Triunfo Potiguar
9721	342	Umarizal
9722	342	Upanema
9723	342	Venha-Ver
9724	342	Vila Flor
9725	343	Agudo
9726	343	Dona Francisca
9727	343	Faxinal do Soturno
9728	343	Formigueiro
9729	343	Ivor??
9730	343	Nova Palma
9731	343	Restinga Seca
9732	343	S??o Jo??o do Pol??sine
9733	343	Silveira Martins
9734	343	Cacequi
9735	343	Dilermando de Aguiar
9736	343	Itaara
9737	343	Jaguari
9738	343	Mata
9739	343	Nova Esperan??a do Sul
9740	343	S??o Martinho da Serra
9741	343	S??o Pedro do Sul
9742	343	S??o Sep??
9743	343	S??o Vicente do Sul
9744	343	Toropi
9745	343	Vila Nova do Sul
9746	343	Cap??o do Cip??
9747	343	Itacurubi
9748	343	Jari
9749	343	J??lio de Castilhos
9750	343	Pinhal Grande
9751	343	Quevedos
9752	343	Santiago
9753	343	Tupanciret??
9754	343	Unistalda
9755	343	Cachoeira do Sul
9756	343	Cerro Branco
9757	343	Novo Cabrais
9758	343	Pantano Grande
9759	343	Para??so do Sul
9760	343	Passo do Sobrado
9761	343	Rio Pardo
9762	343	Arroio do Meio
9763	343	Bom Retiro do Sul
9764	343	Boqueir??o do Le??o
9765	343	Canudos do Vale
9766	343	Capit??o
9767	343	Coqueiro Baixo
9768	343	Doutor Ricardo
9769	343	Encantado
9770	343	Estrela
9771	343	Fazenda Vilanova
9772	343	Forquetinha
9773	343	Imigrante
9774	343	Lajeado
9775	343	Marques de Souza
9776	343	Mu??um
9777	343	Nova Br??scia
9778	343	Paverama
9779	343	Pouso Novo
9780	343	Progresso
9781	343	Relvado
9782	343	Roca Sales
9783	343	Santa Clara do Sul
9784	343	S??rio
9785	343	Taba??
9786	343	Taquari
9787	343	Teut??nia
9788	343	Travesseiro
9789	343	Vespasiano Correa
9790	343	Westf??lia
9791	343	Arroio do Tigre
9792	343	Candel??ria
9793	343	Estrela Velha
9794	343	Gramado Xavier
9795	343	Herveiras
9796	343	Ibarama
9797	343	Lagoa Bonita do Sul
9798	343	Mato Leit??o
9799	343	Passa Sete
9800	343	Santa Cruz do Sul
9801	343	Segredo
9802	343	Sinimbu
9803	343	Vale do Sol
9804	343	Ven??ncio Aires
9805	343	Arambar??
9806	343	Barra do Ribeiro
9807	343	Camaqu??
9808	343	Cerro Grande do Sul
9809	343	Chuvisca
9810	343	Dom Feliciano
9811	343	Sentinela do Sul
9812	343	Tapes
9813	343	Canela
9814	343	Dois Irm??os
9815	343	Gramado
9816	343	Igrejinha
9817	343	Ivoti
9818	343	Lindolfo Collor
9819	343	Morro Reuter
9820	343	Nova Petr??polis
9821	343	Picada Caf??
9822	343	Presidente Lucena
9823	343	Riozinho
9824	343	Rolante
9825	343	Santa Maria do Herval
9826	343	Taquara
9827	343	Tr??s Coroas
9828	343	Alto Feliz
9829	343	Bar??o
9830	343	Bom Princ??pio
9831	343	Brochier
9832	343	Capela de Santana
9833	343	Feliz
9834	343	Harmonia
9835	343	Linha Nova
9836	343	Marat??
9837	343	Montenegro
9838	343	Pareci Novo
9839	343	Po??o das Antas
9840	343	Port??o
9841	343	Salvador do Sul
9842	343	S??o Jos?? do Hort??ncio
9843	343	S??o Jos?? do Sul
9844	343	S??o Pedro da Serra
9845	343	S??o Sebasti??o do Ca??
9846	343	S??o Vendelino
9847	343	Tupandi
9848	343	Vale Real
9849	343	Arroio do Sal
9850	343	Balne??rio Pinhal
9851	343	Cap??o da Canoa
9852	343	Capivari do Sul
9853	343	Cara??
9854	343	Cidreira
9855	343	Dom Pedro de Alc??ntara
9856	343	Imb??
9857	343	Itati
9858	343	Mampituba
9859	343	Maquin??
9860	343	Morrinhos do Sul
9861	343	Mostardas
9862	343	Os??rio
9863	343	Palmares do Sul
9864	343	Santo Ant??nio da Patrulha
9865	343	Terra de Areia
9866	343	Torres
9867	343	Tramanda??
9868	343	Tr??s Cachoeiras
9869	343	Tr??s Forquilhas
9870	343	Xangri-l??
9871	343	Alvorada
9872	343	Araric??
9873	343	Campo Bom
9874	343	Canoas
9875	343	Eldorado do Sul
9876	343	Est??ncia Velha
9877	343	Esteio
9878	343	Glorinha
9879	343	Gravata??
9880	343	Gua??ba
9881	343	Mariana Pimentel
9882	343	Nova Hartz
9883	343	Novo Hamburgo
9884	343	Parob??
9885	343	Porto Alegre??(capital estatal)
9886	343	S??o Leopoldo
9887	343	Sapiranga
9888	343	Sapucaia do Sul
9889	343	Sert??o Santana
9890	343	Viam??o
9891	343	Arroio dos Ratos
9892	343	Bar??o do Triunfo
9893	343	Buti??
9894	343	Charqueadas
9895	343	General C??mara
9896	343	Minas do Le??o
9897	343	S??o Jer??nimo
9898	343	Vale Verde
9899	343	Ant??nio Prado
9900	343	Bento Gon??alves
9901	343	Boa Vista do Sul
9902	343	Carlos Barbosa
9903	343	Caxias do Sul
9904	343	Coronel Pilar
9905	343	Cotipor??
9906	343	Fagundes Varela
9907	343	Farroupilha
9908	343	Flores da Cunha
9909	343	Garibaldi
9910	343	Monte Belo do Sul
9911	343	Nova P??dua
9912	343	Nova Roma do Sul
9913	343	Santa Tereza
9914	343	S??o Marcos
9915	343	Veran??polis
9916	343	Vila Flores
9917	343	Andr?? da Rocha
9918	343	Anta Gorda
9919	343	Arvorezinha
9920	343	Dois Lajeados
9921	343	Guabiju
9922	343	Guapor??
9923	343	Il??polis
9924	343	Itapuca
9925	343	Montauri
9926	343	Nova Alvorada
9927	343	Nova Ara????
9928	343	Nova Bassano
9929	343	Nova Prata
9930	343	Para??
9931	343	Prot??sio Alves
9932	343	Putinga
9933	343	S??o Jorge
9934	343	S??o Valentim do Sul
9935	343	Serafina Corr??a
9936	343	Uni??o da Serra
9937	343	Vista Alegre do Prata
9938	343	Cambar?? do Sul
9939	343	Campestre da Serra
9940	343	Cap??o Bonito do Sul
9941	343	Esmeralda
9942	343	Ip??
9943	343	Jaquirana
9944	343	Lagoa Vermelha
9945	343	Monte Alegre dos Campos
9946	343	Muitos Cap??es
9947	343	Pinhal da Serra
9948	343	S??o Jos?? dos Ausentes
9949	343	Vacaria
9950	343	Almirante Tamandar?? do Sul
9951	343	Barra Funda
9952	343	Boa Vista das Miss??es
9953	343	Carazinho
9954	343	Cerro Grande
9955	343	Chapada
9956	343	Coqueiros do Sul
9957	343	Jaboticaba
9958	343	Lajeado do Bugre
9959	343	Nova Boa Vista
9960	343	Novo Barreiro
9961	343	Palmeira das Miss??es
9962	343	Pinhal
9963	343	Sagrada Fam??lia
9964	343	Santo Ant??nio do Planalto
9965	343	S??o Jos?? das Miss??es
9966	343	S??o Pedro das Miss??es
9967	343	Caibat??
9968	343	Campina das Miss??es
9969	343	Cerro Largo
9970	343	Guarani das Miss??es
9971	343	Mato Queimado
9972	343	Porto Xavier
9973	343	Roque Gonzales
9974	343	Salvador das Miss??es
9975	343	S??o Paulo das Miss??es
9976	343	S??o Pedro do Buti??
9977	343	Sete de Setembro
9978	343	Alto Alegre
9979	343	Boa Vista do Cadeado
9980	343	Boa Vista do Incra
9981	343	Campos Borges
9982	343	Cruz Alta
9983	343	Espumoso
9984	343	Fortaleza dos Valos
9985	343	Ibirub??
9986	343	Jacuizinho
9987	343	J??ia
9988	343	Quinze de Novembro
9989	343	Saldanha Marinho
9990	343	Salto do Jacu??
9991	343	Santa B??rbara do Sul
9992	343	Aratiba
9993	343	??urea
9994	343	Bar??o de Cotegipe
9995	343	Barra do Rio Azul
9996	343	Benjamin Constant do Sul
9997	343	Campinas do Sul
9998	343	Carlos Gomes
9999	343	Centen??rio
10000	343	Cruzaltense
10001	343	Entre Rios do Sul
10002	343	Erebango
10003	343	Erechim
10004	343	Erval Grande
10005	343	Esta????o
10006	343	Faxinalzinho
10007	343	Floriano Peixoto
10008	343	Gaurama
10009	343	Get??lio Vargas
10010	343	Ipiranga do Sul
10011	343	Itatiba do Sul
10012	343	Marcelino Ramos
10013	343	Mariano Moro
10014	343	Paulo Bento
10015	343	Ponte Preta
10016	343	Quatro Irm??os
10017	343	S??o Valentim
10018	343	Severiano de Almeida
10019	343	Tr??s Arroios
10020	343	Viadutos
10021	343	Alpestre
10022	343	Ametista do Sul
10023	343	Constantina
10024	343	Cristal do Sul
10025	343	Dois Irm??os das Miss??es
10026	343	Engenho Velho
10027	343	Erval Seco
10028	343	Frederico Westphalen
10029	343	Gramado dos Loureiros
10030	343	Ira??
10031	343	Liberato Salzano
10032	343	Nonoai
10033	343	Novo Tiradentes
10034	343	Novo Xingu
10035	343	Palmitinho
10036	343	Pinheirinho do Vale
10037	343	Rio dos ??ndios
10038	343	Rodeio Bonito
10039	343	Rondinha
10040	343	Seberi
10041	343	Taquaru??u do Sul
10042	343	Tr??s Palmeiras
10043	343	Trindade do Sul
10044	343	Vicente Dutra
10045	343	Vista Alegre
10046	343	Ajuricaba
10047	343	Alegr??a
10048	343	Augusto Pestana
10049	343	Bozano
10050	343	Chiapetta
10051	343	Condor
10052	343	Coronel Barros
10053	343	Coronel Bicaco
10054	343	Iju??
10055	343	Inhacor??
10056	343	Nova Ramada
10057	343	Panambi
10058	343	Peju??ara
10059	343	Santo Augusto
10060	343	S??o Val??rio do Sul
10061	343	Lagoa dos Tr??s Cantos
10062	343	N??o-Me-Toque
10063	343	Selbach
10064	343	Tapera
10065	343	Tio Hugo
10066	343	Victor Graeff
10067	343	??gua Santa
10068	343	Camargo
10069	343	Casca
10070	343	Caseiros
10071	343	Charr??a
10072	343	Cir??aco
10073	343	Coxilha
10074	343	David Canabarro
10075	343	Ernestina
10076	343	Gentil
10077	343	Ibiraiaras
10078	343	Marau
10079	343	Mato Castelhano
10080	343	Muliterno
10081	343	Nicolau Vergueiro
10082	343	Passo Fundo
10083	343	Pont??o
10084	343	Ronda Alta
10085	343	Santa Cec??lia do Sul
10086	343	Santo Ant??nio do Palma
10087	343	S??o Domingos do Sul
10088	343	Sert??o
10089	343	Vanini
10090	343	Vila L??ngaro
10091	343	Vila Maria
10092	343	Cacique Doble
10093	343	Ibia????
10094	343	Machadinho
10095	343	Maximiliano de Almeida
10096	343	Paim Filho
10097	343	Sananduva
10098	343	Santo Expedito do Sul
10099	343	S??o Jo??o da Urtiga
10100	343	S??o Jos?? do Ouro
10101	343	Tupanci do Sul
10102	343	Alecrim
10103	343	C??ndido God??i
10104	343	Novo Machado
10105	343	Porto Lucena
10106	343	Porto Mau??
10107	343	Porto Vera Cruz
10108	343	Santa Rosa
10109	343	Santo Cristo
10110	343	S??o Jos?? do Inhacor??
10111	343	Tr??s de Maio
10112	343	Tucunduva
10113	343	Tuparendi
10114	343	Bossoroca
10115	343	Catu??pe
10116	343	Dezesseis de Novembro
10117	343	Entre-Iju??s
10118	343	Eug??nio de Castro
10119	343	Giru??
10120	343	Pirap??
10121	343	Rolador
10122	343	Santo ??ngelo
10123	343	Santo Ant??nio das Miss??es
10124	343	S??o Luiz Gonzaga
10125	343	S??o Miguel das Miss??es
10126	343	S??o Nicolau
10127	343	Senador Salgado Filho
10128	343	Ubiretama
10129	343	Vit??ria das Miss??es
10130	343	Barros Cassal
10131	343	Fontoura Xavier
10132	343	Ibirapuit??
10133	343	Lago??o
10134	343	Morma??o
10135	343	S??o Jos?? do Herval
10136	343	Tunas
10137	343	Barra do Guarita
10138	343	Boa Vista do Buric??
10139	343	Bom Progresso
10140	343	Braga
10141	343	Campo Novo
10142	343	Crissiumal
10143	343	Derrubadas
10144	343	Doutor Maur??cio Cardoso
10145	343	Esperan??a do Sul
10146	343	Horizontina
10147	343	Miragua??
10148	343	Nova Candel??ria
10149	343	Redentora
10150	343	S??o Martinho
10151	343	Sede Nova
10152	343	Tenente Portela
10153	343	Tiradentes do Sul
10154	343	Tr??s Passos
10155	343	Vista Ga??cha
10156	343	Arroio Grande
10157	343	Herval
10158	343	Jaguar??o
10159	343	Chu??
10160	343	Rio Grande
10161	343	Santa Vit??ria do Palmar
10162	343	S??o Jos?? do Norte
10163	343	Arroio do Padre
10164	343	Cangu??u
10165	343	Cap??o do Le??o
10166	343	Cerrito
10167	343	Cristal
10168	343	Morro Redondo
10169	343	Pedro Os??rio
10170	343	Pelotas
10171	343	S??o Louren??o do Sul
10172	343	Turu??u
10173	343	Amaral Ferrador
10174	343	Ca??apava do Sul
10175	343	Candiota
10176	343	Encruzilhada do Sul
10177	343	Pedras Altas
10178	343	Pinheiro Machado
10179	343	Piratini
10180	343	Santana da Boa Vista
10181	343	Ros??rio do Sul
10182	343	Santa Margarida do Sul
10183	343	Santana do Livramento
10184	343	Acegu??
10185	343	Bag??
10186	343	Dom Pedrito
10187	343	Hulha Negra
10188	343	Lavras do Sul
10189	343	Alegrete
10190	343	Barra do Quara??
10191	343	Garruchos
10192	343	Itaqui
10193	343	Ma??ambara
10194	343	Manoel Viana
10195	343	S??o Borja
10196	343	S??o Francisco de Assis
10197	343	Uruguaiana
10198	343	Quara??
10199	344	Alta Floresta d'Oeste
10200	344	Alto Alegre de los Parecis
10201	344	Alvorada d'Oeste
10202	344	Ariquemes
10203	344	Cabixi
10204	344	Cacaul??ndia
10205	344	Cacoal
10206	344	Campo Nuevo de Rondonia
10207	344	Candeias del Jamari
10208	344	Castanheiras
10209	344	Cerejeiras
10210	344	Chupinguaia
10211	344	Colorado del Oeste
10212	344	Corumbiara
10213	344	Costa Marques
10214	344	Cujubim
10215	344	Espig??o d'Oeste
10216	344	Extrema de Rondonia
10217	344	Gobernador Jorge Teixeira
10218	344	Guajar??-Mirim
10219	344	Itapu?? del Oeste
10220	344	Jaru
10221	344	Ji-Paran??
10222	344	Machadinho d'Oeste
10223	344	Ministro Andreazza
10224	344	Mirante de la Sierra
10225	344	Monte Negro
10226	344	Nueva Brasil??ndia d'Oeste
10227	344	Nueva Mamor??
10228	344	Nueva Uni??n
10229	344	Novo Horizonte del Oeste
10230	344	Oro Negro del Oeste
10231	344	Parecis
10232	344	Pimenta Bueno
10233	344	Pimenteiras del Oeste
10234	344	Puerto Velho
10235	344	Primavera de Rondonia
10236	344	R??o Crespo
10237	344	Rolim de Moura
10238	344	Santa Luzia d'Oeste
10239	344	Son Felipe d'Oeste
10240	344	S??o Francisco del Guapor??
10241	344	S??o Miguel del Guapor??
10242	344	Seringueiras
10243	344	Teixeir??polis
10244	344	Theobroma
10245	344	Urup??
10246	344	Valle del Anari
10247	344	Valle del Para??so
10248	344	Vilhena
10249	345	Amajari
10250	345	Boa Vista??(capital estatal)
10251	345	Pacaraima
10252	345	Cant??
10253	345	Normandia
10254	345	Uiramut??
10255	345	Caracara??
10256	345	Mucaja??
10257	345	Caroebe
10258	345	Rorain??polis
10259	345	S??o Jo??o da Baliza
10260	346	Bigua??u
10261	346	Florian??polis??(capital estatal)
10262	346	Governador Celso Ramos
10263	346	Palho??a
10264	346	Paulo Lopes
10265	346	Santo Amaro da Imperatriz
10266	346	S??o Jos??
10267	346	S??o Pedro de Alc??ntara
10268	346	??guas Mornas
10269	346	Alfredo Wagner
10270	346	Anit??polis
10271	346	Rancho Queimado
10272	346	S??o Bonif??cio
10273	346	Angelina
10274	346	Canelinha
10275	346	Leoberto Leal
10276	346	Major Gercino
10277	346	Nova Trento
10278	346	Tijucas
10279	346	Bela Vista do Toldo
10280	346	Canoinhas
10281	346	Irine??polis
10282	346	Itai??polis
10283	346	Mafra
10284	346	Major Vieira
10285	346	Monte Castelo
10286	346	Papanduva
10287	346	Porto Uni??o
10288	346	Timb?? Grande
10289	346	Tr??s Barras
10290	346	Araquari??(antes, Paraty)
10291	346	Balne??rio Barra do Sul
10292	346	Corup??
10293	346	Garuva
10294	346	Guaramirim
10295	346	Itapo??
10296	346	Jaragu?? do Sul
10297	346	Joinville
10298	346	S??o Francisco do Sul
10299	346	Schroeder
10300	346	Rio Negrinho
10301	346	S??o Bento do Sul
10302	346	??guas de Chapec??
10303	346	??guas Frias
10304	346	Bom Jesus do Oeste
10305	346	Caibi
10306	346	Campo Er??
10307	346	Caxambu do Sul
10308	346	Chapec??
10309	346	Cordilheira Alta
10310	346	Coronel Freitas
10311	346	Cunha Por??
10312	346	Cunhata??
10313	346	Flor do Sert??o
10314	346	Formosa do Sul
10315	346	Guatamb??
10316	346	Iraceminha
10317	346	Jardin??polis
10318	346	Modelo
10319	346	Nova Erechim
10320	346	Nova Itaberaba
10321	346	Palmitos
10322	346	Pinhalzinho
10323	346	Planalto Alegre
10324	346	Quilombo
10325	346	Saltinho
10326	346	Santa Terezinha do Progresso
10327	346	Santiago do Sul
10328	346	S??o Bernardino
10329	346	S??o Carlos
10330	346	S??o Louren??o do Oeste
10331	346	S??o Miguel da Boa Vista
10332	346	Saudades
10333	346	Serra Alta
10334	346	Sul Brasil
10335	346	Tigrinhos
10336	346	Uni??o do Oeste
10337	346	Alto Bela Vista
10338	346	Arabut??
10339	346	Arvoredo
10340	346	Conc??rdia
10341	346	Ipira
10342	346	Ipumirim
10343	346	Irani
10344	346	It??
10345	346	Lind??ia do Sul
10346	346	Paial
10347	346	Peritiba
10348	346	Piratuba
10349	346	Presidente Castelo Branco??(antes, Dois Irm??os)
10350	346	Seara
10351	346	Xavantina
10352	346	??gua Doce
10353	346	Arroio Trinta
10354	346	Ca??ador
10355	346	Calmon
10356	346	Capinzal
10357	346	Erval Velho
10358	346	Fraiburgo
10359	346	Herval d???Oeste
10360	346	Ibiam
10361	346	Ibicar??
10362	346	Iomer??
10363	346	Jabor??
10364	346	Joa??aba??(antes, Cruzeiro)
10365	346	Lacerd??polis
10366	346	Lebon R??gis
10367	346	Luzerna
10368	346	Macieira
10369	346	Matos Costa
10370	346	Ouro
10371	346	Pinheiro Preto
10372	346	Rio das Antas
10373	346	Salto Veloso
10374	346	Treze T??lias
10375	346	Videira
10376	346	Bandeirante
10377	346	Barra Bonita
10378	346	Descanso
10379	346	Dion??sio Cerqueira
10380	346	Guaruj?? do Sul
10381	346	Ipor?? do Oeste
10382	346	Monda??
10383	346	Palma Sola
10384	346	Para??so
10385	346	Princesa
10386	346	Riqueza
10387	346	Romel??ndia
10388	346	S??o Jo??o do Oeste
10389	346	S??o Jos?? do Cedro
10390	346	S??o Miguel do Oeste
10391	346	Tun??polis
10392	346	Abelardo Luz
10393	346	Coronel Martins
10394	346	Faxinal dos Guedes
10395	346	Galv??o
10396	346	Ipua??u
10397	346	Jupi??
10398	346	Lajeado Grande
10399	346	Marema
10400	346	Ouro Verde
10401	346	Passos Maia
10402	346	Ponte Serrada
10403	346	Varge??o
10404	346	Xanxer??
10405	346	Xaxim
10406	346	Anita Garibaldi
10407	346	Bocaina do Sul
10408	346	Bom Jardim da Serra
10409	346	Bom Retiro
10410	346	Campo Belo do Sul
10411	346	Cap??o Alto
10412	346	Celso Ramos
10413	346	Cerro Negro
10414	346	Correia Pinto
10415	346	Lages
10416	346	Otac??lio Costa
10417	346	Painel
10418	346	Rio Rufino
10419	346	S??o Joaquim
10420	346	S??o Jos?? do Cerrito
10421	346	Urubici
10422	346	Urupema
10423	346	Abdon Batista
10424	346	Brun??polis
10425	346	Campos Novos
10426	346	Curitibanos
10427	346	Frei Rog??rio
10428	346	Monte Carlo
10429	346	Ponte Alta
10430	346	Ponte Alta do Norte
10431	346	S??o Crist??v??o do Sul
10432	346	Vargem
10433	346	Zort??a
10434	346	Ararangu??
10435	346	Balne??rio Arroio do Silva
10436	346	Balne??rio Gaivota
10437	346	Ermo
10438	346	Jacinto Machado
10439	346	Maracaj??
10440	346	Meleiro
10441	346	Morro Grande
10442	346	Passo de Torres
10443	346	Praia Grande
10444	346	Santa Rosa do Sul
10445	346	S??o Jo??o do Sul
10446	346	Sombrio
10447	346	Timb?? do Sul
10448	346	Balne??rio Rinc??o??(ser?? mplantado en enero de 2013)
10449	346	Cocal do Sul
10450	346	Crici??ma
10451	346	Forquilhinha
10452	346	I??ara
10453	346	Lauro M??ller
10454	346	Morro da Fuma??a
10455	346	Sider??polis
10456	346	Treviso
10457	346	Urussanga
10458	346	Armaz??m
10459	346	Bra??o do Norte
10460	346	Capivari de Baixo
10461	346	Garopaba
10462	346	Gr??o Par??
10463	346	Gravatal
10464	346	Imaru??
10465	346	Imbituba??(antes, Henrique Lage)
10466	346	Jaguaruna
10467	346	Laguna
10468	346	Orleans
10469	346	Pedras Grandes
10470	346	Pescaria Brava??ser?? mplantado en enero de 2013)
10471	346	Rio Fortuna
10472	346	Sang??o
10473	346	Santa Rosa de Lima
10474	346	S??o Ludgero??(antes, S??o Ludig??ro)
10475	346	Treze de Maio
10476	346	Tubar??o
10477	346	Api??na
10478	346	Ascurra
10479	346	Benedito Novo
10480	346	Blumenau
10481	346	Botuver??
10482	346	Brusque
10483	346	Doutor Pedrinho
10484	346	Gaspar
10485	346	Guabiruba
10486	346	Indaial
10487	346	Luiz Alves
10488	346	Pomerode
10489	346	Rio dos Cedros
10490	346	Rodeio
10491	346	Timb??
10492	346	Balne??rio Cambori??
10493	346	Barra Velha
10494	346	Bombinhas
10495	346	Cambori??
10496	346	Ilhota
10497	346	Itaja??
10498	346	Itapema
10499	346	Navegantes
10500	346	Penha
10501	346	Balne??rio Pi??arras
10502	346	Porto Belo
10503	346	S??o Jo??o do Itaperi??
10504	346	Agrol??ndia
10505	346	Atalanta
10506	346	Chapad??o do Lageado
10507	346	Imbuia
10508	346	Ituporanga
10509	346	Vidal Ramos
10510	346	Agron??mica
10511	346	Bra??o do Trombudo
10512	346	Dona Emma
10513	346	Ibirama
10514	346	Jos?? Boiteux
10515	346	Laurentino
10516	346	Lontras
10517	346	Mirim Doce
10518	346	Pouso Redondo
10519	346	Presidente Get??lio
10520	346	Presidente Nereu
10521	346	Rio do Campo
10522	346	Rio do Oeste
10523	346	Rio do Sul
10524	346	Salete
10525	346	Tai??
10526	346	Trombudo Central
10527	346	Vitor Meireles
10528	346	Witmarsum
10529	347	Amparo de S??o Francisco
10530	347	Aquidab??
10531	347	Aracaju
10532	347	Arau??
10533	347	Barra dos Coqueiros
10534	347	Boquim
10535	347	Brejo Grande
10536	347	Campo do Brito
10537	347	Canhoba
10538	347	Canind?? de S??o Francisco
10539	347	Carira
10540	347	Carm??polis
10541	347	Cedro de S??o Jo??o
10542	347	Cristin??polis
10543	347	Cumbe
10544	347	Divina Pastora
10545	347	Est??ncia
10546	347	Frei Paulo
10547	347	Gararu
10548	347	General Maynard
10549	347	Graccho Cardoso
10550	347	Ilha das Flores
10551	347	Indiaroba
10552	347	Itabaianinha
10553	347	Itabi
10554	347	Itaporanga d'Ajuda
10555	347	Japaratuba
10556	347	Japoat??
10557	347	Lagarto
10558	347	Laranjeiras
10559	347	Macambira
10560	347	Malhada dos Bois
10561	347	Malhador
10562	347	Maruim
10563	347	Moita Bonita
10564	347	Monte Alegre de Sergipe
10565	347	Muribeca
10566	347	Ne??polis
10567	347	Nossa Senhora Aparecida
10568	347	Nossa Senhora da Gl??ria
10569	347	Nossa Senhora das Dores
10570	347	Nossa Senhora de Lourdes
10571	347	Nossa Senhora do Socorro
10572	347	Pedra Mole
10573	347	Pedrinhas
10574	347	Pirambu
10575	347	Po??o Redondo
10576	347	Po??o Verde
10577	347	Porto da Folha
10578	347	Propri??
10579	347	Riach??o do Dantas
10580	347	Ribeir??polis
10581	347	Ros??rio do Catete
10582	347	Salgado
10583	347	Santa Luzia do Itanhy
10584	347	Santana do S??o Francisco
10585	347	Santo Amaro das Brotas
10586	347	S??o Crist??v??o
10587	347	S??o Miguel do Aleixo
10588	347	Sim??o Dias
10589	347	Siriri
10590	347	Telha
10591	347	Tobias Barreto
10592	347	Tomar do Geru
10593	347	Umba??ba
10594	348	Abreul??ndia
10595	348	Aguiarn??polis
10596	348	Alian??a do Tocantins
10597	348	Almas
10598	348	Anan??s
10599	348	Angico
10600	348	Aparecida do Rio Negro
10601	348	Aragominas
10602	348	Araguacema
10603	348	Aragua??u
10604	348	Aragua??na
10605	348	Araguatins
10606	348	Arapoema
10607	348	Arraias
10608	348	Augustin??polis
10609	348	Aurora do Tocantins
10610	348	Axix?? do Tocantins
10611	348	Baba??ul??ndia
10612	348	Bandeirantes do Tocantins
10613	348	Barra do Ouro
10614	348	Barrol??ndia
10615	348	Bernardo Say??o
10616	348	Brasil??ndia do Tocantins
10617	348	Brejinho de Nazar??
10618	348	Buriti do Tocantins
10619	348	Campos Lindos
10620	348	Cariri do Tocantins
10621	348	Carmol??ndia
10622	348	Carrasco Bonito
10623	348	Caseara
10624	348	Chapada da Natividade
10625	348	Chapada de Areia
10626	348	Colinas do Tocantins
10627	348	Colm??ia
10628	348	Combinado
10629	348	Concei????o do Tocantins
10630	348	Couto de Magalh??es
10631	348	Cristal??ndia
10632	348	Crix??s do Tocantins
10633	348	Darcin??polis
10634	348	Dian??polis
10635	348	Divin??polis do Tocantins
10636	348	Dois Irm??os do Tocantins
10637	348	Duer??
10638	348	Figueir??polis
10639	348	Formoso do Araguaia
10640	348	Fortaleza do Taboc??o
10641	348	Goianorte
10642	348	Goiatins
10643	348	Guara??
10644	348	Gurupi
10645	348	Itacaj??
10646	348	Itaguatins
10647	348	Itapiratins
10648	348	Itapor?? do Tocantins
10649	348	Ja?? do Tocantins
10650	348	Juarina
10651	348	Lagoa da Confus??o
10652	348	Lagoa do Tocantins
10653	348	Lajeado (Tocantins)
10654	348	Lavandeira
10655	348	Lizarda
10656	348	Luzin??polis
10657	348	Marian??polis do Tocantins
10658	348	Mateiros
10659	348	Mauril??ndia do Tocantins
10660	348	Miracema do Tocantins
10661	348	Miranorte
10662	348	Monte do Carmo
10663	348	Monte Santo do Tocantins
10664	348	Muricil??ndia
10665	348	Nova Rosal??ndia
10666	348	Novo Acordo
10667	348	Novo Alegre
10668	348	Novo Jardim
10669	348	Oliveira de F??tima
10670	348	Palmeirante
10671	348	Palmeiras do Tocantins
10672	348	Palmeir??polis
10673	348	Para??so do Tocantins
10674	348	Paran??
10675	348	Pedro Afonso
10676	348	Peixe
10677	348	Pequizeiro
10678	348	Pindorama do Tocantins
10679	348	Piraqu??
10680	348	Pium
10681	348	Ponte Alta do Bom Jesus
10682	348	Ponte Alta do Tocantins
10683	348	Porto Alegre do Tocantins
10684	348	Porto Nacional
10685	348	Praia Norte
10686	348	Pugmil
10687	348	Recursol??ndia
10688	348	Rio da Concei????o
10689	348	Rio dos Bois
10690	348	Rio Sono
10691	348	Sampaio
10692	348	Sandol??ndia
10693	348	Santa F?? do Araguaia
10694	348	Santa Maria do Tocantins
10695	348	Santa Rita do Tocantins
10696	348	Santa Rosa do Tocantins
10697	348	Santa Tereza do Tocantins
10698	348	Santa Terezinha do Tocantins
10699	348	S??o Bento do Tocantins
10700	348	S??o F??lix do Tocantins
10701	348	S??o Miguel do Tocantins
10702	348	S??o Salvador do Tocantins
10703	348	S??o Sebasti??o do Tocantins
10704	348	S??o Val??rio da Natividade
10705	348	Silvan??polis
10706	348	S??tio Novo do Tocantins
10707	348	Sucupira
10708	348	Taquaru??u do Porto
10709	348	Taipas do Tocantins
10710	348	Talism??
10711	348	Tocant??nia
10712	348	Tocantin??polis
10713	348	Tupirama
10714	348	Tupiratins
10715	348	Wanderl??ndia
10716	348	Xambio??
10717	349	Adamantina
10718	349	Adolfo
10719	349	Agua??
10720	349	??guas da Prata
10721	349	??guas de Lind??ia
10722	349	??guas de Santa B??rbara
10723	349	??guas de S??o Pedro
10724	349	Agudos
10725	349	Alambari
10726	349	Alfredo Marcondes
10727	349	Altair
10728	349	Altin??polis
10729	349	Alum??nio
10730	349	??lvares Florence
10731	349	??lvares Machado
10732	349	??lvaro de Carvalho
10733	349	Alvinl??ndia
10734	349	Americana
10735	349	Am??rico Brasiliense
10736	349	Am??rico de Campos
10737	349	Anal??ndia
10738	349	Andradina
10739	349	Angatuba
10740	349	Anhembi
10741	349	Anhumas
10742	349	Aparecida D??oeste
10743	349	Apia??
10744	349	Ara??ariguama
10745	349	Ara??atuba
10746	349	Ara??oiaba da Serra
10747	349	Aramina
10748	349	Arandu
10749	349	Arape??
10750	349	Araraquara
10751	349	Araras
10752	349	Arco-??ris
10753	349	Arealva
10754	349	Areias
10755	349	Arei??polis
10756	349	Ariranha
10757	349	Artur Nogueira
10758	349	Aruj??
10759	349	Asp??sia
10760	349	Assis
10761	349	Atibaia
10762	349	Auriflama
10763	349	Ava??
10764	349	Avanhandava
10765	349	Avar??
10766	349	Bady Bassitt
10767	349	Balbinos
10768	349	B??lsamo
10769	349	Bananal
10770	349	Bar??o de Antonina
10771	349	Barbosa
10772	349	Bariri
10773	349	Barra do Chap??u
10774	349	Barra do Turvo
10775	349	Barretos
10776	349	Barrinha
10777	349	Barueri
10778	349	Bastos
10779	349	Batatais
10780	349	Bauru
10781	349	Bebedouro
10782	349	Bento de Abreu
10783	349	Bernardino de Campos
10784	349	Bertioga
10785	349	Bilac
10786	349	Birigui
10787	349	Biritiba-mirim
10788	349	Boa Esperan??a do Sul
10789	349	Bofete
10790	349	Boituva
10791	349	Bom Jesus Dos Perd??es
10792	349	Bom Sucesso de Itarar??
10793	349	Bor??
10794	349	Borac??ia
10795	349	Borebi
10796	349	Botucatu
10797	349	Bragan??a Paulista
10798	349	Bra??na
10799	349	Brejo Alegre
10800	349	Brodowski
10801	349	Brotas
10802	349	Buri
10803	349	Buritama
10804	349	Buritizal
10805	349	Cabr??lia Paulista
10806	349	Cabre??va
10807	349	Ca??apava
10808	349	Cachoeira Paulista
10809	349	Caconde
10810	349	Caiabu
10811	349	Caieiras
10812	349	Caiu??
10813	349	Cajamar
10814	349	Cajati
10815	349	Cajobi
10816	349	Cajuru
10817	349	Campina do Monte Alegre
10818	349	Campinas
10819	349	Campo Limpo Paulista
10820	349	Campos do Jord??o
10821	349	Campos Novos Paulista
10822	349	Canan??ia
10823	349	Canas
10824	349	C??ndido Mota
10825	349	C??ndido Rodrigues
10826	349	Canitar
10827	349	Cap??o Bonito
10828	349	Capela do Alto
10829	349	Capivari
10830	349	Caraguatatuba
10831	349	Carapicu??ba
10832	349	Cardoso
10833	349	Casa Branca
10834	349	C??ssia Dos Coqueiros
10835	349	Castilho
10836	349	Catanduva
10837	349	Catigu??
10838	349	Cerqueira C??sar
10839	349	Cerquilho
10840	349	Ces??rio Lange
10841	349	Charqueada
10842	349	Clementina
10843	349	Colina
10844	349	Col??mbia
10845	349	Conchal
10846	349	Conchas
10847	349	Cordeir??polis
10848	349	Coroados
10849	349	Coronel Macedo
10850	349	Corumbata??
10851	349	Cosm??polis
10852	349	Cosmorama
10853	349	Cotia
10854	349	Cravinhos
10855	349	Cristais Paulista
10856	349	Cruz??lia
10857	349	Cubat??o
10858	349	Cunha
10859	349	Descalvado
10860	349	Diadema
10861	349	Dirce Reis
10862	349	Divinol??ndia
10863	349	Dobrada
10864	349	Dois C??rregos
10865	349	Dolcin??polis
10866	349	Dourado
10867	349	Dracena
10868	349	Duartina
10869	349	Dumont
10870	349	Echapor??
10871	349	Elias Fausto
10872	349	Elisi??rio
10873	349	Emba??ba
10874	349	Embu
10875	349	Embu-gua??u
10876	349	Emilian??polis
10877	349	Engenheiro Coelho
10878	349	Esp??rito Santo do Pinhal
10879	349	Esp??rito Santo do Turvo
10880	349	Estrela D??oeste
10881	349	Euclides da Cunha Paulista
10882	349	Fartura
10883	349	Fernand??polis
10884	349	Fernando Prestes
10885	349	Fern??o
10886	349	Ferraz de Vasconcelos
10887	349	Flora Rica
10888	349	Floreal
10889	349	Fl??rida Paulista
10890	349	Flor??nia
10891	349	Franca
10892	349	Francisco Morato
10893	349	Franco da Rocha
10894	349	Gabriel Monteiro
10895	349	G??lia
10896	349	Gar??a
10897	349	Gast??o Vidigal
10898	349	Gavi??o Peixoto
10899	349	General Salgado
10900	349	Getulina
10901	349	Glic??rio
10902	349	Guai??ara
10903	349	Guaimb??
10904	349	Guapia??u
10905	349	Guapiara
10906	349	Guara??a??
10907	349	Guarani D??oeste
10908	349	Guarant??
10909	349	Guararapes
10910	349	Guararema
10911	349	Guaratinguet??
10912	349	Guare??
10913	349	Guariba
10914	349	Guaruj??
10915	349	Guarulhos
10916	349	Guatapar??
10917	349	Guzol??ndia
10918	349	Hercul??ndia
10919	349	Holambra
10920	349	Hortol??ndia
10921	349	Iacanga
10922	349	Iacri
10923	349	Iaras
10924	349	Ibat??
10925	349	Ibir??
10926	349	Ibirarema
10927	349	Ibitinga
10928	349	Ibi??na
10929	349	Ic??m
10930	349	Iep??
10931	349	Igara??u do Tiet??
10932	349	Igarapava
10933	349	Igarat??
10934	349	Iguape
10935	349	Ilhabela
10936	349	Ilha Comprida
10937	349	Ilha Solteira
10938	349	Indaiatuba
10939	349	Indiana
10940	349	Indiapor??
10941	349	In??bia Paulista
10942	349	Ipaussu
10943	349	Iper??
10944	349	Ipe??na
10945	349	Ipigu??
10946	349	Iporanga
10947	349	Ipu??
10948	349	Iracem??polis
10949	349	Irapu??
10950	349	Irapuru
10951	349	Itaber??
10952	349	Ita??
10953	349	Itajobi
10954	349	Itaju
10955	349	Itanha??m
10956	349	Ita??ca
10957	349	Itapecerica da Serra
10958	349	Itapetininga
10959	349	Itapevi
10960	349	Itapira
10961	349	Itapirapu?? Paulista
10962	349	It??polis
10963	349	Itapu??
10964	349	Itapura
10965	349	Itaquaquecetuba
10966	349	Itarar??
10967	349	Itariri
10968	349	Itatiba
10969	349	Itatinga
10970	349	Itirapina
10971	349	Itirapu??
10972	349	Itobi
10973	349	Itu
10974	349	Itupeva
10975	349	Ituverava
10976	349	Jaboticabal
10977	349	Jacare??
10978	349	Jaci
10979	349	Jacupiranga
10980	349	Jaguari??na
10981	349	Jales
10982	349	Jambeiro
10983	349	Jandira
10984	349	Jarinu
10985	349	Ja??
10986	349	Jeriquara
10987	349	Joan??polis
10988	349	Jo??o Ramalho
10989	349	Jos?? Bonif??cio
10990	349	J??lio Mesquita
10991	349	Jumirim
10992	349	Jundia??
10993	349	Junqueir??polis
10994	349	Juqui??
10995	349	Juquitiba
10996	349	Lagoinha
10997	349	Laranjal Paulista
10998	349	Lav??nia
10999	349	Lavrinhas
11000	349	Leme
11001	349	Len????is Paulista
11002	349	Limeira
11003	349	Lind??ia
11004	349	Lins
11005	349	Lorena
11006	349	Lourdes
11007	349	Louveira
11008	349	Luc??lia
11009	349	Lucian??polis
11010	349	Lu??s Ant??nio
11011	349	Luizi??nia
11012	349	Lup??rcio
11013	349	Lut??cia
11014	349	Macatuba
11015	349	Macaubal
11016	349	Maced??nia
11017	349	Magda
11018	349	Mairinque
11019	349	Mairipor??
11020	349	Manduri
11021	349	Marab?? Paulista
11022	349	Maraca??
11023	349	Marapoama
11024	349	Mari??polis
11025	349	Mar??lia
11026	349	Marin??polis
11027	349	Martin??polis
11028	349	Mat??o
11029	349	Mau??
11030	349	Mendon??a
11031	349	Meridiano
11032	349	Mes??polis
11033	349	Miguel??polis
11034	349	Mineiros do Tiet??
11035	349	Miracatu
11036	349	Mira Estrela
11037	349	Mirand??polis
11038	349	Mirante do Paranapanema
11039	349	Mirassol
11040	349	Mirassol??ndia
11041	349	Mococa
11042	349	Moji Das Cruzes
11043	349	Mogi Gua??u
11044	349	Moji-mirim
11045	349	Mombuca
11046	349	Mon????es
11047	349	Mongagu??
11048	349	Monte Alegre do Sul
11049	349	Monte Alto
11050	349	Monte Apraz??vel
11051	349	Monte Azul Paulista
11052	349	Monteiro Lobato
11053	349	Monte Mor
11054	349	Morro Agudo
11055	349	Morungaba
11056	349	Motuca
11057	349	Murutinga do Sul
11058	349	Nantes
11059	349	Narandiba
11060	349	Natividade da Serra
11061	349	Nazar?? Paulista
11062	349	Neves Paulista
11063	349	Nhandeara
11064	349	Nipo??
11065	349	Nova Alian??a
11066	349	Nova Campina
11067	349	Nova Cana?? Paulista
11068	349	Nova Castilho
11069	349	Nova Europa
11070	349	Nova Granada
11071	349	Nova Guataporanga
11072	349	Nova Independ??ncia
11073	349	Novais
11074	349	Nova Luzit??nia
11075	349	Nova Odessa
11076	349	Nuporanga
11077	349	Ocau??u
11078	349	??leo
11079	349	Ol??mpia
11080	349	Onda Verde
11081	349	Oriente
11082	349	Orindi??va
11083	349	Orl??ndia
11084	349	Osasco
11085	349	Oscar Bressane
11086	349	Osvaldo Cruz
11087	349	Ourinhos
11088	349	Ouroeste
11089	349	Pacaembu
11090	349	Palmares Paulista
11091	349	Palmeira D??oeste
11092	349	Panorama
11093	349	Paragua??u Paulista
11094	349	Paraibuna
11095	349	Paranapanema
11096	349	Paranapu??
11097	349	Parapu??
11098	349	Pardinho
11099	349	Pariquera-a??u
11100	349	Parisi
11101	349	Patroc??nio Paulista
11102	349	Paulic??ia
11103	349	Paul??nia
11104	349	Paulist??nia
11105	349	Paulo de Faria
11106	349	Pederneiras
11107	349	Pedra Bela
11108	349	Pedran??polis
11109	349	Pedregulho
11110	349	Pedreira
11111	349	Pedrinhas Paulista
11112	349	Pedro de Toledo
11113	349	Pen??polis
11114	349	Pereira Barreto
11115	349	Pereiras
11116	349	Peru??be
11117	349	Piacatu
11118	349	Piedade
11119	349	Pilar do Sul
11120	349	Pindamonhangaba
11121	349	Pindorama
11122	349	Piquerobi
11123	349	Piquete
11124	349	Piracaia
11125	349	Piracicaba
11126	349	Piraju
11127	349	Piraju??
11128	349	Pirangi
11129	349	Pirapora do Bom Jesus
11130	349	Pirapozinho
11131	349	Pirassununga
11132	349	Piratininga
11133	349	Platina
11134	349	Po??
11135	349	Poloni
11136	349	Pomp??ia
11137	349	Ponga??
11138	349	Pontal
11139	349	Pontalinda
11140	349	Pontes Gestal
11141	349	Populina
11142	349	Porangaba
11143	349	Porto Feliz
11144	349	Porto Ferreira
11145	349	Potim
11146	349	Potirendaba
11147	349	Pracinha
11148	349	Prad??polis
11149	349	Prat??nia
11150	349	Presidente Alves
11151	349	Presidente Epit??cio
11152	349	Presidente Prudente
11153	349	Presidente Venceslau
11154	349	Promiss??o
11155	349	Quadra
11156	349	Quat??
11157	349	Queiroz
11158	349	Queluz
11159	349	Quintana
11160	349	Rafard
11161	349	Rancharia
11162	349	Reden????o da Serra
11163	349	Regente Feij??
11164	349	Regin??polis
11165	349	Registro
11166	349	Restinga
11167	349	Ribeira
11168	349	Ribeir??o Bonito
11169	349	Ribeir??o Branco
11170	349	Ribeir??o Corrente
11171	349	Ribeir??o do Sul
11172	349	Ribeir??o Dos ??ndios
11173	349	Ribeir??o Grande
11174	349	Ribeir??o Pires
11175	349	Ribeir??o Preto
11176	349	Riversul
11177	349	Rifaina
11178	349	Rinc??o
11179	349	Rin??polis
11180	349	Rio Claro
11181	349	Rio Das Pedras
11182	349	Rio Grande da Serra
11183	349	Riol??ndia
11184	349	Rosana
11185	349	Roseira
11186	349	Rubi??cea
11187	349	Rubin??ia
11188	349	Sabino
11189	349	Sagres
11190	349	Sales
11191	349	Sales Oliveira
11192	349	Sales??polis
11193	349	Salmour??o
11194	349	Salto
11195	349	Salto de Pirapora
11196	349	Salto Grande
11197	349	Sandovalina
11198	349	Santa Ad??lia
11199	349	Santa Albertina
11200	349	Santa B??rbara D??oeste
11201	349	Santa Branca
11202	349	Santa Clara D??oeste
11203	349	Santa Cruz da Concei????o
11204	349	Santa Cruz da Esperan??a
11205	349	Santa Cruz Das Palmeiras
11206	349	Santa Cruz do Rio Pardo
11207	349	Santa Ernestina
11208	349	Santa f?? do Sul
11209	349	Santa Gertrudes
11210	349	Santa Maria da Serra
11211	349	Santa Mercedes
11212	349	Santana da Ponte Pensa
11213	349	Santana de Parna??ba
11214	349	Santa Rita D??oeste
11215	349	Santa Rita do Passa Quatro
11216	349	Santa Rosa de Viterbo
11217	349	Santa Salete
11218	349	Santo Anast??cio
11219	349	Santo Ant??nio da Alegria
11220	349	Santo Ant??nio de Posse
11221	349	Santo Ant??nio do Aracangu??
11222	349	Santo Ant??nio do Jardim
11223	349	Santo Ant??nio do Pinhal
11224	349	Santo Expedito
11225	349	Sant??polis do Aguape??
11226	349	Santos
11227	349	S??o Bento do Sapuca??
11228	349	S??o Bernardo do Campo
11229	349	S??o Caetano do Sul
11230	349	S??o Jo??o da Boa Vista
11231	349	S??o Jo??o Das Duas Pontes
11232	349	S??o Jo??o de Iracema
11233	349	S??o Jo??o do Pau D??alho
11234	349	S??o Joaquim da Barra
11235	349	S??o Jos?? da Bela Vista
11236	349	S??o Jos?? do Barreiro
11237	349	S??o Jos?? do Rio Pardo
11238	349	S??o Jos?? do Rio Preto
11239	349	S??o Jos?? Dos Campos
11240	349	S??o Louren??o da Serra
11241	349	S??o Lu??s do Paraitinga
11242	349	S??o Manuel
11243	349	S??o Miguel Arcanjo
11244	349	S??o Paulo
11245	349	S??o Pedro do Turvo
11246	349	S??o Roque
11247	349	S??o Sebasti??o da Grama
11248	349	Sarapu??
11249	349	Sarutai??
11250	349	Sebastian??polis do Sul
11251	349	Serra Azul
11252	349	Serrana
11253	349	Serra Negra
11254	349	Sete Barras
11255	349	Sever??nia
11256	349	Silveiras
11257	349	Socorro
11258	349	Sorocaba
11259	349	Sud Mennucci
11260	349	Sumar??
11261	349	Suzano
11262	349	Suzan??polis
11263	349	Tabapu??
11264	349	Tabo??o da Serra
11265	349	Taciba
11266	349	Tagua??
11267	349	Taia??u
11268	349	Tai??va
11269	349	Tamba??
11270	349	Tanabi
11271	349	Tapiratiba
11272	349	Taquaral
11273	349	Taquaritinga
11274	349	Taquarituba
11275	349	Taquariva??
11276	349	Tarabai
11277	349	Tarum??
11278	349	Tatu??
11279	349	Taubat??
11280	349	Tejup??
11281	349	Tiet??
11282	349	Timburi
11283	349	Torre de Pedra
11284	349	Torrinha
11285	349	Trabiju
11286	349	Trememb??
11287	349	Tr??s Fronteiras
11288	349	Tuiuti
11289	349	Tup??
11290	349	Tupi Paulista
11291	349	Turi??ba
11292	349	Ubarana
11293	349	Ubatuba
11294	349	Ubirajara
11295	349	Uchoa
11296	349	Uni??o Paulista
11297	349	Ur??nia
11298	349	Uru
11299	349	Urup??s
11300	349	Valentim Gentil
11301	349	Valinhos
11302	349	Valpara??so
11303	349	Vargem Grande do Sul
11304	349	Vargem Grande Paulista
11305	349	V??rzea Paulista
11306	349	Vinhedo
11307	349	Viradouro
11308	349	Vista Alegre do Alto
11309	349	Vit??ria Brasil
11310	349	Votorantim
11311	349	Votuporanga
11312	349	Zacarias
11313	349	Chavantes
0	0	No Determinado
\.


--
-- TOC entry 2627 (class 0 OID 33571)
-- Dependencies: 260
-- Data for Name: tipocargo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipocargo (idtipocargo, descripcion, posee_nivel) FROM stdin;
2	OFICIAL	S
1	MINISTERIAL	N
\.


--
-- TOC entry 2629 (class 0 OID 33578)
-- Dependencies: 262
-- Data for Name: tipoconstruccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipoconstruccion (idtipoconstruccion, descripcion) FROM stdin;
1	Adobe
2	Ladrillos
3	Madera
\.


--
-- TOC entry 2600 (class 0 OID 33463)
-- Dependencies: 230
-- Data for Name: tipodoc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipodoc (idtipodoc, descripcion) FROM stdin;
4	Pasaporte
6	Otros
2	Certificado de Nacimiento
3	Carnet Extranjeria
5	Tarjeta de Servicio Militar
0	No Determinado
1	Documento de Identidad (DNI, C??dula de Identidad)
\.


--
-- TOC entry 2632 (class 0 OID 33586)
-- Dependencies: 265
-- Data for Name: tipodocumentacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipodocumentacion (idtipodocumentacion, descripcion) FROM stdin;
1	Documento Privado
2	En Tramite
3	Juez
4	Minuta de Compra Venta
5	No Tiene
6	Notaria
7	Simple
8	Alquilado
9	SUNARP
\.


--
-- TOC entry 2634 (class 0 OID 33592)
-- Dependencies: 267
-- Data for Name: tipoinmueble; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipoinmueble (idtipoinmueble, descripcion) FROM stdin;
1	Terreno
2	Templo
3	Alquiler
4	En Uso
5	Templo y Casa Misi??n
6	Casa Misi??n
\.


--
-- TOC entry 2636 (class 0 OID 33598)
-- Dependencies: 269
-- Data for Name: trimestre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trimestre (idtrimestre, descripcion, fechainicial, fechafinal, nrosemanas) FROM stdin;
1	Primer Trimestre	01/01	31/03	13
2	Segundo Trimestre	01/04	30/06	13
3	Tercer Trimestre	01/07	30/09	13
4	Cuarto Trimestre	01/10	31/12	13
\.


--
-- TOC entry 2638 (class 0 OID 33610)
-- Dependencies: 272
-- Data for Name: log_sistema; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.log_sistema (idlog, mensaje, fecha, usuario, nombres, idperfil, idreferencia, ip, operacion, tabla) FROM stdin;
\.


--
-- TOC entry 2640 (class 0 OID 33621)
-- Dependencies: 274
-- Data for Name: modulos; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.modulos (modulo_id, modulo_nombre, modulo_icono, modulo_controlador, modulo_padre, modulo_orden, modulo_route, estado) FROM stdin;
8	Mantenimiento	fa fa-fw fa-cog	#	1	1	C20210618222025	A
2	Perfiles	#	perfiles/index	3	1	C20210618222148	A
7	Modulos	#	modulos/index	3	2	C20210618222158	A
5	Permisos	#	permisos/index	3	4	C20210618222223	A
4	Usuarios	#	usuarios/index	3	3	C20210618222246	A
1	Modulo Padre	#	#	1	10	C20210619155956	A
15	\N	fa fa-fw fa-money	#	1	2	C20210619160115	A
13	\N	fa fa-fw fa-home	#	1	2	C20210619160723	A
16	\N	#	asociados/index	13	1	C20210620221836	A
9	Paises	#	paises/index	8	3	C20210621130214	A
17	\N	#	divisiones/index	8	2	C20210621130728	A
18	\N	#	uniones/index	8	4	C20210621130814	A
10	Idiomas	#	idiomas/index	8	1	C20210621130955	A
20	\N	#	distritos_misioneros/index	8	6	C20210621171421	A
21	\N	#	iglesias/index	8	7	C20210621215134	A
22	\N	#	pastores/index	8	8	C20210629022610	A
23	\N	#	departamentos/index	8	9	C20210702000732	A
24	\N	#	provincias/index	8	10	C20210702000755	A
25	\N	#	distritos/index	8	11	C20210702000824	A
29	\N	#	asociados/curriculum	13	2	C20210702015755	A
3	Seguridad	fa fa-fw fa-lock	#	1	2	C20210618222007	A
26	\N	#	traslados/index	13	3	C20210702015802	A
28	\N	#	traslados/control	13	4	C20210702015806	A
32	\N	#	niveles/index	8	13	C20210702220420	A
33	\N	#	cargos/index	8	14	C20210702221054	A
31	\N	#	tipos_cargo/index	8	12	C20210703013822	A
30	\N	#	actividad_misionera/index	13	5	C20210706134917	A
19	\N	#	misiones/index	8	5	C20210711204236	A
35	\N	fa fa-fw fa-bar-chart-o	#	1	4	C20210712222459	A
34	\N	#	actividad_misionera/reporte	35	1	C20210712222717	A
36	\N	#	reportes/general_asociados	35	2	C20210716214013	A
37	\N	#	reportes/grafico_feligresia	35	3	C20210718212452	A
38	\N	#	reportes/miembros_iglesia	35	4	C20210718212747	A
39	\N	#	instituciones/index	8	15	C20210726012743	A
40	\N	#	otras_propiedades/index	8	16	C20210726012810	A
41	\N	#	reportes/oficiales_iglesia	35	5	C20210728151814	A
42	\N	#	reportes/oficiales_union_asociacion	35	6	C20210728161558	A
43	\N	#	reportes/informe_semestral	35	7	C20210728162033	A
44	\N	#	eleccion/index	13	6	C20210729230642	A
45	\N	#	importar/datos	13	7	C20210820001538	A
\.


--
-- TOC entry 2641 (class 0 OID 33625)
-- Dependencies: 275
-- Data for Name: modulos_idiomas; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.modulos_idiomas (modulo_id, idioma_id, mi_descripcion) FROM stdin;
3	1	Seguridad
8	1	Mantenimiento
2	1	Perfiles
7	1	Modulos
5	1	Permisos
4	1	Usuarios
14	1	Gesti??n de Iglesias
1	1	Modulo Padre
15	1	Gesti??n de Ingresos
13	1	Gesti??n de Iglesias
16	1	Asociados
9	1	Paises
17	1	Divisiones
18	1	Uniones
10	1	Idiomas
20	1	Distritos Misioneros
21	1	Iglesias
22	1	Otros Pastores / Ancianos
27	1	Traslados de Asociados <br> Individual o Masivo
23	1	Divisi??n Pol??tica 1
24	1	Divisi??n Pol??tica 2
25	1	Divisi??n Pol??tica 3
29	1	Curriculum
26	1	Traslado de Asociados
28	1	Control de Traslados
32	1	Niveles
33	1	Cargos
31	1	Tipos de Cargo
30	1	Actividad Misionera
19	1	Asociaciones
35	1	Reportes
34	1	Reporte Actividades Misioneras
36	1	Reporte General de Asociados
37	1	Reporte de Feligresia
38	1	Miembros de Iglesia
39	1	Instituciones
40	1	Otras Propiedades
41	1	Oficiales de Iglesia
42	1	Oficiales Uni??n/Asociaci??n
43	1	Informe Semestral
44	1	Elecci??n de Oficiales
45	1	Importar Datos
\.


--
-- TOC entry 2643 (class 0 OID 33630)
-- Dependencies: 277
-- Data for Name: perfiles; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.perfiles (perfil_id, perfil_descripcion, estado) FROM stdin;
1	ADMINISTRADOR	A
2	SUBADMINISTRADOR	A
22	\N	A
\.


--
-- TOC entry 2644 (class 0 OID 33634)
-- Dependencies: 278
-- Data for Name: perfiles_idiomas; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.perfiles_idiomas (perfil_id, idioma_id, pi_descripcion) FROM stdin;
21	1	Secretaria
2	1	Sub Administrador
1	1	Administrador
20	1	Contabilidad
22	1	Contador
\.


--
-- TOC entry 2646 (class 0 OID 33639)
-- Dependencies: 280
-- Data for Name: permisos; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.permisos (perfil_id, modulo_id) FROM stdin;
22	10
22	17
22	9
22	18
22	19
22	20
22	21
22	22
22	23
22	24
22	25
22	31
22	32
22	33
22	39
22	40
22	16
22	29
22	26
22	28
22	30
22	44
22	2
22	7
22	4
22	5
22	34
22	36
22	37
22	38
22	41
22	42
22	43
1	10
1	17
1	9
1	18
1	19
1	20
1	21
1	22
1	23
1	24
1	25
1	31
1	32
1	33
1	39
1	40
1	16
1	29
1	26
1	28
1	30
1	44
1	45
1	2
1	7
1	4
1	5
1	34
1	36
1	37
1	38
1	41
1	42
1	43
2	10
2	17
2	9
2	18
2	19
2	20
2	21
2	22
2	23
2	24
2	25
2	31
2	32
2	33
2	39
2	40
2	16
2	29
2	26
2	28
2	30
2	44
2	45
2	2
2	4
2	5
2	34
2	36
2	37
2	38
2	41
2	42
2	43
\.


--
-- TOC entry 2647 (class 0 OID 33642)
-- Dependencies: 281
-- Data for Name: tipoacceso; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.tipoacceso (idtipoacceso, descripcion) FROM stdin;
1	su DISTRITO MISIONERO
4	su PAIS
5	su DIVISION
3	su UNION
2	su ASOCIACI??N
\.


--
-- TOC entry 2649 (class 0 OID 33648)
-- Dependencies: 283
-- Data for Name: usuarios; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.usuarios (usuario_id, usuario_user, usuario_pass, usuario_nombres, usuario_referencia, perfil_id, estado, idmiembro, idtipoacceso) FROM stdin;
10	admin	$2y$10$p93p/0o.usTlXCq//upIce5Chvo/KagAsZ7qX1y6Aw299eoVW8TWC	\N	\N	1	A	19	5
13	Ycotrina	$2y$10$gFelS5s5Zjk24G4GLpDOs.WvcnQ6ddWVz/ZrY0w7visBEQRC6AF0W	\N	\N	2	A	\N	5
\.


--
-- TOC entry 2715 (class 0 OID 0)
-- Dependencies: 172
-- Name: actividadmisionera_idactividadmisionera_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.actividadmisionera_idactividadmisionera_seq', 40, true);


--
-- TOC entry 2716 (class 0 OID 0)
-- Dependencies: 174
-- Name: capacitacion_miembro_idcapacitacion_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.capacitacion_miembro_idcapacitacion_seq', 1, false);


--
-- TOC entry 2717 (class 0 OID 0)
-- Dependencies: 176
-- Name: cargo_miembro_idcargomiembro_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.cargo_miembro_idcargomiembro_seq', 1, false);


--
-- TOC entry 2718 (class 0 OID 0)
-- Dependencies: 178
-- Name: categoriaiglesia_idcategoriaiglesia_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.categoriaiglesia_idcategoriaiglesia_seq', 1, false);


--
-- TOC entry 2719 (class 0 OID 0)
-- Dependencies: 180
-- Name: condicioneclesiastica_idcondicioneclesiastica_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.condicioneclesiastica_idcondicioneclesiastica_seq', 1, false);


--
-- TOC entry 2720 (class 0 OID 0)
-- Dependencies: 182
-- Name: condicioninmueble_idcondicioninmueble_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.condicioninmueble_idcondicioninmueble_seq', 1, false);


--
-- TOC entry 2721 (class 0 OID 0)
-- Dependencies: 184
-- Name: control_traslados_idcontrol_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.control_traslados_idcontrol_seq', 1, false);


--
-- TOC entry 2722 (class 0 OID 0)
-- Dependencies: 186
-- Name: controlactmisionera_idcontrolactmisionera_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.controlactmisionera_idcontrolactmisionera_seq', 1, false);


--
-- TOC entry 2723 (class 0 OID 0)
-- Dependencies: 188
-- Name: distritomisionero_iddistritomisionero_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.distritomisionero_iddistritomisionero_seq', 55, true);


--
-- TOC entry 2724 (class 0 OID 0)
-- Dependencies: 190
-- Name: division_iddivision_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.division_iddivision_seq', 8, true);


--
-- TOC entry 2725 (class 0 OID 0)
-- Dependencies: 193
-- Name: educacion_miembro_ideducacionmiembro_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.educacion_miembro_ideducacionmiembro_seq', 1, false);


--
-- TOC entry 2726 (class 0 OID 0)
-- Dependencies: 195
-- Name: eleccion_ideleccion_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.eleccion_ideleccion_seq', 1, false);


--
-- TOC entry 2727 (class 0 OID 0)
-- Dependencies: 197
-- Name: historial_altasybajas_idhistorial_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.historial_altasybajas_idhistorial_seq', 1, false);


--
-- TOC entry 2728 (class 0 OID 0)
-- Dependencies: 199
-- Name: historial_traslados_idtraslado_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.historial_traslados_idtraslado_seq', 1, false);


--
-- TOC entry 2729 (class 0 OID 0)
-- Dependencies: 201
-- Name: iglesia_idiglesia_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.iglesia_idiglesia_seq', 1785, true);


--
-- TOC entry 2730 (class 0 OID 0)
-- Dependencies: 203
-- Name: institucion_idinstitucion_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.institucion_idinstitucion_seq', 1, false);


--
-- TOC entry 2731 (class 0 OID 0)
-- Dependencies: 205
-- Name: laboral_miembro_idlaboralmiembro_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.laboral_miembro_idlaboralmiembro_seq', 1, false);


--
-- TOC entry 2732 (class 0 OID 0)
-- Dependencies: 207
-- Name: miembro_idmiembro_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.miembro_idmiembro_seq', 1, false);


--
-- TOC entry 2733 (class 0 OID 0)
-- Dependencies: 209
-- Name: mision_idmision_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.mision_idmision_seq', 21, true);


--
-- TOC entry 2734 (class 0 OID 0)
-- Dependencies: 211
-- Name: motivobaja_idmotivobaja_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.motivobaja_idmotivobaja_seq', 1, false);


--
-- TOC entry 2735 (class 0 OID 0)
-- Dependencies: 213
-- Name: otras_propiedades_ idotrapropiedad_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias."otras_propiedades_ idotrapropiedad_seq"', 1, false);


--
-- TOC entry 2736 (class 0 OID 0)
-- Dependencies: 215
-- Name: otrospastores_idotrospastores_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.otrospastores_idotrospastores_seq', 1, false);


--
-- TOC entry 2737 (class 0 OID 0)
-- Dependencies: 219
-- Name: paises_jerarquia_pj_id_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.paises_jerarquia_pj_id_seq', 63, true);


--
-- TOC entry 2738 (class 0 OID 0)
-- Dependencies: 220
-- Name: paises_pais_id_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.paises_pais_id_seq', 24, true);


--
-- TOC entry 2739 (class 0 OID 0)
-- Dependencies: 222
-- Name: parentesco_miembro_idparentescomiembro_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.parentesco_miembro_idparentescomiembro_seq', 1, false);


--
-- TOC entry 2740 (class 0 OID 0)
-- Dependencies: 224
-- Name: religion_idreligion_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.religion_idreligion_seq', 1, false);


--
-- TOC entry 2741 (class 0 OID 0)
-- Dependencies: 226
-- Name: temp_traslados_idtemptraslados_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.temp_traslados_idtemptraslados_seq', 466, true);


--
-- TOC entry 2742 (class 0 OID 0)
-- Dependencies: 228
-- Name: union_idunion_seq; Type: SEQUENCE SET; Schema: iglesias; Owner: postgres
--

SELECT pg_catalog.setval('iglesias.union_idunion_seq', 15, true);


--
-- TOC entry 2743 (class 0 OID 0)
-- Dependencies: 235
-- Name: cargo_idcargo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cargo_idcargo_seq', 157, true);


--
-- TOC entry 2744 (class 0 OID 0)
-- Dependencies: 237
-- Name: condicioninmueble_idcondicioninmueble_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.condicioninmueble_idcondicioninmueble_seq', 1, false);


--
-- TOC entry 2745 (class 0 OID 0)
-- Dependencies: 239
-- Name: departamento_iddepartamento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departamento_iddepartamento_seq', 349, true);


--
-- TOC entry 2746 (class 0 OID 0)
-- Dependencies: 241
-- Name: distrito_iddistrito_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.distrito_iddistrito_seq', 9143, true);


--
-- TOC entry 2747 (class 0 OID 0)
-- Dependencies: 243
-- Name: estadocivil_idestadocivil_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estadocivil_idestadocivil_seq', 1, false);


--
-- TOC entry 2748 (class 0 OID 0)
-- Dependencies: 245
-- Name: gradoinstruccion_idgradoinstruccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gradoinstruccion_idgradoinstruccion_seq', 1, false);


--
-- TOC entry 2749 (class 0 OID 0)
-- Dependencies: 247
-- Name: idiomas_idioma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.idiomas_idioma_id_seq', 2, true);


--
-- TOC entry 2750 (class 0 OID 0)
-- Dependencies: 249
-- Name: nivel_idnivel_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nivel_idnivel_seq', 21, true);


--
-- TOC entry 2751 (class 0 OID 0)
-- Dependencies: 251
-- Name: ocupacion_idocupacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ocupacion_idocupacion_seq', 1, false);


--
-- TOC entry 2752 (class 0 OID 0)
-- Dependencies: 253
-- Name: pais_idpais_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pais_idpais_seq', 1, false);


--
-- TOC entry 2753 (class 0 OID 0)
-- Dependencies: 255
-- Name: parentesco_idparentesco_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parentesco_idparentesco_seq', 1, false);


--
-- TOC entry 2754 (class 0 OID 0)
-- Dependencies: 257
-- Name: procesos_proceso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.procesos_proceso_id_seq', 1, false);


--
-- TOC entry 2755 (class 0 OID 0)
-- Dependencies: 259
-- Name: provincia_idprovincia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.provincia_idprovincia_seq', 11313, true);


--
-- TOC entry 2756 (class 0 OID 0)
-- Dependencies: 261
-- Name: tipocargo_idtipocargo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipocargo_idtipocargo_seq', 22, true);


--
-- TOC entry 2757 (class 0 OID 0)
-- Dependencies: 263
-- Name: tipoconstruccion_idtipoconstruccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipoconstruccion_idtipoconstruccion_seq', 1, false);


--
-- TOC entry 2758 (class 0 OID 0)
-- Dependencies: 264
-- Name: tipodoc_idtipodoc_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipodoc_idtipodoc_seq', 1, false);


--
-- TOC entry 2759 (class 0 OID 0)
-- Dependencies: 266
-- Name: tipodocumentacion_idtipodocumentacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipodocumentacion_idtipodocumentacion_seq', 1, false);


--
-- TOC entry 2760 (class 0 OID 0)
-- Dependencies: 268
-- Name: tipoinmueble_idtipoinmueble_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipoinmueble_idtipoinmueble_seq', 1, false);


--
-- TOC entry 2761 (class 0 OID 0)
-- Dependencies: 270
-- Name: trimestre_idtrimestre_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trimestre_idtrimestre_seq', 1, false);


--
-- TOC entry 2762 (class 0 OID 0)
-- Dependencies: 273
-- Name: log_sistema_idlog_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.log_sistema_idlog_seq', 1, false);


--
-- TOC entry 2763 (class 0 OID 0)
-- Dependencies: 276
-- Name: modulos_modulo_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.modulos_modulo_id_seq', 45, true);


--
-- TOC entry 2764 (class 0 OID 0)
-- Dependencies: 279
-- Name: perfiles_perfil_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.perfiles_perfil_id_seq', 22, true);


--
-- TOC entry 2765 (class 0 OID 0)
-- Dependencies: 282
-- Name: tipoacceso_idtipoacceso_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.tipoacceso_idtipoacceso_seq', 1, false);


--
-- TOC entry 2766 (class 0 OID 0)
-- Dependencies: 284
-- Name: usuarios_usuario_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.usuarios_usuario_id_seq', 13, true);


--
-- TOC entry 2329 (class 2606 OID 33710)
-- Name: actividadmisionera actividadmisionera_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.actividadmisionera
    ADD CONSTRAINT actividadmisionera_pkey PRIMARY KEY (idactividadmisionera);


--
-- TOC entry 2331 (class 2606 OID 33712)
-- Name: capacitacion_miembro capacitacion_miembro_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.capacitacion_miembro
    ADD CONSTRAINT capacitacion_miembro_pkey PRIMARY KEY (idcapacitacion);


--
-- TOC entry 2333 (class 2606 OID 33714)
-- Name: cargo_miembro cargo_miembro_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.cargo_miembro
    ADD CONSTRAINT cargo_miembro_pkey PRIMARY KEY (idcargomiembro, idmiembro, idcargo);


--
-- TOC entry 2335 (class 2606 OID 33716)
-- Name: categoriaiglesia categoriaiglesia_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.categoriaiglesia
    ADD CONSTRAINT categoriaiglesia_pkey PRIMARY KEY (idcategoriaiglesia);


--
-- TOC entry 2337 (class 2606 OID 33718)
-- Name: condicioneclesiastica condicioneclesiastica_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.condicioneclesiastica
    ADD CONSTRAINT condicioneclesiastica_pkey PRIMARY KEY (idcondicioneclesiastica);


--
-- TOC entry 2339 (class 2606 OID 33720)
-- Name: condicioninmueble condicioninmueble_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.condicioninmueble
    ADD CONSTRAINT condicioninmueble_pkey PRIMARY KEY (idcondicioninmueble);


--
-- TOC entry 2341 (class 2606 OID 33722)
-- Name: control_traslados control_traslados_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.control_traslados
    ADD CONSTRAINT control_traslados_pkey PRIMARY KEY (idcontrol);


--
-- TOC entry 2343 (class 2606 OID 33724)
-- Name: controlactmisionera controlactmisionera_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.controlactmisionera
    ADD CONSTRAINT controlactmisionera_pkey PRIMARY KEY (idcontrolactmisionera);


--
-- TOC entry 2345 (class 2606 OID 33726)
-- Name: distritomisionero distritomisionero_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.distritomisionero
    ADD CONSTRAINT distritomisionero_pkey PRIMARY KEY (iddistritomisionero);


--
-- TOC entry 2347 (class 2606 OID 33728)
-- Name: division division_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.division
    ADD CONSTRAINT division_pkey PRIMARY KEY (iddivision);


--
-- TOC entry 2349 (class 2606 OID 33730)
-- Name: educacion_miembro educacion_miembro_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.educacion_miembro
    ADD CONSTRAINT educacion_miembro_pkey PRIMARY KEY (ideducacionmiembro);


--
-- TOC entry 2351 (class 2606 OID 33732)
-- Name: eleccion eleccion_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.eleccion
    ADD CONSTRAINT eleccion_pkey PRIMARY KEY (ideleccion);


--
-- TOC entry 2353 (class 2606 OID 33734)
-- Name: historial_altasybajas historial_altasybajas_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.historial_altasybajas
    ADD CONSTRAINT historial_altasybajas_pkey PRIMARY KEY (idhistorial);


--
-- TOC entry 2355 (class 2606 OID 33736)
-- Name: historial_traslados historial_traslados_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.historial_traslados
    ADD CONSTRAINT historial_traslados_pkey PRIMARY KEY (idtraslado);


--
-- TOC entry 2357 (class 2606 OID 33738)
-- Name: iglesia iglesia_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.iglesia
    ADD CONSTRAINT iglesia_pkey PRIMARY KEY (idiglesia);


--
-- TOC entry 2359 (class 2606 OID 33740)
-- Name: institucion institucion_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.institucion
    ADD CONSTRAINT institucion_pkey PRIMARY KEY (idinstitucion);


--
-- TOC entry 2361 (class 2606 OID 33742)
-- Name: laboral_miembro laboral_miembro_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.laboral_miembro
    ADD CONSTRAINT laboral_miembro_pkey PRIMARY KEY (idlaboralmiembro);


--
-- TOC entry 2363 (class 2606 OID 33744)
-- Name: miembro miembro_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.miembro
    ADD CONSTRAINT miembro_pkey PRIMARY KEY (idmiembro);


--
-- TOC entry 2365 (class 2606 OID 33746)
-- Name: mision mision_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.mision
    ADD CONSTRAINT mision_pkey PRIMARY KEY (idmision);


--
-- TOC entry 2367 (class 2606 OID 33748)
-- Name: motivobaja motivobaja_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.motivobaja
    ADD CONSTRAINT motivobaja_pkey PRIMARY KEY (idmotivobaja);


--
-- TOC entry 2369 (class 2606 OID 33750)
-- Name: otras_propiedades otras_propiedades_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.otras_propiedades
    ADD CONSTRAINT otras_propiedades_pkey PRIMARY KEY (idotrapropiedad);


--
-- TOC entry 2371 (class 2606 OID 33752)
-- Name: otrospastores otrospastores_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.otrospastores
    ADD CONSTRAINT otrospastores_pkey PRIMARY KEY (idotrospastores);


--
-- TOC entry 2373 (class 2606 OID 33754)
-- Name: paises paises_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.paises
    ADD CONSTRAINT paises_pkey PRIMARY KEY (pais_id);


--
-- TOC entry 2375 (class 2606 OID 33756)
-- Name: parentesco_miembro parentesco_miembro_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.parentesco_miembro
    ADD CONSTRAINT parentesco_miembro_pkey PRIMARY KEY (idparentescomiembro);


--
-- TOC entry 2377 (class 2606 OID 33758)
-- Name: religion religion_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.religion
    ADD CONSTRAINT religion_pkey PRIMARY KEY (idreligion);


--
-- TOC entry 2379 (class 2606 OID 33760)
-- Name: temp_traslados temp_traslados_pkey; Type: CONSTRAINT; Schema: iglesias; Owner: postgres
--

ALTER TABLE ONLY iglesias.temp_traslados
    ADD CONSTRAINT temp_traslados_pkey PRIMARY KEY (idmiembro, idtipodoc, iddivision, pais_id, idunion, idmision, iddistritomisionero, idiglesia, nrodoc, tipo_traslado);


--
-- TOC entry 2383 (class 2606 OID 33762)
-- Name: cargo cargo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargo
    ADD CONSTRAINT cargo_pkey PRIMARY KEY (idcargo);


--
-- TOC entry 2385 (class 2606 OID 33764)
-- Name: condicioninmueble condicioninmueble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condicioninmueble
    ADD CONSTRAINT condicioninmueble_pkey PRIMARY KEY (idcondicioninmueble);


--
-- TOC entry 2387 (class 2606 OID 33766)
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (iddepartamento);


--
-- TOC entry 2389 (class 2606 OID 33768)
-- Name: distrito distrito_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distrito
    ADD CONSTRAINT distrito_pkey PRIMARY KEY (iddistrito);


--
-- TOC entry 2391 (class 2606 OID 33770)
-- Name: estadocivil estadocivil_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estadocivil
    ADD CONSTRAINT estadocivil_pkey PRIMARY KEY (idestadocivil);


--
-- TOC entry 2393 (class 2606 OID 33772)
-- Name: gradoinstruccion gradoinstruccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gradoinstruccion
    ADD CONSTRAINT gradoinstruccion_pkey PRIMARY KEY (idgradoinstruccion);


--
-- TOC entry 2395 (class 2606 OID 33774)
-- Name: idiomas idiomas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idiomas
    ADD CONSTRAINT idiomas_pkey PRIMARY KEY (idioma_id);


--
-- TOC entry 2397 (class 2606 OID 33776)
-- Name: nivel nivel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nivel
    ADD CONSTRAINT nivel_pkey PRIMARY KEY (idnivel);


--
-- TOC entry 2399 (class 2606 OID 33778)
-- Name: ocupacion ocupacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ocupacion
    ADD CONSTRAINT ocupacion_pkey PRIMARY KEY (idocupacion);


--
-- TOC entry 2401 (class 2606 OID 33780)
-- Name: pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (idpais);


--
-- TOC entry 2403 (class 2606 OID 33782)
-- Name: parentesco parentesco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parentesco
    ADD CONSTRAINT parentesco_pkey PRIMARY KEY (idparentesco);


--
-- TOC entry 2405 (class 2606 OID 33784)
-- Name: procesos procesos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procesos
    ADD CONSTRAINT procesos_pkey PRIMARY KEY (proceso_id);


--
-- TOC entry 2407 (class 2606 OID 33786)
-- Name: provincia provincia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincia
    ADD CONSTRAINT provincia_pkey PRIMARY KEY (idprovincia);


--
-- TOC entry 2409 (class 2606 OID 33788)
-- Name: tipocargo tipocargo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipocargo
    ADD CONSTRAINT tipocargo_pkey PRIMARY KEY (idtipocargo);


--
-- TOC entry 2411 (class 2606 OID 33790)
-- Name: tipoconstruccion tipoconstruccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipoconstruccion
    ADD CONSTRAINT tipoconstruccion_pkey PRIMARY KEY (idtipoconstruccion);


--
-- TOC entry 2381 (class 2606 OID 33792)
-- Name: tipodoc tipodoc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipodoc
    ADD CONSTRAINT tipodoc_pkey PRIMARY KEY (idtipodoc);


--
-- TOC entry 2413 (class 2606 OID 33794)
-- Name: tipodocumentacion tipodocumentacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipodocumentacion
    ADD CONSTRAINT tipodocumentacion_pkey PRIMARY KEY (idtipodocumentacion);


--
-- TOC entry 2415 (class 2606 OID 33796)
-- Name: tipoinmueble tipoinmueble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipoinmueble
    ADD CONSTRAINT tipoinmueble_pkey PRIMARY KEY (idtipoinmueble);


--
-- TOC entry 2417 (class 2606 OID 33798)
-- Name: trimestre trimestre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trimestre
    ADD CONSTRAINT trimestre_pkey PRIMARY KEY (idtrimestre);


--
-- TOC entry 2419 (class 2606 OID 33800)
-- Name: log_sistema log_sistema_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.log_sistema
    ADD CONSTRAINT log_sistema_pkey PRIMARY KEY (idlog);


--
-- TOC entry 2421 (class 2606 OID 33802)
-- Name: modulos modulos_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.modulos
    ADD CONSTRAINT modulos_pkey PRIMARY KEY (modulo_id);


--
-- TOC entry 2423 (class 2606 OID 33804)
-- Name: perfiles perfiles_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.perfiles
    ADD CONSTRAINT perfiles_pkey PRIMARY KEY (perfil_id);


--
-- TOC entry 2425 (class 2606 OID 33806)
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (perfil_id, modulo_id);


--
-- TOC entry 2427 (class 2606 OID 33808)
-- Name: tipoacceso tipoacceso_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.tipoacceso
    ADD CONSTRAINT tipoacceso_pkey PRIMARY KEY (idtipoacceso);


--
-- TOC entry 2429 (class 2606 OID 33810)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (usuario_id);


--
-- TOC entry 2430 (class 2606 OID 33811)
-- Name: modulos fk_padres_modulos; Type: FK CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.modulos
    ADD CONSTRAINT fk_padres_modulos FOREIGN KEY (modulo_padre) REFERENCES seguridad.modulos(modulo_id);


--
-- TOC entry 2656 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2021-09-16 22:44:21

--
-- PostgreSQL database dump complete
--

