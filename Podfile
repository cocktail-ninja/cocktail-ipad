source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '9.0'
inhibit_all_warnings!

target "cocktail-assassin" do
  pod 'iCarousel', '~> 1.8'
  pod 'PromiseKit', '~> 4.4'
  pod 'OMGHTTPURLRQ', '~> 3.2'
  pod 'Alamofire', '~> 4.5'
  pod 'iOSSharedViewTransition', :git => 'https://github.com/sbycrosz/iOSSharedViewTransition.git'
  pod 'MONActivityIndicatorView'
  pod 'Fabric'
  pod 'Crashlytics'
  
  target "cocktail-assassinTests" do
    inherit! :search_paths

    pod 'Quick', '~> 1.1'
    pod 'Nimble', '~> 7.0'
    pod 'SwiftLint', '~> 0.22'
  end
end
