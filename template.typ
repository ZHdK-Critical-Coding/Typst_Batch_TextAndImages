// One PDF with all folders in source/.
// build.sh / build.ps1 call this file once and pass:
//   items  – the folder names, one per line, e.g. "forest\nglacier"
//   images – the images of all folders as "folder/name", one per line
#let split-lines(s) = s.split("\n").filter(line => line != "")
#let items = split-lines(sys.inputs.at("items", default: "glacier"))
#let images = split-lines(
  sys.inputs.at("images", default: "glacier/01.jpg\nglacier/02.jpg\nglacier/03.jpg")
)

#set page(paper: "a4", margin: 20mm)
#set text(size: 11pt, lang: "en")
#set par(justify: true)

#for item in items {
  // Paths starting with "/" are relative to the project root (--root .)
  let folder = "/source/" + item + "/"

  // every folder starts on a new page
  pagebreak(weak: true)

  // ---- the text ----
  // The first line of text.txt is the title, the rest is the body.
  // An empty line starts a new paragraph.
  let lines = read(folder + "text.txt").trim().split("\n")
  let title = lines.first()
  let body = lines.slice(1).join("\n").trim()

  text(size: 24pt, weight: "bold", title)
  v(1em)
  for paragraph in body.split(regex("\n\s*\n")) {
    par(paragraph)
  }

  // ---- one page per image of this folder ----
  for path in images.filter(path => path.starts-with(item + "/")) {
    page(align(center + horizon, image("/source/" + path, width: 100%, height: 100%, fit: "contain")))
  }
}
