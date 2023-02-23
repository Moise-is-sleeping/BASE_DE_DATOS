--3--
		INSERT INTO ALUMNOS4( COD_AL, NOMBRE_AL, APELLIDO_AL, FECNAC_AL, NDNI_AL, LDNI_AL)
		SELECT COD_AL, SUBSTR(NOMBRE_AL,INSTR(NOMBRE_AL,',')+2,INSTR(NOMBRE_AL,' ')+1), SUBSTR(NOMBRE_AL,0,INSTR(NOMBRE_AL,' ')-1),FECNAC_AL, SUBSTR(DNI_AL,0,8),SUBSTR(DNI_AL,9)
		FROM ALUMNOS;
		
		
		
SELECT SUBSTR(NOMBRE_AL,INSTR(NOMBRE_AL,' '))
FROM ALUMNOS;


--TABLA ALUMNOS--

--1--


UPDATE ALUMNOS
SET FECNAC_AL = SYSDATE
WHERE NOMBRE_AL =(  SELECT FECNAC_AL
					FROM ALUMNOS
					WHERE UPPER(NOMBRE_AL) LIKE '%AMADOR%');

--2--


UPDATE ALUMNOS
SET (FECINC_AL,CIUDAD_AL) = ( SELECT FECINC_AL,CIUDAD_AL FROM ALUMNOS WHERE UPPER(NOMBRE_AL) LIKE '%CARLOS%')
WHERE UPPER(CIUDAD_AL) = 'SEVILLA';


--3--


UPDATE ALUMNOS
SET FECINC_AL = (SELECT FECINC_AL FROM ALUMNOS WHERE UPPER(NOMBRE_AL) LIKE '%JAVIER%'),
DELEGADO_AL = (SELECT DELEGADO_AL FROM ALUMNOS WHERE UPPER(NOMBRE_AL) LIKE '%DANIEL%')
WHERE UPPER(NOMBRE_AL) LIKE '%DANIEL%';






--Tablas ALUM, NUEVOS y ANTIGUOS
--1.Dadas las tablas ALUM y NUEVOS, insertar en la tabla ALUM los alumnos nuevos.


INSERT INTO ALUM
SELECT NOMBRE,EDAD, LOCALIDAD
FROM NUEVOS
WHERE NOMBRE NOT IN (  SELECT NOMBRE
						FROM ALUM);

--2.Borrar de la tabla ALUM los alumnos de la tabla ANTIGUOS.
DELETE FROM ALUM 
WHERE NOMBRE IN (SELECT NOMBRE
				FROM ALUM
				WHERE NOMBRE  IN (  SELECT NOMBRE
									FROM ANTIGUOS));



--Tablas EMPLE y DEPART

--3.Insertar un empleado de apellido 'SAAVEDRA' con número 2000.
-- La fecha de alta será la actual del sistema, el SALARIO el mismo del empleado
-- 'SALA' más el 20% y el resto de datos igual que 'SALA'.


INSERT INTO EMPLE
SELECT 2000, 'SAAVEDRA', OFICIO, DIR, SYSDATE, SALARIO +(SALARIO*0.20),COMISION, DEPT_NO
FROM EMPLE
WHERE APELLIDO = 'SALA';

--4.Modificar el número de departamento de 'SAAVEDRA'. El nuevo departamento será aquel donde hay 
--más empleados cuyo OFICIO se 'EMPLEADO'.


UPDATE EMPLE
SET DEPT_NO = (SELECT E.DEPT_NO
				FROM EMPLE E
				WHERE OFICIO = 'EMPLEADO' 
				GROUP BY E.DEPT_NO
				HAVING COUNT(OFICIO) = (SELECT MAX(COUNT(OFICIO))
										FROM EMPLE
										WHERE OFICIO = 'EMPLEADO'
										GROUP BY DEPT_NO))
WHERE APELLIDO = 'SAAVEDRA';



--5.Borrar todos los departamentos de la tabla DEPART para los cuales no existan empleados en EMPLE.

DELETE FROM DEPART
WHERE DEPT_NO NOT IN (  SELECT DEPT_NO
						FROM EMPLE
						GROUP BY DEPT_NO);


--Tablas PERSONAL, PROFESORES y CENTROS

--6.Modificar el nº de plazas de la tabla CENTROS con un valor igual a la mitad en aquellos centros con
-- menos de dos profesores.


UPDATE CENTROS
SET NUM_PLAZAS = NUM_PLAZAS/2
WHERE COD_CENTRO IN (SELECT COD_CENTRO
					FROM PROFESORES
					GROUP BY(COD_CENTRO)
					HAVING COUNT(APELLIDOS) <= 2);
					
--7.Eliminar los centros que no tengan personal.


DELETE FROM CENTROS
WHERE COD_CENTRO NOT IN (   SELECT COD_CENTRO
							FROM PERSONAL
							GROUP BY COD_CENTRO);


--8.Añadir un nuevo profesor en el centro o en los centros cuyo nº de administrativos sea 1 en la 
--especialidad 'IDIOMA', con DNI 8790055 y de nombre 'Clara Salas'.

INSERT INTO PROFESORES
SELECT DISTINCT (COD_CENTRO),8790055,'Salas ,Clara','IDIOMA'
FROM PROFESORES
WHERE COD_CENTRO IN (   SELECT COD_CENTRO
						FROM PERSONAL
						WHERE FUNCION = 'ADMINISTRATIVO'
						GROUP BY COD_CENTRO
						HAVING COUNT(FUNCION) = 1);
DELETE FROM PROFESORES
WHERE APELLIDOS = 'Salas ,Clara';


--9.Borrar el personal que esté en centros de menos de 300 plazas y con menos de dos profesores.

DELETE FROM PERSONAL
WHERE COD_CENTRO != (   SELECT C.COD_CENTRO
						FROM CENTROS C, PROFESORES P
						WHERE C.COD_CENTRO = P.COD_CENTRO AND  C.NUM_PLAZAS > 300
						GROUP BY C. COD_CENTRO
						HAVING COUNT(P.COD_CENTRO) > 2);

--10.Borrar a los profesores que estén en la tabla PROFESORES y no estén en la tabla PERSONAL.
DELETE FROM PROFESORES
WHERE APELLIDOS IN (
						SELECT APELLIDOS 
						FROM PROFESORES
						WHERE APELLIDOS NOT IN (SELECT APELLIDOS
										  FROM PERSONAL
										  WHERE FUNCION = 'PROFESOR'));