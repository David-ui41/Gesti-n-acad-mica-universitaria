
USE GestionAcademicaUni;
GO

-- 1. Restricciones en Programa
ALTER TABLE Programa ADD CONSTRAINT UQ_CodigoPrograma UNIQUE (codigo_programa);
ALTER TABLE Programa ADD CONSTRAINT DF_Programa_Activo DEFAULT (1) FOR activo;
GO

-- 2. Restricciones en Estudiante
ALTER TABLE Estudiante ADD CONSTRAINT UQ_CodigoEstudiante UNIQUE (codigo_estudiante);
ALTER TABLE Estudiante ADD CONSTRAINT UQ_DocEstudiante UNIQUE (tipo_documento, numero_documento);
ALTER TABLE Estudiante ADD CONSTRAINT UQ_CorreoEstudiante UNIQUE (correo_institucional);
ALTER TABLE Estudiante ADD CONSTRAINT DF_Estudiante_Estado DEFAULT ('ACTIVO') FOR estado;
ALTER TABLE Estudiante ADD CONSTRAINT CHK_EstadoEstudiante CHECK (estado IN ('ACTIVO', 'INACTIVO', 'GRADUADO', 'RETIRADO'));
GO

-- 3. Restricciones en Asignatura y Prerrequisito
ALTER TABLE Asignatura ADD CONSTRAINT UQ_CodigoAsignatura UNIQUE (codigo);
ALTER TABLE Asignatura ADD CONSTRAINT CHK_Creditos CHECK (creditos > 0);
ALTER TABLE Asignatura ADD CONSTRAINT DF_Asignatura_Activa DEFAULT (1) FOR activa;

ALTER TABLE Prerrequisito ADD CONSTRAINT CHK_NoAutoRequisito CHECK (id_asignatura <> id_asignatura_prerrequisito);
GO

-- 4. Restricciones en Docente
ALTER TABLE Docente ADD CONSTRAINT UQ_CodigoDocente UNIQUE (codigo_docente);
ALTER TABLE Docente ADD CONSTRAINT UQ_NumeroDocumentoDoc UNIQUE (numero_documento);
ALTER TABLE Docente ADD CONSTRAINT UQ_CorreoDocente UNIQUE (correo_institucional);
ALTER TABLE Docente ADD CONSTRAINT DF_Docente_Activo DEFAULT (1) FOR activo;
GO

-- 5. Restricciones en Periodo
ALTER TABLE Periodo ADD CONSTRAINT UQ_CodigoPeriodo UNIQUE (codigo);
ALTER TABLE Periodo ADD CONSTRAINT CHK_FechasPeriodo CHECK (fecha_fin > fecha_inicio);
GO

-- 6. Restricciones en Grupo y HorarioGrupo
ALTER TABLE Grupo ADD CONSTRAINT UQ_CodigoGrupo UNIQUE (codigo_grupo);
ALTER TABLE Grupo ADD CONSTRAINT CHK_Cupo CHECK (cupo > 0);
ALTER TABLE Grupo ADD CONSTRAINT DF_Grupo_Estado DEFAULT ('ABIERTO') FOR estado;
ALTER TABLE Grupo ADD CONSTRAINT CHK_EstadoGrupo CHECK (estado IN ('ABIERTO', 'CERRADO', 'CANCELADO'));

ALTER TABLE HorarioGrupo ADD CONSTRAINT CHK_DiaSemana CHECK (dia_semana BETWEEN 1 AND 7);
ALTER TABLE HorarioGrupo ADD CONSTRAINT CHK_Horas CHECK (hora_fin > hora_inicio);
GO

-- 7. Restricciones en Matricula
ALTER TABLE Matricula ADD CONSTRAINT UQ_Estudiante_Grupo UNIQUE (id_estudiante, id_grupo);
ALTER TABLE Matricula ADD CONSTRAINT DF_Matricula_Fecha DEFAULT (GETDATE()) FOR fecha_matricula;
ALTER TABLE Matricula ADD CONSTRAINT DF_Matricula_Estado DEFAULT ('ACTIVA') FOR estado;
ALTER TABLE Matricula ADD CONSTRAINT CHK_EstadoMatricula CHECK (estado IN ('ACTIVA', 'CANCELADA', 'APROBADA', 'REPROBADA'));
GO

-- 8. Restricciones en Evaluacion
ALTER TABLE Evaluacion ADD CONSTRAINT UQ_Matricula_EvaluacionNombre UNIQUE (id_matricula, nombre);
ALTER TABLE Evaluacion ADD CONSTRAINT CHK_Porcentaje CHECK (porcentaje > 0.0 AND porcentaje <= 100.0);
ALTER TABLE Evaluacion ADD CONSTRAINT CHK_Nota CHECK (nota >= 0.0 AND nota <= 5.0);
GO

-- ============================================================================
-- TRIGGER DE REGLA DE NEGOCIO: Validar que los porcentajes no excedan 100%
-- ============================================================================
CREATE TRIGGER TR_ValidarPorcentajeEvaluacion
ON Evaluacion
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT id_matricula
        FROM Evaluacion
        WHERE id_matricula IN (SELECT DISTINCT id_matricula FROM inserted)
        GROUP BY id_matricula
        HAVING SUM(porcentaje) > 100.0
    )
    BEGIN
        RAISERROR ('Error de Negocio: La suma de porcentajes de evaluación para una matrícula no puede superar el 100%%.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
