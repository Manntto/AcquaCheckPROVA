-- =============================================================
-- AcquaCheck — Consultas de Agregação
-- =============================================================

-- -------------------------------------------------------------
-- 1. Total de checklists por atração
-- -------------------------------------------------------------
SELECT
    a.name          AS atracao,
    COUNT(c.id)     AS total_checklists
FROM attractions a
LEFT JOIN checklists c ON c.attraction_id = a.id
GROUP BY a.id, a.name
ORDER BY total_checklists DESC;


-- -------------------------------------------------------------
-- 2. Taxa de conformidade geral por atração (%)
-- -------------------------------------------------------------
SELECT
    a.name                                                          AS atracao,
    COUNT(ci.id)                                                    AS total_itens,
    ROUND(100.0 * SUM(CASE WHEN ci.compliant THEN 1 ELSE 0 END)
        / NULLIF(COUNT(ci.id), 0), 2)                              AS pct_conforme
FROM attractions a
JOIN checklists      c  ON c.attraction_id = a.id
JOIN checklist_items ci ON ci.checklist_id = c.id
GROUP BY a.id, a.name
ORDER BY pct_conforme ASC;


-- -------------------------------------------------------------
-- 3. Quantidade de inspeções por mês
-- -------------------------------------------------------------
SELECT
    TO_CHAR(date_time, 'YYYY-MM') AS mes,
    COUNT(*)                       AS total_checklists
FROM checklists
GROUP BY mes
ORDER BY mes;


-- -------------------------------------------------------------
-- 4. Inspetores com mais não conformidades encontradas
-- -------------------------------------------------------------
SELECT
    u.name                                                          AS inspetor,
    SUM(CASE WHEN NOT ci.compliant THEN 1 ELSE 0 END)              AS nao_conformes
FROM users u
JOIN checklists      c  ON c.user_id = u.id
JOIN checklist_items ci ON ci.checklist_id = c.id
WHERE u.role = 'inspector'
GROUP BY u.id, u.name
ORDER BY nao_conformes DESC;


-- -------------------------------------------------------------
-- 5. Média de itens não conformes por checklist, por atração
-- -------------------------------------------------------------
SELECT
    a.name                                                          AS atracao,
    ROUND(AVG(nao_conf.total), 2)                                  AS media_nao_conformes_por_checklist
FROM attractions a
JOIN checklists c ON c.attraction_id = a.id
JOIN (
    SELECT checklist_id,
           SUM(CASE WHEN NOT compliant THEN 1 ELSE 0 END) AS total
    FROM checklist_items
    GROUP BY checklist_id
) nao_conf ON nao_conf.checklist_id = c.id
GROUP BY a.id, a.name
ORDER BY media_nao_conformes_por_checklist DESC;
