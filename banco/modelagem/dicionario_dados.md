# Dicionário de Dados — AcquaCheck

## Tabela: `users`

Armazena os usuários do sistema (administradores e inspetores).

| Coluna     | Tipo          | Nulo | Único | Padrão | Descrição                                      |
|------------|---------------|------|-------|--------|------------------------------------------------|
| `id`       | SERIAL        | NÃO  | SIM   | auto   | Identificador único do usuário (PK)            |
| `name`     | VARCHAR(100)  | NÃO  | NÃO   | —      | Nome completo do usuário                       |
| `email`    | VARCHAR(100)  | NÃO  | SIM   | —      | E-mail de acesso (usado no login)              |
| `password` | VARCHAR(250)  | NÃO  | NÃO   | —      | Senha armazenada como hash bcrypt              |
| `role`     | VARCHAR(20)   | NÃO  | NÃO   | —      | Perfil de acesso: `admin` ou `inspector`       |

**Constraints:** `CHECK (role IN ('admin', 'inspector'))`

---

## Tabela: `attractions`

Representa as atrações aquáticas disponíveis no parque.

| Coluna   | Tipo         | Nulo | Único | Padrão | Descrição                                      |
|----------|--------------|------|-------|--------|------------------------------------------------|
| `id`     | SERIAL       | NÃO  | SIM   | auto   | Identificador único da atração (PK)            |
| `name`   | VARCHAR(100) | NÃO  | NÃO   | —      | Nome da atração                                |
| `active` | BOOLEAN      | NÃO  | NÃO   | TRUE   | Indica se a atração está em operação           |

---

## Tabela: `questions`

Perguntas de inspeção associadas a uma atração específica.

| Coluna          | Tipo         | Nulo | Único | Padrão | Descrição                                      |
|-----------------|--------------|------|-------|--------|------------------------------------------------|
| `id`            | SERIAL       | NÃO  | SIM   | auto   | Identificador único da pergunta (PK)           |
| `attraction_id` | INTEGER      | NÃO  | NÃO   | —      | FK para `attractions.id`                       |
| `question`      | VARCHAR(255) | NÃO  | NÃO   | —      | Texto da pergunta de inspeção                  |

**Chaves Estrangeiras:**
- `attraction_id` → `attractions(id)` — `ON DELETE CASCADE` (ao excluir atração, remove suas perguntas)

---

## Tabela: `checklists`

Registro de uma inspeção realizada por um usuário em uma atração em determinado momento.

| Coluna          | Tipo        | Nulo | Único | Padrão | Descrição                                      |
|-----------------|-------------|------|-------|--------|------------------------------------------------|
| `id`            | SERIAL      | NÃO  | SIM   | auto   | Identificador único do checklist (PK)          |
| `user_id`       | INTEGER     | NÃO  | NÃO   | —      | FK para `users.id` (inspetor responsável)      |
| `attraction_id` | INTEGER     | NÃO  | NÃO   | —      | FK para `attractions.id`                       |
| `date_time`     | TIMESTAMPTZ | NÃO  | NÃO   | NOW()  | Data e hora da inspeção (com fuso horário)     |
| `notes`         | TEXT        | SIM  | NÃO   | NULL   | Observações livres do inspetor                 |

**Chaves Estrangeiras:**
- `user_id` → `users(id)` — `ON DELETE RESTRICT`
- `attraction_id` → `attractions(id)` — `ON DELETE RESTRICT`

---

## Tabela: `checklist_items`

Resposta de cada pergunta dentro de um checklist. Representa o resultado individual de cada item inspecionado.

| Coluna         | Tipo    | Nulo | Único | Padrão | Descrição                                      |
|----------------|---------|------|-------|--------|------------------------------------------------|
| `id`           | SERIAL  | NÃO  | SIM   | auto   | Identificador único do item (PK)               |
| `checklist_id` | INTEGER | NÃO  | NÃO   | —      | FK para `checklists.id`                        |
| `question_id`  | INTEGER | NÃO  | NÃO   | —      | FK para `questions.id`                         |
| `compliant`    | BOOLEAN | NÃO  | NÃO   | —      | `TRUE` = conforme, `FALSE` = não conforme      |

**Chaves Estrangeiras:**
- `checklist_id` → `checklists(id)` — `ON DELETE CASCADE`
- `question_id` → `questions(id)` — `ON DELETE RESTRICT`

**Constraints:** `UNIQUE (checklist_id, question_id)` — impede resposta duplicada para a mesma pergunta no mesmo checklist.

---

## Índices

| Nome                       | Tabela            | Campo(s)         | Tipo   | Motivo                                          |
|----------------------------|-------------------|------------------|--------|-------------------------------------------------|
| `idx_users_email`          | `users`           | `email`          | B-Tree | Busca rápida no login                           |
| `idx_questions_attraction` | `questions`       | `attraction_id`  | B-Tree | Listar perguntas de uma atração                 |
| `idx_checklists_user`      | `checklists`      | `user_id`        | B-Tree | Histórico de inspeções por inspetor             |
| `idx_checklists_attraction`| `checklists`      | `attraction_id`  | B-Tree | Histórico de inspeções por atração              |
| `idx_checklists_date`      | `checklists`      | `date_time`      | B-Tree | Filtros por período (relatórios)                |
| `idx_items_checklist`      | `checklist_items` | `checklist_id`   | B-Tree | Carregamento dos itens de um checklist          |
