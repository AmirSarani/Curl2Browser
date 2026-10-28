#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/AmirSarani/Curl2Browser/archive/refs/heads/main.tar.gz"
INSTALL_DIR="${HOME}/.local/share/curl2browser"
BIN_DIR="${HOME}/.local/bin"
TEMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

if ! command -v node >/dev/null 2>&1; then
  echo "Error: Node.js 18 or newer is required: https://nodejs.org/" >&2
  exit 1
fi

NODE_VERSION="$(node -p 'process.versions.node')"
if ! node -e 'process.exit(Number(process.versions.node.split(".")[0]) >= 18 ? 0 : 1)'; then
  echo "Error: Node.js 18 or newer is required. Detected: ${NODE_VERSION}" >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm is required. Reinstall Node.js and try again." >&2
  exit 1
fi

echo "Downloading Curl2Browser..."
curl -fsSL "$REPO" -o "${TEMP_DIR}/source.tar.gz"
mkdir -p "${TEMP_DIR}/source"
tar -xzf "${TEMP_DIR}/source.tar.gz" -C "${TEMP_DIR}/source"

SOURCE_DIR="${TEMP_DIR}/source/Curl2Browser-main"
for file in curlp.js package.json package-lock.json; do
  if [ ! -f "${SOURCE_DIR}/${file}" ]; then
    echo "Error: Required project file is missing: ${file}" >&2
    exit 1
  fi
done

mkdir -p "$INSTALL_DIR" "$BIN_DIR"
cp -R "${SOURCE_DIR}/." "$INSTALL_DIR/"

echo "Installing dependencies..."
(
  cd "$INSTALL_DIR"
  npm ci --omit=dev
)

cat > "${BIN_DIR}/curlp" <<'WRAPPER'
#!/usr/bin/env sh
exec node "$HOME/.local/share/curl2browser/curlp.js" "$@"
WRAPPER
chmod +x "${BIN_DIR}/curlp"

SHELL_NAME="$(basename "${SHELL:-sh}")"
case "$SHELL_NAME" in
  zsh) PROFILE="${HOME}/.zshrc" ;;
  bash) PROFILE="${HOME}/.bashrc" ;;
  *) PROFILE="${HOME}/.profile" ;;
esac

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
if ! grep -Fq '.local/bin' "$PROFILE" 2>/dev/null; then
  printf '\n%s\n' "$PATH_LINE" >> "$PROFILE"
fi
export PATH="${BIN_DIR}:${PATH}"

echo
echo "Curl2Browser installed successfully."
echo "Run: curlp https://example.com"
echo "If the command is not found, open a new terminal or run:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo "Google Chrome or a compatible Playwright browser is required."
