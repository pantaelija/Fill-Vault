#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"

if [[ ! -f fvai/manifest.json ]]; then
  echo "ERROR: fvai/manifest.json not found. Run from the repository root." >&2
  exit 1
fi

if [[ ! -f fvai/lib/pdf.min.mjs || ! -s fvai/lib/pdf.min.mjs ]]; then
  echo "ERROR: Generated libraries are missing. Run: bash setup.sh" >&2
  exit 1
fi

required=(
  "fvai/lib/pdf.worker.min.mjs"
  "fvai/lib/mammoth.browser.min.js"
  "fvai/lib/tesseract/tesseract.min.js"
  "fvai/lib/tesseract/worker.min.js"
  "fvai/lib/tesseract/lang/eng.traineddata.gz"
)
for file in "${required[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "ERROR: Required file missing or empty: $file" >&2
    echo "Run: bash setup.sh" >&2
    exit 1
  fi
done

if ! compgen -G "fvai/lib/tesseract/tesseract-core*" >/dev/null; then
  echo "ERROR: Tesseract core assets are missing under fvai/lib/tesseract/." >&2
  echo "Run: bash setup.sh" >&2
  exit 1
fi
if ! command -v zip >/dev/null 2>&1; then
  echo "ERROR: zip utility is required to create the release archive." >&2
  exit 1
fi

# Preserve executable bits in the ZIP so macOS/Linux setup launchers work.
chmod +x setup-mac.command setup-linux.sh start-mac.command start-linux.sh
mkdir -p dist
rm -f dist/Fill-Vault.zip
zip -qr dist/Fill-Vault.zip fvai START-HERE.md setup-mac.command setup-linux.sh setup-windows.ps1 start-mac.command start-linux.sh start-windows.ps1

echo "Created dist/Fill-Vault.zip with the extension and cross-platform setup/start scripts."
echo "Before publishing, extract this ZIP into a clean folder and test on macOS, Windows, and Linux."
