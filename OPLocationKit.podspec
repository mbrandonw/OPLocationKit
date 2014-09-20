Pod::Spec.new do |spec|
  spec.name         = 'OPLocationKit'
  spec.version      = '0.1.0'
  spec.license      = { type: 'BSD' }
  spec.homepage     = 'https://github.com/mbrandonw/OPLocationKit'
  spec.authors      = { 'Brandon Williams' => 'mbw234@gmail.com' }
  spec.summary      = ''
  spec.source       = { git: 'https://github.com/mbrandonw/OPLocationKit.git' }
  spec.source_files = 'OPLocationKit/Source/**/*.{h,m}'
  spec.frameworks = 'CoreLocation'
  spec.requires_arc = true
end
