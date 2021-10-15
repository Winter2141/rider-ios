# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

target 'pintaxi' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  #Alamofire Webservices
  pod 'Alamofire','~>4.8.1'
  pod 'AlamofireObjectMapper','~>5.2.0'
  
  #Reachability Network check
  pod 'ReachabilitySwift'
  
  #Google
  pod 'GoogleMaps'
  pod 'GoogleSignIn'
  pod 'GooglePlaces'
  pod 'Google-Mobile-Ads-SDK'
  #Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'FloatRatingView'
  pod 'SVPinView'
  
  
  #Crashlytics
  #    pod 'Fabric'
  #    pod 'Crashlytics'
  
  #Facebook
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  #pod 'AccountKit'
  
  #Keyboard
  pod 'IQKeyboardManagerSwift'
  pod 'IHKeyboardAvoiding'
  
  #Payment & Bank
  pod 'Stripe'
  pod 'BraintreeDropIn'
  pod 'CreditCardForm', :git => 'https://github.com/orazz/CreditCardForm-iOS', branch: 'master'
  pod 'PayUmoney_PnP'
  # pod 'PayPal-iOS-SDK', '2.18.1'
  pod 'razorpay-pod', '~> 1.1.12'
  
  #Others
  pod 'lottie-ios'
  pod 'KWDrawerController'
  pod 'DateTimePicker'
  pod 'PopupDialog'
  pod 'Lightbox'
  pod 'DropDown'
  
  
  pod 'HCSStarRatingView'
  pod 'SDWebImage'
  
  # Workaround for Cocoapods issue #7606
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
  
end
