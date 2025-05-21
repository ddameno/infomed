CREATE OR REPLACE VIEW Vista_Pacientes_Edad AS
SELECT 
    p.id_paciente,
    p.nombre,
    p.fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.fecha_nacimiento)) AS edad,
    s.descripcion AS sexo,
    p.numero,
    p.calle,
    p.ciudad
FROM 
    Pacientes p
JOIN 
    SexoBiologico s ON p.id_sexo = s.id_sexo;