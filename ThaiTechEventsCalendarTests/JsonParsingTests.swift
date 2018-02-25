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

class JsonParsingTests: XCTestCase {

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
            realm.deleteAll()
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
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
