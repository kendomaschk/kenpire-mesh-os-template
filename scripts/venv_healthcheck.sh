#!/bin/bash
# KenPire Mesh OS - Virtual Environment Health Check

echo "🧠 Checking KenPire .venv integrity..."
cd "$(dirname "$0")/.."

PYTHON_PATH="/c/Users/isick/AppData/Local/Programs/Python/Python312/python"

if [ ! -d ".venv" ]; then
  echo "❌ No .venv directory found. Creating new one with $PYTHON_PATH ..."
  "$PYTHON_PATH" -m venv .venv
fi

source .venv/Scripts/activate  # Windows Git Bash path
"$PYTHON_PATH" -m pip install --upgrade pip >/dev/null 2>&1

pip check >/dev/null 2>&1 && echo "✅ Dependencies are consistent." || {
  echo "⚠️ Dependency issues detected—reinstalling..."
  pip install -r requirements.txt >/dev/null 2>&1
}

echo "✅ Environment ready. ($("$PYTHON_PATH" -c 'import sys; print(sys.executable)'))"
