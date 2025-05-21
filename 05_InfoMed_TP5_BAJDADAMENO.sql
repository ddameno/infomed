-- Creo y cargo la tabla Ciudades
CREATE TABLE Ciudades_ids (
    id_ciudad SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO Ciudades_ids (nombre)
VALUES ('Buenos Aires'), ('Córdoba'), ('Rosario'), ('Mendoza'), ('La Plata');

-- Capitalizar primero los nombres de las ciudades
UPDATE Pacientes
SET ciudad = INITCAP(ciudad);

-- Eliminar espacios en blanco al principio y al final
UPDATE Pacientes
SET ciudad = TRIM(ciudad);


-- Añado la columna ciudad_id a la tabla Pacientes
ALTER TABLE Pacientes ADD COLUMN ciudad_id INT;

-- Añadir el ID de la ciudad correspondiente. Lo hacemos usando las letras iniciales o finales
-- de cada ciudad, ya que en este caso en particular no se reptiten, y es algo que todos
--los registros para una misma ciudad, aunque esten mal escritos, tienen en comun.
UPDATE Pacientes
SET ciudad_id = (SELECT id_ciudad FROM Ciudades WHERE nombre = 'Buenos Aires')
WHERE (ciudad LIKE 'B%') OR (ciudad LIKE 'Ca%');

UPDATE Pacientes
SET ciudad_id = (SELECT id_ciudad FROM Ciudades WHERE nombre = 'Córdoba')
WHERE (ciudad LIKE '%ba');


UPDATE Pacientes
SET ciudad_id = (SELECT id_ciudad FROM Ciudades WHERE nombre = 'Rosario')
WHERE (ciudad LIKE 'Ro%');

UPDATE Pacientes
SET ciudad_id = (SELECT id_ciudad FROM Ciudades WHERE nombre = 'Mendoza')
WHERE (ciudad LIKE 'M%');

-- Eliminar el viejo índice creado en la consigna 01
DROP INDEX IF EXISTS indice_pac_ciudad;

-- Eliminar la columna ciudad de la tabla Pacientes
ALTER TABLE Pacientes DROP COLUMN ciudad;

-- Crear el nuevo índice en la columna ciudad_id
CREATE INDEX indice_pac_ciudad_id ON Pacientes(ciudad_id);