# Creates output\<folder>.pdf for every folder in source\ (Windows PowerShell).
# Usage: powershell -ExecutionPolicy Bypass -File build.ps1
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force output | Out-Null

foreach ($dir in Get-ChildItem source -Directory) {
  $item = $dir.Name
  # image file names, one per line, sorted alphabetically
  $images = (Get-ChildItem $dir.FullName -File |
    Where-Object { $_.Extension -match '^\.(jpe?g|png)$' } |
    Sort-Object Name |
    ForEach-Object { $_.Name }) -join "`n"
  Write-Host "source/$item -> output/$item.pdf"
  typst compile --root . --input "item=$item" --input "images=$images" template.typ "output/$item.pdf"
}
