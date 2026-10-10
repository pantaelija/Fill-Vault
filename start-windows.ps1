$ErrorActionPreference = "Stop"
$Model = "qwen2.5:7b"
if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "Ollama is not installed. Run setup-windows.ps1 first." -ForegroundColor Yellow
    Start-Process "https://ollama.com/download"
    Read-Host "Press Enter to exit"
    exit 1
}
try {
    $null = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 3
} catch {
    Write-Host "Opening Ollama..."
    $app = Join-Path $env:LOCALAPPDATA "Programs\Ollama\ollama app.exe"
    if (Test-Path $app) { Start-Process $app }
    else { Start-Process "https://ollama.com/download"; Write-Host "Open Ollama from the Start menu, then rerun this script."; Read-Host "Press Enter"; exit 1 }
    $ready = $false
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Seconds 2
        try { $null = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 2; $ready = $true; break } catch {}
    }
    if (-not $ready) { throw "Ollama did not respond. Run setup-windows.ps1 and check OLLAMA_ORIGINS." }
}
$models = & ollama list
if ($LASTEXITCODE -ne 0 -or -not ($models | Select-String -SimpleMatch $Model)) {
    throw "Model missing. Run setup-windows.ps1 to download and verify $Model."
}
Write-Host "Ready. Ollama is running locally and $Model is installed." -ForegroundColor Green
Write-Host "Open Chrome and use Fill-Vault. Do not expose port 11434 to the internet."
Read-Host "Press Enter to close"
