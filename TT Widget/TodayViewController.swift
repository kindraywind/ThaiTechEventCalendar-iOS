//
//  TodayViewController.swift
//  TT Widget
//
//  Created by Woramet Muangsiri on 3/5/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    let calAPI = CalendarAPI()
    let dateFormatter = DateFormatter()
    let weekdayFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        dateFormatter.dateFormat = "MMM d"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        weekdayFormatter.dateFormat = "E"
        weekdayFormatter.timeZone = TimeZone(abbreviation: "GMT+7")
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapRecognizer)
    }

    private func getUpcomingEvent() -> Event? {
        return calAPI.upcomingEvents()?.first
    }

    private func updateUI() {
        let event = getUpcomingEvent()
        titleLabel.text = event?.title
        summaryLabel.text = event?.summary
    }

    private func updateUIWith(_ event: Event?, displayMode: NCWidgetDisplayMode) {
        guard let event = event else {
            return
        }

        titleLabel.text = event.title
        summaryLabel.text = event.summary
//        timeLabel.text =

        let start = dateFormatter.string(from: event.start)
        let end = dateFormatter.string(from: event.end)

        if start == end {
            dateLabel.text = start
        } else {
            dateLabel.text = "\(start) ~\n\(end)"
        }
        dateLabel.text?.append(" at \(event.time)")

        if displayMode == .compact {
            summaryLabel.isHidden = true
        } else {
            summaryLabel.isHidden = false
        }
        viewDidLayoutSubviews()
    }

    @objc private func viewTapped() {
        let url = URL(string: "ttevent://")!
        extensionContext?.open(url, completionHandler: nil)
    }
}

extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        calAPI.fetchCalendarFromNetwork(success: { [weak self] in
            self?.updateUIWith(self?.getUpcomingEvent(), displayMode: .compact)
            completionHandler(NCUpdateResult.newData)
            }, failure: {
                completionHandler(NCUpdateResult.failed)
        })
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
        updateUIWith(getUpcomingEvent(), displayMode: activeDisplayMode)
    }
}
