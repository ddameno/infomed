# Esta primer forma repite el nombre del medicamento para cada combinación médico–paciente y 
# muestra cuántas veces se emitió esa combinación (aunque normalmente será 1 por combinación)

SELECT 
    me.nombre AS medicamento,
    COUNT(r.id_medicamento) AS total_recetas,
    m.nombre AS medico,
    p.nombre AS paciente
FROM 
    Recetas r
JOIN 
    Medicamentos me ON r.id_medicamento = me.id_medicamento
JOIN 
    Medicos m ON r.id_medico = m.id_medico
JOIN 
    Pacientes p ON r.id_paciente = p.id_paciente
GROUP BY 
    me.nombre, m.nombre, p.nombre
ORDER BY 
    total_recetas DESC;


# Otra forma: una sola fila por medicamento, mostrando cuántas veces se prescribió y a quiénes (pacientes) y por quiénes (médicos)
SELECT 
    me.nombre AS medicamento,
    COUNT(*) AS total_recetas,
    STRING_AGG(DISTINCT m.nombre, ', ') AS medicos,
    STRING_AGG(DISTINCT p.nombre, ', ') AS pacientes
FROM 
    Recetas r
JOIN 
    Medicamentos me ON r.id_medicamento = me.id_medicamento
JOIN 
    Medicos m ON r.id_medico = m.id_medico
JOIN 
    Pacientes p ON r.id_paciente = p.id_paciente
GROUP BY 
    me.nombre
ORDER BY 
    total_recetas DESC;