#!/usr/bin/env bash
# KenPire Mesh OS - Env Reset Script
# Purpose: Nuke and rebuild Python virtual environment cleanly.

set -e

echo "🧹 Nuking old .venv..."
rm -rf .venv

echo "🐍 Rebuilding fresh .venv..."
python3 -m venv .venv

echo "⚡ Activating .venv..."
# Activate env for the current shell session
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
elif [ -f ".venv/Scripts/activate" ]; then
    source .venv/Scripts/activate
fi

echo "📦 Installing dependencies from requirements.txt..."
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "⚠️ No requirements.txt found, skipping installs."
fi

echo "✅ .venv reset complete!"
