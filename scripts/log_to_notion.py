import argparse, requests, json, os

NOTION_API = os.getenv("NOTION_API_KEY")
DATABASE_ID = os.getenv("NOTION_PROOFLOCK_DB")

parser = argparse.ArgumentParser()
parser.add_argument("--title")
parser.add_argument("--file")
parser.add_argument("--status")
parser.add_argument("--page")
args = parser.parse_args()

with open(args.file, "r") as f:
    proof_data = json.load(f)

payload = {
    "parent": {"database_id": DATABASE_ID},
    "properties": {
        "Title": {"title": [{"text": {"content": args.title}}]},
        "Status": {"rich_text": [{"text": {"content": args.status}}]},
        "Version": {
            "rich_text": [{"text": {"content": proof_data["version_tag"]}}]
        },
        "Timestamp": {
            "rich_text": [{"text": {"content": proof_data["timestamp"]}}]
        },
    },
}

res = requests.post(
    "https://api.notion.com/v1/pages",
    headers={
        "Authorization": f"Bearer {NOTION_API}",
        "Content-Type": "application/json",
        "Notion-Version": "2022-06-28",
    },
    json=payload,
)
print(f"✅ Notion log created: {res.status_code}")
