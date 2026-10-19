Pod::Spec.new do |s|
  s.name             = 'UtilvoShieldFilters'
  s.version          = '1.1.1'
  s.summary          = 'Parser and matcher for DNS/ABP host blocklists and Utilvo Shield network filter rules.'
  s.description      = 'Lightweight Swift SDK for parsing Adblock Plus (ABP) and hosts-file domain blocklists and evaluating hostname blocking rules.'
  s.homepage         = 'https://utilvo.com/shield'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Utilvo' => 'utilvo.com@gmail.com' }
  s.source           = { :git => 'https://github.com/utilvo/utilvo-shield-filters.git', :tag => 'v1.1.1' }
  s.swift_versions   = ['5.5', '5.7', '5.9']
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'
  s.source_files     = 'Sources/UtilvoShieldFilters/**/*.swift'
end
