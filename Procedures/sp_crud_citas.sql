CREATE OR REPLACE PROCEDURE dbo.sp_crud_citas(
    p_id_cita INT,
    p_id_cliente INTEGER,
	p_id_empleado INTEGER,
	p_id_servicio INTEGER,
	p_fecha_hora DATE,
	p_duracion_estimada INTEGER,
    p_notas TEXT,
    p_costo_total MONEY,
    p_metodo_pago INTEGER,
	p_ubicacion INTEGER,
	p_recordatorio boolean,
	p_estado boolean,
	p_accion character varying(1)[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    result_set RECORD;
BEGIN
    -- CREATE
    IF p_accion[1] = 'I' THEN
        BEGIN
            INSERT INTO 
                dbo."CITAS"
                ("ID_CLIENTE", "ID_EMPLEADO", "ID_SERVICIO", "FECHA_HORA", "DURACION_ESTIMADA", "NOTAS",
				 "COSTO_TOTAL", "METODO_PAGO", "UBICACION", "RECORDATORIO", "ESTADO")
            VALUES 
                (p_id_cliente, p_id_empleado, p_id_servicio, p_fecha_hora, p_duracion_estimada,
				p_notas,p_costo_total, p_metodo_pago, p_ubicacion, p_recordatorio, p_estado);
            
            RAISE NOTICE 'Registro insertado en la tabla CITAS';            
            -- Leer y mostrar los datos insertados
            FOR result_set IN SELECT * FROM dbo."CITAS" WHERE "ID_CITA" = p_id_cita
            LOOP
                RAISE NOTICE 
				'ID_CLIENTE: %, ID_EMPLEADO: %,ID_SERVICIO: %, FECHA_HORA: %, DURACION_ESTIMADA: %,
				NOTAS: %, COSTO_TOTAL: %, METODO_PAGO: %, UBICACION: %, RECORDATORIO: %, ESTADO: %',
                 result_set."ID_CLIENTE",  result_set."ID_EMPLEADO", result_set."ID_SERVICIO",
                 result_set."FECHA_HORA", result_set."DURACION_ESTIMADA", result_set."NOTAS",
				 result_set."COSTO_TOTAL", result_set."METODO_PAGO", result_set."UBICACION",
				 result_set."RECORDATORIO", result_set."ESTADO";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al insertar en la tabla CITAS: %', SQLERRM;
        END;
    END IF;
    
    -- READ
    IF p_accion[1] = 'O' THEN
        BEGIN
            FOR result_set IN SELECT * FROM dbo."CITAS" WHERE "ID_CITA" = p_id_cita
            LOOP
                RAISE NOTICE 'ID_CITA: %, ID_CLIENTE: %, ID_EMPLEADO: %,ID_SERVICIO: %, FECHA_HORA: %, DURACION_ESTIMADA: %,
				NOTAS: %, COSTO_TOTAL: %, METODO_PAGO: %, UBICACION: %, RECORDATORIO: %, ESTADO: %',
				result_set."ID_CITA", result_set."ID_CLIENTE",  result_set."ID_EMPLEADO", result_set."ID_SERVICIO",
                result_set."FECHA_HORA", result_set."DURACION_ESTIMADA", result_set."NOTAS",result_set."COSTO_TOTAL",
				result_set."METODO_PAGO", result_set."UBICACION", result_set."RECORDATORIO", result_set."ESTADO";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al consultar la tabla CITAS: %', SQLERRM;
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
            DELETE FROM dbo."CITAS" WHERE "ID_CITA" = p_id_cita;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al eliminar en la tabla CITAS: %', SQLERRM;
        END;
    END IF;
	
END;
$$;

/*
CALL sp_crud_empleado(
    p_id_empleado := 1,
    p_nombre := ARRAY['MARIA'],
    p_apellido := ARRAY['MORALES'],
    p_telefono := 12345678,
    p_correo := ARRAY['moralesmaria@example.com'],
    p_especialidad := 1,
	p_disponibilidad := TRUE,
    p_activo := TRUE,
    p_accion := ARRAY['O']
);
*/