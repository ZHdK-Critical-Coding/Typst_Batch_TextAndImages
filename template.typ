// One PDF with all folders in source/.
// build.sh / build.ps1 call this file once and pass:
//   items  – the folder names, one per line, e.g. "forest\nglacier"
//   images – the images of all folders as "folder/name", one per line
//   texts  – the .txt files of all folders as "folder/name", one per line
#let split-lines(s) = s.split("\n").filter(line => line != "")
#let items = split-lines(sys.inputs.at("items", default: "glacier"))
#let images = split-lines(
  sys.inputs.at("images", default: "glacier/01.jpg\nglacier/02.jpg\nglacier/03.jpg")
)
#let texts = split-lines(sys.inputs.at("texts", default: "glacier/text.txt"))

// A5, 12 mm page border. Images are full bleed (see below).
#set page(paper: "a5", margin: 12mm)
// Helvetica 14/16 pt, regular only: every line box is exactly 16 pt high
// (baseline at the bottom), so the baseline-to-baseline distance is 16 pt.
#set text(font: "Helvetica", size: 14pt, weight: "regular", style: "normal",
  top-edge: 16pt, bottom-edge: 0pt, lang: "de")
#set par(justify: true, leading: 0pt, spacing: 16pt)

#for item in items {
  // every folder starts on a new page
  pagebreak(weak: true)

  // ---- the text (optional) ----
  // The first .txt file of the folder is used, whatever its name.
  // The whole file is body text; an empty line starts a new paragraph.
  // No .txt file: images only.
  // Paths starting with "/" are relative to the project root (--root .)
  let text-files = texts.filter(path => path.starts-with(item + "/"))
  if text-files.len() > 0 {
    let body = read("/source/" + text-files.first()).trim()
    for paragraph in body.split(regex("\n\s*\n")) {
      par(paragraph)
    }
  }

  // ---- one page per image of this folder ----
  for path in images.filter(path => path.starts-with(item + "/")) {
    // full bleed: no margin, image covers the whole page (cropped if needed)
    page(margin: 0pt, image("/source/" + path, width: 100%, height: 100%, fit: "cover"))
  }
}
