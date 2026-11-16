
USE GestionAcademicaUni;
GO
SET NOCOUNT ON;

DECLARE @i INT = 1;

-- 1. Insertar 1.000 Programas Académicos
WHILE @i <= 1000
BEGIN
    INSERT INTO Programa (codigo_programa, nombre_programa, facultad, activo)
    VALUES (
        CONCAT('PROG-', RIGHT('0000' + CAST(@i AS VARCHAR), 4)),
        CONCAT('Programa Profesional en Área ', @i),
        CASE (@i % 5)
            WHEN 0 THEN 'Facultad de Ingeniería'
            WHEN 1 THEN 'Facultad de Ciencias de la Salud'
            WHEN 2 THEN 'Facultad de Ciencias Económicas'
            WHEN 3 THEN 'Facultad de Derecho y Ciencias Políticas'
            ELSE 'Facultad de Artes y Humanidades'
        END,
        CASE WHEN @i % 20 = 0 THEN 0 ELSE 1 END
    );
    SET @i = @i + 1;
END
GO

-- 2. Insertar 1.000 Estudiantes
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Estudiante (codigo_estudiante, tipo_documento, numero_documento, nombre, apellido, correo_institucional, fecha_ingreso, estado, id_programa)
    VALUES (
        CONCAT('EST-2026-', RIGHT('0000' + CAST(@i AS VARCHAR), 4)),
        CASE WHEN @i % 10 = 0 THEN 'TI' ELSE 'CC' END,
        CAST(1000000000 + @i AS VARCHAR),
        CASE (@i % 6)
            WHEN 0 THEN 'Carlos' WHEN 1 THEN 'María' WHEN 2 THEN 'Andrés'
            WHEN 3 THEN 'Laura' WHEN 4 THEN 'Santiago' ELSE 'Valentina'
        END,
        CONCAT('Apellido', @i),
        CONCAT('estudiante', @i, '@universidad.edu.co'),
        DATEADD(DAY, -(@i % 1000), '2026-01-15'),
        CASE WHEN @i % 15 = 0 THEN 'INACTIVO' ELSE 'ACTIVO' END,
        ((@i - 1) % 50) + 1 -- Concentra estudiantes en los primeros 50 programas para analítica
    );
    SET @i = @i + 1;
END
GO

-- 3. Insertar 1.000 Asignaturas
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Asignatura (codigo, nombre, creditos, activa)
    VALUES (
        CONCAT('ASIG-', RIGHT('0000' + CAST(@i AS VARCHAR), 4)),
        CONCAT('Asignatura Fundamental Nivel ', @i),
        ((@i % 4) + 1), -- Créditos entre 1 y 4
        CASE WHEN @i % 25 = 0 THEN 0 ELSE 1 END
    );
    SET @i = @i + 1;
END
GO

-- 4. Insertar 1.000 Prerrequisitos 
DECLARE @i INT = 2;
WHILE @i <= 1001
BEGIN
    INSERT INTO Prerrequisito (id_asignatura, id_asignatura_prerrequisito)
    VALUES (
        CASE WHEN @i > 1000 THEN 1000 ELSE @i END,
        (@i - 1)
    );
    SET @i = @i + 1;
END
GO

-- 5. Insertar 1.000 Docentes
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Docente (codigo_docente, tipo_documento, numero_documento, nombre, apellido, correo_institucional, activo)
    VALUES (
        CONCAT('DOC-', RIGHT('0000' + CAST(@i AS VARCHAR), 4)),
        'CC',
        CAST(70000000 + @i AS VARCHAR),
        CASE (@i % 4)
            WHEN 0 THEN 'Jorge' WHEN 1 THEN 'Diana' WHEN 2 THEN 'Fernando' ELSE 'Claudia'
        END,
        CONCAT('Profesor', @i),
        CONCAT('docente', @i, '@universidad.edu.co'),
        CASE WHEN @i % 30 = 0 THEN 0 ELSE 1 END
    );
    SET @i = @i + 1;
END
GO

-- 6. Insertar 1.000 Periodos Académicos
DECLARE @i INT = 1;
DECLARE @fechaBase DATE = '2000-01-01';
WHILE @i <= 1000
BEGIN
    INSERT INTO Periodo (codigo, nombre, fecha_inicio, fecha_fin)
    VALUES (
        CONCAT('PER-', RIGHT('0000' + CAST(@i AS VARCHAR), 4)),
        CONCAT('Periodo Académico Histórico ', @i),
        DATEADD(MONTH, (@i - 1) * 6, @fechaBase),
        DATEADD(MONTH, (@i * 6) - 1, @fechaBase)
    );
    SET @i = @i + 1;
END
GO

-- 7. Insertar 1.000 Grupos 
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Grupo (codigo_grupo, id_asignatura, id_docente, id_periodo, cupo, estado)
    VALUES (
        CONCAT('GRP-', RIGHT('0000' + CAST(@i AS VARCHAR), 4)),
        ((@i - 1) % 800) + 1,
        ((@i - 1) % 800) + 1,
        ((@i - 1) % 10) + 1,
        20 + (@i % 21), -- Cupos entre 20 y 40
        'ABIERTO'
    );
    SET @i = @i + 1;
END
GO

-- 8. Insertar 1.000 Horarios de Grupo
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO HorarioGrupo (id_grupo, dia_semana, hora_inicio, hora_fin, aula)
    VALUES (
        @i,
        ((@i - 1) % 6) + 1,
        '08:00:00',
        '10:00:00',
        CONCAT('Bloque A - Salón ', 100 + (@i % 50))
    );
    SET @i = @i + 1;
END
GO

-- 9. Insertar 1.000 Matrículas 
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Matricula (id_estudiante, id_grupo, fecha_matricula, estado)
    VALUES (
        ((@i - 1) % 900) + 1, -- Deja 100 estudiantes sin matrícula
        ((@i - 1) % 200) + 1, -- Concentra matrículas en 200 grupos
        DATEADD(DAY, -(@i % 30), GETDATE()),
        'ACTIVA'
    );
    SET @i = @i + 1;
END
GO

-- 10. Insertar 1.000 Evaluaciones 
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Evaluacion (id_matricula, nombre, porcentaje, nota, fecha_evaluacion)
    VALUES (
        @i,
        'Evaluación Consolidada Final',
        100.0,
        ROUND((RAND(CHECKSUM(NEWID())) * 4.0) + 1.0, 2), -- Notas variadas entre 1.00 y 5.00
        GETDATE()
    );
    SET @i = @i + 1;
END
GO

PRINT 'Carga de 1.000 registros por tabla';
GO
