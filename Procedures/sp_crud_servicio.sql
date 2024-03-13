-- PROCEDURE: dbo.sp_crud_servicio(integer, integer, character varying[], money, integer, integer)

-- DROP PROCEDURE IF EXISTS dbo.sp_crud_servicio(integer, integer, character varying[], money, integer, integer);

CREATE OR REPLACE PROCEDURE dbo.sp_crud_servicio(
	IN p_id_servicio integer,
	IN p_id_tipo_servicio integer,
	IN p_descripcion character varying[],
	IN p_precio money,
	IN p_duracion_estimada integer,
	IN p_id_categoria integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    result_set RECORD;
BEGIN
    -- CREATE
    IF p_accion[1] = 'I' THEN
        BEGIN
            INSERT INTO 
                dbo."SERVICIOS"
                ("ID_TIPO_SERVICIO", "DESCRIPCION", "PRECIO", "DURACION_ESTIMADA", "ID_CATEGORIA")
            VALUES 
                (p_id_tipo_servicio, p_descripcion, p_precio, p_duracion_estimada, p_id_categoria);
            
            RAISE NOTICE 'Registro insertado en la tabla SERVICIOS';            
            -- Leer y mostrar los datos insertados
            FOR result_set IN SELECT * FROM dbo."SERVICIOS" WHERE "ID_SERVICIO" = p_id_servicio
            LOOP
                RAISE NOTICE 
				'ID_TIPO_SERVICIO: %, DESCRIPCION: %, PRECIO: %,DURACION_ESTIMADA: %, ID_CATEGORIA: %',
                 result_set."ID_TIPO_SERVICIO",  result_set."DESCRIPCION", result_set."PRECIO",
                 result_set."DURACION_ESTIMADA", result_set."ID_CATEGORIA";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al insertar en la tabla SERVICIOS: %', SQLERRM;
        END;
    END IF;
    
    -- READ
    IF p_accion[1] = 'O' THEN
        BEGIN
            FOR result_set IN SELECT * FROM dbo."SERVICIOS" WHERE "ID_SERVICIO" = p_id_servicio
            LOOP
                RAISE NOTICE 'ID_SERVICIO: %, ID_TIPO_SERVICIO: %, DESCRIPCION: %, PRECIO: %, 
				DURACION_ESTIMADA: %, ID_CATEGORIA: %',
				result_set."ID_SERVICIO", result_set."ID_TIPO_SERVICIO", result_set."DESCRIPCION",
			 	result_set."PRECIO", result_set."DURACION_ESTIMADA", result_set."ID_CATEGORIA";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al consultar la tabla SERVICIOS: %', SQLERRM;
        END;
    END IF;
	
    -- UPDATE
    IF p_accion[1] = 'U' THEN
        BEGIN
            UPDATE dbo."SERVICIOS"
            SET "ID_TIPO_SERVICIO" = p_id_tipo_servicio, "DESCRIPCION" = p_descripcion, "PRECIO" = p_precio, 
			"DURACION_ESTIMADA" = p_duracion_estimada, "ID_CATEGORIA" = p_id_categoria
            WHERE "ID_SERVICIO" = p_id_servicio;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al actualizar la tabla SERVICIOS: %', SQLERRM;
        END;
    END IF;
    
    -- DELETE
    IF p_accion[1] = 'D' THEN
        BEGIN
            DELETE FROM dbo."SERVICIOS" WHERE "ID_SERVICIO" = p_id_servicio;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al eliminar en la tabla SERVICIO: %', SQLERRM;
        END;
    END IF;
	
END;
$BODY$;
ALTER PROCEDURE dbo.sp_crud_servicio(integer, integer, character varying[], money, integer, integer)
    OWNER TO postgres;
