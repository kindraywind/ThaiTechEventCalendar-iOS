//
//  TabbarControllerTests.swift
//  ThaiTechEventsCalendarUITests
//
//  Created by Woramet Muangsiri on 3/1/18.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest

class TabbarControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testSelectTabbar() {
        let app = XCUIApplication()
        setupSnapshot(app)
        let tabBarsQuery = XCUIApplication().tabBars

        let exists = NSPredicate(format: "exists == 1")

        tabBarsQuery.buttons["Calendar"].tap()
        snapshot("calendar_screen_01")

//        tabBarsQuery.buttons["Settings"].tap()
//        expectation(for: exists, evaluatedWith: app.navigationBars["Settings"], handler: nil)
//        waitForExpectations(timeout: 5, handler: nil)

        tabBarsQuery.buttons["Events"].tap()
        expectation(for: exists, evaluatedWith: app.navigationBars["Upcoming events"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
