# La subconsulta (desde WHERE) encuentra la fecha mas reciente para cada paciente
# Despues, la consulta principal trae el nombre del paciente, esa fecha mas reciente de consulta y el diagnostico

# Esta no incluye pacientes sin consultas:
SELECT p.nombre AS paciente, c.fecha, c.diagnostico
FROM Consultas c
JOIN Pacientes p ON c.id_paciente = p.id_paciente
WHERE (c.id_paciente, c.fecha) IN (
    SELECT id_paciente, MAX(fecha)
    FROM Consultas
    GROUP BY id_paciente
);

# Despues de correr esta query, notamos que no coinciden las cantidades de pacientes mostrados con los que hay en la base de datos
# Modificamos entonces apra que, aquellos que no han realizado consultas, aparezcan igual.

# DISTINCT ON -> devuelve la fecha mas reciente
# LEFT JOIN -> asegura que se incluyan todos los pacientes

SELECT 
  p.nombre AS paciente,
  c.fecha AS ultima_consulta,
  c.diagnostico
FROM Pacientes p
LEFT JOIN (
    SELECT DISTINCT ON (id_paciente) 
      id_paciente,
      fecha,
      diagnostico
    FROM Consultas
    ORDER BY id_paciente, fecha DESC
) c ON p.id_paciente = c.id_paciente
ORDER BY p.nombre;
