<#
    optimizar-imagen.ps1

    Optimiza imagenes para la web: las redimensiona (lado mas largo) y las
    guarda como JPEG con la calidad indicada, manteniendo la proporcion.

    Uso rapido (desde la raiz del proyecto):
      # 1) Una sola imagen -> crea "foto-web.jpg" al lado del original
      powershell -ExecutionPolicy Bypass -File .\herramientas\optimizar-imagen.ps1 "C:\ruta\foto.jpg"

      # 2) Una imagen a una ruta concreta (ej. reemplazar la del sitio)
      powershell -ExecutionPolicy Bypass -File .\herramientas\optimizar-imagen.ps1 "C:\ruta\foto.jpg" "img\galeria\mi-foto.jpg"

      # 3) Una carpeta completa -> crea "carpeta-web" con todo optimizado
      powershell -ExecutionPolicy Bypass -File .\herramientas\optimizar-imagen.ps1 "C:\ruta\fotos" "img\galeria"

    Parametros:
      -Entrada          Archivo o carpeta de origen (obligatorio)
      -Salida           Archivo o carpeta de destino (opcional)
      -MaxLado          Pixeles del lado mas largo (por defecto 1400)
      -Calidad          Calidad JPEG 1-100 (por defecto 82)
      -PermitirAmpliar  Permite agrandar imagenes mas chicas que -MaxLado
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Entrada,

    [Parameter(Position = 1)]
    [string]$Salida,

    [int]$MaxLado = 1400,

    [ValidateRange(1, 100)]
    [int]$Calidad = 82,

    [switch]$PermitirAmpliar
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$extensiones = @('.jpg', '.jpeg', '.png', '.webp', '.bmp', '.gif', '.tif', '.tiff')
$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq 'image/jpeg' }

function Save-Optimizada {
    param([string]$Origen, [string]$Destino)

    $src = New-Object System.Drawing.Bitmap($Origen)
    $anchoOrig = $src.Width
    $altoOrig = $src.Height

    $lado = [Math]::Max($anchoOrig, $altoOrig)
    if ($PermitirAmpliar) {
        $escala = $MaxLado / $lado
    }
    else {
        $escala = [Math]::Min(1.0, $MaxLado / $lado)
    }

    $ancho = [int][Math]::Round($anchoOrig * $escala)
    $alto = [int][Math]::Round($altoOrig * $escala)
    if ($ancho -lt 1) { $ancho = 1 }
    if ($alto -lt 1) { $alto = 1 }

    $bmp = New-Object System.Drawing.Bitmap($ancho, $alto)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::White)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.DrawImage($src, 0, 0, $ancho, $alto)
    $g.Dispose()
    $src.Dispose()

    $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
        [System.Drawing.Imaging.Encoder]::Quality, [long]$Calidad)
    $bmp.Save($Destino, $codec, $ep)
    $ep.Dispose()
    $bmp.Dispose()

    $peso = (Get-Item -LiteralPath $Destino).Length
    [PSCustomObject]@{
        Archivo   = [IO.Path]::GetFileName($Destino)
        Original  = '{0}x{1}' -f $anchoOrig, $altoOrig
        Resultado = '{0}x{1}' -f $ancho, $alto
        Peso      = '{0:N0} KB' -f ($peso / 1kb)
    }
}

$entradaFull = (Resolve-Path -LiteralPath $Entrada).Path

if (Test-Path -LiteralPath $entradaFull -PathType Container) {

    # ----- Modo carpeta -----
    if (-not $Salida) {
        $Salida = $entradaFull.TrimEnd('\', '/') + '-web'
    }
    if (-not [IO.Path]::IsPathRooted($Salida)) {
        $Salida = Join-Path (Get-Location).Path $Salida
    }
    if (-not (Test-Path -LiteralPath $Salida)) {
        New-Item -ItemType Directory -Path $Salida | Out-Null
    }

    $imgs = Get-ChildItem -LiteralPath $entradaFull -File |
        Where-Object { $extensiones -contains $_.Extension.ToLower() }

    if (-not $imgs) {
        Write-Host "No se encontraron imagenes en: $entradaFull" -ForegroundColor Yellow
        return
    }

    $resultados = @()
    foreach ($img in $imgs) {
        $destino = Join-Path $Salida ([IO.Path]::GetFileNameWithoutExtension($img.Name) + '.jpg')
        try {
            $resultados += Save-Optimizada -Origen $img.FullName -Destino $destino
        }
        catch {
            Write-Host ("Omitida (no es una imagen valida): {0}" -f $img.Name) -ForegroundColor Yellow
        }
    }

    if ($resultados.Count -gt 0) {
        $resultados | Format-Table -AutoSize
    }
    Write-Host ("Listo: {0} imagen(es) optimizada(s) en {1}" -f $resultados.Count, $Salida) -ForegroundColor Green
}
else {

    # ----- Modo archivo -----
    if (-not $Salida) {
        $Salida = Join-Path ([IO.Path]::GetDirectoryName($entradaFull)) `
            ([IO.Path]::GetFileNameWithoutExtension($entradaFull) + '-web.jpg')
    }
    elseif (-not [IO.Path]::IsPathRooted($Salida)) {
        $Salida = Join-Path (Get-Location).Path $Salida
    }

    $dirDestino = [IO.Path]::GetDirectoryName($Salida)
    if ($dirDestino -and -not (Test-Path -LiteralPath $dirDestino)) {
        New-Item -ItemType Directory -Path $dirDestino | Out-Null
    }

    $resultado = Save-Optimizada -Origen $entradaFull -Destino $Salida
    $resultado | Format-Table -AutoSize
    Write-Host ("Listo: {0}" -f $Salida) -ForegroundColor Green
}
