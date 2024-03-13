CREATE TABLE dbo."CLIENTES"
(
    "ID_CLIENTE" serial,
    "NOMBRE" character varying(100)[],
    "APELLIDO" character varying(100)[],
    "TELEFONO" numeric,
    "CORREO" character varying(50)[] NOT NULL,
    "DIRECCION" character varying(50) NOT NULL,
    "ACTIVO" boolean DEFAULT TRUE,
    PRIMARY KEY ("ID_CLIENTE")
);

ALTER TABLE IF EXISTS dbo."CLIENTES"
    OWNER to postgres;

COMMENT ON TABLE dbo."CLIENTES"
    IS 'Contiene información personal del cliente.';

id_cliente: Es la clave primaria de la tabla, de tipo SERIAL, que se autoincrementa automáticamente.
nombre: Almacena el nombre del cliente, con una longitud máxima de 255 caracteres.
direccion: Almacena la dirección del cliente, con una longitud máxima de 255 caracteres.
telefono: Almacena el número de teléfono del cliente, con una longitud máxima de 20 caracteres.
correo_electronico: Almacena el correo electrónico del cliente, con una longitud máxima de 255 caracteres.
activo: Indica si el cliente está activo (TRUE) o inactivo (FALSE). Por defecto, se establece en TRUE.
--------------------------------------------------------------------

CREATE TABLE dbo."EMPLEADO"
(
    "ID_EMPLEADO" serial,
    "NOMBRE" character varying(100)[],
    "APELLIDO" character varying(100)[],
    "TELEFONO" numeric,
    "CORREO" character varying(50)[] NOT NULL,
    "ESPECIALIDAD" integer,
    "DISPONIBILIDAD" boolean DEFAULT TRUE,
    "ACTIVO" boolean DEFAULT TRUE,
    PRIMARY KEY ("ID_EMPLEADO")
);

ALTER TABLE IF EXISTS dbo."EMPLEADO"
    OWNER to postgres;

COMMENT ON TABLE dbo."EMPLEADO"
    IS 'Contiene información sobre los empleados del negocio';

id_empleado: Es la clave primaria de la tabla, de tipo SERIAL, que se autoincrementa automáticamente.
nombre: Almacena el nombre del empleado, con una longitud máxima de 255 caracteres.
id_especialidad: Es la clave foránea que referencia a la tabla catalogo_especialidades.
disponible: Indica si el empleado está disponible (TRUE) o no (FALSE). Por defecto, se establece en TRUE.

-------------------------------------------------------------------------
CREATE TABLE dbo."SERVICIOS"
(
    "ID_SERVICIO" serial,
    "ID_TIPO_SERVICIO" integer,
    "DESCRIPCION" character varying(100)[],
    "PRECIO" money,
    "DURACION_ESTIMADA" integer,
    "ID_CATEGORIA" integer,
    PRIMARY KEY ("ID_SERVICIO")
);

ALTER TABLE IF EXISTS dbo."SERVICIOS"
    OWNER to postgres;

COMMENT ON TABLE dbo."SERVICIOS"
    IS 'Describe los servicios ofrecidos por el negocio.';

id_servicio: Es la clave primaria de la tabla, de tipo SERIAL, que se autoincrementa automáticamente.
nombre_servicio: Almacena el nombre del servicio, con una longitud máxima de 255 caracteres.
descripcion: Almacena una descripción del servicio, con formato de texto.
precio: Almacena el precio del servicio, con una precisión de 2 decimales.
duracion_estimada: Almacena la duración estimada del servicio en minutos.
categoria: Almacena la categoría del servicio (ej. "Cortes de cabello", "Peinados", etc.).

----------------------------------------------------------------------------------------
CREATE TABLE dbo."CITAS"
(
    "ID_CITA" serial,
    "ID_CLIENTE" integer,
    "ID_EMPLEADO" integer,
    "ID_SERVICIO" integer,
    "FECHA_HORA" date,
    "DURACION_ESTIMADA" integer,
    "NOTAS" text,
    "COSTO_TOTAL" money,
    "METODO_PAGO" integer,
    "UBICACION" integer,
    "RECORDATORIO" boolean DEFAULT TRUE,
    "ESTADO" boolean DEFAULT TRUE,
    PRIMARY KEY ("ID_CITA")
);

ALTER TABLE IF EXISTS dbo."CITAS"
    OWNER to postgres;

COMMENT ON TABLE dbo."CITAS"
    IS 'Registra una cita programada entre un cliente y un profesional para un servicio específico.';
	
id_cita: Es la clave primaria de la tabla, de tipo SERIAL, que se autoincrementa automáticamente.
id_cliente: Es la clave foránea que referencia a la tabla cliente.
id_profesional: Es la clave foránea que referencia a la tabla empleado.
id_servicio: Es la clave foránea que referencia a la tabla servicio.
fecha_hora: Almacena la fecha y hora de la cita.
duracion: Almacena la duración estimada de la cita en minutos.
notas: Almacena notas adicionales sobre la cita.
estado: Almacena el estado de la cita (ej. "Pendiente", "Confirmada", "Cancelada")
costo_total: Almacena el costo total de la cita.
metodo_pago: Almacena el método de pago utilizado.
ubicacion: Almacena la ubicación donde se realizará la cita.
recordatorio: Indica si se debe enviar un recordatorio al cliente antes de la cita.

-----------------------------------------------------------------------------------------
ALTER TABLE IF EXISTS dbo."CITAS"
    ADD CONSTRAINT "FK_id_cliente" FOREIGN KEY ("ID_CLIENTE")
    REFERENCES dbo."CLIENTES" ("ID_CLIENTE") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

COMMENT ON CONSTRAINT "FK_id_cliente" ON dbo."CITAS"
    IS 'Relacion entre tabla cliente con el campo cliente de citas.';
	

ALTER TABLE IF EXISTS dbo."CITAS"
    ADD CONSTRAINT "FK_id_empleado" FOREIGN KEY ("ID_EMPLEADO")
    REFERENCES dbo."EMPLEADO" ("ID_EMPLEADO") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

COMMENT ON CONSTRAINT "FK_id_empleado" ON dbo."CITAS"
    IS 'Relacion entre tabla empleado con el campo empleado de citas.';
	

ALTER TABLE IF EXISTS dbo."CITAS"
    ADD CONSTRAINT "FK_id_servicio" FOREIGN KEY ("ID_SERVICIO")
    REFERENCES dbo."SERVICIOS" ("ID_SERVICIO") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

COMMENT ON CONSTRAINT "FK_id_servicio" ON dbo."CITAS"
    IS 'Relacion entre tabla servicio con el campo servicio de citas';
	
-----------------------------------------------
	
	CREATE TABLE IF NOT EXISTS dbo."CATALOGOS"
(
    "ID_CATALOGO" integer NOT NULL DEFAULT nextval('dbo."CATALOGOS_ID_CATALOGO_seq"'::regclass),
    "ID_PADRE" integer,
    "CODIGO_CATALOGO" character varying(50)[] COLLATE pg_catalog."default",
    "NOMBRE" character varying(250)[] COLLATE pg_catalog."default",
    "DESCRIPCION" character varying(500)[] COLLATE pg_catalog."default",
    "ACTIVO" boolean DEFAULT true,
    CONSTRAINT "CATALOGOS_pkey" PRIMARY KEY ("ID_CATALOGO")
)

ALTER TABLE IF EXISTS dbo."ID_CATALOGO"
    OWNER to postgres;
	
COMMENT ON TABLE dbo."CATALOGOS"
    IS 'Tabla que contiene los catalogos ';