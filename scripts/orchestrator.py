#!/usr/bin/env python3
import subprocess, time, datetime, os, sys

CYCLE = int(os.getenv("KENPIRE_ORCHESTRATOR_CYCLE", 300))  # 5 minutes default


def run(name, cmd):
    print(f"[{datetime.datetime.utcnow().isoformat()}Z] ▶️  {name}")
    try:
        subprocess.run(cmd, check=True)
        print(
            f"[{datetime.datetime.utcnow().isoformat()}Z] ✅  {name} complete\n"
        )
    except subprocess.CalledProcessError as e:
        print(
            f"[{datetime.datetime.utcnow().isoformat()}Z] ⚠️  {name} failed: {e}\n"
        )


def main():
    print("🚀 KenPire Mesh Orchestrator — Loop Initiated")
    while True:
        run("ProofLock", [sys.executable, "scripts/prooflock.py"])
        run("Pulse Check", [sys.executable, "scripts/pulse_check.py"])
        run("Trust Router", [sys.executable, "scripts/trust_router.py"])
        print(f"⏳ Sleeping {CYCLE} seconds before next cycle...\n")
        time.sleep(CYCLE)


if __name__ == "__main__":
    main()
