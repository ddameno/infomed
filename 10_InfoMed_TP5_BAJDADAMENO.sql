DO $$
DECLARE
    cantidad_consultas_3 INTEGER;
    nombre_med VARCHAR;
BEGIN
        SELECT nombre INTO nombre_med FROM medicos WHERE id_medico = 3;
        SELECT COUNT(*) INTO cantidad_consultas_3 FROM consultas WHERE id_medico = 3 
        AND fecha >= '2024-08-01'
        AND fecha < '2024-09-01';

        RAISE NOTICE 'La cantidad de recetas hechas por % en AGOSTO 2024 es: %', nombre_med, cantidad_consultas_3;
    
END $$;