# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def base_pods
  pod 'Alamofire', '~> 4.6'
  pod 'Alamofire-SwiftyJSON'
  pod 'RealmSwift', '~> 3.0.2'
  pod 'SwiftLint', '~> 0.25.0'
  pod 'SwiftyJSON', '~> 4.0.0'
end

def shared_pods
  pod 'CVCalendar', '~> 1.6.1'
  pod 'Crashlytics', '~> 3.10.0'
  pod 'DeckTransition', '~> 2.0'
  pod 'Fabric', '~> 1.7.3'
  pod 'Firebase/Core'
  pod 'Tabman', '1.6.0'
  pod 'TagListView', '~> 1.3.0'
  pod 'markymark'
end

target 'ThaiTechEventsCalendar' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  base_pods
  shared_pods

  target 'ThaiTechEventsCalendarTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ThaiTechEventsCalendarUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'TT Widget' do
  use_frameworks!
  inhibit_all_warnings!
  base_pods
end



