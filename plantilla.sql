EJEMPLO de Tarea Entrable y examen - TIPO A

Nombre: <Pon tu nombre >

************************************************************************
	INSTRUCCIONES:
	==============

-Salva este fichero con las iniciales de tu nombre y apellidos,
 en el directorio "C:\Ejemplo_Tarea_Entregable\ ":
	Ejemplo:	Si tu nombre es             Tomas Coronado Garcia
			    el fichero debe llamarse:   00TCG_Ej.sql
El numero que pones delante de tus iniciales debe ser el que aparece a continuación:

01	Álvarez Sánchez, Santiago
02	Antelo Ramírez, Julio
03	Bermudo Calero, Aarón
04	Brenes Brealey, Moise
05	Castilla Loaiza, Álvaro M.
06	Cepero Rondón, Rubén
07	Cordero Moreno, Carlos
08	Deniz Sáiz, Elián
09	Espinosa Sánchez, Lucía
10	Fernández Trigo, Julio
11	Ferrero Aldariz, Miguel Ángel
12	Galvín Reyes, Juan José
13	García El Abboudi, Francisco J.
14	Gutiérrez Bueno, Daniel
15	López Galán, Adrián
16	Merino Jiménez, Eduardo
17	Mulas Batista, Guillermo
18  Muñoz Mariscal, Francisco
19  Sabino Pérez, Adrián
20  Serrano Benítez, César
 
-Pon tu nombre al ejercicio en la parte de arriba de este documento
- y lee atentamente todas las preguntas.

-Entra en "SQL Plus" con cualquier usuario. 

-Carga el script para el examen desde el fichero "Datos_Ejemplo_TE_Ex17.sql".

-Donde ponga "SQL>", copiarás las sentencias SQL que has utilizado.

-Donde ponga "Resultado:" copiarás el resultado que la consola SQL*Plus te devuelve.

-RECUERDA: guardar, cada cierto tiempo, el contenido de este fichero. Es lo que voy a evaluar, si lo pierdes, lo siento, en la recuperación tendrás otra oportunidad.

-PUNTUACIÓN:  	0,625 puntos cada pregunta


************************************************************************
	Descripción de las tablas:
	==========================

CREATE TABLE PROFESORES(
  COD_PR			NUMBER(2)		PRIMARY KEY,
  DNI_PR			CHAR(9)			UNIQUE,
  NOMBRE_PR			VARCHAR2(25)	NOT NULL,
  ESPECIALIDAD_PR	VARCHAR2(15)	NOT NULL
);
CREATE TABLE CLASES(
  PROFESOR_CL		NUMBER(2),
  ASIGNATURA_CL		NUMBER(3),
  AULA_CL			NUMBER(2), 
  HORASSEM_CL		NUMBER(2), 
  PRIMARY KEY (PROFESOR_CL, ASIGNATURA_CL)
);
CREATE TABLE ASIGNATURAS(
  COD_AS		NUMBER(3)		PRIMARY KEY,
  NOMBRE_AS		VARCHAR2(35)	NOT NULL,
  HORAS_AS		NUMBER(3)		NOT NULL
);
CREATE TABLE ALUMNOS(
  COD_AL		NUMBER(2)	PRIMARY KEY,
  FECINC_AL		DATE,
  FECNAC_AL		DATE,
  DNI_AL		CHAR(9)			UNIQUE,
  NOMBRE_AL		VARCHAR2(25) 	NOT NULL,
  CIUDAD_AL		VARCHAR2(10) 	NOT NULL,
  TUTOR_AL		NUMBER(2),
  DELEGADO_AL	NUMBER(2)
  );
CREATE TABLE NOTAS(
  ALUMNO_NO		NUMBER(2),
  ASIGNATURA_NO	NUMBER(3),
  FECHA_NO		DATE,
  NOTA_NO		NUMBER(4,2),
  PRIMARY KEY (ALUMNO_NO, ASIGNATURA_NO, FECHA_NO)
  );

***************************************************************************************************************
 1.- Mostrar de cada alumno su nombre y apellidos (tal como están almacenados), 
 DNI y la edad que tenían cuando ingresaron.

 SQL>  
 
SELECT NOMBRE_AL, DNI_AL, ROUND(MONTHS_BETWEEN(SYSDATE,FECNAC_AL)/12)  EDAD
FROM ALUMNOS;
		

Resultado:

NOMBRE_AL                 DNI_AL          EDAD
------------------------- --------- ----------
Arias Grillo, Jairo       55645991T         26
Arnaldos Valle, Javier    54652636D         36
Avila Ferrete, Raquel     71106202D         28
Cabrera Alava, Kilian     56646516D         26
Pires Barranco, Amador    51506642K         26
Calvo Jimenez, Alberto    55980648H         27
Camacho Lindsey, Daniel   64555339D         27
Pozo Martin, Ismael       37839343D         27
Rolo Vera, Luis Miguel    76138301V         31
Mendizabal Romero, Luis   67918627L         35
Gallego Carvajal, Juan    63453550T         44
Reina Ramirez, Joaquin    90676183D         30
Gata Masero, Carlos       22563618D         26


***************************************************************************************************************
 2.- Mostrar de cada profesor su nombre y apellidos en mayúsculas, 
 junto con la letra de su DNI.

 SQL>
 

 

Resultado:

***************************************************************************************************************
 3.- Mostrar nombre y apellidos de cada alumnos 
 junto con el nombre (SIN LOS APELLIDOS) de su tutor.
 
SQL>


SELECT A.NOMBRE_AL, SUBSTR(P.NOMBRE_PR,INSTR(P.NOMBRE_PR,',')+2) NOMBRBE_PROF
FROM PROFESORES P , ALUMNOS A
WHERE P.COD_PR = A.TUTOR_AL;


Resultado:

NOMBRE_AL                 NOMBRBE_PROF
------------------------- ----------------------------------------------------------------------------------------------------
Arias Grillo, Jairo       Malvina
Arnaldos Valle, Javier    Malvina
Avila Ferrete, Raquel     Malvina
Cabrera Alava, Kilian     Malvina
Pires Barranco, Amador    Malvina
Calvo Jimenez, Alberto    Malvina
Camacho Lindsey, Daniel   Carmen
Pozo Martin, Ismael       Carmen
Rolo Vera, Luis Miguel    Carmen
Mendizabal Romero, Luis   Carmen
Gallego Carvajal, Juan    Carmen
Reina Ramirez, Joaquin    Carmen
Gata Masero, Carlos       Carmen


***************************************************************************************************************
 4.- Mostrar la nota media (CON DOS DECIMALES) 
 de la asignatura BASES DE DATOS.
 
SQL>

SELECT ROUND(AVG(NOTA_NO),2)
FROM NOTAS
WHERE ASIGNATURA_NO =(SELECT COD_AS
					  FROM ASIGNATURAS
					  WHERE UPPER(NOMBRE_AS) ='BASES DE DATOS');

Resultado:

ROUND(AVG(NOTA_NO),2)
---------------------
                 6,91

***************************************************************************************************************
 5.- Mostrar código, nombre y apellido, 
 y DNI de los alumnos que han aprobado algún examen de LENGUAJE DE MARCAS.
 
SQL>

SELECT NOMBRE_AL, COD_AL
FROM ALUMNOS A, NOTAS N
WHERE A.COD_ALO = N.ALUMNO_NO
AND 
GROUP BY NOMBRE_AL, COD_AL
HAVING 

Resultado:

***************************************************************************************************************
 6.- Mostrar las horas que da clase a la semana cada profesor.
 
SQL>

Resultado:

***************************************************************************************************************
 7.- Mostrar de cada alumno su código y sus apellidos (SIN EL NOMBRE) 
 junto con el nombre y apellidos de su delegado.
 
SQL>

Resultado:

***************************************************************************************************************
 8.- Mostrar los profesores que le han dado clase a JAIRO
 (Serán aquellos que imparten la asignatura en la que tiene nota).
 
SQL>

Resultado:

***************************************************************************************************************
 9.- Mostrar, de cada asignatura, 
 su nombre y la nota media (CON DOS DECIMALES).
 
SQL>

Resultado:

***************************************************************************************************************
10.- (OUTER JOIN, hay asignaturas que no tienen notas) 
Mostrar, de cada asignatura, su nombre y la nota media (CON DOS DECIMALES).
 
SQL>

Resultado:

***************************************************************************************************************
11.- Mostrar el nombre de la asignatura con la nota media más alta.
 
SQL>

Resultado:

***************************************************************************************************************
12.- Mostrar la nota media (CON DOS DECIMALES) 
de cada alumno en cada asignatura 
(nombre y apellidos junto con el nombre de la asignatura) para los alumnos de BADAJOZ.
 
SQL>

Resultado:

***************************************************************************************************************
13.- Mostrar el nombre y apellidos 
de los alumnos que sacaron en algún examen, 
la misma nota que la máxima nota que sacó JAIRO en LENGUAJE DE MARCAS.
 
SQL>

Resultado:

***************************************************************************************************************
14.- Mostrar el nombre y apellidos 
del profesor que ha puesto la nota más alta.
 
SQL>

Resultado:

***************************************************************************************************************
15.- Mostrar la fecha en la que se hizo 
el primer examen con el siguiente formato: 'Jueves 12 de diciembre de 2017 '.
 
SQL>

Resultado:

***************************************************************************************************************
16.- Mostrar cuantos examenes ha hecho cada alumno en BASES DE DATOS.
 
SQL>

Resultado:
 
