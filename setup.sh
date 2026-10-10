#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p fvai/lib/tesseract/lang
[ -f package.json ] || npm init -y >/dev/null
npm i pdfjs-dist@4.10.38 mammoth@1.8.0 tesseract.js@5.1.1 @tesseract.js-data/eng
cp node_modules/pdfjs-dist/legacy/build/pdf.min.mjs node_modules/pdfjs-dist/legacy/build/pdf.worker.min.mjs fvai/lib/
cp node_modules/mammoth/mammoth.browser.min.js fvai/lib/
cp node_modules/tesseract.js/dist/tesseract.min.js node_modules/tesseract.js/dist/worker.min.js fvai/lib/tesseract/
cp node_modules/tesseract.js-core/tesseract-core*.js fvai/lib/tesseract/
LANG_FILE=$(find node_modules/@tesseract.js-data/eng -name 'eng.traineddata.gz' | sort | grep best_int | head -1)
[ -n "$LANG_FILE" ] || LANG_FILE=$(find node_modules/@tesseract.js-data/eng -name 'eng.traineddata.gz' | head -1)
cp "$LANG_FILE" fvai/lib/tesseract/lang/eng.traineddata.gz
echo "Libraries copied:"
ls fvai/lib fvai/lib/tesseract fvai/lib/tesseract/lang
