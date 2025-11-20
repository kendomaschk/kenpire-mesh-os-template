#!/usr/bin/env python3
import json, os, sys, pathlib, datetime, subprocess

BASE = pathlib.Path(".")
LEDGER = BASE / "logs" / "trust_router.log"
PROOF = BASE / "proof" / "prooflock_v1.0.0.json"


def log(msg):
    os.makedirs(LEDGER.parent, exist_ok=True)
    with open(LEDGER, "a") as f:
        f.write(f"{datetime.datetime.utcnow().isoformat()}Z {msg}\n")


def regen_proof():
    subprocess.run([sys.executable, "scripts/prooflock.py"], check=False)
    log("♻️  ProofLock regenerated")


def check():
    if not PROOF.exists():
        log("❗ Missing prooflock – regenerating")
        regen_proof()
        return
    try:
        data = json.loads(PROOF.read_text())
        assert "files" in data and data["files"], "empty ProofLock file list"
        log("✅ ProofLock healthy")
    except Exception as e:
        log(f"⚠️ ProofLock invalid: {e}")
        regen_proof()


if __name__ == "__main__":
    check()
