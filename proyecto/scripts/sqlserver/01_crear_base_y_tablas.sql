
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'GestionAcademicaUni')
BEGIN
    ALTER DATABASE GestionAcademicaUni SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GestionAcademicaUni;
END
GO

CREATE DATABASE GestionAcademicaUni;
GO

USE GestionAcademicaUni;
GO

-- Tabla: Programa
CREATE TABLE Programa (
    id_programa INT IDENTITY(1,1),
    codigo_programa VARCHAR(20) NOT NULL,
    nombre_programa VARCHAR(100) NOT NULL,
    facultad VARCHAR(100) NOT NULL,
    activo BIT NOT NULL,
    CONSTRAINT PK_Programa PRIMARY KEY (id_programa)
);
GO

-- Tabla: Estudiante
CREATE TABLE Estudiante (
    id_estudiante INT IDENTITY(1,1),
    codigo_estudiante VARCHAR(20) NOT NULL,
    tipo_documento VARCHAR(5) NOT NULL,
    numero_documento VARCHAR(25) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    correo_institucional VARCHAR(100) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    estado VARCHAR(15) NOT NULL,
    id_programa INT NOT NULL,
    CONSTRAINT PK_Estudiante PRIMARY KEY (id_estudiante),
    CONSTRAINT FK_Estudiante_Programa FOREIGN KEY (id_programa) REFERENCES Programa(id_programa)
);
GO

-- Tabla: Asignatura
CREATE TABLE Asignatura (
    id_asignatura INT IDENTITY(1,1),
    codigo VARCHAR(25) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    creditos INT NOT NULL,
    activa BIT NOT NULL,
    CONSTRAINT PK_Asignatura PRIMARY KEY (id_asignatura)
);
GO

--  Tabla: Prerrequisito
CREATE TABLE Prerrequisito (
    id_asignatura INT NOT NULL,
    id_asignatura_prerrequisito INT NOT NULL,
    CONSTRAINT PK_Prerrequisito PRIMARY KEY (id_asignatura, id_asignatura_prerrequisito),
    CONSTRAINT FK_Prereq_AsignaturaBase FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    CONSTRAINT FK_Prereq_AsignaturaRequisito FOREIGN KEY (id_asignatura_prerrequisito) REFERENCES Asignatura(id_asignatura)
);
GO

--  Tabla: Docente
CREATE TABLE Docente (
    id_docente INT IDENTITY(1,1),
    codigo_docente VARCHAR(20) NOT NULL,
    tipo_documento VARCHAR(5) NOT NULL,
    numero_documento VARCHAR(25) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    correo_institucional VARCHAR(150) NOT NULL,
    activo BIT NOT NULL,
    CONSTRAINT PK_Docente PRIMARY KEY (id_docente)
);
GO

-- Tabla: Periodo
CREATE TABLE Periodo (
    id_periodo INT IDENTITY(1,1),
    codigo VARCHAR(15) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    CONSTRAINT PK_Periodo PRIMARY KEY (id_periodo)
);
GO

-- Tabla: Grupo
CREATE TABLE Grupo (
    id_grupo INT IDENTITY(1,1),
    codigo_grupo VARCHAR(20) NOT NULL,
    id_asignatura INT NOT NULL,
    id_docente INT NOT NULL,
    id_periodo INT NOT NULL,
    cupo INT NOT NULL,
    estado VARCHAR(15) NOT NULL,
    CONSTRAINT PK_Grupo PRIMARY KEY (id_grupo),
    CONSTRAINT FK_Grupo_Asignatura FOREIGN KEY (id_asignatura) REFERENCES Asignatura(id_asignatura),
    CONSTRAINT FK_Grupo_Docente FOREIGN KEY (id_docente) REFERENCES Docente(id_docente),
    CONSTRAINT FK_Grupo_Periodo FOREIGN KEY (id_periodo) REFERENCES Periodo(id_periodo)
);
GO

-- Tabla: HorarioGrupo
CREATE TABLE HorarioGrupo (
    id_horario INT IDENTITY(1,1),
    id_grupo INT NOT NULL,
    dia_semana INT NOT NULL,
    hora_inicio TIME(0) NOT NULL,
    hora_fin TIME(0) NOT NULL,
    aula VARCHAR(20) NOT NULL,
    CONSTRAINT PK_HorarioGrupo PRIMARY KEY (id_horario),
    CONSTRAINT FK_Horario_Grupo FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo)
);
GO

-- Tabla: Matricula
CREATE TABLE Matricula (
    id_matricula INT IDENTITY(1,1),
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_matricula DATE NOT NULL,
    estado VARCHAR(15) NOT NULL,
    CONSTRAINT PK_Matricula PRIMARY KEY (id_matricula),
    CONSTRAINT FK_Matricula_Estudiante FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante),
    CONSTRAINT FK_Matricula_Grupo FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo)
);
GO

--  Tabla: Evaluacion
CREATE TABLE Evaluacion (
    id_evaluacion INT IDENTITY(1,1),
    id_matricula INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    porcentaje FLOAT NOT NULL,
    nota FLOAT NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    CONSTRAINT PK_Evaluacion PRIMARY KEY (id_evaluacion),
    CONSTRAINT FK_Evaluacion_Matricula FOREIGN KEY (id_matricula) REFERENCES Matricula(id_matricula)
);
GO
