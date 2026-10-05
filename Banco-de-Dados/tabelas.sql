-- Recria o banco do zero (evita erros de tabelas criadas pela metade)
DROP DATABASE IF EXISTS amonia_sense;
CREATE DATABASE amonia_sense;
USE amonia_sense;

-- =========================================================
-- Cliente (precisa vir antes de Local, Incidente e empresa)
-- =========================================================
CREATE TABLE cliente (
    idCliente INT PRIMARY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    documento VARCHAR(40) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    dtNasc DATE NOT NULL,
    senha VARCHAR(60) NOT NULL,
    CONSTRAINT chkEmailResp CHECK (email LIKE '%@%')
);

INSERT INTO cliente (nome, documento, email, telefone, dtNasc, senha) VALUES
('Carlos Eduardo Lima', '12345678901', 'carlos.lima@gmail.com', '11987654321', '1978-02-20', 'Senha segura 123'),
('Mariana Souza', '23456789012', 'mariana.souza@gmail.com', '11912345678', '2000-04-10', 'Senha segura 123'),
('Roberto Alves', '21998765432', 'roberto.alves@gmail.com', '34567890123', '1990-10-29', 'Senha segura 123'),
('Fernanda Costa', '34991234567', 'fernanda.costa@gmail.com', '45678901234', '1988-07-25', 'Senha segura 123');

SELECT * FROM cliente;

DESCRIBE cliente;

SELECT CONCAT('Nome do usuário: ', nome, ' | Email: ', email, ' | Documento: ', IFNULL(Documento, '(Sem Documento cadastrado)')) AS 'Descrição'
FROM cliente;

SELECT nome, TIMESTAMPDIFF(YEAR, dtNasc, NOW()) AS 'IDADE DO USUÁRIO'
FROM cliente;

SELECT CONCAT('Nome do usuário: ', nome, ' | Email: ', email, ' | Documento: ', IFNULL(Documento, '(Sem Documento cadastrado)'),
FROM cliente;

-- =========================================================
-- Local
-- =========================================================
CREATE TABLE Local (
    idLocal INT PRIMARY KEY AUTO_INCREMENT,
    nomeLocal VARCHAR(100) NOT NULL,
    cidade VARCHAR(50),
    
    cep CHAR(8),
    fkCliente INT,
    statusOperacao TINYINT DEFAULT 1,
    CONSTRAINT fkClienteLocal FOREIGN KEY (fkCliente) REFERENCES Cliente (idCliente)
);

INSERT INTO Local (nomeLocal, cidade, cep, fkCliente) VALUES
('Fazenda Nova Orla', 'São José', '13010111', 1),
('Abatedouro do José', 'São Paulo', '01001000', NULL),
('Dessosa Minas', 'Volta Redonda', NULL, 3),
('Fazenda Novos Ares', 'Uberlândia', '14010200', 4);

SELECT * FROM Local;

SELECT CONCAT(
    'Frigorífico: ', L.nomeLocal,
    ' | Cidade: ', IFNULL(L.cidade, 'Não informada'),
    ' | CEP: ', IFNULL(L.cep, 'CEP Pendente'),
    ' | Gerente: ', IFNULL(R.nome, 'Aguardando contratação'),
    ' | Status: ',
    CASE
        WHEN L.statusOperacao = 1 THEN 'Ativo'
        ELSE 'Desativado'
    END
) AS 'Relatório de Unidades'
FROM Local L
LEFT JOIN Cliente R ON L.fkCliente = R.idCliente;

-- =========================================================
-- SENSOR
-- =========================================================
CREATE TABLE Sensor (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    identificarSensor VARCHAR(50) NOT NULL,
    statusVazamento VARCHAR(20) DEFAULT 'Normal',
    concentracaoValor INT NOT NULL,
    dataHoraLeitura DATETIME DEFAULT CURRENT_TIMESTAMP,
    statusSensor VARCHAR(20) DEFAULT 'ATIVO',
    fkLocal INT,
    CONSTRAINT fkSensorLocal FOREIGN KEY (fkLocal) REFERENCES Local(idLocal),
    CONSTRAINT chk_sensor_status CHECK (statusSensor IN ('ATIVO', 'MANUTENCAO', 'INATIVO')),
    CONSTRAINT chkconcentracaoValor CHECK (concentracaoValor >= 0 AND concentracaoValor <= 1023),
    CONSTRAINT chkStatusVazamento CHECK (statusVazamento IN ('Normal', 'Alerta', 'Evacuação'))
);

INSERT INTO Sensor (identificarSensor, fkLocal, concentracaoValor) VALUES
('MQ-2', 1, 200),
('MQ-2', 2, 400),
('MQ-2', 3, 300),
('MQ-2', 4, 800);

SELECT * FROM Sensor;

SELECT CONCAT('SENSOR UTILIZADO: ', identificarSensor, ' | CONCENTRAÇÃO DO VALOR NO LOCAL: ', concentracaoValor, ' | DATA E HORA DA LEITURA: ', dataHoraLeitura, ' | STATUS VAZAMENTO: ',
    CASE
        WHEN concentracaoValor <= 200 THEN 'Normal - Ar limpo'
        WHEN concentracaoValor <= 600 THEN 'Alerta - Ligar exaustores'
        ELSE 'Evacuação - Nível tóxico'
    END) AS 'STATUS DA OPERAÇÃO'
FROM Sensor;

-- =========================================================
-- INCIDENTE (com gravidade de 1 a 3)
-- Escala: 1 = Atenção | 2 = Perigo | 3 = Risco de Morte
-- =========================================================
CREATE TABLE Incidente (
    idIncidente INT PRIMARY KEY AUTO_INCREMENT,
    fkSensor INT NOT NULL,
    ClienteLocal INT,
    nivelDePerigo VARCHAR(20) NOT NULL,
    gravidade TINYINT NOT NULL,
    acaoTomada VARCHAR(150),
    dataAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    dataResolucao DATETIME,
    statusIncidente VARCHAR(20) DEFAULT 'Aberto',
    CONSTRAINT fkIncidenteSensor FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor),
    CONSTRAINT fkIncidenteResp FOREIGN KEY (ClienteLocal) REFERENCES Cliente(idCliente),
    CONSTRAINT chkStatusIncidente CHECK (statusIncidente IN ('Aberto', 'Em Atendimento', 'Resolvido')),
    CONSTRAINT chkNivelDePerigo CHECK (nivelDePerigo IN ('Atenção', 'Perigo', 'Risco de Morte')),
    CONSTRAINT chkGravidade CHECK (gravidade IN (1, 2, 3))
);

INSERT INTO Incidente (fkSensor, ClienteLocal, nivelDePerigo, gravidade, acaoTomada, dataResolucao, statusIncidente) VALUES
(2, 1, 'Perigo', 2, 'Ventilação ativada manualmente e local evacuado', '2026-09-04 10:30:00', 'Resolvido'),
(3, NULL, 'Atenção', 1, NULL, NULL, 'Aberto'),
(4, 2, 'Risco de Morte', 3, 'Isolamento da área e acionamento dos bombeiros', NULL, 'Em Atendimento'),
(2, NULL, 'Atenção', 1, NULL, NULL, 'Aberto');

SELECT * FROM Incidente;

SELECT
    CONCAT('Alerta no Sensor ID: ', fkSensor,
            ' | Nível: ', nivelDePerigo,
            ' | Gravidade: ', gravidade,
            ' | Técnico: ', IFNULL(ClienteLocal, '(Aguardando)'),
            ' | Ação: ', IFNULL(acaoTomada, '(Nenhuma ação registrada)'),
            ' | Status da Ocorrência: ',
            CASE
                WHEN statusIncidente = 'Aberto' THEN 'REQUER ATENÇÃO IMEDIATA'
                WHEN statusIncidente = 'Em Atendimento' THEN 'EQUIPE NO LOCAL'
                ELSE 'PROBLEMA RESOLVIDO'
            END) AS 'Painel de Monitoramento'
FROM Incidente;

SELECT idIncidente, nivelDePerigo, gravidade,
    DATE_FORMAT(dataAlerta, '%d/%m/%Y %H:%i') AS 'Data do Alerta',
    TIMESTAMPDIFF(HOUR, dataAlerta, NOW()) AS 'Horas desde o disparo'
FROM Incidente
WHERE statusIncidente != 'Resolvido'
ORDER BY gravidade DESC;

-- =========================================================
-- EMPRESA
-- =========================================================
CREATE TABLE empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    data_cadastro DATE DEFAULT (CURDATE()),
    status_contrato VARCHAR(10) NOT NULL,
    fkCliente INT,
    CONSTRAINT fkClienteEmpresa FOREIGN KEY (fkCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT checkContrato CHECK(status_contrato IN('Ativo','Cancelado')),
    data_pagamento DATETIME,
    status_pagamento TINYINT NOT NULL,
    CONSTRAINT checkPagamento CHECK(status_pagamento IN(0, 1))
);

INSERT INTO empresa (nome, cnpj, status_contrato, data_pagamento, status_pagamento) VALUES
('Frigorífico Boi Gordo S.A.', '12345678000199', 'Ativo', '2026-09-05', 1),
('Carnes Premium Exportação Ltda', '98765432000188', 'Ativo', NULL, 0),
('Abatedouro Vale do Sol', '11122233000177', 'Cancelado', '2025-12-10', 1);

SELECT * FROM empresa;

SELECT CONCAT(
    ' Cliente: ', nome,
    ' | CNPJ: ', cnpj,
    ' | Contrato: ', status_contrato,
    ' | Situação Financeira: ',
    CASE
        WHEN status_pagamento = 1 THEN 'Pagamento em Dia'
        ELSE 'Inadimplente (Bloquear Sistema)'
    END,
    ' | Último Pagamento: ', IFNULL(DATE_FORMAT(data_pagamento, '%d/%m/%Y %H:%i'), 'Nenhum pagamento registrado')
) AS 'Dashboard Financeiro'
FROM empresa;