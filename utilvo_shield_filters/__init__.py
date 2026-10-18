"""
Utilvo Shield Filters — Official ABP 2.0 / uBlock Origin / AdGuard Filter List SDK
Homepage: https://utilvo.com/shield
Platform: https://utilvo.com
"""

from typing import Dict, List, Optional, Set, Union
import urllib.request

__version__ = "1.0.0"

FILTER_LIST_URL = "https://utilvo.com/filters/utilvo-shield-filters.txt"
MIRROR_FILTER_LIST_URL = "https://utilvo.com/shield/filters.txt"
SHIELD_HOMEPAGE = "https://utilvo.com/shield"
PLATFORM_URL = "https://utilvo.com"


def parse_abp_rule(line: str) -> Optional[Dict[str, Union[str, bool, List[str]]]]:
    """Parse a single Adblock Plus 2.0 domain rule and return metadata or None."""
    if not line or not isinstance(line, str):
        return None
    trimmed = line.strip()
    if not trimmed or trimmed.startswith("!") or trimmed.startswith("["):
        return None
    if not trimmed.startswith("||"):
        return None
    caret_idx = trimmed.find("^")
    if caret_idx == -1:
        return None

    domain = trimmed[2:caret_idx].lower()
    options_str = trimmed[caret_idx + 1 :]
    third_party = False
    excluded_domains: List[str] = []

    if options_str.startswith("$"):
        for opt in options_str[1:].split(","):
            if opt in ("third-party", "3p"):
                third_party = True
            elif opt.startswith("domain="):
                for dom in opt[7:].split("|"):
                    if dom.startswith("~"):
                        excluded_domains.append(dom[1:].lower())

    return {
        "domain": domain,
        "third_party": third_party,
        "excluded_domains": excluded_domains,
    }


def is_host_blocked(hostname: str, blocked_hosts: Set[str]) -> bool:
    """Return True if hostname or any of its parent domains is in blocked_hosts."""
    if not hostname or not blocked_hosts:
        return False
    parts = hostname.lower().rstrip(".").split(".")
    for i in range(len(parts) - 1):
        candidate = ".".join(parts[i:])
        if candidate in blocked_hosts:
            return True
    return False


def fetch_filter_hosts(url: str = FILTER_LIST_URL, timeout: int = 15) -> Set[str]:
    """Download the live Utilvo Shield Filters list and return a Set of blocked domains."""
    req = urllib.request.Request(
        url,
        headers={"User-Agent": f"utilvo-shield-filters/{__version__} (+https://utilvo.com/shield)"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        text = resp.read().decode("utf-8", errors="replace")

    hosts: Set[str] = set()
    for line in text.splitlines():
        parsed = parse_abp_rule(line)
        if parsed and isinstance(parsed.get("domain"), str):
            hosts.add(str(parsed["domain"]))
    return hosts
