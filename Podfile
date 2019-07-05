# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BrakhQ' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BrakhQ
  pod 'Moya', '~> 13.0'
  pod 'Starscream', '~> 3.1'
  pod 'CalendarKit'
  pod 'Eureka'
  pod 'DataCache'
  pod 'KeychainSwift', '~> 16.0'
  pod 'RealmSwift'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    installer.pods_project.targets.each do |target|
        target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
