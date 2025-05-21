#LIMIT 1 -> devuelve el más recetado

SELECT m.nombre AS medicamento, COUNT(r.id_medicamento) AS cantidad_recetas
FROM Recetas r
JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
GROUP BY m.id_medicamento, m.nombre
ORDER BY cantidad_recetas DESC
LIMIT 1;
