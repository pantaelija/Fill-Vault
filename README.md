# Fill-Vault

**Fill out web forms with help from your own documents — while keeping control of every value.**

Fill-Vault is a browser extension powered by the open-source `qwen2.5:7b` model running locally through Ollama. It extracts facts from documents, suggests matching form fields, and shows source evidence so you can review each suggestion. It never submits a form for you.

- **Download:** [GitHub Releases](https://github.com/pantaelija/Fill-Vault/releases) — choose `Fill-Vault.zip` from the latest release.
- **Quick start:** read [START-HERE.md](START-HERE.md) included in the release ZIP.
- **Issues and help:** [Report a problem or ask a question](https://github.com/pantaelija/Fill-Vault/issues).
- **Contributing:** see [Contributing](CONTRIBUTING.md).

## What you need

- Google Chrome or a compatible Chromium browser
- [Ollama](https://ollama.com/download)
- Several gigabytes of disk space and sufficient memory for `qwen2.5:7b`
- Internet access for the first Ollama/model download

**End users installing a prepared release ZIP do not need Node.js, npm, Git, or Python.** Those tools are only needed to build from source or run the optional local test form. The model is downloaded separately; it is not bundled in the ZIP.

## Install for the first time

1. Download `Fill-Vault.zip` from [GitHub Releases](https://github.com/pantaelija/Fill-Vault/releases) and extract it to a permanent folder.
2. Run the setup script for your operating system:
   - **macOS:** double-click `setup-mac.command`. If macOS blocks it, right-click and choose **Open**. If the executable bit was not preserved by your unzip tool, open Terminal in the extracted folder and run `bash setup-mac.command`.
   - **Windows:** right-click `setup-windows.ps1` and choose **Run with PowerShell**. If script execution is blocked, do not weaken the machine-wide execution policy; follow the official Ollama installer steps and rerun it.
   - **Linux:** open a terminal in the extracted folder and run `bash setup-linux.sh`.
3. The script checks Ollama, opens the official Ollama download page if it is missing, pulls `qwen2.5:7b`, and verifies the model. You may need to install/open Ollama yourself and rerun setup; these scripts do not silently bypass operating-system security prompts.
4. In Chrome, open `chrome://extensions`, turn on **Developer mode**, click **Load unpacked**, and select the `fvai` folder (the folder containing `manifest.json`).
5. Keep the extracted folder in place. Open Fill-Vault, import a sample document, review extracted facts, scan a form, and approve only suggestions you understand.

The first model download is several gigabytes and can take time. Keep your computer connected to the internet until it finishes. Do not select the ZIP itself in Chrome; extract it first.

## Start Fill-Vault later

After setup, use the matching launcher in the extracted folder:

- macOS: double-click `start-mac.command` (or run `bash start-mac.command` in Terminal).
- Windows: right-click `start-windows.ps1` and choose **Run with PowerShell**.
- Linux: run `bash start-linux.sh`.

Keep Ollama running while you use the extension. If you move the extracted folder, Chrome may need the extension reloaded from its new `fvai` location.

## How the local model connects

The extension sends requests to Ollama at `http://localhost:11434`. Ollama must allow the browser extension origin. The setup scripts configure or guide the `OLLAMA_ORIGINS` setting for Chrome/Firefox extension origins. Extension IDs can vary for unpacked development extensions, so this setup uses wildcard extension origins. Only use this on a computer where you trust the installed browser extensions.

If the browser cannot connect, fully quit and restart Ollama, run `ollama list`, confirm `qwen2.5:7b` appears, open `http://localhost:11434/api/tags` to test the local API, and reload Fill-Vault. Linux installations using systemd may require configuring `OLLAMA_ORIGINS` in the service environment; see the [official Ollama Linux instructions](https://github.com/ollama/ollama/blob/main/docs/linux.md).

**Never expose Ollama port 11434 to the public internet.** Keep the service on localhost and only allow origins you trust. The scripts do not kill unrelated processes or disable operating-system protections.

## Privacy and safety

- Document processing and model inference are designed to run locally; this project does not require a Fill-Vault cloud account or upload documents to a Fill-Vault server.
- Internet is needed to download Ollama and the model. Review Ollama's own documentation and the extension's network behavior if your privacy requirements are strict.
- Websites you visit still receive information you choose to submit to them.
- Use fictional sample data during demos. Review every suggestion and verify every field yourself before submitting a real form. Fill-Vault does not submit forms automatically.

## For contributors: build from source

Install a current Node.js LTS release, then run:

```bash
git clone https://github.com/pantaelija/Fill-Vault.git
cd Fill-Vault
npm ci
bash setup.sh
bash build-release.sh
```

`setup.sh` prepares document-processing libraries under `fvai/lib/`. `build-release.sh` creates `dist/Fill-Vault.zip`, including the extension and setup/start scripts. The ZIP is a build artifact and is not committed to Git.

Keep `package.json` and `package-lock.json` in sync. Do not commit generated `node_modules/`, `fvai/lib/`, or `dist/` files.

## Optional local sample form

Install Python 3, then from the repository root run:

```bash
cd test
python3 -m http.server 8000
```

Open `http://localhost:8000/form.html`. Use Ctrl+C to stop the server.

## Troubleshooting

- **Ollama unavailable:** open the Ollama app, then use `ollama list` and `http://localhost:11434/api/tags` to check it.
- **Model missing:** rerun the operating-system setup script; it runs `ollama pull qwen2.5:7b` and verifies the result.
- **Browser connection blocked:** confirm `OLLAMA_ORIGINS` is set for the Ollama process, restart Ollama, and reload the extension.
- **Slow responses or memory errors:** Qwen 2.5 7B is a multi-gigabyte model. Speed and memory use vary by hardware; test on your target computer.
- **Incorrect/unsupported fields:** review the source evidence, leave uncertain fields blank, and correct values manually.

Do not post document contents, private identifiers, or sensitive logs in public GitHub issues.

## Before publishing a release

Test the extracted ZIP in a clean browser profile and on each advertised operating system. Verify the extension loads, document extraction works, Ollama responds, source evidence supports suggestions, unsupported facts are not invented, selected fields fill correctly, and no form is submitted automatically.

## License

See [LICENSE](LICENSE). Contributions are welcome; please read [CONTRIBUTING.md](CONTRIBUTING.md) first.
