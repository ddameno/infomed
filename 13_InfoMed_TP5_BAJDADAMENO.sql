SELECT p.nombre AS nombre_paciente, COUNT(r.id_medicamento) AS cantidad_recetas
FROM Pacientes p
JOIN Recetas r ON p.id_paciente = r.id_paciente
GROUP BY p.id_paciente, p.nombre
ORDER BY cantidad_recetas DESC;

# Al correr la query anterior vemos que no coinciden la cantidad total de pacientes
# mostrados con los que hay en la base de datos, por ende consluimos que hay algunos 
# que no recibieron recetas. Decidimos hacer modificaciones para que se incluyan estos
# pacientes tambien. 

#LEFT JOIN incluye pacientes que no tienen recetas

SELECT p.nombre AS nombre_paciente, COUNT(r.id_medicamento) AS cantidad_recetas
FROM Pacientes p
LEFT JOIN Recetas r ON p.id_paciente = r.id_paciente
GROUP BY p.id_paciente, p.nombre
ORDER BY cantidad_recetas DESC;
