//
//  EventDetailViewControllerTests.swift
//  ThaiTechEventsCalendarUITests
//
//  Created by Woramet Muangsiri on 3/1/18.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest

class EventDetailViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testTapEventCellShare() {
        let app = XCUIApplication()
        setupSnapshot(app)
        let cell = app.tables.firstMatch.cells.firstMatch
        let detailTable = app.tables["detailTableView"]
        sleep(1)
        XCTAssertTrue(cell.exists)
        XCTAssertFalse(detailTable.exists)

        cell.tap()
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: detailTable, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        let shareButton = app.buttons["share"]
        shareButton.tap()
        let activityListView = app.otherElements["ActivityListView"]
        expectation(for: exists, evaluatedWith: activityListView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

    }

}
