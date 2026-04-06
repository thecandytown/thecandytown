# Comprehensive fix for ALL corrupted Unicode characters across all product pages
# The ✕ close button, smart quotes, and smart apostrophes were corrupted by encoding issues

$files = @(
    'tangy-maggie.html',
    'candy-floss.html', 
    'chocolate-fountain.html',
    'popcorn.html',
    'potato-twister.html',
    'waffle-stall.html',
    'ice-gola.html',
    'masala-sweet-corn.html',
    'chana-jor-garam.html',
    'bachpan-ki-yaadein.html',
    'french-fries.html',
    'cupcakes.html'
)

foreach ($f in $files) {
    $path = Join-Path 'c:\Users\Shree\Desktop\thecandytown' $f
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    
    $count = 0
    
    # 1. Fix corrupted close button: the ✕ character became ?
    # Pattern: the ? sits alone on a line inside a close button
    # We need to be careful to only replace ? that is the close button text
    # The pattern is: ">?\n" inside a button with closeBubble
    # Using regex-safe approach: look for lines with just whitespace + ?
    $lines = $content -split "`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $trimmed = $lines[$i].Trim()
        if ($trimmed -eq '?') {
            # Check if previous lines contain closeBubble or close button context
            $contextFound = $false
            for ($j = [Math]::Max(0, $i - 3); $j -lt $i; $j++) {
                if ($lines[$j] -match 'closeBubble|close-btn|shadow-lg') {
                    $contextFound = $true
                    break
                }
            }
            if ($contextFound) {
                $lines[$i] = $lines[$i].Replace('?', '&#10005;')
                $count++
            }
        }
    }
    $content = $lines -join "`n"
    
    # 2. Fix corrupted smart quotes: "text" became ?text?
    # Common patterns in descriptions
    $content = $content.Replace('?Maggie?', '&ldquo;Maggie&rdquo;')
    if ($content -ne $content) { $count++ }
    
    # 3. Fix corrupted smart apostrophes: it's became it?s, everyone's -> everyone?s
    # These are tricky - only replace in text content context, not in JS/URLs
    $content = $content.Replace('everyone?s', "everyone's")
    $content = $content.Replace('that?s', "that's")
    $content = $content.Replace('it?s', "it's")
    $content = $content.Replace('It?s', "It's")
    $content = $content.Replace('don?t', "don't")
    $content = $content.Replace('won?t', "won't")
    $content = $content.Replace('can?t', "can't")
    $content = $content.Replace('we?re', "we're")
    $content = $content.Replace('We?re', "We're")
    $content = $content.Replace('you?re', "you're")
    $content = $content.Replace('they?re', "they're")
    $content = $content.Replace('there?s', "there's")
    $content = $content.Replace('here?s', "here's")
    $content = $content.Replace('let?s', "let's")
    $content = $content.Replace('Let?s', "Let's")
    $content = $content.Replace('what?s', "what's")
    $content = $content.Replace('wasn?t', "wasn't")
    $content = $content.Replace('isn?t', "isn't")
    $content = $content.Replace('Kid?s', "Kid's")
    $content = $content.Replace('guest?s', "guest's")
    
    # 4. Fix corrupted em-dash: — became ?
    # This is harder to detect automatically, skip for safety
    
    # Save with UTF-8 BOM
    $utf8 = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText($path, $content, $utf8)
    
    Write-Host "Fixed $f ($count close-button replacements + text fixes)"
}
