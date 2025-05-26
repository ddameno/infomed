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
