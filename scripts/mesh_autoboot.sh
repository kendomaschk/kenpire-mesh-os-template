#!/bin/bash
# KenPire Mesh OS – Autonomous Boot Sequence
# Runs environment checks, logs health, and fires Orchestrator & WhisperBot.

cd "$(dirname "$0")/.."
echo "🌅 KenPire Mesh Booting at $(date)" | tee -a logs/boot.log

# 1️⃣ Environment sanity
bash scripts/venv_healthcheck.sh || {
  echo "❌ Environment failed health check" | tee -a logs/boot.log
  exit 1
}

# 2️⃣ Orchestrator bridge check
echo "🧠 Launching Orchestrator Bootcheck..." | tee -a logs/boot.log
bash scripts/orchestrator_bootcheck.sh >> logs/orchestrator_boot.log 2>&1 &

# 3️⃣ WhisperBot relay
if [ -f agents/whisper_bot/whisper_bot.py ]; then
  echo "🌀 Starting WhisperBot relay..." | tee -a logs/boot.log
  source .venv/bin/activate
  python agents/whisper_bot/whisper_bot.py >> logs/whisperbot.log 2>&1 &
else
  echo "⚠️ No WhisperBot found – skipping." | tee -a logs/boot.log
fi

echo "✅ KenPire Mesh Boot sequence complete."
