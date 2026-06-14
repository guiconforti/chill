#!/usr/bin/env bash
# check-assets.sh — flag image files whose extension doesn't match their real content.
# This is what causes GitHub's "Something went really wrong, and we can't process that file."
# Run from a repo root (or pass a folder). Recurses into subfolders.
#
#   ./check-assets.sh            # checks current folder
#   ./check-assets.sh path/to/   # checks a specific folder
#   ./check-assets.sh --fix      # renames mismatched files to the correct extension
#   ./check-assets.sh --fix path/to/
#
# Note: --fix only RENAMES files. It does NOT update references inside your HTML/CSS.
# After a fix, grep your code for the old names and update them.

set -euo pipefail

FIX=0
DIR="."
for arg in "$@"; do
  case "$arg" in
    --fix) FIX=1 ;;
    *) DIR="$arg" ;;
  esac
done

if ! command -v file >/dev/null 2>&1; then
  echo "ERROR: 'file' command not found. Install it (macOS has it by default; Linux: apt install file)."
  exit 2
fi

# Map the 'file' command's reported type -> the extension it SHOULD have.
real_ext() {
  case "$(file -b --mime-type "$1")" in
    image/jpeg) echo "jpg" ;;
    image/png)  echo "png" ;;
    image/gif)  echo "gif" ;;
    image/webp) echo "webp" ;;
    image/svg+xml) echo "svg" ;;
    image/avif) echo "avif" ;;
    video/mp4)  echo "mp4" ;;
    *) echo "" ;;   # unknown / not an image we care about
  esac
}

mismatches=0
checked=0

# Find candidate asset files by extension (case-insensitive).
while IFS= read -r -d '' f; do
  ext="${f##*.}"
  ext_lc="$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"
  # jpeg and jpg are the same thing — normalize
  [ "$ext_lc" = "jpeg" ] && ext_lc="jpg"

  want="$(real_ext "$f")"
  [ -z "$want" ] && continue   # skip files 'file' can't classify
  checked=$((checked+1))

  if [ "$ext_lc" != "$want" ]; then
    mismatches=$((mismatches+1))
    printf 'MISMATCH  %-50s  ext=.%s  actual=%s\n' "$f" "$ext" "$want"
    if [ "$FIX" -eq 1 ]; then
      new="${f%.*}.$want"
      if [ -e "$new" ]; then
        echo "   skip rename: $new already exists"
      else
        mv "$f" "$new"
        echo "   renamed -> $new"
      fi
    fi
  fi
done < <(find "$DIR" -type f \( \
  -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \
  -o -iname '*.webp' -o -iname '*.svg' -o -iname '*.avif' -o -iname '*.mp4' \
  \) -print0)

echo "----------------------------------------"
echo "checked: $checked   mismatches: $mismatches"
if [ "$mismatches" -eq 0 ]; then
  echo "All clear — extensions match content. Safe to upload."
  exit 0
elif [ "$FIX" -eq 1 ]; then
  echo "Renamed mismatched files. Now update references in your HTML/CSS to match."
  exit 0
else
  echo "Re-run with --fix to auto-rename, then fix references in your code."
  exit 1
fi
