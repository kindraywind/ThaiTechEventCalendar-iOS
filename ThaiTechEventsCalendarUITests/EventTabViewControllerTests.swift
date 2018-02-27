//
//  EventTabViewControllerTests.swift
//  ThaiTechEventsCalendarUITests
//
//  Created by Woramet Muangsiri on 2/25/18.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest

class EventTabViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testUpComingFeedIsDefaultTab() {
        let app = XCUIApplication()
        setupSnapshot(app)
        XCTAssertTrue(app.navigationBars["Upcoming events"].exists)
        snapshot("Upcoming_screen01")
    }

    func testSwipeLeftFromUpcomingEvents() {
        let app = XCUIApplication()
        XCTAssertTrue(app.navigationBars["Upcoming events"].exists)
        let table = app.tables.firstMatch
        table.swipeLeft()

        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: app.navigationBars["Past events"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSwipeRightFromUpComingEvents() {
        let app = XCUIApplication()
        XCTAssertTrue(app.navigationBars["Upcoming events"].exists)
        let table = app.tables.firstMatch
        table.swipeRight()

        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: app.navigationBars["Upcoming events"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSwipeRightFromPastEvents() {
        let app = XCUIApplication()
        let table = app.tables.firstMatch
        table.swipeLeft()
        sleep(1)
        table.swipeRight()
        sleep(1)
        XCTAssertTrue(app.navigationBars["Upcoming events"].exists)
    }
}
