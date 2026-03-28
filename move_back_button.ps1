$files = @(
    "bachpan-ki-yaadein.html",
    "candy-floss.html",
    "chana-jor-garam.html",
    "chocolate-fountain.html",
    "cupcakes.html",
    "french-fries.html",
    "ice-gola.html",
    "masala-sweet-corn.html",
    "popcorn.html",
    "potato-twister.html",
    "tangy-maggie.html",
    "waffle-stall.html"
)

foreach ($f in $files) {
    if (-not (Test-Path $f)) { continue }
    $content = [System.IO.File]::ReadAllText("$pwd\$f", [System.Text.Encoding]::UTF8)

    # 1. Remove it from the Nav
    $navPattern = '(?s)<!-- Mobile Back Button -->\s*<a href="index\.html" class="md:hidden flex items-center justify-center text-brand-brown p-1 hover:scale-110 transition mr-2 shrink-0" aria-label="Go back">\s*<i data-lucide="arrow-left" class="w-6 h-6"></i>\s*</a>\s*'
    $content = [regex]::Replace($content, $navPattern, '')

    # 2. Insert it just inside <main ...>
    # Make sure we don't insert it twice!
    if ($content -notmatch '<!-- Mobile Back Button Below Nav -->') {
        $mainPattern = '(?s)(<main\s+class="[^"]*?")\s*>'
        $evalMain = [System.Text.RegularExpressions.MatchEvaluator] {
            param($m)
            $mainTag = $m.Groups[1].Value
            return @"
$mainTag>
      <!-- Mobile Back Button Below Nav -->
      <a href="index.html" class="md:hidden inline-flex items-center text-brand-brown font-bold text-xs uppercase tracking-widest bg-white/50 px-4 py-2 border border-brand-brown/10 rounded-full shadow-sm mb-6 w-max -mt-4">
        <i data-lucide="arrow-left" class="w-4 h-4 mr-2"></i> Back to Main
      </a>
"@
        }
        $content = [regex]::Replace($content, $mainPattern, $evalMain)
        [System.IO.File]::WriteAllText("$pwd\$f", $content, [System.Text.Encoding]::UTF8)
        Write-Host "Moved Back Button in $f"
    } else {
        Write-Host "Already moved in $f"
    }
}
