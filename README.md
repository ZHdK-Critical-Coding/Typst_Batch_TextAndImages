# Typst: Text and Images

[Deutsch](README_DE.md)

Turns all folders in `source/` into one PDF: every folder starts on a new
page with the text from its `.txt` file (optional, any name), followed by
every image in the folder on a page of its own. One template, any amount of material – add a folder and run the
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
needed. The font TeX Gyre Heros (a free Helvetica clone) is included in
`fonts/`, so the PDF looks the same on every computer and on GitHub.

License: MIT. Font: TeX Gyre Heros, [GUST Font License](fonts/GUST-FONT-LICENSE.txt).

## How to Run

The source material lies in `source/`, one folder per section:

```
source/
  glacier/
    text.txt     optional, any name ending in .txt (the first one is used);
                 an empty line starts a new paragraph
    01.jpg       images (jpg, png), placed in alphabetical order
    02.jpg
  harbour/
    ...
```

Open a terminal in the repository folder and run

- **macOS / Linux**: `./build.sh`
- **Windows**: `powershell -ExecutionPolicy Bypass -File build.ps1`

The script creates `output/document.pdf` (A4, 20 mm margins) with the
folders in alphabetical order. Replace the folders in `source/` with your own material and run
it again. An existing PDF is overwritten.

To work on the layout, open `template.typ` in VS Code and start the
Tinymist preview: without inputs from the script, the template shows the
folder `glacier`.

## On GitHub

Every push to `main` builds the PDF on GitHub
(`.github/workflows/build.yml`, with
[GitHub Action for Typst](https://github.com/marketplace/actions/github-action-for-typst)).
Download it in the **Actions** tab: open the run, then click
**Download document.pdf** at the top of the page (or **Artifacts →
document.pdf** at the bottom). You have to be signed in to GitHub; the
PDF is kept for 90 days. **Run workflow** starts a build by hand.

The latest PDF is also published on GitHub Pages, together with the
date of the build and the number of pages:
<https://zhdk-critical-coding.github.io/Typst_Batch_TextAndImages/>
(direct link: [document.pdf](https://zhdk-critical-coding.github.io/Typst_Batch_TextAndImages/document.pdf)),
no sign-in needed. For your own copy of the repository, choose
**Settings → Pages → Source: GitHub Actions** once.

A tag starting with `v` also creates a release with the PDF attached:

```sh
git tag v1.0
git push origin v1.0
```

The action only runs `typst compile <options> template.typ`. The step
before it runs `./build.sh --options`, which prints the same options as a
local build, one per line; the lists are joined with `|` instead of line
breaks, because the action splits the options at line breaks. The action
writes `template.pdf`, which is then renamed to `output/document.pdf`.
It uses the latest Typst version.

## Coding Help

Typst cannot list the files of a folder by itself. The build script does
that and hands the lists to Typst, which builds the whole PDF in one run.

- **`build.sh` / `build.ps1`**: collect the folder names in `source/`
  the images of all folders as `folder/name` (`jpg`, `jpeg`, `png`,
  sorted by name) and the `.txt` files the same way, then call
  `typst compile --root . --font-path fonts --input items=<folders> --input images=<images> --input texts=<texts> template.typ output/document.pdf`.
  `--input` hands values to the template, `--root .` allows the template
  to read files anywhere in the repository, `--font-path fonts` loads the
  font in `fonts/`. `./build.sh --options` only prints these options
  (used on GitHub). Extend the pattern
  `\.(jpe?g|png)$` for other file types (Typst also reads `gif`, `svg`
  and `webp`).
- **`template.typ` → inputs**: `sys.inputs.at("items", default: …)` reads
  the values from the command line. The defaults are used by the live
  preview. Both arrive as one string with one entry per line and are split
  into arrays.
- **`template.typ` → page setup**: `#set page(...)`, `#set text(...)` and
  `#set par(...)` define format, margins, font size and justification for
  the whole document. Change `paper: "a4"` to e.g. `"a5"` or set your own
  `width` and `height`; add `font: "…"` to `#set text` for another font.
- **`template.typ` → folders**: `for item in items` builds one section
  per folder. `pagebreak(weak: true)` starts every section on a new page
  (but adds no empty page at the very beginning).
- **`template.typ` → text**: `texts.filter(...)` picks the `.txt` files of
  the folder; if there is none, the folder gets no text page. `read()`
  loads the first one as a string, which is split at empty lines into
  paragraphs. The text is used as plain text, so characters like `*`, `_`
  or `#` are printed as they are.
- **`template.typ` → images**: `images.filter(...)` picks the images whose
  path starts with the folder name. For every image, `page(...)` creates a
  new page. `image(..., width: 100%, height: 100%, fit: "contain")` scales the
  image to the area inside the margins without cropping it. Use
  `fit: "cover"` to fill the area, or `page(margin: 0, …)` for full-bleed
  images.
