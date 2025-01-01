# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

source 'https://github.com/CocoaPods/Specs.git'

# Add this post_install hook at the root level
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
      # Fix for pod naming issues
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "org.cocoapods.${PRODUCT_NAME:rfc1034identifier}"
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end

target '句句' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 句句
  pod 'BulletinBoard'
  pod 'DateTimePicker'
  pod 'MASegmentedControl'
  pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'GoogleAnalytics'
  #pod 'Onboard'
  pod 'Hero'
  pod 'PopupDialog'
  pod 'SwiftyGif'
  pod 'SwiftMessages'
  #pod 'AlertToast'
  #pod 'UIImageViewAlignedSwift'
  #pod 'UXCam'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  pod 'SDWebImageSwiftUI'
  pod 'GoogleUtilities'
  pod 'Firebase/CoreOnly'
  pod 'FSCalendar'
  
  #pod 'Storyly'
  pod 'Google-Mobile-Ads-SDK'
  

  target '句句Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target '句句UITests' do
    # Pods for testing
  end

end

target 'widgetExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  pod 'SDWebImageSwiftUI'
  pod 'GoogleUtilities'
  pod 'Google-Mobile-Ads-SDK'
  
end
