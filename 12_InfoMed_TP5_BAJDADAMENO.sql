# JOIN -> une las prescripciones con los medicamentos para obtener el nombre 
#         del medicamento
# WHERE p.id_medico = 2 -> filtra las rpescripciones hechas por el 
#                          medico con id 2
# GROUP BY -> agrupa por nombre del medicamento
# HAVING COUNT(*) > 1 -> selecciona los medicamentos que fueron rpescritos
#                        mas de una vez

SELECT m.nombre, COUNT(*) AS veces_recetado
FROM Recetas r
JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
WHERE r.id_medico = 2
GROUP BY m.nombre
HAVING COUNT(*) > 1;

