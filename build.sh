#!/bin/sh
# Creates output/document.pdf with all folders in source/.
# Usage: ./build.sh
cd "$(dirname "$0")"
mkdir -p output

# folder names and images ("folder/name"), one per line, sorted alphabetically
items=$(cd source && ls -d */ | sed 's|/$||' | sort)
images=$(cd source && ls */* | grep -iE '\.(jpe?g|png)$' | sort)

echo "source/ -> output/document.pdf"
typst compile --root . \
  --input items="$items" \
  --input images="$images" \
  template.typ output/document.pdf
