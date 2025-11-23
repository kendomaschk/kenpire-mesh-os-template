#!/bin/bash
# KenPire Mesh OS™ - Codespaces Post-Create Setup Script

set -e

echo "🚀 KenPire Mesh OS™ - Setting up development environment..."

# Update package lists
sudo apt-get update

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt-get install -y \
    redis-server \
    postgresql-client \
    curl \
    wget \
    jq \
    git-lfs \
    tree

# Set up Python environment
echo "🐍 Setting up Python environment..."
python3 -m pip install --upgrade pip
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Install Python dependencies
if [ -f "requirements.txt" ]; then
    echo "📋 Installing Python dependencies..."
    pip install -r requirements.txt
fi

if [ -f "requirements-dev.txt" ]; then
    echo "🔧 Installing development dependencies..."
    pip install -r requirements-dev.txt
fi

# Install pre-commit hooks
if [ -f ".pre-commit-config.yaml" ]; then
    echo "🪝 Setting up pre-commit hooks..."
    pre-commit install
fi

# Set up Git configuration for Codespaces
echo "📝 Configuring Git for KenPire development..."
git config --global user.name "KenPire Developer"
git config --global user.email "dev@kenpire.com"
git config --global core.autocrlf false
git config --global core.safecrlf true
git config --global init.defaultBranch main

# Create necessary directories
echo "📁 Creating project directories..."
mkdir -p logs
mkdir -p temp
mkdir -p data

# Set up environment variables
echo "🌍 Setting up environment..."
cat >> ~/.bashrc << 'EOF'

# KenPire Mesh OS™ Environment Variables
export KENPIRE_ENV=development
export KENPIRE_LOG_LEVEL=INFO
export PYTHONPATH="${PYTHONPATH}:${PWD}"

# KenPire aliases for quick development
alias kenpire-start='python smart_card_elevator_pitch_system.py'
alias kenpire-gui='python interactive_smart_card_gui.py'
alias kenpire-test='python -m pytest tests/'
alias kenpire-monitor='python scripts/auto_monitor.py'
alias kenpire-ai='python scripts/multi_ai_ecosystem_analyzer.py'

# Quick navigation
alias cdk='cd /workspaces/kenpire-mesh-os-template'
alias cdl='cd /workspaces/kenpire-mesh-os-template/logs'
alias cds='cd /workspaces/kenpire-mesh-os-template/scripts'

echo "🎉 KenPire Mesh OS™ environment loaded!"
EOF

# Make scripts executable
echo "🔧 Making scripts executable..."
find scripts/ -name "*.py" -exec chmod +x {} \;
find scripts/ -name "*.sh" -exec chmod +x {} \;

# Download sample data or configurations if needed
echo "📊 Setting up sample data..."
# Add any data setup commands here

echo "✅ Post-create setup complete!"
echo ""
echo "🚀 Quick Start Commands:"
echo "  python smart_card_elevator_pitch_system.py  # Run main demo"
echo "  python interactive_smart_card_gui.py        # Launch GUI"
echo "  python scripts/auto_monitor.py              # Health monitoring"
echo ""
echo "📚 Documentation available in /docs"
echo "🎯 Happy coding with KenPire Mesh OS™!"