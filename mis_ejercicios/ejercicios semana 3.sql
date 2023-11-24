CREATE DATABASE tienda_informatica;
USE tienda_informatica;
CREATE TABLE fabricante(
codigo_fabricante INT PRIMARY KEY,
nombre_fabricante VARCHAR(100)
);
CREATE TABLE producto(
codigo_producto INT PRIMARY KEY,
nombre_producto VARCHAR(100),
precio DOUBLE,
codigo_fabricante1 INT,
FOREIGN KEY (codigo_fabricante1) REFERENCES fabricante(codigo_fabricante)
);

USE tienda_informatica;
INSERT INTO fabricante VALUES(1, 'asus');
INSERT INTO fabricante VALUES(2,'lenovo');
INSERT INTO fabricante VALUES(3, 'hewlett-packard');
INSERT INTO fabricante VALUES(4, 'samsung');
INSERT INTO fabricante VALUES(5, 'seagate');
INSERT INTO fabricante VALUES(6, 'crucial');
INSERT INTO fabricante VALUES(7, 'gigabyte');
INSERT INTO fabricante VALUES(8, 'huawei');
INSERT INTO fabricante VALUES(9, 'xiaomi');

INSERT INTO producto VALUES(1, 'Disco Duro SATA1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8 GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050 Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559,2);
INSERT INTO producto VALUES(9, 'Portátil Ideapad 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

SELECT COUNT(codigo) AS 'número de productos'
FROM producto;

ALTER TABLE fabricante
CHANGE nombre
nombre_fabricante VARCHAR(100);
ALTER TABLE producto
CHANGE codigo
codigo_producto INT;

SELECT nombre_fabricante, COUNT(codigo_producto) AS 'total_productos'
FROM producto
LEFT JOIN fabricante
ON fabricante.codigo_fabricante=producto.codigo_fabricante1
GROUP BY nombre_fabricante
ORDER BY total_productos DESC;

#muestra los productos totales de los fabricantes con precios mayores a 200
SELECT nombre_fabricante, MAX(precio) AS 'precio_maximo', MIN(precio) AS 'precio_minimo', AVG(precio) AS 'precio_promedio', COUNT(nombre_fabricante)
FROM producto
INNER JOIN fabricante
ON fabricante.codigo_fabricante=producto.codigo_fabricante1
GROUP BY nombre_fabricante
HAVING MAX(precio)>200;

SELECT *
FROM fabricante

SELECT *
FROM producto

/*
#este no corre
SELECT nombre_fabricante, MAX(precio) AS 'precio_maximo', MIN(precio) AS 'precio_minimo', AVG(precio) AS 'precio_promedio', COUNT(nombre_fabricante)
FROM producto
INNER JOIN fabricante
ON fabricante.codigo_fabricante=producto.codigo_fabricante1
WHERE precio>200
GROUP BY nombre_fabricante;
*/

# el conteo final es solo de los productos co precio menor a 200
SELECT nombre_fabricante, MAX(precio) AS 'precio_maximo', MIN(precio) AS 'precio_minimo', AVG(precio) AS 'precio_promedio', COUNT(nombre_fabricante)
FROM producto
INNER JOIN fabricante
ON fabricante.codigo_fabricante=producto.codigo_fabricante1
WHERE precio>200
GROUP BY nombre_fabricante;

ALTER TABLE producto
CHANGE nombre
nombre_producto VARCHAR(100);

SELECT nombre_producto, precio
FROM producto

#subcosulta (no jala)
SELECT nombre_producto, precio
FROM producto
WHERE precio=(SELECT MAX(precio) FROM producto);

SELECT *
FROM producto

#no jala
SELECT nombre_producto, precio, nombre_fabricante
FROM producto
INNER JOIN fabricante
ON fabricante.codigo_fabricante= producto.codigo_fabricante1;

#Devuelve todos los productos del fabricante Lenovo. (con INNER JOIN).
SELECT *
FROM producto
INNER JOIN fabricante
ON fabricante.codigo_fabricante=producto.codigo_fabricante1
WHERE nombre_fabricante='lenovo';

#Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT *
FROM producto
WHERE codigo_fabricante1=(SELECT codigo_fabricante
FROM  fabricante
WHERE nombre_fabricante='lenovo');

# Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN).
SELECT *
FROM producto
WHERE precio=(SELECT MAX(precio)
FROM producto
WHERE codigo_producto=(SELECT codigo_producto
FROM fabricante
WHERE nombre_fabricante='lenovo'));

SELECT nombre_producto AS 'producto_mas_caro_lenovo'
FROM producto
WHERE precio=(SELECT MAX(precio)
FROM producto
WHERE codigo_producto=(SELECT codigo_producto
FROM fabricante
WHERE nombre_fabricante='lenovo'));

#cremos tabla que lmacenara los datos trigger no tiene relacion con ninguna otra
CREATE TABLE registro(
id_registro INT AUTO_INCREMENT PRIMARY KEY,
accion VARCHAR(100),
fecha TIMESTAMP
);

#creamos trigger
DELIMITER //
	CREATE TRIGGER trigger_registro BEFORE INSERT ON producto
    FOR EACH ROW BEGIN
    INSERT INTO registro(accion) VALUES("se agrego un producto");
    END//
DELIMITER ;

DROP TRIGGER trigger_registro;

SELECT *
FROM registro;

INSERT INTO producto VALUES(17, 'Mack book', 48, 2);

SELECT *
FROM registro;

SELECT *
FROM producto;
#SE REA TRIGGER PARA MODIFICAR PRODUTO

DELIMITER //
	CREATE TRIGGER trigger_modificacion AFTER UPDATE ON producto
    FOR EACH ROW BEGIN
    INSERT INTO registro(accion) VALUES("se modifico un producto");
    END//
DELIMITER ;

UPDATE producto
SET nombre_producto = 'ASUS'
WHERE codigo_producto=17;


#modificar precio trigger
DELIMITER //
	CREATE TRIGGER modificar_precio BEFORE INSERT ON producto
    FOR EACH ROW BEGIN
    IF NEW.precio > 200 THEN
    SET NEW.precio = NEW.precio - 10; 
    ELSEIF NEW.precio < 200 THEN
    SET NEW.precio = NEW.precio + 10;
    END IF;
    END//
DELIMITER ;

INSERT INTO producto VALUES(40, 'Mack book', 488, 2);
INSERT INTO producto VALUES(50, 'Mack book', 188, 2);

SELECT *
FROM producto;

DROP TRIGGER modificar_precio;

DELIMITER //
	CREATE TRIGGER modificar_precio BEFORE INSERT ON producto
    FOR EACH ROW BEGIN
    IF NEW.precio > 200 THEN
    SET NEW.precio = NEW.precio - 10; 
    ELSEIF NEW.precio < 200 THEN
    SET NEW.precio = NEW.precio + 10;
    END IF;
    INSERT INTO registro(accion) VALUES (concat('se agrego producto con precio de :', NEW.precio));
    END//
DELIMITER ;

INSERT INTO producto VALUES(60, 'Mack book', 188, 2);
#muestra las modificaciones a los productos
SELECT *
FROM registro