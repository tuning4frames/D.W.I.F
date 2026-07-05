import { spawn } from "node:child_process";
import { existsSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const validCommands = new Set(["dev", "build"]);
const command = process.argv[2];
const extraArgs = process.argv.slice(3);

if (!validCommands.has(command)) {
  console.error("Usage: node scripts/run-tauri.mjs <dev|build> [...args]");
  process.exit(1);
}

const rootDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");

if (command === "dev" || command === "build") {
  const prepareResult = await runNodeScript("scripts/prepare-bundled-node.mjs");
  if (prepareResult !== 0) {
    process.exit(prepareResult);
  }
}

const env = { ...process.env };

if (process.platform !== "win32") {
  env.CARGO_HOME ??= path.join(env.HOME ?? "", ".cargo");
  env.PKG_CONFIG_PATH = [
    env.PKG_CONFIG_PATH,
    "/usr/lib/x86_64-linux-gnu/pkgconfig",
    "/usr/share/pkgconfig"
  ]
    .filter(Boolean)
    .join(":");
  env.PKG_CONFIG ??= "/usr/bin/pkg-config";
}

process.exit(await runBin(command, extraArgs, env));

function runNodeScript(relativePath) {
  return new Promise((resolve) => {
    const child = spawn(process.execPath, [path.join(rootDir, relativePath)], {
      cwd: rootDir,
      stdio: "inherit"
    });

    child.on("exit", (code) => resolve(code ?? 1));
    child.on("error", () => resolve(1));
  });
}

function runBin(subcommand, extraArgs, env) {
  return new Promise((resolve) => {
    const tauriBin = path.join(
      rootDir,
      "node_modules",
      ".bin",
      process.platform === "win32" ? "tauri.cmd" : "tauri"
    );

    if (!existsSync(tauriBin)) {
      console.error("Tauri CLI is not installed. Run npm install first.");
      resolve(1);
      return;
    }

    const child =
      process.platform === "win32"
        ? spawn(process.env.ComSpec ?? "cmd.exe", ["/d", "/s", "/c", `${tauriBin} ${subcommand}${extraArgs.length ? " " + extraArgs.join(" ") : ""}`], {
            cwd: rootDir,
            env,
            stdio: "inherit"
          })
        : spawn(tauriBin, [subcommand, ...extraArgs], {
            cwd: rootDir,
            env,
            stdio: "inherit"
          });

    child.on("exit", (code) => resolve(code ?? 1));
    child.on("error", (error) => {
      if (error.code === "ENOENT") {
        console.error("Tauri CLI is not installed. Run npm install first.");
      } else {
        console.error(error.message);
      }
      resolve(1);
    });
  });
}
