# Curl2Browser

Run `curl` requests and automatically open HTML responses in a browser.

## Requirements

- Node.js 18 or newer
- `curl`
- Google Chrome or a compatible Playwright browser

## Install on Windows

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/AmirSarani/Curl2Browser/main/scripts/install.ps1 | iex
```

Then open a new terminal and run:

```powershell
curlp https://example.com
```

To uninstall, download `scripts/uninstall.ps1` from this repository and run it in PowerShell.

## Install on Linux or macOS

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/AmirSarani/Curl2Browser/main/scripts/install.sh | bash
```

Then open a new terminal and run:

```bash
curlp https://example.com
```

The installer places the command in `~/.local/bin`. If your shell cannot find `curlp`, add that directory to your PATH.

## Usage

```bash
curlp https://example.com
curlp -L https://example.com
curlp -I https://example.com
curlp -H "Accept: text/html" https://example.com
```

The command forwards its arguments to the system `curl`.

- HTML responses are opened in a browser.
- Non-HTML responses are printed to the terminal.
- Curl errors and exit codes are reported.

## Browser setup

Curl2Browser first tries installed Google Chrome, then the browser bundled with Playwright.

If neither is available, install Google Chrome or install a compatible Playwright browser:

```bash
npx playwright install chromium
```

## Notes

- This tool is intended for HTML responses. Binary downloads and other non-HTML responses are written to standard output.
- HTML is loaded into a browser as a local document. Relative URLs and origin-dependent behavior may differ from opening the original URL directly.
- Do not use this tool with untrusted HTML unless you understand the risks of opening it in your browser.

## Development

```bash
npm install
npm test
```

## License

MIT
