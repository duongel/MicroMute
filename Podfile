# Uncomment the next line to define a global platform for your project
platform :macos, '11.0'

target 'MicroMute' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

    pod 'Magnet'

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end