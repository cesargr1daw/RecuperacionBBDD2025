/*alter session set "_oracle_script"=true;	
create user EJERCICIOTRIGGER_PARTE2 identified by EJERCICIOTRIGGER_PARTE2;
GRANT CONNECT, RESOURCE, DBA TO EJERCICIOTRIGGER_PARTE2;*/
-- EJERCICIO 1: CREACION DE TABLAS
create table articulos(	
codigo number(4) not null,	
descripcion varchar2(40), 
precio number (6,2),	
stock number(4),	
constraint PK_articulos_codigo primary key (codigo) );	
create table ventas(	
codigo number(4),	
cantidad number(4),	
fecha date,	
constraint FK_ventas_articulos foreign key (codigo) references articulos(codigo) 
); 

-- EJERCICIO 2: SECUENCIA
CREATE SEQUENCE sec_codigoart START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCYCLE;

-- EJERCICIO 3
CREATE OR REPLACE TRIGGER tr_codigo_articulo
BEFORE INSERT ON articulos
FOR EACH ROW
BEGIN
	:NEW.codigo := sec_codigoart.NEXTVAL;
END;

-- EJERCICIO 4
INSERT INTO articulos (descripcion, precio, stock)
VALUES ('cuaderno rayado 24h', 4.5, 100);

INSERT INTO articulos (descripcion, precio, stock)
VALUES ('cuaderno liso 12h', 3.5, 150);

INSERT INTO articulos (descripcion, precio, stock)
VALUES ('lapices color x6', 8.4, 60);

-- EJERCICIO 5
INSERT INTO articulos VALUES (160, 'regla 20cm.', 6.5, 40);
INSERT INTO articulos VALUES (173, 'compas metal', 14, 35);
INSERT INTO articulos VALUES (234, 'goma lapiz', 0.95, 200);

-- EJERCICIO 6
CREATE OR REPLACE TRIGGER tr_insertar_ventas
BEFORE INSERT ON ventas
FOR EACH ROW
DECLARE
	v_stock articulos.stock%TYPE;
BEGIN
	SELECT stock INTO v_stock FROM articulos WHERE codigo = :NEW.codigo;

	IF :NEW.cantidad > v_stock THEN
		RAISE_APPLICATION_ERROR(-20001, 'Stock insuficiente para realizar la venta.');
	END IF;
	
	UPDATE articulos
	SET stock = stock - :NEW.cantidad
	WHERE codigo = :NEW.codigo;
END;

-- EJERCICIO 7
CREATE OR REPLACE TRIGGER tr_insertar_ventas
BEFORE INSERT ON ventas
FOR EACH ROW
DECLARE
	v_stock articulos.stock%TYPE;
	v_dia	 NUMBER;
	v_hora	NUMBER;
BEGIN
	v_dia := TO_NUMBER(TO_CHAR(SYSDATE, 'D'));
	v_hora := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));

	IF NOT ((v_dia BETWEEN 2 AND 6) AND (v_hora BETWEEN 8 AND 17)) THEN
		RAISE_APPLICATION_ERROR(-20002, 'Las ventas solo pueden realizarse de lunes a viernes de 8 a 18 hs.');
	END IF;

	SELECT stock INTO v_stock FROM articulos WHERE codigo = :NEW.codigo;

	IF :NEW.cantidad > v_stock THEN
		RAISE_APPLICATION_ERROR(-20001, 'Stock insuficiente para realizar la venta.');
	END IF;

	UPDATE articulos
	SET stock = stock - :NEW.cantidad
	WHERE codigo = :NEW.codigo;
END;

-- EJERCICIO 8
CREATE OR REPLACE TRIGGER tr_articulos
BEFORE INSERT OR UPDATE OR DELETE ON articulos
FOR EACH ROW
DECLARE
	v_dia	 NUMBER;
	v_hora	NUMBER;
BEGIN
	v_dia := TO_NUMBER(TO_CHAR(SYSDATE, 'D'));
	v_hora := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));

	IF INSERTING OR DELETING THEN
		IF NOT (v_dia = 7 AND v_hora BETWEEN 8 AND 11) THEN
			RAISE_APPLICATION_ERROR(-20003, 'Solo se permiten inserciones o borrados en articulos los sábados de 8 a 12 hs.');
		END IF;
	ELSIF UPDATING THEN
		IF :OLD.stock != :NEW.stock THEN
			IF NOT ((v_dia BETWEEN 2 AND 6) AND (v_hora BETWEEN 8 AND 17)) THEN
				RAISE_APPLICATION_ERROR(-20004, 'Actualización de stock permitida solo de lunes a viernes de 8 a 18 hs.');
			END IF;
		ELSE
			IF NOT (v_dia = 7 AND v_hora BETWEEN 8 AND 11) THEN
				RAISE_APPLICATION_ERROR(-20005, 'Solo se permite modificar artículos los sábados de 8 a 12 hs.');
			END IF;
		END IF;
	END IF;
END;

-- EJERCICIO 9
CREATE TABLE departamento (
	num_dep		 VARCHAR2(10) PRIMARY KEY,
	nombre			VARCHAR2(10),
	presupuesto NUMBER
);

CREATE TABLE empleado (
	nss			NUMBER PRIMARY KEY,
	nombre	 VARCHAR2(10),
	salario	NUMBER,
	num_dep	VARCHAR2(10),
	CONSTRAINT fk_dep FOREIGN KEY (num_dep) REFERENCES departamento(num_dep)
);

CREATE OR REPLACE TRIGGER tr_insert_empleado
AFTER INSERT ON empleado
FOR EACH ROW
BEGIN
	UPDATE departamento
	SET presupuesto = presupuesto + :NEW.salario
	WHERE num_dep = :NEW.num_dep;
END;

CREATE OR REPLACE TRIGGER tr_update_salario
AFTER UPDATE OF salario ON empleado
FOR EACH ROW
BEGIN
	UPDATE departamento
	SET presupuesto = presupuesto + (:NEW.salario - :OLD.salario)
	WHERE num_dep = :OLD.num_dep;
END;
