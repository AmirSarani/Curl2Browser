
const { spawn } = require("child_process");
const { chromium } = require("playwright");

async function main() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.log('Usage: curlp URL [curl options]');
    return;
  }

  const child = spawn("curl.exe", args, {
    windowsHide: true,
    stdio: ["inherit", "pipe", "inherit"],
  });

  const chunks = [];

  child.stdout.on("data", (chunk) => chunks.push(chunk));

  child.on("error", (error) => {
    console.error("curl error:", error.message);
    process.exitCode = 1;
  });

  child.on("close", async (code) => {
    const output = Buffer.concat(chunks);
    const html = output.toString("utf8");

    if (code !== 0) {
      console.error(`curl exited with code ${code}`);
      return;
    }

    if (!/<(?:!doctype\s+html|html)\b/i.test(html)) {
      process.stdout.write(output);
      return;
    }

    let browser;

    try {
      browser = await chromium.launch({
        headless: false,
        channel: "chrome",
        executablePath:
          "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
      });

      const page = await browser.newPage();
      await page.setContent(html, { waitUntil: "load" });
      await page.bringToFront();

      console.log("HTML opened in Chrome.");
    } catch (error) {
      console.error("Browser error:", error.message);
      if (browser) await browser.close();
      process.exitCode = 1;
    }
  });
}

main().catch(console.error);
