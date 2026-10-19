//! Zero-dependency parser and domain matcher for Adblock Plus 2.0 (`[Adblock Plus 2.0]`)
//! and uBlock Origin static network filter rules.

use std::collections::HashSet;

/// Primary raw filter list endpoint maintained by Utilvo Shield.
pub const FILTER_LIST_URL: &str = "https://utilvo.com/filters/utilvo-shield-filters.txt";

/// Secondary mirror endpoint for the filter list.
pub const MIRROR_FILTER_LIST_URL: &str = "https://utilvo.com/shield/filters.txt";

/// Official Utilvo Shield homepage.
pub const SHIELD_HOMEPAGE: &str = "https://utilvo.com/shield";

/// Parsed representation of an Adblock Plus 2.0 network filter rule.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ParsedAbpRule {
    pub domain: String,
    pub third_party: bool,
    pub excluded_domains: Vec<String>,
}

/// Parses a single Adblock Plus 2.0 network rule line (e.g. `||01counter.com^$third-party,domain=~youtube.com`).
pub fn parse_abp_rule(line: &str) -> Option<ParsedAbpRule> {
    let trimmed = line.trim();
    if trimmed.is_empty() || trimmed.starts_with('!') || trimmed.starts_with('[') {
        return None;
    }
    if !trimmed.starts_with("||") {
        return None;
    }
    let caret_idx = trimmed.find('^')?;
    if caret_idx <= 2 {
        return None;
    }

    let domain = trimmed[2..caret_idx].to_ascii_lowercase();
    let options_str = &trimmed[caret_idx + 1..];
    let mut third_party = false;
    let mut excluded_domains = Vec::new();

    if let Some(opts_raw) = options_str.strip_prefix('$') {
        for opt in opts_raw.split(',') {
            if opt == "third-party" || opt == "3p" {
                third_party = true;
            } else if let Some(doms) = opt.strip_prefix("domain=") {
                for d in doms.split('|') {
                    if let Some(excl) = d.strip_prefix('~') {
                        if !excl.is_empty() {
                            excluded_domains.push(excl.to_ascii_lowercase());
                        }
                    }
                }
            }
        }
    }

    Some(ParsedAbpRule {
        domain,
        third_party,
        excluded_domains,
    })
}

/// Checks whether `hostname` or any of its parent registrable labels exist in `blocked_hosts`.
pub fn is_host_blocked(hostname: &str, blocked_hosts: &HashSet<String>) -> bool {
    let clean = hostname.trim().trim_end_matches('.').to_ascii_lowercase();
    if clean.is_empty() {
        return false;
    }
    let parts: Vec<&str> = clean.split('.').collect();
    if parts.len() < 2 {
        return false;
    }
    for i in 0..(parts.len() - 1) {
        let candidate = parts[i..].join(".");
        if blocked_hosts.contains(&candidate) {
            return true;
        }
    }
    false
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_abp_rule() {
        let rule = parse_abp_rule("||01counter.com^$third-party,domain=~youtube.com").unwrap();
        assert_eq!(rule.domain, "01counter.com");
        assert!(rule.third_party);
        assert_eq!(rule.excluded_domains, vec!["youtube.com".to_string()]);
    }

    #[test]
    fn test_is_host_blocked() {
        let mut set = HashSet::new();
        set.insert("01counter.com".to_string());
        assert!(is_host_blocked("sub.01counter.com", &set));
        assert!(!is_host_blocked("example.com", &set));
    }
}
