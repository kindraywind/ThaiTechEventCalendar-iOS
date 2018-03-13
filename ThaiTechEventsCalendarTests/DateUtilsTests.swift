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

    func testDateString() {
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 3
        dateComponents.day = 31
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+7")
        var dateComponents2 = DateComponents()
        dateComponents2.year = 2018
        dateComponents2.month = 4
        dateComponents2.day = 22
        dateComponents2.timeZone = TimeZone(abbreviation: "GMT+7")
        let userCalendar = Calendar(identifier: .gregorian)
        let march31 = userCalendar.date(from: dateComponents)!
        let april22 = userCalendar.date(from: dateComponents2)!
        XCTAssertEqual(DateUtils.dateString(fromDate: march31, toDate: april22), "March 31 (Sat) ~ April 22 (Sun)")
    }

    func testDateStringSingleDay() {
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 3
        dateComponents.day = 31
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+7")

        var dateComponents2 = DateComponents()
        dateComponents2.year = 2018
        dateComponents2.month = 3
        dateComponents2.day = 31
        dateComponents2.timeZone = TimeZone(abbreviation: "GMT+7")

        let userCalendar = Calendar(identifier: .gregorian)
        let march31 = userCalendar.date(from: dateComponents)!
        let anotherMarch31 = userCalendar.date(from: dateComponents2)!
        XCTAssertEqual(DateUtils.dateString(fromDate: march31, toDate: anotherMarch31), "March 31 (Sat)")
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
}
