#!/bin/sh
# Creates output/<folder>.pdf for every folder in source/.
# Usage: ./build.sh
cd "$(dirname "$0")"
mkdir -p output

for dir in source/*/; do
  item=$(basename "$dir")
  # image file names, one per line, sorted alphabetically
  images=$(ls "$dir" | grep -iE '\.(jpe?g|png)$' | sort)
  echo "source/$item -> output/$item.pdf"
  typst compile --root . \
    --input item="$item" \
    --input images="$images" \
    template.typ "output/$item.pdf"
done
