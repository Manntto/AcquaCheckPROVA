# ── Stage 1: deps ──────────────────────────────────────────────
FROM node:24-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# ── Stage 2: runtime ───────────────────────────────────────────
FROM node:24-alpine AS runtime
WORKDIR /app

# Copia apenas as dependências de produção já instaladas
COPY --from=deps /app/node_modules ./node_modules

# Copia o código-fonte (camadas mais mutáveis por último)
COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
