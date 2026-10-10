#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")"

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  echo "ERROR: Node.js and npm are required to prepare the extension libraries." >&2
  echo "Install a current Node.js LTS release, then run this script again." >&2
  exit 1
fi

if [[ ! -f fvai/manifest.json ]]; then
  echo "ERROR: fvai/manifest.json not found. Run this from the Fill-Vault repository." >&2
  exit 1
fi

if [[ -f package-lock.json ]]; then
  echo "==> Installing exact dependencies from package-lock.json..."
  npm ci
else
  echo "WARNING: package-lock.json is missing; dependency versions may not be reproducible." >&2
  npm install
fi

mkdir -p fvai/lib/tesseract/lang

copy_required() {
  local src="$1"
  local dest="$2"
  if [[ ! -s "$src" ]]; then
    echo "ERROR: Required dependency file missing: $src" >&2
    exit 1
  fi
  cp "$src" "$dest"
}

echo "==> Preparing PDF.js..."
copy_required "node_modules/pdfjs-dist/legacy/build/pdf.min.mjs" "fvai/lib/pdf.min.mjs"
copy_required "node_modules/pdfjs-dist/legacy/build/pdf.worker.min.mjs" "fvai/lib/pdf.worker.min.mjs"

echo "==> Preparing Mammoth..."
copy_required "node_modules/mammoth/mammoth.browser.min.js" "fvai/lib/mammoth.browser.min.js"

echo "==> Preparing Tesseract.js..."
copy_required "node_modules/tesseract.js/dist/tesseract.min.js" "fvai/lib/tesseract/tesseract.min.js"
copy_required "node_modules/tesseract.js/dist/worker.min.js" "fvai/lib/tesseract/worker.min.js"

shopt -s nullglob
core_files=(node_modules/tesseract.js-core/tesseract-core*)
if (( ${#core_files[@]} == 0 )); then
  echo "ERROR: Tesseract.js core assets were not found." >&2
  exit 1
fi
cp "${core_files[@]}" fvai/lib/tesseract/

lang_file=""
while IFS= read -r candidate; do
  if [[ "$candidate" == *best_int* ]]; then
    lang_file="$candidate"
    break
  fi
  [[ -n "$lang_file" ]] || lang_file="$candidate"
done < <(find node_modules/@tesseract.js-data/eng -name 'eng.traineddata.gz' -type f | sort)

if [[ -z "$lang_file" || ! -s "$lang_file" ]]; then
  echo "ERROR: English Tesseract trained data was not found." >&2
  exit 1
fi
cp "$lang_file" fvai/lib/tesseract/lang/eng.traineddata.gz

echo "==> Required libraries prepared."
find fvai/lib -type f -print | sort
