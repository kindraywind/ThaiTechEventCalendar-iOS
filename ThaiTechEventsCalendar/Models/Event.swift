//
//  Event.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Event: Object {
    @objc dynamic var eventId = ""
    @objc dynamic var declared = ""
    @objc dynamic var desc = ""
    @objc dynamic var start = Date()
    @objc dynamic var end = Date()
    @objc dynamic var location: Location?
    @objc dynamic var summary = ""
    @objc dynamic var time = ""
    @objc dynamic var title = ""
    let categories = List<String>()
    let links = List<Link>()
    let topics = List<String>()

    required convenience init(_ json: JSON) {
        self.init()
        mapping(json)
    }

    override static func primaryKey() -> String? {
        return "eventId"
    }

    // Mappable
    func mapping(_ json: JSON) {
        eventId = json["id"].stringValue
        declared = json["declared"].stringValue
        desc = json["description"].stringValue
        end = parseDate(json["end"])
        location = Location(json["location"])
        start = parseDate(json["start"])
        summary = json["summary"].stringValue
//        time =
        title = json["title"].stringValue

        json["categories"].arrayValue.forEach({ categories.append($0.stringValue) })
        json["links"].arrayValue.forEach({ links.append(Link($0)) })
        json["topics"].arrayValue.forEach({ topics.append($0.stringValue) })
    }

    private func parseDate(_ dateJson: JSON) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = dateJson["year"].intValue
        dateComponents.month = dateJson["month"].intValue
        dateComponents.day = dateJson["date"].intValue
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+7")
        let userCalendar = Calendar.current // user calendar

        return userCalendar.date(from: dateComponents) ?? Date()
    }

}

class Location: Object {
    @objc dynamic var detail = ""
    @objc dynamic var title = ""
    @objc dynamic var url = ""

    required convenience init(_ json: JSON) {
        self.init()
        mapping(json)
    }
    func mapping(_ json: JSON) {
        detail = json["detail"].stringValue
        title = json["title"].stringValue
        url = json["url"].stringValue
    }
}

class Link: Object {
    @objc dynamic var detail = ""
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    @objc dynamic var type = ""
    @objc dynamic var price = ""

    required convenience init(_ json: JSON) {
        self.init()
        mapping(json)
    }

    func mapping(_ json: JSON) {
        detail = json["detail"].stringValue
        title = json["title"].stringValue
        url = json["url"].stringValue
        type = json["type"].stringValue
        price = json["price"].stringValue
    }
}
