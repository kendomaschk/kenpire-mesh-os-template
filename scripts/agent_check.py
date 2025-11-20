import yaml
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
AGENTS = ROOT / "agents"
CAPSULES = ROOT / "capsules"
MANIFEST = ROOT / "manifest.yml"


def list_agents(folder, label):
    print(f"\n🔹 {label.upper()} REGISTERED:")
    for path in folder.glob("*/manifest.yml"):
        data = yaml.safe_load(open(path))
        name = next(iter(data.values())).get("name", path.parent.name)
        role = next(iter(data.values())).get("role", "unknown")
        print(f"  - {name:<20} ({role})")


def list_manifest_agents():
    if MANIFEST.exists():
        data = yaml.safe_load(open(MANIFEST))
        print("\n📜 MANIFEST ROSTER:")
        for a in data.get("agents", []):
            print(f"  - {a['name']:<20} → {a['path']} ({a['role']})")
    else:
        print("\n⚠️ No root manifest found.")


if __name__ == "__main__":
    list_agents(AGENTS, "agents")
    list_agents(CAPSULES, "capsules")
    list_manifest_agents()
    print("\n✅ Agent check complete.\n")
