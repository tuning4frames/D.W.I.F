import path from "node:path";
import {
  parseOptionalNumber,
  processImage,
  resolveInputPath,
  resolveOutputPath
} from "../lib/dwif.mjs";

async function main() {
  const [, , rawInputPath, rawOutputName, rawTopStrip, rawRadius, rawFastAnimated, rawEncodingConfig] = process.argv;

  if (!rawInputPath) {
    throw new Error("Input image path is required.");
  }

  const inputPath = resolveInputPath(rawInputPath);
  const outputPath = resolveOutputPath(inputPath, rawOutputName || "");

  const result = await processImage({
    inputPath,
    outputPath,
    manualTopStrip: parseOptionalNumber(rawTopStrip, "top-strip"),
    manualRadius: parseOptionalNumber(rawRadius, "radius"),
    fastAnimated: rawFastAnimated !== "false",
    encodingConfig: rawEncodingConfig ? JSON.parse(rawEncodingConfig) : null,
    onProgress(progress) {
      process.stdout.write(`${JSON.stringify({ type: "progress", ...progress })}\n`);
    }
  });

  process.stdout.write(
    `${JSON.stringify({
      type: "result",
      ...result,
      outputPath: path.resolve(result.outputPath)
    })}\n`
  );
}

main().catch((error) => {
  process.stderr.write(error.message);
  process.exit(1);
});
