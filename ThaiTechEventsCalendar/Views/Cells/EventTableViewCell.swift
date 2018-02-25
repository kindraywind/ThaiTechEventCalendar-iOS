//
//  EventTableViewCell.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit
import TagListView

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var topicTagListView: TagListView!
    @IBOutlet weak var wrapperView: UIView!

    let dateFormatter = DateFormatter()
    let weekdayFormatter = DateFormatter()
    var isHeightCalculated = false

    override func awakeFromNib() {
        super.awakeFromNib()
        wrapperView.layer.cornerRadius = 14
        wrapperView.layer.shadowColor = UIColor.black.cgColor
        wrapperView.layer.shadowOpacity = 0.3
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 5)
        wrapperView.layer.masksToBounds = false
        topicTagListView.textFont = UIFont.systemFont(ofSize: 15)
        topicTagListView.alignment = .left // possible values are .Left, .Center, and .Right

        dateFormatter.dateFormat = "MMM d"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        weekdayFormatter.dateFormat = "E"
        weekdayFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension EventTableViewCell: Updatable {

    func updateUIWith(_ event: Event) {
        titleLabel.text = event.title
        summaryLabel.text = event.summary

        let start = dateFormatter.string(from: event.start)
        let startDay = weekdayFormatter.string(from: event.start)
        let end = dateFormatter.string(from: event.end)
        let endDay = weekdayFormatter.string(from: event.end)

        if start == end {
            dateLabel.text = start
            weekDayLabel.text = startDay
        } else {
            dateLabel.text = "\(start) ~\n\(end)"
            weekDayLabel.text = "\(startDay) - \(endDay)"
        }

        topicTagListView.removeAllTags()
        event.categories.forEach({ topicTagListView.addTag($0) })
        event.topics.forEach({ topicTagListView.addTag($0) })
    }

}
