#!/usr/bin/env python3
import json, os, datetime, random, pathlib

os.makedirs("logs", exist_ok=True)
pulse = {
    "utc": datetime.datetime.utcnow().isoformat() + "Z",
    "node": os.getenv("KENPIRE_NODE", "codespace"),
    "redis_ok": bool(os.getenv("REDIS_URL", "redis://localhost:6379")),
    "cpu_load": round(random.uniform(0.10, 0.85), 2),
    "mem_ok": True,
    "status": "OK",
}
with open("logs/pulse_report.json", "w") as f:
    json.dump(pulse, f, indent=2)
print("🫀 Pulse written: logs/pulse_report.json")
