#!/usr/bin/env python3
"""
KenPire Automation Monitor
Keeps Commander Ken's AI empire running 24/7
"""

import time
import requests
import subprocess
import json
from datetime import datetime

class KenPireMonitor:
    def __init__(self):
        self.backend_url = "http://localhost:8000"
        self.frontend_url = "http://localhost:5173"
        self.log_file = "logs/automation_monitor.log"
        
    def log(self, message):
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_msg = f"[{timestamp}] {message}"
        print(log_msg)
        with open(self.log_file, 'a', encoding='utf-8') as f:
            f.write(log_msg + '\n')
    
    def check_system_health(self):
        """Check if the KenPire system is healthy"""
        health_score = 0
        
        # Check backend
        try:
            response = requests.get(f"{self.backend_url}/health", timeout=5)
            if response.status_code == 200:
                health_score += 50
                self.log("✅ Backend is healthy")
            else:
                self.log(f"⚠️ Backend unhealthy: {response.status_code}")
        except Exception as e:
            self.log(f"❌ Backend down: {str(e)}")
            
        # Check frontend
        try:
            response = requests.get(self.frontend_url, timeout=5)
            if response.status_code == 200:
                health_score += 50
                self.log("✅ Frontend is healthy")
            else:
                self.log(f"⚠️ Frontend issues: {response.status_code}")
        except Exception as e:
            self.log(f"❌ Frontend down: {str(e)}")
            
        return health_score
    
    def auto_restart_if_needed(self):
        """Restart system if health is poor"""
        health = self.check_system_health()
        
        if health < 50:  # System is unhealthy
            self.log("🔄 System unhealthy, attempting auto-restart...")
            try:
                # Try to restart the mesh
                subprocess.run(["/workspaces/kenpire-mesh-os/start-mesh.sh"], 
                             check=False, timeout=30)
                time.sleep(15)  # Give it time to start
                
                # Re-check health
                new_health = self.check_system_health()
                if new_health > health:
                    self.log("🚀 System restarted successfully!")
                else:
                    self.log("⚠️ Restart didn't improve health, may need manual intervention")
                    
            except Exception as e:
                self.log(f"❌ Auto-restart failed: {str(e)}")
        
        return health
    
    def monitor_continuously(self, interval_minutes=5):
        """Monitor the system continuously"""
        self.log("🤖 KenPire Automation Monitor started - keeping your AI empire running!")
        
        while True:
            try:
                health = self.auto_restart_if_needed()
                self.log(f"💚 System health: {health}%")
                
                # Sleep for the specified interval
                time.sleep(interval_minutes * 60)
                
            except KeyboardInterrupt:
                self.log("🛑 Monitor stopped by user")
                break
            except Exception as e:
                self.log(f"⚠️ Monitor error: {str(e)}")
                time.sleep(60)  # Wait a minute before retrying

if __name__ == "__main__":
    monitor = KenPireMonitor()
    monitor.monitor_continuously()
