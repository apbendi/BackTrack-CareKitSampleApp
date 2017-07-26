platform :ios, '9.0'

target 'BackTrack' do
  use_frameworks!

  pod 'CMHealth', :git => 'git@github.com:cloudmine/CMHealthSDK-iOS.git'
  pod 'CareKit', :path => '../CareKit/'

  target 'BackTrackTests' do
    inherit! :search_paths
  end

  target 'BackTrackUITests' do
    inherit! :search_paths
  end
end
