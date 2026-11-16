
USE GestionAcademicaUni;
GO

-- 1. Listar estudiantes con su programa.
SELECT 
    e.codigo_estudiante,
    e.nombre,
    e.apellido,
    e.correo_institucional,
    p.nombre_programa,
    p.facultad
FROM Estudiante e
INNER JOIN Programa p ON e.id_programa = p.id_programa
ORDER BY e.apellido ASC;
GO

-- 2. Consultar asignaturas activas con créditos superiores a un valor (ej. > 2 créditos).
SELECT 
    codigo,
    nombre,
    creditos
FROM Asignatura
WHERE activa = 1 AND creditos > 2
ORDER BY creditos DESC, nombre ASC;
GO

-- 3. Contar estudiantes por programa y ordenar de mayor a menor.
SELECT 
    p.codigo_programa,
    p.nombre_programa,
    COUNT(e.id_estudiante) AS total_estudiantes
FROM Programa p
LEFT JOIN Estudiante e ON p.id_programa = e.id_programa
GROUP BY p.codigo_programa, p.nombre_programa
ORDER BY total_estudiantes DESC;
GO

-- 4. Calcular el promedio de notas por asignatura y periodo.
SELECT 
    per.codigo AS periodo,
    a.codigo AS codigo_asignatura,
    a.nombre AS asignatura,
    ROUND(AVG(ev.nota), 2) AS promedio_nota
FROM Evaluacion ev
INNER JOIN Matricula m ON ev.id_matricula = m.id_matricula
INNER JOIN Grupo g ON m.id_grupo = g.id_grupo
INNER JOIN Asignatura a ON g.id_asignatura = a.id_asignatura
INNER JOIN Periodo per ON g.id_periodo = per.id_periodo
GROUP BY per.codigo, a.codigo, a.nombre
ORDER BY per.codigo DESC, promedio_nota DESC;
GO

-- 5. Mostrar matrículas con estudiante, grupo, asignatura y docente.
SELECT 
    m.id_matricula,
    CONCAT(e.nombre, ' ', e.apellido) AS estudiante,
    g.codigo_grupo,
    a.nombre AS asignatura,
    CONCAT(d.nombre, ' ', d.apellido) AS docente,
    m.estado AS estado_matricula
FROM Matricula m
INNER JOIN Estudiante e ON m.id_estudiante = e.id_estudiante
INNER JOIN Grupo g ON m.id_grupo = g.id_grupo
INNER JOIN Asignatura a ON g.id_asignatura = a.id_asignatura
INNER JOIN Docente d ON g.id_docente = d.id_docente;
GO

-- 6. Listar docentes aunque no tengan grupos en el periodo.
SELECT 
    d.codigo_docente,
    d.nombre,
    d.apellido,
    COUNT(g.id_grupo) AS cantidad_grupos_asignados
FROM Docente d
LEFT JOIN Grupo g ON d.id_docente = g.id_docente
GROUP BY d.codigo_docente, d.nombre, d.apellido
ORDER BY cantidad_grupos_asignados ASC;
GO

-- 7. Encontrar asignaturas que nunca se hayan ofrecido en grupos.
SELECT 
    a.id_asignatura,
    a.codigo,
    a.nombre,
    a.creditos
FROM Asignatura a
LEFT JOIN Grupo g ON a.id_asignatura = g.id_asignatura
WHERE g.id_grupo IS NULL;
GO

-- 8. Identificar programas con más estudiantes que el promedio por programa.
SELECT 
    p.codigo_programa,
    p.nombre_programa,
    COUNT(e.id_estudiante) AS total_estudiantes
FROM Programa p
INNER JOIN Estudiante e ON p.id_programa = e.id_programa
GROUP BY p.id_programa, p.codigo_programa, p.nombre_programa
HAVING COUNT(e.id_estudiante) > (
    SELECT AVG(CAST(conteo AS FLOAT))
    FROM (
        SELECT COUNT(id_estudiante) AS conteo
        FROM Estudiante
        GROUP BY id_programa
    ) AS subconsulta_promedios
)
ORDER BY total_estudiantes DESC;
GO

-- 9. Encontrar estudiantes cuyo promedio supere el promedio de su programa.
WITH PromedioEstudiante AS (
    SELECT 
        e.id_estudiante,
        e.nombre,
        e.apellido,
        e.id_programa,
        AVG(ev.nota) AS prom_alumno
    FROM Estudiante e
    INNER JOIN Matricula m ON e.id_estudiante = m.id_estudiante
    INNER JOIN Evaluacion ev ON m.id_matricula = ev.id_matricula
    GROUP BY e.id_estudiante, e.nombre, e.apellido, e.id_programa
),
PromedioPrograma AS (
    SELECT 
        e.id_programa,
        AVG(ev.nota) AS prom_carrera
    FROM Estudiante e
    INNER JOIN Matricula m ON e.id_estudiante = m.id_estudiante
    INNER JOIN Evaluacion ev ON m.id_matricula = ev.id_matricula
    GROUP BY e.id_programa
)
SELECT 
    pe.nombre,
    pe.apellido,
    p.nombre_programa,
    ROUND(pe.prom_alumno, 2) AS promedio_estudiante,
    ROUND(pp.prom_carrera, 2) AS promedio_programa
FROM PromedioEstudiante pe
INNER JOIN PromedioPrograma pp ON pe.id_programa = pp.id_programa
INNER JOIN Programa p ON pe.id_programa = p.id_programa
WHERE pe.prom_alumno > pp.prom_carrera
ORDER BY promedio_estudiante DESC;
GO

-- 10. Consultar grupos con ocupación inferior al 50 % del cupo.
SELECT 
    g.codigo_grupo,
    a.nombre AS asignatura,
    g.cupo AS cupo_maximo,
    COUNT(m.id_matricula) AS matriculados_activos,
    ROUND((CAST(COUNT(m.id_matricula) AS FLOAT) / g.cupo) * 100, 2) AS porcentaje_ocupacion
FROM Grupo g
INNER JOIN Asignatura a ON g.id_asignatura = a.id_asignatura
LEFT JOIN Matricula m ON g.id_grupo = m.id_grupo AND m.estado = 'ACTIVA'
GROUP BY g.codigo_grupo, a.nombre, g.cupo
HAVING COUNT(m.id_matricula) < (g.cupo * 0.5)
ORDER BY porcentaje_ocupacion ASC;
GO
