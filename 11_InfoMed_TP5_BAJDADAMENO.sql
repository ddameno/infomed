# JOIN -> une las tablas por el id del paciente
# WHERE -> filtra las fechas para que esten dentro de agosto 2024

SELECT p.nombre, c.fecha, c.diagnostico
FROM Pacientes p
JOIN Consultas c ON p.id_paciente = c.id_paciente
WHERE c.fecha >= '2024-08-01' AND c.fecha < '2024-09-01';
