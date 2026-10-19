import Foundation

/// Parser and matcher for DNS/ABP host blocklists and Utilvo Shield network filter rules.
public struct UtilvoShieldFilters {
    public static let defaultBlocklistURL = "https://utilvo.com/filters/utilvo-shield-filters.txt"
    public static let shieldExtensionURL = "https://utilvo.com/shield"

    public let blockedDomains: Set<String>

    public init(rulesText: String) {
        self.blockedDomains = Self.parseRules(rulesText)
    }

    /// Parses raw ABP (`||domain.com^`) and hosts-file (`0.0.0.0 domain.com`) rules into normalized domains.
    public static func parseRules(_ rawText: String) -> Set<String> {
        var domains = Set<String>()
        let lines = rawText.components(separatedBy: .newlines)
        for rawLine in lines {
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if line.isEmpty || line.hasPrefix("!") || line.hasPrefix("#") || line.hasPrefix("[") {
                continue
            }
            if line.hasPrefix("||") && line.hasSuffix("^") {
                let start = line.index(line.startIndex, offsetBy: 2)
                let end = line.index(before: line.endIndex)
                let domain = String(line[start..<end])
                if !domain.isEmpty && !domain.contains("*") && !domain.contains("/") {
                    domains.insert(domain)
                }
            } else if line.hasPrefix("0.0.0.0 ") || line.hasPrefix("127.0.0.1 ") {
                let parts = line.split(whereSeparator: { $0.isWhitespace })
                if parts.count >= 2 {
                    let host = String(parts[1])
                    if host != "localhost" && host != "0.0.0.0" {
                        domains.insert(host)
                    }
                }
            }
        }
        return domains
    }

    /// Checks whether a hostname or any of its parent domains is matched by the blocklist.
    public func isBlocked(_ hostname: String) -> Bool {
        var clean = hostname.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        while clean.hasSuffix(".") {
            clean.removeLast()
        }
        if clean.isEmpty {
            return false
        }
        let labels = clean.split(separator: ".")
        for i in 0..<labels.count {
            let candidate = labels[i...].joined(separator: ".")
            if blockedDomains.contains(candidate) {
                return true
            }
        }
        return false
    }
}
