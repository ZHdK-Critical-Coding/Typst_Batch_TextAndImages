# Typst: Text and Images

[English](README.md)

Macht aus allen Ordnern in `source/` ein PDF: jeder Ordner beginnt auf
einer neuen Seite mit dem Text aus seiner `.txt`-Datei (optional, beliebiger Name), danach folgt jedes Bild aus
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
braucht es nicht. Die Schrift TeX Gyre Heros (ein freier Helvetica-Klon)
liegt in `fonts/`, so sieht das PDF auf jedem Computer und auf GitHub
gleich aus.

Lizenz: MIT. Schrift: TeX Gyre Heros, [GUST Font License](fonts/GUST-FONT-LICENSE.txt).

## Ausführen

Das Ausgangsmaterial liegt in `source/`, ein Ordner pro Abschnitt:

```
source/
  glacier/
    text.txt     optional, beliebiger Name mit Endung .txt (die erste wird verwendet);
                 eine Leerzeile beginnt einen neuen Absatz
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

## Auf GitHub

Jeder Push auf `main` erzeugt das PDF auf GitHub
(`.github/workflows/build.yml`, mit
[GitHub Action for Typst](https://github.com/marketplace/actions/github-action-for-typst)).
Herunterladen im Tab **Actions**: den Durchlauf öffnen, dann oben auf
**Download document_….pdf** klicken (oder unten **Artifacts →
document_….pdf**). Der Dateiname enthält das Erstellungsdatum
(Zürcher Zeit), z. B. `document_2026-11-02_1804.pdf`. Dazu muss man bei GitHub angemeldet sein; das PDF wird
90 Tage aufbewahrt. **Run workflow** startet einen Build von Hand.

Das neueste PDF, mit Datum und Seitenzahl, steht immer auf der
GitHub Page: <https://zhdk-critical-coding.github.io/Typst_Batch_TextAndImages/>. `site/index.html` ist die Seite; der Workflow
setzt `{{FILE}}` (den Dateinamen mit Datum), `{{DATE}}` und `{{PAGES}}` (aus `pdfinfo`) ein und
veröffentlicht sie zusammen mit dem PDF. Für ein eigenes Repository zuerst
**Settings → Pages → Source** auf **GitHub Actions** stellen.

Ein Tag, der mit `v` beginnt, erzeugt zusätzlich ein Release mit dem PDF:

```sh
git tag v1.0
git push origin v1.0
```

Die Action führt nur `typst compile <optionen> template.typ` aus. Der
Schritt davor ruft `./build.sh --options` auf, das dieselben Optionen wie
ein lokaler Build ausgibt, eine pro Zeile; die Listen sind mit `|` statt
mit Zeilenumbrüchen verbunden, weil die Action die Optionen an
Zeilenumbrüchen trennt. Die Action schreibt `template.pdf`, das danach in
`output/document.pdf` umbenannt wird. Verwendet wird die neueste
Typst-Version.

## Coding-Hilfe

Typst kann die Dateien eines Ordners nicht selbst auflisten. Das übernimmt das Build-Script; es übergibt die Listen an Typst, das das
ganze PDF in einem Durchgang erzeugt.

- **`build.sh` / `build.ps1`**: sammeln die Ordnernamen in `source/` und die
  Bilder aller Ordner als `ordner/name` (`jpg`, `jpeg`, `png`, nach Namen
  sortiert) sowie die `.txt`-Dateien auf dieselbe Weise und rufen
  `typst compile --root . --font-path fonts --input items=<ordner> --input images=<bilder> --input texts=<texte> template.typ output/document.pdf`
  auf. `--input` übergibt Werte an die Vorlage, `--root .` erlaubt der
  Vorlage, Dateien überall im Repository zu lesen, `--font-path fonts`
  lädt die Schrift in `fonts/`. `./build.sh --options` gibt nur diese
  Optionen aus (verwendet auf GitHub). Für andere Dateitypen
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
- **`template.typ` → Text**: `texts.filter(...)` wählt die `.txt`-Dateien
  des Ordners; gibt es keine, erhält der Ordner keine Textseite. `read()`
  lädt die erste davon als String, der bei Leerzeilen in Absätze
  aufgeteilt wird. Der Text wird als reiner Text verwendet, Zeichen wie `*`,
  `_` oder `#` erscheinen also unverändert.
- **`template.typ` → Bilder**: `images.filter(...)` wählt die Bilder,
  deren Pfad mit dem Ordnernamen beginnt. Für jedes Bild erzeugt
  `page(...)` eine neue Seite. `image(..., width: 100%, height: 100%, fit: "contain")`
  skaliert das Bild auf die Fläche innerhalb der Ränder, ohne es zu
  beschneiden. Mit `fit: "cover"` füllt es die Fläche, mit
  `page(margin: 0, …)` geht es bis an den Seitenrand.
