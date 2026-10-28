# Curl2Browser

**English:** A cross-platform CLI utility that runs `curl` requests and
opens HTML responses in a desktop browser.\
**فارسی:** ابزار خط فرمان چندسکویی برای اجرای درخواست‌های `curl` و باز
کردن پاسخ‌های HTML در مرورگر دسکتاپ.

[English](#english) · [فارسی](#فارسی)

------------------------------------------------------------------------

`<a id="english">`{=html}`</a>`{=html}

## English

### Overview

Curl2Browser wraps your system's `curl` command and uses Playwright to
open HTML responses in a browser. If the response does not look like
HTML, it prints the output to the terminal.

### Requirements

-   Node.js 18 or newer
-   npm
-   `curl` available on `PATH`
-   Google Chrome or a compatible Playwright browser

Curl2Browser first tries installed Google Chrome, then tries
Playwright's Chromium. If no compatible browser is available, try:

``` bash
npx playwright install chromium
```

### Install

**Windows --- PowerShell**

``` powershell
irm https://raw.githubusercontent.com/AmirSarani/Curl2Browser/main/scripts/install.ps1 | iex
```

Open a new terminal after installation. The installer downloads the
current `main` branch, installs production dependencies in your user
profile, creates the `curlp` command, and adds its `bin` folder to your
user PATH.

**Linux / macOS --- Terminal**

``` bash
curl -fsSL https://raw.githubusercontent.com/AmirSarani/Curl2Browser/main/scripts/install.sh | bash
```

The installer places the app in `~/.local/share/curl2browser`, creates
`~/.local/bin/curlp`, and adds `~/.local/bin` to the relevant shell
profile if needed. If the command is not found, open a new terminal or
run:

``` bash
export PATH="$HOME/.local/bin:$PATH"
```

Review an installation script before piping it directly into a shell if
you want to inspect its actions.

### Usage

``` bash
curlp URL [curl options]
```

Open an HTML response:

``` bash
curlp https://example.com
```

Follow redirects:

``` bash
curlp -L https://example.com
```

Send a custom header:

``` bash
curlp -H "Accept: text/html" https://example.com
```

Print response headers:

``` bash
curlp -I https://example.com
```

Combine options:

``` bash
curlp -L -H "Accept: text/html" https://example.com
```

Use the same quoting rules as your normal shell and `curl` command.

### How it works

1.  `curlp` passes the URL and options to the system `curl` executable.
2.  Curl2Browser captures the response output.
3.  If the response looks like HTML, it launches a browser and loads the
    returned HTML.
4.  Otherwise, it prints the output to the terminal.
5.  Request or browser errors are reported and a failure exit status is
    returned.

### Important behavior and limitations

The HTML is loaded as a local document, not navigated to at the original
website URL. Relative links and asset paths, cookies, origin-dependent
behavior, and some JavaScript may therefore behave differently from the
original site.

HTML detection is heuristic. Browser behavior can vary by operating
system and browser installation. Linux and macOS installers should be
tested on the target systems before being relied on in production.

The current `npm test` script checks JavaScript syntax in `curlp.js` and
`app.js`; it is not a comprehensive integration test.

### Uninstall

**Windows:** From a local clone of the repository, run in PowerShell:

``` powershell
.\scripts\uninstall.ps1
```

**Linux / macOS:** From a local clone of the repository, run:

``` bash
bash scripts/uninstall.sh
```

The uninstallers remove Curl2Browser files and its command wrapper. The
Windows script also removes its PATH entry. The Unix script does not
remove a PATH line from your shell profile; remove that line manually if
it was added only for Curl2Browser. Neither uninstaller removes Node.js,
npm, or your browser.

### Development

``` bash
git clone https://github.com/AmirSarani/Curl2Browser.git
cd Curl2Browser
npm install
node curlp.js https://example.com
npm test
```

### Troubleshooting

-   **`curlp` not found:** Open a new terminal and check that the
    installer directory is on PATH.
-   **Node.js version error:** Install Node.js 18 or newer.
-   **No usable browser:** Install Google Chrome or a compatible
    Playwright Chromium browser.
-   **Unexpected page appearance:** Remember that HTML is loaded
    locally, not from its original origin.
-   **Response printed instead of opened:** The response may not have
    been detected as HTML. Test the request with regular `curl` and
    inspect the response.

### Security and privacy

-   Only access URLs and content you are authorized to use.
-   Treat returned HTML as untrusted. Depending on the content and
    browser, scripts may execute.
-   Avoid opening unknown or suspicious HTML outside an isolated test
    environment.
-   Command-line arguments may expose credentials or tokens through
    shell history or local process inspection.
-   The installer downloads source code and installs dependencies.
    Review the scripts and source if you need to verify their behavior.

### Project structure

``` text
Curl2Browser/
├── curlp.js
├── app.js
├── package.json
├── package-lock.json
├── README.md
├── LICENSE
└── scripts/
    ├── install.ps1
    ├── uninstall.ps1
    ├── install.sh
    └── uninstall.sh
```

### License

MIT License. See [LICENSE](LICENSE).

------------------------------------------------------------------------

`<a id="فارسی">`{=html}`</a>`{=html}

## فارسی

### معرفی

**Curl2Browser** ابزار خط فرمانی است که درخواست را با `curl` سیستم اجرا
می‌کند. اگر پاسخ دریافت‌شده شبیه HTML باشد، آن را در مرورگر دسکتاپ باز
می‌کند؛ در غیر این صورت، خروجی را در ترمینال نشان می‌دهد.

### پیش‌نیازها

-   Node.js نسخهٔ ۱۸ یا جدیدتر
-   npm
-   در دسترس بودن دستور `curl` در PATH
-   Google Chrome یا مرورگر سازگار با Playwright

ابزار ابتدا Google Chrome نصب‌شده را امتحان می‌کند و در صورت نیاز سراغ
Chromium مربوط به Playwright می‌رود. اگر مرورگر سازگار پیدا نشد، این
دستور را امتحان کنید:

``` bash
npx playwright install chromium
```

### نصب

**ویندوز --- PowerShell**

``` powershell
irm https://raw.githubusercontent.com/AmirSarani/Curl2Browser/main/scripts/install.ps1 | iex
```

پس از نصب، یک ترمینال جدید باز کنید. نصب‌کننده سورس شاخهٔ `main` را دانلود
می‌کند، وابستگی‌های لازم را در مسیر کاربر نصب می‌کند، فرمان `curlp` را
می‌سازد و پوشهٔ `bin` را به PATH کاربر اضافه می‌کند.

**لینوکس و macOS --- ترمینال**

``` bash
curl -fsSL https://raw.githubusercontent.com/AmirSarani/Curl2Browser/main/scripts/install.sh | bash
```

برنامه در `~/.local/share/curl2browser` نصب می‌شود و فرمان
`~/.local/bin/curlp` ساخته می‌شود. در صورت نیاز، مسیر `~/.local/bin` به
فایل تنظیمات shell اضافه می‌شود. اگر فرمان پیدا نشد، ترمینال جدیدی باز
کنید یا اجرا کنید:

``` bash
export PATH="$HOME/.local/bin:$PATH"
```

اگر می‌خواهید دقیقاً بدانید نصب‌کننده چه کار می‌کند، پیش از اجرای مستقیم آن
از طریق shell، اسکریپت را بررسی کنید.

### روش استفاده

``` bash
curlp URL [curl options]
```

باز کردن پاسخ HTML:

``` bash
curlp https://example.com
```

دنبال کردن ریدایرکت‌ها:

``` bash
curlp -L https://example.com
```

ارسال هدر سفارشی:

``` bash
curlp -H "Accept: text/html" https://example.com
```

نمایش هدرهای پاسخ:

``` bash
curlp -I https://example.com
```

ترکیب چند گزینه:

``` bash
curlp -L -H "Accept: text/html" https://example.com
```

قواعد نقل‌قول‌گذاری را مطابق shell خود رعایت کنید؛ درست مانند اجرای معمولی
`curl`.

### سازوکار اجرا

1.  دستور `curlp` آدرس و گزینه‌ها را به برنامهٔ `curl` سیستم می‌دهد.
2.  خروجی پاسخ دریافت می‌شود.
3.  اگر پاسخ شبیه HTML باشد، مرورگر اجرا شده و HTML بارگذاری می‌شود.
4.  اگر پاسخ HTML تشخیص داده نشود، خروجی در ترمینال چاپ می‌شود.
5.  خطاهای درخواست یا اجرای مرورگر گزارش می‌شوند و در صورت شکست، کد خروج
    خطا برگردانده می‌شود.

### رفتار مهم و محدودیت‌ها

HTML به‌عنوان یک سند محلی بارگذاری می‌شود، نه از طریق مراجعهٔ مستقیم به URL
اصلی سایت. به همین دلیل لینک‌های نسبی، مسیر فایل‌های جانبی، کوکی‌ها،
رفتارهای وابسته به مبدأ و بعضی قابلیت‌های JavaScript ممکن است مثل سایت
اصلی عمل نکنند.

تشخیص HTML قطعی نیست و رفتار مرورگر با توجه به سیستم‌عامل و مرورگر نصب‌شده
می‌تواند متفاوت باشد. اسکریپت‌های نصب Linux و macOS باید در همان
سیستم‌عامل‌ها آزمایش شوند و پیش از تست عملی نباید اجرای بی‌نقص آن‌ها را
تضمین‌شده فرض کرد.

دستور فعلی `npm test` نحو JavaScript فایل‌های `curlp.js` و `app.js` را
بررسی می‌کند؛ این تست جامع یکپارچگی نیست.

### حذف نصب

**ویندوز:** از نسخهٔ محلی مخزن، در PowerShell اجرا کنید:

``` powershell
.\scripts\uninstall.ps1
```

**لینوکس و macOS:** از نسخهٔ محلی مخزن اجرا کنید:

``` bash
bash scripts/uninstall.sh
```

اسکریپت‌های حذف نصب، فایل‌های Curl2Browser و فرمان آن را پاک می‌کنند.
اسکریپت ویندوز ورودی PATH مربوط به ابزار را نیز حذف می‌کند. اسکریپت
Linux/macOS خط PATH را از فایل تنظیمات shell حذف نمی‌کند؛ اگر آن خط فقط
برای Curl2Browser اضافه شده بود، آن را دستی پاک کنید. هیچ‌کدام Node.js،
npm یا مرورگر شما را حذف نمی‌کنند.

### توسعه

``` bash
git clone https://github.com/AmirSarani/Curl2Browser.git
cd Curl2Browser
npm install
node curlp.js https://example.com
npm test
```

### عیب‌یابی

-   **فرمان `curlp` پیدا نمی‌شود:** ترمینال جدید باز کنید و وجود مسیر نصب
    در PATH را بررسی کنید.
-   **خطای نسخهٔ Node.js:** نسخهٔ ۱۸ یا جدیدتر نصب کنید.
-   **مرورگر سازگار پیدا نمی‌شود:** Google Chrome یا Chromium سازگار با
    Playwright نصب کنید.
-   **ظاهر صفحه متفاوت است:** HTML به‌صورت محلی باز می‌شود و در مبدأ اصلی
    سایت نیست.
-   **پاسخ به‌جای مرورگر در ترمینال چاپ می‌شود:** ممکن است پاسخ HTML تشخیص
    داده نشده باشد. همان درخواست را با `curl` معمولی اجرا و پاسخ را
    بررسی کنید.

### امنیت و حریم خصوصی

-   فقط به URLها و محتوایی دسترسی پیدا کنید که مجاز به استفاده از آن‌ها
    هستید.
-   HTML دریافتی را غیرقابل‌اعتماد فرض کنید؛ بسته به محتوا و مرورگر، ممکن
    است اسکریپت اجرا شود.
-   محتوای ناشناس یا مشکوک را خارج از محیط آزمایشی ایزوله باز نکنید.
-   آرگومان‌های خط فرمان ممکن است اطلاعات ورود یا توکن‌ها را در تاریخچهٔ
    shell یا ابزارهای مشاهدهٔ فرایندهای محلی آشکار کنند.
-   نصب‌کننده سورس را دانلود می‌کند و وابستگی‌ها را نصب می‌کند. اگر نیاز به
    اطمینان از عملکرد آن دارید، پیش از اجرا اسکریپت و سورس را بررسی
    کنید.

### ساختار پروژه

``` text
Curl2Browser/
├── curlp.js
├── app.js
├── package.json
├── package-lock.json
├── README.md
├── LICENSE
└── scripts/
    ├── install.ps1
    ├── uninstall.ps1
    ├── install.sh
    └── uninstall.sh
```

### مجوز

این پروژه تحت مجوز MIT منتشر شده است. جزئیات در فایل [LICENSE](LICENSE)
قرار دارد.

------------------------------------------------------------------------

## Suggested GitHub repository description / توضیح کوتاه پیشنهادی برای مخزن

**English:** Cross-platform CLI that runs curl requests and opens HTML
responses in your browser, with installers for Windows, Linux, and
macOS.

**فارسی:** ابزار خط فرمان چندسکویی برای اجرای درخواست‌های curl و باز کردن
پاسخ‌های HTML در مرورگر؛ همراه با نصب‌کننده برای ویندوز، لینوکس و macOS.
