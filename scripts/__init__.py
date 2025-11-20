# KenPire Mesh OS - Scripts Package
# This file makes the scripts directory a proper Python package
# for better import resolution and Pylance support

"""
KenPire Mesh OS Scripts Package

This package contains the core operational scripts for the KenPire Mesh OS:
- send_card.py: Smart Narrative Card™ dispatcher
- encode_card.py: Steganographic payload encoding
- adaptive_card_relay.py: Multi-surface card relay system
- adaptive_cards_optimizer.py: Microsoft Teams UI Kit optimization
- orchestrator.py: Multi-agent orchestration
- agent_check.py: Agent verification and discovery
- prooflock.py: Cryptographic integrity verification
"""

__version__ = "3.2.0"
__author__ = "Commander Ken Domaschk"
__copyright__ = "KenPire Mesh OS - Patent Protected Technology"

# Optional: Import key functions to make them available at package level
try:
    from .send_card import dispatch_card_to_ai, send_card
except ImportError:
    pass

try:
    from .encode_card import encode_steganographic_payload
except ImportError:
    pass

try:
    from .orchestrator import MultiAIOrchestrator
except ImportError:
    pass