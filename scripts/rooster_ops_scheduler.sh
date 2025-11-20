#!/bin/bash
# KenPire Mesh OS - RoosterOps Daily Standup Scheduler
# Executes daily standup protocol at 8:00 AM daily

LOG_FILE="logs/rooster_ops_scheduler.log"
SCRIPT_DIR="/workspaces/kenpire-mesh-os"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

# Check if running in automated mode
if [ "$1" = "--automated" ]; then
    log_message "☀️ ROOSTEROPS AUTOMATED EXECUTION TRIGGERED"
    
    # Change to project directory
    cd "$SCRIPT_DIR" || {
        log_message "❌ ERROR: Cannot access project directory"
        exit 1
    }
    
    # Execute daily standup protocol
    log_message "🚨 EXECUTING DAILY STANDUP PROTOCOL"
    python scripts/daily_standup_protocol.py >> "$LOG_FILE" 2>&1
    
    if [ $? -eq 0 ]; then
        log_message "✅ DAILY STANDUP PROTOCOL COMPLETED SUCCESSFULLY"
        
        # Optional: Dispatch the card to AI services
        if [ -f "queue/outbox/daily_standup_$(date +%Y-%m-%d).json" ]; then
            log_message "📤 DISPATCHING DAILY STANDUP CARD TO ALL AGENTS"
            python scripts/send_card.py --target all --payload-file "queue/outbox/daily_standup_$(date +%Y-%m-%d).json" >> "$LOG_FILE" 2>&1
        fi
    else
        log_message "❌ DAILY STANDUP PROTOCOL FAILED"
        exit 1
    fi
    
else
    # Interactive mode - show cron setup instructions
    echo "🌅 RoosterOps Daily Standup Scheduler"
    echo ""
    echo "To set up automated daily execution at 8:00 AM:"
    echo ""
    echo "1. Edit crontab:"
    echo "   crontab -e"
    echo ""
    echo "2. Add this line:"
    echo "   0 8 * * * cd $SCRIPT_DIR && bash scripts/rooster_ops_scheduler.sh --automated"
    echo ""
    echo "3. Or run manually:"
    echo "   bash scripts/rooster_ops_scheduler.sh --automated"
    echo ""
    echo "📋 Current status:"
    
    if [ -f "$LOG_FILE" ]; then
        echo "   Last execution: $(tail -1 "$LOG_FILE" | cut -d'|' -f1)"
        echo "   Log entries: $(wc -l < "$LOG_FILE") lines"
    else
        echo "   Status: Never executed"
    fi
fi