$ErrorActionPreference = "Stop"

$repo = "https://codeload.github.com/AmirSarani/Curl2Browser/zip/refs/heads/main"
$installDir = Join-Path $env:LOCALAPPDATA "Programs\Curl2Browser"
$binDir = Join-Path $installDir "bin"
$tempDir = Join-Path $env:TEMP ("Curl2Browser-" + [guid]::NewGuid().ToString("N"))
$zipFile = Join-Path $tempDir "source.zip"

try {
    $nodeCommand = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeCommand) {
        throw "Node.js 18 or newer is required: https://nodejs.org/"
    }

    $nodeVersionText = (& node -p "process.versions.node").Trim()
    if ([version]$nodeVersionText -lt [version]"18.0.0") {
        throw "Node.js 18 or newer is required. Detected: $nodeVersionText"
    }

    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        throw "npm is missing. Reinstall Node.js and try again."
    }

    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

    Write-Host "Downloading Curl2Browser..."
    Invoke-WebRequest -Uri $repo -OutFile $zipFile
    Expand-Archive -LiteralPath $zipFile -DestinationPath $tempDir -Force

    $sourceDir = Join-Path $tempDir "Curl2Browser-main"
    foreach ($requiredFile in @("curlp.js", "package.json", "package-lock.json")) {
        if (-not (Test-Path (Join-Path $sourceDir $requiredFile))) {
            throw "Required project file is missing: $requiredFile"
        }
    }

    New-Item -ItemType Directory -Force -Path $installDir, $binDir | Out-Null

    Get-ChildItem -LiteralPath $sourceDir -Force |
        Copy-Item -Destination $installDir -Recurse -Force

    Write-Host "Installing dependencies..."
    Push-Location $installDir
    try {
        npm ci --omit=dev
        if ($LASTEXITCODE -ne 0) {
            throw "Dependency installation failed with exit code $LASTEXITCODE."
        }
    }
    finally {
        Pop-Location
    }

    $wrapper = Join-Path $binDir "curlp.cmd"
    $wrapperContent = "@echo off`r`nnode `"%~dp0..\curlp.js`" %*`r`n"
    [System.IO.File]::WriteAllText(
        $wrapper,
        $wrapperContent,
        [System.Text.Encoding]::ASCII
    )

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $pathEntries = @($userPath -split ";" | Where-Object { $_ })

    if (-not ($pathEntries | Where-Object { $_.TrimEnd("\") -ieq $binDir.TrimEnd("\") })) {
        $newPath = (@($pathEntries) + $binDir) -join ";"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    }

    if (-not ($env:Path -split ";" | Where-Object { $_.TrimEnd("\") -ieq $binDir.TrimEnd("\") })) {
        $env:Path = "$binDir;$env:Path"
    }

    Write-Host ""
    Write-Host "Curl2Browser installed successfully." -ForegroundColor Green
    Write-Host "Try: curlp https://example.com"
    Write-Host "Google Chrome or a compatible Playwright browser is required."
}
catch {
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
}
finally {
    if (Test-Path $tempDir) {
        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
