
-- ==========================================
-- BANCO DE DADOS: CLÍNICA MÉDICA
-- ==========================================

CREATE DATABASE IF NOT EXISTS clinica_medica;
USE clinica_medica;

-- ==========================================
-- 1. TABELA PACIENTE
-- ==========================================

CREATE TABLE paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE,
    telefone VARCHAR(20),
    endereco VARCHAR(150)
);

-- ==========================================
-- 2. TABELA MÉDICO
-- ==========================================

CREATE TABLE medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(100),
    telefone VARCHAR(20)
);

-- ==========================================
-- 3. TABELA CONSULTA
-- ==========================================

CREATE TABLE consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    data_consulta DATETIME NOT NULL,
    motivo VARCHAR(200),
    status VARCHAR(20) NOT NULL DEFAULT 'Agendada',

    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,

    FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente),

    FOREIGN KEY (id_medico)
        REFERENCES medico(id_medico)
);

-- ==========================================
-- 4. TABELA EXAME
-- ==========================================

CREATE TABLE exame (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(200),
    valor DECIMAL(10,2)
);

-- ==========================================
-- 5. TABELA EXAME_SOLICITADO
-- ==========================================

CREATE TABLE exame_solicitado (
    id_solicitacao INT AUTO_INCREMENT PRIMARY KEY,
    data_solicitacao DATE NOT NULL,
    resultado TEXT,

    id_consulta INT NOT NULL,
    id_exame INT NOT NULL,

    FOREIGN KEY (id_consulta)
        REFERENCES consulta(id_consulta),

    FOREIGN KEY (id_exame)
        REFERENCES exame(id_exame)
);

-- ==========================================
-- DADOS DE EXEMPLO
-- ==========================================

INSERT INTO paciente
(nome, cpf, data_nascimento, telefone, endereco)
VALUES
('Ruan Flambory', '123.456.789-00', '2004-05-10',
 '67999999999', 'Rua A, 100'),
('Wesley Silva', '987.654.321-00', '2003-08-15',
 '67988888888', 'Rua B, 200');

INSERT INTO medico
(nome, crm, especialidade, telefone)
VALUES
('Dr. Carlos Pereira', 'CRM12345',
 'Clínico Geral', '67977777777'),
('Dra. Ana Souza', 'CRM67890',
 'Cardiologia', '67966666666');

INSERT INTO consulta
(data_consulta, motivo, status, id_paciente, id_medico)
VALUES
('2026-09-10 08:30:00',
 'Dor de cabeça', 'Agendada', 1, 1),
('2026-09-11 14:00:00',
 'Consulta cardiológica', 'Agendada', 2, 2);

INSERT INTO exame
(nome, descricao, valor)
VALUES
('Hemograma', 'Exame de sangue completo', 60.00),
('Glicemia', 'Exame para medir a glicose', 35.00),
('Eletrocardiograma', 'Exame do coração', 120.00);

INSERT INTO exame_solicitado
(data_solicitacao, resultado, id_consulta, id_exame)
VALUES
('2026-09-10', 'Aguardando resultado', 1, 1),
('2026-09-11', 'Aguardando resultado', 2, 3);

-- ==========================================
-- CONSULTAS PARA TESTAR
-- ==========================================

-- Ver todos os pacientes
SELECT * FROM paciente;

-- Ver todos os médicos
SELECT * FROM medico;

-- Ver todas as consultas
SELECT * FROM consulta;

-- Ver consultas com nome do paciente e médico
SELECT
    c.id_consulta,
    p.nome AS paciente,
    m.nome AS medico,
    m.especialidade,
    c.data_consulta,
    c.motivo,
    c.status
FROM consulta c
JOIN paciente p
    ON c.id_paciente = p.id_paciente
JOIN medico m
    ON c.id_medico = m.id_medico;

-- Ver exames solicitados
SELECT
    es.id_solicitacao,
    p.nome AS paciente,
    m.nome AS medico,
    e.nome AS exame,
    es.data_solicitacao,
    es.resultado
FROM exame_solicitado es
JOIN consulta c
    ON es.id_consulta = c.id_consulta
JOIN paciente p
    ON c.id_paciente = p.id_paciente
JOIN medico m
    ON c.id_medico = m.id_medico
JOIN exame e
    ON es.id_exame = e.id_exame;

-- Atualizar status da consulta
UPDATE consulta
SET status = 'Realizada'
WHERE id_consulta = 1;

-- Atualizar resultado do exame
UPDATE exame_solicitado
SET resultado = 'Resultado normal'
WHERE id_solicitacao = 1;