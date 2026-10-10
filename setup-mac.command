#!/bin/bash
set -Eeuo pipefail
cd "$(dirname "$0")"
MODEL="qwen2.5:7b"
ORIGINS="chrome-extension://*,moz-extension://*"

clear
echo "Fill-Vault setup for macOS"
echo "This guided setup uses the official Ollama app and keeps document processing local."
echo

if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed (or Terminal cannot find it yet). Opening the official download page."
  open "https://ollama.com/download"
  echo "Install Ollama from the official site, open it once, then run setup-mac.command again."
  read -r -p "Press Return to close this window..."
  exit 0
fi

echo "Checking Ollama..."
if ! ollama list >/dev/null 2>&1; then
  echo "Ollama is installed but its local service is not responding."
  echo "Open Ollama from Applications and wait for it to finish starting, then run this script again."
  open -a Ollama || true
  read -r -p "Press Return to close this window..."
  exit 1
fi

echo "Downloading/verifying $MODEL. This is several gigabytes and may take a while..."
ollama pull "$MODEL"
echo
echo "Model check:"
ollama list | grep -F "$MODEL" >/dev/null || { echo "Model verification failed." >&2; exit 1; }
echo "Verified: $MODEL"
echo
echo "Configuring Ollama browser access for Chrome/Firefox extensions."
echo "The extension uses localhost only; do not expose Ollama to the public internet."
launchctl setenv OLLAMA_ORIGINS "$ORIGINS"

echo "Restarting the Ollama app so it inherits the allowed-origin setting..."
osascript -e 'tell application "Ollama" to quit' >/dev/null 2>&1 || true
sleep 2
open -a Ollama
echo "Waiting for the local Ollama API..."
for i in {1..30}; do
  if curl --silent --fail http://localhost:11434/api/tags >/dev/null; then
    echo "Ollama API is responding at http://localhost:11434."
    echo
    echo "Next: open Chrome -> chrome://extensions -> Developer mode -> Load unpacked"
    echo "Select the fvai folder (the folder containing manifest.json)."
    echo "If you already loaded Fill-Vault, reload the extension."
    echo "Keep Ollama running while using Fill-Vault."
    read -r -p "Press Return to close this window..."
    exit 0
  fi
  sleep 2
done

echo "Ollama did not respond within 60 seconds. Open the Ollama app and try again."
echo "If the app was already running, quit it completely and rerun this setup."
read -r -p "Press Return to close this window..."
exit 1
