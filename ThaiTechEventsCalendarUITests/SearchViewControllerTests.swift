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
        let searchButton = app.tabBars.buttons["Search"]
        searchButton.tap()
        app.searchFields["Events"].tap()
        app.staticTexts["b"].tap()
        let kStaticText = app.staticTexts["k"]
        kStaticText.tap()
        kStaticText.tap()

        app.tables.firstMatch.swipeUp()

        XCTAssertFalse(app.keyboards.firstMatch.exists)

        let cell = app.tables.firstMatch.cells.firstMatch
        let detailTable = app.tables["detailTableView"]
        sleep(1)
        XCTAssertTrue(cell.exists)
        XCTAssertFalse(detailTable.exists)

        cell.tap()
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: detailTable, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

    }

}
