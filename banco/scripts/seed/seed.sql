-- =============================================================
-- AcquaCheck — Seed de Dados para Teste
-- Mínimo de 100 registros distribuídos entre as tabelas
-- =============================================================

-- -------------------------------------------------------------
-- USERS (10 registros)
-- Senhas são hash bcrypt de "Senha@123"
-- -------------------------------------------------------------
INSERT INTO users (name, email, password, role) VALUES
('Maximus Ponciano',   'admin@acquacheck.com',    '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'admin'),
('Carlos Mendes',      'carlos@acquacheck.com',   '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Fernanda Lima',      'fernanda@acquacheck.com', '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Rafael Souza',       'rafael@acquacheck.com',   '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Juliana Costa',      'juliana@acquacheck.com',  '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Bruno Alves',        'bruno@acquacheck.com',    '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Patrícia Rocha',     'patricia@acquacheck.com', '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Diego Ferreira',     'diego@acquacheck.com',    '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Aline Martins',      'aline@acquacheck.com',    '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'inspector'),
('Thiago Barbosa',     'thiago@acquacheck.com',   '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'admin');

-- -------------------------------------------------------------
-- ATTRACTIONS (8 registros)
-- -------------------------------------------------------------
INSERT INTO attractions (name, active) VALUES
('Toboágua Radical',      TRUE),
('Piscina de Ondas',       TRUE),
('Rio Lento',              TRUE),
('Piscina Infantil',       TRUE),
('Toboágua Familiar',      TRUE),
('Área de Mergulho',       TRUE),
('Piscina Olímpica',       FALSE),
('Toboágua Fechado',       TRUE);

-- -------------------------------------------------------------
-- QUESTIONS (24 registros — 3 por atração)
-- -------------------------------------------------------------
INSERT INTO questions (attraction_id, question) VALUES
-- Toboágua Radical (1)
(1, 'Os corrimãos estão fixos e sem ferrugem?'),
(1, 'A superfície do toboágua está sem rachaduras?'),
(1, 'O fluxo de água está adequado para operação?'),
-- Piscina de Ondas (2)
(2, 'O sistema de ondas foi testado antes da abertura?'),
(2, 'A sinalização de profundidade está visível?'),
(2, 'Os salva-vidas estão posicionados corretamente?'),
-- Rio Lento (3)
(3, 'As boias estão em bom estado de conservação?'),
(3, 'O fluxo da corrente está dentro do limite seguro?'),
(3, 'Não há objetos cortantes no percurso?'),
-- Piscina Infantil (4)
(4, 'A profundidade máxima está sinalizada?'),
(4, 'O piso antiderrapante está em bom estado?'),
(4, 'A temperatura da água está adequada?'),
-- Toboágua Familiar (5)
(5, 'A capacidade máxima por boia está sinalizada?'),
(5, 'Os degraus de acesso estão seguros?'),
(5, 'O colchão de chegada está com nível de água correto?'),
-- Área de Mergulho (6)
(6, 'A profundidade mínima para mergulho está sinalizada?'),
(6, 'Não há obstáculos submersos na área de mergulho?'),
(6, 'O equipamento de resgate está acessível?'),
-- Piscina Olímpica (7)
(7, 'As raias estão devidamente demarcadas?'),
(7, 'O sistema de filtragem está operacional?'),
(7, 'Os blocos de partida estão fixos?'),
-- Toboágua Fechado (8)
(8, 'A iluminação interna está funcionando?'),
(8, 'Não há obstruções no interior do toboágua?'),
(8, 'O sistema de frenagem na saída está operacional?');

-- -------------------------------------------------------------
-- CHECKLISTS (20 registros)
-- -------------------------------------------------------------
INSERT INTO checklists (user_id, attraction_id, date_time, notes) VALUES
(2, 1, '2025-01-10 08:00:00-03', NULL),
(3, 2, '2025-01-10 08:15:00-03', 'Sinalização desgastada, solicitar troca'),
(4, 3, '2025-01-10 08:30:00-03', NULL),
(5, 4, '2025-01-10 08:45:00-03', NULL),
(6, 5, '2025-01-10 09:00:00-03', NULL),
(7, 6, '2025-01-10 09:15:00-03', 'Equipamento de resgate reposicionado'),
(8, 8, '2025-01-10 09:30:00-03', NULL),
(2, 1, '2025-02-14 08:00:00-03', NULL),
(3, 2, '2025-02-14 08:15:00-03', NULL),
(4, 3, '2025-02-14 08:30:00-03', 'Boia nº 7 com furo, retirada de operação'),
(5, 4, '2025-02-14 08:45:00-03', NULL),
(6, 5, '2025-02-14 09:00:00-03', NULL),
(9, 6, '2025-02-14 09:15:00-03', NULL),
(2, 8, '2025-02-14 09:30:00-03', NULL),
(3, 1, '2025-03-20 08:00:00-03', NULL),
(4, 2, '2025-03-20 08:15:00-03', NULL),
(5, 3, '2025-03-20 08:30:00-03', NULL),
(6, 4, '2025-03-20 08:45:00-03', 'Temperatura da água abaixo do ideal, ajustada'),
(7, 5, '2025-03-20 09:00:00-03', NULL),
(8, 6, '2025-03-20 09:15:00-03', NULL);

-- -------------------------------------------------------------
-- CHECKLIST_ITEMS (60 registros — 3 itens por checklist)
-- Cada checklist responde as 3 perguntas da sua atração
-- -------------------------------------------------------------
INSERT INTO checklist_items (checklist_id, question_id, compliant) VALUES
-- Checklist 1 (atração 1, perguntas 1-3)
(1,  1, TRUE),  (1,  2, TRUE),  (1,  3, TRUE),
-- Checklist 2 (atração 2, perguntas 4-6)
(2,  4, TRUE),  (2,  5, FALSE), (2,  6, TRUE),
-- Checklist 3 (atração 3, perguntas 7-9)
(3,  7, TRUE),  (3,  8, TRUE),  (3,  9, TRUE),
-- Checklist 4 (atração 4, perguntas 10-12)
(4, 10, TRUE),  (4, 11, TRUE),  (4, 12, TRUE),
-- Checklist 5 (atração 5, perguntas 13-15)
(5, 13, TRUE),  (5, 14, TRUE),  (5, 15, TRUE),
-- Checklist 6 (atração 6, perguntas 16-18)
(6, 16, TRUE),  (6, 17, TRUE),  (6, 18, FALSE),
-- Checklist 7 (atração 8, perguntas 22-24)
(7, 22, TRUE),  (7, 23, TRUE),  (7, 24, TRUE),
-- Checklist 8 (atração 1, perguntas 1-3)
(8,  1, TRUE),  (8,  2, FALSE), (8,  3, TRUE),
-- Checklist 9 (atração 2, perguntas 4-6)
(9,  4, TRUE),  (9,  5, TRUE),  (9,  6, TRUE),
-- Checklist 10 (atração 3, perguntas 7-9)
(10, 7, FALSE), (10, 8, TRUE),  (10, 9, TRUE),
-- Checklist 11 (atração 4, perguntas 10-12)
(11,10, TRUE),  (11,11, TRUE),  (11,12, FALSE),
-- Checklist 12 (atração 5, perguntas 13-15)
(12,13, TRUE),  (12,14, FALSE), (12,15, TRUE),
-- Checklist 13 (atração 6, perguntas 16-18)
(13,16, TRUE),  (13,17, TRUE),  (13,18, TRUE),
-- Checklist 14 (atração 8, perguntas 22-24)
(14,22, FALSE), (14,23, TRUE),  (14,24, TRUE),
-- Checklist 15 (atração 1, perguntas 1-3)
(15, 1, TRUE),  (15, 2, TRUE),  (15, 3, FALSE),
-- Checklist 16 (atração 2, perguntas 4-6)
(16, 4, TRUE),  (16, 5, TRUE),  (16, 6, TRUE),
-- Checklist 17 (atração 3, perguntas 7-9)
(17, 7, TRUE),  (17, 8, TRUE),  (17, 9, TRUE),
-- Checklist 18 (atração 4, perguntas 10-12)
(18,10, TRUE),  (18,11, TRUE),  (18,12, TRUE),
-- Checklist 19 (atração 5, perguntas 13-15)
(19,13, TRUE),  (19,14, TRUE),  (19,15, TRUE),
-- Checklist 20 (atração 6, perguntas 16-18)
(20,16, TRUE),  (20,17, FALSE), (20,18, TRUE);
