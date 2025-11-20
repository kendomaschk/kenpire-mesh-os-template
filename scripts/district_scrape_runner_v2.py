import csv, json, hashlib, requests
from bs4 import BeautifulSoup
from datetime import datetime
from pathlib import Path

data_file = Path("data/district_list.csv")
log_file = Path("output/scrape_log.json")
proof_file = Path("prooflock/ledger.json")

keywords = ["curriculum", "instruction", "resources", "TEKS", "lesson"]

results = []

with data_file.open() as f:
    reader = csv.DictReader(f)
    for row in reader:
        name, url = row["District"], row["URL"]
        print(f"🔎 Scanning {name}...")
        try:
            r = requests.get(url, timeout=10)
            soup = BeautifulSoup(r.text, "html.parser")
            found = [k for k in keywords if soup.body and k.lower() in soup.body.text.lower()]
            results.append({
                "district": name,
                "url": url,
                "found_keywords": found,
                "timestamp": datetime.utcnow().isoformat()
            })
        except Exception as e:
            results.append({"district": name, "url": url, "error": str(e)})

# Save results
log_file.parent.mkdir(exist_ok=True)
json.dump(results, log_file.open("w"), indent=2)

# Hash for ProofLock
hash_val = hashlib.sha256(log_file.read_bytes()).hexdigest()
proof_entry = {
    "file": str(log_file),
    "hash": f"sha256:{hash_val}",
    "timestamp": datetime.utcnow().isoformat()
}

# Update ledger
proof_file.parent.mkdir(exist_ok=True)
if proof_file.exists():
    ledger = json.load(proof_file.open())
    ledger.setdefault("entries", []).append(proof_entry)
else:
    ledger = {"repo": "kenpire-mesh-os", "entries": [proof_entry]}
json.dump(ledger, proof_file.open("w"), indent=2)

print("✅ Scrape complete. ProofLock updated.")
