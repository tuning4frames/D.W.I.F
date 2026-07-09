# D.W.I.F.

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
  <a href="./docs/SETUP.md">Setup Guide</a> | <a href="./docs/SIMPLE_GUIDE.md">Simple Guide</a>
</p>

<p align="center">
  Small image fixer for adding a transparent top strip and rounded top-right corner to Discord widget images, with both a CLI and a Tauri desktop UI.
</p>

<p align="center">
  <img src="./assets/before-after.webp" alt="Before and after preview of D.W.I.F. fixing a Discord widget image">
</p>

## Install

For normal use, download a prebuilt desktop bundle from GitHub Releases. That package includes the app and its bundled Node runtime, so end users do not need Node.js, Rust, or local build tools just to run D.W.I.F.

Source setup is only for development:

- Node.js 18+
- Rust toolchain
- Visual Studio Build Tools with Desktop development with C++ on Windows
- Optional: `gifski` if you want the highest-quality GIF preset instead of the built-in encoder

Development install:

```bash
npm install
```

Helper setup scripts:

- Windows: `powershell -ExecutionPolicy Bypass -File .\scripts\install-deps-windows.ps1`
- Linux: `bash ./scripts/install-deps-linux.sh`
- macOS: `bash ./scripts/install-deps-macos.sh`

There is also a setup guide at [docs/SETUP.md](./docs/SETUP.md).

## Desktop UI

Launch the desktop app:

```bash
npm run tauri:dev
```

The desktop UI includes:

- file picker for PNG, JPG, WEBP, GIF, and experimental AVIF files
- live preview area
- loading spinner and animated processing progress bar
- fast animated processing enabled by default
- top strip and radius controls
- generate action
- custom title bar with working window controls
- resizable desktop window
- download button to save a copy anywhere you want

Notes:

- large GIF and animated WEBP files can take a while to process
- animated previews may be limited depending on the file and platform
- animated processing now reports frame-by-frame progress in the UI
- the desktop app now uses the faster animated export path by default
- in `tauri:dev`, generated files are written to the local `output/` folder first
- in a packaged desktop build, generated files are written to the app's local data folder before you save a copy elsewhere
- ImageMagick is not required by the app
- the highest-quality GIF preset uses `gifski`; if it is not bundled or installed, use a lower preset or set `DWIF_GIFSKI_PATH`

Build a desktop bundle:

```bash
npm run tauri:build
```

To publish prebuilt bundles through GitHub Releases, push a version tag like `v1.0.0`. The GitHub Actions release workflow will build the Tauri app on Windows and Linux and attach the generated artifacts to a draft release.

## CLI Use

Quick start:

```bash
node index.mjs input.png
```

That keeps the original image size, auto-calculates the strip and radius, and writes the fixed output into `output/`.

If you run it without paths:

```bash
node index.mjs
```

it will prompt for the input image and output file name.

## Paths

- relative inputs default to `input/`
- relative paths outside `input/` also work if the file exists locally
- absolute input paths also work
- outputs always go to `output/`

Examples:

```bash
node index.mjs input.png
node index.mjs input\input.png
node index.mjs animation.webp fixed.webp
node index.mjs animation.gif fixed.gif
node index.mjs C:\full\path\image.png output.png
```

## Manual Options

```bash
node index.mjs <input-image> [output-name] [top-strip] [radius]
```

Examples:

```bash
node index.mjs input.png output.png 17 36
node index.mjs animation.webp fixed.webp
node index.mjs animation.gif fixed.gif
```

You can also override only one value and leave the other on auto:

```bash
node index.mjs input.png output.png 17
```

Help:

```bash
node index.mjs --help
```

## Notes

- Output format follows the output file extension: `.png`, `.webp`, or `.gif`.
- Transparent WEBP files are supported.
- Animated WEBP and GIF files keep their animation frames.
- Animated output currently supports `.webp` and `.gif`.
- Experimental AVIF input uses a temporary lossless WEBP bridge during processing and finalizes `.avif` with ImageMagick.
- Faster animated export settings are enabled by default. GIF output still has harder edges than WEBP because GIF transparency is only 1-bit.
- The original image size is preserved.
- Auto sizing is calibrated from:
  - `512x512` -> `17 / 36`
  - `1844x853` -> `54 / 172`
- You may see a warning when the source image is not `512x512`, since that is the original widget reference size.
