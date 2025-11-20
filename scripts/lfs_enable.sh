#!/bin/bash
# 🧠 KenPire Mesh – Git LFS Auto-Enable Script (by Jarvess)

echo "🚀 Initializing Git LFS for KenPire Mesh..."

# Check if git-lfs is installed
if ! command -v git-lfs &> /dev/null; then
  echo "📦 Installing Git LFS..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update && sudo apt install git-lfs -y
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install git-lfs
  else
    echo "❌ Unsupported OS: please install git-lfs manually."
    exit 1
  fi
fi

# Enable Git LFS for current repo
git lfs install
git lfs track "*.tar.gz" "*.zip" "*.bin"
echo "*.tar.gz filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
echo "*.zip filter=lfs diff=lfs merge=lfs -text" >> .gitattributes

# Commit the .gitattributes if needed
git add .gitattributes
git commit -m "🔐 Enable Git LFS tracking for capsule assets" || echo "✅ .gitattributes already committed"

echo "✅ Git LFS is now enabled and tracking .tar.gz / .zip"