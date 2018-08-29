Pod::Spec.new do |s|

  s.name         = "AutoMockable"
  s.version      = "0.1.2"
  s.summary      = "Framework to generate Mockito-style mocks automatically."
  s.homepage     = "https://github.com/Arasthel/AutoMockable"

  s.license      = { :type => "MIT", :file => 'LICENSE' }
  s.author       = { "Jorge Martin Espinosa" => "contact@arasthel.com" }
  s.source       = { :git => "https://github.com/Arasthel/AutoMockable.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files  = 'AutoMockable/Source/**/*'
  s.resources  = 'AutoMockable/Templates/*'
  s.frameworks = 'Foundation'
  s.dependency 'Sourcery'
  s.weak_framework = 'XCTest'

  s.swift_version = '4.1'
  s.pod_target_xcconfig = {
    'APPLICATION_EXTENSION_API_ONLY' => 'YES',
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '$(inherited) -weak-lswiftXCTest -Xlinker -no_application_extension',
    'OTHER_SWIFT_FLAGS' => '$(inherited) -suppress-warnings',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks"',
  }

end
