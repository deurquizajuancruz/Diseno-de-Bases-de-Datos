/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Localidad = (CodigoPostal, nombreL, descripcion, #habitantes)
Arbol = (nroArbol, especie, años, calle, nro, codigoPostal(fk))
Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
Poda = (codPoda, fecha, DNI(fk), nroArbol(fk))
*/

/*
1
Listar especie, años, calle, nro. y localidad de árboles podados por el podador ‘Juan Perez’ y por el podador ‘Jose Garcia’.
*/

SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
INNER JOIN Poda pod ON (pod.nroArbol = a.nroArbol)
INNER JOIN Podador p ON (p.DNI = pod.DNI)
WHERE (p.nombre = 'Juan') AND (p.apellido = 'Perez')
INTERSECT
SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
NATURAL JOIN Poda pod
INNER JOIN Podador p ON (p.DNI = pod.DNI)
WHERE (p.nombre = 'Jose') AND (p.apellido = 'Garcia')

/*
2
Reportar DNI, nombre, apellido, fnac y localidad donde viven podadores que tengan podas durante 2018.
*/

SELECT po.DNI, po.nombre, po.apellido, po.fnac, l.nombreL
FROM Podador po INNER JOIN Localidad l ON (po.codigoPostalVive = l.codigoPostal)
INNER JOIN Poda p ON (p.DNI = po.DNI)
WHERE YEAR(fecha) = 2018

/*
3
Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.
*/

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE a.nroArbol NOT IN (
    SELECT a.nroArbol
    FROM Arbol a INNER JOIN Poda p ON (p.nroArbol = a.nroArbol)
)

/*
4
Reportar especie, años, calle, nro y localidad de árboles que fueron podados durante 2017 y no fueron podados durante 2018.
*/

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
INNER JOIN Poda p ON (p.nroArbol = a.nroArbol)
WHERE YEAR(p.fecha) = 2017
EXCEPT
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
INNER JOIN Poda p ON (p.nroArbol = a.nroArbol)
WHERE YEAR(p.fecha) = 2018

/*
5
Reportar DNI, nombre, apellido, fnac y localidad donde viven podadores con apellido terminado con el string ‘ata’ y que el podador tenga al menos una poda durante 2018. Ordenar por apellido y nombre.
*/

SELECT pod.DNI, pod.nombre, pod.apellido, pod.fnac, l.nombreL
FROM Podador pod INNER JOIN Localidad l ON (pod.codigoPostalVive = l.codigoPostal)
WHERE (pod.apellido LIKE '%ata')
INTERSECT
(SELECT pod.DNI, pod.nombre, pod.apellido, pod.fnac, l.nombreL
FROM Podador pod INNER JOIN Poda p ON (p.DNI = pod.DNI)
WHERE YEAR(p.fecha) = 2018)
ORDER BY pod.apellido, pod.nombre

/*
6
Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron árboles de especie ‘Coníferas’.
*/

SELECT pod.DNI, pod.apellido, pod.nombre, pod.telefono, pod.fnac
FROM Podador pod INNER JOIN Poda p ON (pod.DNI = p.DNI)
INNER JOIN Arbol a ON (a.nroArbol = p.nroArbol)
WHERE (a.especie = 'Coníferas')
EXCEPT
(
SELECT pod.DNI, pod.apellido, pod.nombre, pod.telefono, pod.fnac
FROM Podador pod INNER JOIN Poda p ON (pod.DNI = p.DNI)
INNER JOIN Arbol a ON (a.nroArbol = p.nroArbol)
WHERE (a.especie <> 'Coníferas'))

/*
7
Listar especie de árboles que se encuentren en la localidad de ‘La Plata’ y también en la localidad de ‘Salta’.
*/

SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE (l.nombreL = 'La Plata')
INTERSECT
(SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE (l.nombreL = 'Salta'))

/*
8
Eliminar el podador con DNI: 22234566.
*/

DELETE FROM Podador WHERE DNI = 22234566
DELETE FROM Poda WHERE DNI = 22234566

/*
9
Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 100 árboles.
*/

SELECT l.nombreL, l.descripcion, l.#habitantes
FROM Localidad l INNER JOIN Arbol a ON (a.codigoPostal = l.CodigoPostal)
GROUP BY l.CodigoPostal, l.nombreL, l.descripcion, l.#habitantes
HAVING COUNT(*)<100