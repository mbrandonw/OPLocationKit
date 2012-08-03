Pod::Spec.new do |s|
  s.name     = 'OPLocationKit'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  
  s.summary  = 'Sweet location stuffs.'
  s.homepage = 'https://github.com/mbrandonw/OPLocationKit'
  s.author   = { 'Brandon Williams' => 'brandon@opetopic.com' }
  s.source   = { :git => 'git@github.com:mbrandonw/OPLocationKit.git' }
  
  s.source_files = 'OPLocationKit/Source/**/*.{h,m}'
  
  s.frameworks = 'CoreLocation'
  
  s.dependency 'BlocksKit', '~> 1.0.1'
  s.dependency 'AFNetworking', '~> 0.7.0'
  s.dependency 'OPExtensionKit', :git => 'git@github.com:mbrandonw/OPExtensionKit.git'
  s.dependency 'OPEnumerable', :git => 'git@github.com:mbrandonw/OPEnumerable.git'

end
