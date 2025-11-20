#!/usr/bin/env python3
import os
import json
import subprocess
import sys
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

REPO_ROOT = os.getcwd()
PROOFLOCK_ROOT = os.path.join(REPO_ROOT, "prooflock")
DOCS_DIR = os.path.join(REPO_ROOT, "docs")


def safe_name(branch):
    return branch.replace("/", "-").replace(" ", "_")


def find_prooflocks():
    results = []
    for root, _, files in os.walk(PROOFLOCK_ROOT):
        for f in files:
            if f.endswith(".json"):
                results.append(os.path.join(root, f))
    return results


def gen_pdf(json_path):
    with open(json_path) as fh:
        doc = json.load(fh)
    branch = (
        doc.get("BRANCH") or os.path.splitext(os.path.basename(json_path))[0]
    )
    fname = f"PROOFLOCK_{safe_name(branch)}.pdf"
    os.makedirs(DOCS_DIR, exist_ok=True)
    out = os.path.join(DOCS_DIR, fname)
    c = canvas.Canvas(out, pagesize=letter)
    c.setFont("Helvetica-Bold", 16)
    c.drawString(
        72, 720, f"KenPire ProofLock Certificate — {doc.get('PROOFLOCK_ID')}"
    )
    c.setFont("Helvetica", 10)
    c.drawString(72, 700, f"Sealed: {doc.get('TIMESTAMP')}")
    c.drawString(72, 680, f"Hash: {doc.get('HASH')}")
    c.drawString(72, 660, f"Signed By: {doc.get('SIGNED_BY')}")
    c.drawString(72, 640, f"Branch: {doc.get('BRANCH')}")
    c.drawString(
        72,
        620,
        f"Notes: {doc.get('DETAILS','Initial scaffold for Dirty Rag Bot capsule')}",
    )
    c.save()
    print("WROTE:", out)
    return out


def git_commit_and_push(
    files, message="chore(prooflock): add generated prooflock PDFs"
):
    if not files:
        print("No files to commit.")
        return
    subprocess.run(
        ["git", "config", "--global", "user.email", "kenpire-bot@example.com"],
        check=True,
    )
    subprocess.run(
        ["git", "config", "--global", "user.name", "KenPire Mesh Bot"],
        check=True,
    )
    subprocess.run(["git", "add"] + files, check=True)
    subprocess.run(["git", "commit", "-m", message], check=False)
    # push using origin (checkout earlier with PAT)
    subprocess.run(["git", "push", "origin", "main"], check=False)


def main():
    if not os.path.isdir(PROOFLOCK_ROOT):
        print("No prooflock directory found. Exiting.")
        return
    jsons = find_prooflocks()
    written = []
    for j in jsons:
        try:
            written.append(gen_pdf(j))
        except Exception as e:
            print("Error generating PDF for", j, e)
    if written:
        git_commit_and_push(written)


if __name__ == "__main__":
    main()
