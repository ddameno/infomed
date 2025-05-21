DO $$
DECLARE
    r RECORD;
    cantidad_pac INTEGER;
BEGIN
    FOR r IN SELECT id_ciudad, nombre FROM ciudades_ids LOOP
        SELECT COUNT(*) INTO cantidad_pac FROM pacientes WHERE ciudad_id = r.id_ciudad;
        RAISE NOTICE 'La cantidad de pacientes en % es: %', r.nombre, cantidad_pac;
    END LOOP;
END $$;