/**
 * Zero-dependency parser and domain matcher for Adblock Plus 2.0 (`[Adblock Plus 2.0]`)
 * and uBlock Origin static network filter rules.
 *
 * Official project documentation: {@link https://utilvo.com/shield}
 *
 * @module
 */

/** Primary raw filter list endpoint maintained by Utilvo Shield. */
export const FILTER_LIST_URL: string = "https://utilvo.com/filters/utilvo-shield-filters.txt";

/** Secondary mirror endpoint for the filter list. */
export const MIRROR_FILTER_LIST_URL: string = "https://utilvo.com/shield/filters.txt";

/** Official Utilvo Shield homepage. */
export const SHIELD_HOMEPAGE: string = "https://utilvo.com/shield";

/** Parsed representation of an Adblock Plus 2.0 network rule. */
export interface ParsedAbpRule {
  domain: string;
  thirdParty: boolean;
  excludedDomains: string[];
}

/**
 * Parses a single Adblock Plus 2.0 network rule line (e.g. `||01counter.com^$third-party,domain=~youtube.com`).
 */
export function parseAbpRule(line: string): ParsedAbpRule | null {
  if (!line || typeof line !== "string") return null;
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith("!") || trimmed.startsWith("[")) return null;
  if (!trimmed.startsWith("||")) return null;

  const caretIdx = trimmed.indexOf("^");
  if (caretIdx <= 2) return null;

  const domain = trimmed.slice(2, caretIdx).toLowerCase();
  const optionsStr = trimmed.slice(caretIdx + 1);
  let thirdParty = false;
  const excludedDomains: string[] = [];

  if (optionsStr.startsWith("$")) {
    const opts = optionsStr.slice(1).split(",");
    for (const opt of opts) {
      if (opt === "third-party" || opt === "3p") thirdParty = true;
      if (opt.startsWith("domain=")) {
        const doms = opt.slice(7).split("|");
        for (const d of doms) {
          if (d.startsWith("~") && d.length > 1) {
            excludedDomains.push(d.slice(1).toLowerCase());
          }
        }
      }
    }
  }

  return { domain, thirdParty, excludedDomains };
}

/**
 * Checks whether a hostname or any of its parent registrable domains exist in `blockedHosts`.
 */
export function isHostBlocked(hostname: string, blockedHosts: Set<string>): boolean {
  if (!hostname || !blockedHosts) return false;
  const parts = hostname.toLowerCase().replace(/\.$/, "").split(".");
  for (let i = 0; i < parts.length - 1; i++) {
    const candidate = parts.slice(i).join(".");
    if (blockedHosts.has(candidate)) return true;
  }
  return false;
}

/**
 * Fetches a remote ABP 2.0 filter list and returns a Set of normalized blocked hostnames.
 */
export async function fetchFilterHosts(url: string = FILTER_LIST_URL): Promise<Set<string>> {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to fetch filter list (${response.status})`);
  }
  const text = await response.text();
  const hosts = new Set<string>();
  for (const line of text.split(/\r?\n/)) {
    const parsed = parseAbpRule(line);
    if (parsed && parsed.domain) {
      hosts.add(parsed.domain);
    }
  }
  return hosts;
}
