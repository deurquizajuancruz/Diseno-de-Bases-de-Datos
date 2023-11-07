/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
PERSONA = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
ALUMNO = (DNI, Legajo, Año_Ingreso)
PROFESOR = (DNI, Matricula, Nro_Expediente)
TITULO = (Cod_Titulo, Nombre, Descripción)
TITULO-PROFESOR = (Cod_Titulo, DNI, Fecha)
CURSO = (Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
ALUMNO-CURSO = (DNI, Cod_Curso, Año, Desempeño, Calificación)
PROFESOR-CURSO = (DNI, Cod_Curso, Fecha_Desde, Fecha_Hasta)
*/

/*
1
Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año ingreso inferior a 2014.
*/

SELECT p.DNI, a.legajo, p.Apellido, p.Nombre
FROM Persona p INNER JOIN Alumno a ON (a.DNI = p.DNI)
WHERE (a.Año_Ingreso < 2014)

/*
2
Listar DNI, matricula, apellido y nombre de los profesores que dictan cursos que tengan más 100 horas de duración. Ordenar por DNI.
*/

SELECT p.DNI, pro.Matricula, p.Apellido, p.Nombre
FROM Persona p INNER JOIN Profesor pro ON (p.DNI = pro.DNI)
INNER JOIN PROFESOR-CURSO pc ON (pro.DNI = pc.DNI)
INNER JOIN CURSO c ON (c.Cod_Curso = pc.Cod_Curso)
WHERE (c.Duracion > 100)
ORDER BY p.DNI

/*
3
Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al curso con nombre “Diseño de Bases de Datos” en 2019.
*/

SELECT p.DNI, p.Apellido, p.Nombre, p.Genero, p.Fecha_Nacimiento
FROM Persona p INNER JOIN Alumno a ON (a.DNI = p.DNI)
INNER JOIN ALUMNO-CURSO ac ON (ac.DNI = a.DNI)
INNER JOIN Curso c ON (c.Cod_Curso = ac.Cod_Curso)
WHERE (c.nombre = 'Diseño de Bases de Datos' AND YEAR(ac.Año)) = 2019

/*
4 
Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una calificación superior a 9 en los cursos que dicta el profesor “Juan Garcia”. Dicho listado deberá estar ordenado por Apellido.
*/

SELECT p.DNI, p.Apellido, p.Nombre, ac.Calificación
FROM Persona p INNER JOIN Alumno a ON (a.DNI = p.DNI)
INNER JOIN ALUMNO-CURSO ac ON (ac.DNI = a.DNI)
INNER JOIN Curso c ON (c.Cod_Curso = ac.Cod_Curso)
INNER JOIN PROFESOR-CURSO pc ON (c.Cod_Curso = pc.Cod_Curso)
INNER JOIN Persona per2 ON (per2.DNI = pc.DNI)
WHERE (ac.Calificación > 9) AND (per2.Nombre = 'Juan') AND (per2.Apellido = 'Garcia')
ORDER BY p.Apellido

/*
5
Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos. Dicho listado deberá estar ordenado por Apellido y Nombre.
*/

SELECT p.DNI, p.Apellido, p.Nombre, pro.Matricula
FROM Persona p INNER JOIN Profesor pro ON (pro.DNI = p.DNI)
INNER JOIN TITULO-PROFESOR tp ON (tp.DNI = pro.DNI)
GROUP BY p.DNI, p.Apellido, p.Nombre, pro.Matricula
HAVING COUNT(*)>3
ORDER BY p.Apellido, p.Nombre

/*
6
Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor. La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta.
*/

SELECT p.DNI, p.Apellido, p.Nombre, SUM(c.duracion) as Cantidad de horas, AVG(c.duracion) as Promedio de horas
FROM Persona p INNER JOIN Profesor pro ON (pro.DNI = p.DNI)
INNER JOIN PROFESOR-CURSO pc ON (p.DNI = pc.DNI)
INNER JOIN CURSO c ON (c.Cod_Curso = pc.Cod_Curso)
GROUP BY p.DNI, p.Apellido, p.Nombre

/*
7
Listar Nombre, Descripción del curso que posea más alumnos inscriptos y del que posea menos alumnos inscriptos durante 2019
*/

SELECT c.Nombre, c.Descripción
FROM CURSO c INNER JOIN ALUMNO-CURSO ac ON (ac.Cod_Curso = c.Cod_Curso)
GROUP BY c.Cod_Curso, c.Nombre, c.Descripción
HAVING COUNT(*) => ALL
(SELECT COUNT(*)
FROM ALUMNO-CURSO ac
WHERE YEAR(ac.Año) = 2019)
UNION
(SELECT c.Nombre, c.Descripción
FROM CURSO c INNER JOIN ALUMNO-CURSO ac ON (ac.Cod_Curso = c.Cod_Curso)
GROUP BY c.Cod_Curso, c.Nombre, c.Descripción
HAVING COUNT(*) <= ALL
(SELECT COUNT(*)
FROM ALUMNO-CURSO ac
WHERE YEAR(ac.Año) = 2019))

/*
8
Listar el DNI, Apellido, Nombre, Legajo de alumnos que realizaron cursos con nombre conteniendo el string ‘BD’ durante 2018 pero no realizaron ningún curso durante 2019.
*/

SELECT p.DNI, p.Apellido, p.Nombre, a.Legajo
FROM PERSONA p INNER JOIN Alumno a (a.DNI = p.DNI)
INNER JOIN ALUMNO-CURSO ac ON (ac.DNI = a.DNI)
INNER JOIN CURSO c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE (c.nombre LIKE '%BD%') AND YEAR(ac.Año) = 2018
EXCEPT
SELECT p.DNI, p.Apellido, p.Nombre, a.Legajo
FROM PERSONA p INNER JOIN Alumno a (a.DNI = p.DNI)
INNER JOIN ALUMNO-CURSO ac ON (ac.DNI = a.DNI)
INNER JOIN CURSO c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE YEAR(ac.Año) = 2019

/*
9
Agregar un profesor con los datos que prefiera y agregarle el título con código: 25.
*/

INSERT INTO PERSONA (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero) VALUES (20570123, 'Flores', 'Darío', '11/12/1983', 'Casado', 'Hombre')
INSERT INTO PROFESOR (DNI, Matricula, Nro_Expediente) VALUES (20570123, 4458, 3491)
INSERT INTO TITULO-PROFESOR (Cod_Titulo, DNI, Fecha) VALUES (25, 20570123, '8/9/2005')

/*
10
Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado.
*/

UPDATE PERSONA SET Estado_Civil = 'Divorciado' WHERE (SELECT * FROM ALUMNO WHERE Legajo = '2020/09') 

/*
11
Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no dejar el conjunto de relaciones en estado inconsistente.
*/

DELETE FROM PERSONA WHERE DNI = 30568989
DELETE FROM ALUMNO WHERE DNI = 30568989
DELETE FROM ALUMNO-CURSO WHERE DNI = 30568989
