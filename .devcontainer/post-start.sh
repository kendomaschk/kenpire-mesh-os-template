#!/bin/bash
# KenPire Mesh OS™ - Codespaces Post-Start Script
# Runs every time the container starts

set -e

echo "🔄 KenPire Mesh OS™ - Starting services..."

# Start Redis server if not running
if ! pgrep redis-server > /dev/null; then
    echo "🗄️  Starting Redis server..."
    sudo service redis-server start
fi

# Check if virtual environment exists and activate
if [ -d ".venv" ]; then
    echo "🐍 Activating Python virtual environment..."
    source .venv/bin/activate
fi

# Update Python path
export PYTHONPATH="${PYTHONPATH}:${PWD}"

# Check system health
echo "🏥 Running health checks..."

# Check Redis connectivity
if command -v redis-cli &> /dev/null; then
    if redis-cli ping > /dev/null 2>&1; then
        echo "✅ Redis: Connected"
    else
        echo "⚠️  Redis: Connection failed"
    fi
fi

# Check Python environment
if python3 -c "import sys; print(f'✅ Python {sys.version}')"; then
    echo "✅ Python: Ready"
else
    echo "❌ Python: Issues detected"
fi

# Display system status
echo ""
echo "📊 System Status:"
echo "  🐍 Python: $(python3 --version)"
echo "  📦 Pip packages: $(pip list --format=freeze | wc -l) installed"
echo "  💾 Redis: $(redis-cli ping 2>/dev/null || echo 'Not connected')"
echo "  💽 Disk space: $(df -h /workspaces | tail -1 | awk '{print $4}')"
echo "  🧠 Memory: $(free -h | awk '/^Mem:/ {print $7}')"

echo ""
echo "🎯 KenPire Mesh OS™ ready for development!"
echo ""
echo "📋 Quick Actions:"
echo "  • Run: 'python smart_card_elevator_pitch_system.py'"
echo "  • GUI: 'python interactive_smart_card_gui.py'"
echo "  • Test: 'python -m pytest'"
echo "  • Monitor: 'python scripts/auto_monitor.py'"