
const { chromium } = require("playwright");
const { spawn } = require("child_process");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  prompt: "Curl2Browser> ",
});

async function main() {
  const browser = await chromium.launch({
    headless: false,
    channel: "chrome",
    executablePath:
      "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  });

  const page = await browser.newPage();

  console.log("Curl2Browser ready.");
  console.log("Paste a curl command or type exit.");
  rl.prompt();

  rl.on("line", async (line) => {
    const command = line.trim();

    if (command.toLowerCase() === "exit") {
      await browser.close();
      rl.close();
      return;
    }

    if (!/^curl(?:\.exe)?\s/i.test(command)) {
      console.log("Please enter a curl command.");
      return rl.prompt();
    }

    try {
      const args = command
        .replace(/^curl(?:\.exe)?\s+/i, "")
        .match(/"[^"]*"|'[^']*'|\S+/g) || [];

      const cleaned = args.map((arg) => {
        if (
          (arg.startsWith('"') && arg.endsWith('"')) ||
          (arg.startsWith("'") && arg.endsWith("'"))
        ) {
          return arg.slice(1, -1);
        }
        return arg;
      });

      const result = await new Promise((resolve, reject) => {
        const child = spawn("curl.exe", cleaned, {
          windowsHide: true,
        });

        let stdout = "";
        let stderr = "";

        child.stdout.on("data", (chunk) => {
          stdout += chunk.toString("utf8");
        });

        child.stderr.on("data", (chunk) => {
          stderr += chunk.toString("utf8");
        });

        child.on("error", reject);

        child.on("close", (code) => {
          if (code !== 0) {
            reject(new Error(stderr || `curl exited with code ${code}`));
          } else {
            resolve(stdout);
          }
        });
      });

      if (/<(?:!doctype\s+html|html)\b/i.test(result)) {
        await page.setContent(result, {
          waitUntil: "load",
          timeout: 15000,
        });

        await page.bringToFront();
        console.log("HTML rendered in Chrome.");
      } else {
        console.log("\n--- Response ---\n");
        console.log(result);
        console.log("\n----------------\n");
      }
    } catch (error) {
      console.error("Request failed:", error.message);
    }

    rl.prompt();
  });
}

main().catch((error) => {
  console.error("Startup failed:", error.message);
  process.exitCode = 1;
});
