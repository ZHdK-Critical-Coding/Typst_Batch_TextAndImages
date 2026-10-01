# Typst: Text and Images

[English](README.md)

Macht aus allen Ordnern in `source/` ein PDF: jeder Ordner beginnt auf
einer neuen Seite mit dem Text aus `text.txt`, danach folgt jedes Bild aus
dem Ordner auf einer eigenen Seite. Eine Vorlage, beliebig viel Material – einen Ordner hinzufügen und das
Script nochmals ausführen. Geschrieben in
[Typst](https://typst.app), einer modernen, schnellen Alternative zu LaTeX
mit gut lesbarer Auszeichnungssprache.

## Installation

Voraussetzungen: Typst 0.12 oder neuer (Kommandozeile), ein Terminal.
Optional: Visual Studio Code mit der Erweiterung **Tinymist Typst** für eine
Live-Vorschau von `template.typ`.

Typst installieren:

- **macOS** (mit [Homebrew](https://brew.sh)):
  ```sh
  brew install typst
  ```
- **Windows** (PowerShell):
  ```sh
  winget install --id Typst.Typst
  ```
- **Linux / ohne Paketmanager**: das Archiv für das eigene System von den
  [Typst-Releases](https://github.com/typst/typst/releases) herunterladen,
  entpacken und das Programm `typst` in einen Ordner im `PATH` legen.

Die Installation mit `typst --version` prüfen. Weitere Bibliotheken
braucht es nicht; Typst bringt eigene Schriften mit.

Lizenz: MIT

## Ausführen

Das Ausgangsmaterial liegt in `source/`, ein Ordner pro Abschnitt:

```
source/
  glacier/
    text.txt     erste Zeile: Titel; eine Leerzeile beginnt einen neuen Absatz
    01.jpg       Bilder (jpg, png), in alphabetischer Reihenfolge gesetzt
    02.jpg
  harbour/
    ...
```

Ein Terminal im Ordner des Repositorys öffnen und ausführen:

- **macOS / Linux**: `./build.sh`
- **Windows**: `powershell -ExecutionPolicy Bypass -File build.ps1`

Das Script erzeugt `output/document.pdf` (A4, 20 mm Rand) mit den Ordnern
in alphabetischer Reihenfolge. Die Ordner in `source/` durch eigenes Material ersetzen und das
Script nochmals ausführen. Ein bestehendes PDF wird überschrieben.

Um am Layout zu arbeiten, `template.typ` in VS Code öffnen und die
Tinymist-Vorschau starten: ohne Werte vom Script zeigt die Vorlage den
Ordner `glacier`.

## Coding-Hilfe

Typst kann die Dateien eines Ordners nicht selbst auflisten. Das übernimmt das Build-Script; es übergibt die Listen an Typst, das das
ganze PDF in einem Durchgang erzeugt.

- **`build.sh` / `build.ps1`**: sammeln die Ordnernamen in `source/` und die
  Bilder aller Ordner als `ordner/name` (`jpg`, `jpeg`, `png`, nach Namen
  sortiert) und rufen
  `typst compile --root . --input items=<ordner> --input images=<bilder> template.typ output/document.pdf`
  auf. `--input` übergibt Werte an die Vorlage, `--root .` erlaubt der
  Vorlage, Dateien überall im Repository zu lesen. Für andere Dateitypen
  das Muster `\.(jpe?g|png)$` erweitern (Typst liest auch `gif`, `svg` und
  `webp`).
- **`template.typ` → Eingaben**: `sys.inputs.at("items", default: …)` liest
  die Werte von der Kommandozeile. Die Standardwerte verwendet die
  Live-Vorschau. Beide kommen als ein String mit einem Eintrag pro Zeile an
  und werden in Arrays aufgeteilt.
- **`template.typ` → Seiteneinstellungen**: `#set page(...)`,
  `#set text(...)` und `#set par(...)` legen Format, Ränder, Schriftgrösse
  und Blocksatz für das ganze Dokument fest. `paper: "a4"` z. B. auf
  `"a5"` ändern oder eigene Werte für `width` und `height` setzen; mit
  `font: "…"` in `#set text` eine andere Schrift wählen.
- **`template.typ` → Ordner**: `for item in items` baut einen Abschnitt
  pro Ordner. `pagebreak(weak: true)` beginnt jeden Abschnitt auf einer
  neuen Seite (ohne ganz am Anfang eine leere Seite einzufügen).
- **`template.typ` → Text**: `read()` lädt `text.txt` als String. Die
  erste Zeile wird zum Titel, der Rest wird bei Leerzeilen in Absätze
  aufgeteilt. Der Text wird als reiner Text verwendet, Zeichen wie `*`,
  `_` oder `#` erscheinen also unverändert.
- **`template.typ` → Bilder**: `images.filter(...)` wählt die Bilder,
  deren Pfad mit dem Ordnernamen beginnt. Für jedes Bild erzeugt
  `page(...)` eine neue Seite. `image(..., width: 100%, height: 100%, fit: "contain")`
  skaliert das Bild auf die Fläche innerhalb der Ränder, ohne es zu
  beschneiden. Mit `fit: "cover"` füllt es die Fläche, mit
  `page(margin: 0, …)` geht es bis an den Seitenrand.
