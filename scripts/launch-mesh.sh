#!/usr/bin/env bash
set -e
echo "[KenPire] Launch helper starting..."

if [ ! -f "ui/package.json" ]; then
  echo "[KenPire] No UI detected at ./ui yet."
  echo "          Add a React/Tailwind app in ./ui (with package.json) or adjust docker-compose.yml."
  echo "          Example: npx create-vite@latest ui --template react"
  exit 0
fi

docker compose up --build
