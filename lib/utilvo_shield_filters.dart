/// Zero-dependency parser and domain suffix matcher for Adblock Plus 2.0
/// (`[Adblock Plus 2.0]`) and uBlock Origin static network filter rules.
library utilvo_shield_filters;

const String filterListUrl = 'https://utilvo.com/filters/utilvo-shield-filters.txt';
const String mirrorFilterListUrl = 'https://utilvo.com/shield/filters.txt';
const String shieldHomepage = 'https://utilvo.com/shield';

class AbpRuleResult {
  final String domain;
  final bool thirdParty;
  final List<String> excludedDomains;

  const AbpRuleResult({
    required this.domain,
    required this.thirdParty,
    required this.excludedDomains,
  });
}

/// Parses a single Adblock Plus 2.0 network rule line (`||domain^$third-party`).
AbpRuleResult? parseAbpRule(String line) {
  final trimmed = line.trim();
  if (trimmed.isEmpty || trimmed.startsWith('!') || trimmed.startsWith('[')) {
    return null;
  }
  if (!trimmed.startsWith('||')) {
    return null;
  }
  final caretIdx = trimmed.indexOf('^');
  if (caretIdx <= 2) {
    return null;
  }

  final domain = trimmed.substring(2, caretIdx).toLowerCase();
  final optionsStr = trimmed.substring(caretIdx + 1);
  var thirdParty = false;
  final excluded = <String>[];

  if (optionsStr.startsWith(r'$')) {
    final opts = optionsStr.substring(1).split(',');
    for (final opt in opts) {
      if (opt == 'third-party' || opt == '3p') {
        thirdParty = true;
      } else if (opt.startsWith('domain=')) {
        final doms = opt.substring(7).split('|');
        for (final d in doms) {
          if (d.startsWith('~') && d.length > 1) {
            excluded.add(d.substring(1).toLowerCase());
          }
        }
      }
    }
  }

  return AbpRuleResult(
    domain: domain,
    thirdParty: thirdParty,
    excludedDomains: excluded,
  );
}

/// Checks whether [hostname] or any of its parent registrable domain suffixes
/// exist in [blockedSet].
bool isHostBlocked(String hostname, Set<String> blockedSet) {
  if (blockedSet.isEmpty) return false;
  var clean = hostname.trim().toLowerCase();
  while (clean.endsWith('.')) {
    clean = clean.substring(0, clean.length - 1);
  }
  if (clean.isEmpty) return false;

  final parts = clean.split('.');
  if (parts.length < 2) return false;

  for (var i = 0; i < parts.length - 1; i++) {
    final candidate = parts.sublist(i).join('.');
    if (blockedSet.contains(candidate)) {
      return true;
    }
  }
  return false;
}
