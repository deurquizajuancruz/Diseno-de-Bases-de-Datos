/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Vehiculo = (patente, modelo, marca, peso, km)
Camion = (patente, largo, max_toneladas, cant_ruedas, tiene_acoplado)
Auto = (patente, es_electrico, tipo_motor)
Service = (fecha, patente, km_service, observaciones, monto)
Parte = (cod_parte, nombre, precio_parte)
Service_Parte = (fecha, patente, cod_parte, precio)
*/

/*
1
Listar todos los datos de aquellos camiones que tengan entre 4 y 8 ruedas, y que hayan realizado algún service en los últimos 365 días. Ordenar por patente, modelo y marca.
*/

SELECT c.patente, c.largo, c.max_toneladas, c.cant_ruedas, c.tiene_acoplado, v.modelo, v.marca, v.peso, v.km
FROM Camion c INNER JOIN Vehiculo v ON (c.patente = v.patente)
INNER JOIN Service s ON (c.patente = s.patente)
WHERE ((c.cant_ruedas BETWEEN 4 AND 8) AND (s.fecha BETWEEN '06/11/2022' AND '06/11/2023'))

/*
2
Listar los autos que hayan realizado el service “cambio de aceite” antes de los 13.000 km o hayan realizado el service “inspección general” que incluya la parte “filtro de combustible”.
*/

SELECT a.patente, a.es_electrico, a.tipo_motor,
FROM Auto a INNER JOIN Service s ON (a.patente = s.patente)
WHERE (s.observaciones = 'Cambio de aceite' AND s.km_service<13000)
UNION
(SELECT a.patente, a.es_electrico, a.tipo_motor,
FROM Auto a INNER JOIN Service s ON (a.patente = s.patente)
INNER JOIN Service_Parte sp ON (sp.patente = s.patente AND sp.fecha = s.fecha)
INNER JOIN Parte p ON (p.cod_parte = sp.cod_parte)
WHERE (p.nombre = 'Filtro de combustible' AND (s.observaciones = 'Inspección general')))

/*
3
Listar nombre y precio de todas las partes que aparezcan en más de 30 service que hayan salido (partes) más de $4.000.
*/

SELECT par.nombre, par.precio_parte
FROM Parte par INNER JOIN Service_Parte s ON (s.cod_parte = par.cod_parte)
WHERE (par.precio_parte > 4000)
GROUP BY par.cod_parte, par.nombre, par.precio_parte
HAVING COUNT(*) > 30

/*
4
Dar de baja todos los camiones con más de 250.000 km.
*/

DELETE FROM Service_Parte WHERE c.patente IN
(SELECT c.patente
FROM Camion c INNER JOIN Vehiculo v ON (v.patente = c.patente)
WHERE v.km > 250000)

DELETE FROM Service WHERE c.patente IN
(SELECT c.patente
FROM Camion c INNER JOIN Vehiculo v ON (v.patente = c.patente)
WHERE v.km > 250000)

DELETE FROM Camion WHERE c.patente IN 
(SELECT c.patente
FROM Camion c INNER JOIN Vehiculo v ON (v.patente = c.patente)
WHERE v.km > 250000)

DELETE FROM Vehiculo WHERE c.patente IN
(SELECT c.patente
FROM Camion c INNER JOIN Vehiculo v ON (v.patente = c.patente)
WHERE v.km > 250000)

/*
5
Listar el nombre y precio de aquellas partes que figuren en todos los service realizados en el corriente año.
*/

SELECT nombre, precio_parte
FROM Parte p
WHERE NOT EXISTS
(SELECT *
FROM SERVICE s
WHERE NOT EXISTS
(SELECT *
FROM SERVICE_PARTE sp
WHERE (s.fecha_patente = sp.fecha_patente AND p.cod_parte = sp.cod_parte AND YEAR(fecha) = 2023)))

/*
6
Listar todos los autos cuyo tipo de motor sea eléctrico. Mostrar información de patente, modelo, marca y peso.
*/

SELECT a.patente, v.modelo, v.marca, v.peso
FROM Auto a INNER JOIN Vehiculo v ON (a.patente = v.patente)
WHERE (a.es_electrico = true)

/*
7
Dar de alta una parte, cuyo nombre sea “Aleron” y precio $400.
*/

INSERT INTO Parte (nombre, precio_parte) VALUES ('Aleron',4000)

/*
8
Dar de baja todos los services que se realizaron al auto con patente ‘AWA564’.
*/

DELETE FROM Service s WHERE s.patente = 'AWA564'
DELETE FROM Service_Parte sp WHERE sp.patente = 'AWA564'

/*
9
Listar todos los vehículos que hayan tenido services durante el 2018.
*/

SELECT *
FROM Vehiculo v INNER JOIN Service_Parte sp ON (sp.patente = v.patente)
WHERE (YEAR(sp.fecha) = 2018)