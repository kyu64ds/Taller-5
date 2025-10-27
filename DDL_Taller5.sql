-- ========================================
-- DDL Taller 5 - Stored Procedures
-- Por: Juan José Pareja Ortíz
-- ========================================

IF DB_ID('FIFA_Sub20_Colombia2024') IS NOT NULL
    DROP DATABASE FIFA_Sub20_Colombia2024;
GO

CREATE DATABASE FIFA_Sub20_Colombia2024;
GO

USE FIFA_Sub20_Colombia2024;
GO

-- ==============================
-- Tabla: Pais
-- ==============================
CREATE TABLE Pais(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Pais NVARCHAR(100) NOT NULL,
    Entidad NVARCHAR(100) NULL,
    Bandera NVARCHAR(200) NULL,
    LogoEntidad NVARCHAR(200) NULL
);

-- ==============================
-- Tabla: Campeonato
-- ==============================
CREATE TABLE Campeonato(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Campeonato NVARCHAR(150) NOT NULL,
    IdPais INT NOT NULL,
    Anio INT NOT NULL,
    CONSTRAINT FK_Campeonato_Pais FOREIGN KEY (IdPais)
        REFERENCES Pais(Id)
);

-- ==============================
-- Tabla: Ciudad
-- ==============================
CREATE TABLE Ciudad(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Ciudad NVARCHAR(150) NOT NULL,
    IdPais INT NOT NULL,
    CONSTRAINT FK_Ciudad_Pais FOREIGN KEY (IdPais)
        REFERENCES Pais(Id)
);

-- ==============================
-- Tabla: Estadio
-- ==============================
CREATE TABLE Estadio(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Estadio NVARCHAR(150) NOT NULL,
    Capacidad INT NULL,
    IdCiudad INT NOT NULL,
    Foto NVARCHAR(255) NULL,
    CONSTRAINT FK_Estadio_Ciudad FOREIGN KEY (IdCiudad)
        REFERENCES Ciudad(Id)
);

-- ==============================
-- Tabla: Grupo
-- ==============================
CREATE TABLE Grupo(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Grupo NVARCHAR(10) NOT NULL,
    IdCampeonato INT NOT NULL,
    CONSTRAINT FK_Grupo_Campeonato FOREIGN KEY (IdCampeonato)
        REFERENCES Campeonato(Id)
);

-- ==============================
-- Tabla: GrupoPais
-- ==============================
CREATE TABLE GrupoPais(
    IdGrupo INT NOT NULL,
    IdPais INT NOT NULL,
    CONSTRAINT PK_GrupoPais PRIMARY KEY(IdGrupo, IdPais),
    CONSTRAINT FK_GrupoPais_Grupo FOREIGN KEY(IdGrupo)
        REFERENCES Grupo(Id),
    CONSTRAINT FK_GrupoPais_Pais FOREIGN KEY(IdPais)
        REFERENCES Pais(Id)
);

-- ==============================
-- Tabla: Fase
-- ==============================
CREATE TABLE Fase(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Fase NVARCHAR(100) NOT NULL
);

-- ==============================
-- Tabla: Encuentro
-- ==============================
CREATE TABLE Encuentro(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdPais1 INT NOT NULL,
    IdPais2 INT NOT NULL,
    IdEstadio INT NOT NULL,
    IdFase INT NOT NULL,
    IdCampeonato INT NOT NULL,
    Fecha DATE NOT NULL,
    Goles1 INT DEFAULT 0,
    Goles2 INT DEFAULT 0,
    CONSTRAINT FK_Encuentro_Pais1 FOREIGN KEY(IdPais1)
        REFERENCES Pais(Id),
    CONSTRAINT FK_Encuentro_Pais2 FOREIGN KEY(IdPais2)
        REFERENCES Pais(Id),
    CONSTRAINT FK_Encuentro_Estadio FOREIGN KEY(IdEstadio)
        REFERENCES Estadio(Id),
    CONSTRAINT FK_Encuentro_Fase FOREIGN KEY(IdFase)
        REFERENCES Fase(Id),
    CONSTRAINT FK_Encuentro_Campeonato FOREIGN KEY(IdCampeonato)
        REFERENCES Campeonato(Id)
);
GO
