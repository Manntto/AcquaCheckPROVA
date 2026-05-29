-- =============================================================
-- AcquaCheck — Operações CRUD
-- =============================================================

-- -------------------------------------------------------------
-- USERS
-- -------------------------------------------------------------
-- Create
INSERT INTO users (name, email, password, role)
VALUES ('Novo Inspetor', 'novo@acquacheck.com', '$2b$10$hash_aqui', 'inspector');

-- Read
SELECT id, name, email, role FROM users;
SELECT id, name, email, role FROM users WHERE id = 1;

-- Update
UPDATE users SET name = 'Nome Atualizado' WHERE id = 1;

-- Delete
DELETE FROM users WHERE id = 1;

-- -------------------------------------------------------------
-- ATTRACTIONS
-- -------------------------------------------------------------
-- Create
INSERT INTO attractions (name, active) VALUES ('Nova Atração', TRUE);

-- Read
SELECT * FROM attractions;
SELECT * FROM attractions WHERE active = TRUE;

-- Update
UPDATE attractions SET active = FALSE WHERE id = 1;

-- Delete
DELETE FROM attractions WHERE id = 1;

-- -------------------------------------------------------------
-- QUESTIONS
-- -------------------------------------------------------------
-- Create
INSERT INTO questions (attraction_id, question)
VALUES (1, 'O equipamento de segurança está disponível?');

-- Read
SELECT * FROM questions WHERE attraction_id = 1;

-- Update
UPDATE questions SET question = 'Pergunta atualizada?' WHERE id = 1;

-- Delete
DELETE FROM questions WHERE id = 1;

-- -------------------------------------------------------------
-- CHECKLISTS
-- -------------------------------------------------------------
-- Create
INSERT INTO checklists (user_id, attraction_id, date_time, notes)
VALUES (2, 1, NOW(), 'Observação opcional');

-- Read
SELECT * FROM checklists WHERE user_id = 2 ORDER BY date_time DESC;
SELECT * FROM checklists WHERE attraction_id = 1;

-- Update
UPDATE checklists SET notes = 'Observação atualizada' WHERE id = 1;

-- Delete
DELETE FROM checklists WHERE id = 1;

-- -------------------------------------------------------------
-- CHECKLIST_ITEMS
-- -------------------------------------------------------------
-- Create
INSERT INTO checklist_items (checklist_id, question_id, compliant)
VALUES (1, 1, TRUE);

-- Read
SELECT * FROM checklist_items WHERE checklist_id = 1;

-- Update
UPDATE checklist_items SET compliant = FALSE WHERE id = 1;

-- Delete
DELETE FROM checklist_items WHERE checklist_id = 1;
