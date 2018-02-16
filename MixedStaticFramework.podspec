Pod::Spec.new do |s| 
  s.name             = "MixedStaticFramework" 
  s.version          = "1.0.0" 
  s.summary          = "Testing mixing objc and swift code in a pod lib"
  s.description      = <<-DESC
  This project is simply for testing mixing objc and swift code in a pod lib.
  DESC
  s.homepage         = "https://github.com/bryanboyko/MixedStaticFramework" 
  s.author           = { "Bryan" => "bryan.boyko@gmail.com" } 
  s.source           = { :git => "https://github.com/bryanboyko/MixedStaticFramework.git", :tag => s.version.to_s } 
  s.license          = { :type => "MIT", :file => "LICENSE" } 

  s.xcconfig         = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  s.pod_target_xcconfig = { 'SWIFT_OBJC_BRIDGING_HEADER' => '$(PODS_TARGET_SRCROOT)/MixedStaticFramework/Core/ObjC/MixedStaticFramework-Bridging-Header.h' }
  s.libraries        = 'xml2' 
  s.swift_version    = "4.0" 
 
  s.requires_arc     = true 
  s.platform         = :ios, '8.0'
  s.static_framework = true

  s.dependency 'mopub-ios-sdk', '>= 4.17.0'
  s.dependency 'FBAudienceNetwork', '4.27.2'

  s.source_files     = 'MixedStaticFramework/**/*.{swift,h,m}'
end
