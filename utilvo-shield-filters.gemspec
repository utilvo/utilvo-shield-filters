Gem::Specification.new do |s|
  s.name        = "utilvo-shield-filters"
  s.version     = "1.0.0"
  s.summary     = "Zero-dependency parser and domain matcher for Adblock Plus 2.0 network filter rules."
  s.description = "Parses Adblock Plus 2.0 and uBlock Origin static network filter rules (||domain^$third-party) and matches hostnames against domain blocklists."
  s.authors     = ["Utilvo"]
  s.email       = "utilvo.com@gmail.com"
  s.files       = ["lib/utilvo_shield_filters.rb", "README.md", "LICENSE"]
  s.homepage    = "https://utilvo.com/shield"
  s.license     = "MIT"
  s.required_ruby_version = ">= 2.7.0"
  s.metadata    = {
    "homepage_uri"    => "https://utilvo.com/shield",
    "source_code_uri" => "https://github.com/utilvo/utilvo-shield-filters",
    "bug_tracker_uri" => "https://github.com/utilvo/utilvo-shield-filters/issues"
  }
end
