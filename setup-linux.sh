#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"
MODEL="qwen2.5:7b"
ORIGINS="chrome-extension://*,moz-extension://*"

echo "Fill-Vault setup for Linux"
echo "This script does not run remote install scripts or use sudo."
echo
if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed. Install it using the official instructions:"
  echo "  https://ollama.com/download"
  echo "Then start Ollama and run this script again."
  exit 1
fi
if ! ollama list >/dev/null 2>&1; then
  echo "Ollama is installed but not running. Start your Ollama service, then rerun this script."
  echo "Official help: https://github.com/ollama/ollama/blob/main/docs/linux.md"
  exit 1
fi

echo "Downloading/verifying $MODEL. This is several gigabytes and may take a while..."
ollama pull "$MODEL"
ollama list | grep -F "$MODEL" >/dev/null || { echo "Model verification failed." >&2; exit 1; }
echo "Verified: $MODEL"
echo
echo "To allow your browser extension, OLLAMA_ORIGINS must be set on the Ollama service."
echo "For a temporary foreground session, stop the existing Ollama service first, then run:"
printf '  OLLAMA_ORIGINS="%s" ollama serve\n' "$ORIGINS"
echo "Keep that terminal open while using Fill-Vault."
echo "For persistent setup, configure OLLAMA_ORIGINS in your systemd service override"
echo "and restart the service; see the Ollama Linux documentation."
echo
echo "Do not expose port 11434 to the public internet."
