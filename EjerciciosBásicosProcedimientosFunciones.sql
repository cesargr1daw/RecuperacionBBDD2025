/*
1. Realizar un procedure que muestre los números múltiplos de 5 de 0 a 100.
2. Procedure que muestre por pantalla todos los números comprendidos entre 1 y 100 que son
múltiplos de 7 o de 13.
3. Realizar un procedure que muestre los número múltiplos del primer parámetro que van desde el
segundo parámetro hasta el tercero.
4. Procedure que reciba un número entero por parámetro y visualice su tabla de multiplicar
5. Realizar un procedure que muestre los número comprendidos desde el primer parámetro hasta
el segundo.
6. Realizar un procedure que cuente de 20 en 20, desde el primer parámetro hasta el segundo.
7. Realizar un procedure que reciba dos números como parámetro, y muestre el resultado de
elevar el primero parámetro al segundo.
8. Realizar un procedure que reciba dos números como parámetro y muestre el resultado de elevar
el primero número a 1, a 2... hasta el segundo número.
9. Procedure que tome un número N que se le pasa por parámetro y muestre la suma de los N
primeros números.
10. Función que tome como parámetros dos números enteros A y B, y calcule el producto de A y B
mediante sumas, mostrando el resultado y devolviéndolo.
11. Procedure que tome como parámetros dos números B y E enteros positivos, y calcule la potencia
(B elevado a E) a través de productos.
12. Realizar un procedure que reciba como parámetro un número entero positivo N y calcule el
factorial.
Factorial (0)= 1
Factorial (1)= 1
Factorial (N) = N * Factorial(N – 1)
13. Realizar un procedure que reciba como parámetros número N entero positivo y calcule la suma
de los inversos de N es decir
1/1 + 1/2 + 1/3 + 1/4 + ...... 1/N
*/

--EJERCICIO 1
CREATE OR REPLACE PROCEDURE pr_multiplos_5 IS 
BEGIN 
	FOR i IN 1..100 LOOP
		IF MOD(i,5)=0
			THEN DBMS_OUTPUT.PUT_LINE(i);
		END IF;
	END LOOP;
END;

BEGIN
	pr_multiplos_5();
END;

--EJERCICIO 2
CREATE OR REPLACE PROCEDURE pr_multiplos_7_or_13 IS 
BEGIN 
	FOR i IN 1..100 LOOP 
		IF MOD(i,7)=0 OR MOD(i,13)=0
			THEN DBMS_OUTPUT.PUT_LINE(i);
		END IF;
	END LOOP;
END;

BEGIN
	pr_multiplos_7_or_13();
END;

--EJERCICIO 3
CREATE OR REPLACE PROCEDURE pr_multiplos(v_parametro1 NUMBER, v_parametro2 NUMBER, v_parametro3 NUMBER) IS 
BEGIN 
	FOR i IN v_parametro2..v_parametro3 LOOP 
		IF MOD (i,v_parametro1)=0
			THEN DBMS_OUTPUT.PUT_LINE(i);
		END IF;
	END LOOP;
END;


BEGIN
	pr_multiplos(2,1,20);
END;

--EJERCICIO 4
CREATE OR REPLACE PROCEDURE pr_TABLA_MULTIPLICAR(v_multiplicador NUMBER) IS 
BEGIN 
	FOR i IN 1..10 LOOP 
		DBMS_OUTPUT.PUT_LINE(v_multiplicador*i);
	END LOOP;
END;
		
BEGIN
	pr_TABLA_MULTIPLICAR(3);
END;

--EJERCICIO 5
CREATE OR REPLACE PROCEDURE pr_mostrar_rango(v_limite_inferior NUMBER, v_limite_superior NUMBER) IS 
BEGIN 
	FOR i IN v_limite_inferior..v_limite_superior LOOP 
		DBMS_OUTPUT.PUT_LINE(i);
	END LOOP;
END;

BEGIN
	pr_mostrar_rango(2,8);
END;

--EJERCICIO 6
CREATE OR REPLACE PROCEDURE pr_SUMATORIO_20_rango(v_limite_inferior NUMBER, v_limite_superior NUMBER) 
IS 
	v_sumatorio NUMBER:=0;
BEGIN 
	FOR i IN v_limite_inferior..v_limite_superior LOOP
		v_sumatorio:=v_sumatorio+20;
		DBMS_OUTPUT.PUT_LINE(v_sumatorio);
	END LOOP;	
END;

BEGIN
	pr_SUMATORIO_20_rango(1,10);
END;

--EJERCICIO 7
CREATE OR REPLACE PROCEDURE pr_potencia(v_num1 NUMBER, v_num2 NUMBER) 
IS
	v_multiplo NUMBER := 1;
BEGIN
	FOR i IN 1..v_num2 LOOP
		v_multiplo := v_multiplo * v_num1;
		DBMS_OUTPUT.PUT_LINE(v_multiplo);
	END LOOP;
END;


BEGIN
	pr_potencia(2, 3);
END;

--EJERCICIO 8
CREATE OR REPLACE PROCEDURE pr_elevar_par1_to_par2(v_par1 NUMBER, v_par2 NUMBER) IS
v_elevado NUMBER;
BEGIN
	FOR i IN 1..v_par2 LOOP
		v_elevado :=1;
		FOR j IN 1..i LOOP
			v_elevado:=v_elevado*v_par1;
		END LOOP;
		DBMS_OUTPUT.PUT_LINE(v_elevado);
	END LOOP;
END;


CREATE OR REPLACE PROCEDURE pr_elevar_par1_to_par2_verion2(v_par1 NUMBER, v_par2 NUMBER) IS
BEGIN
	FOR i IN 1..v_par2 LOOP
		DBMS_OUTPUT.PUT_LINE(POWER(v_par1,i));
	END LOOP;
END;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Usando bucles: ');
	pr_elevar_par1_to_par2(2,4);
	DBMS_OUTPUT.PUT_LINE('Usando funcion POWER: ');
	pr_elevar_par1_to_par2_verion2(2,4);
END;

--EJERCICIO 9
CREATE OR REPLACE PROCEDURE pr_sumatorio_N_numeos(v_numero NUMBER)
IS
	v_sumatorio NUMBER:=0;
BEGIN
	FOR i IN 1..v_numero LOOP
		v_sumatorio:=i+v_sumatorio;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(v_sumatorio);
END;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Se espera un 6');
	pr_sumatorio_N_numeos(3);
	DBMS_OUTPUT.PUT_LINE('Se espera un 10');
	pr_sumatorio_N_numeos(4);
	DBMS_OUTPUT.PUT_LINE('Se espera un 15');
	pr_sumatorio_N_numeos(5);
END;	

--EJERICIO 10
CREATE OR REPLACE PROCEDURE pr_MULTIPLOS_A_POR_B(v_parA NUMBER, v_parB NUMBER) 
IS
	v_producto NUMBER:=0;
BEGIN
	FOR i IN 1..v_parB LOOP
		v_producto:=v_producto+v_parA;
		DBMS_OUTPUT.PUT_LINE(V_PRODUCTO);
	END LOOP;
END;


BEGIN
	pr_MULTIPLOS_A_POR_B(10,10);
END;

--EJERCICIO 11
CREATE OR REPLACE PROCEDURE DUMMY.pr_elevar_parA_to_parE(v_parA NUMBER, v_parE NUMBER) 
IS
	v_potencia NUMBER:=1;
BEGIN
	FOR i IN 1..v_parE LOOP
		v_potencia:=v_potencia*v_parA;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(v_potencia);
END;

BEGIN
	pr_elevar_parA_to_parE(3,3);
END;

--EJERCICIO 12
CREATE OR REPLACE PROCEDURE pr_calcular_factorial(v_NFactor NUMBER)
IS
	v_factorial NUMBER:=1;
BEGIN
	FOR i IN 1..v_NFactor LOOP
		v_factorial:=v_factorial*i;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(v_factorial);
END;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Se espera un 120');
	pr_calcular_factorial(5);
END;

--EJERCICIO 13
CREATE OR REPLACE PROCEDURE pr_calcular_inversoN(v_N_num NUMBER)
IS
	v_resultado NUMBER:=0;
BEGIN
	FOR i IN 1..v_N_num LOOP
		v_resultado:=v_resultado+(1/i);
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(ROUND(v_resultado,3));
END;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Resultado esperado: 2.283');
	pr_calcular_inversoN(5);
END;
