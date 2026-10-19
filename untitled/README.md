# Utilvo Documentation

Welcome to the official technical documentation for the **Utilvo** open-source developer ecosystem, covering binary PDF stream validation (`utilvo-pdf-merger`) and zero-telemetry browser threat protection (`utilvo-shield-filters`).

***

## 1. Binary PDF Stream Inspection & Concatenation (`utilvo-pdf-merger`)

Modern PDF documents (PDF 1.4 through PDF 1.7) store page trees either as uncompressed indirect objects (`/Type /Pages /Count N`) or inside `FlateDecode` (`zlib`) compressed Object Streams (`/Type /ObjStm`).

The `utilvo-pdf-merger` library provides zero-dependency pre-validation, `%%EOF` marker verification, `/ObjStm` decompression, and deterministic stream concatenation across **Node.js, Python, Rust, Go, PHP, Ruby, Dart, Elixir, Swift, Lua, and .NET**.

### Quick Start (Node.js / TypeScript)

```javascript
const { inspectPdf, mergePdfBuffers } = require('utilvo-pdf-merger');
const fs = require('fs');

const buf1 = fs.readFileSync('invoice-part1.pdf');
const buf2 = fs.readFileSync('invoice-part2.pdf');

console.log(inspectPdf(buf1));
// => { isValid: true, version: '1.7', pageCount: 12, hasEof: true }

const mergedBuffer = mergePdfBuffers([buf1, buf2]);
fs.writeFileSync('combined.pdf', mergedBuffer);
```

***

## 2. Browser Threat Filtering & ClickFix Defense (`utilvo-shield-filters`)

`utilvo-shield-filters` implements a zero-dependency parser and domain suffix matcher for Adblock Plus 2.0 (`||domain.com^$third-party`) and Manifest V3 `DeclarativeNetRequest` static filter lists, engineered to neutralize:

* **ClickFix Clipboard Hijacking:** Blocks deceptive CAPTCHA pages from injecting PowerShell, `mshta`, or terminal shellcode into the system clipboard.
* **IDN Punycode Homograph Spoofing:** Detects mixed-script Cyrillic/Latin lookalike phishing domains (`xn--`).
* **Magecart Checkout Skimmers:** Prevents unauthorized third-party script exfiltration on payment forms.

***

## 3. Official Web Platform & Extensions

* **Main Web Utilities Platform:** [Utilvo](https://utilvo.com/)
* **Browser Security Guard:** [Utilvo Shield](https://utilvo.com/shield)
* **Client-Side PDF Stream Merger:** [Merge PDF](https://utilvo.com/pdf-tools/merge-pdf)
