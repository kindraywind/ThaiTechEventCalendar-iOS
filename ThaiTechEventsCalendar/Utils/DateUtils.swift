//
//  DateUtils.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation
import SwiftyJSON

class DateUtils {
    static func parseDateFrom(_ dateJson: JSON) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = dateJson["year"].intValue
        dateComponents.month = dateJson["month"].intValue
        dateComponents.day = dateJson["date"].intValue
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.timeZone = TimeZone(abbreviation: "GMT+7")
        let userCalendar = Calendar.current

        return userCalendar.date(from: dateComponents) ?? Date()
    }

    static func dateString(fromDate: Date, toDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d (E)"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")

        if fromDate == toDate {
            return "\(dateFormatter.string(from: fromDate))"
        } else {
            return "\(dateFormatter.string(from: fromDate)) ~ \(dateFormatter.string(from: toDate))"
        }

    }
}
