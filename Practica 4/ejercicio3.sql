/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Club = (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
Ciudad = (codigoCiudad, nombre)
Estadio = (codigoEstadio, codigoClub(FK), nombre, direccion)
Jugador = (DNI, nombre, apellido, edad, codigoCiudad(FK))
ClubJugador = (codigoClub, DNI, desde, hasta)
*/

/*
1
Reportar nombre y anioFundacion de aquellos clubes de la ciudad de La Plata que no poseen estadio.
*/

SELECT cl.nombre, cl.anioFundacion
FROM Club cl INNER JOIN Ciudad c ON (c.codigoCiudad = cl.codigoCiudad)
WHERE (c.nombre = 'La Plata')
EXCEPT 
(SELECT cl.nombre, cl.anioFundacion
FROM Club cl INNER JOIN Estadio e ON (cl.codigoClub = e.codigoClub)
)

/*
2
Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de Berisso.
*/

SELECT cl.nombre
FROM Club cl 
EXCEPT
(SELECT cl.nombre 
FROM Club cl INNER JOIN ClubJugador clubJ ON (cl.codigoClub = clubJ.codigoClub)
INNER JOIN Jugador j ON (j.DNI = clubJ.DNI)
INNER JOIN Ciudad c ON (j.codigoCiudad = c.codigoCiudad)
WHERE (c.nombre = 'Berisso'))

/*
3
Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club Gimnasia y Esgrima La Plata.
*/

SELECT j.DNI, j.nombre, j.apellido
FROM Jugador j INNER JOIN ClubJugador clubJ ON (clubJ.DNI = j.DNI)
INNER JOIN Club c ON (clubJ.codigoClub = c.codigoClub)
WHERE (c.nombre = 'Gimnasia y Esgrima La Plata')

/*
4
Mostrar DNI, nombre y apellido de aquellos jugadores que tengan más de 29 años y hayan jugado o juegan en algún club de la ciudad de Córdoba.
*/

SELECT j.DNI, j.nombre, j.apellido
FROM Jugador j INNER JOIN ClubJugador clubJ ON (clubJ.dni = j.DNI)
INNER JOIN Club c ON (clubJ.codigoClub = c.codigoClub)
INNER JOIN Ciudad ciu ON (ciu.codigoCiudad = c.codigoCiudad)
WHERE (j.edad>29) AND (ciu.nombre = 'Córdoba')

/*
5
Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan actualmente en cada uno.
*/

SELECT cl.nombre, AVG(j.edad)
FROM Club cl INNER JOIN ClubJugador clubJ ON (cl.codigoClub = clubJ.codigoClub)
INNER JOIN Jugador j ON (clubJ.DNI = j.DNI)
WHERE (clubJ.desde<='5/11/2023') AND (clubJ.hasta>='5/11/2023')
GROUP BY cl.codigoClub, cl.nombre

/*
6
Listar para cada jugador: nombre, apellido, edad y cantidad de clubes diferentes en los que jugó. (Incluido el actual).
*/

SELECT j.nombre, j.apellido, j.edad, COUNT (*) as Cantidad
FROM Jugador j INNER JOIN ClubJugador clubJ ON (clubJ.DNI = j.DNI)
GROUP BY j.DNI, j.nombre, j.apellido, j.edad

/*
7
Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar del Plata.
*/

SELECT cl.nombre
FROM Club cl
EXCEPT
(SELECT cl.nombre
FROM Club cl INNER JOIN ClubJugador clubJ ON (clubJ.codigoClub = cl.codigoClub)
INNER JOIN Jugador j ON (clubJ.DNI = j.DNI)
INNER JOIN Ciudad ciu ON (ciu.codigoCiudad = j.codigoCiudad)
WHERE (ciu.nombre = 'Mar del Plata'))


/*
8
Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los clubes.
*/

SELECT j.nombre, j.apellido
FROM Jugador j INNER JOIN ClubJugador clubJ (clubJ.DNI = j.DNI)
INNER JOIN Club cl (clubJ.codigoClub = cl.codigoClub)
GROUP BY j.DNI, j.nombre, j.apellido
WHERE (COUNT(DISTINCT club.codigoClub)) = (SELECT COUNT(*) FROM Club)

/*
9
Agregar con codigoClub 1234 el club “Estrella de Berisso” que se fundó en 1921 y que pertenece a la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la tabla Club.
*/

INSERT INTO Club (codigoClub, nombre, anioFundacion, codigoCiudad) VALUES (1234, 'Estrella de Berisso', 1921, (SELECT ciu.codigoCiudad FROM Ciudad ciu WHERE ciu.nombre = 'Berisso'))