# Fill-Vault

**Fill out web forms with help from your own documents — while keeping control of every value.**

Fill-Vault is a browser extension powered by the open-source `qwen2.5:7b` model running locally through Ollama. It extracts facts from documents, suggests matching form fields, and shows source evidence so you can review each suggestion. It never submits a form for you.

- **Download:** [GitHub Releases](https://github.com/pantaelija/Fill-Vault/releases) — choose `Fill-Vault.zip` from the latest release.
- **Install help:** follow the beginner steps below.
- **Issues and help:** [Report a problem or ask a question](https://github.com/pantaelija/Fill-Vault/issues).
- **Contributing:** see [Contributing](CONTRIBUTING.md).

## What you need

- Google Chrome or a compatible Chromium browser
- [Ollama](https://ollama.com/download)
- The `qwen2.5:7b` model in Ollama
- Internet access for the initial Ollama model download
- Sufficient memory and disk space for the model

**End users installing a prepared release ZIP do not need Node.js, npm, Git, or Python.** Those tools are only needed to build from source or run the optional local test form.

The model is downloaded separately; it is not included in this repository or the extension ZIP.

## Install Fill-Vault (beginner-friendly)

1. Open the project's [GitHub Releases](https://github.com/pantaelija/Fill-Vault/releases) page.
2. Download `Fill-Vault.zip` from the release assets and extract it to a permanent folder.
3. Install Ollama from https://ollama.com/download.
4. Open Terminal (macOS/Linux) or PowerShell (Windows) and run:

   ```bash
   ollama pull qwen2.5:7b
   ollama list
   ```

   Confirm `qwen2.5:7b` appears in the list. Test it with `ollama run qwen2.5:7b`, then type `/bye` to exit.

5. Configure Ollama to allow requests from the extension. The exact method depends on how Ollama was installed and launched. See **Configure browser access to Ollama** below.
6. In Chrome, open `chrome://extensions`, enable **Developer mode**, click **Load unpacked**, and select the extracted `fvai` folder (the folder containing `manifest.json`).
7. Keep the extracted folder in place. Chrome loads the extension from that folder.
8. Open the extension, go to Documents, import a fictional sample CV or supported document, extract and review facts, then open a form, scan it, review the suggestions and evidence, and fill only the values you approve.
9. Verify every field yourself before submitting any real form.

Do not load the ZIP file itself; extract it first. Do not select the repository root unless it is the folder containing `manifest.json`.

## Configure browser access to Ollama

Fill-Vault sends local requests to Ollama. Ollama must be running and its allowed-origin configuration must include the installed extension's origin. Extension IDs can vary when the extension is loaded unpacked, so a wildcard extension origin may be used in a local development setup; only do this if you understand and trust the extensions running in your browser.

For a temporary macOS/Linux terminal session, quit the Ollama desktop app/service first, then start the server in Terminal with:

```bash
OLLAMA_ORIGINS="chrome-extension://*,moz-extension://*" ollama serve
```

Keep that terminal open while using the extension. If Ollama is already running, this command may report that the port is already in use; do not kill unrelated processes blindly. Instead, configure the environment variable for the Ollama app/service and restart it, following the official Ollama instructions for your operating system.

For Windows, set `OLLAMA_ORIGINS` in the environment used to launch Ollama, then restart Ollama. The exact steps differ between launching Ollama as a desktop app and running it as a service.

Never expose the Ollama API to the public internet. Keep it bound to localhost and only allow origins you trust. If a request fails, check the extension's error message and the Ollama logs.

## For contributors: build from source

Install a current Node.js LTS release. Then:

```bash
git clone https://github.com/pantaelija/Fill-Vault.git
cd Fill-Vault
npm ci
bash setup.sh
bash build-release.sh
```

`setup.sh` prepares document-processing libraries under `fvai/lib/`. `build-release.sh` checks the generated files and creates `dist/Fill-Vault.zip`. The ZIP is a distribution artifact and is not committed to Git.

Keep `package.json` and `package-lock.json` in sync. Do not commit generated `node_modules/`, `fvai/lib/`, or `dist/` files.

## Optional local sample form

Install Python 3, then from the repository root run:

```bash
cd test
python3 -m http.server 8000
```

Open `http://localhost:8000/form.html` in Chrome. Use Ctrl+C in the terminal to stop the server.

## Troubleshooting

### Ollama is unavailable

- Make sure Ollama is running.
- Run `ollama list` and confirm `qwen2.5:7b` is installed.
- Confirm the local API responds at `http://localhost:11434/api/tags`.
- Confirm `OLLAMA_ORIGINS` includes the extension origin and restart Ollama after changing it.
- Inspect errors at `chrome://extensions`.

### Missing document-processing files

For a source checkout, run `bash setup.sh` again and inspect its output. For a release ZIP, report the problem against the release; do not ask end users to install Node.js unless they are building from source.

### Slow responses or memory errors

Qwen 2.5 7B is a multi-gigabyte model and needs additional memory to run. Speed depends on system memory, CPU/GPU and document length. This project cannot guarantee good performance on every computer. Test on the target hardware before a demo.

### Incorrect or unsupported fields

Review the proposed value and source evidence. Leave uncertain fields blank and correct values manually. Websites with custom controls may not be supported.

## Privacy and safety

The project is designed to use a local model, but verify the extension's actual network requests, browser storage and permissions before using sensitive documents. Use fictional sample data for demos. Always review AI-generated values; do not automatically submit forms containing legal, financial, medical or identity information.

## Before publishing a release

Before publishing a release, test the extracted ZIP in a clean Chrome profile and verify:
- the extension loads without errors;
- document extraction works for each advertised format;
- Ollama can be reached and `qwen2.5:7b` responds;
- source evidence supports suggested values;
- unsupported facts are not invented;
- selected fields fill correctly; and
- the form is not submitted automatically.

## License

See [LICENSE](LICENSE). Contributions are welcome; please read [CONTRIBUTING.md](CONTRIBUTING.md) first.
