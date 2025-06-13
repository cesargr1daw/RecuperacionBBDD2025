/*
RA5: PLSQL (Practicar simulacro)

    1. Realiza un procedure para insertar una apuesta. El procedure recibirá el código del caballo, el código de la carrera, el dni del cliente y el importe. El  procedure deberá mostrar los siguientes posibles errores:
        ◦ Si el caballo no existe lanzar la excepción -20001 con el mensaje “Caballo imaginario”
        ◦ Si la carrera no existe lanzar la excepción -20002 con el mensaje “Caballo imaginario”
        ◦ Si el cliente no existe lanzar la excepción -20003 con elmensaje “Cliente imaginario”
        ◦ Si el caballo no participa en la carrera lanzar la excepción -20004 con el mensaje “Caballo existente pero descansando”
        ◦ Si el importe apostado supera el límite fijado para dicha carrera lanzar la excepción -20005 con el mensaje, “Jugar es malo”.

El tantoporuno será de uno siempre. Si se comprueba uno de los errores no es necesario seguir mirando los demás. (1,5 puntos)

    2. Realizar una función que reciba dos parámetros, un número y un parámetro de entrada salida. La función debe devolver un -1 y un 0 en el parámetro de entrada salida si el número que recibe como primer parámetro no es entero y positivo. Si el primer parámetro es entero y positivo devolver en el parámetro de entrada y salida la suma de los n primeros números, es decir si  el primer parámetro es un 5 deberá devolver en el parámetro de entrada salida el resultado de sumar 1+2+3+4+5. En este caso la función devolverá un 1. (1 punto)
       Realizar un bloque anónimo para probar está función en la que se llamará con un número negativo, un número no entero, y por último con un número entero y positivo. En este bloque se debe escribir el resultado de la función o el mensaje de error correspondiente. (0.5 puntos)
    3. Añadir un nuevo campo a la tabla caballos llamada num_carreras (si no sabes cómo preguntame pero serás penalizado con 0,5 punto).  Realizar un procedure que rellene este campo con los valores oportunos. El procedure deberá ir mostrando los nombres de los caballos que han corrido más de 5 carreras y al final el número de caballos que cumplen esta condición.  (2 puntos) 

    5. Mostrar el nombre del caballo o caballos que hayan ganado más carreras, es decir, que hayan quedado primeros más veces. (1 punto)

    6. Mostrar el nombre y nacionalidad de aquellos clientes que hayan apostados más de euros. (1 punto)

    7. Obtener el nombre de los caballos que han quedado siempre primeros en todas las carreras que han corrido  (1 punto)

    8. Para todas las carreras que se corrieron entre el 7 al 12 de Julio de 2009 mostrar el nombre del caballo, el nombre del dueño, el nombre del jockey y el nombre de la carrera. Los datos deben estar ordenados alfabéticamente por el nombre de la carrera y el nombre del caballo; (1 punto)

    9. Mostrar el dinero que ha ganado (no el que ha apostado) cada uno de los clientes (1 punto)
*/

--Ejercicio 1

CREATE OR REPLACE PROCEDURE pr_VALIDAR_APUESTAS (
    v_DNI_CLIENTE APUESTAS.DNICLIENTE%TYPE,
    v_CODIGO_CABALLO APUESTAS.CODCABALLO%TYPE, 
    v_CODIGO_CARRERA APUESTAS.CODCARRERA%TYPE, 
    v_IMPORTE_APUESTA APUESTAS.IMPORTE%TYPE
) IS 
    v_existe NUMBER;
    v_IMPORTE_LIMITE CARRERAS.APUESTALIMITE%TYPE; 
BEGIN
    SELECT COUNT(*) INTO v_existe FROM CABALLOS c WHERE c.CODCABALLO = v_CODIGO_CABALLO;
    IF v_existe = 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'CABALLO IMAGINARIO');
    END IF;    

    SELECT COUNT(*) INTO v_existe FROM CARRERAS c WHERE c.CODCARRERA = v_CODIGO_CARRERA;
    IF v_existe = 0 THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Carrera imaginaria');
    END IF;

    SELECT COUNT(*) INTO v_existe FROM CLIENTES c WHERE c.DNI = v_DNI_CLIENTE;
    IF v_existe = 0 THEN 
        RAISE_APPLICATION_ERROR(-20003, 'Cliente imaginario');
    END IF;

    SELECT COUNT(*) INTO v_existe FROM PARTICIPACIONES p WHERE p.CODCABALLO = v_CODIGO_CABALLO AND p.CODCARRERA = v_CODIGO_CARRERA;
    IF v_existe = 0 THEN 
        RAISE_APPLICATION_ERROR(-20004, 'Caballo existente pero descansando');
    END IF;

    SELECT APUESTALIMITE INTO v_IMPORTE_LIMITE FROM CARRERAS c WHERE c.CODCARRERA = v_CODIGO_CARRERA;
    IF v_IMPORTE_APUESTA > v_IMPORTE_LIMITE THEN 
        RAISE_APPLICATION_ERROR(-20005, 'Jugar es malo');
    END IF;

    INSERT INTO APUESTAS(DNICLIENTE, CODCABALLO, CODCARRERA, IMPORTE, TANTOPORUNO) 
    VALUES (v_DNI_CLIENTE, v_CODIGO_CABALLO, v_CODIGO_CARRERA, v_IMPORTE_APUESTA, 1);
    COMMIT;
END pr_VALIDAR_APUESTAS;


-- 1. Caso válido (todo correcto, debe insertar sin error)
BEGIN
  pr_VALIDAR_APUESTAS('222B', '2', 'C1', 1200);
END;

BEGIN
    pr_VALIDAR_APUESTAS('666F', '1', 'C1', 100);
END;

-- 2. Caballo imaginario (codcaballo no existe)
BEGIN
    pr_VALIDAR_APUESTAS('111A', '99', 'C1', 100);
END;


-- 3. Carrera imaginaria (codcarrera no existe)
BEGIN
  pr_VALIDAR_APUESTAS('111A', '1', 'XX', 1500);
END;

-- 4. Cliente imaginario (dni no existe)
BEGIN
  pr_VALIDAR_APUESTAS('XXX', '1', 'C1', 1500);
END;

-- 5. Caballo existente pero descansando (no participa en la carrera)
BEGIN
  pr_VALIDAR_APUESTAS('111A', '8', 'C1', 1500);
END;

-- 6. Importe apuesta supera límite (apuestalimite en carrera C1 = 2000)
BEGIN
  pr_VALIDAR_APUESTAS('111A', '1', 'C1', 2500);
END;

	

--Ejercicio 2
CREATE OR REPLACE FUNCTION fn_suma_numeros (
    v_numero IN NUMBER, 
    v_resultado IN OUT NUMBER
) RETURN NUMBER IS
BEGIN
    IF v_numero <= 0 OR v_numero != TRUNC(v_numero) THEN
        v_resultado := 0;
        RETURN -1;
    END IF;

    v_resultado := (v_numero * (v_numero + 1)) / 2;
    RETURN 1;
END fn_suma_numeros;

DECLARE
    resultado NUMBER;
    retorno NUMBER;
BEGIN
    resultado := -999;
    retorno := fn_suma_numeros(-5, resultado);
    IF retorno = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error: número no entero y positivo. Resultado: ' || resultado);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Suma resultado: ' || resultado);
    END IF;

    resultado := -999;
    retorno := fn_suma_numeros(3.14, resultado);
    IF retorno = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error: número no entero y positivo. Resultado: ' || resultado);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Suma resultado: ' || resultado);
    END IF;

    resultado := -999;
    retorno := fn_suma_numeros(5, resultado);
    IF retorno = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error: número no entero y positivo. Resultado: ' || resultado);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Suma resultado: ' || resultado);
    END IF;
END;


--Ejercicio 3
ALTER TABLE caballos ADD (num_carreras NUMBER);

CREATE OR REPLACE PROCEDURE actualizar_num_carreras IS
  contador NUMBER := 0;
  CURSOR cur_caballos IS
    SELECT codcaballo, nombre FROM caballos;

  num_carr NUMBER;
BEGIN
  FOR cab IN cur_caballos LOOP
    SELECT COUNT(*) INTO num_carr FROM participaciones WHERE codcaballo = cab.codcaballo;

    UPDATE caballos SET num_carreras = num_carr WHERE codcaballo = cab.codcaballo;

    IF num_carr > 5 THEN
      DBMS_OUTPUT.PUT_LINE('Caballo con más de 5 carreras: ' || cab.nombre || ' (' || num_carr || ')');
      contador := contador + 1;
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Número total de caballos con más de 5 carreras: ' || contador);

  COMMIT;
END;


BEGIN
    actualizar_num_carreras;
END;


--Ejercicio 5
DECLARE
  max_ganadas NUMBER;
BEGIN
  SELECT MAX(ganadas) INTO max_ganadas
  FROM (
    SELECT codcaballo, COUNT(*) AS ganadas
    FROM participaciones
    WHERE posicionfinal = 1
    GROUP BY codcaballo
  );
  DBMS_OUTPUT.PUT_LINE('Caballos que han ganado más carreras (' || max_ganadas || ' victorias):');

  FOR rec IN (
    SELECT c.nombre
    FROM caballos c
    JOIN (
      SELECT codcaballo, COUNT(*) AS ganadas
      FROM participaciones
      WHERE posicionfinal = 1
      GROUP BY codcaballo
    ) p ON c.codcaballo = p.codcaballo
    WHERE p.ganadas = max_ganadas
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.nombre);
  END LOOP;
END;

--Consulta
SELECT c.nombre
FROM caballos c
JOIN (
  SELECT codcaballo, COUNT(*) AS victorias
  FROM participaciones
  WHERE posicionfinal = 1
  GROUP BY codcaballo
) p ON c.codcaballo = p.codcaballo
WHERE p.victorias = (
  SELECT MAX(ganadas)
  FROM (
    SELECT codcaballo, COUNT(*) AS ganadas
    FROM participaciones
    WHERE posicionfinal = 1
    GROUP BY codcaballo
  )
);


-- Ejercicio 6
DECLARE
  importe_min NUMBER := 1000;  -- Cambia el umbral aquí
BEGIN
  DBMS_OUTPUT.PUT_LINE('Clientes que han apostado más de ' || importe_min || ' euros:');
  
  FOR rec IN (
    SELECT c.nombre, c.nacionalidad, SUM(a.importe) AS total_apostado
    FROM clientes c
    JOIN apuestas a ON c.dni = a.dnicliente
    GROUP BY c.nombre, c.nacionalidad
    HAVING SUM(a.importe) > importe_min
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.nombre || ' (' || rec.nacionalidad || ') - Total apostado: ' || rec.total_apostado);
  END LOOP;
END;

--Consulta
SELECT c.nombre, c.nacionalidad, SUM(a.importe) AS total_apostado
FROM clientes c
JOIN apuestas a ON c.dni = a.dnicliente
GROUP BY c.nombre, c.nacionalidad
HAVING SUM(a.importe) > 1000;


-- Ejercicio 7
BEGIN
  DBMS_OUTPUT.PUT_LINE('Caballos que siempre quedaron primeros en todas sus carreras:');

  FOR rec IN (
    SELECT c.nombre
    FROM caballos c
    WHERE NOT EXISTS (
      SELECT 1 FROM participaciones p
      WHERE p.codcaballo = c.codcaballo AND p.posicionfinal != 1
    )
    AND EXISTS (
      SELECT 1 FROM participaciones p2
      WHERE p2.codcaballo = c.codcaballo
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.nombre);
  END LOOP;
END;

--Consulta
SELECT c.nombre
FROM caballos c
WHERE NOT EXISTS (
  SELECT 1
  FROM participaciones p
  WHERE p.codcaballo = c.codcaballo AND p.posicionfinal != 1
)
AND EXISTS (
  SELECT 1
  FROM participaciones p2
  WHERE p2.codcaballo = c.codcaballo
);


-- Ejercicio 8
BEGIN
  DBMS_OUTPUT.PUT_LINE('Carreras del 7 al 12 Julio 2009:');

  FOR rec IN (
    SELECT
      p.codcarrera,
      c.nombrecarrera,
      cab.nombre AS nombre_caballo,
      per.nombre || ' ' || per.apellidos AS nombre_dueño,
      j.nombre || ' ' || j.apellidos AS nombre_jockey
    FROM participaciones p
    JOIN carreras c ON p.codcarrera = c.codcarrera
    JOIN caballos cab ON p.codcaballo = cab.codcaballo
    JOIN personas per ON cab.propietario = per.codigo
    JOIN personas j ON p.jockey = j.codigo
    WHERE c.fechahora BETWEEN TO_DATE('07/07/2009','DD/MM/YYYY') AND TO_DATE('12/07/2009','DD/MM/YYYY')
    ORDER BY c.nombrecarrera, cab.nombre
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      rec.nombrecarrera || ' | ' || rec.nombre_caballo || ' | ' || rec.nombre_dueño || ' | ' || rec.nombre_jockey
    );
  END LOOP;
END;

--Consulta
SELECT
  ca.nombrecarrera,
  cab.nombre AS nombre_caballo,
  du.nombre || ' ' || du.apellidos AS nombre_dueño,
  jo.nombre || ' ' || jo.apellidos AS nombre_jockey
FROM carreras ca
JOIN participaciones p ON ca.codcarrera = p.codcarrera
JOIN caballos cab ON p.codcaballo = cab.codcaballo
JOIN personas du ON cab.propietario = du.codigo
JOIN personas jo ON p.jockey = jo.codigo
WHERE ca.fechahora BETWEEN TO_DATE('07/07/2009', 'DD/MM/YYYY') AND TO_DATE('12/07/2009', 'DD/MM/YYYY')
ORDER BY ca.nombrecarrera, cab.nombre;


-- Ejercicio 9
BEGIN
  DBMS_OUTPUT.PUT_LINE('Dinero ganado por cada cliente:');

  FOR rec IN (
    SELECT c.nombre, SUM(a.importe * a.tantoporuno) AS dinero_ganado
    FROM clientes c
    LEFT JOIN apuestas a ON c.dni = a.dnicliente
    GROUP BY c.nombre
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.nombre || ': ' || NVL(TO_CHAR(rec.dinero_ganado, '9999999.99'), '0'));
  END LOOP;
END;

--Consulta
SELECT c.nombre, SUM(a.importe * a.tantoporuno) AS dinero_ganado
FROM clientes c
LEFT JOIN apuestas a ON c.dni = a.dnicliente
GROUP BY c.nombre;
