#!/usr/bin/env bash
set -euo pipefail

if [ ! -d .git ]; then
  echo "Run this from the root of the lumen-web repo (no .git here)."
  exit 1
fi
if [ ! -f index.html ] || [ ! -f privacy.html ]; then
  echo "Expected index.html and privacy.html at the repo root. Not found."
  exit 1
fi

perl -i -pe 's/12 345 678 901/19 670 960 586/g' privacy.html

if grep -q 'href="/privacy.html"' index.html; then
  echo "Footer already has a privacy link — leaving index.html untouched."
else
  perl -i -pe 's{2026 LUMEN</div>}{2026 LUMEN &middot; <a href="/privacy.html" style="color:#8CA0BC;text-decoration:underline">Privacy Policy</a></div>}g' index.html
fi

if git diff --quiet; then
  echo "Nothing changed — already up to date."
  exit 0
fi

git add index.html privacy.html
git commit -m "Add privacy link to footer; set correct ABN"
git push origin main

echo ""
echo "Done. Vercel will deploy from main."
echo "Check: getlumen.com.au (footer link) and getlumen.com.au/privacy.html (ABN)"
