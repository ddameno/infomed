DO $$
DECLARE
    r RECORD;
    cantidad_pac_m INTEGER;
    cantidad_pac_f INTEGER;
BEGIN
    FOR r IN SELECT id_ciudad, nombre FROM ciudades_ids LOOP
        SELECT COUNT(*) INTO cantidad_pac_m FROM pacientes WHERE ciudad_id = r.id_ciudad AND id_sexo =1;
        RAISE NOTICE 'La cantidad de pacientes masculinos en % es: %', r.nombre, cantidad_pac_m;
        SELECT COUNT(*) INTO cantidad_pac_f FROM pacientes WHERE ciudad_id = r.id_ciudad AND id_sexo =2;
        RAISE NOTICE 'La cantidad de pacientes femeninos en % es: %', r.nombre, cantidad_pac_f;
    END LOOP;
END $$;