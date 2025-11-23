#!/usr/bin/env powershell
<#
.SYNOPSIS
    KenPire Mesh OS™ - One-Button Setup & Deployment Script
    
.DESCRIPTION
    Automated setup for KenPire Mesh OS™ development environment
    Handles environment detection, dependency installation, and quick start
    
.PARAMETER Mode
    Setup mode: 'development', 'production', or 'demo'
    
.EXAMPLE
    .\QUICK_START.ps1 -Mode development
    
.NOTES
    KenPire Mesh OS™ v2.0.0-TEMPLATE
    Supports: Windows 10/11, PowerShell 5.1+
#>

param(
    [ValidateSet('development', 'production', 'demo')]
    [string]$Mode = 'development',
    [switch]$SkipGit,
    [switch]$Verbose
)

# Script Configuration
$ErrorActionPreference = "Stop"
$ProgressPreference = "Continue"

# ASCII Art Header
Write-Host @"
╔══════════════════════════════════════════════════════════════════╗
║                   🚀 KenPire Mesh OS™ v2.0.0                    ║
║                     ONE-BUTTON SETUP WIZARD                     ║
║                                                                  ║
║  🎯 Mode: $($Mode.ToUpper().PadRight(12)) 🔧 Platform: Windows        ║
╚══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

function Write-Status {
    param($Message, $Status = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    switch ($Status) {
        "SUCCESS" { Write-Host "[$timestamp] ✅ $Message" -ForegroundColor Green }
        "ERROR"   { Write-Host "[$timestamp] ❌ $Message" -ForegroundColor Red }
        "WARN"    { Write-Host "[$timestamp] ⚠️  $Message" -ForegroundColor Yellow }
        default   { Write-Host "[$timestamp] ℹ️  $Message" -ForegroundColor White }
    }
}

function Test-Prerequisites {
    Write-Status "Checking system prerequisites..."
    
    # Check PowerShell Version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Status "PowerShell 5.1+ required. Current: $($PSVersionTable.PSVersion)" "ERROR"
        exit 1
    }
    
    # Check Git
    try {
        $gitVersion = git --version
        Write-Status "Git detected: $gitVersion" "SUCCESS"
    }
    catch {
        Write-Status "Git not found. Installing via winget..." "WARN"
        winget install --id Git.Git -e --source winget
    }
    
    # Check Python
    try {
        $pythonVersion = python --version
        Write-Status "Python detected: $pythonVersion" "SUCCESS"
    }
    catch {
        Write-Status "Python not found. Installing Python 3.11..." "WARN"
        winget install --id Python.Python.3.11 -e --source winget
    }
    
    # Check Node.js (for some demo features)
    try {
        $nodeVersion = node --version
        Write-Status "Node.js detected: $nodeVersion" "SUCCESS"
    }
    catch {
        Write-Status "Node.js not found. Installing..." "WARN"
        winget install --id OpenJS.NodeJS -e --source winget
    }
}

function Initialize-Environment {
    Write-Status "Setting up development environment..."
    
    # Create Python virtual environment
    if (Test-Path ".venv") {
        Write-Status "Virtual environment exists, activating..." "SUCCESS"
    } else {
        Write-Status "Creating Python virtual environment..."
        python -m venv .venv
    }
    
    # Activate virtual environment
    & ".\.venv\Scripts\Activate.ps1"
    Write-Status "Virtual environment activated" "SUCCESS"
    
    # Install Python dependencies
    if (Test-Path "requirements.txt") {
        Write-Status "Installing Python dependencies..."
        pip install -r requirements.txt
    }
    
    # Install development dependencies
    if (Test-Path "requirements-dev.txt") {
        Write-Status "Installing development dependencies..."
        pip install -r requirements-dev.txt
    }
}

function Setup-GitHooks {
    if ($SkipGit) {
        Write-Status "Skipping Git setup as requested"
        return
    }
    
    Write-Status "Setting up Git hooks and configuration..."
    
    # Set up pre-commit hooks
    if (Test-Path ".pre-commit-config.yaml") {
        pip install pre-commit
        pre-commit install
        Write-Status "Pre-commit hooks installed" "SUCCESS"
    }
    
    # Configure Git for KenPire development
    git config --local user.name "KenPire Developer"
    git config --local core.autocrlf false
    git config --local core.safecrlf true
}

function Start-Services {
    param($ServiceMode)
    
    Write-Status "Starting services in $ServiceMode mode..."
    
    switch ($ServiceMode) {
        'development' {
            Write-Status "Starting development servers..."
            # Start Redis if available
            if (Get-Command redis-server -ErrorAction SilentlyContinue) {
                Start-Process redis-server -WindowStyle Hidden
                Write-Status "Redis server started" "SUCCESS"
            }
        }
        'production' {
            Write-Status "Production mode - manual service start required" "WARN"
        }
        'demo' {
            Write-Status "Starting demo environment..."
            # Launch demo systems
            if (Test-Path "smart_card_elevator_pitch_system.py") {
                Write-Status "Demo systems available - run manually when ready" "SUCCESS"
            }
        }
    }
}

function Show-QuickStart {
    Write-Host @"

╔══════════════════════════════════════════════════════════════════╗
║                     🎉 SETUP COMPLETE!                          ║
╚══════════════════════════════════════════════════════════════════╝

🚀 QUICK START COMMANDS:

📁 Activate Environment:
   .\.venv\Scripts\Activate.ps1

🎴 Run Smart Card Demo:
   python smart_card_elevator_pitch_system.py

🤖 Start Multi-AI System:
   python scripts/multi_ai_ecosystem_analyzer.py

🎯 Launch Interactive GUI:
   python interactive_smart_card_gui.py

📊 System Health Check:
   python scripts/auto_monitor.py

🔧 Development Mode:
   python -m pytest tests/

📚 Documentation:
   - README.md - Project overview
   - ARCHITECTURE.md - Technical details
   - API.md - API documentation

🆘 Support:
   - GitHub Issues: /issues
   - Documentation: /docs
   - Community: /discussions

╔══════════════════════════════════════════════════════════════════╗
║  🎯 Environment: $($Mode.ToUpper().PadRight(10)) ✅ Status: READY FOR USE    ║
╚══════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Green
}

# Main execution
try {
    Write-Status "Starting KenPire Mesh OS™ setup in $Mode mode..."
    
    Test-Prerequisites
    Initialize-Environment
    Setup-GitHooks
    Start-Services $Mode
    Show-QuickStart
    
    Write-Status "🎉 KenPire Mesh OS™ setup completed successfully!" "SUCCESS"
}
catch {
    Write-Status "Setup failed: $_" "ERROR"
    Write-Status "Check logs above for details. Try running with -Verbose for more info." "ERROR"
    exit 1
}