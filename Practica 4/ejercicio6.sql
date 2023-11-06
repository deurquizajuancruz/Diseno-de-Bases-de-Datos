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

/*
2
Listar nombre, stock, precio de repuesto que participaron en reparaciones durante 2019 y además no participaron en reparaciones del técnico ‘José Gonzalez’.
*/

/*
3
Listar el nombre, especialidad de técnicos que no participaron en ninguna reparación. Ordenar por nombre ascendentemente.
*/

/*
4
Listar el nombre, especialidad de técnicos solo participaron en reparaciones durante 2018.
*/

/*
5
Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo utilizaron. Si un repuesto no participó en alguna reparación igual debe aparecer en dicho listado.
*/

/*
6
Listar nombre y especialidad del técnico con mayor cantidad de reparaciones realizadas y el técnico con menor cantidad de reparaciones.
*/

/*
7
Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que dicho repuesto no haya estado en reparaciones con precio_total superior a 10000.
*/

/*
8
Proyectar precio, fecha y precio total de aquellas reparaciones donde se utilizó algún repuesto con precio en el momento de la reparación mayor a $1000 y menor a $5000.
*/

/*
9
Listar nombre, stock y precio de repuestos que hayan sido utilizados en todas las reparaciones.
*/

/*
10
Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al menos 10 repuestos distintos.
*/

