CREATE DATABASE amonia_sense;
USE amonia_sense;

-- =========================================================
-- Empresa 
-- =========================================================

CREATE TABLE Empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nomeFantasia VARCHAR(45) NOT NULL,
    cnpj VARCHAR(15) UNIQUE NOT NULL
);

-- =========================================================
-- Usuário
-- =========================================================

CREATE TABLE Usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    documento VARCHAR(40) UNIQUE NOT NULL, -- CPF ou Passaporte
	telefone VARCHAR(20) NOT NULL,
	email VARCHAR(100) NOT NULL,
	senha VARCHAR(60) NOT NULL,
    dtNasc DATE NOT NULL,
    fkEmpresa INT,
    CONSTRAINT fkEmpresaUsuario FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa),
    fkResponsavel INT, 
    CONSTRAINT fkResponsavelUsuario FOREIGN KEY (fkResponsavel) REFERENCES Usuario(idUsuario)
);

-- =========================================================
-- Local
-- =========================================================

CREATE TABLE Locall (
    idLocal INT PRIMARY KEY AUTO_INCREMENT,
    UF char(2) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    cep VARCHAR(8),
    fkEmpresa INT,
    CONSTRAINT fkEmpresaLocal FOREIGN KEY (fkEmpresa) REFERENCES Empresa (idEmpresa)
);

-- =========================================================
-- Sensor
-- =========================================================

CREATE TABLE Sensor (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(45) NOT NULL,
    tipo VARCHAR(45),
    localizacao VARCHAR(50), -- RESOLVER LOCALIZAÇÃO 
    statuss VARCHAR(20),
    CONSTRAINT chkstatus CHECK (statuss IN ('Ativo', 'Inativo', 'Manutenção')),
    fkLocal INT,
    CONSTRAINT fkLocalSensor FOREIGN KEY (fkLocal) REFERENCES Locall(idLocal)
);

-- =========================================================
-- Dados do Sensor
-- =========================================================

CREATE TABLE Dado_captado (
	idDado INT AUTO_INCREMENT,
    fkSensor INT,
	CONSTRAINT pkComposta PRIMARY KEY (idDado, fkSensor),
    concentracaoAmonia DECIMAL(10,2),
    dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fkDadoSensor FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor)
);