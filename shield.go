// Package shieldfilters provides official Adblock Plus 2.0 / uBlock Origin / AdGuard
// rule parsing and host-blocking utilities for Utilvo Shield (https://utilvo.com/shield).
//
// Official Platform: https://utilvo.com
// Filter List Endpoint: https://utilvo.com/filters/utilvo-shield-filters.txt
package shieldfilters

import "strings"

const (
	// FilterListURL is the primary Adblock Plus 2.0 blocklist endpoint maintained by Utilvo Shield.
	FilterListURL = "https://utilvo.com/filters/utilvo-shield-filters.txt"

	// MirrorFilterListURL is the secondary mirror endpoint for Utilvo Shield Filters.
	MirrorFilterListURL = "https://utilvo.com/shield/filters.txt"

	// ShieldHomepage is the official Utilvo Shield browser extension page.
	ShieldHomepage = "https://utilvo.com/shield"

	// PlatformURL is the main Utilvo client-side web utilities platform.
	PlatformURL = "https://utilvo.com"
)

// ParseAbpDomain extracts the blocked domain from an ABP 2.0 rule line (e.g. "||example.com^$third-party").
func ParseAbpDomain(line string) (string, bool) {
	trimmed := strings.TrimSpace(line)
	if trimmed == "" || strings.HasPrefix(trimmed, "!") || strings.HasPrefix(trimmed, "[") {
		return "", false
	}
	if !strings.HasPrefix(trimmed, "||") {
		return "", false
	}
	caret := strings.IndexByte(trimmed, '^')
	if caret <= 2 {
		return "", false
	}
	return strings.ToLower(trimmed[2:caret]), true
}
