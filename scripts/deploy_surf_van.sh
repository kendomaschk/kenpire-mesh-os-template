#!/bin/bash

# 🏄‍♂️ KenPire Mesh OS v3.5 - Surf Van Deployment Script
# Educational Capsule Edition - Austin ISD Ready

set -e

echo "🏄‍♂️ KENPIRE SURF VAN DEPLOYMENT"
echo "================================="
echo "v3.5 Educational Capsule Edition"
echo ""

# Check if portable exists
if [ ! -f "kenpire_portable_20251108_180125.tar.gz" ]; then
    echo "❌ Error: Portable package not found!"
    echo "Expected: kenpire_portable_20251108_180125.tar.gz"
    exit 1
fi

echo "📦 Found portable package: kenpire_portable_20251108_180125.tar.gz"
echo "💾 Size: $(du -h kenpire_portable_20251108_180125.tar.gz | cut -f1)"

# Get target directory
TARGET_DIR=${1:-"/tmp/kenpire_educational_deploy"}
echo "🎯 Target deployment: $TARGET_DIR"

# Create target directory
mkdir -p "$TARGET_DIR"

# Extract portable package
echo "📦 Extracting educational capsule..."
tar -xzf kenpire_portable_20251108_180125.tar.gz -C "$TARGET_DIR"

# Check if extraction successful
if [ -d "$TARGET_DIR/kenpire_portable" ]; then
    echo "✅ Educational capsule extracted successfully!"
    echo ""
    echo "🚀 TO START EDUCATIONAL DEPLOYMENT:"
    echo "   cd $TARGET_DIR/kenpire_portable"
    echo "   ./start-kenpire.sh"
    echo ""
    echo "🏫 EDUCATIONAL AGENTS INCLUDED:"
    echo "   - Curriculum Director (standards alignment)"
    echo "   - Literacy Coach (reading/writing support)" 
    echo "   - Bell Ringer (schedule management)"
    echo "   - Tracker (student progress analytics)"
    echo ""
    echo "🏄‍♂️ SURF VAN UI: Patent-protected educational interface"
    echo "🛡️  IP PROTECTION: ClauseWitch Clause 4B engaged"
    echo "📊 TRIFECTA MESH: Claude + GPT-4o + Gemini active"
    echo ""
    echo "🎯 Ready for Austin ISD pilot deployment!"
else
    echo "❌ Error: Extraction failed"
    exit 1
fi