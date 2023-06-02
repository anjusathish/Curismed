# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Curismed' do
  # Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

  # Pods for Curismed
  pod 'SwiftGifOrigin'
  pod 'BEMCheckBox'
  pod 'DropDown'
  pod 'SideMenuSwift'
  pod 'IQKeyboardManagerSwift'
  pod "TTGSnackbar"
  pod 'SwiftyGif'
  pod 'GooglePlaces'
   pod 'SwiftKeychainWrapper'
  pod 'FSCalendar', '~> 2.8'



  target 'CurismedTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CurismedUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end
