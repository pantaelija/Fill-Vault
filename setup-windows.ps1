$ErrorActionPreference = "Stop"
$Model = "qwen2.5:7b"
$Origins = "chrome-extension://*,moz-extension://*"

Write-Host ""
Write-Host "Fill-Vault setup for Windows" -ForegroundColor Cyan
Write-Host "This setup uses the official Ollama installer. It does not download or execute third-party install scripts."
Write-Host ""

if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Write-Host "Ollama is not installed or is not yet on PATH."
    Start-Process "https://ollama.com/download"
    Write-Host "Install Ollama from the official site, open it once, then close and reopen PowerShell."
    Read-Host "Press Enter to exit"
    exit 0
}

try {
    & ollama list | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Ollama service is unavailable" }
} catch {
    Write-Host "Ollama is installed but its local service is not responding." -ForegroundColor Yellow
    Write-Host "Open Ollama from the Start menu, wait for it to start, then rerun this setup."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Downloading/verifying $Model. This is several gigabytes and may take a while..." -ForegroundColor Cyan
& ollama pull $Model
if ($LASTEXITCODE -ne 0) { throw "Model download failed. Check your internet connection and try again." }
$Models = & ollama list
if ($LASTEXITCODE -ne 0 -or -not ($Models | Select-String -SimpleMatch $Model)) {
    throw "Model verification failed: $Model is not listed by Ollama."
}
Write-Host "Verified: $Model" -ForegroundColor Green
Write-Host ""
Write-Host "To enable browser access, Fill-Vault will set OLLAMA_ORIGINS for your Windows user."
[Environment]::SetEnvironmentVariable("OLLAMA_ORIGINS", $Origins, "User")
$env:OLLAMA_ORIGINS = $Origins
Write-Host ""
Write-Host "Now fully quit Ollama from its system-tray menu. This is important so the next process reads the new setting."
Read-Host "After quitting Ollama, press Enter here to relaunch it"
$appCandidates = @(
    (Join-Path $env:LOCALAPPDATA "Programs\Ollama\ollama app.exe"),
    (Join-Path $env:LOCALAPPDATA "Ollama\ollama app.exe")
)
$app = $appCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($app) {
    Start-Process -FilePath $app
} else {
    Write-Host "Could not find the Ollama desktop app in its usual locations." -ForegroundColor Yellow
    Write-Host "Open Ollama from the Start menu after fully quitting it. If the setting is not picked up, sign out and back in first."
}
Write-Host "Waiting for the local Ollama API..."
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 2
    try { $null = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -TimeoutSec 2; $ready = $true; break } catch {}
}
if ($ready) {
    Write-Host "Ollama API is responding." -ForegroundColor Green
} else {
    Write-Host "Ollama has not responded yet. Open it manually and rerun start-windows.ps1." -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Next: Chrome -> chrome://extensions -> Developer mode -> Load unpacked -> select the fvai folder."
Write-Host "Fill-Vault uses Ollama on this computer. Never expose port 11434 to the public internet."
Read-Host "Press Enter to close"
