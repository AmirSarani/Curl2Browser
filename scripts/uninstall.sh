#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/.local/share/curl2browser"
BIN_DIR="${HOME}/.local/bin"
WRAPPER="${BIN_DIR}/curlp"

echo "Removing Curl2Browser..."

rm -rf "$INSTALL_DIR"
rm -f "$WRAPPER"

echo "Curl2Browser files removed."
echo "If you added ~/.local/bin to PATH for Curl2Browser only, you can remove that PATH entry from your shell profile manually."
