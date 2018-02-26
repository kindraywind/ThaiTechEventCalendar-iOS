xcrun simctl uninstall booted com.octto.ThaiTechEventsCalendar;
xcodebuild test -workspace ThaiTechEventsCalendar.xcworkspace -scheme ThaiTechEventsCalendarTests CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -destination 'platform=iOS Simulator,name=iPhone 7';
