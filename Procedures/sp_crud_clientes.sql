CREATE OR REPLACE PROCEDURE sp_crud_clientes(
    p_id_cliente INT,
    p_nombre character varying(100)[],
    p_apellido character varying(100)[],
    p_telefono numeric,
    p_correo character varying(50)[],
    p_direccion character varying(50),
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
                dbo."CLIENTES"
                ("NOMBRE", "APELLIDO", "TELEFONO", "CORREO", "DIRECCION", "ACTIVO")
            VALUES 
                (p_nombre, p_apellido, p_telefono, p_correo, p_direccion, COALESCE(p_activo, TRUE));
            
            RAISE NOTICE 'Registro insertado en la tabla CLIENTES';            
            -- Leer y mostrar los datos insertados
            FOR result_set IN SELECT * FROM dbo."CLIENTES" WHERE "ID_CLIENTE" = p_id_cliente
            LOOP
                RAISE NOTICE 
				'ID_CLIENTE: %, NOMBRE: %, APELLIDO: %, TELEFONO: %, CORREO: %, DIRECCION: %, ACTIVO: %',
                 result_set."ID_CLIENTE", result_set."NOMBRE", result_set."APELLIDO",
                 result_set."TELEFONO", result_set."CORREO", result_set."DIRECCION", result_set."ACTIVO";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al insertar en la tabla CLIENTES: %', SQLERRM;
        END;
    END IF;
    
    -- READ
    IF p_accion[1] = 'O' THEN
        BEGIN
            FOR result_set IN SELECT * FROM dbo."CLIENTES" WHERE "ID_CLIENTE" = p_id_cliente
            LOOP
                RAISE NOTICE 'ID_CLIENTE: %, NOMBRE: %, APELLIDO: %, TELEFONO: %, CORREO: %, DIRECCION: %, ACTIVO: %',
                             result_set."ID_CLIENTE", result_set."NOMBRE", result_set."APELLIDO",
                             result_set."TELEFONO", result_set."CORREO", result_set."DIRECCION", result_set."ACTIVO";
            END LOOP;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al consultar la tabla CLIENTES: %', SQLERRM;
        END;
    END IF;
	
    -- UPDATE
    IF p_accion[1] = 'U' THEN
        BEGIN
            UPDATE dbo."CLIENTES"
            SET "NOMBRE" = p_nombre, "APELLIDO" = p_apellido, "TELEFONO" = p_telefono, "CORREO" = p_correo, "DIRECCION" = p_direccion,  "ACTIVO" = COALESCE(p_activo, TRUE)
            WHERE "ID_CLIENTE" = p_id_cliente;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al actualizar la tabla CLIENTES: %', SQLERRM;
        END;
    END IF;
    
    -- DELETE
    IF p_accion[1] = 'D' THEN
        BEGIN
            DELETE FROM dbo."CLIENTES" WHERE "ID_CLIENTE" = p_id_cliente;
        EXCEPTION
            WHEN others THEN
                RAISE EXCEPTION 'Error al eliminar en la tabla CLIENTES: %', SQLERRM;
        END;
    END IF;
END;
$$;
--------------------------------------------------------------------------------------

/*
CALL sp_crud_clientes(
    p_id_cliente := 2,
    p_nombre := ARRAY['ALVARO'],
    p_apellido := ARRAY['ZAPATA'],
    p_telefono := 12345678,
    p_correo := ARRAY['alvarozapata@example.com'],
    p_direccion := 'LEON',
    p_activo := TRUE,
    p_accion := ARRAY['U']
);

CALL sp_crud_clientes(
    p_id_cliente := 3,
    p_nombre := NULL,
    p_apellido := NULL,
    p_telefono := NULL,
    p_correo := NULL,
    p_direccion := NULL,
    p_activo := NULL,
    p_accion := ARRAY['O']
);
*/


