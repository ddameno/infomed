DO $$
DECLARE
    r RECORD;
    cantidad_recetas INTEGER;
BEGIN
    FOR r IN SELECT id_medico, nombre FROM medicos LOOP
        SELECT COUNT(*) INTO cantidad_recetas FROM recetas WHERE id_medico = r.id_medico;
        RAISE NOTICE 'La cantidad de recetas hechas por % es: %', r.nombre, cantidad_recetas;
    END LOOP;
END $$;