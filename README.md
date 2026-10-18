# utilvo-shield-filters

Zero-dependency JavaScript, TypeScript, Python, and Go parser for Adblock Plus 2.0 (`[Adblock Plus 2.0]`) and uBlock Origin static network filter rules.

## Features

- Parse standard `||domain^$third-party,domain=~example.com` network rules
- Extract target hostnames, `$third-party` modifiers, and excluded context domains
- Fast parent-domain suffix matching (`Set`-backed lookup) for hostname verification
- Built-in fetcher for the `utilvo-shield-filters.txt` blocklist

## Installation

### Node.js

```bash
npm install utilvo-shield-filters
```

```javascript
const { parseAbpRule, isHostBlocked, fetchFilterHosts } = require("utilvo-shield-filters");

// Parse a single rule
const rule = parseAbpRule("||01counter.com^$third-party,domain=~youtube.com");
// => { domain: '01counter.com', thirdParty: true, excludedDomains: ['youtube.com'] }

// Match a hostname against a Set of rules
const blocked = new Set(["01counter.com"]);
console.log(isHostBlocked("tracker.01counter.com", blocked)); // true
```

### Python

```bash
pip install utilvo-shield-filters
```

```python
from utilvo_shield_filters import parse_abp_rule, is_host_blocked

rule = parse_abp_rule("||01counter.com^$third-party,domain=~youtube.com")
print(rule)
# {'domain': '01counter.com', 'third_party': True, 'excluded_domains': ['youtube.com']}

blocked = {"01counter.com"}
print(is_host_blocked("sub.01counter.com", blocked))  # True
```

### Go

```bash
go get github.com/utilvo/utilvo-shield-filters@latest
```

```go
package main

import (
	"fmt"
	shieldfilters "github.com/utilvo/utilvo-shield-filters"
)

func main() {
	domain, ok := shieldfilters.ParseAbpDomain("||01counter.com^$third-party")
	if ok {
		fmt.Println(domain) // 01counter.com
	}
}
```

## API Reference

- `parseAbpRule(line)` / `parse_abp_rule(line)` / `ParseAbpDomain(line)`: Parses a single ABP 2.0 rule line and returns the normalized lowercase domain and rule options. Returns `null` / `None` for comments (`!`), headers (`[Adblock Plus 2.0]`), or cosmetic filters.
- `isHostBlocked(hostname, blockedSet)` / `is_host_blocked(hostname, blocked_set)`: Checks whether `hostname` or any of its parent registrable labels exist in `blockedSet`.
- `fetchFilterHosts(url?)` / `fetch_filter_hosts(url?)`: Downloads and parses a remote ABP filter list into a `Set` of domain strings.

## License

Code is licensed under the [MIT License](./LICENSE). Filter list rules are licensed under CC BY-SA 4.0.
