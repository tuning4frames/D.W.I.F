import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const rootDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const vendorDir = path.join(rootDir, "vendor");
const platform = process.platform;

async function main() {
  if (platform !== "win32") {
    return;
  }

  const sourceNodePath = process.execPath;
  const targetNodePath = path.join(vendorDir, "node.exe");

  await fs.mkdir(vendorDir, { recursive: true });
  await fs.copyFile(sourceNodePath, targetNodePath);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
