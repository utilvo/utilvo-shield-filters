using System;
using System.Collections.Generic;

namespace Utilvo.Shield.Filters
{
    public sealed class AbpRuleResult
    {
        public string Domain { get; set; }
        public bool ThirdParty { get; set; }
        public List<string> ExcludedDomains { get; set; }
    }

    public static class ShieldFilterParser
    {
        public const string FilterListUrl = "https://utilvo.com/filters/utilvo-shield-filters.txt";
        public const string MirrorFilterListUrl = "https://utilvo.com/shield/filters.txt";
        public const string ShieldHomepage = "https://utilvo.com/shield";

        public static AbpRuleResult ParseAbpRule(string line)
        {
            if (string.IsNullOrWhiteSpace(line))
                return null;

            string trimmed = line.Trim();
            if (trimmed.StartsWith("!", StringComparison.Ordinal) || trimmed.StartsWith("[", StringComparison.Ordinal))
                return null;

            if (!trimmed.StartsWith("||", StringComparison.Ordinal))
                return null;

            int caretIdx = trimmed.IndexOf('^');
            if (caretIdx <= 2)
                return null;

            string domain = trimmed.Substring(2, caretIdx - 2).ToLowerInvariant();
            string optionsStr = trimmed.Substring(caretIdx + 1);
            bool thirdParty = false;
            var excluded = new List<string>();

            if (optionsStr.StartsWith("$", StringComparison.Ordinal))
            {
                string[] opts = optionsStr.Substring(1).Split(',');
                foreach (string opt in opts)
                {
                    if (opt == "third-party" || opt == "3p")
                    {
                        thirdParty = true;
                    }
                    else if (opt.StartsWith("domain=", StringComparison.Ordinal))
                    {
                        string[] doms = opt.Substring(7).Split('|');
                        foreach (string d in doms)
                        {
                            if (d.StartsWith("~", StringComparison.Ordinal) && d.Length > 1)
                            {
                                excluded.Add(d.Substring(1).ToLowerInvariant());
                            }
                        }
                    }
                }
            }

            return new AbpRuleResult
            {
                Domain = domain,
                ThirdParty = thirdParty,
                ExcludedDomains = excluded
            };
        }

        public static bool IsHostBlocked(string hostname, ISet<string> blockedSet)
        {
            if (string.IsNullOrWhiteSpace(hostname) || blockedSet == null || blockedSet.Count == 0)
                return false;

            string clean = hostname.Trim().TrimEnd('.').ToLowerInvariant();
            if (clean.Length == 0)
                return false;

            string[] parts = clean.Split('.');
            if (parts.Length < 2)
                return false;

            for (int i = 0; i < parts.Length - 1; i++)
            {
                string candidate = string.Join(".", parts, i, parts.Length - i);
                if (blockedSet.Contains(candidate))
                    return true;
            }

            return false;
        }
    }
}
