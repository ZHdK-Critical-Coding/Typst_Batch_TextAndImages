# Typst: Text and Images

[Deutsch](README_DE.md)

Turns every folder in `source/` into its own PDF: the text from `text.txt`
on the first page, followed by every image in the folder on a page of its
own. One template, any number of documents – add a folder and run the
script again. Written in [Typst](https://typst.app), a modern, fast
alternative to LaTeX with a readable markup language.

## Installation

Requirements: Typst 0.12 or newer (command line), a terminal. Optional:
Visual Studio Code with the extension **Tinymist Typst** for a live preview
of `template.typ`.

Install Typst:

- **macOS** (with [Homebrew](https://brew.sh)):
  ```sh
  brew install typst
  ```
- **Windows** (PowerShell):
  ```sh
  winget install --id Typst.Typst
  ```
- **Linux / without a package manager**: download the archive for your
  system from the [Typst releases](https://github.com/typst/typst/releases),
  unpack it and put the `typst` program into a folder in your `PATH`.

Check the installation with `typst --version`. No other libraries are
needed; Typst brings its own fonts.

License: MIT

## How to Run

The source material lies in `source/`, one folder per document:

```
source/
  glacier/
    text.txt     first line: title; an empty line starts a new paragraph
    01.jpg       images (jpg, png), placed in alphabetical order
    02.jpg
  harbour/
    ...
```

Open a terminal in the repository folder and run

- **macOS / Linux**: `./build.sh`
- **Windows**: `powershell -ExecutionPolicy Bypass -File build.ps1`

The script creates `output/glacier.pdf`, `output/harbour.pdf` … (A4, 20 mm
margins). Replace the folders in `source/` with your own material and run
it again. Existing PDFs are overwritten.

To work on the layout, open `template.typ` in VS Code and start the
Tinymist preview: without inputs from the script, the template shows the
folder `glacier`.

## Coding Help

Typst cannot list the files of a folder by itself. The build script does
that and calls Typst once per folder.

- **`build.sh` / `build.ps1`**: loop over the folders in `source/`. For
  each one they collect the image names (`jpg`, `jpeg`, `png`, sorted by
  name) and call
  `typst compile --root . --input item=<folder> --input images=<names> template.typ output/<folder>.pdf`.
  `--input` hands values to the template, `--root .` allows the template
  to read files anywhere in the repository. Extend the pattern
  `\.(jpe?g|png)$` for other file types (Typst also reads `gif`, `svg`
  and `webp`).
- **`template.typ` → inputs**: `sys.inputs.at("item", default: …)` reads
  the values from the command line. The defaults are used by the
  live preview. `images` arrives as one string with one name per line and
  is split into an array.
- **`template.typ` → page setup**: `#set page(...)`, `#set text(...)` and
  `#set par(...)` define format, margins, font size and justification for
  the whole document. Change `paper: "a4"` to e.g. `"a5"` or set your own
  `width` and `height`; add `font: "…"` to `#set text` for another font.
- **`template.typ` → text**: `read()` loads `text.txt` as a string. The
  first line becomes the title, the rest is split at empty lines into
  paragraphs. The text is used as plain text, so characters like `*`, `_`
  or `#` are printed as they are.
- **`template.typ` → images**: for every image, `page(...)` creates a new
  page. `image(..., width: 100%, height: 100%, fit: "contain")` scales the
  image to the area inside the margins without cropping it. Use
  `fit: "cover"` to fill the area, or `page(margin: 0, …)` for full-bleed
  images.
