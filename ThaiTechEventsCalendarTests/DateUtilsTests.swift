//
//  DateUtilsTests.swift
//  ThaiTechEventsCalendarTests
//
//  Created by Woramet Muangsiri on 2/25/18.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import ThaiTechEventsCalendar

class DateUtilsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParseDateFromJSONShouldNotBeNil() {
        let jsonString = """
                             { "year": 2018
                             , "month": 1
                             , "date": 11
                             }
                        """
        let json = JSON.init(parseJSON: jsonString)
        XCTAssertNotNil(json)
        XCTAssertNotNil(DateUtils.parseDateFrom(json))
    }

    func testParseDateFromJSONShouldBeValid() {
        let jsonString = """
                             { "year": 2018
                             , "month": 1
                             , "date": 11
                             }
                        """
        let jsonStringFuture = """
                             { "year": 3018
                             , "month": 10
                             , "date": 22
                             }
                        """
        let json = JSON.init(parseJSON: jsonString)
        let jsonFuture = JSON.init(parseJSON: jsonStringFuture)
        let someDay = DateUtils.parseDateFrom(json)
        let someDayInFuture = DateUtils.parseDateFrom(jsonFuture)
        XCTAssertNotNil(json)
        XCTAssertNotNil(someDay)
        XCTAssertNotNil(someDayInFuture)

        XCTAssertTrue(someDayInFuture > someDay)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
