#!/usr/bin/env python3
"""
KenPire Card Loader - Dual Copyright Protected System
Copyright Cases: #1-14961881531 & #1-15001107391
© 2025 Ken Domaschk / KenPire Tech Co.™

This script loads and validates cards from the cards_index.yml system
for bandwidth optimization and modular mesh intelligence.
"""

import yaml
import json
import os
import sys
import hashlib
from pathlib import Path
from typing import Dict, List, Any
from datetime import datetime, timezone

class KenPireCardLoader:
    def __init__(self, workspace_root: str = "/workspaces/kenpire-mesh-os"):
        self.workspace_root = Path(workspace_root)
        self.cards_index_path = self.workspace_root / "cards" / "cards_index.yml"
        self.loaded_cards = {}
        self.card_cache = {}
        
    def load_cards_index(self) -> Dict[str, Any]:
        """Load and validate the main cards index file"""
        try:
            with open(self.cards_index_path, 'r') as f:
                index = yaml.safe_load(f)
                
            # Validate copyright protection
            if 'copyright_protection' not in index:
                raise ValueError("Missing copyright protection metadata")
                
            copyright_info = index['copyright_protection']
            if copyright_info['case_primary'] != "1-14961881531":
                raise ValueError("Invalid primary copyright case")
            if copyright_info['case_secondary'] != "1-15001107391":
                raise ValueError("Invalid secondary copyright case")
                
            print(f"✅ Cards Index loaded - Dual Copyright Protected")
            print(f"   Primary Case: {copyright_info['case_primary']}")
            print(f"   Secondary Case: {copyright_info['case_secondary']}")
            print(f"   Owner: {copyright_info['owner']}")
            
            return index
            
        except Exception as e:
            print(f"❌ Failed to load cards index: {e}")
            return {}
    
    def load_card_by_type(self, card_type: str, card_id: str = None) -> List[Dict[str, Any]]:
        """Load specific card type (control, security, proof, personality, technical, memory, gameboard)"""
        index = self.load_cards_index()
        if not index:
            return []
            
        card_type_key = f"{card_type}_cards"
        if card_type_key not in index:
            print(f"⚠️  Card type '{card_type}' not found")
            return []
            
        cards = index[card_type_key]
        
        if card_id:
            # Load specific card by ID
            matching_cards = [card for card in cards if card.get('id') == card_id]
            if not matching_cards:
                print(f"⚠️  Card '{card_id}' not found in {card_type}_cards")
                return []
            cards = matching_cards
            
        loaded_cards = []
        for card in cards:
            loaded_card = self._load_individual_card(card)
            if loaded_card:
                loaded_cards.append(loaded_card)
                
        return loaded_cards
    
    def _load_individual_card(self, card_config: Dict[str, Any]) -> Dict[str, Any]:
        """Load and validate individual card"""
        card_id = card_config.get('id', 'unknown')
        
        try:
            # Check if file-based card
            if 'file' in card_config:
                file_path = self.workspace_root / card_config['file']
                if file_path.exists():
                    # Generate hash for cache validation
                    file_hash = self._generate_file_hash(file_path)
                    
                    # Check cache
                    cache_key = f"{card_id}_{file_hash}"
                    if cache_key in self.card_cache:
                        print(f"📋 Loading cached card: {card_id}")
                        return self.card_cache[cache_key]
                    
                    # Load file content
                    if file_path.suffix in ['.yml', '.yaml']:
                        with open(file_path, 'r') as f:
                            content = yaml.safe_load(f)
                    elif file_path.suffix == '.json':
                        with open(file_path, 'r') as f:
                            content = json.load(f)
                    elif file_path.suffix in ['.txt', '.md']:
                        with open(file_path, 'r') as f:
                            content = f.read()
                    else:
                        content = {"file_path": str(file_path), "binary": True}
                        
                    card_config['content'] = content
                    card_config['file_hash'] = file_hash
                    
                    # Cache the loaded card
                    self.card_cache[cache_key] = card_config
                    
                else:
                    print(f"⚠️  File not found for card {card_id}: {file_path}")
                    
            # Add metadata
            card_config['loaded_at'] = datetime.now(timezone.utc).isoformat()
            card_config['loader_version'] = "2.0.0"
            
            print(f"✅ Loaded card: {card_id} ({card_config.get('type', 'unknown')})")
            return card_config
            
        except Exception as e:
            print(f"❌ Failed to load card {card_id}: {e}")
            return {}
    
    def _generate_file_hash(self, file_path: Path) -> str:
        """Generate SHA256 hash for file integrity"""
        hash_sha256 = hashlib.sha256()
        try:
            with open(file_path, 'rb') as f:
                for chunk in iter(lambda: f.read(4096), b""):
                    hash_sha256.update(chunk)
            return hash_sha256.hexdigest()
        except Exception:
            return "error"
    
    def load_startup_cards(self) -> Dict[str, List[Dict[str, Any]]]:
        """Load all cards marked for startup"""
        index = self.load_cards_index()
        startup_cards = {}
        
        for card_type in ['control', 'security', 'personality']:
            cards = self.load_card_by_type(card_type)
            startup_cards[card_type] = [
                card for card in cards 
                if card.get('load_on') in ['startup', 'continuous']
            ]
            
        return startup_cards
    
    def validate_copyright_protection(self) -> bool:
        """Validate all cards have proper copyright protection"""
        index = self.load_cards_index()
        if not index:
            return False
            
        validation_passed = True
        
        for card_type in ['control_cards', 'security_cards', 'proof_cards', 
                         'personality_cards', 'technical_cards', 'memory_cards', 
                         'gameboard_cards']:
            if card_type in index:
                for card in index[card_type]:
                    if 'copyright_case' not in card:
                        print(f"⚠️  Missing copyright case for card: {card.get('id')}")
                        validation_passed = False
                        
        return validation_passed
    
    def generate_manifest(self) -> Dict[str, Any]:
        """Generate system manifest with all loaded cards"""
        index = self.load_cards_index()
        
        manifest = {
            "system": "KenPire Mesh OS",
            "version": "3.2",
            "copyright_protection": index.get('copyright_protection', {}),
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "card_statistics": {},
            "cards_by_type": {}
        }
        
        total_cards = 0
        for card_type in ['control_cards', 'security_cards', 'proof_cards', 
                         'personality_cards', 'technical_cards', 'memory_cards', 
                         'gameboard_cards']:
            if card_type in index:
                card_count = len(index[card_type])
                manifest["card_statistics"][card_type] = card_count
                manifest["cards_by_type"][card_type] = [
                    {
                        "id": card.get('id'),
                        "name": card.get('name'),
                        "type": card.get('type'),
                        "copyright_case": card.get('copyright_case')
                    }
                    for card in index[card_type]
                ]
                total_cards += card_count
                
        manifest["card_statistics"]["total"] = total_cards
        
        return manifest


def main():
    """Main entry point for card loader"""
    print("🃏 KenPire Card Loader - Dual Copyright Protected")
    print("   Copyright Cases: #1-14961881531 & #1-15001107391")
    print("   © 2025 Ken Domaschk / KenPire Tech Co.™\n")
    
    loader = KenPireCardLoader()
    
    if len(sys.argv) > 1:
        command = sys.argv[1]
        
        if command == "startup":
            # Load startup cards
            startup_cards = loader.load_startup_cards()
            print("\n📋 Startup Cards Loaded:")
            for card_type, cards in startup_cards.items():
                print(f"  {card_type.upper()}: {len(cards)} cards")
                
        elif command == "validate":
            # Validate copyright protection
            if loader.validate_copyright_protection():
                print("✅ All cards have proper copyright protection")
            else:
                print("❌ Copyright validation failed")
                
        elif command == "manifest":
            # Generate manifest
            manifest = loader.generate_manifest()
            print(json.dumps(manifest, indent=2))
            
        elif command.startswith("load:"):
            # Load specific card type
            card_type = command.split(":")[1]
            cards = loader.load_card_by_type(card_type)
            print(f"\n📋 Loaded {len(cards)} {card_type} cards")
            
    else:
        # Default: load and display summary
        index = loader.load_cards_index()
        if index:
            manifest = loader.generate_manifest()
            print("\n📊 Card System Summary:")
            for card_type, count in manifest["card_statistics"].items():
                if card_type != "total":
                    print(f"  {card_type}: {count}")
            print(f"  TOTAL: {manifest['card_statistics']['total']} cards")


if __name__ == "__main__":
    main()