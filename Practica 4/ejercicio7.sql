/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Banda = (codigoB, nombreBanda, genero_musical, año_creacion)
Integrante = (DNI, nombre, apellido, dirección, email, fecha_nacimiento, codigoB(fk))
Escenario = (nroEscenario, nombre_escenario, ubicación, cubierto, m2, descripción)
Recital = (fecha, hora, nroEscenario, codigoB(fk))
*/

/*
1
Listar DNI, nombre, apellido, dirección y email de integrantes nacidos entre 1980 y 1990 y hayan realizado algún recital durante 2018.
*/

SELECT i.DNI, i.nombre, i.apellido, i.email 
FROM Integrante i 
WHERE (YEAR(i.fecha_nacimiento) BETWEEN 1980 AND 1990) AND i.DNI IN 
(SELECT i.DNI
FROM Integrante i INNER JOIN Recital r ON (i.codigoB = r.codigoB)
WHERE (YEAR(r.fecha) = 2018))

/*
2
Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales durante 2018, pero no hayan tocado durante 2017.
*/

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE (YEAR(r.fecha) = 2018) AND b.codigoB NOT IN 
(SELECT b.codigoB
FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE (YEAR(r.fecha) = 2017))

/*
3
Listar el cronograma de recitales del dia 04/12/2018. Se deberá listar: nombre de la banda que ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente.
*/

SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario, e.ubicación
FROM Recital r INNER JOIN Banda b ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE (DAY(r.fecha) = 4 AND MONTH(r.fecha) = 12 AND YEAR(r.fecha) = 2018)

/*
4
Listar DNI, nombre, apellido, email de integrantes que hayan tocado en el escenario con nombre ‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’.
*/

SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i INNER JOIN Recital r ON (i.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE (e.nombre_escenario = 'Gustavo Cerati')
INTERSECT
(SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i INNER JOIN Recital r ON (i.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE (e.nombre_escenario = 'Carlos Gardel'))

/*
5
Reportar nombre, género musical y año de creación de bandas que tengan más de 8 integrantes.
*/

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b INNER JOIN Integrante i ON (i.codigoB = b.codigoB)
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.año_creacion
HAVING COUNT(*) > 8

/*
6
Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales con género musical rock and roll. Ordenar por nombre de escenario.
*/

SELECT e.nombre_escenario, e.ubicación, e.descripción
FROM Escenario e INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
INNER JOIN Banda b ON (r.codigoB = b.codigoB)
WHERE (b.genero_musical = 'Rock and roll' AND e.nroEscenario NOT IN
(SELECT e.nroEscenario
FROM Escenario e INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
INNER JOIN Banda b ON (r.codigoB = b.codigoB)
WHERE (b.genero_musical <> 'Rock and roll')))
ORDER BY e.nombre_escenario

/*
7
Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en escenarios cubiertos durante 2018.// cubierto es true, false según corresponda
*/

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
INNER JOIN Escenario e ON (e.nroEscenario = r.nroEscenario)
WHERE (e.cubierto = true AND YEAR(r.fecha) = 2018)

/*
8
Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2018.
*/

SELECT e.nombre_escenario, COUNT(*) AS Cantidad de recitales
FROM Escenario e INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
WHERE (YEAR(r.fecha) = 2018)
GROUP BY e.nroEscenario, e.nombre_escenario

/*
9
Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’.
*/

UPDATE Banda SET nombreBanda = 'Memphis la Blusera' WHERE nombreBanda = 'Mempis la Blusera'