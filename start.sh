#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"

if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed. Install it from https://ollama.com/download" >&2
  exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is needed only for the optional sample form server." >&2
  exit 1
fi
if [[ ! -f test/form.html ]]; then
  echo "test/form.html not found; sample form server cannot start." >&2
  exit 1
fi

echo "Checking model..."
if ! ollama list | grep 'qwen2.5:7b' >/dev/null; then
  echo "Model missing. Run: ollama pull qwen2.5:7b" >&2
  exit 1
fi

echo
echo "IMPORTANT: This script does not kill or restart an existing Ollama process."
echo "Configure OLLAMA_ORIGINS for the Ollama process before starting this script."
echo 'For a terminal-launched local server, quit the Ollama app first and run:'
echo '  OLLAMA_ORIGINS="chrome-extension://*,moz-extension://*" ollama serve'
echo "Then, in another terminal, run this script to open the sample form."
echo

python3 -m http.server 8000 --directory test
