#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '%s\n' "$1"
}

if ! command -v xcode-select >/dev/null 2>&1; then
  log "xcode-select is missing. Install Xcode Command Line Tools first."
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  log "Finish the Xcode Command Line Tools install, then rerun this script."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew is required. Install it from https://brew.sh and rerun this script."
  exit 1
fi

brew update
brew install node rust gifski

if [[ -f "./package.json" ]]; then
  log ""
  log "Installing npm dependencies..."
  npm install

  log ""
  log "Starting D.W.I.F...."
  npm run tauri:dev
  exit 0
fi

log ""
log "macOS prerequisites ready."
log "Next steps:"
log "  npm install"
log "  npm run tauri:dev"
