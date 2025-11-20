#!/bin/bash
# 🪄 ClauseWitch helper: create and push a feature branch safely

if [ -z "$1" ]; then
  echo "Usage: ./scripts/new-branch.sh <branch-name>"
  exit 1
fi

BRANCH="feature/$1"

# Create and switch
git checkout -b "$BRANCH"

# Push and set upstream
git push -u origin "$BRANCH"

echo "✨ You're now working on $BRANCH — safe from ClauseWitch 🔒"
