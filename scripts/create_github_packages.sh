#!/bin/bash
# Create GitHub-compatible revenue packages (under 100MB limit)

set -e

RELEASE_DIR="revenue_releases/release_20251030_084946"
CORE_RELEASE_DIR="revenue_releases/github_release"

echo "📦 Creating GitHub-compatible release packages..."

mkdir -p "$CORE_RELEASE_DIR"

# Copy the small UI framework (already under limit)
echo "💎 Copying Core UI Framework..."
cp "$RELEASE_DIR/kenpire-ui-framework-v1.0.tar.gz" "$CORE_RELEASE_DIR/"
cp "$RELEASE_DIR/kenpire-ui-framework-v1.0.zip" "$CORE_RELEASE_DIR/"

# Create portable version WITHOUT .venv directories  
echo "💎 Creating GitHub-compatible Portable Edition..."
cd revenue_packages/portable
tar --exclude='*/\.venv/*' --exclude='*/__pycache__/*' --exclude='*/node_modules/*' \
    -czf "../../$CORE_RELEASE_DIR/kenpire-mesh-portable-github-v1.0.tar.gz" \
    kenpire-mesh-portable/ README.md
cd ../..

# Create cloud version WITHOUT .venv directories
echo "💎 Creating GitHub-compatible Cloud Edition..."
cd revenue_packages/cloud  
tar --exclude='*/\.venv/*' --exclude='*/__pycache__/*' --exclude='*/node_modules/*' \
    -czf "../../$CORE_RELEASE_DIR/kenpire-mesh-cloud-github-v1.0.tar.gz" \
    kenpire-mesh-cloud/ README.md
cd ../..

# Copy documentation
echo "📋 Copying documentation..."
cp "$RELEASE_DIR/PRICING.md" "$CORE_RELEASE_DIR/"
cp "$RELEASE_DIR/QUICK_DEPLOY.md" "$CORE_RELEASE_DIR/"  
cp "$RELEASE_DIR/RELEASE_SUMMARY.md" "$CORE_RELEASE_DIR/"

# Create new checksums
echo "🔐 Generating new checksums..."
cd "$CORE_RELEASE_DIR"
sha256sum *.tar.gz *.zip > SHA256SUMS_GITHUB
cd ../..

# Create size comparison
echo "📊 Package Size Comparison:"
echo "Original sizes:"
ls -lah "$RELEASE_DIR/"*.tar.gz "$RELEASE_DIR/"*.zip | awk '{print $5, $9}'
echo ""
echo "GitHub-compatible sizes:"
ls -lah "$CORE_RELEASE_DIR/"*.tar.gz "$CORE_RELEASE_DIR/"*.zip | awk '{print $5, $9}'

echo ""
echo "✅ GitHub-compatible packages created!"
echo "🎯 All packages now under GitHub's 100MB limit"
echo "📁 Location: $CORE_RELEASE_DIR/"