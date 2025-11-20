import sys

def send_card(prompt):
    print(f"🚀 Sending to Gpt → {{prompt}}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("❌ No prompt provided.")
    else:
        send_card(sys.argv[1])
