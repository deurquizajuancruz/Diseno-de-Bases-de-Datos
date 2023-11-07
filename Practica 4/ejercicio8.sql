/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Equipo = (codigoE, nombreE, descripcionE)
Integrante = (DNI, nombre, apellido, ciudad, email, telefono, codigoE(fk))
Laguna = (nroLaguna, nombreL, ubicación, extension, descripción)
TorneoPesca = (codTorneo, fecha, hora, nroLaguna(fk), descripcion)
Inscripcion = (codTorneo, codigoE, asistio, gano)// asistio y gano son true o false según corresponda
*/

/*
1
Listar DNI, nombre, apellido y email de integrantes que sean de la ciudad ‘La Plata’ y estén inscriptos en torneos a disputarse durante 2019.
*/

SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i INNER JOIN Inscripcion ins ON (i.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
WHERE (i.ciudad = 'La Plata' AND YEAR(tp.fecha) = 2019)

/*
2
Reportar nombre y descripción de equipos que solo se hayan inscripto en torneos de 2018.
*/

SELECT e.nombreE, e.descripcionE
FROM Equipo e INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (tp.codTorneo = ins.codTorneo)
WHERE (YEAR(tp.fecha) = 2018)
EXCEPT
(SELECT e.nombreE, e.descripcionE
FROM Equipo e INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
INNER JOIN TorneoPesca tp ON (tp.codTorneo = ins.codTorneo)
WHERE (YEAR(tp.fecha) <> 2018))

/*
3
Listar DNI, nombre, apellido, email y ciudad de integrantes que asistieron a torneos en la laguna con nombre ‘La Salada, Coronel Granada’ y su equipo no tenga inscripciones a torneos a disputarse en 2019.
*/

SELECT i.DNI, i.nombre, i.apellido, i.email, i.ciudad
FROM Integrante i INNER JOIN Inscripcion ins ON (ins.codigoE = i.codigoE)
INNER JOIN TorneoPesca tp ON (tp.codTorneo = ins.codTorneo)
INNER JOIN Laguna l ON (tp.nroLaguna = l.nroLaguna)
WHERE (l.ubicación = 'La Salada, Coronel Granada') AND i.codigoE NOT IN (
    SELECT e.codigoE
    FROM Equipo e INNER JOIN Inscripcion ins ON (e.codigoE = ins.codigoE)
    INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
    WHERE (YEAR(tp.fecha) = 2019)
)

/*
4
Reportar nombre, y descripción de equipos que tengan al menos 5 integrantes. Ordenar por nombre y descripción.
*/

SELECT e.nombreE, e.descripcionE
FROM Equipo e INNER JOIN Integrante i ON (i.codigoE = e.codigoE)
GROUP BY e.codigoE, e.nombreE, e.descripcionE
HAVING COUNT(*) >= 5
ORDER BY e.nombreE, e.descripcionE

/*
5
Reportar nombre, y descripción de equipos que tengan inscripciones en todas las lagunas.
*/

SELECT e.nombreE, e.descripcionE
FROM Equipo e INNER JOIN Inscripcion ins ON (ins.codigoE = e.codigoE)
INNER JOIN TorneoPesca tp ON (ins.codTorneo = tp.codTorneo)
INNER JOIN Laguna l ON (tp.nroLaguna = l.nroLaguna)
GROUP BY e.codigoE, e.nombreE, e.descripcionE
HAVING (COUNT (DISTINCT l.nroLaguna) = SELECT COUNT(*) FROM Laguna)

/*
6
Eliminar el equipo con código:10000
*/

DELETE FROM Equipo WHERE codigoE = 10000
DELETE FROM Inscripcion WHERE codigoE = 10000
DELETE FROM Integrante WHERE codigoE = 10000

/*
7
Listar nombreL, ubicación, extensión y descripción de lagunas que no tuvieron torneos.
*/

SELECT l.nombreL, l.ubicación, l.extension, l.descripción
FROM Laguna l 
WHERE l.nroLaguna NOT IN (
    SELECT tp.nroLaguna
    FROM TorneoPesca tp
)

/*
8
Reportar nombre, y descripción de equipos que tengan inscripciones a torneos a disputarse durante 2019, pero no tienen inscripciones a torneos de 2018
*/

SELECT e.nombreE, e.descripción
FROM Equipo e INNER JOIN Inscripcion ins ON (ins.codigoE = e.codigoE)
INNER JOIN TorneoPesca tp ON (tp.codTorneo = ins.codTorneo)
WHERE (YEAR(tp.fecha) = 2019)
EXCEPT 
(SELECT e.nombreE, e.descripción
FROM Equipo e INNER JOIN Inscripcion ins ON (ins.codigoE = e.codigoE)
INNER JOIN TorneoPesca tp ON (tp.codTorneo = ins.codTorneo)
WHERE (YEAR(tp.fecha) = 2018))
/*
9
Listar DNI, nombre, apellido, ciudad y email de integrantes que ganaron algún torneo que se disputó en la laguna con nombre: ‘Laguna de Chascomús’.
*/

SELECT i.DNI, i.nombre, i.apellido, i.ciudad, i.email
FROM Integrante i INNER JOIN Inscripcion ins ON (ins.codigoE = i.codigoE)
INNER JOIN TorneoPesca tp ON (tp.codTorneo = ins.codTorneo)
INNER JOIN Laguna l ON (tp.nroLaguna = l.nroLaguna)
WHERE (ins.gano = true AND l.nombreL = 'Laguna de Chascomús')