platform :ios, '11.0'
use_frameworks!
use_modular_headers!
inhibit_all_warnings! # supresses pods project warnings

def common
  pod 'MERLin'
  pod 'RxDataSources'
  pod 'SwiftGen', '~> 5.3.0'
end

target 'Huge-PGA' do
  common  
end

abstract_target 'Modules' do
  common
  
  target 'HFoundation'
end

