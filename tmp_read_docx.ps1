$zip = "docmaestro238.docx"
$tmp = Join-Path (Get-Location) "tmp_docx_extract"
if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
New-Item -ItemType Directory -Path $tmp | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $tmp)
$xml = Join-Path $tmp "word/document.xml"
if (-Not (Test-Path $xml)) { Write-Error "document.xml not found"; exit 1 }
$doc = [xml](Get-Content $xml)
$ns = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
$ns.AddNamespace('w','http://schemas.openxmlformats.org/wordprocessingml/2006/main')
$doc.SelectNodes('//w:t',$ns) | ForEach-Object { $_.'#text' } | Out-String
