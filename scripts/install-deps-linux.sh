#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '%s\n' "$1"
}

install_debian() {
  sudo apt-get update
  sudo apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libgtk-3-dev \
    libwebkit2gtk-4.1-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev
}

install_fedora() {
  sudo dnf install -y \
    curl \
    gcc-c++ \
    make \
    pkgconf-pkg-config \
    gtk3-devel \
    webkit2gtk4.1-devel \
    libappindicator-gtk3-devel \
    librsvg2-devel
}

install_arch() {
  sudo pacman -Sy --needed --noconfirm \
    curl \
    base-devel \
    pkgconf \
    gtk3 \
    webkit2gtk-4.1 \
    libappindicator-gtk3 \
    librsvg
}

if command -v apt-get >/dev/null 2>&1; then
  log "Detected apt-based distro."
  install_debian
elif command -v dnf >/dev/null 2>&1; then
  log "Detected Fedora-like distro."
  install_fedora
elif command -v pacman >/dev/null 2>&1; then
  log "Detected Arch-like distro."
  install_arch
else
  log "Unsupported distro. Install Node.js 18+, Rust, pkg-config, GTK3, and WebKitGTK manually."
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  log "Node.js is not installed. Install Node.js 18+ and rerun."
  exit 1
fi

if ! command -v rustup >/dev/null 2>&1; then
  log "Installing Rust toolchain..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

if ! command -v gifski >/dev/null 2>&1; then
  log "Optional: install gifski separately if you want the highest-quality GIF preset."
fi

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
log "Linux prerequisites ready."
log "Next steps:"
log "  npm install"
log "  npm run tauri:dev"
