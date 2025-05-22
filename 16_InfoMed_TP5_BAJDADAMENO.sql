# GROUP BY -> agrupa por combinación de médico y paciente.
# -> COUNT(c.id_consulta) cuenta cuántas consultas hizo ese médico a ese paciente.
# ORDER BY organiza primero por nombre del médico y luego del paciente.

SELECT 
  m.nombre AS medico,
  p.nombre AS paciente,
  COUNT(c.id_consulta) AS total_consultas
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
JOIN Pacientes p ON c.id_paciente = p.id_paciente
GROUP BY m.nombre, p.nombre
ORDER BY m.nombre, p.nombre;
