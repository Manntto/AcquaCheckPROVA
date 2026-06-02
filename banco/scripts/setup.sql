-- =============================================================
-- AcquaCheck — Script DDL Completo
-- Banco: PostgreSQL 17
-- =============================================================

-- Garante execução limpa em ambiente de desenvolvimento
DROP TABLE IF EXISTS checklist_items CASCADE;
DROP TABLE IF EXISTS checklists       CASCADE;
DROP TABLE IF EXISTS questions        CASCADE;
DROP TABLE IF EXISTS attractions      CASCADE;
DROP TABLE IF EXISTS users            CASCADE;

-- -------------------------------------------------------------
-- TABELA: users
-- Armazena os usuários do sistema (inspetores e administradores)
-- -------------------------------------------------------------
CREATE TABLE users (
    id       SERIAL        PRIMARY KEY,
    name     VARCHAR(100)  NOT NULL,
    email    VARCHAR(100)  NOT NULL UNIQUE,
    password VARCHAR(250)  NOT NULL,
    role     VARCHAR(20)   NOT NULL CHECK (role IN ('admin', 'inspector'))
);

-- -------------------------------------------------------------
-- TABELA: attractions
-- Representa as atrações aquáticas que serão inspecionadas
-- -------------------------------------------------------------
CREATE TABLE attractions (
    id     SERIAL       PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    active BOOLEAN      NOT NULL DEFAULT TRUE
);

-- -------------------------------------------------------------
-- TABELA: questions
-- Perguntas de inspeção vinculadas a uma atração específica
-- -------------------------------------------------------------
CREATE TABLE questions (
    id            SERIAL       PRIMARY KEY,
    attraction_id INTEGER      NOT NULL,
    question      VARCHAR(255) NOT NULL,
    CONSTRAINT fk_questions_attraction
        FOREIGN KEY (attraction_id) REFERENCES attractions(id)
        ON DELETE CASCADE
);

-- -------------------------------------------------------------
-- TABELA: checklists
-- Registro de uma inspeção realizada por um usuário em uma atração
-- -------------------------------------------------------------
CREATE TABLE checklists (
    id            SERIAL      PRIMARY KEY,
    user_id       INTEGER     NOT NULL,
    attraction_id INTEGER     NOT NULL,
    date_time     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes         TEXT,
    CONSTRAINT fk_checklists_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_checklists_attraction
        FOREIGN KEY (attraction_id) REFERENCES attractions(id)
        ON DELETE RESTRICT
);

-- -------------------------------------------------------------
-- TABELA: checklist_items
-- Resposta de cada pergunta dentro de um checklist
-- -------------------------------------------------------------
CREATE TABLE checklist_items (
    id           SERIAL  PRIMARY KEY,
    checklist_id INTEGER NOT NULL,
    question_id  INTEGER NOT NULL,
    compliant    BOOLEAN NOT NULL,
    CONSTRAINT fk_items_checklist
        FOREIGN KEY (checklist_id) REFERENCES checklists(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_items_question
        FOREIGN KEY (question_id) REFERENCES questions(id)
        ON DELETE RESTRICT,
    CONSTRAINT uq_item_per_checklist
        UNIQUE (checklist_id, question_id)
);

-- =============================================================
-- ÍNDICES
-- =============================================================

-- Busca de usuário por e-mail (login)
CREATE INDEX idx_users_email ON users(email);

-- Listagem de perguntas por atração
CREATE INDEX idx_questions_attraction ON questions(attraction_id);

-- Checklists por usuário (histórico do inspetor)
CREATE INDEX idx_checklists_user ON checklists(user_id);

-- Checklists por atração (histórico da atração)
CREATE INDEX idx_checklists_attraction ON checklists(attraction_id);

-- Checklists por data (filtros de período)
CREATE INDEX idx_checklists_date ON checklists(date_time);

-- Itens por checklist (carregamento dos resultados)
CREATE INDEX idx_items_checklist ON checklist_items(checklist_id);
