Pod::Spec.new do |s|
  s.name         = "RuuviTag-iOS"
  s.version      = "1.0.6"
  s.summary      = "RuuviTag iOS/tvOS Library"
  s.description  = <<-DESC
  Library to handle RuuviTag advertisement data listening
                   DESC
  s.homepage     = "https://github.com/TomiLahtinen/ruuvitag-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Tomi Lahtinen" => "tomi.lahtinen@solita.fi" }
  s.source       = { :git => "https://github.com/TomiLahtinen/ruuvitag-ios.git", :tag => "#{s.version}" }
  s.source_files = "ruuvitag-ios/**/*.{swift}"
  # s.resources    = "ruuvitag-ios/**/*.{png,jpeg,jpg,storyboard,xib}"
  s.swift_version = '4.0'
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '9.0'
  # s.dependency 'SwiftBytes' -- reinstate this, if SwiftBytes starts supportign tvOS
end
