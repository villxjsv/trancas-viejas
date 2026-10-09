<#
    revisar-imagenes.ps1

    Revisa todas las imagenes del sitio y avisa cuales tienen poca resolucion
    (lado mas largo por debajo del minimo), para saber cuales conviene mejorar.

    Uso (desde la raiz del proyecto):
      powershell -ExecutionPolicy Bypass -File .\herramientas\revisar-imagenes.ps1
      powershell -ExecutionPolicy Bypass -File .\herramientas\revisar-imagenes.ps1 -Minimo 1000
#>
[CmdletBinding()]
param(
    [string]$Carpeta,

    [int]$Minimo = 900
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

# Por defecto revisamos la carpeta "img" del proyecto (un nivel arriba de
# esta carpeta "herramientas").
if (-not $Carpeta) {
    $baseScript = Split-Path -Parent $MyInvocation.MyCommand.Path
    $raizProyecto = Split-Path -Parent $baseScript
    $Carpeta = Join-Path $raizProyecto 'img'
}

$extensiones = @('.jpg', '.jpeg', '.png', '.webp', '.bmp')
$carpetaFull = (Resolve-Path -LiteralPath $Carpeta).Path

$archivos = Get-ChildItem -LiteralPath $carpetaFull -Recurse -File |
    Where-Object { $extensiones -contains $_.Extension.ToLower() }

$filas = foreach ($f in $archivos) {
    $im = New-Object System.Drawing.Bitmap($f.FullName)
    $ancho = $im.Width
    $alto = $im.Height
    $im.Dispose()

    $lado = [Math]::Max($ancho, $alto)
    [PSCustomObject]@{
        Imagen     = $f.FullName.Substring($carpetaFull.Length).TrimStart('\', '/')
        Tamano     = '{0}x{1}' -f $ancho, $alto
        Lado       = $lado
        PesoKB     = [int]($f.Length / 1kb)
        Mejorable  = ($lado -lt $Minimo)
    }
}

$filas = $filas | Sort-Object Lado

Write-Host ''
Write-Host ('=== Imagenes con lado mas largo menor a {0} px ===' -f $Minimo) -ForegroundColor Cyan
$chicas = $filas | Where-Object { $_.Mejorable }
if ($chicas) {
    $chicas | Format-Table Imagen, Tamano, PesoKB -AutoSize
}
else {
    Write-Host '  (ninguna: todas tienen buena resolucion)' -ForegroundColor Green
}

Write-Host ''
Write-Host ('Total de imagenes: {0}' -f $filas.Count)
Write-Host ('Peso total: {0:N0} KB' -f ($filas | Measure-Object PesoKB -Sum).Sum)
