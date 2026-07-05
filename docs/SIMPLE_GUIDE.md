# D.W.I.F. Simple Guide

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
  <a href="../README.md">Main Guide</a> | <a href="./SETUP.md">Setup Guide</a>
</p>

<p align="center">
  Small image fixer for adding a transparent top strip and rounded top-right corner to Discord widget images, with both a CLI and a Tauri desktop UI.
</p>

<p align="center">
  <img src="../assets/before-after.webp" alt="Before and after preview of D.W.I.F. fixing a Discord widget image">
</p>

This is the shortest version.

## Do This

1. Open GitHub Releases.
2. Download the build for your platform.
3. Run the installer or extracted app bundle.

That is the normal user path.

## If You Are Developing

1. Clone the repo.
2. Open a terminal in the repo folder.
3. Run the setup script for your platform:

```bash
# Windows
powershell -ExecutionPolicy Bypass -File .\scripts\install-deps-windows.ps1

# Linux
bash ./scripts/install-deps-linux.sh

# macOS
bash ./scripts/install-deps-macos.sh
```

4. Then run:

```bash
npm install
npm run tauri:dev
```

## Need More Detail?

Use the [Full Setup Guide](./SETUP.md).
