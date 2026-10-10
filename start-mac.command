#!/bin/bash
set -Eeuo pipefail
MODEL="qwen2.5:7b"
echo "Fill-Vault — start Ollama on macOS"
if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed. Run setup-mac.command first."
  open "https://ollama.com/download"
  read -r -p "Press Return to close..."
  exit 1
fi
if ! curl --silent --fail http://localhost:11434/api/tags >/dev/null; then
  echo "Opening Ollama..."
  open -a Ollama || true
  for i in {1..30}; do
    if curl --silent --fail http://localhost:11434/api/tags >/dev/null; then break; fi
    sleep 2
  done
fi
if ! curl --silent --fail http://localhost:11434/api/tags >/dev/null; then
  echo "Ollama did not respond. Run setup-mac.command and check OLLAMA_ORIGINS."
  read -r -p "Press Return to close..."
  exit 1
fi
if ! ollama list | grep -F "$MODEL" >/dev/null; then
  echo "Model missing. Run setup-mac.command to download it."
  read -r -p "Press Return to close..."
  exit 1
fi
echo "Ready. Ollama is running locally and $MODEL is installed."
echo "Now open Chrome and use Fill-Vault. Do not expose port 11434 to the internet."
read -r -p "Press Return to close..."
