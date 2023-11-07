/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
AGENCIA = (RAZON_SOCIAL, dirección, telef, e-mail)
CIUDAD  = (CODIGOPOSTAL, nombreCiudad, añoCreación)
CLIENTE  = (DNI, nombre, apellido, teléfono, dirección)
VIAJE = (FECHA, HORA, DNI, cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)
//cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje
*/

/*
1
Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de ‘La Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y luego por teléfono.
*/

SELECT a.RAZON_SOCIAL, a.dirección, a.telef
FROM AGENCIA a INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
INNER JOIN CIUDAD c ON (c.CODIGOPOSTAL = v.cpOrigen)
INNER JOIN CLIENTE cli ON (v.DNI = cli.DNI)
WHERE (c.nombreCiudad = 'La Plata') AND (cli.apellido = 'Roma')
ORDER BY a.RAZON_SOCIAL, a.telef

/*
2
Listar fecha, hora, datos personales del cliente, ciudad origen y destino de viajes realizados en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’.
*/

SELECT v.FECHA, v.HORA, cli.DNI, cli.nombre, cli.apellido, cli.teléfono, cli.dirección, origen.nombreCiudad, destino.nombreCiudad
FROM Cliente cli INNER JOIN VIAJE v ON (cli.DNI = v.DNI)
INNER JOIN CIUDAD origen ON (origen.CODIGOPOSTAL = v.cpOrigen)
INNER JOIN CIUDAD destino ON (destino.CODIGOPOSTAL = v.cpDestino)
WHERE YEAR(v.FECHA) = 2019 AND MONTH (v.fecha) = 1 AND v.descripcion LIKE '%demorado%'
 

/*
3
Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección de mail que termine con ‘@jmail.com’.
*/

SELECT a.RAZON_SOCIAL, a.direccion, a.telef, a.e-mail
FROM AGENCIA a INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
WHERE YEAR(v.fecha) = 2019
UNION
SELECT a.RAZON_SOCIAL, a.direccion, a.telef, a.e-mail
FROM AGENCIA a INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
WHERE (a.e-mail LIKE '%@jmail.com')

/*
4
Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel Brandsen’.
*/

SELECT cli.DNI, cli.nombre, cli.apellido, cli.teléfono, cli.dirección
FROM CLIENTE cli INNER JOIN VIAJE v ON (cli.DNI = v.DNI)
INNER JOIN CIUDAD destino ON (destino.CODIGOPOSTAL = v.cpDestino)
WHERE (destino.nombreCiudad = 'Coronel Brandsen')
EXCEPT
(SELECT cli.DNI, cli.nombre, cli.apellido, cli.teléfono, cli.dirección
FROM CLIENTE cli INNER JOIN VIAJE v ON (cli.DNI = v.DNI)
INNER JOIN CIUDAD destino ON (destino.CODIGOPOSTAL = v.cpDestino)
WHERE (destino.nombreCiudad <> 'Coronel Brandsen'))

/*
5
Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’.
*/

SELECT COUNT(*) AS Cantidad
FROM AGENCIA a INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
INNER JOIN CIUDAD destino ON (destino.CODIGOPOSTAL = v.cpDestino)
WHERE (a.RAZON_SOCIAL = 'TAXI Y') AND (destino.nombreCiudad = 'Villa Elisa')


/*
6
Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias.
*/

SELECT cli.nombre, cli.apellido, cli.direccion, cli.telefono
FROM Cliente cli INNER JOIN Viaje v ON (cli.DNI = v.DNI)
GROUP BY cli.DNI, cli.nombre, cli.apellido, cli.direccion, c.telefono
HAVING COUNT(DISTINCT v.RAZON_SOCIAL) = (SELECT COUNT(*) FROM AGENCIA);

/*
7
Modificar el cliente con DNI: 38495444 actualizando el teléfono a: 221-4400897.
*/

UPDATE CLIENTE SET teléfono = 221-4400897 WHERE DNI = 38495444

/*
8
Listar razon_social, dirección y teléfono de la/s agencias que tengan mayor cantidad de viajes realizados.
*/

SELECT a.RAZON_SOCIAL, a.dirección, a.telef,
FROM AGENCIA a INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
GROUP BY a.RAZON_SOCIAL, a.direccion, a.telef
HAVING COUNT(*) >= ALL 
(SELECT COUNT(*) 
FROM VIAJE v
GROUP BY v.razon_social)

/*
9
Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes.
*/

SELECT cli.nombre, cli.apellido, cli.dirección, cli.teléfono
FROM CLIENTE cli INNER JOIN VIAJE v ON (cli.DNI = v.DNI)
GROUP BY cli.DNI, cli.nombre, cli.apellido, cli.dirección, cli.teléfono
HAVING COUNT(*) >= 10

/*
10
Borrar al cliente con DNI 40325692.
*/

DELETE FROM CLIENTE WHERE DNI = 40325692
DELETE FROM VIAJE WHERE DNI = 40325692