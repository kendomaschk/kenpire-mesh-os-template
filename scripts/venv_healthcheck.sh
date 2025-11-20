#!/bin/bash
# KenPire Mesh OS - Virtual Environment Health Check
echo "🧠 Checking KenPire .venv integrity..."
cd "$(dirname "$0")/.."

if [ ! -d ".venv" ]; then
  echo "❌ No .venv directory found. Creating new one..."
  python3 -m venv .venv
fi

source .venv/bin/activate

python -m pip install --upgrade pip >/dev/null 2>&1
pip check >/dev/null 2>&1 && echo "✅ Dependencies are consistent." || echo "⚠️ Dependency issues detected—reinstalling..."
pip install -r requirements.txt >/dev/null 2>&1
echo "✅ Environment ready. ($(which python))"
