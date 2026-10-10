# Fill-Vault: start here

Fill-Vault runs the open-source `qwen2.5:7b` model through Ollama on your computer. The model is a separate, multi-gigabyte download. The setup scripts check for Ollama, guide you to its official download if it is missing, download the model, and verify that Ollama lists it.

## 1. Install Ollama and the model

Download Fill-Vault from the [GitHub Releases page](https://github.com/pantaelija/Fill-Vault/releases) and extract the ZIP. Keep the extracted folder somewhere permanent.

- **macOS:** double-click `setup-mac.command`. If macOS blocks it, right-click the file, choose Open, and follow the system prompt. The script opens the official Ollama download page if needed.
- **Windows:** right-click `setup-windows.ps1` and choose **Run with PowerShell**. If PowerShell blocks scripts, do not change the machine-wide execution policy; use the official Ollama download page and follow the steps printed by the script.
- **Linux:** open a terminal in the extracted folder and run `bash setup-linux.sh`. If Ollama is missing, follow the official Ollama Linux instructions linked by the script.

The first model download can take a while and needs several gigabytes of free disk space. Keep the computer connected to the internet until the download finishes. You do not need Node.js, npm, Git, or Python to use a prepared release ZIP.

## 2. Load the browser extension

1. Open Chrome and go to `chrome://extensions`.
2. Turn on **Developer mode**.
3. Click **Load unpacked**.
4. Select the `fvai` folder — the folder containing `manifest.json`.
5. Keep the folder in place. If the extension is already installed, reload it after setup.

## 3. Ollama browser access

The browser extension calls Ollama on `localhost` only. Ollama must allow the extension's origin. The macOS script sets `OLLAMA_ORIGINS` for newly launched GUI apps and restarts Ollama. On Windows, follow the exact commands printed by `setup-windows.ps1`, then fully quit and reopen Ollama. On Linux, configure `OLLAMA_ORIGINS` for the Ollama service; the setup script prints the temporary foreground command and links to the official service instructions.

If the extension cannot connect, check that Ollama is running, run `ollama list`, verify `qwen2.5:7b` appears, and reload the extension. Do not terminate unrelated processes to free port 11434.

## Privacy and safety

- The AI model runs locally through Ollama. Your documents are intended to stay on your computer; they are not sent to a Fill-Vault cloud service by this setup.
- The model download itself requires internet access. Ollama may also have its own software behavior; review its official privacy and network documentation if you need stronger assurance.
- The browser still visits the websites you choose, and those websites receive whatever information you submit to them.
- Never expose Ollama's API port (`11434`) to the public internet. Only allow browser origins you trust.
- Use sample data while testing. Review every suggestion and verify every field before submitting a real form. Fill-Vault does not replace your judgment.

## If setup does not work

1. Fully quit and reopen Ollama.
2. Run `ollama list` and check for `qwen2.5:7b`.
3. Open `http://localhost:11434/api/tags` in your browser. A local JSON response means the API is responding.
4. Reload Fill-Vault from `chrome://extensions`.
5. If needed, follow the official [Ollama download and setup instructions](https://ollama.com/download) and report the operating system and exact error in [GitHub Issues](https://github.com/pantaelija/Fill-Vault/issues).

Do not post document contents, API logs containing private information, or personal identifiers in a public issue.
