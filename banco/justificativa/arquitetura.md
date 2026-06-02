# Justificativa de Arquitetura — AcquaCheck

## 1. Escolha Tecnológica

### Banco de Dados: PostgreSQL 17

**Por que SQL e não NoSQL?**

O sistema AcquaCheck gerencia inspeções de segurança em atrações aquáticas. Os dados possuem estrutura bem definida e relacionamentos claros entre entidades (usuário → checklist → itens → perguntas → atração). Esse cenário favorece um banco relacional, onde integridade referencial e consistência são garantidas pelo próprio banco via constraints e chaves estrangeiras.

**Por que PostgreSQL especificamente?**

- Suporte nativo a `TIMESTAMPTZ` (timestamp com fuso horário), essencial para registrar inspeções com precisão temporal.
- Suporte a `CHECK constraints`, `UNIQUE compostos` e `ON DELETE CASCADE/RESTRICT` sem configuração adicional.
- Amplamente utilizado em produção, com excelente suporte a Docker e ecossistema Node.js (driver `pg`).
- Gratuito e open source, adequado para o contexto acadêmico e de startup.

---

## 2. Requisitos do Sistema

| Item | Descrição |
|---|---|
| **Objetivo** | Registrar e acompanhar inspeções de segurança em atrações aquáticas |
| **Entidades principais** | Usuários, Atrações, Perguntas, Checklists, Itens de Checklist |
| **Volume estimado** | ~500 checklists/mês, ~15 itens por checklist = ~7.500 registros/mês em `checklist_items` |
| **Usuários estimados** | 5 a 20 inspetores simultâneos por parque |
| **Consultas principais** | Resultado de checklist, histórico por atração, ranking de não conformidades |

---

## 3. Normalização

### Primeira Forma Normal (1FN)

**Regra:** Cada coluna deve conter valores atômicos (indivisíveis) e não deve haver grupos repetidos.

**Aplicação no projeto:**
- Todas as colunas armazenam um único valor por célula. Não há arrays, listas ou campos compostos.
- A resposta de cada pergunta (`compliant`) é um valor booleano atômico em `checklist_items`, e não uma lista de respostas dentro de `checklists`.
- Cada linha é identificada unicamente pela chave primária `id`.

✅ **Todas as tabelas estão na 1FN.**

---

### Segunda Forma Normal (2FN)

**Regra:** Estar na 1FN e todos os atributos não-chave devem depender da chave primária inteira (sem dependências parciais — relevante em chaves compostas).

**Aplicação no projeto:**
- Nenhuma tabela usa chave primária composta. Todas usam `id SERIAL` como PK simples.
- Em `checklist_items`, a constraint `UNIQUE(checklist_id, question_id)` garante unicidade do par, mas a PK continua sendo `id`. O atributo `compliant` depende do par (checklist + pergunta), não de apenas um deles — o que seria uma dependência parcial se a PK fosse composta.

✅ **Todas as tabelas estão na 2FN.**

---

### Terceira Forma Normal (3FN)

**Regra:** Estar na 2FN e não haver dependências transitivas (atributo não-chave dependendo de outro atributo não-chave).

**Aplicação no projeto:**
- Em `checklists`: `date_time` e `notes` dependem diretamente de `id`. `user_id` e `attraction_id` são FKs, não atributos derivados.
- Em `checklist_items`: `compliant` depende diretamente do par (checklist + pergunta), sem transitividade.
- Dados do usuário (nome, e-mail) não são repetidos em `checklists` — são acessados via JOIN com `users`.
- Dados da atração (nome) não são repetidos em `questions` ou `checklists` — acessados via JOIN com `attractions`.

✅ **Todas as tabelas estão na 3FN.**

---

### Ausência de Desnormalização

Não foi aplicada desnormalização intencional. O volume de dados estimado não justifica redundância para ganho de performance — os índices B-Tree criados são suficientes para as consultas críticas identificadas.

---

## 4. Estratégia de Indexação

| Índice | Campo | Tipo | Motivo |
|---|---|---|---|
| `idx_users_email` | `users.email` | B-Tree | Login: busca por e-mail é a operação mais frequente |
| `idx_questions_attraction` | `questions.attraction_id` | B-Tree | Carregamento das perguntas ao abrir um checklist |
| `idx_checklists_user` | `checklists.user_id` | B-Tree | Histórico de inspeções por inspetor |
| `idx_checklists_attraction` | `checklists.attraction_id` | B-Tree | Histórico de inspeções por atração |
| `idx_checklists_date` | `checklists.date_time` | B-Tree | Filtros por período em relatórios |
| `idx_items_checklist` | `checklist_items.checklist_id` | B-Tree | Carregamento dos itens ao exibir resultado de checklist |

Todos os índices são do tipo **B-Tree**, adequado para buscas por igualdade e por intervalo (`BETWEEN`, `>`, `<`), que são os padrões de acesso do sistema.
