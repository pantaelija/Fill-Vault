#!/bin/bash
cd "$(dirname "$0")"
pkill -f Ollama; pkill ollama; sleep 2
export OLLAMA_ORIGINS="chrome-extension://*,safari-web-extension://*,moz-extension://*"
(cd test && python3 -m http.server 8000 >/dev/null 2>&1 &)
trap 'pkill -f "http.server 8000"' EXIT
open -a "Brave Browser" "http://localhost:8000/form.html"
ollama serve
