/*
Dadas las siguientes relaciones, resolver utilizando SQL las consultas planteadas.
Cliente = (idCliente, nombre, apellido, DNI, telefono, direccion)
Factura = (nroTicket, total, fecha, hora, idCliente(fk))
Detalle = (nroTicket, idProducto, cantidad, preciounitario)
Producto = (idProducto, descripcion, precio, nombreP, stock) 
*/

/*
1 
Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI.
*/

SELECT *
FROM Cliente
WHERE (apellido LIKE 'Pe%')
ORDER BY DNI

/*
2
Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente durante 2017.
*/

SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente NATURAL JOIN Factura
WHERE YEAR(fecha) = 2017 
EXCEPT
(SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente
WHERE YEAR(fecha)<>2017)

/*
3
Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI:45789456, pero que no fueron vendidos a clientes de apellido ‘Garcia’.
*/

SELECT nombreP, descripcion, precio, stock
FROM Producto NATURAL JOIN Detalle
NATURAL JOIN Factura
NATURAL JOIN Cliente
WHERE (DNI = 45789456)
EXCEPT
(SELECT nombreP, descripcion, precio, stock
FROM Producto NATURAL JOIN Detalle
NATURAL JOIN Factura
NATURAL JOIN Cliente
WHERE (apellido = 'Garcia'))

/*
4
Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan teléfono con característica: 221 (La característica está al comienzo del teléfono). Ordenar por nombre.
*/

SELECT nombreP, descripcion, precio, stock
FROM Producto NATURAL JOIN Detalle
NATURAL JOIN Factura
NATURAL JOIN Cliente
WHERE telefono NOT LIKE '221%'
ORDER BY nombreP

/*
5
Listar para cada producto: nombre, descripción, precio y cuantas veces fué vendido. Tenga en cuenta que puede no haberse vendido nunca el producto.
*/

SELECT nombreP, descripcion, precio, COUNT(nroTicket)
FROM Producto NATURAL JOIN Detalle
GROUP BY idProducto, nombreP, descripcion, precio

/*
6
Listar nombre, apellido, DNI, teléfono y dirección de clientes que compraron los productos con nombre ‘prod1’ y ‘prod2’ pero nunca compraron el producto con nombre ‘prod3’.
*/

(SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente NATURAL JOIN Factura
NATURAL JOIN Detalle
NATURAL JOIN Producto
WHERE (nombreP='prod1')
INTERSECT
SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente NATURAL JOIN Factura
NATURAL JOIN Detalle
NATURAL JOIN Producto
WHERE (nombreP='prod2'))
EXCEPT
(SELECT nombre, apellido, DNI, telefono, direccion
FROM Cliente NATURAL JOIN Factura
NATURAL JOIN Detalle
NATURAL JOIN Producto
WHERE (nombreP='prod3'))

/*
7
Listar nroTicket, total, fecha, hora y DNI del cliente, de aquellas facturas donde se haya comprado el producto ‘prod38’ o la factura tenga fecha de 2019.
*/
SELECT nrotTicket, total, fecha, hora, DNI
FROM Cliente NATURAL JOIN Factura
NATURAL JOIN Detalle
NATURAL JOIN Producto
WHERE (nombreP = 'prod38')
UNION
SELECT nrotTicket, total, fecha, hora, DNI
FROM Cliente NATURAL JOIN Factura
WHERE YEAR(fecha) = 2019


/*
8
Agregar un cliente con los siguientes datos: nombre:’Jorge Luis’, apellido:’Castor’, DNI:40578999, teléfono:221-4400789, dirección:’11 entre 500 y 501 nro:2587’ y el id de cliente: 500002. Se supone que el idCliente 500002 no existe.
*/
INSERT INTO Cliente (idCliente, nombre, apellido, DNI, telefono, direccion) VALUES (500002, 'Jorge Luis', 'Castor', 40578999, 221-4400789, '11 entre 500 y 501 nro:2587')


/*
9
Listar nroTicket, total, fecha, hora para las facturas del cliente ´Jorge Pérez´ donde no haya comprado el producto ´Z´.
*/
SELECT nroTicket, total, fecha, hora
FROM Cliente NATURAL JOIN Factura
NATURAL JOIN Detalle
NATURAL JOIN Producto
WHERE (nombre = 'Jorge') AND (apellido = 'Pérez') AND nroTicket NOT IN 
(SELECT nroTicket
FROM Cliente NATURAL JOIN Factura
NATURAL JOIN Detalle
NATURAL JOIN Producto
WHERE (nombreP='Z'))

/*
10
Listar DNI, apellido y nombre de clientes donde el monto total comprado, teniendo en cuenta todas sus facturas, supere $10.000.000.
*/
SELECT DNI, apellido, nombre
FROM Cliente NATURAL JOIN Factura
GROUP BY DNI, apellido, nombre
HAVING BY (SUM)total>10000000