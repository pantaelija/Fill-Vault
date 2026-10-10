#!/usr/bin/env bash
set -Eeuo pipefail
MODEL="qwen2.5:7b"
ORIGINS="chrome-extension://*,moz-extension://*"
if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed. Follow https://ollama.com/download and rerun setup-linux.sh." >&2
  exit 1
fi
if ! ollama list >/dev/null 2>&1; then
  echo "Starting local Ollama server. Keep this terminal open while using Fill-Vault."
  echo "Press Ctrl+C to stop the server."
  export OLLAMA_ORIGINS="$ORIGINS"
  exec ollama serve
fi
if ! curl --silent --fail http://localhost:11434/api/tags >/dev/null; then
  echo "Ollama CLI responded but the local API did not. Check your Ollama service." >&2
  exit 1
fi
if ! ollama list | grep -F "$MODEL" >/dev/null; then
  echo "Model missing. Run bash setup-linux.sh." >&2
  exit 1
fi
echo "Ollama is already running. Confirm its service has OLLAMA_ORIGINS configured."
echo "If Fill-Vault cannot connect, configure the service environment as described in START-HERE.md."
echo "Keep Ollama bound to localhost; do not expose port 11434 to the internet."
