CREATE OR REPLACE PROCEDURE sp_crud_empleado(
    p_id_empleado INT,
    p_nombre character varying(100)[],
    p_apellido character varying(100)[],
    p_telefono numeric,
    p_correo character varying(50)[],
    p_especialidad integer,
	p_disponibilidad boolean,
    p_activo boolean,
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
                dbo."EMPLEADO"
                ("NOMBRE", "APELLIDO", "TELEFONO", "CORREO", "ESPECIALIDAD", "DISPONIBILIDAD", "ACTIVO")
            VALUES 
                (p_nombre, p_apellido, p_telefono, p_correo, p_especialidad, p_disponibilidad, 
				 COALESCE(p_activo, TRUE));
            
            RAISE NOTICE 'Registro insertado en la tabla EMPLEADOS';            
            -- Leer y mostrar los datos insertados
            FOR result_set IN SELECT * FROM dbo."EMPLEADO" WHERE "ID_EMPLEADO" = p_id_empleado
            LOOP
                RAISE NOTICE 
				'ID_EMPLEADO: %, NOMBRE: %, APELLIDO: %, TELEFONO: %, 
				CORREO: %, ESPECIALIDAD: %, DISPONIBILIDAD: %, ACTIVO: %',
                 result_set."ID_EMPLEADO", result_set."NOMBRE", result_set."APELLIDO",
                 result_set."TELEFONO", result_set."CORREO", result_set."ESPECIALIDAD", 
				  result_set."DISPONIBILIDAD",  result_set."ACTIVO";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al insertar en la tabla EMPLEADO: %', SQLERRM;
        END;
    END IF;
    
    -- READ
    IF p_accion[1] = 'O' THEN
        BEGIN
            FOR result_set IN SELECT * FROM dbo."EMPLEADO" WHERE "ID_EMPLEADO" = p_id_empleado
            LOOP
                RAISE NOTICE 'ID_EMPLEADO: %, NOMBRE: %, APELLIDO: %, TELEFONO: %, CORREO: %, ESPECIALIDAD: %, DISPONIBILIDAD: %, ACTIVO: %',
                             result_set."ID_EMPLEADO", result_set."NOMBRE", result_set."APELLIDO",
                             result_set."TELEFONO", result_set."CORREO", result_set."ESPECIALIDAD", 
							 result_set."DISPONIBILIDAD", result_set."ACTIVO";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al consultar la tabla EMPLEADO: %', SQLERRM;
        END;
    END IF;
	
    -- UPDATE
    IF p_accion[1] = 'U' THEN
        BEGIN
            UPDATE dbo."EMPLEADO"
            SET "NOMBRE" = p_nombre, "APELLIDO" = p_apellido, "TELEFONO" = p_telefono, 
			"CORREO" = p_correo, "ESPECIALIDAD" = p_especialidad, "DISPONIBILIDAD" = p_disponibilidad,  
			"ACTIVO" = COALESCE(p_activo, TRUE)
            WHERE "ID_EMPLEADO" = p_id_empleado;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al actualizar la tabla EMPLEADOS: %', SQLERRM;
        END;
    END IF;
    
    -- DELETE
    IF p_accion[1] = 'D' THEN
        BEGIN
            DELETE FROM dbo."EMPLEADO" WHERE "ID_EMPLEADO" = p_id_empleado;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al eliminar en la tabla EMPLEADO: %', SQLERRM;
        END;
    END IF;
END;
$$;


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