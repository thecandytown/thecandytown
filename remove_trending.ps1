$removeFiles = @(
    "bachpan-ki-yaadein.html",
    "chana-jor-garam.html",
    "cupcakes.html",
    "french-fries.html",
    "ice-gola.html",
    "masala-sweet-corn.html",
    "potato-twister.html",
    "tangy-maggie.html",
    "waffle-stall.html"
)

foreach ($f in $removeFiles) {
    if (-not (Test-Path $f)) { continue }
    $content = [System.IO.File]::ReadAllText("$pwd\$f", [System.Text.Encoding]::UTF8)

    $pattern = '(?s)\s*<span class="inline-flex items-center gap-1\.5 px-3 py-1 pb-1\.5 rounded-full bg-red-100 text-red-600 font-bold text-xs uppercase tracking-widest border border-red-200 shadow-sm animate-pulse">\s*<span>(?:&#128293;|🔥)</span>\s*Trending - High Demand\s*</span>'

    if ($content -match $pattern) {
        $content = [regex]::Replace($content, $pattern, '')
        [System.IO.File]::WriteAllText("$pwd\$f", $content, [System.Text.Encoding]::UTF8)
        Write-Host "Removed trending tag from $f"
    } else {
        Write-Host "Trending tag not found in $f"
    }
}
