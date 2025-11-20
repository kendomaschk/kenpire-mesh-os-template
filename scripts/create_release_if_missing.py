#!/usr/bin/env python3
import os
import subprocess
import json
import sys
import requests

REPO = os.environ.get("GITHUB_REPOSITORY") or "kendomaschk/kenpire-mesh-os"
TOKEN = os.environ.get("GITHUB_TOKEN")
TAG = "dirtyrag-0.1.0"
API = "https://api.github.com"


def tag_exists():
    r = requests.get(
        f"{API}/repos/{REPO}/tags", headers={"Authorization": f"token {TOKEN}"}
    )
    if r.status_code != 200:
        print("Could not list tags:", r.status_code, r.text)
        return False
    tags = [t["name"] for t in r.json()]
    return TAG in tags


def create_tag_and_release():
    # Create tag from HEAD
    subprocess.run(
        ["git", "tag", "-a", TAG, "-m", f"Release {TAG}"], check=False
    )
    subprocess.run(["git", "push", "origin", TAG], check=False)
    # Create release via API
    r = requests.post(
        f"{API}/repos/{REPO}/releases",
        headers={"Authorization": f"token {TOKEN}"},
        json={
            "tag_name": TAG,
            "name": TAG,
            "body": "Dirty Rag genesis release — ProofLock sealed.",
        },
    )
    print("Release response:", r.status_code, r.text)


def main():
    if not TOKEN:
        print(
            "GITHUB_TOKEN/PAT not provided in env. Skipping release creation."
        )
        return
    if tag_exists():
        print("Tag exists, skipping.")
        return
    create_tag_and_release()


if __name__ == "__main__":
    main()
