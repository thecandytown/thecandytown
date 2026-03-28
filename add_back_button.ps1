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

    $target = "<!-- Brand -->"
    $replacement = @"
<!-- Mobile Back Button -->
        <a href="index.html" class="md:hidden flex items-center justify-center text-brand-brown p-1 hover:scale-110 transition mr-2 shrink-0" aria-label="Go back">
          <i data-lucide="arrow-left" class="w-6 h-6"></i>
        </a>

        <!-- Brand -->
"@

    if ($content -notmatch "<!-- Mobile Back Button -->") {
        $content = $content.Replace($target, $replacement)
        [System.IO.File]::WriteAllText("$pwd\$f", $content, [System.Text.Encoding]::UTF8)
        Write-Host "Added Back Button to $f"
    } else {
        Write-Host "Back Button already exists in $f"
    }
}
