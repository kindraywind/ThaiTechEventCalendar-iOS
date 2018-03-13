//
//  SearchViewControllerTests.swift
//  ThaiTechEventsCalendarUITests
//
//  Created by Woramet Muangsiri on 3/12/18.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest

class SearchViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

    }

    func testSearchAndTapResult() {

        let app = XCUIApplication()
        let exists = NSPredicate(format: "exists == 1")
        let notExists = NSPredicate(format: "exists == 0")
        let searchButton = app.tabBars.buttons["Search"]
        searchButton.tap()
        app.searchFields["Events"].tap()
        app.searchFields["Events"].typeText("bkk")
        sleep(1)

        app.tables.firstMatch.swipeUp()

        expectation(for: notExists, evaluatedWith: app.keyboards.firstMatch, handler: nil)

        let cell = app.tables.firstMatch.cells.firstMatch
        let detailTable = app.tables["detailTableView"]
        sleep(1)
        expectation(for: exists, evaluatedWith: cell, handler: nil)
        expectation(for: notExists, evaluatedWith: detailTable, handler: nil)
        sleep(1)
        cell.tap()

        expectation(for: exists, evaluatedWith: detailTable, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }

}
