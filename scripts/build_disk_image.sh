#!/usr/bin/env bash
# KenPire™ Disk Image Builder — v1.0.0

set -e
echo "💽  Building KenPire Mesh OS portable image..."
BUILD_TIME=$(date -u +"%Y%m%dT%H%M%SZ")
OUTFILE="KenPire_Mesh_OS_${BUILD_TIME}.tar.gz"

tar -czf "$OUTFILE" \
  cards scripts logs prooflock_*.json README.md .venv 2>/dev/null || \
  echo "⚠️  Some optional paths may be missing, continuing..."

echo "✅  Archive created: $OUTFILE"

SHA256SUM=$(sha256sum "$OUTFILE" | cut -d ' ' -f1)
cat <<JSON > prooflock_snapshot_${BUILD_TIME}.json
{
  "capsule": "KenPire Mesh OS",
  "version": "1.0.0",
  "artifact": "$OUTFILE",
  "sha256": "$SHA256SUM",
  "timestamp": "$BUILD_TIME"
}
JSON

echo "🔐  ProofLock manifest generated: prooflock_snapshot_${BUILD_TIME}.json"
echo "💫  Done."
