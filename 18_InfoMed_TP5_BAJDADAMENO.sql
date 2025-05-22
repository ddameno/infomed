# COUNT(DISTINCT r.id_paciente) -> cuenta cuantos pacientes atendio cada médico 
#                                  (evita contar duplicados si un médico atendió varias veces al mismo paciente


SELECT 
    m.nombre AS medico,
    COUNT(DISTINCT r.id_paciente) AS total_pacientes
FROM 
    Recetas r
JOIN 
    Medicos m ON r.id_medico = m.id_medico
GROUP BY 
    m.nombre
ORDER BY 
    total_pacientes DESC;

# La siguiente variante incluye los emdicos que no atendieron a ningun paciente
SELECT 
    m.nombre AS medico,
    COUNT(DISTINCT r.id_paciente) AS total_pacientes
FROM 
    Medicos m
LEFT JOIN 
    Recetas r ON m.id_medico = r.id_medico
GROUP BY 
    m.nombre
ORDER BY 
    total_pacientes DESC;
