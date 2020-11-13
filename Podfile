platform :ios, '11.0'
use_frameworks!
use_modular_headers!
inhibit_all_warnings! # supresses pods project warnings

def common
  pod 'SwiftGen', '~> 5.3.0'
end

def animation
  pod 'Hero'
  pod 'lottie-ios'
end

def reactive
  pod 'MERLin'
end

target 'Huge-PGA' do
  common
  reactive
  animation
  
  pod 'BLECore'
  pod 'BoseWearable'
  pod 'RxCoreLocation'
  pod 'SwiftFormat/CLI', '0.39.4'
end

abstract_target 'Modules' do
  common
  reactive
  animation
  
  pod 'RxDataSources'
  pod 'XMLParsing'
  
  target 'HFoundation' do
    pod 'BLECore'
    pod 'BoseWearable'
    
    pod 'WorldMagneticModel', '~> 1.0'
    
    pod 'MapboxNavigation'
    pod 'MapboxCoreNavigation'
  end
  
  target 'HomeModule'
  
  target 'OnboardingModule'
  target 'TutorialListModule'
  
  target 'DiscoveryTutorialModule'
  target 'NavigationTutorialModule'
end

post_install do |installer|
  system("git config core.hooksPath .githooks")
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'DWARF'
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
    end
    
    if target.name == 'RxCocoa'
        puts "Patching RxCocoa references to UIWebView"
        
        root = File.join(File.dirname(installer.pods_project.path), 'RxCocoa')
        `chflags -R nouchg #{root}`
        `grep --include=UIWebView+Rx.swift -rl '#{root}' -e "os\(iOS\)" | xargs sed -i '' 's/os(iOS)/false/'`
        `grep --include=RxWebViewDelegateProxy.swift -rl '#{root}' -e "os\(iOS\)" | xargs sed -i '' 's/os(iOS)/false/'`
        `grep --include=Deprecated.swift -rl '#{root}' -e "extension UIWebView" | xargs sed -i '' '/extension UIWebView/{N;N;N;N;N;d;}'`
    end
  end
end
