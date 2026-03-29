$files = Get-ChildItem -Filter *.html
foreach ($file in $files) {
    if (-not (Test-Path $file.FullName)) { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)

    if ($content -notmatch 'rel="icon"') {
        $faviconLink = "`n    <link rel=""icon"" type=""image/png"" href=""./favicon.png"">`n</head>"
        $content = $content.Replace("</head>", $faviconLink)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Injected favicon into $($file.Name)"
    } else {
        Write-Host "Favicon already exists in $($file.Name). Replacing."
        $content = [regex]::Replace($content, '<link[^>]*rel="icon"[^>]*>', '<link rel="icon" type="image/png" href="./favicon.png">')
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
    }
}
