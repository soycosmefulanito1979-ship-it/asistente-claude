$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$assetsRoot = Join-Path $scriptRoot '..\..\assets'
$paperPath = Join-Path $assetsRoot 'paper_texture.png'
$grainPath = Join-Path $assetsRoot 'film_grain.png'
$imagesRoot = Join-Path $scriptRoot 'images'

if (-not (Test-Path $imagesRoot)) { New-Item -ItemType Directory -Path $imagesRoot | Out-Null }

$posts = @(
    [pscustomobject]@{ Name='lunes.png'; Width=1080; Height=1920; Text='El silencio no siempre es ausencia.'; Tag='Historia de un amor inconcluso' },
    [pscustomobject]@{ Name='martes.png'; Width=1080; Height=1080; Text='3 razones por las que esto dolió.'; Tag='Análisis de personaje' },
    [pscustomobject]@{ Name='miercoles.png'; Width=1080; Height=1920; Text='Escribir es recordar.'; Tag='Detrás de escena' },
    [pscustomobject]@{ Name='jueves.png'; Width=1080; Height=1350; Text='¿Alguna vez sentiste que todo terminó?'; Tag='Frase impactante' },
    [pscustomobject]@{ Name='viernes.png'; Width=1080; Height=1920; Text='Lo que nadie te dice de volver a empezar.'; Tag='Amor y pérdida' },
    [pscustomobject]@{ Name='sabado.png'; Width=1080; Height=1080; Text='Mapa de la Italia que nadie conoce.'; Tag='Ambientación italiana' },
    [pscustomobject]@{ Name='domingo.png'; Width=1080; Height=1920; Text='El final que no viste venir.'; Tag='Teaser trailer' }
)

$paper = if (Test-Path $paperPath) { [System.Drawing.Bitmap]::FromFile($paperPath) } else { $null }
$grain = if (Test-Path $grainPath) { [System.Drawing.Bitmap]::FromFile($grainPath) } else { $null }

foreach ($post in $posts) {
    $width = [int]$post.Width
    $height = [int]$post.Height
    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $rect = New-Object System.Drawing.Rectangle 0,0,$width,$height
    $colorTop = [System.Drawing.Color]::FromArgb(255, 26, 26, 26)
    $colorBottom = [System.Drawing.Color]::FromArgb(255, 212, 175, 55)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $colorTop, $colorBottom, [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
    $g.FillRectangle($bgBrush, $rect)
    $bgBrush.Dispose()

    $overlayColor = [System.Drawing.Color]::FromArgb(32, 0, 0, 0)
    $g.FillRectangle((New-Object System.Drawing.SolidBrush $overlayColor), 0, 0, $width, $height)

    if ($paper) {
        $attr = New-Object System.Drawing.Imaging.ImageAttributes
        $matrix = New-Object System.Drawing.Imaging.ColorMatrix
        $matrix.Matrix33 = 0.08
        $attr.SetColorMatrix($matrix)
        $g.DrawImage($paper, $rect, 0, 0, $paper.Width, $paper.Height, [System.Drawing.GraphicsUnit]::Pixel, $attr)
        $attr.Dispose()
    }

    if ($grain) {
        $attr2 = New-Object System.Drawing.Imaging.ImageAttributes
        $matrix2 = New-Object System.Drawing.Imaging.ColorMatrix
        $matrix2.Matrix33 = 0.06
        $attr2.SetColorMatrix($matrix2)
        $g.DrawImage($grain, $rect, 0, 0, $grain.Width, $grain.Height, [System.Drawing.GraphicsUnit]::Pixel, $attr2)
        $attr2.Dispose()
    }

    $titleFont = New-Object System.Drawing.Font('Georgia', [math]::Max(48, [math]::Round($width / 18)), [System.Drawing.FontStyle]::Bold)
    $subtitleFont = New-Object System.Drawing.Font('Arial', 26, [System.Drawing.FontStyle]::Regular)

    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center

    $titleRect = [System.Drawing.RectangleF]::new(120, 120, $width - 240, $height * 0.45)
    $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(140, 0, 0, 0))
    $g.DrawString($post.Text, $titleFont, $shadowBrush, [System.Drawing.RectangleF]::new($titleRect.X + 6, $titleRect.Y + 6, $titleRect.Width, $titleRect.Height), $format)
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString($post.Text, $titleFont, $titleBrush, $titleRect, $format)

    $subtitleRect = [System.Drawing.RectangleF]::new(120, $height * 0.62, $width - 240, $height * 0.16)
    $subtitleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 212, 175, 55))
    $g.DrawString($post.Tag, $subtitleFont, $subtitleBrush, $subtitleRect, $format)

    $titleFont.Dispose()
    $subtitleFont.Dispose()
    $titleBrush.Dispose()
    $shadowBrush.Dispose()
    $g.Dispose()

    $bmp.Save((Join-Path $imagesRoot $post.Name), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Created $($post.Name)"
}

if ($paper) { $paper.Dispose() }
if ($grain) { $grain.Dispose() }
Write-Host 'All images generated.'
