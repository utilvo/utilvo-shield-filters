export declare const FILTER_LIST_URL = "https://utilvo.com/filters/utilvo-shield-filters.txt";
export declare const MIRROR_FILTER_LIST_URL = "https://utilvo.com/shield/filters.txt";
export declare const SHIELD_HOMEPAGE = "https://utilvo.com/shield";
export declare const PLATFORM_URL = "https://utilvo.com";

export interface ParsedAbpRule {
  domain: string;
  thirdParty: boolean;
  excludedDomains: string[];
}

export declare function parseAbpRule(line: string): ParsedAbpRule | null;
export declare function isHostBlocked(hostname: string, blockedHosts: Set<string>): boolean;
export declare function fetchFilterHosts(url?: string): Promise<Set<string>>;
