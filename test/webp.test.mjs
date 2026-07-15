import assert from "node:assert/strict";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import WebPMux from "node-webpmux";
import sharp from "sharp";

import { processImage } from "../lib/dwif.mjs";

test("animated WebP replaces complete frames instead of blending them", async (context) => {
  const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), "dwif-webp-test-"));
  context.after(() => fs.rm(tempDir, { recursive: true, force: true }));

  const width = 4;
  const height = 4;
  const redFrame = await sharp({
    create: { width, height, channels: 4, background: "red" }
  }).webp({ lossless: true }).toBuffer();
  const transparentFrame = await sharp({
    create: { width, height, channels: 4, background: { r: 0, g: 0, b: 0, alpha: 0 } }
  }).webp({ lossless: true }).toBuffer();
  const inputPath = path.join(tempDir, "input.webp");
  const outputPath = path.join(tempDir, "output.webp");

  await WebPMux.Image.save(inputPath, {
    width,
    height,
    frames: [
      await WebPMux.Image.generateFrame({ buffer: redFrame, delay: 100, blend: false }),
      await WebPMux.Image.generateFrame({ buffer: transparentFrame, delay: 100, blend: false })
    ]
  });

  await processImage({ inputPath, outputPath, manualTopStrip: 0, manualRadius: 0 });

  const output = new WebPMux.Image();
  await output.load(outputPath);
  assert.equal(output.frames.length, 2);
  assert.deepEqual(output.frames.map((frame) => frame.blend), [false, false]);
});
