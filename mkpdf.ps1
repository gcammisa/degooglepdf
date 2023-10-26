# Prerequisites: base64, sed, convert (ImageMagick)

$PNGHEAD = "data:image/png;base64,"
$JPEGHEAD = "data:image/jpeg;base64,"
$COUNTER = 1
$SKIPEXTRACT = 0

# Get filename
if (-not $args) {
    Write-Host "Usage: $MyInvocation.MyCommand input"
    Write-Host "Where 'input' is the downloaded PDF page archive file name"
    exit 1
}
if (-not (Test-Path $args[0])) {
    Write-Host "Error: File $($args[0]) does not exist!"
    exit 1
}

Write-Host "Processing file: $($args[0])"

# Base file name without extension/spaces
$basename = $args[0] -replace '.imgpack', ''
$basename = $basename -replace ' ', '_'
$dirname = "$basename`_pages"

if (Test-Path $dirname -PathType Container) {
    $choice = Read-Host "It seems '$($args[0])' already has been extracted to '$dirname'. Use existing files? (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        $SKIPEXTRACT = 1
    }
    elseif ($choice -eq "n" -or $choice -eq "N") {
        $SKIPEXTRACT = 0
        Write-Host "Purging existing files."
        Remove-Item "$dirname\*.jpg"
    }
    else {
        Write-Host "Invalid response"
    }
}
else {
    New-Item -ItemType Directory -Path $dirname | Out-Null
}

Set-Location -Path $dirname

if ($SKIPEXTRACT -eq 0) {
    Write-Host -NoNewline "Extracting pages: "

    Get-Content "..\$($args[0])" | ForEach-Object {
        Write-Host -NoNewline "$COUNTER, "
        $padcounter = "{0:D4}" -f $COUNTER
        if ($_ -match $PNGHEAD) {
            $imgdata = $_ -replace $PNGHEAD, ""
            [System.Convert]::FromBase64String($imgdata) | Set-Content -Path "$padcounter.png" -Encoding Byte
            Convert-Image $padcounter.png $padcounter.jpg
            Remove-Item "$padcounter.png"
        }
        if ($_ -match $JPEGHEAD) {
            $imgdata = $_ -replace $JPEGHEAD, ""
            [System.Convert]::FromBase64String($imgdata) | Set-Content -Path "$padcounter.jpg" -Encoding Byte
        }
        $COUNTER++
    }
    Write-Host "done."
}

Write-Host -NoNewline "Generating PDF ..."
& "convert.exe" (Get-ChildItem -File | Sort-Object { [int]$_.BaseName }) "..\$($basename).pdf"
Write-Host "completed!"

Set-Location -Path ..
