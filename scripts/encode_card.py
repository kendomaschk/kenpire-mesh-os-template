#!/usr/bin/env python3
"""
Base64 helper for embedding machine payloads into a visible card.
Usage:
  ./scripts/encode_card.py --in machine_payload.json --out b64.txt
"""
import base64
import json
import argparse
import sys
import pathlib

ap = argparse.ArgumentParser()
ap.add_argument("--in", dest="inf", required=True, help="Path to JSON payload")
ap.add_argument(
    "--out", dest="outf", required=True, help="Where to write base64"
)
args = ap.parse_args()

p = pathlib.Path(args.inf)
try:
    raw = p.read_text()
    # validate json round-trip
    json.loads(raw)
except Exception as e:
    print(f"❌ invalid JSON: {e}")
    sys.exit(1)

b64 = base64.b64encode(raw.encode("utf-8")).decode("utf-8")
pathlib.Path(args.outf).write_text(b64)
print(f"✅ wrote base64 → {args.outf}")
