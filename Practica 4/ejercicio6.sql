/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Técnico = (codTec, nombre, especialidad) // técnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac, codRep, cantidad, precio) //repuestos utilizados en reparaciones.
Reparación = (nroReparac, codTec, precio_total, fecha) //reparaciones realizadas.
*/

/*
1
Listar todos los repuestos, informando el nombre, stock y precio. Ordenar el resultado por precio.
*/

SELECT nombre, stock, precio
FROM Repuesto
ORDER BY precio

/*
2
Listar nombre, stock, precio de repuesto que participaron en reparaciones durante 2019 y además no participaron en reparaciones del técnico ‘José Gonzalez’.
*/

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r INNER JOIN RepuestoReparacion rr ON (rr.codRep = r.codRep)
INNER JOIN Reparación rep ON (rep.nroReparac = rr.nroReparac)
WHERE YEAR(rep.fecha) = 2019 AND r.codRep NOT IN 
(SELECT r.codRep
FROM Repuesto r INNER JOIN RepuestoReparacion rr ON (rr.codRep = r.codRep)
INNER JOIN Reparación rep ON (rep.nroReparac = rr.nroReparac)
INNER JOIN Técnico t ON (rep.codTec = t.codTec)
WHERE (t.nombre = 'José Gonzalez'))

/*
3
Listar el nombre, especialidad de técnicos que no participaron en ninguna reparación. Ordenar por nombre ascendentemente.
*/

SELECT t.nombre, t.especialidad
FROM Técnico t
WHERE t.codTec NOT IN 
(SELECT t.codTec
FROM Técnico t INNER JOIN Reparación r ON (r.codTec = t.codTec))
ORDER BY t.nombre

/*
4
Listar el nombre, especialidad de técnicos solo participaron en reparaciones durante 2018.
*/

SELECT t.nombre, t.especialidad
FROM Técnico t INNER JOIN Reparación r ON (r.codTec = t.codTec)
WHERE (YEAR(r.fecha) = 2018 AND t.codTec NOT IN 
(SELECT t.codTec
FROM Técnico t INNER JOIN Reparación r ON (r.codTec = t.codTec)
WHERE (YEAR(r.fecha) <> 2018)))

/*
5
Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un repuesto no participó en alguna reparación igual debe aparecer en dicho listado.
*/

SELECT r.nombre, r.stock, COUNT(r.codTec) AS Cantidad
FROM Repuesto r LEFT JOIN RepuestoReparacion rr ON (rr.codRep = r.codRep)
INNER JOIN Reparación r ON (r.codTec = rr.codTec)
GROUP BY r.codRep, r.nombre, r.stock

/*
6
Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el técnico con menor cantidad de reparaciones.
*/

SELECT t.nombre, t.especialidad
FROM Técnico t INNER JOIN Reparación r ON (r.codTec = t.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) => ALL 
(SELECT COUNT(*)
FROM Reparación r
GROUP BY r.codTec)
UNION
(SELECT t.nombre, t.especialidad
FROM Técnico t INNER JOIN Reparación r ON (r.codTec = t.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) <= SOME 
(SELECT COUNT(*)
FROM Reparación r
GROUP BY r.codTec))

/*
7
Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto no haya estado en reparaciones con precio_total superior a 10000.
*/

SELECT rep.nombre, rep.stock, rep.precio
FROM Repuesto rep
WHERE (rep.stock > 0 AND rep.codRep NOT IN 
(SELECT rr.codRep
FROM RepuestoReparacion rr INNER JOIN Reparación r ON (rr.nroReparac = r.nroReparac)
WHERE (r.precio_total > 10000)))

/*
8
Proyectar precio, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto con precio en el momento de la reparación mayor a $1000 y menor a $5000.
*/

SELECT rr.precio, rep.fecha, rep.precio_total
FROM Reparación rep INNER JOIN RepuestoReparacion rr ON (rr.nroReparac = rep.nroReparac)
WHERE (rr.precio BETWEEN 1000 AND 5000)

/*
9
Listar nombre, stock y precio de repuestos que hayan sido utilizados en todas las reparaciones.
*/

SELECT rep.nombre, rep.stock, rep.precio
FROM Repuesto rep INNER JOIN RepuestoReparacion rr ON (rr.codRep = rep.codRep)
GROUP BY rep.codRep, rep.nombre, rep.stock, rep.precio
HAVING (COUNT(DISTINCT rr.nroReparac) = SELECT COUNT(*) FROM Reparacion)

/*
10
Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 10 repuestos distintos.
*/

SELECT r.fecha, r.precio_total, t.codTec
FROM Reparación r INNER JOIN Técnico t ON (t.codTec = r.codTec)
INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
GROUP BY r.nroReparac, r.fecha, r.precio_total, t.codTec
HAVING COUNT(DISTINCT (rr.codRep)) >= 10