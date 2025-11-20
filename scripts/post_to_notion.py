#!/usr/bin/env python3
import os
import requests
import json
import datetime

NOTION_TOKEN = os.environ.get("NOTION_TOKEN")
DB_ID = os.environ.get("NOTION_DATABASE_ID")
if not NOTION_TOKEN or not DB_ID:
    print("Missing Notion env vars. Skipping.")
    exit(0)

API = "https://api.notion.com/v1/pages"
headers = {
    "Authorization": f"Bearer {NOTION_TOKEN}",
    "Notion-Version": "2022-06-28",
    "Content-Type": "application/json",
}

title = "Dirty Rag Bot — Genesis (ProofLock)"
now = datetime.datetime.utcnow().isoformat()

properties = {
    "Name": {"title": [{"text": {"content": title}}]},
    "Date": {"date": {"start": now}},
    "Notes": {
        "rich_text": [
            {
                "text": {
                    "content": "ProofLock sealed and release created. See docs/PROOFLOCK_feature-dirtyrag-core.pdf"
                }
            }
        ]
    },
}

payload = {"parent": {"database_id": DB_ID}, "properties": properties}
r = requests.post(API, headers=headers, json=payload)
print("Notion response:", r.status_code, r.text)
