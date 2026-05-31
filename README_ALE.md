# AcquaCheck — Infraestrutura de Sistemas Web

## 1. Identificação do Projeto

**Sistema:** AcquaCheck  
**Descrição:** API REST para inspeção de atrações aquáticas. Inspetores realizam checklists de conformidade respondendo perguntas específicas de cada atração (toboáguas, piscinas, etc.).  
**Caminho Escolhido:** Opção A — Docker / Orquestração Local (Custom Bridge Network + Compose)

---

## 2. Pré-requisitos

Ferramentas necessárias no ambiente (WSL2 ou Linux):

- Docker Engine 24+ ou Docker Desktop com WSL2 backend
- Docker Compose Plugin (`docker compose` — sem hífen)
- Git

Verificar instalação:

```bash
docker --version
docker compose version
```

---

## 3. Guia de Instalação e Execução

```bash
# 1. Clone o repositório
git clone <url-do-repo>
cd AcquaCheckPROVA

# 2. Configure as variáveis de ambiente
cp backend/.env.example backend/.env
# Edite backend/.env com suas credenciais (veja seção 5)

# 3. Suba toda a infraestrutura (build + start)
docker compose up --build -d

# 4. Execute as migrations (cria as tabelas no banco)
docker compose exec backend node command.js migrate

# 5. Acesse a API
curl http://localhost/users
# Swagger: http://localhost/api-docs
```

---

## 4. Detalhamento Técnico da Infraestrutura

### 4.1 Otimização de Imagens (Multi-stage Build)

O `Dockerfile` usa dois estágios separados:

```
Stage 1 — deps (node:24-alpine)
  └── Instala APENAS dependências de produção (npm ci --omit=dev)
      Camadas menos mutáveis primeiro → cache reutilizado em rebuilds

Stage 2 — runtime (node:24-alpine)
  └── Copia node_modules prontos do stage anterior
  └── Copia o código-fonte por último (camada mais mutável)
  └── Resultado: imagem sem devDependencies, sem cache npm, sem ferramentas de build
```

Benefícios:
- Imagem final ~60% menor que um build single-stage
- `node_modules` de dev (nodemon, sequelize-cli) nunca chegam à imagem de produção
- `.dockerignore` exclui `node_modules/`, `.env`, `.git`, logs — reduz contexto de build

### 4.2 Persistência de Dados (Named Volumes)

Dois Named Volumes declarados no `docker-compose.yml`:

| Volume | Serviço | Dado persistido |
|---|---|---|
| `acquacheckprova_postgres_data` | `db` | Banco PostgreSQL completo |
| `acquacheckprova_redis_data` | `redis` | Cache Redis |

Named Volumes são gerenciados pelo Docker daemon — sobrevivem a `docker compose down`, restart e recriação de containers. Bind mounts **não** são usados para dados persistentes.

**Prova de persistência:**
```bash
# Reinicia o banco e verifica que os dados continuam
docker compose restart db
docker compose exec backend node command.js migrate
curl -X POST http://localhost/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@acquacheck.com","password":"123456"}'
# Retorna token → dados persistiram
```

### 4.3 Rede e Comunicação Interna (Custom Bridge)

Todos os serviços estão na rede `acquacheckprova_internal` do tipo `bridge`. A comunicação ocorre **exclusivamente por nome de serviço** (DNS interno do Docker) — IPs estáticos são proibidos e desnecessários.

```
Host (porta 80)
  └── nginx          → proxy_pass http://backend:3000
        └── backend  → host=db, port=5432
              └── db (PostgreSQL — sem porta exposta ao host)
        └── backend  → host=redis, port=6379
              └── redis (sem porta exposta ao host)
```

Evidência do DNS interno em execução:

```
$ docker network inspect acquacheckprova_internal

acquacheck_backend: 172.25.0.4/16
acquacheck_nginx:   172.25.0.5/16
acquacheck_db:      172.25.0.2/16
acquacheck_redis:   172.25.0.3/16
```

O backend resolve `db` e `redis` por nome — nunca por IP. Se o IP mudar (restart), a resolução continua funcionando.

**Isolamento:** `db` e `redis` não têm portas mapeadas para o host (`PortBindings: {}`). São inacessíveis diretamente da internet — apenas o Nginx expõe a porta 80.

```bash
# Confirmar que backend não tem porta exposta ao host:
docker inspect acquacheck_backend --format '{{json .HostConfig.PortBindings}}'
# Saída: {}
```

### 4.4 Segurança

- **Segredos via `.env`:** Todas as credenciais (senha do banco, JWT secret) são injetadas via arquivo `.env` — nunca hardcoded no código ou no `docker-compose.yml`
- **Backend privado:** Porta 3000 não é exposta ao host. Todo acesso externo passa pelo Nginx
- **Banco privado:** PostgreSQL e Redis sem portas mapeadas para o host
- **Imagem imutável:** Nenhuma alteração em runtime no filesystem do container — código e dependências são fixados no build

---

## 5. Gestão de Segredos e Configurações

Crie `backend/.env` a partir do exemplo:

```bash
cp backend/.env.example backend/.env
```

Conteúdo do `.env.example`:

```env
POSTGRES_DB=banco_checklist
POSTGRES_USER=admin
POSTGRES_PASSWORD=sua_senha_aqui
JWT_SECRET=seu_segredo_jwt_aqui
DB_HOST=db
```

> ⚠️ **Nunca commite o arquivo `.env` com senhas reais.** O `.gitignore` já o exclui do repositório.

---

## 6. Evidências de Funcionamento e Verificação

### Containers em execução

```bash
$ docker compose ps

NAME                 IMAGE                     STATUS         PORTS
acquacheck_backend   acquacheckprova-backend   Up 4 minutes   3000/tcp
acquacheck_db        postgres:17-alpine        Up 4 minutes   5432/tcp
acquacheck_nginx     nginx:1.27-alpine         Up 5 minutes   0.0.0.0:80->80/tcp
acquacheck_redis     redis:7-alpine            Up 5 minutes   6379/tcp
```

### Volumes persistentes

```bash
$ docker volume ls | grep acquacheck

local     acquacheckprova_postgres_data
local     acquacheckprova_redis_data
```

### DNS interno (Service Discovery)

```bash
$ docker network inspect acquacheckprova_internal \
    --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'

acquacheck_backend: 172.25.0.4/16
acquacheck_nginx:   172.25.0.5/16
acquacheck_db:      172.25.0.2/16
acquacheck_redis:   172.25.0.3/16
```

### Backend inacessível diretamente (sem porta exposta)

```bash
$ docker inspect acquacheck_backend \
    --format '{{json .HostConfig.PortBindings}}'
# {}  ← sem binding de porta para o host
```

### API funcionando via Nginx

```bash
# Criar usuário (rota pública)
curl -X POST http://localhost/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Admin","email":"admin@acquacheck.com","password":"123456","role":"admin"}'

# Login
curl -X POST http://localhost/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@acquacheck.com","password":"123456"}'
# Retorna: {"token":"eyJ..."}

# Swagger
curl -o /dev/null -w "%{http_code}" http://localhost/api-docs/
# 200
```

**URL de acesso:** `http://localhost` (via Nginx na porta 80)  
**Swagger:** `http://localhost/api-docs`

---

## 7. Troubleshooting e Limpeza

### Problemas comuns

```bash
# Backend não conecta ao banco (banco ainda inicializando)
docker compose logs db        # aguarde "database system is ready"
docker compose restart backend

# Porta 80 ocupada
# Altere "80:80" para "8080:80" no docker-compose.yml

# Volume com dados de versão incompatível do Postgres
docker compose down -v        # apaga volumes e recria limpo
docker compose up --build -d
docker compose exec backend node command.js migrate
```

### Logs

```bash
docker compose logs backend   # logs da API Node.js
docker compose logs nginx     # logs do proxy reverso
docker compose logs db        # logs do PostgreSQL
```

### Limpeza

```bash
# Para containers (mantém volumes e dados)
docker compose down

# Para containers E apaga todos os dados do banco
docker compose down -v
```

---

## 8. CI/CD — Build, Tag e Push para Amazon ECR

O pipeline automatiza o ciclo: **Build → Tag → Push (ECR) → Deploy**.

### Pré-requisitos

```bash
# AWS CLI configurado
aws configure

# Login no ECR (substitua ACCOUNT_ID e REGION)
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS \
    --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

### Fluxo manual

```bash
# 1. Build da imagem otimizada
docker build -t acquacheck-backend ./backend

# 2. Tag com versão
docker tag acquacheck-backend:latest \
  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/acquacheck-backend:latest

# 3. Push para ECR
docker push \
  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/acquacheck-backend:latest

# 4. Deploy — atualiza o serviço ECS/Swarm com a nova imagem
docker service update --image \
  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/acquacheck-backend:latest \
  acquacheck_backend
```

### Pipeline automatizado (GitHub Actions)

O arquivo `.github/workflows/deploy.yml` executa o fluxo acima automaticamente a cada push na branch `main`.
