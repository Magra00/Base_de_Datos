CREATE DATABASE test;
USE test;
CREATE TABLE alumno(
id_alumno INT PRIMARY KEY,
nombre_alumno VARCHAR(100),
apellido1_alumno VARCHAR(100), 
apellido2_alumno VARCHAR(100),
nota INT
)

#Trigger 1: trigger_check_nota_before_insert

DELIMITER //
	CREATE TRIGGER trigger_check_nota_before_insert BEFORE INSERT ON alumno
    FOR EACH ROW BEGIN
    IF NEW.nota < 0 THEN
    SET NEW.nota = 0; 
    ELSEIF NEW.nota > 10 THEN
    SET NEW.nota = 10;
    END IF;
    END//
DELIMITER ;

#Trigger2 : trigger_check_nota_before_update

DELIMITER // 
	CREATE TRIGGER trigger_check_nota_before_update BEFORE UPDATE ON alumno
    FOR EACH ROW BEGIN
    IF NEW.nota < 0 THEN
    SET NEW.nota = 0; 
    ELSEIF NEW.nota > 10 THEN
    SET NEW.nota = 10;
    END IF;
    END//
DELIMITER ;


#cremos tabla que lmacenara los datos trigger no tiene relacion con ninguna otra
CREATE TABLE actualizacion(
id_registro INT AUTO_INCREMENT PRIMARY KEY,
accion VARCHAR(100),
fecha TIMESTAMP
);

#creamos trigger de ingreso alumno
DELIMITER //
	CREATE TRIGGER trigger_actualizacion BEFORE INSERT ON alumno
    FOR EACH ROW BEGIN
    INSERT INTO alumno(accion) VALUES("se agrego un alumno");
    END//
DELIMITER ;

#SE cREA TRIGGER PARA MODIFICAR alumno

DELIMITER //
	CREATE TRIGGER trigger_modificacion AFTER UPDATE ON alumno
    FOR EACH ROW BEGIN
    INSERT INTO alumno(accion) VALUES("se modifico un alumno");
    END//
DELIMITER ;

DROP TRIGGER trigger_actualizacion;
DROP TRIGGER trigger_modificacion;

INSERT INTO alumno VALUES(20, 'MARTHA', 'GRANDE', 'ABRIZ',15);
INSERT INTO alumno VALUES(21, 'MARTHA', 'GRANDE', 'ABRIZ',-5);
INSERT INTO alumno VALUES(22, 'MARTHA', 'GRANDE', 'ABRIZ',10);

SELECT *
FROM alumno;

UPDATE alumno
SET nota = 20
WHERE id_alumno =21;

SELECT *
FROM alumno;

SELECT *
FROM actualizacion;

INSERT INTO alumno VALUES(25, 'MARTHA', 'GRANDE', 'ABRIZ',7);
INSERT INTO alumno VALUES(26, 'MARTHA', 'GRANDE', 'ABRIZ',-6);
INSERT INTO alumno VALUES(27, 'MARTHA', 'GRANDE', 'ABRIZ',20);