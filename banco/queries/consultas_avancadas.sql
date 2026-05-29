-- =============================================================
-- AcquaCheck — Consultas Críticas do Sistema
-- =============================================================

-- -------------------------------------------------------------
-- CONSULTA 1: Resultado completo de um checklist
--
-- Por que é importante:
--   É a consulta principal do sistema. Quando um inspetor abre
--   um checklist, o app precisa exibir cada pergunta com sua
--   resposta (conforme/não conforme). Usa JOIN entre 4 tabelas.
--
-- Otimização:
--   Usa idx_items_checklist (checklist_id) para filtrar os itens
--   sem varredura completa da tabela.
-- -------------------------------------------------------------
SELECT
    q.question,
    ci.compliant,
    c.date_time,
    u.name  AS inspector,
    a.name  AS attraction
FROM checklist_items ci
JOIN checklists c  ON c.id  = ci.checklist_id
JOIN questions  q  ON q.id  = ci.question_id
JOIN users      u  ON u.id  = c.user_id
JOIN attractions a ON a.id  = c.attraction_id
WHERE ci.checklist_id = 1
ORDER BY q.id;


-- -------------------------------------------------------------
-- CONSULTA 2: Histórico de inspeções por atração (com período)
--
-- Por que é importante:
--   Permite ao gestor ver todas as inspeções de uma atração
--   em um intervalo de datas — base para relatórios gerenciais.
--
-- Otimização:
--   Usa idx_checklists_attraction + idx_checklists_date,
--   evitando full scan na tabela checklists.
-- -------------------------------------------------------------
SELECT
    c.id,
    c.date_time,
    u.name  AS inspector,
    c.notes,
    COUNT(ci.id)                                        AS total_items,
    SUM(CASE WHEN ci.compliant THEN 1 ELSE 0 END)       AS conformes,
    SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END)   AS nao_conformes
FROM checklists c
JOIN users            u  ON u.id  = c.user_id
JOIN checklist_items  ci ON ci.checklist_id = c.id
WHERE c.attraction_id = 1
  AND c.date_time BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY c.id, u.name
ORDER BY c.date_time DESC;


-- -------------------------------------------------------------
-- CONSULTA 3: Ranking de não conformidades por atração
--
-- Por que é importante:
--   Identifica quais atrações acumulam mais problemas,
--   permitindo priorizar manutenção. Consulta de agregação
--   com GROUP BY e ORDER BY em múltiplas tabelas.
--
-- Otimização:
--   Usa idx_checklists_attraction para agrupar eficientemente.
-- -------------------------------------------------------------
SELECT
    a.name                                              AS attraction,
    COUNT(ci.id)                                        AS total_inspecoes,
    SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END)   AS total_nao_conformes,
    ROUND(
        100.0 * SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END)
        / NULLIF(COUNT(ci.id), 0), 2
    )                                                   AS pct_nao_conformes
FROM attractions a
JOIN checklists      c  ON c.attraction_id = a.id
JOIN checklist_items ci ON ci.checklist_id = c.id
GROUP BY a.id, a.name
ORDER BY total_nao_conformes DESC;


-- -------------------------------------------------------------
-- CONSULTA 4: Perguntas com maior índice de não conformidade
--
-- Por que é importante:
--   Mostra quais itens específicos falham com mais frequência,
--   orientando revisão de procedimentos ou manutenção preventiva.
--   Usa agregação com HAVING para filtrar apenas problemas relevantes.
-- -------------------------------------------------------------
SELECT
    a.name                                              AS attraction,
    q.question,
    COUNT(ci.id)                                        AS vezes_inspecionado,
    SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END)   AS vezes_nao_conforme,
    ROUND(
        100.0 * SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END)
        / NULLIF(COUNT(ci.id), 0), 2
    )                                                   AS pct_falha
FROM questions q
JOIN attractions     a  ON a.id  = q.attraction_id
JOIN checklist_items ci ON ci.question_id = q.id
GROUP BY q.id, q.question, a.name
HAVING SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END) > 0
ORDER BY pct_falha DESC;


-- -------------------------------------------------------------
-- CONSULTA 5: Produtividade dos inspetores no mês
--
-- Por que é importante:
--   Permite ao administrador acompanhar quantas inspeções cada
--   inspetor realizou no mês corrente, com total de itens avaliados.
--   Usa DATE_TRUNC para agrupamento por mês.
--
-- Otimização:
--   Usa idx_checklists_user + idx_checklists_date.
-- -------------------------------------------------------------
SELECT
    u.name                  AS inspector,
    COUNT(DISTINCT c.id)    AS checklists_realizados,
    COUNT(ci.id)            AS itens_avaliados,
    SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END) AS nao_conformes_encontrados
FROM users u
JOIN checklists      c  ON c.user_id = u.id
JOIN checklist_items ci ON ci.checklist_id = c.id
WHERE u.role = 'inspector'
  AND DATE_TRUNC('month', c.date_time) = DATE_TRUNC('month', NOW())
GROUP BY u.id, u.name
ORDER BY checklists_realizados DESC;
