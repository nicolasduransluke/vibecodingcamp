#!/bin/bash
# Commit a kid's game during the camp.
#
# Usage:
#   bash scripts/commit-game.sh <slug> <path-to-html>
#
# Examples:
#   bash scripts/commit-game.sh clemente-duran ~/Downloads/dinosave-v2.html
#   bash scripts/commit-game.sh flo-lima /tmp/flo-game.html
#
# After running, the game is live at:
#   https://vibecodingcamp.vercel.app/games/2026-05/<slug>.html
#
# Available slugs: domingo-matte, crescente-matte, clemente-duran,
#   leon-jaramillo, colomba-tauber, anibal-monckeberg, july-monckeberg,
#   flo-lima, cami-caceres, cleme-caceres, pedro-lagos

set -e

cd "$(dirname "$0")/.."

slug="$1"
src="$2"

if [ -z "$slug" ] || [ -z "$src" ]; then
  echo "Usage: bash scripts/commit-game.sh <slug> <path-to-html>"
  echo ""
  echo "Available slugs:"
  ls games/2026-05/*.html | xargs -n1 basename | sed 's/.html$//' | sed 's/^/  /'
  exit 1
fi

dest="games/2026-05/${slug}.html"

if [ ! -f "$dest" ]; then
  echo "❌ No existe $dest. Slug válido?"
  exit 1
fi

if [ ! -f "$src" ]; then
  echo "❌ No existe el archivo origen: $src"
  exit 1
fi

cp "$src" "$dest"
git add "$dest"
git commit -m "Update ${slug}'s game" --no-verify
git push origin main

echo ""
echo "✅ Live in 30s at:"
echo "   https://vibecodingcamp.vercel.app/${dest}"
