$ErrorActionPreference = "Stop"

$installDir = Join-Path $env:LOCALAPPDATA "Programs\Curl2Browser"
$binDir = Join-Path $installDir "bin"

try {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $pathEntries = @($userPath -split ";" | Where-Object { $_ })

    $filteredPath = @(
        $pathEntries | Where-Object {
            $_.TrimEnd("\") -ine $binDir.TrimEnd("\")
        }
    )

    if ($filteredPath.Count -ne $pathEntries.Count) {
        [Environment]::SetEnvironmentVariable(
            "Path",
            ($filteredPath -join ";"),
            "User"
        )
    }

    if (Test-Path $installDir) {
        Remove-Item -LiteralPath $installDir -Recurse -Force
    }

    Write-Host "Curl2Browser has been uninstalled." -ForegroundColor Green
    Write-Host "Open a new terminal to refresh PATH."
}
catch {
    Write-Host "Uninstallation failed: $_" -ForegroundColor Red
    exit 1
}
