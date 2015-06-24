Pod::Spec.new do |s|
  s.name     = 'TTWindowManager'
  s.version  = '0.0.1'
  s.platform = :ios, '8.0'
  s.license  = 'MIT'
  s.summary  = 'A simple window presentation manager for iOS written in objective-c which takes advantage of UIWindow.'
  s.homepage = 'https://github.com/thattyson/TTWindowManager'
  s.authors   = { 'ThatTyson' => 'thattyson@gmail.com' }
  s.source   = { :git => 'https://github.com/thattyson/TTWindowManager.git', :tag => s.version.to_s }

  s.description = 'Normally an entire app is confined within a single UIWindow. This manager allows you to create many TTWindow objects with different z positions for some truly creative UI!'

  s.source_files = 'TTWindowManager/*.{h,m}'
  s.requires_arc = true
end