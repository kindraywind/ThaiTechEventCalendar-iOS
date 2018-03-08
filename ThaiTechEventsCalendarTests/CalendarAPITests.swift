//
//  JsonParsingTests.swift
//  ThaiTechEventsCalendarTests
//
//  Created by Woramet Muangsiri on 2/25/18.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
import Foundation
import SwiftyJSON
import RealmSwift

@testable import ThaiTechEventsCalendar

class CalendarAPITests: XCTestCase {

    private func populate() {
        guard let path = Bundle.main.path(forResource: "calendar", ofType: "json"),
            let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8),
            let realm = try? Realm() else {
                XCTFail("Failed to populated")
                return
        }
        let json = JSON(parseJSON: jsonString)
        try! realm.write {
            json.arrayValue.forEach({ realm.add(Event($0), update: true) })
        }

    }

    private func destroyRealm() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }

        } catch {
            XCTFail("FAIL")
        }
    }

    override func setUp() {
        super.setUp()
        destroyRealm()
    }

    func testRealmShouldBeEmptyForTheFirstTime() {
        guard let realm = try? Realm() else {
            XCTFail("FAIL")
            return
        }

        XCTAssertEqual(realm.objects(Event.self).count, 0)
        XCTAssertEqual(realm.objects(Link.self).count, 0)
        XCTAssertEqual(realm.objects(Location.self).count, 0)
    }

    func testParsingJsonToRealmObjects() {
        guard let realm = try? Realm() else {
            XCTFail("FAIL")
            return
        }

        XCTAssertEqual(realm.objects(Event.self).count, 0)
        populate()
        XCTAssertEqual(realm.objects(Event.self).count, 28)
        XCTAssertEqual(realm.objects(Link.self).count, 45)
        XCTAssertEqual(realm.objects(Location.self).count, 23)
    }

    func testUpdatingRealmObjectsWithPrimaryKey() {
        guard let realm = try? Realm() else {
            XCTFail("FAIL")
            return
        }

        XCTAssertEqual(realm.objects(Event.self).count, 0)
        populate()
        populate()
        XCTAssertEqual(realm.objects(Event.self).count, 28, "The event count should be still 28")
        XCTAssertEqual(realm.objects(Link.self).count, 45)
        XCTAssertEqual(realm.objects(Location.self).count, 23)
    }

    func testGetEventOnThatDate() {
        guard let realm = try? Realm() else {
            XCTFail("FAIL")
            return
        }
        XCTAssertEqual(realm.objects(Event.self).count, 0)
        populate()
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 2
        dateComponents.day = 22
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+7")
        let userCalendar = Calendar(identifier: .gregorian)
        let eightMarch = userCalendar.date(from: dateComponents)
        let events = CalendarAPI().events(on: eightMarch!)
        XCTAssertEqual(events?.count, 2)
    }

    func testGetEventOnThatBuddhistDate() {
        guard let realm = try? Realm() else {
            XCTFail("FAIL")
            return
        }
        XCTAssertEqual(realm.objects(Event.self).count, 0)
        populate()
        var dateComponents = DateComponents()
        dateComponents.year = 2561
        dateComponents.month = 2
        dateComponents.day = 22
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+7")
        let userCalendar = Calendar(identifier: .buddhist)
        let eightMarch = userCalendar.date(from: dateComponents)
        let events = CalendarAPI().events(on: eightMarch!)
        XCTAssertEqual(events?.count, 2)
    }

    func testPerformanceExample() {
        self.measure {
            populate()
        }
    }
}
