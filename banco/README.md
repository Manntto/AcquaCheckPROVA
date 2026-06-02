# AcquaCheck — Banco de Dados

Sistema de inspeção de segurança para atrações aquáticas.

## Tecnologia

- **PostgreSQL 17** via Docker
- **ORM:** Sequelize 6 (Node.js)

## Estrutura do Repositório

```
banco/
├── modelagem/
│   ├── dicionario_dados.md     # Descrição de todas as tabelas e campos
│   ├── der.png                 # Diagrama Entidade-Relacionamento (Conceitual)
│   └── modelo_logico.png       # Diagrama Lógico
├── scripts/
│   ├── setup.sql               # DDL: criação de tabelas, constraints e índices
│   └── seed/
│       └── seed.sql            # Dados de teste (122 registros)
├── queries/
│   └── consultas_avancadas.sql # 5 consultas críticas documentadas
└── justificativa/
    └── arquitetura.md          # Escolha tecnológica, normalização e indexação
```

## Como executar

### 1. Subir o banco via Docker

```bash
docker-compose up -d
```

### 2. Criar as tabelas

```bash
docker exec -i db_acquacheck_container psql -U $POSTGRES_USER -d $POSTGRES_DB < banco/scripts/setup.sql
```

### 3. Carregar os dados de teste

```bash
docker exec -i db_acquacheck_container psql -U $POSTGRES_USER -d $POSTGRES_DB < banco/scripts/seed/seed.sql
```

## Modelo de Dados

### Entidades

| Tabela            | Descrição                                              |
|-------------------|--------------------------------------------------------|
| `users`           | Usuários do sistema (admin e inspetores)               |
| `attractions`     | Atrações aquáticas do parque                           |
| `questions`       | Perguntas de inspeção por atração                      |
| `checklists`      | Registro de uma inspeção (usuário + atração + data)    |
| `checklist_items` | Resposta de cada pergunta em um checklist              |

### Relacionamentos

```
users         1 ──< checklists
attractions   1 ──< checklists
attractions   1 ──< questions
checklists    1 ──< checklist_items
questions     1 ──< checklist_items
```

## Dados de Teste

O seed inclui:
- 10 usuários (1 admin + 9 inspetores)
- 8 atrações
- 24 perguntas (3 por atração)
- 23 checklists (20 históricos + 3 do mês atual)
- 69 itens de checklist

**Total: 134 registros**

## Documentação Completa

- [Dicionário de Dados](modelagem/dicionario_dados.md)
- [Justificativa de Arquitetura e Normalização](justificativa/arquitetura.md)
- [Consultas Críticas](queries/consultas_avancadas.sql)
