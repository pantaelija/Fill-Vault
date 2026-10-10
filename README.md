# Fill-Vault

Fill-Vault is a browser extension that uses a local AI model to suggest form values from your own documents. It is designed to provide source evidence for suggestions, leave unsupported fields blank, and let you review values before filling a form.

## Requirements

* Google Chrome or another compatible Chromium-based browser.
* [Ollama](https://ollama.com/download) installed and running locally.
* The `qwen2.5:7b` model downloaded in Ollama.
* Enough free disk space and memory to run the model comfortably.

**Privacy:** Fill-Vault is designed for local AI processing. Review the code and verify network behavior before using sensitive personal documents. Do not upload real identity documents when testing.

## Install Fill-Vault

### 1. Install Ollama

Download Ollama for your operating system:

* macOS: https://ollama.com/download/mac
* Windows: https://ollama.com/download/windows
* Linux: https://ollama.com/download/linux

### 2. Download the AI model

Open Terminal on macOS/Linux or PowerShell on Windows and run:

```bash
ollama pull qwen2.5:7b
```

Verify the model is installed:

```bash
ollama list
```

Test it:

```bash
ollama run qwen2.5:7b
```

Type a short test message. Exit the model with `/bye`.

Keep Ollama running while using Fill-Vault.

### 3. Download the extension

Download `Fill-Vault.zip` from the project's GitHub Releases page and extract it to a permanent folder.

Do not load the ZIP file directly. The extracted folder must contain the extension's `manifest.json` file.

### 4. Load the extension in Chrome

1. Open `chrome://extensions`.
2. Enable **Developer mode**.
3. Click **Load unpacked**.
4. Select the extracted `fvai` folder.
5. Confirm that Fill-Vault appears without an extension error.

### 5. Test the workflow

1. Open the extension.
2. Open its Documents page.
3. Import a sample CV or text document.
4. Extract facts and review the results.
5. Open a test form.
6. Scan the form and review the suggested values and evidence.
7. Select the values you want and fill the form.
8. Verify every field manually. Fill-Vault does not submit the form for you.

Use fictional sample data for your first test.

## Build from source

Install a current Node.js LTS release, then clone the repository:

```bash
git clone https://github.com/pantaelija/Fill-Vault.git
cd Fill-Vault
```

Install the extension's local libraries:

```bash
bash ./setup.sh
```

Build a distributable ZIP:

```bash
bash ./build-release.sh
```

The resulting package is `dist/Fill-Vault.zip`. Test it in a fresh browser profile before publishing.

## Troubleshooting

### Ollama is unavailable

* Open the Ollama application.
* Run `ollama list` to verify that `qwen2.5:7b` is installed.
* Confirm that the local API responds at `http://localhost:11434/api/tags`.
* If Ollama is not running, start it using the normal instructions for your operating system.

### The model is missing

Run:

```bash
ollama pull qwen2.5:7b
```

### The extension does not load

* Select the extracted `fvai` directory, not the repository root or ZIP file.
* Open `chrome://extensions` and inspect the error details.
* If a library is missing, rebuild the package from source.

### Document extraction fails

* Rebuild using `bash ./build-release.sh`.
* Check that the generated `fvai/lib/` directory contains the required libraries.
* Review the extension's error messages.

### Form fields are not filled correctly

* Review each suggestion and its supporting evidence.
* Try a standard HTML form.
* Do not assume every website or custom dropdown is supported.

## Privacy and safety

Review all AI suggestions before using them. Never allow an AI-generated answer to silently replace important personal information. Do not automatically submit forms containing legal, financial, medical or identity information.

## License

See [LICENSE](LICENSE).
