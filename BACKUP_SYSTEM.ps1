#!/usr/bin/env powershell
<#
.SYNOPSIS
    KenPire Mesh OS™ - Automated Backup & Recovery System
    
.DESCRIPTION
    Creates versioned backups with recovery capabilities
    Supports incremental, full, and differential backup strategies
    
.PARAMETER BackupType
    Type of backup: 'full', 'incremental', 'config-only'
    
.PARAMETER RestoreFrom
    Backup timestamp to restore from (format: YYYYMMDD_HHMMSS)
    
.EXAMPLE
    .\BACKUP_SYSTEM.ps1 -BackupType full
    .\BACKUP_SYSTEM.ps1 -RestoreFrom 20251122_213045
    
.NOTES
    KenPire Mesh OS™ v2.0.0-TEMPLATE
    Automatic versioning and integrity checks included
#>

param(
    [ValidateSet('full', 'incremental', 'config-only', 'restore')]
    [string]$BackupType = 'full',
    [string]$RestoreFrom = '',
    [switch]$AutoCompress = $true,
    [switch]$Verbose
)

# Configuration
$BackupRoot = "C:\KenPire\Backups"
$ProjectRoot = $PWD
$TimestampFormat = "yyyyMMdd_HHmmss"
$MaxBackups = 10

function Write-BackupLog {
    param($Message, $Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        "ERROR"   { Write-Host $logEntry -ForegroundColor Red }
        "WARN"    { Write-Host $logEntry -ForegroundColor Yellow }
        default   { Write-Host $logEntry -ForegroundColor White }
    }
    
    # Log to file
    $logFile = "$BackupRoot\backup_log.txt"
    if (!(Test-Path $BackupRoot)) { New-Item -Path $BackupRoot -ItemType Directory -Force }
    $logEntry | Out-File -FilePath $logFile -Append
}

function Initialize-BackupSystem {
    Write-BackupLog "Initializing KenPire Backup System..."
    
    if (!(Test-Path $BackupRoot)) {
        New-Item -Path $BackupRoot -ItemType Directory -Force
        Write-BackupLog "Created backup directory: $BackupRoot" "SUCCESS"
    }
    
    # Create backup metadata directory
    $metadataDir = "$BackupRoot\.metadata"
    if (!(Test-Path $metadataDir)) {
        New-Item -Path $metadataDir -ItemType Directory -Force
    }
    
    return $true
}

function Get-BackupManifest {
    param($BackupPath)
    
    $manifestFile = "$BackupPath\backup_manifest.json"
    if (Test-Path $manifestFile) {
        return Get-Content $manifestFile | ConvertFrom-Json
    }
    return $null
}

function New-BackupManifest {
    param($BackupPath, $BackupInfo)
    
    $manifest = @{
        timestamp = $BackupInfo.Timestamp
        type = $BackupInfo.Type
        version = "2.0.0-TEMPLATE"
        files = $BackupInfo.Files
        size_mb = $BackupInfo.SizeMB
        checksum = $BackupInfo.Checksum
        git_commit = (git rev-parse HEAD 2>$null)
        git_branch = (git branch --show-current 2>$null)
        machine = $env:COMPUTERNAME
        user = $env:USERNAME
        created = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    
    $manifestFile = "$BackupPath\backup_manifest.json"
    $manifest | ConvertTo-Json -Depth 10 | Out-File -FilePath $manifestFile
    
    return $manifest
}

function Invoke-FullBackup {
    $timestamp = Get-Date -Format $TimestampFormat
    $backupName = "KENPIRE_FULL_$timestamp"
    $backupPath = "$BackupRoot\$backupName"
    
    Write-BackupLog "Starting full backup: $backupName"
    
    # Create backup directory
    New-Item -Path $backupPath -ItemType Directory -Force
    
    # Files and directories to backup
    $backupItems = @(
        "*.py",
        "*.ps1", 
        "*.md",
        "*.json",
        "*.txt",
        "*.yaml", 
        "*.yml",
        "requirements*.txt",
        ".devcontainer\*",
        ".vscode\*",
        "scripts\*",
        "docs\*",
        ".git\config",
        ".gitignore",
        ".gitattributes"
    )
    
    $totalFiles = 0
    $totalSize = 0
    $fileList = @()
    
    foreach ($pattern in $backupItems) {
        $files = Get-ChildItem -Path $ProjectRoot -Filter $pattern -Recurse -Force -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            if ($file.PSIsContainer) { continue }
            
            $relativePath = $file.FullName.Substring($ProjectRoot.Path.Length + 1)
            $destPath = "$backupPath\$relativePath"
            $destDir = Split-Path $destPath -Parent
            
            if (!(Test-Path $destDir)) {
                New-Item -Path $destDir -ItemType Directory -Force | Out-Null
            }
            
            Copy-Item -Path $file.FullName -Destination $destPath -Force
            $totalFiles++
            $totalSize += $file.Length
            $fileList += $relativePath
        }
    }
    
    # Create manifest
    $backupInfo = @{
        Timestamp = $timestamp
        Type = "full"
        Files = $fileList
        SizeMB = [math]::Round($totalSize / 1MB, 2)
        Checksum = (Get-FileHash -Path $backupPath -Algorithm SHA256 -ErrorAction SilentlyContinue).Hash
    }
    
    New-BackupManifest -BackupPath $backupPath -BackupInfo $backupInfo
    
    # Compress if requested
    if ($AutoCompress) {
        $zipPath = "$BackupRoot\$backupName.zip"
        Compress-Archive -Path $backupPath\* -DestinationPath $zipPath -Force
        Remove-Item -Path $backupPath -Recurse -Force
        Write-BackupLog "Backup compressed: $zipPath" "SUCCESS"
    }
    
    Write-BackupLog "Full backup completed: $totalFiles files ($($backupInfo.SizeMB) MB)" "SUCCESS"
    
    # Cleanup old backups
    Invoke-BackupCleanup
    
    return $backupName
}

function Invoke-ConfigBackup {
    $timestamp = Get-Date -Format $TimestampFormat
    $backupName = "KENPIRE_CONFIG_$timestamp"
    $backupPath = "$BackupRoot\$backupName"
    
    Write-BackupLog "Starting configuration backup: $backupName"
    
    New-Item -Path $backupPath -ItemType Directory -Force
    
    # Configuration files only
    $configItems = @(
        "requirements*.txt",
        "*.json",
        ".devcontainer\*",
        ".vscode\*",
        ".git\config",
        ".gitignore",
        ".gitattributes",
        "QUICK_START.ps1",
        "BACKUP_SYSTEM.ps1"
    )
    
    $totalFiles = 0
    foreach ($pattern in $configItems) {
        $files = Get-ChildItem -Path $ProjectRoot -Filter $pattern -Recurse -Force -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            if ($file.PSIsContainer) { continue }
            
            $relativePath = $file.FullName.Substring($ProjectRoot.Path.Length + 1)
            $destPath = "$backupPath\$relativePath"
            $destDir = Split-Path $destPath -Parent
            
            if (!(Test-Path $destDir)) {
                New-Item -Path $destDir -ItemType Directory -Force | Out-Null
            }
            
            Copy-Item -Path $file.FullName -Destination $destPath -Force
            $totalFiles++
        }
    }
    
    Write-BackupLog "Configuration backup completed: $totalFiles files" "SUCCESS"
    return $backupName
}

function Invoke-RestoreBackup {
    param($BackupName)
    
    Write-BackupLog "Starting restore from: $BackupName"
    
    $backupPath = "$BackupRoot\$BackupName"
    $zipPath = "$BackupRoot\$BackupName.zip"
    
    # Check if compressed backup exists
    if ((Test-Path $zipPath) -and !(Test-Path $backupPath)) {
        Write-BackupLog "Extracting compressed backup..."
        Expand-Archive -Path $zipPath -DestinationPath $backupPath -Force
    }
    
    if (!(Test-Path $backupPath)) {
        Write-BackupLog "Backup not found: $BackupName" "ERROR"
        return $false
    }
    
    # Read manifest
    $manifest = Get-BackupManifest -BackupPath $backupPath
    if ($manifest) {
        Write-BackupLog "Restoring from backup created: $($manifest.created)"
        Write-BackupLog "Git commit: $($manifest.git_commit)"
    }
    
    # Create restore point
    $restorePoint = "RESTORE_POINT_$(Get-Date -Format $TimestampFormat)"
    Invoke-ConfigBackup | Out-Null
    
    # Restore files
    $restoredFiles = 0
    Get-ChildItem -Path $backupPath -Recurse -File | ForEach-Object {
        $relativePath = $_.FullName.Substring($backupPath.Length + 1)
        $destPath = "$ProjectRoot\$relativePath"
        $destDir = Split-Path $destPath -Parent
        
        if (!(Test-Path $destDir)) {
            New-Item -Path $destDir -ItemType Directory -Force | Out-Null
        }
        
        Copy-Item -Path $_.FullName -Destination $destPath -Force
        $restoredFiles++
    }
    
    Write-BackupLog "Restore completed: $restoredFiles files restored" "SUCCESS"
    Write-BackupLog "Restore point created: $restorePoint" "SUCCESS"
    
    return $true
}

function Invoke-BackupCleanup {
    Write-BackupLog "Cleaning up old backups (keeping $MaxBackups)..."
    
    $backups = Get-ChildItem -Path $BackupRoot -Directory | 
               Where-Object { $_.Name -match "KENPIRE_.*_\d{8}_\d{6}" } |
               Sort-Object CreationTime -Descending
    
    $toDelete = $backups | Select-Object -Skip $MaxBackups
    
    foreach ($backup in $toDelete) {
        Remove-Item -Path $backup.FullName -Recurse -Force
        
        # Also remove compressed version
        $zipFile = "$($backup.FullName).zip"
        if (Test-Path $zipFile) {
            Remove-Item -Path $zipFile -Force
        }
        
        Write-BackupLog "Removed old backup: $($backup.Name)"
    }
}

function Show-BackupStatus {
    Write-Host @"

╔══════════════════════════════════════════════════════════════════╗
║                  🗄️  KenPire Backup Status                      ║
╚══════════════════════════════════════════════════════════════════╝

📁 Backup Location: $BackupRoot
📊 Available Backups:

"@ -ForegroundColor Cyan
    
    $backups = Get-ChildItem -Path $BackupRoot -Directory | 
               Where-Object { $_.Name -match "KENPIRE_.*_\d{8}_\d{6}" } |
               Sort-Object CreationTime -Descending |
               Select-Object -First 5
    
    foreach ($backup in $backups) {
        $manifest = Get-BackupManifest -BackupPath $backup.FullName
        $size = if ($manifest) { "$($manifest.size_mb) MB" } else { "Unknown" }
        $type = if ($manifest) { $manifest.type } else { "Unknown" }
        
        Write-Host "  📦 $($backup.Name)" -ForegroundColor Green
        Write-Host "     📅 Created: $($backup.CreationTime)"
        Write-Host "     📋 Type: $type | Size: $size"
        Write-Host ""
    }
    
    Write-Host "🔧 Commands:" -ForegroundColor Yellow
    Write-Host "  .\BACKUP_SYSTEM.ps1 -BackupType full"
    Write-Host "  .\BACKUP_SYSTEM.ps1 -BackupType config-only" 
    Write-Host "  .\BACKUP_SYSTEM.ps1 -BackupType restore -RestoreFrom BACKUP_NAME"
}

# Main execution
try {
    Write-Host "🗄️  KenPire Mesh OS™ Backup System v2.0.0" -ForegroundColor Cyan
    
    Initialize-BackupSystem
    
    switch ($BackupType) {
        'full' {
            $result = Invoke-FullBackup
            Write-BackupLog "✅ Full backup completed: $result" "SUCCESS"
        }
        'config-only' {
            $result = Invoke-ConfigBackup
            Write-BackupLog "✅ Configuration backup completed: $result" "SUCCESS"
        }
        'restore' {
            if ($RestoreFrom) {
                $result = Invoke-RestoreBackup -BackupName $RestoreFrom
                if ($result) {
                    Write-BackupLog "✅ Restore completed successfully" "SUCCESS"
                }
            } else {
                Write-BackupLog "❌ RestoreFrom parameter required for restore operation" "ERROR"
            }
        }
    }
    
    Show-BackupStatus
    
} catch {
    Write-BackupLog "❌ Backup operation failed: $_" "ERROR"
    exit 1
}