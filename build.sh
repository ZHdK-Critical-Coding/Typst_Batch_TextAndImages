#!/bin/sh
# Creates output/document.pdf with all folders in source/.
# Usage: ./build.sh            (PDF)
#        ./build.sh --options  (only print the typst options, one per line, used on GitHub)
cd "$(dirname "$0")"
mkdir -p output

# folder names, images and texts ("folder/name"), one per line, sorted alphabetically
items=$(cd source && ls -d */ | sed 's|/$||' | sort)
images=$(cd source && ls */* | grep -iE '\.(jpe?g|png)$' | sort)
texts=$(cd source && ls */* | grep -iE '\.txt$' | sort)

# the GitHub action takes one option per line, so the lists are joined with "|"
if [ "$1" = "--options" ]; then
  join() { echo "$1" | paste -sd '|' -; }
  printf '%s\n' --root . --font-path fonts \
    --input "items=$(join "$items")" \
    --input "images=$(join "$images")" \
    --input "texts=$(join "$texts")"
  exit 0
fi

echo "source/ -> output/document.pdf"
typst compile --root . --font-path fonts \
  --input items="$items" \
  --input images="$images" \
  --input texts="$texts" \
  template.typ output/document.pdf
