$ErrorActionPreference = 'Stop'
$width = 2000
$height = 2000
Add-Type -AssemblyName System.Drawing

# Ensure assets directory exists
$assetsDir = Join-Path $PSScriptRoot ''
if (-not (Test-Path -Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir | Out-Null }

# film_grain.png (noise)
$filmPath = Join-Path $assetsDir 'film_grain.png'
$bmp = New-Object System.Drawing.Bitmap $width, $height
$rand = New-Object System.Random
for ($y=0; $y -lt $height; $y++) {
    for ($x=0; $x -lt $width; $x+=4) {
        if ($rand.NextDouble() -lt 0.018) { # sparse noise
            $alpha = [int]($rand.Next(4,16))
            $color = [System.Drawing.Color]::FromArgb($alpha, 0, 0, 0)
            $bmp.SetPixel($x, $y, $color)
        }
    }
}
$bmp.Save($filmPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

# paper_texture.png (cream gradient + subtle noise)
$paperPath = Join-Path $assetsDir 'paper_texture.png'
$bmp2 = New-Object System.Drawing.Bitmap $width, $height
$g = [System.Drawing.Graphics]::FromImage($bmp2)
$color1 = [System.Drawing.Color]::FromArgb(255, 246, 240, 232)
$color2 = [System.Drawing.Color]::FromArgb(255, 242, 233, 225)
$rect = New-Object System.Drawing.Rectangle 0,0,$width,$height
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $color1, $color2, [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal)
$g.FillRectangle($brush, $rect)
$brush.Dispose()

for ($i=0; $i -lt 140000; $i++) {
    $x = $rand.Next(0, $width)
    $y = $rand.Next(0, $height)
    $alpha = [int]($rand.Next(3,10))
    $c = [System.Drawing.Color]::FromArgb($alpha, 0, 0, 0)
    $bmp2.SetPixel($x, $y, $c)
}

$g.Dispose()
$bmp2.Save($paperPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp2.Dispose()

Write-Host "Generated: $filmPath`nGenerated: $paperPath"