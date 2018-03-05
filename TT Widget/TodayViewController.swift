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

class TodayViewController: UIViewController, NCWidgetProviding {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("######## wperformupdate")
        calAPI.fetchCalendarFromNetwork(success: { [weak self] in
            self?.updateUIWith(self?.getUpcomingEvent(), displayMode: .compact)
            }, failure: nil)
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

    func getUpcomingEvent() -> Event? {
        return calAPI.upcomingEvents()?.first
    }

    func updateUI() {
        let event = getUpcomingEvent()
        titleLabel.text = event?.title
        summaryLabel.text = event?.summary
    }

    func updateUIWith(_ event: Event?, displayMode: NCWidgetDisplayMode) {
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

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
        updateUIWith(getUpcomingEvent(), displayMode: activeDisplayMode)
    }

}
