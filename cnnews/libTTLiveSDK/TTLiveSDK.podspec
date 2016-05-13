#
#  Be sure to run `pod spec lint TTLiveSDK.podspec --verbose' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "TTLiveSDK"
  s.version      = "0.0.1"
  s.summary      = "TTLiveSDK"
  s.author    = "kk"
  s.license      = "MIT"
  s.homepage     = "https://github.com/onlyyoujack/TTLiveSDK"
  s.source       = { :git => "https://github.com/onlyyoujack/TTLiveSDK.git", :tag => s.version }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.resource     = 'libTTLiveSDK/LiveSDKResource.bundle'
  s.source_files = 'libTTLiveSDK/*.{h,m}'
  s.vendored_libraries  = 'libTTLiveSDK/libTTLiveSDK.a'
  s.frameworks = "AVFoundation", "CoreMedia", 'VideoToolbox', 'Accelerate', 'AudioToolbox', 'Foundation'
  s.libraries = 'c++'
end
