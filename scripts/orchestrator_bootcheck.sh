#!/bin/bash
# KenPire Mesh OS – Orchestrator Boot Check
# Purpose: Validate API key + bridge connectivity on startup.

echo "🧠 Orchestrator Boot Check: Initializing bridge test..."

# Activate virtual environment
source .venv/bin/activate

# Run the Smart Narrative Card™ ping
python scripts/send_card.py --target gpt --payload '{"type":"ping"}'

# Check exit code
if [ $? -eq 0 ]; then
    echo "✅ Bridge check successful. Mesh is ready."
else
    echo "❌ Bridge check failed. Review logs/bridge_dispatch.log for details."
fi

# Optional: record boot check in Orchestrator log
mkdir -p logs
echo "$(date) | Orchestrator boot check completed" >> logs/orchestrator_boot.log
