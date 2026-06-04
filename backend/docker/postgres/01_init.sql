-- =============================================================
-- AcquaCheck — Inicialização do PostgreSQL
--
-- Este script é executado uma única vez pelo container do
-- PostgreSQL na primeira inicialização (docker-entrypoint-initdb.d).
--
-- A criação das tabelas e índices é responsabilidade das
-- migrations do Sequelize:
--   docker compose exec backend node command.js migrate
-- =============================================================

-- Habilita extensão de UUID (disponível por padrão no PostgreSQL 17)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
