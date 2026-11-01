# Creates output\document.pdf with all folders in source\ (Windows PowerShell).
# Usage: powershell -ExecutionPolicy Bypass -File build.ps1
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force output | Out-Null

# folder names, images and texts ("folder/name"), one per line, sorted alphabetically
$folders = Get-ChildItem source -Directory | Sort-Object Name
$items = ($folders | ForEach-Object { $_.Name }) -join "`n"
function Get-Files($pattern) {
  ($folders | ForEach-Object {
    $folder = $_.Name
    Get-ChildItem $_.FullName -File |
      Where-Object { $_.Extension -match $pattern } |
      Sort-Object Name |
      ForEach-Object { "$folder/$($_.Name)" }
  }) -join "`n"
}
$images = Get-Files '^\.(jpe?g|png)$'
$texts = Get-Files '^\.txt$'

Write-Host "source/ -> output/document.pdf"
typst compile --root . --input "items=$items" --input "images=$images" --input "texts=$texts" template.typ output/document.pdf
