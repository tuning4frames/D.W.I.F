# D.W.I.F. Setup Guide

<p align="center">
  Discord Widget Image Fixer.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/node-18%2B-339933?style=flat-square&logo=node.js&logoColor=white" alt="Node 18+">
  <img src="https://img.shields.io/badge/tauri-v2-24c8db?style=flat-square" alt="Tauri v2">
  <img src="https://img.shields.io/badge/output-PNG%20%7C%20WEBP%20%7C%20GIF-8A2BE2?style=flat-square" alt="PNG, WEBP, and GIF output">
  <img src="https://img.shields.io/badge/auto%20sizing-enabled-4C9A2A?style=flat-square" alt="Auto sizing enabled">
</p>

<p align="center">
  <a href="../README.md">Main Guide</a> | <a href="./SIMPLE_GUIDE.md">Simple Guide</a>
</p>

<p align="center">
  Small image fixer for adding a transparent top strip and rounded top-right corner to Discord widget images, with both a CLI and a Tauri desktop UI.
</p>

<p align="center">
  <img src="../assets/before-after.webp" alt="Before and after preview of D.W.I.F. fixing a Discord widget image">
</p>

This is the fuller setup page for D.W.I.F. Use this one if you want the exact development setup flow and the extra notes.

## Regular Use

If you just want to run the app, use a prebuilt bundle from GitHub Releases. Those desktop builds include the app and its bundled Node runtime, so you do not need Node.js, Rust, or local compiler toolchains on the target machine.

## What You Need

- Node.js 18+
- npm
- Rust toolchain
- Platform build tools for Tauri
- Optional: `gifski` for the highest-quality GIF export path

## Install Flow

1. Open the repo folder in a terminal.
2. Run the setup script for your platform:

```bash
# Windows
powershell -ExecutionPolicy Bypass -File .\scripts\install-deps-windows.ps1

# Linux
bash ./scripts/install-deps-linux.sh

# macOS
bash ./scripts/install-deps-macos.sh
```

3. If the script only installs prerequisites, run:

```bash
npm install
```

4. Start the desktop app:

```bash
npm run tauri:dev
```

5. Build a desktop bundle when you want a packaged app:

```bash
npm run tauri:build
```

## Platform Notes

- Windows desktop builds need Visual Studio Build Tools with the C++ desktop workload.
- Linux package names vary by distro; the Linux script covers Debian/Ubuntu first and falls back to Fedora and Arch style installs when available.
- macOS builds require Xcode Command Line Tools.
- `gifski` is optional unless you want the highest-quality GIF preset.

## Publishing Releases

Push a version tag such as `v1.0.0` to trigger the GitHub Actions release workflow. It builds Tauri bundles for Windows and Linux and uploads them to a draft GitHub Release.

The app does not depend on ImageMagick. `gifski` is only relevant for the highest GIF presets.

## Short Version

If you just want the quick path, use the [Simple Guide](./SIMPLE_GUIDE.md).
