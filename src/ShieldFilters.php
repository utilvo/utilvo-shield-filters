<?php

declare(strict_types=1);

namespace Utilvo\ShieldFilters;

/**
 * Zero-dependency parser and domain matcher for Adblock Plus 2.0 network filter rules.
 */
final class ShieldFilters
{
    public const FILTER_LIST_URL = 'https://utilvo.com/filters/utilvo-shield-filters.txt';
    public const MIRROR_FILTER_LIST_URL = 'https://utilvo.com/shield/filters.txt';
    public const SHIELD_HOMEPAGE = 'https://utilvo.com/shield';

    /**
     * Parse a single Adblock Plus 2.0 network rule line.
     *
     * @param string $line
     * @return array{domain: string, thirdParty: bool, excludedDomains: list<string>}|null
     */
    public static function parseAbpRule(string $line): ?array
    {
        $trimmed = trim($line);
        if ($trimmed === '' || $trimmed[0] === '!' || $trimmed[0] === '[') {
            return null;
        }
        if (strncmp($trimmed, '||', 2) !== 0) {
            return null;
        }
        $caretIdx = strpos($trimmed, '^');
        if ($caretIdx === false || $caretIdx <= 2) {
            return null;
        }

        $domain = strtolower(substr($trimmed, 2, $caretIdx - 2));
        $optionsStr = substr($trimmed, $caretIdx + 1);
        $thirdParty = false;
        $excludedDomains = [];

        if ($optionsStr !== '' && $optionsStr[0] === '$') {
            $opts = explode(',', substr($optionsStr, 1));
            foreach ($opts as $opt) {
                if ($opt === 'third-party' || $opt === '3p') {
                    $thirdParty = true;
                } elseif (strncmp($opt, 'domain=', 7) === 0) {
                    $doms = explode('|', substr($opt, 7));
                    foreach ($doms as $d) {
                        if ($d !== '' && $d[0] === '~') {
                            $excludedDomains[] = strtolower(substr($d, 1));
                        }
                    }
                }
            }
        }

        return [
            'domain' => $domain,
            'thirdParty' => $thirdParty,
            'excludedDomains' => $excludedDomains,
        ];
    }

    /**
     * Check if a hostname or any of its parent domains is present in an associative map/set of blocked domains.
     *
     * @param string $hostname
     * @param array<string, bool> $blockedSet
     * @return bool
     */
    public static function isHostBlocked(string $hostname, array $blockedSet): bool
    {
        $clean = rtrim(strtolower($hostname), '.');
        if ($clean === '') {
            return false;
        }
        $parts = explode('.', $clean);
        $count = count($parts);
        for ($i = 0; $i < $count - 1; $i++) {
            $candidate = implode('.', array_slice($parts, $i));
            if (isset($blockedSet[$candidate])) {
                return true;
            }
        }
        return false;
    }
}
