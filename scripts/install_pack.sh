#!/usr/bin/env bash
# KenPire™ Mesh OS Installer — v1.0.0
# Purpose: Set up virtual environment, install dependencies, and verify base system.

set -e

echo "🧠 Initializing KenPire Mesh OS environment..."

if [ ! -d ".venv" ]; then
  echo "🚀 Creating Python virtual environment..."
  python3 -m venv .venv
fi

source .venv/bin/activate

echo "📦 Installing base dependencies..."
pip install --upgrade pip wheel
pip install -r requirements.txt || echo "⚠️ No requirements.txt found — skipping."

mkdir -p logs cards scripts

echo "✅ Environment ready."
echo "Run: python3 scripts/system_health_check.py --card cards/system_health_card.yaml"
