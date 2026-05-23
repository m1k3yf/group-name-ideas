#!/usr/bin/env bash
# push-batch.sh — sync local with remote, then push the latest batch.
# Designed to run from either a Claude sandbox or Mikey's Mac terminal.
# Credentials are embedded in the remote URL, so no `gh` CLI is required.

set -e

# Resolve repo root (works in both sandbox and Mac)
if [ -d "/sessions" ] && [ -d "$(dirname "$0")" ]; then
  cd "$(dirname "$0")"
else
  cd ~/Desktop/MIKEY/Music/Group-Name-Ideas
fi

echo "→ Repo: $(pwd)"

# Always pull-rebase first so we never diverge
echo "→ Fetching and rebasing on origin/main…"
git fetch origin
git pull --rebase origin main || {
  echo "✗ Rebase failed. Aborting and exiting — manual intervention needed."
  git rebase --abort 2>/dev/null || true
  exit 1
}

# Stage only index.html (other untracked files are ignored or intentional)
git add index.html

# Bail out cleanly if nothing changed
if git diff --cached --quiet; then
  echo "→ index.html unchanged — nothing to commit."
  exit 0
fi

# Detect highest batch number for the commit message
BATCH=$(grep -oE 'id:"b[0-9]+"' index.html | grep -oE '[0-9]+' | sort -n | tail -1)
DATE=$(date "+%B %-d")
MSG="Add batch ${BATCH} — ${DATE}"

echo "→ Committing: $MSG"
git commit -m "$MSG"

echo "→ Pushing to origin/main…"
git push origin main

echo "✓ Done."
