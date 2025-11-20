#!/usr/bin/env python3
# KenPire Mesh OS — Real Smart Narrative Dispatcher
# Rebuilt clean from GPU-PC node

import json
import argparse
import importlib
import os
import sys
from datetime import datetime

# ---------------------------------------------------------------------------
# Logging Utility
# ---------------------------------------------------------------------------

def log(msg: str):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[Dispatcher {timestamp}] {msg}")

# ---------------------------------------------------------------------------
# Dynamic Agent Loader
# ---------------------------------------------------------------------------
# Each KenPire agent lives in scripts/ or agents/
# Any agent with a send() function can receive Smart Narrative Cards.

AGENT_MAP = {
    "gpt": "send_gpt_card",
    "orchestrator": "orchestrator_bootcheck",
    "jarvess": "post_to_notion",          # placeholder until Jarvess API is plugged in
    "dirtyrag": "quick_share",            # placeholder, real DirtyRag module can replace
    "trifecta": "trust_router",           # manages GPT–Gemini–Claude triangulation
}


# ---------------------------------------------------------------------------
# Resolve and import module by known name or fail gracefully
# ---------------------------------------------------------------------------

def load_agent_module(agent_key: str):
    """
    Loads the module responsible for delivering cards to this agent.
    All modules must expose a function: handle_card(payload: dict)
    """

    if agent_key not in AGENT_MAP:
        log(f"ERROR: Unknown agent '{agent_key}'. Valid agents: {list(AGENT_MAP.keys())}")
        sys.exit(1)

    module_name = AGENT_MAP[agent_key]

    try:
        module = importlib.import_module(f"scripts.{module_name}")
        return module
    except ImportError:
        try:
            module = importlib.import_module(f"agents.{module_name}")
            return module
        except ImportError:
            log(f"ERROR: Agent module '{module_name}' not found.")
            sys.exit(1)


# ---------------------------------------------------------------------------
# Card Sender
# ---------------------------------------------------------------------------

def dispatch_card(agent_key: str, payload: dict):
    """
    Dispatches a Smart Narrative Card to the designated agent.
    """

    log(f"Dispatching Smart Narrative Card to '@{agent_key}'")

    module = load_agent_module(agent_key)

    if not hasattr(module, "handle_card"):
        log(f"ERROR: Agent module '{module.__name__}' missing 'handle_card(payload)'")
        sys.exit(1)

    try:
        response = module.handle_card(payload)
        log(f"Agent '@{agent_key}' Response: {response}")
    except Exception as e:
        log(f"ERROR: Agent '@{agent_key}' failed to process card: {e}")
        sys.exit(1)


# ---------------------------------------------------------------------------
# CLI Entrypoint
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="KenPire Smart Narrative Card Dispatcher")
    parser.add_argument("--target", type=str, required=True,
                        help="Agent target name (orchestrator, gpt, jarvess, dirtyrag, trifecta, etc.)")
    parser.add_argument("--payload", type=str, required=True,
                        help="JSON string payload for the Smart Narrative Card")

    args = parser.parse_args()

    try:
        payload = json.loads(args.payload)
    except json.JSONDecodeError as e:
        log(f"ERROR: Invalid JSON payload: {e}")
        sys.exit(1)

    dispatch_card(args.target, payload)


if __name__ == "__main__":
    main()
