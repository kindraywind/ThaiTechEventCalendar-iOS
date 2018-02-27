//
//  ThaiTechEventsCalendarUITests.swift
//  ThaiTechEventsCalendarUITests
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest

class EventFeedViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testTapEventCell() {
        let app = XCUIApplication()
        let cell = app.tables.firstMatch.cells.firstMatch
        let detailTable = app.tables["detailTableView"]

        XCTAssertTrue(cell.exists)
        XCTAssertFalse(detailTable.exists)

        cell.tap()
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: detailTable, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

}
