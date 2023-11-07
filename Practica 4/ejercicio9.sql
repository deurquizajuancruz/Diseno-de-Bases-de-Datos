/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Proyecto = (codProyecto, nombrP, descripcion, fechaInicioP, fechaFinP, fechaFinEstimada, DNIResponsable, equipoBackend, equipoFrontend) //DNIResponsable corresponde a un empleado, equipoBackend y equipoFrontend corresponden a un equipo
Equipo = (codEquipo, nombreE, descripcionTecnologias, DNILider)//DNILider corresponde a un empleado
Empleado = (DNI, nombre, apellido, telefono, direccion, fechaIngreso)
Empleado_Equipo = (codEquipo, DNI, fechaInicio, fechaFin, descripcionRol)
*/

/*
1
Listar nombre, descripción, fecha de inicio y fecha de fin de proyectos ya finalizados que no fueron terminados antes de la fecha de fin estimada.
*/

SELECT p.nombrP, p.descripcion, p.fechaInicioP, p.fechaFinP
FROM Proyecto p 
WHERE (p.fechaFinP > p.fechaFinEstimada AND p.fechaFinP < '6/11/2023' )

/*
2
Listar DNI, nombre, apellido, telefono, dirección y fecha de ingreso de empleados que no son, ni fueron responsables de proyectos. Ordenar por apellido y nombre.
*/

SELECT *
FROM Empleado e 
EXCEPT
(SELECT *
FROM Empleado e INNER JOIN Proyecto p ON (e.DNI = p.DNIResponsable))
ORDER BY e.apellido, e.nombre

/*
3
Listar DNI, nombre, apellido, teléfono y dirección de líderes de equipo que tenga más de un equipo a cargo.
*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e INNER JOIN Equipo eq ON (e.DNI = eq.DNILider)
GROUP BY e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
HAVING COUNT(*) > 1

/*
4
Listar DNI, nombre, apellido, teléfono y dirección de todos los empleados que trabajan en el proyecto con nombre ‘Proyecto X’. No es necesario informar responsable y líderes.
*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion 
FROM Empleado e INNER JOIN Empleado_Equipo eq ON (eq.DNI = e.DNI)
INNER JOIN Proyecto p ON (p.equipoFrontend = eq.codEquipo)
WHERE (p.nombrP = 'Proyecto X')
UNION
(SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion 
FROM Empleado e INNER JOIN Empleado_Equipo eq ON (eq.DNI = e.DNI)
INNER JOIN Proyecto p ON (p.equipoBackend = eq.codEquipo)
WHERE (p.nombrP = 'Proyecto X'))

/*
5
Listar nombre de equipo y datos personales de líderes de equipos que no tengan empleados asignados y trabajen con tecnología ‘Java’.
*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion, eq.nombreE
FROM Empleado e INNER JOIN Equipo eq ON (eq.DNILider = e.DNI)
WHERE (eq.descripcionTecnologias = 'Java') AND eq.codEquipo NOT IN 
(SELECT ee.codEquipo
FROM Empleado_Equipo ee)

/*
6
Modificar nombre, apellido y dirección del empleado con DNI: 40568965 con los datos que desee.
*/

UPDATE empleado SET nombre = 'Juana', apellido = 'Lorenzo', direccion = 'Calle 2 N 45' WHERE DNI = 40568965

/*
7
Listar DNI, nombre, apellido, teléfono y dirección de empleados que son responsables de proyectos pero no han sido líderes de equipo.
*/

SELECT e.DNI, e.nombre, e.apellido, e.telefono, e.direccion
FROM Empleado e INNER JOIN Proyecto p ON (e.DNI = p.DNIResponsable)
WHERE e.DNI NOT IN 
(SELECT eq.DNILider
FROM Equipo eq)

/*
8
Listar nombre de equipo y descripción de tecnologías de equipos que hayan sido asignados como equipos frontend y backend.
*/

SELECT eq.nombreE, eq.descripcionTecnologias
FROM Equipo eq INNER JOIN Proyecto p ON (eq.codEquipo = p.equipoBackend)
WHERE (eq.codEquipo IN 
(SELECT eq.codEquipo
FROM Equipo eq INNER JOIN Proyecto p ON (eq.codEquipo = p.equipoFrontend)))

/*
9
Listar nombre, descripción, fecha de inicio, nombre y apellido de responsables de proyectos a finalizar durante 2019.
*/

SELECT p.nombrP, p.descripcion, p.fechaInicioP, e.nombre, e.apellido
FROM Proyecto p INNER JOIN Empleado e ON (p.DNIResponsable = e.DNI)
WHERE (YEAR(fechaFinEstimada) = 2019)