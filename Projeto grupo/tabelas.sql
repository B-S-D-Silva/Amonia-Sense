create database pi;

use pi;

-- -----------------------------------------------------------------

CREATE TABLE Locais (
idLocal INT PRIMARY KEY AUTO_INCREMENT,
nomeLocal VARCHAR(100) NOT NULL,
cidade VARCHAR(50),
cep CHAR(8),
responsavelLocal VARCHAR(50)
);

INSERT INTO Locais (nomeLocal, cidade, cep, responsavelLocal) VALUES
('Fazenda Nova Orla', 'São José', '13010111', 'Carlos Silva'),
('Abatedouro do José', 'São Paulo', '01001000', NULL),
('Dessosa Minas', 'Volta Redonda', NULL, 'Mariana Costa'),
('Fazenda Novos Ares', 'Uberlândia', '14010200', 'Roberto Almeida');

SELECT * FROM Locais;

UPDATE Locais SET responsavelLocal = 'José Fernando' WHERE idLocal = 2;

UPDATE Locais SET cep = '30120010' WHERE idLocal = 3;

ALTER TABLE Locais ADD COLUMN statusOperacao TINYINT DEFAULT 1;

ALTER TABLE Locais MODIFY COLUMN responsavelLocal VARCHAR(80);

ALTER TABLE Locais ADD COLUMN ColunaTeste VARCHAR(10);
ALTER TABLE Locais DROP COLUMN ColunaTeste;

DELETE FROM Locais WHERE idLocal = 4;

UPDATE Locais SET statusOperacao = 0 WHERE idLocal = 3;

SELECT CONCAT(
    'Frigorífico: ', nomeLocal, 
    ' | Cidade: ', IFNULL(cidade, 'Não informada'), 
    ' | CEP: ', IFNULL(cep, 'CEP Pendente'), 
    ' | Gerente: ', IFNULL(responsavelLocal, 'Aguardando contratação'),
    ' | Status: ', 
    CASE 
        WHEN statusOperacao = 1 THEN 'Ativo'
        ELSE 'Desativado'
    END
) AS 'Relatório de Unidades' 
FROM Locais;

-- -------------------------------------------------------------------------------------

CREATE TABLE Usuarios (
idUsers INT PRIMARY KEY AUTO_INCREMENT,
nomeCompleto VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
dataNascimento DATE,
locais VARCHAR(100) NOT NULL,
senha VARCHAR(255), 
dtAquisicao DATETIME DEFAULT CURRENT_TIMESTAMP,
cpf CHAR(11) NOT NULL UNIQUE,
statusConta TINYINT DEFAULT 1,
CONSTRAINT chkEmail CHECK (email LIKE '%@%')
);

DESCRIBE Usuarios;

INSERT INTO Usuarios (nomeCompleto, email, dataNascimento, senha, cpf, locais) VALUES
('José Fernando da Silva', 'jose@gmail.com', '1978-02-20', 'Senha segura 123', '54896275614', 'Fazenda Nova Orla'),
('Pedro Afonso dos Santos', 'pedro.afo@gmail.com', '2000-04-10', 'Senha segura 123', '36794201984', 'Abatedouro do José'),
('Guilherme dos Campos', 'gui.campos@gmail.com', '1990-10-29', 'Senha segura 123', '87925643102', 'Dessosa Minas'),
('Julia Miranda', 'julia.miranda@gmail.com', '1988-07-25', 'Senha segura 123', '14975236849', 'Fazenda Novos Ares');

SELECT * FROM Usuarios;

UPDATE Usuarios SET senha = 'Estou protegido' WHERE idUsers = 2;

UPDATE Usuarios SET senha = 'Senhas iguais' WHERE idUsers IN(3,4);

ALTER TABLE Usuarios RENAME COLUMN nomeCompleto TO Nome;

ALTER TABLE Usuarios MODIFY COLUMN Nome VARCHAR(150);

ALTER TABLE Usuarios ADD COLUMN Teste VARCHAR(10);

ALTER TABLE Usuarios DROP COLUMN Teste;

ALTER TABLE Usuarios ADD CONSTRAINT chkNome CHECK (Nome LIKE '% %');

DELETE FROM Usuarios WHERE idUsers = 4;

SELECT CONCAT('Nome do usuario: ',Nome,' | Email: ',email,' | cpf: ',IFNULL(cpf, '(Sem CPF cadastrado)')) AS 'Descrição' FROM Usuarios;

SELECT Nome,TIMESTAMPDIFF(YEAR,dataNascimento,now()) AS 'IDADE DO USUARIO' FROM Usuarios;

UPDATE Usuarios SET statusConta = 0 WHERE idUsers = 3;

SELECT CONCAT('Nome do usuario: ',Nome,' | Email: ',email,' | cpf: ',IFNULL(cpf, '(Sem CPF cadastrado)'),' | Status da Conta: ',
CASE 
WHEN statusConta = 1 THEN 'Ativo'
ELSE 'Desativado'
END) AS 'Descrição' FROM Usuarios;

TRUNCATE TABLE Usuarios;

-- -------------------------------------------------------------------------------------

CREATE TABLE Sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
Locais VARCHAR(100) NOT NULL, 
identificarSensor VARCHAR(50) NOT NULL,
statusVazamento VARCHAR(20) DEFAULT 'Normal',
concentracaoValor INT NOT NULL,
dataHoraLeitura DATETIME DEFAULT CURRENT_TIMESTAMP,
statusSensor VARCHAR(20) DEFAULT 'ATIVO',
CONSTRAINT chk_sensor_status CHECK (statusSensor IN ('ATIVO', 'MANUTENCAO', 'INATIVO')),
CONSTRAINT chkconcentracaoValor CHECK (concentracaoValor >= 0 AND concentracaoValor <= 1023),
CONSTRAINT chkStatusVazamento CHECK (statusVazamento IN ('Normal', 'Alerta', 'Evacuação'))
);
/* valorAnalogico: Recebe o sinal elétrico do Arduino (de 0 a 1023)
0    = Ar limpo (Sem amônia)
1023 = Saturação máxima (Risco extremo)
Guardamos o valor bruto para calcular o PPM com exatidão no backend. */
INSERT INTO Sensor (identificarSensor,Locais,concentracaoValor) VALUES 
('MQ-2','Fazenda Nova Orla',200),
('MQ-2','Abatedouro do José',400),
('MQ-2','Dessosa Minas',300),
('MQ-2','Fazenda Novos Ares',800);

SELECT * FROM Sensor;

UPDATE Sensor SET Locais = 'Fazenda Grupo 8' WHERE idSensor = 3;

UPDATE Sensor SET concentracaoValor = 900 WHERE idSensor = 4;

DELETE FROM Sensor WHERE idSensor = 1;

ALTER TABLE Sensor MODIFY COLUMN identificarSensor VARCHAR(40);

SELECT CONCAT('SENSOR UTILIZADO: ',identificarSensor,' | CONCENTRAÇÃO DO VALOR NO LOCAL: ',concentracaoValor,' | DATA E HORA DA LEITURA: ',dataHoraLeitura,' | STATUS VAZAMENTO: ',
CASE
	WHEN concentracaoValor <= 200 THEN 'Normal - Ar limpo'
    WHEN concentracaoValor <= 600 THEN 'Alerta - Ligar exaustores'
    ELSE 'Evacuação - Nível tóxico'
END) AS 'STATUS DA OPERAÇÃO'
FROM Sensor;


-- -------------------------------------------------------------------------------------

CREATE TABLE Incidente (
idIncidente INT PRIMARY KEY AUTO_INCREMENT,
Sensor INT NOT NULL,
responsavelLocal INT,
nivelDePerigo VARCHAR(20) NOT NULL,
acaoTomada VARCHAR(150),
dataAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
dataResolucao DATETIME,
statusIncidente VARCHAR(20) DEFAULT 'Aberto',
    
CONSTRAINT chkStatusIncidente CHECK (statusIncidente IN ('Aberto', 'Em Atendimento', 'Resolvido')),
CONSTRAINT chkNivelDePerigo CHECK (nivelDePerigo IN ('Atenção', 'Perigo', 'Risco de Morte'))
);
INSERT INTO Incidente (Sensor, responsavelLocal, nivelDePerigo, acaoTomada, dataResolucao, statusIncidente) VALUES 
(2, 1, 'Perigo', 'Ventilação ativada manualmente e local evacuado', '2026-09-04 10:30:00', 'Resolvido'),
(3, NULL, 'Atenção', NULL, NULL, 'Aberto'),
(4, 2, 'Risco de Morte', 'Isolamento da área e acionamento dos bombeiros', NULL, 'Em Atendimento'),
(2, NULL, 'Atenção', NULL, NULL, 'Aberto');

SELECT * FROM Incidente;

UPDATE Incidente SET responsavelLocal = 3, statusIncidente = 'Em Atendimento' WHERE idIncidente = 2;

UPDATE Incidente SET statusIncidente = 'Resolvido', acaoTomada = 'Vazamento contido na válvula principal, bombeiros liberaram a área', dataResolucao = NOW() WHERE idIncidente = 3;

ALTER TABLE Incidente MODIFY COLUMN acaoTomada VARCHAR(255);

ALTER TABLE Incidente ADD COLUMN tempoResposta INT;
ALTER TABLE Incidente DROP COLUMN tempoResposta;

DELETE FROM Incidente WHERE idIncidente = 4;

SELECT 
    CONCAT('Alerta no Sensor ID: ',
            Sensor,
            ' | Nível: ',
            nivelDePerigo,
            ' | Técnico: ',
            IFNULL(responsavelLocal, '(Aguardando)'),
            ' | Ação: ',
            IFNULL(acaoTomada, '(Nenhuma ação registrada)'),
            ' | Status da Ocorrência: ',
            CASE
                WHEN statusIncidente = 'Aberto' THEN 'REQUER ATENÇÃO IMEDIATA'
                WHEN statusIncidente = 'Em Atendimento' THEN 'EQUIPE NO LOCAL'
                ELSE 'PROBLEMA RESOLVIDO'
            END) AS 'Painel de Monitoramento'
FROM
    Incidente;

SELECT idIncidente, nivelDePerigo, 
    DATE_FORMAT(dataAlerta, '%d/%m/%Y %H:%i') AS 'Data do Alerta',
    TIMESTAMPDIFF(HOUR, dataAlerta, NOW()) AS 'Horas desde o disparo'
FROM Incidente
WHERE statusIncidente != 'Resolvido';

-- ---------------------------------------------------------------------------------

CREATE TABLE empresas (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
cnpj CHAR(14) UNIQUE NOT NULL,
data_cadastro DATE DEFAULT (CURDATE()),
status_contrato VARCHAR(10) NOT NULL,
CONSTRAINT checkContrato CHECK(status_contrato IN('Ativo','Cancelado')),
data_pagamento DATETIME,
status_pagamento TINYINT NOT NULL,
CONSTRAINT checkPagamento CHECK(status_pagamento IN(0, 1))
);

INSERT INTO empresas (nome, cnpj, status_contrato, data_pagamento, status_pagamento) VALUES 
('Frigorífico Boi Gordo S.A.', '12345678000199', 'Ativo', '2026-09-05', 1),
('Carnes Premium Exportação Ltda', '98765432000188', 'Ativo', NULL, 0), 
('Abatedouro Vale do Sol', '11122233000177', 'Cancelado', '2025-12-10', 1);

SELECT * FROM empresas;

UPDATE empresas SET status_pagamento = 1, data_pagamento = CURDATE() WHERE idEmpresa = 2;

ALTER TABLE empresas ADD COLUMN emailFinanceiro VARCHAR(100);
ALTER TABLE empresas DROP COLUMN emailFinanceiro;

DELETE FROM empresas WHERE idEmpresa = 3;

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
FROM empresas;