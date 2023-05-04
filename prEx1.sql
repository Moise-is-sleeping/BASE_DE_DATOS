TIPO A

Nombre: <Pon aquí tu nombre>

------------------------------------------------------------------------
	INSTRUCCIONES:
	==============

-Salva este fichero con las iniciales de tu nombre y apellidos,
 en el directorio "C:\ALUMNOS\ ":
	Ejemplo:	José María Rivera Calvete
			JMRC.sql

-Pon tu nombre al ejercicio y lee atentamente todas las preguntas.

-Entra en "SQL Plus" con:
	usuario: 	HR
	contraseña:	HR

-Carga el script para el examen desde el fichero "Empresa.sql".

-RECUERDA: guardar, cada cierto tiempo, el contenido de este fichero. Es lo que voy a evaluar, si lo pierdes, lo siento, en la recuperación tendrás otra oportunidad.

	PUNTUACIÓN
	==========
- Cada pregunta: 	 2 puntos

- Se considerará para la evaluación:
	- Que funcione
	- Estilo de programación 
	- Tratamiento de excepciones
	- Código reutilizable y paramétrico

------------------------------------------------------------------------

	Descripción de las tablas:
	==========================

CENTROS
-------
# COD_CE		NUMBER(2)		Código del Centro
* DIRECTOR_CE	NUMBER(6)		Director del Centro
  NOMB_CE		VARCHAR2(30)	Nombre del Centro (O)
  DIRECC_CE		VARCHAR2(50)	Dirección del Centro (O)
  POBLAC_CE		VARCHAR2(15)	Población del Centro (O)

DEPARTAMENTOS
-------------
# COD_DE		NUMBER(3)		Código del Departamento
* DIRECTOR_DE	NUMBER(6)		Director del Departamento
* DEPTJEFE_DE	NUMBER(3)		Departamento del que depende
* CENTRO_DE		NUMBER(2)		Centro trabajo (O)
  NOMB_DE		VARCHAR2(40)	Nombre del Departamento (O)
  PRESUP_DE		NUMBER(11)		Presupuesto del Departamento (O)
  TIPODIR_DE	CHAR(1)			Tipo de Director del Departamento (O)

EMPLEADOS
---------
# COD_EM		NUMBER(6)		Código del Empleado
* DEPT_EM		NUMBER(3)		Departamento del Empleado (O)
  EXTTEL_EM		CHAR(9)			Extensión telefónica
  FECINC_EM		DATE			Fecha de incorporación del Empleado (O)
  FECNAC_EM		DATE			Fecha de nacimiento del Empleado (O)
  DNI_EM		VARCHAR2(9)		DNI del Empleado (U)
  NOMB_EM		VARCHAR2(40)	Nombre del Empleado (O)
  NUMHIJ_EM		NUMBER(2)		Número de hijos del Empleado (O)
  SALARIO_EM	NUMBER(9)		Salario Anual del Empleado (O)
  COMISION_EM	NUMBER(9)		Comisión del Empleado

HIJOS
-----
#*PADRE_HI		NUMBER(6)		Código del Empleado
# NUMHIJ_HI		NUMBER(2)		Número del hijo del Empleado
  FECNAC_HI		DATE			Fecha de nacimiento del Hijo (O)
  NOMB_HI		VARCHAR2(40)	Nombre del Hijo (O)



Nota: 
	# PRIMARY KEY
	* FOREIGN KEY
	(O) Obligatorio
	(U) Único

------------------------------------------------------------------------
1.- Diseña el procedimiento "ModComision" que establezca la comisión de los empleados que trabajan en los centros de:
	- "Madrid", el 10% de su salario.
	- "Sevilla", el 15%. 
	- "Huelva", un 20%. 
	Todos empleados tendrán un incremento de 100 euros en la comisión por cada año de antigüedad en la empresa.

Código:

CREATE OR REPLACE PROCEDURE MODComision IS
CURSOR C_COMISION IS 
SELECT C.COD_CE COD, ROUND(MONTHS_BETWEEN(SYSDATE,FECINC_EM)/12) ANTI
FROM EMPLEADOS E, CENTROS C, DEPARTAMENTOS D
WHERE C.COD_CE = D.CENTRO_DE AND D.COD_DE = E.DEPT_EM
ORDER BY C.COD_CE;
BEGIN 
	COMMIT;
	FOR I IN C_COMISION LOOP
		IF I.COD = 10 THEN 
			UPDATE empleados
			SET COMISION_EM = (0.10*SALARIO_EM)+I.ANTI*100;
		ELSIF I.COD = 20 THEN 
			UPDATE empleados
			SET COMISION_EM = (0.15*SALARIO_EM)+I.ANTI*100;
		ELSIF I.COD = 30 THEN 
			UPDATE empleados
			SET COMISION_EM = (0.20*SALARIO_EM)+I.ANTI*100;
		END IF;
	END LOOP;
	COMMIT;
END;
/
			

------------------------------------------------------------------------
2.- Diseña el procedimiento "ListarCentro" que acepte como parámetro el código de un centro y muestre un listado con la siguiente estructura, donde la "Masa salarial" será la suma de los salrios de los empleados de ese departamento:

Centro    Director                         Poblacion
--------- -------------------------------- ---------
Direccion Del Junco Suarez, Malvina           Madrid
-
Cod Departamento    Director                    Masa salarial
--- --------------- --------------------------- -------------
200 Informatica     Del Junco Suarez, Malvina        23600000
300 Investigacion   Calderon Diaz, Daniel            18000000


Código:

CREATE OR REPLACE PROCEDURE PR_ListarCentro(
	P_COD_CENTRO NUMBER)IS
CURSOR  C_CENTRO IS
	SELECT C.NOMB_CE Centro, E.NOMB_EM Director, C.POBLAC_CE Poblacion
	FROM CENTROS C, EMPLEADOS E 
	WHERE C.DIRECTOR_CE = E.COD_EM
	AND C.COD_CE = P_COD_CENTRO ;
	VAR_CENTRO C_CENTRO%ROWTYPE;
CURSOR C_DEPART(VAR_COD NUMBER) IS
	SELECT DEPT_EM,NOMB_DE,NOMB_EM
	FROM EMPLEADOS, DEPARTAMENTOS
	WHERE DEPT_EM = COD_DE AND CENTRO_DE = VAR_COD AND DIRECTOR_DE = COD_EM
	GROUP BY DEPT_EM,NOMB_DE,NOMB_EM;
	VAR_MASA NUMBER;
BEGIN
	OPEN C_CENTRO;
		FETCH C_CENTRO INTO VAR_CENTRO;
		DBMS_OUTPUT.PUT_LINE(VAR_CENTRO.CENTRO ||'        '|| VAR_CENTRO.DIRECTOR ||'        '|| VAR_CENTRO.POBLACION);
	CLOSE C_CENTRO;
	FOR I IN C_DEPART(P_COD_CENTRO) LOOP
		SELECT SUM(SALARIO_EM)
		INTO VAR_MASA
		FROM EMPLEADOS
		WHERE DEPT_EM = I.DEPT_EM
		GROUP BY DEPT_EM;
		DBMS_OUTPUT.PUT_LINE(I.DEPT_EM ||'        '|| I.NOMB_DE ||'        '|| I.NOMB_EM ||'        '|| VAR_MASA);
	END LOOP;
END;
/


Resultado:
Direccion        Del Junco Suarez, Malvina                  Madrid
200        Informatica        Del Junco Suarez, Malvina                  23600000
300        Investigacion        Calderon Diaz, Daniel                      18000000
------------------------------------------------------------------------
3.- Diseña el procedimiento "Listar" que haga un listado de los datos de todos los centros con la estructura del listado anterior.


Código:
CREATE OR REPLACE PROCEDURE PR_ListarCentro IS
CURSOR C_CODIGOS IS
	SELECT COD_CE
	FROM CENTROS;
CURSOR  C_CENTRO(VAR_CENTRO NUMBER)IS
	SELECT C.NOMB_CE Centro, E.NOMB_EM Director, C.POBLAC_CE Poblacion
	FROM CENTROS C, EMPLEADOS E 
	WHERE C.DIRECTOR_CE = E.COD_EM
	AND C.COD_CE = 10 ;
	VAR_CENTRO C_CENTRO%ROWTYPE   ;
CURSOR C_DEPART(VAR_COD NUMBER) IS
	SELECT DEPT_EM,NOMB_DE,NOMB_EM
	FROM EMPLEADOS, DEPARTAMENTOS
	WHERE DEPT_EM = COD_DE AND CENTRO_DE = VAR_COD AND DIRECTOR_DE = COD_EM
	GROUP BY DEPT_EM,NOMB_DE,NOMB_EM;
	VAR_MASA NUMBER;
BEGIN
	FOR A IN C_CODIGOS LOOP
		OPEN C_CENTRO(A.COD_CE);
			FETCH C_CENTRO INTO VAR_CENTRO USING (A.COD_CE);
			DBMS_OUTPUT.PUT_LINE(VAR_CENTRO.CENTRO ||'        '|| VAR_CENTRO.DIRECTOR ||'        '|| VAR_CENTRO.POBLACION);
		CLOSE C_CENTRO;
		FOR I IN C_DEPART(A.COD_CE) LOOP
			SELECT SUM(SALARIO_EM)
			INTO VAR_MASA
			FROM EMPLEADOS
			WHERE DEPT_EM = I.DEPT_EM
			GROUP BY DEPT_EM;
			DBMS_OUTPUT.PUT_LINE(I.DEPT_EM ||'        '|| I.NOMB_DE ||'        '|| I.NOMB_EM ||'        '|| VAR_MASA);
		END LOOP;
	END LOOP;
END;
/

Resultado:

------------------------------------------------------------------------------------------------------------------------------------------------
4.- Crea la función "Aniversario" que se le pase como parámetro una fecha y que devuelva TRUE o FALSE si hoy fuera el aniversario algo que ocurrió en esa fecha.
CREATE OR REPLACE FUNCTION Aniversario(
	VAR_FECHA IN DATE ) RETURN BOOLEAN IS 
BEGIN 
	IF TO_CHAR(VAR_FECHA, 'dd') = TO_CHAR(SYSDATE, 'dd')
	THEN  RETURN true;
	ELSE RETURN false;
	END IF;

EXCEPTION 
WHEN NO_DATA_FOUND THEN 
	DBMS_OUTPUT.PUT_LINE('CAMPO VACIDO ');
END;
/
	
Código:


BEGIN
	if Aniversario('')= true then DBMS_OUTPUT.PUT_LINE('TRUE');
	end if;
END;
/

select TO_CHAR(SYSDATE, 'mm')
from empleados;
------------------------------------------------------------------------
5.- Diseña el procedimiento "ListarAniversario" que genere un listado en el que se vea cada empleado con su fecha de incorporación a la empresa indicando "Aniversario" a aquellos empleados  que hoy sea el aniversario de su incorporación a la empresa, indicando el total de personas que lo cumplen.

	Ej.:
		Segura Viudas, Santiago	19/05/90		Aniversario	
		Rivera Calvete, José Mª	02/06/95
		Conan Bárbaro, Mari		12/06/99

		Total Aniversario: 1


Código:

CREATE OR REPLACE PROCEDURE ListarAniversario IS 
CURSOR C_DATES IS 
SELECT NOMB_EM,FECINC_EM
FROM EMPLEADOS;
BEGIN 
	FOR I IN C_DATES LOOP
		IF TO_CHAR(I.FECINC_EM,'MM')= TO_CHAR(SYSDATE,'MM') AND TO_CHAR(I.FECINC_EM,'DD') = TO_CHAR(SYSDATE,'DD')
		THEN DBMS_OUTPUT.PUT_LINE(I.NOMB_EM || '  ' || I.FECINC_EM || '  ' || 'Aniversario');
		ELSE DBMS_OUTPUT.PUT_LINE(I.NOMB_EM || '  ' || I.FECINC_EM );
		END IF;
	END LOOP;
END;
/
Resultado:
