$ErrorActionPreference = "Stop"
$Model = "qwen2.5:7b"

Write-Host ""
Write-Host "Fill-Vault setup for Windows" -ForegroundColor Cyan
Write-Host "This guided setup uses the official Ollama installer. It does not download or execute third-party scripts."
Write-Host ""

$Ollama = Get-Command ollama -ErrorAction SilentlyContinue
if (-not $Ollama) {
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
    Write-Host "Open Ollama from the Start menu, wait for it to start, then run this script again."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Downloading/verifying $Model. This is several gigabytes and may take a while..." -ForegroundColor Cyan
& ollama pull $Model
if ($LASTEXITCODE -ne 0) { throw "Model download failed. Check your internet connection and try again." }
$Models = & ollama list
if (-not ($Models | Select-String -SimpleMatch $Model)) { throw "Model verification failed: $Model is not listed by Ollama." }
Write-Host "Verified: $Model" -ForegroundColor Green
Write-Host ""
Write-Host "Browser access setup:" -ForegroundColor Cyan
Write-Host "1. Fully quit Ollama from its system-tray menu (not just close its window)."
Write-Host "2. In PowerShell, run this command to set the allowed origins for your Windows user:"
Write-Host '   [Environment]::SetEnvironmentVariable("OLLAMA_ORIGINS", "chrome-extension://*,moz-extension://*", "User")'
Write-Host "3. Start Ollama again from the Start menu. If it does not inherit the setting, sign out and back in, then start it."
Write-Host "4. Open Chrome -> chrome://extensions -> Developer mode -> Load unpacked -> select the fvai folder."
Write-Host ""
Write-Host "Fill-Vault sends model requests to Ollama on your own computer. Do not expose port 11434 to the public internet."
Read-Host "Press Enter to close"
