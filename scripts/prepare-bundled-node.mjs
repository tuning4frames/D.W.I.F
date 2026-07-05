import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const rootDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const vendorDir = path.join(rootDir, "vendor");
const platform = process.platform;

async function main() {
  if (platform !== "win32" && platform !== "linux") {
    return;
  }

  const sourceNodePath = process.execPath;
  const targetNodePath = path.join(vendorDir, platform === "win32" ? "node.exe" : "node");

  await fs.mkdir(vendorDir, { recursive: true });
  await fs.copyFile(sourceNodePath, targetNodePath);
  if (platform !== "win32") {
    await fs.chmod(targetNodePath, 0o755);
  }
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
