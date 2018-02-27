# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'RealmSwift', '~> 3.0.2'
  pod 'SwiftLint', '~> 0.25.0'
  pod 'SwiftyJSON', '~> 4.0.0'
  pod 'TagListView', '~> 1.3.0'
  pod 'DeckTransition', '~> 2.0'
  pod 'Tabman', '1.6.0'
  pod 'Alamofire', '~> 4.6'
  pod 'Alamofire-SwiftyJSON'
  pod 'markymark'
end

target 'ThaiTechEventsCalendar' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
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
