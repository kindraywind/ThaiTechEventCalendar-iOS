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

struct TTConstant {
    static let baseAPIURL = "https://thaiprogrammer-tech-events-calendar.spacet.me"
    static let baseURL = "https://calendar.thaiprogrammer.org/event/"
}

struct CalendarAPI {

    func fetchCalendarFromNetwork() {
        fetchCalendarFromNetwork(success: nil, failure: nil)
    }

    func fetchCalendarFromNetwork(success: (() -> Void)?,
                                  failure: (() -> Void)?) {
        guard let realm = try? Realm() else {
            failure?()
            return
        }

        Alamofire.request(TTConstant.baseAPIURL+"/calendar.json").responseSwiftyJSON { dataResponse in
            if dataResponse.error != nil {
                failure?()
                return
            }
            guard let json = dataResponse.value else {
                failure?()
                return
            }
            try! realm.write {
                json.arrayValue.forEach({ realm.add(Event($0), update: true) })
                success?()
            }
        }
    }

}

extension CalendarAPI {
    // MARK: - Events filter (refactorable)
    func events(on date: Date) -> Results<Event>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let tmr = date.addingTimeInterval(24 * 60 * 60)
        let thatDatePredicate = NSPredicate(format: "start >= %@ AND end <= %@", date as NSDate, tmr as NSDate)
        return realm
            .objects(Event.self)
            .filter(thatDatePredicate)
            .sorted(byKeyPath: "start", ascending: true)
    }

    func upcomingEvents() -> Results<Event>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let upcomingPredicate = NSPredicate(format: "start >= %@", Date() as NSDate)
        return realm
            .objects(Event.self)
            .filter(upcomingPredicate)
            .sorted(byKeyPath: "start", ascending: true)
    }

    func pastEvents() -> Results<Event>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let pastPredicate = NSPredicate(format: "start < %@", Date() as NSDate)
        return realm
            .objects(Event.self)
            .filter(pastPredicate)
            .sorted(byKeyPath: "start", ascending: true)
    }
}
