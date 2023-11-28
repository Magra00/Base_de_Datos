CREATE DATABASE proveedores;
USE proveedores;
CREATE TABLE proveedor(
codigo_proveedor INT PRIMARY KEY,
nombre_proveedor VARCHAR(100),
direccion_proveedor VARCHAR(100),
ciudad_proveedor VARCHAR(100),
provincia_proveedor VARCHAR(100)
);

CREATE TABLE categoria(
codigo_categoria VARCHAR(100) PRIMARY KEY,
nombre_categoria VARCHAR(100)
);

CREATE TABLE pieza(
codigo_pieza INT PRIMARY KEY,
nombre_pieza VARCHAR(100),
color_pieza VARCHAR(100),
precio_pieza DOUBLE,
categoria VARCHAR(100),
codigo_categoria1 VARCHAR(100),
FOREIGN KEY (codigo_categoria1) REFERENCES categoria(codigo_categoria)
);

CREATE TABLE entrega(
fecha_entrega VARCHAR(100),
cantidad_entregados INT,
codigo_proveedor1 INT,
FOREIGN KEY (codigo_proveedor1) REFERENCES proveedor(codigo_proveedor),
codigo_pieza1 INT,
FOREIGN KEY (codigo_pieza1) REFERENCES pieza(codigo_pieza)
);

INSERT INTO proveedor VALUES(001, 'PROV1', 'DIRECCION', 'CIUDAD', 'PROVINCIA');
INSERT INTO proveedor VALUES(002, 'PROV2', 'DIRECCION2', 'CIUDAD2', 'PROVINCIA2');
INSERT INTO proveedor VALUES(003, 'PROV3', 'DIRECCION3', 'CIUDAD3', 'PROVINCIA3');

INSERT INTO categoria VALUES('C1', 'CATEGORIA1');
INSERT INTO categoria VALUES('C2', 'CATEGORIA2');
INSERT INTO categoria VALUES('C3', 'CATEGORIA3');

INSERT INTO pieza VALUES(111, 'PIEZA1', 'COLOR1', 11.1, 'CATEGORIA1', 'C1');
INSERT INTO pieza VALUES(112, 'PIEZA2', 'COLOR1', 11.1, 'CATEGORIA2', 'C2');
INSERT INTO pieza VALUES(113, 'PIEZA3', 'COLOR3', 13.5, 'CATEGORIA3', 'C3');

SELECT *
FROM proveedor;

SELECT *
FROM pieza;

INSERT INTO entrega VALUES('20-11-2023', 15, 001, 111);
INSERT INTO entrega VALUES('20-11-2023', 5, 002, 112);
INSERT INTO entrega VALUES('22-11-2023', 5, 001, 111);

SELECT *
FROM entrega;