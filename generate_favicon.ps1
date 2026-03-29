Add-Type -AssemblyName System.Drawing
$imgPath = "c:\Users\Shree\Desktop\thecandytown\images\Candy_Town_Logo.png"
if (-not (Test-Path $imgPath)) {
    Write-Host "Logo not found"
    exit
}
$img = [System.Drawing.Image]::FromFile($imgPath)

# Find bounding box for circle (assuming white is background)
# A simple way to just crop to circle using the image's shortest dimension.
$size = [math]::Min($img.Width, $img.Height)

# Sometimes there's white padding. Let's assume a 2% inner padding so we don't accidentally clip the colored border
$padding = [int]($size * 0.02)
$clipSize = $size - ($padding * 2)

$x = ($img.Width - $clipSize) / 2
$y = ($img.Height - $clipSize) / 2

$targetSize = 128
$bmp = New-Object System.Drawing.Bitmap($targetSize, $targetSize)
$bmp.MakeTransparent()

$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.Clear([System.Drawing.Color]::Transparent)

$path = New-Object System.Drawing.Drawing2D.GraphicsPath
# Ellipse slightly inside to avoid any halo artifact
$path.AddEllipse(1, 1, $targetSize - 2, $targetSize - 2)
$g.SetClip($path)

$srcRect = New-Object System.Drawing.Rectangle($x, $y, $clipSize, $clipSize)
$destRect = New-Object System.Drawing.Rectangle(0, 0, $targetSize, $targetSize)
$g.DrawImage($img, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

$faviconPath = "c:\Users\Shree\Desktop\thecandytown\favicon.png"
$bmp.Save($faviconPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
$img.Dispose()

Write-Host "Favicon created at $faviconPath"
