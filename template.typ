// One PDF for one folder in source/.
// build.sh / build.ps1 call this file once per folder and pass:
//   item   – the folder name, e.g. "glacier"
//   images – the image file names in that folder, one per line
#let item = sys.inputs.at("item", default: "glacier")
#let images = (
  sys.inputs.at("images", default: "01.jpg\n02.jpg\n03.jpg")
    .split("\n")
    .filter(name => name != "")
)

// Paths starting with "/" are relative to the project root (--root .)
#let folder = "/source/" + item + "/"

#set page(paper: "a4", margin: 20mm)
#set text(size: 11pt, lang: "en")
#set par(justify: true)

// ---- page 1: the text ----
// The first line of text.txt is the title, the rest is the body.
// An empty line starts a new paragraph.
#let lines = read(folder + "text.txt").trim().split("\n")
#let title = lines.first()
#let body = lines.slice(1).join("\n").trim()

#text(size: 24pt, weight: "bold", title)
#v(1em)
#for paragraph in body.split(regex("\n\s*\n")) {
  par(paragraph)
}

// ---- one page per image ----
#for name in images {
  page(align(center + horizon, image(folder + name, width: 100%, height: 100%, fit: "contain")))
}
