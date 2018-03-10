//
//  CalendarAPI.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/25/18.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Alamofire_SwiftyJSON
import Alamofire

// MARK: - Constants
struct TTConstant {
    static let baseAPIURL = "https://thaiprogrammer-tech-events-calendar.spacet.me"
    static let baseURL = "https://calendar.thaiprogrammer.org/event/"
}

// MARK: Calendar network API
struct CalendarAPI {

    func fetchCalendarFromNetwork() {
        fetchCalendarFromNetwork(success: nil, failure: nil)
    }

    func fetchCalendarFromNetwork(success: (() -> Void)?,
                                  failure: (() -> Void)?) {
        guard let realm = try? Realm() else { failure?(); return }

        Alamofire.request(TTConstant.baseAPIURL+"/calendar.json").responseSwiftyJSON { dataResponse in
            if dataResponse.error != nil { failure?(); return }
            guard let json = dataResponse.value else { failure?(); return }

            try? realm.write {
                json.arrayValue.forEach({ realm.add(Event($0), update: true) })
                success?()
            }
        }
    }

}

// MARK: - Events query by start date
extension CalendarAPI {
    // MARK: - Events by start date
    func events(when predicate: NSPredicate, ascending isAscending: Bool) -> Results<Event>? {
        guard let realm = try? Realm() else { return nil }

        return realm
            .objects(Event.self)
            .filter(predicate)
            .sorted(byKeyPath: "start", ascending: isAscending)
    }

    func events(on date: Date) -> Results<Event>? {
        let tmr = date.addingTimeInterval(24 * 60 * 60)
        let today = NSPredicate(format: "start >= %@ AND end <= %@", date as NSDate, tmr as NSDate)
        return events(when: today, ascending: true)
    }

    func upcomingEvents() -> Results<Event>? {
        let upcoming = NSPredicate(format: "start >= %@", Date().gregorianDate() as NSDate)
        return events(when: upcoming, ascending: true)
    }

    func pastEvents() -> Results<Event>? {
        let alreadyPassed = NSPredicate(format: "start < %@", Date().gregorianDate() as NSDate)
        return events(when: alreadyPassed, ascending: false)
    }
}

// MARK: - Events searching
extension CalendarAPI {
    func eventsFromSearch(text: String) -> Results<Event>? {
        guard let realm = try? Realm() else { return nil }
        let contain = NSPredicate(format: "title CONTAINS[c] %@", text)
        return realm
            .objects(Event.self)
            .filter(contain)
            .sorted(byKeyPath: "start", ascending: false)
    }
}
