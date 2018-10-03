xcrun simctl uninstall booted com.octto.ThaiTechEventsCalendar;
xcodebuild test -quiet -workspace ThaiTechEventsCalendar.xcworkspace -scheme ThaiTechEventsCalendarTests CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -destination 'platform=iOS Simulator,name=iPhone 7' | xcpretty -c;
