# PARTE 1: Base de Datos

## Ejercicio 1.1. 
Se trata de una base de datos relacional, porque los datos se relacionan en tablas que emplean primary keys y foreign keys. Además, es de tipo transaccional, ya que se utiliza para realizar registros y consultas de datos de gestión médica.

## Ejercicio 1.2. 
Diagrama de entidad-relación para la base de datos dada.
![DER drawio](https://github.com/user-attachments/assets/eb3b9488-e734-4356-9eb5-f817d1adbe55)


## Ejercicio 1.3. 
Modelo lógico entidad-relación.
![Diagrama ER de base de datos (pata de gallo) (1)](https://github.com/user-attachments/assets/03812f28-592b-456f-afbc-607ab4656319)


## Ejercicio 1.4. 
En un principio podemos considerar que la base se encuentra normalizada ya que tenemos primary keys definidas para los aspectos más importantes de la base, y no hay atributos multivariados que puedan complejizar el análisis. Algunos factores sí podrían normalizarse, como por ejemplo: hacer una lista de ciudades, cada una con un código, que es su primary key en la tabla “Lista de ciudades”, que a su vez se referencia como foreign key en el atributo ciudad de la tabla pacientes. Este procedimiento podría realizarse para los atributos diagnóstico y  tratamiento de la tabla consultas, aunque en parte esto puede estar siendo normalizado a través del código SNOMED.

# PARTE 2: SQL

## Querys
### 2.1
```
CREATE INDEX indice_pac_ciudad ON Pacientes(ciudad);
```

### 2.2
```
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
```
    
### 2.3
```
UPDATE PACIENTES
SET calle = 'Calle Corrientes', numero = '500'
WHERE nombre = 'Luciana Gómez'
```

### 2.4
```
SELECT nombre, matricula
FROM MEDICOS
WHERE especialidad_id = 4
```

### 2.5
```
#Creo y cargo la tabla Ciudades
CREATE TABLE Ciudades_ids (
    id_ciudad SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO Ciudades_ids (nombre)
VALUES ('Buenos Aires'), ('Córdoba'), ('Rosario'), ('Mendoza'), ('La Plata');

#Capitalizar primero los nombres de las ciudades
UPDATE Pacientes
SET ciudad = INITCAP(ciudad);

#Eliminar espacios en blanco al principio y al final
UPDATE Pacientes
SET ciudad = TRIM(ciudad);


#Añado la columna ciudad_id a la tabla Pacientes
ALTER TABLE Pacientes ADD COLUMN ciudad_id INT;

#Añadir el ID de la ciudad correspondiente. Lo hacemos usando las letras iniciales o finales
#de cada ciudad, ya que en este caso en particular no se reptiten, y es algo que todos
#los registros para una misma ciudad, aunque esten mal escritos, tienen en comun.
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

#Eliminar el viejo índice creado en la consigna 01
DROP INDEX IF EXISTS indice_pac_ciudad;

#Eliminar la columna ciudad de la tabla Pacientes
ALTER TABLE Pacientes DROP COLUMN ciudad;

#Crear el nuevo índice en la columna ciudad_id
CREATE INDEX indice_pac_ciudad_id ON Pacientes(ciudad_id);
```

### 2.6
```
SELECT nombre, ciudad, calle, numero
FROM PACIENTES
WHERE ciudad_id = 1
```

### 2.7
```
DO $$
DECLARE
    r RECORD;
    cantidad_pac INTEGER;
BEGIN
    FOR r IN SELECT id_ciudad, nombre FROM ciudades_ids LOOP
        SELECT COUNT(*) INTO cantidad_pac FROM pacientes WHERE ciudad_id = r.id_ciudad;
        RAISE NOTICE 'La cantidad de pacientes en % es: %', r.nombre, cantidad_pac;
    END LOOP;
END $$;
```

### 2.8
```
DO $$
DECLARE
    r RECORD;
    cantidad_pac_m INTEGER;
    cantidad_pac_f INTEGER;
BEGIN
    FOR r IN SELECT id_ciudad, nombre FROM ciudades_ids LOOP
        SELECT COUNT(*) INTO cantidad_pac_m FROM pacientes WHERE ciudad_id = r.id_ciudad AND id_sexo =1;
        RAISE NOTICE 'La cantidad de pacientes masculinos en % es: %', r.nombre, cantidad_pac_m;
        SELECT COUNT(*) INTO cantidad_pac_f FROM pacientes WHERE ciudad_id = r.id_ciudad AND id_sexo =2;
        RAISE NOTICE 'La cantidad de pacientes femeninos en % es: %', r.nombre, cantidad_pac_f;
    END LOOP;
END $$;`
```

### 2.9
```
DO $$
DECLARE
    r RECORD;
    cantidad_recetas INTEGER;
BEGIN
    FOR r IN SELECT id_medico, nombre FROM medicos LOOP
        SELECT COUNT(*) INTO cantidad_recetas FROM recetas WHERE id_medico = r.id_medico;
        RAISE NOTICE 'La cantidad de recetas hechas por % es: %', r.nombre, cantidad_recetas;
    END LOOP;
END $$;
```

### 2.10
```
DO $$
DECLARE
    cantidad_consultas_3 INTEGER;
    nombre_med VARCHAR;
BEGIN
        SELECT nombre INTO nombre_med FROM medicos WHERE id_medico = 3;
        SELECT COUNT(*) INTO cantidad_consultas_3 FROM consultas WHERE id_medico = 3 
        AND fecha >= '2024-08-01'
        AND fecha < '2024-09-01';

        RAISE NOTICE 'La cantidad de recetas hechas por % en AGOSTO 2024 es: %', nombre_med, cantidad_consultas_3;
    
END $$;
```

### 2.11
```
#### JOIN -> une las tablas por el id del paciente
#### WHERE -> filtra las fechas para que esten dentro de agosto 2024

SELECT p.nombre, c.fecha, c.diagnostico
FROM Pacientes p
JOIN Consultas c ON p.id_paciente = c.id_paciente
WHERE c.fecha >= '2024-08-01' AND c.fecha < '2024-09-01';
```

### 2.12
```
#### JOIN -> une las prescripciones con los medicamentos para obtener el nombre 
####         del medicamento
#### WHERE p.id_medico = 2 -> filtra las rpescripciones hechas por el 
####                         medico con id 2
#### GROUP BY -> agrupa por nombre del medicamento
#### HAVING COUNT(*) > 1 -> selecciona los medicamentos que fueron rpescritos
####                        mas de una vez

SELECT m.nombre, COUNT(*) AS veces_recetado
FROM Recetas r
JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
WHERE r.id_medico = 2
GROUP BY m.nombre
HAVING COUNT(*) > 1;
```

### 2.13
```
SELECT p.nombre AS nombre_paciente, COUNT(r.id_medicamento) AS cantidad_recetas
FROM Pacientes p
JOIN Recetas r ON p.id_paciente = r.id_paciente
GROUP BY p.id_paciente, p.nombre
ORDER BY cantidad_recetas DESC;

#### Al correr la query anterior vemos que no coinciden la cantidad total de pacientes
#### mostrados con los que hay en la base de datos, por ende consluimos que hay algunos 
#### que no recibieron recetas. Decidimos hacer modificaciones para que se incluyan estos
#### pacientes tambien. 

#### LEFT JOIN incluye pacientes que no tienen recetas

SELECT p.nombre AS nombre_paciente, COUNT(r.id_medicamento) AS cantidad_recetas
FROM Pacientes p
LEFT JOIN Recetas r ON p.id_paciente = r.id_paciente
GROUP BY p.id_paciente, p.nombre
ORDER BY cantidad_recetas DESC;
```

### 2.14
```
#LIMIT 1 -> devuelve el más recetado

SELECT m.nombre AS medicamento, COUNT(r.id_medicamento) AS cantidad_recetas
FROM Recetas r
JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
GROUP BY m.id_medicamento, m.nombre
ORDER BY cantidad_recetas DESC
LIMIT 1;
```


### 2.15
```
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

#Despues de correr esta query, notamos que no coinciden las cantidades de pacientes mostrados con los que hay en la base de #datos
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
```

### 2.16
```
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
```

### 2.17
```
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
```
    
### 2.18
```
#COUNT(DISTINCT r.id_paciente) -> cuenta cuantos pacientes atendio cada médico 
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
```



