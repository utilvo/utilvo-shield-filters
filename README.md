# Utilvo Shield Filters (`utilvo-shield-filters`)

**Official ABP 2.0 / uBlock Origin / AdGuard Network Filter List & Rule Parser SDK**  
Maintained by **[Utilvo](https://utilvo.com)** • Official Extension Hub: **[https://utilvo.com/shield](https://utilvo.com/shield)**

[![DOI: Zenodo](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22975427-blue)](https://doi.org/10.5281/zenodo.22975427)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Filter Rules](https://img.shields.io/badge/Rules-19%2C980%2B%20ABP%202.0-16a34a)](https://utilvo.com/filters/utilvo-shield-filters.txt)

---

## Overview

**Utilvo Shield Filters** is a curated network-level blocklist (~19,980 rules in standard `[Adblock Plus 2.0]` syntax) and zero-dependency JavaScript/Python/Go parser library engineered to block:

- Third-party ad networks and aggressive popunder redirect chains
- Malvertising gateways, phishing domains, and ClickFix fake-CAPTCHA traps
- Cross-site tracking beacons and RTB fingerprinting endpoints

All rules are scoped with `$third-party,domain=~youtube.com` so first-party web applications and video playback continue working without interruption.

---

## Direct Filter List Subscription URLs

| Resource | Official Endpoint |
| :--- | :--- |
| **Utilvo Shield Official Page** | **[https://utilvo.com/shield](https://utilvo.com/shield)** |
| **Utilvo Main Platform** | **[https://utilvo.com](https://utilvo.com)** |
| **Primary Raw Filter List (ABP 2.0)** | `https://utilvo.com/filters/utilvo-shield-filters.txt` |
| **Mirror Raw Filter List** | `https://utilvo.com/shield/filters.txt` |
| **Chrome Web Store Extension** | [Utilvo Shield for Chrome](https://chromewebstore.google.com/detail/utilvo-shield/hafpojbddmohoboonogiplgmbjcekkkc) |
| **Mozilla Firefox Add-on** | [Utilvo Shield for Firefox](https://addons.mozilla.org/en-US/firefox/addon/utilvo-shield/) |
| **Zenodo Archival DOI** | [doi:10.5281/zenodo.22975427](https://doi.org/10.5281/zenodo.22975427) |

---

## Installation & Usage

### JavaScript / TypeScript (Node.js & Browser)

```bash
npm install utilvo-shield-filters
```

```javascript
const {
  FILTER_LIST_URL,
  SHIELD_HOMEPAGE,
  parseAbpRule,
  isHostBlocked,
  fetchFilterHosts
} = require("utilvo-shield-filters");

async function main() {
  const blockedSet = await fetchFilterHosts();
  console.log("Loaded domains:", blockedSet.size);
  console.log("Check tracker:", isHostBlocked("sub.01counter.com", blockedSet)); // true
}

main();
```

### Python (`pip`)

```bash
pip install utilvo-shield-filters
```

```python
from utilvo_shield_filters import (
    FILTER_LIST_URL,
    SHIELD_HOMEPAGE,
    fetch_filter_hosts,
    is_host_blocked,
)

hosts = fetch_filter_hosts()
print(f"Loaded {len(hosts)} blocked domains from {SHIELD_HOMEPAGE}")
print(is_host_blocked("01counter.com", hosts))  # True
```

---

## Academic Citation

If you reference **Utilvo Shield Filters** or our client-side security architecture in academic work, please see [`CITATION.cff`](./CITATION.cff) and [`codemeta.json`](./codemeta.json):

> Ayoub, I. (2026). *Privacy-Preserving Client-Side Information Processing: A Browser-Based Architecture for Local Data Analysis and Secure File Handling*. Zenodo. https://doi.org/10.5281/zenodo.22975427

---

## License

Code licensed under the **MIT License**. Filter list rules licensed under **CC BY-SA 4.0**.  
© 2026 [Utilvo](https://utilvo.com) — Privacy-First Client-Side Web Utilities.
