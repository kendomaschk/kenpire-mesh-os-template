#!/usr/bin/env python3
import hashlib, json, os, datetime, pathlib

BASE = pathlib.Path(".")
OUT = BASE / "proof" / "prooflock_v1.0.0.json"


def hash_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


manifest = {
    "version_tag": "v1.0.0-locked",
    "generated_utc": datetime.datetime.utcnow().isoformat() + "Z",
    "files": {},
}

for folder in ["cards", "scripts", "go", "config", ".github/workflows"]:
    for p in pathlib.Path(folder).rglob("*"):
        if p.is_file():
            manifest["files"][str(p)] = {"sha256": hash_file(p)}

os.makedirs(OUT.parent, exist_ok=True)
with open(OUT, "w") as f:
    json.dump(manifest, f, indent=2)

print("✅ ProofLock generated:", OUT)
