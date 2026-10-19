# frozen_string_literal: true

require "set"

# Zero-dependency parser and domain matcher for Adblock Plus 2.0 network filter rules.
module UtilvoShieldFilters
  VERSION = "1.0.0"
  FILTER_LIST_URL = "https://utilvo.com/filters/utilvo-shield-filters.txt"
  MIRROR_FILTER_LIST_URL = "https://utilvo.com/shield/filters.txt"
  SHIELD_HOMEPAGE = "https://utilvo.com/shield"

  module_function

  def parse_abp_rule(line)
    return nil unless line.is_a?(String)

    trimmed = line.strip
    return nil if trimmed.empty? || trimmed.start_with?("!", "[")
    return nil unless trimmed.start_with?("||")

    caret_idx = trimmed.index("^")
    return nil if caret_idx.nil? || caret_idx <= 2

    domain = trimmed[2...caret_idx].downcase
    options_str = trimmed[(caret_idx + 1)..] || ""
    third_party = false
    excluded_domains = []

    if options_str.start_with?("$")
      options_str[1..].split(",").each do |opt|
        if opt == "third-party" || opt == "3p"
          third_party = true
        elsif opt.start_with?("domain=")
          opt[7..].split("|").each do |dom|
            excluded_domains << dom[1..].downcase if dom.start_with?("~") && dom.length > 1
          end
        end
      end
    end

    {
      domain: domain,
      third_party: third_party,
      excluded_domains: excluded_domains
    }
  end

  def host_blocked?(hostname, blocked_set)
    return false if hostname.nil? || blocked_set.nil?

    clean = hostname.strip.chomp(".").downcase
    return false if clean.empty?

    parts = clean.split(".")
    return false if parts.length < 2

    (0...(parts.length - 1)).any? do |i|
      candidate = parts[i..].join(".")
      blocked_set.include?(candidate)
    end
  end
end
