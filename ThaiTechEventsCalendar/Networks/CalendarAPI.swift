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
        guard let realm = try? Realm() else {
            return
        }

        Alamofire.request(TTConstant.baseAPIURL+"/calendar.json").responseSwiftyJSON { dataResponse in
            if dataResponse.error != nil {
                return
            }
            guard let json = dataResponse.value else {
                return
            }
            try! realm.write {
                json.arrayValue.forEach({ realm.add(Event($0), update: true) })
            }
        }
    }
}
