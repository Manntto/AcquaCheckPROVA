#!/bin/bash
set -e

echo "🚀 Subindo containers..."
docker compose up --build -d

echo "⏳ Aguardando banco ficar pronto..."
docker compose exec backend sh -c "until nc -z db 5432; do sleep 1; done"

echo "🗂️  Executando migrations..."
docker compose exec backend node command.js migrate

echo "🌱 Inserindo seed..."
docker compose exec backend node command.js seed

echo "✅ Pronto! API disponível em http://localhost"
