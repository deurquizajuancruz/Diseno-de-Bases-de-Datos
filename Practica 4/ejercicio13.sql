/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Club = (IdClub, nombreClub, ciudad)
Complejo = (IdComplejo, nombreComplejo, IdClub(fk))
Cancha = (IdCancha, nombreCancha, IdComplejo(fk))
Entrenador = (IdEntrenador, nombreEntrenador, fechaNacimiento, direccion)
Entrenamiento = (IdEntrenamiento, fecha, IdEntrenador(fk), IdCancha(fk))
*/

/*
1
Listar nombre, fecha nacimiento y dirección de entrenadores que hayan tenido entrenamientos durante 2020.
*/

SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
FROM Entrenador e NATURAL JOIN Entrenamiento en
WHERE (YEAR(en.fecha) = 2020)

/*
2
Listar para cada cancha del complejo “Complejo 1”, la cantidad de entrenamientos que se realizaron durante el 2019. Informar nombre de la cancha y cantidad de entrenamientos.
*/

SELECT can.nombreCancha, COUNT(*) AS Cantidad de entrenamientos
FROM Cancha can NATURAL JOIN Complejo c
NATURAL JOIN Entrenamiento e
WHERE (YEAR(e.fecha) = 2019 AND c.nombreComplejo = 'Complejo 1')
GROUP BY can.IdCancha, can.nombreCancha

/*
3
Listar los complejos donde haya realizado entrenamientos el entrenador “Jorge Gonzalez”. Informar nombre de complejo, ordenar el resultado de manera ascendente.
*/

SELECT c.nombreComplejo
FROM Complejo c NATURAL JOIN Cancha can
NATURAL JOIN Entrenamiento e
NATURAL JOIN Entrenador entr
WHERE (entr.nombreEntrenador = 'Jorge Gonzalez')
ORDER BY c.nombreComplejo

/*
4
Listar nombre, fecha de nacimiento y dirección de entrenadores que hayan entrenado en la cancha “Cancha 1” y en la Cancha “Cancha 2”.
*/

SELECT entr.nombre, entr.fechaNacimiento, entr.direccion
FROM Entrenador entr NATURAL JOIN Entrenamiento e
NATURAL JOIN Cancha c 
WHERE (c.nombreCancha = 'Cancha 1' AND entr.IdEntrenador IN
(SELECT entr.IdEntrenador
FROM Entrenador entr NATURAL JOIN Entrenamiento e
NATURAL JOIN Cancha c 
WHERE (c.nombreCancha = 'Cancha 2')))

/*
5
Listar todos los clubes en los que entrena el entrenador “Marcos Perez”. Informar nombre del club y ciudad.
*/

SELECT cl.nombreClub, cl.ciudad
FROM Club cl NATURAL JOIN Complejo
NATURAL JOIN Cancha
NATURAL JOIN Entrenamiento
NATURAL JOIN Entrenador e
WHERE (e.nombreEntrenador = 'Marcos Perez')

/*
6
Eliminar los entrenamientos del entrenador ‘Juan Perez’.
*/

DELETE FROM Entrenamiento entr WHERE (entr.IdEntrenador IN 
(SELECT e.IdEntrenador
FROM Entrenador e
WHERE (e.nombre = 'Juan Perez')))