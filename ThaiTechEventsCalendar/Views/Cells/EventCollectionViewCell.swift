//
//  EventCollectionViewCell.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit
import TagListView

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var topicTagListView: TagListView!

    let dateFormatter = DateFormatter()
    let weekdayFormatter = DateFormatter()
    var isHeightCalculated = false

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
        topicTagListView.textFont = UIFont.systemFont(ofSize: 15)
        topicTagListView.alignment = .left // possible values are .Left, .Center, and .Right

        dateFormatter.dateFormat = "MMM d"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        weekdayFormatter.dateFormat = "E"
        weekdayFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
    }

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
        event.topics.forEach({ topicTagListView.addTag($0) })
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
}

struct Event2 {
    let title = "55535344234234234234234"
    let summary = "rrsgdsfghhdfsdaghjfdghjfdsafgh"
}
