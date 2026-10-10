# Contributing to Fill-Vault

Thanks for helping improve Fill-Vault! Beginners are welcome.

## Before you start

- Read the main [README](README.md) and its privacy/safety notes.
- Search existing [issues](https://github.com/pantaelija/Fill-Vault/issues) before opening a duplicate.
- For a bug, include the browser/OS, steps to reproduce, expected behavior, actual behavior, and relevant error text.
- Never attach real identity documents, phone numbers, addresses, or other private information. Use fictional sample data.

## Run the tests

Install Node.js 22 or a current LTS release, then from the repository root run:

```bash
npm ci
npm test
```

For a full local extension build, see **For contributors: build from source** in the README.

## Propose a change

1. Fork the repository on GitHub.
2. Create a branch for one focused change.
3. Make the smallest safe change you can.
4. Run `npm test`.
5. Open a pull request describing the problem, the fix, and how you tested it. Screenshots using fictional data are welcome.

## Safety principles

- Use only facts extracted from the user's own documents; never invent values.
- If evidence is missing or ambiguous, leave the field unmatched for manual review.
- Keep form submission manual. Never submit forms automatically.
- Keep the local Ollama service bound to the local machine; do not expose it to the public internet.
- Do not add analytics or upload documents/facts to external services without clear disclosure and explicit consent.
- Treat document contents and web-page labels as untrusted input.
