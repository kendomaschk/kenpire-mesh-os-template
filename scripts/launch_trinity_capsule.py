# launch_trinity_capsule.py
# FULL TYPE LAUNCHER: Calls the true multi-AI orchestrator logic.

import subprocess
import sys
import os

def dispatch_full_orchestrator():
    """Executes the full Tri-LLM Orchestrator from orchestrator.py."""
    
    # 1. Get the prompt from the command line arguments
    if len(sys.argv) < 2:
        print("⚠️ Error: No Smart Narrative Prompt provided via command line.")
        print("Usage: python launch_trinity_capsule.py 'Your Prompt Here'")
        return

    prompt = " ".join(sys.argv[1:])
    print(f"\n🚀 Dispatching FULL Orchestration Prompt:\n> {prompt}")
    
    # 2. Define the path to the main orchestrator script
    # Assumes orchestrator.py is in the same directory as this script (scripts/)
    orchestrator_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'orchestrator.py')
    
    if not os.path.exists(orchestrator_path):
        print(f"❌ CRITICAL ERROR: Orchestrator not found at {orchestrator_path}")
        print("Please ensure orchestrator.py is in the scripts/ directory.")
        return

    # 3. Launch the orchestrator script using subprocess
    try:
        # Pass the full prompt as a single argument to the orchestrator
        # The orchestrator script must be configured to handle sys.argv
        result = subprocess.run(
            ["python", orchestrator_path, prompt],
            check=True,  # Raise error if orchestrator.py fails
            text=True,
            capture_output=True
        )
        print("\n✅ FULL Orchestration Complete. See output below:")
        print("=========================================")
        print(result.stdout)
        
    except subprocess.CalledProcessError as e:
        print(f"\n❌ ORCHESTRATOR FAILED! Exit Code: {e.returncode}")
        print(f"STDOUT: {e.stdout.strip()}")
        print(f"STDERR: {e.stderr.strip()}")
        print("Dirty Rag Alert: Investigate API Keys and orchestrator.py logic.")
    except FileNotFoundError:
        print("\n❌ Python interpreter not found. Check environment path.")

if __name__ == "__main__":
    dispatch_full_orchestrator()