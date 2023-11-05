/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Localidad = (CodigoPostal, nombreL, descripcion, #habitantes)
Arbol = (nroArbol, especie, años, calle, nro, codigoPostal(fk))
Podador = (DNI, nombre, apellido, telefono,fnac,codigoPostalVive(fk))
Poda = (codPoda,fecha, DNI(fk),nroArbol(fk))
*/

/*
1
Listar especie, años, calle, nro. y localidad de árboles podados por el podador ‘Juan Perez’ y por el podador ‘Jose Garcia’.
*/

/*
2
Reportar DNI, nombre, apellido, fnac y localidad donde viven podadores que tengan podas durante 2018.
*/

/*
3
Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca.
*/

/*
4
Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2017 y no fueron podados durante 2018.
*/

/*
5
Reportar DNI, nombre, apellido, fnac y localidad donde viven podadores con apellido terminado con el string ‘ata’ y que el podador tenga al menos una poda durante 2018. Ordenar por apellido y nombre.
*/

/*
6
Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron árboles de especie ‘Coníferas’.
*/

/*
7
Listar especie de árboles que se encuentren en la localidad de ‘La Plata’ y también en la localidad de ‘Salta’.
*/

/*
8
Eliminar el podador con DNI: 22234566.
*/

/*
9
Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de 100 árboles.
*/