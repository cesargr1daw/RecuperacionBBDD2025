/*alter session set "_oracle_script"=true;	
create user EJERCICIOTRIGGER identified by EJERCICIOTRIGGER;
GRANT CONNECT, RESOURCE, DBA TO EJERCICIOTRIGGER;*/

create table libros(  
codigo number(6),  
titulo varchar2(40),  
autor varchar2(30),  
editorial varchar2(20),  
precio number(6,2) );  
create table ofertas(  
titulo varchar2(40),  
autor varchar2(30),  
precio number(6,2) );  
create table control(  
usuario varchar2(30),  
fecha date );  


-- EJERCICIO 1
CREATE OR REPLACE TRIGGER tr_registros_oferta 
AFTER INSERT ON ofertas
FOR EACH ROW
BEGIN
	INSERT INTO control VALUES(USER, SYSDATE);
END;

SELECT * FROM CONTROL;

INSERT INTO OFERTAS VALUES('TRILOGIA SEÑOR DE LOS ANILLOS', 'J.R.R. TOLKIEN', 15);

SELECT * FROM CONTROL;

-- EJERCICIO 2

insert into libros values(100,'Uno','Richard Bach','Planeta',25.100);  
insert into libros values(103,'El aleph','Borges','Emece',28.0);  
insert into libros values(105,'Matematica estas ahi','Paenza','Nuevo siglo',12.50);  
insert into libros values(120,'Aprenda PHP','Molina Mario','Nuevo siglo',55.200);  
insert into libros values(145,'Alicia en el pais de las maravillas','Carroll','Planeta',35.10);  

CREATE OR REPLACE TRIGGER tr_redondear_precio
BEFORE INSERT OR UPDATE OF precio ON libros
FOR EACH ROW
BEGIN
	IF :NEW.precio>50 THEN :NEW.precio:=ROUND(:NEW.precio);
	END IF;
END;

--SE COMPRUEBA QUE EL LBRO CON ID 120 TIENE EL PRECIO REDONDEADO
SELECT * FROM LIBROS;


-- EJERCICIO 3
ALTER TABLE libros ADD stock NUMBER(5);

CREATE OR REPLACE TRIGGER tr_control_update_libros
BEFORE UPDATE ON libros
FOR EACH ROW
BEGIN
	IF :NEW.codigo!=:OLD.codigo 
		THEN RAISE_APPLICATION_ERROR(-20001, '"NO SE DEBE MODIFICAR EL ID.');
	END IF;
	IF :NEW.precio!=:OLD.precio THEN
		IF :NEW.precio<=0
			THEN RAISE_APPLICATION_ERROR(-20002, 'EL PRECIO DEBE SER MAYOR QUE 0');
		END IF;
	END IF;
	IF :NEW.stock!=:OLD.stock THEN
		IF :NEW.stock<0 OR :NEW.stock>1000
			THEN RAISE_APPLICATION_ERROR(-20003, 'EL STOCK DEBE SER MAYOR A 0 Y MENOR A 1000');
		END IF;
	END IF;
END;

 --Error: No se permite modificar el código del libro.
UPDATE libros SET codigo = 999999 WHERE codigo = 100;
-- Error: El precio debe ser mayor que cero. Se mantiene el valor anterior.
UPDATE libros SET precio = -10 WHERE codigo = 100;
-- Error: El stock debe estar entre 0 y 1000.
UPDATE libros SET stock = 1500 WHERE codigo = 100;


-- EJERCICIO 4
ALTER TABLE control ADD accion VARCHAR2(20);

CREATE OR REPLACE TRIGGER tr_control_libros
AFTER INSERT OR UPDATE OR DELETE ON libros
FOR EACH ROW
BEGIN
	IF INSERTING THEN INSERT INTO control VALUES(USER,SYSDATE, 'INSERCIÓN');
	ELSIF UPDATING THEN INSERT INTO control VALUES(USER,SYSDATE, 'ACTUALIZACIÓN');
	ELSE
		INSERT INTO control VALUES(USER,SYSDATE, 'BORRADO');
	END IF;
END;


INSERT INTO libros (codigo, titulo, autor, editorial, precio, stock)
VALUES (200001, 'Libro A', 'Autor 1', 'Editorial X', 25.50, 100);
INSERT INTO libros (codigo, titulo, autor, editorial, precio, stock)
VALUES (200002, 'Libro B', 'Autor 2', 'Editorial Y', 15.00, 50);
INSERT INTO libros (codigo, titulo, autor, editorial, precio, stock)
VALUES (200003, 'Libro C', 'Autor 3', 'Editorial Z', 45.75, 300);

UPDATE libros SET stock = 200 WHERE codigo = 200001;
UPDATE libros SET precio = 28.99 WHERE codigo = 200002;
UPDATE libros SET titulo = 'Libro C Actualizado' WHERE codigo = 200003;

DELETE FROM libros WHERE codigo = 200001;
DELETE FROM libros WHERE codigo = 200002;
DELETE FROM libros WHERE codigo = 200003;

SELECT * FROM control;

CREATE OR REPLACE TRIGGER tr_restricciones_libros
BEFORE INSERT OR UPDATE OR DELETE ON libros
FOR EACH ROW
DECLARE
	v_dia  NUMBER;
	v_hora NUMBER;
BEGIN
 	v_dia := TO_NUMBER(TO_CHAR(SYSDATE, 'D'));
 	v_hora := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
	IF INSERTING OR DELETING THEN
		IF v_dia != 7 OR v_hora < 8 OR v_hora >= 12 THEN
			RAISE_APPLICATION_ERROR(-20001, 'SOLO SE PERMITE INSERTAR O BORRAR LIBROS LOS SABADOS DE 8 A 12 H.');
		END IF;
	ELSIF UPDATING THEN
	IF :NEW.precio != :OLD.precio THEN
		IF NOT ((v_dia BETWEEN 2 AND 6 AND v_hora BETWEEN 8 AND 17) OR (v_dia = 7 AND v_hora BETWEEN 8 AND 11)) 
          THEN RAISE_APPLICATION_ERROR(-20002, 'SOLO SE PERMITE ACTUALIZAR PRECIOS DE LUNES A VIERNES DE 8 A 18 H O SABADOS DE 8 A 12 H.');
      END IF;
    END IF;
  END IF;
END;

-- CORRECTO
UPDATE libros SET precio = 35 WHERE codigo = 100001;

-- ERROR
INSERT INTO libros VALUES (300001, 'Prueba', 'Autor', 'Ed', 20.00, 100);


--ERROR
INSERT INTO libros VALUES (300002, 'Sábado válido', 'Autor', 'Ed', 29.99, 10);

-- CORRECTO
UPDATE libros SET precio = 33 WHERE codigo = 300002;
