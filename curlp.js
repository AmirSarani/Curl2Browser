const { spawn } = require("child_process");
const { chromium } = require("playwright");

async function launchBrowser() {
  let chromeError;
  try {
    return await chromium.launch({ channel: "chrome", headless: false });
  } catch (error) {
    chromeError = error;
  }
  try {
    return await chromium.launch({ headless: false });
  } catch (bundledError) {
    throw new Error(
      "No usable browser found. Install Google Chrome or run " +
      "`npx playwright install chromium`.\n" +
      `Chrome error: ${chromeError.message}\n` +
      `Playwright error: ${bundledError.message}`
    );
  }
}

async function main() {
  const args = process.argv.slice(2);
  if (args.length === 0) {
    console.log("Usage: curlp URL [curl options]");
    process.exitCode = 1;
    return;
  }
  const curlCommand = process.platform === "win32" ? "curl.exe" : "curl";
  const child = spawn(curlCommand, args, {
    windowsHide: true,
    stdio: ["inherit", "pipe", "inherit"],
  });
  const chunks = [];
  child.stdout.on("data", (chunk) => chunks.push(chunk));
  child.on("error", (error) => {
    console.error(`curl error: ${error.message}`);
    process.exitCode = 1;
  });
  child.on("close", async (code) => {
    if (code !== 0) {
      console.error(`curl exited with code ${code}`);
      process.exitCode = code || 1;
      return;
    }
    const output = Buffer.concat(chunks);
    const html = output.toString("utf8");
    if (!/<(?:!doctype\s+html|html)\b/i.test(html)) {
      process.stdout.write(output);
      return;
    }
    let browser;
    try {
      browser = await launchBrowser();
      const page = await browser.newPage();
      await page.setContent(html, { waitUntil: "load" });
      await page.bringToFront();
      console.log("HTML opened in browser.");
    } catch (error) {
      console.error(`Browser error: ${error.message}`);
      if (browser) await browser.close().catch(() => {});
      process.exitCode = 1;
    }
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
