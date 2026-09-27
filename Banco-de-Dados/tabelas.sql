CREATE DATABASE amonia_sense;
USE amonia_sense;

CREATE TABLE Responsavel (
    idResponsavel INT PRIMARY KEY AUTO_INCREMENT,
    nomeCompleto VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dataNascimento DATE,
    senha VARCHAR(255), 
    dtAquisicao DATETIME DEFAULT CURRENT_TIMESTAMP,
    cpf CHAR(11) NOT NULL UNIQUE,
    statusConta TINYINT DEFAULT 1,
    CONSTRAINT chkEmail CHECK (email LIKE '%@%')
);

DESCRIBE Responsavel;

INSERT INTO Responsavel (nomeCompleto, email, dataNascimento, senha, cpf) VALUES
('José Fernando da Silva', 'jose@gmail.com', '1978-02-20', 'Senha segura 123', '54896275614'),
('Pedro Afonso dos Santos', 'pedro.afo@gmail.com', '2000-04-10', 'Senha segura 123', '36794201984'),
('Guilherme dos Campos', 'gui.campos@gmail.com', '1990-10-29', 'Senha segura 123', '87925643102'),
('Julia Miranda', 'julia.miranda@gmail.com', '1988-07-25', 'Senha segura 123', '14975236849');

SELECT * FROM Responsavel;

SELECT CONCAT('Nome do usuário: ', nomeCompleto, ' | Email: ', email, ' | CPF: ', IFNULL(cpf, '(Sem CPF cadastrado)')) AS 'Descrição' 
FROM Responsavel;

SELECT nomeCompleto, TIMESTAMPDIFF(YEAR, dataNascimento, NOW()) AS 'IDADE DO USUÁRIO' 
FROM Responsavel;

SELECT CONCAT('Nome do usuário: ', nomeCompleto, ' | Email: ', email, ' | CPF: ', IFNULL(cpf, '(Sem CPF cadastrado)'), ' | Status da Conta: ',
    CASE 
        WHEN statusConta = 1 THEN 'Ativo'
        ELSE 'Desativado'
    END) AS 'Descrição' 
FROM Responsavel;

CREATE TABLE Locais (
    idLocal INT PRIMARY KEY AUTO_INCREMENT,
    nomeLocal VARCHAR(100) NOT NULL,
    cidade VARCHAR(50),
    cep CHAR(8),
    fkResponsavel INT,
    statusOperacao TINYINT DEFAULT 1,
    CONSTRAINT fkResponsavelLocal FOREIGN KEY (fkResponsavel) REFERENCES Responsavel (idResponsavel)
);

INSERT INTO Locais (nomeLocal, cidade, cep, fkResponsavel) VALUES
('Fazenda Nova Orla', 'São José', '13010111', 1),
('Abatedouro do José', 'São Paulo', '01001000', NULL),
('Dessosa Minas', 'Volta Redonda', NULL, 3),
('Fazenda Novos Ares', 'Uberlândia', '14010200', 4);

SELECT * FROM Locais;

SELECT CONCAT(
    'Frigorífico: ', L.nomeLocal, 
    ' | Cidade: ', IFNULL(L.cidade, 'Não informada'), 
    ' | CEP: ', IFNULL(L.cep, 'CEP Pendente'), 
    ' | Gerente: ', IFNULL(R.nomeCompleto, 'Aguardando contratação'),
    ' | Status: ', 
    CASE 
        WHEN L.statusOperacao = 1 THEN 'Ativo'
        ELSE 'Desativado'
    END
) AS 'Relatório de Unidades' 
FROM Locais L
LEFT JOIN Responsavel R ON L.fkResponsavel = R.idResponsavel;

CREATE TABLE Sensor (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    identificarSensor VARCHAR(50) NOT NULL,
    statusVazamento VARCHAR(20) DEFAULT 'Normal',
    concentracaoValor INT NOT NULL,
    dataHoraLeitura DATETIME DEFAULT CURRENT_TIMESTAMP,
    statusSensor VARCHAR(20) DEFAULT 'ATIVO',
    fkLocal INT, 
    CONSTRAINT fkSensorLocal FOREIGN KEY (fkLocal) REFERENCES Locais(idLocal),
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

CREATE TABLE Incidente (
    idIncidente INT PRIMARY KEY AUTO_INCREMENT,
    fkSensor INT NOT NULL,
    responsavelLocal INT,
    nivelDePerigo VARCHAR(20) NOT NULL,
    acaoTomada VARCHAR(150),
    dataAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    dataResolucao DATETIME,
    statusIncidente VARCHAR(20) DEFAULT 'Aberto',
    CONSTRAINT fkIncidenteSensor FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor),
    CONSTRAINT chkStatusIncidente CHECK (statusIncidente IN ('Aberto', 'Em Atendimento', 'Resolvido')),
    CONSTRAINT chkNivelDePerigo CHECK (nivelDePerigo IN ('Atenção', 'Perigo', 'Risco de Morte'))
);

INSERT INTO Incidente (fkSensor, responsavelLocal, nivelDePerigo, acaoTomada, dataResolucao, statusIncidente) VALUES 
(2, 1, 'Perigo', 'Ventilação ativada manualmente e local evacuado', '2026-09-04 10:30:00', 'Resolvido'),
(3, NULL, 'Atenção', NULL, NULL, 'Aberto'),
(4, 2, 'Risco de Morte', 'Isolamento da área e acionamento dos bombeiros', NULL, 'Em Atendimento'),
(2, NULL, 'Atenção', NULL, NULL, 'Aberto');

SELECT * FROM Incidente;

SELECT 
    CONCAT('Alerta no Sensor ID: ', fkSensor,
            ' | Nível: ', nivelDePerigo,
            ' | Técnico: ', IFNULL(responsavelLocal, '(Aguardando)'),
            ' | Ação: ', IFNULL(acaoTomada, '(Nenhuma ação registrada)'),
            ' | Status da Ocorrência: ',
            CASE
                WHEN statusIncidente = 'Aberto' THEN 'REQUER ATENÇÃO IMEDIATA'
                WHEN statusIncidente = 'Em Atendimento' THEN 'EQUIPE NO LOCAL'
                ELSE 'PROBLEMA RESOLVIDO'
            END) AS 'Painel de Monitoramento'
FROM Incidente;

SELECT idIncidente, nivelDePerigo, 
    DATE_FORMAT(dataAlerta, '%d/%m/%Y %H:%i') AS 'Data do Alerta',
    TIMESTAMPDIFF(HOUR, dataAlerta, NOW()) AS 'Horas desde o disparo'
FROM Incidente
WHERE statusIncidente != 'Resolvido';

CREATE TABLE empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    data_cadastro DATE DEFAULT (CURDATE()),
    status_contrato VARCHAR(10) NOT NULL,
    fkResponsavel INT,
    CONSTRAINT fkResponsavelEmpresa FOREIGN KEY (fkResponsavel) REFERENCES Responsavel(idResponsavel),
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
