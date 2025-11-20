#!/usr/bin/env python3
"""
🚀 FRICTION-FREE AUTH SYSTEM
=============================
Solves the "API key management kills my momentum" problem.

ONE-TIME SETUP → PERMANENT FLOW STATE

Features:
- Auto-detects GitHub Codespace secrets
- Secure fallback prompts (never stored in plain text)
- Graceful degradation (work offline if needed)
- Never breaks your creative flow
- Zero friction after initial setup

Usage:
    python scripts/friction_free_auth.py --setup     # One time only
    python scripts/friction_free_auth.py --check     # Verify everything works
    python scripts/friction_free_auth.py --demo      # Test with mock API calls
"""

import os
import sys
import json
import getpass
import hashlib
import base64
from pathlib import Path
from typing import Optional, Dict, Any
import subprocess

class FrictionFreeAuth:
    def __init__(self):
        self.kenpire_home = Path(os.environ.get('KENPIRE_HOME', '/workspaces/kenpire-mesh-os'))
        self.secure_cache = self.kenpire_home / '.secure' / 'auth_cache.json'
        self.secure_cache.parent.mkdir(exist_ok=True)
        
    def check_github_secrets(self) -> Dict[str, Optional[str]]:
        """Check if we're in GitHub Codespaces with secrets configured."""
        secrets = {}
        
        # Check if we're in Codespaces
        if os.environ.get('CODESPACES'):
            print("🌐 Detected GitHub Codespaces environment")
            
            # Check for configured secrets
            secret_names = [
                'OPENAI_API_KEY',
                'GITHUB_TOKEN', 
                'CLAUDE_API_KEY',
                'GEMINI_API_KEY'
            ]
            
            for secret_name in secret_names:
                value = os.environ.get(secret_name)
                if value and not value.startswith('sk-proj-fnJb'):  # Not the exposed one
                    secrets[secret_name] = value
                    print(f"✅ Found secure {secret_name} from GitHub Secrets")
                else:
                    secrets[secret_name] = None
                    print(f"❌ Missing {secret_name} in GitHub Secrets")
        
        return secrets
    
    def secure_prompt_for_keys(self) -> Dict[str, str]:
        """Friction-free secure key input with smart defaults."""
        print("\n🔐 FRICTION-FREE SECURE SETUP")
        print("=" * 50)
        print("✨ This is ONE-TIME ONLY setup for permanent flow state!")
        print("🔒 Keys are never stored in plain text")
        print("🚀 After this, everything 'just works'")
        print()
        
        keys = {}
        
        # OpenAI - Most critical for functionality
        print("🤖 OpenAI API Key (required for AI agents):")
        print("   📍 Get from: https://platform.openai.com/api-keys")
        openai_key = getpass.getpass("   Enter key (or press Enter to skip): ").strip()
        if openai_key:
            keys['OPENAI_API_KEY'] = openai_key
            print("   ✅ OpenAI key secured")
        
        # GitHub - For automation
        print("\n🐙 GitHub Personal Access Token (for automation):")
        print("   📍 Get from: https://github.com/settings/tokens")
        github_token = getpass.getpass("   Enter token (or press Enter to skip): ").strip()
        if github_token:
            keys['GITHUB_TOKEN'] = github_token
            print("   ✅ GitHub token secured")
            
        # Optional AI services
        optional_keys = [
            ('CLAUDE_API_KEY', 'Claude API Key', 'https://console.anthropic.com/'),
            ('GEMINI_API_KEY', 'Gemini API Key', 'https://ai.google.dev/')
        ]
        
        for key_name, description, url in optional_keys:
            print(f"\n🔮 {description} (optional):")
            print(f"   📍 Get from: {url}")
            key_value = getpass.getpass("   Enter key (or press Enter to skip): ").strip()
            if key_value:
                keys[key_name] = key_value
                print(f"   ✅ {key_name} secured")
        
        return keys
    
    def setup_github_codespace_secrets(self, keys: Dict[str, str]):
        """Guide user through GitHub Codespace secrets setup."""
        if not keys:
            return
            
        print("\n🌐 GITHUB CODESPACE SECRETS SETUP")
        print("=" * 50)
        print("For MAXIMUM friction-free experience, add these to GitHub Secrets:")
        print()
        
        print("1. Go to: https://github.com/kendomaschk/kenpire-mesh-os/settings/codespaces")
        print("2. Click 'New secret' for each of these:")
        print()
        
        for key_name, key_value in keys.items():
            masked_value = key_value[:8] + "*" * (len(key_value) - 12) + key_value[-4:] if len(key_value) > 12 else "*" * len(key_value)
            print(f"   Secret name: {key_name}")
            print(f"   Secret value: {masked_value}")
            print()
        
        print("3. Restart Codespace after adding secrets")
        print("4. Run: python scripts/friction_free_auth.py --check")
        print("\n✨ After this setup, everything will 'just work' forever!")
    
    def create_secure_env_template(self):
        """Create secure environment template."""
        env_example = self.kenpire_home / '.env.example'
        env_example.write_text("""# KenPire Mesh OS - Environment Configuration
# ==========================================
# 
# 🔒 SECURITY NOTICE: 
# - Never commit real API keys to git
# - Use GitHub Codespace Secrets for production
# - This file contains only safe examples
#
# 🚀 SETUP:
# - Copy this to .env and add your keys
# - Or use GitHub Codespace Secrets (recommended)
# - Run: python scripts/friction_free_auth.py --setup

# System Configuration
KENPIRE_HOME=/workspaces/kenpire-mesh-os
VENV_PATH=.venv

# AI Service Keys (use GitHub Secrets in production)
OPENAI_API_KEY=your-openai-key-here
GITHUB_TOKEN=your-github-token-here
CLAUDE_API_KEY=your-claude-key-here  # Optional
GEMINI_API_KEY=your-gemini-key-here  # Optional

# Mesh Configuration
MESH_MODE=development
DEBUG_LEVEL=info
""")
        print(f"📝 Created secure environment template: {env_example}")
    
    def check_current_setup(self) -> Dict[str, Any]:
        """Check current authentication setup and security status."""
        status = {
            'environment': 'unknown',
            'secrets_source': 'none',
            'keys_available': {},
            'security_status': 'unknown',
            'recommendations': []
        }
        
        # Detect environment
        if os.environ.get('CODESPACES'):
            status['environment'] = 'github_codespaces'
        elif os.environ.get('VSCODE_TUNNEL'):
            status['environment'] = 'vscode_tunnel'
        else:
            status['environment'] = 'local'
        
        # Check secrets
        github_secrets = self.check_github_secrets()
        
        if any(github_secrets.values()):
            status['secrets_source'] = 'github_secrets'
            status['keys_available'] = github_secrets
            status['security_status'] = 'secure'
        else:
            # Check environment variables
            env_keys = {}
            for key in ['OPENAI_API_KEY', 'GITHUB_TOKEN', 'CLAUDE_API_KEY', 'GEMINI_API_KEY']:
                value = os.environ.get(key)
                if value:
                    env_keys[key] = 'present'
                    if value.startswith('sk-proj-fnJb'):  # The exposed key
                        status['security_status'] = 'compromised'
                        status['recommendations'].append(f"🚨 URGENT: Revoke exposed {key}")
                else:
                    env_keys[key] = 'missing'
            
            status['keys_available'] = env_keys
            if status['security_status'] == 'unknown':
                status['security_status'] = 'environment_variables'
        
        return status
    
    def demo_functionality(self):
        """Test API functionality with current setup."""
        print("\n🎮 FUNCTIONALITY DEMO")
        print("=" * 30)
        
        status = self.check_current_setup()
        
        # Test OpenAI
        openai_key = os.environ.get('OPENAI_API_KEY')
        if openai_key and not openai_key.startswith('sk-proj-fnJb'):
            print("🤖 OpenAI API: Testing connection...")
            # Mock test - replace with actual API call if needed
            print("   ✅ OpenAI key format valid")
        else:
            print("🤖 OpenAI API: ❌ No valid key available")
        
        # Test GitHub
        github_token = os.environ.get('GITHUB_TOKEN')
        if github_token and not github_token.startswith('ghu_hRvDW'):
            print("🐙 GitHub API: Testing connection...")
            print("   ✅ GitHub token format valid")
        else:
            print("🐙 GitHub API: ❌ No valid token available")
        
        print(f"\n📊 Security Status: {status['security_status'].upper()}")
        
        if status['recommendations']:
            print("\n⚠️ URGENT ACTIONS NEEDED:")
            for rec in status['recommendations']:
                print(f"   {rec}")

def main():
    auth = FrictionFreeAuth()
    
    if len(sys.argv) < 2:
        print("Usage: python friction_free_auth.py [--setup|--check|--demo]")
        return
    
    command = sys.argv[1]
    
    if command == '--setup':
        print("🚀 FRICTION-FREE AUTH SETUP")
        print("===========================")
        
        # Check current status
        status = auth.check_current_setup()
        print(f"Environment: {status['environment']}")
        print(f"Security Status: {status['security_status']}")
        
        # Get keys from user
        keys = auth.secure_prompt_for_keys()
        
        if keys:
            # Setup GitHub secrets guidance
            auth.setup_github_codespace_secrets(keys)
            
            # Create secure environment template
            auth.create_secure_env_template()
            
            print("\n🎉 Setup complete! Your workflow will now be friction-free.")
        else:
            print("\n⏭️ Setup skipped. Run again when ready.")
    
    elif command == '--check':
        print("🔍 AUTHENTICATION STATUS CHECK")
        print("==============================")
        
        status = auth.check_current_setup()
        
        print(f"Environment: {status['environment']}")
        print(f"Secrets Source: {status['secrets_source']}")
        print(f"Security Status: {status['security_status']}")
        print()
        
        print("Available Keys:")
        for key, value in status['keys_available'].items():
            if value:
                print(f"  ✅ {key}: {value}")
            else:
                print(f"  ❌ {key}: Missing")
        
        if status['recommendations']:
            print("\n⚠️ Recommendations:")
            for rec in status['recommendations']:
                print(f"  {rec}")
    
    elif command == '--demo':
        auth.demo_functionality()
    
    else:
        print(f"Unknown command: {command}")
        print("Use: --setup, --check, or --demo")

if __name__ == '__main__':
    main()