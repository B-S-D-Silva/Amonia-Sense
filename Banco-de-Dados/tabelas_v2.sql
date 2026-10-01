CREATE DATABASE amonia_sense;
USE amonia_sense;

-- =========================================================
-- Empresa 
-- =========================================================

CREATE TABLE Empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    cnpj VARCHAR(15) UNIQUE NOT NULL
);

-- =========================================================
-- Usuário
-- =========================================================

CREATE TABLE Usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    documento VARCHAR(40) UNIQUE NOT NULL,
	telefone VARCHAR(20) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	senha VARCHAR(60) NOT NULL,
    dtNasc DATE NOT NULL,
    CONSTRAINT chkEmailResp CHECK (email LIKE '%@%'),
    fkEmpresa INT,
    CONSTRAINT fkEmpresaUsuario FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa) 
);

-- =========================================================
-- Local
-- =========================================================

CREATE TABLE Locall (
    idLocal INT PRIMARY KEY AUTO_INCREMENT,
    cidade VARCHAR(50) NOT NULL,
    endereco VARCHAR(100),
    cep VARCHAR(8) NOT NULL,
    fkEmpresa INT,
    CONSTRAINT fkEmpresaLocal FOREIGN KEY (fkEmpresa) REFERENCES Empresa (idEmpresa)
);

-- =========================================================
-- Sensor
-- =========================================================

CREATE TABLE Sensor (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    tipo VARCHAR(45),
    coordenada VARCHAR(100),
    statuss VARCHAR(20),
    fkLocal INT,
    CONSTRAINT fkLocalSensor FOREIGN KEY (fkLocal) REFERENCES Locall(idLocal)
);

-- =========================================================
-- Dados do Sensor
-- =========================================================

CREATE TABLE Dado_captado (
	idDado INT,
    concentracaoAmonia DECIMAL(10,2),
    dataHora DATETIME,
    fkSensor INT, 
    CONSTRAINT fkSensorDado_captado FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor)
)