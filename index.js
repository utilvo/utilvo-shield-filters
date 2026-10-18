"use strict";

/**
 * Utilvo Shield Filters — Official ABP 2.0 / uBlock Origin / AdGuard Filter List SDK
 * Homepage: https://utilvo.com/shield
 * Main Platform: https://utilvo.com
 */

const FILTER_LIST_URL = "https://utilvo.com/filters/utilvo-shield-filters.txt";
const MIRROR_FILTER_LIST_URL = "https://utilvo.com/shield/filters.txt";
const SHIELD_HOMEPAGE = "https://utilvo.com/shield";
const PLATFORM_URL = "https://utilvo.com";

/**
 * Parses a single Adblock Plus 2.0 network rule (e.g. "||example.com^$third-party,domain=~youtube.com")
 * and returns the blocked hostname or null if the line is a comment/header.
 * @param {string} line
 * @returns {{ domain: string, thirdParty: boolean, excludedDomains: string[] } | null}
 */
function parseAbpRule(line) {
  if (!line || typeof line !== "string") return null;
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith("!") || trimmed.startsWith("[")) return null;
  if (!trimmed.startsWith("||")) return null;

  const caretIdx = trimmed.indexOf("^");
  if (caretIdx === -1) return null;

  const domain = trimmed.slice(2, caretIdx).toLowerCase();
  const optionsStr = trimmed.slice(caretIdx + 1);
  let thirdParty = false;
  const excludedDomains = [];

  if (optionsStr.startsWith("$")) {
    const opts = optionsStr.slice(1).split(",");
    for (const opt of opts) {
      if (opt === "third-party" || opt === "3p") thirdParty = true;
      if (opt.startsWith("domain=")) {
        const doms = opt.slice(7).split("|");
        for (const d of doms) {
          if (d.startsWith("~")) excludedDomains.push(d.slice(1).toLowerCase());
        }
      }
    }
  }

  return { domain, thirdParty, excludedDomains };
}

/**
 * Checks if a hostname or any of its parent domains is present in the blocked hosts Set.
 * @param {string} hostname
 * @param {Set<string>} blockedHosts
 * @returns {boolean}
 */
function isHostBlocked(hostname, blockedHosts) {
  if (!hostname || !blockedHosts) return false;
  const parts = hostname.toLowerCase().replace(/\.$/, "").split(".");
  for (let i = 0; i < parts.length - 1; i++) {
    const candidate = parts.slice(i).join(".");
    if (blockedHosts.has(candidate)) return true;
  }
  return false;
}

/**
 * Fetches the live Utilvo Shield Filters list and returns a Set of blocked hostnames.
 * @param {string} [url]
 * @returns {Promise<Set<string>>}
 */
async function fetchFilterHosts(url = FILTER_LIST_URL) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to fetch Utilvo Shield Filters (${response.status})`);
  }
  const text = await response.text();
  const hosts = new Set();
  for (const line of text.split(/\r?\n/)) {
    const parsed = parseAbpRule(line);
    if (parsed && parsed.domain) {
      hosts.add(parsed.domain);
    }
  }
  return hosts;
}

module.exports = {
  FILTER_LIST_URL,
  MIRROR_FILTER_LIST_URL,
  SHIELD_HOMEPAGE,
  PLATFORM_URL,
  parseAbpRule,
  isHostBlocked,
  fetchFilterHosts,
};
