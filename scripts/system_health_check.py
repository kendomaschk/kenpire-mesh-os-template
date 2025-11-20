#!/usr/bin/env python3
"""
KenPire™ System Health Card — Loop Sync v1.0.1
Now supports --card argument for YAML file input.
"""

import os, argparse, yaml
from datetime import datetime

LOG_PATH = "logs/system_health.log"
TRUST_LOG = "logs/trust_router.log"


def log(msg):
    timestamp = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
    line = f"{timestamp} {msg}"
    print(line)
    with open(LOG_PATH, "a") as f:
        f.write(line + "\n")


def check_orchestrator():
    proc = (
        os.popen("ps aux | grep orchestrator.py | grep -v grep").read().strip()
    )
    return bool(proc), (
        "✅ Orchestrator running" if proc else "❌ Orchestrator not detected"
    )


def check_prooflock():
    if not os.path.exists(TRUST_LOG):
        return False, "⚠️ trust_router.log missing"
    with open(TRUST_LOG) as f:
        tail = f.readlines()[-5:]
    healthy = any("ProofLock healthy" in line for line in tail)
    return healthy, (
        "✅ ProofLock healthy" if healthy else "❌ ProofLock failing"
    )


def main(card_path):
    log(f"🧠 Starting System Health Loop with {card_path}")
    card_data = yaml.safe_load(open(card_path))
    log(
        f"🔖 Capsule: {card_data['capsule']['name']} — Version {card_data['capsule']['version']}"
    )
    checks = [check_orchestrator(), check_prooflock()]
    for ok, msg in checks:
        log(msg)
    if all(ok for ok, _ in checks):
        log("💫 Mesh integrity confirmed — all systems nominal.\n")
    else:
        log("🚨 One or more systems failed health check.\n")


if __name__ == "__main__":
    os.makedirs("logs", exist_ok=True)
    parser = argparse.ArgumentParser()
    parser.add_argument("--card", required=True, help="Path to YAML card")
    args = parser.parse_args()
    main(args.card)
