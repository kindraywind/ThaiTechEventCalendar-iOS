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
    let calAPI = CalendarAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("######## wperformupdate")
        calAPI.fetchCalendarFromNetwork(success: { [weak self] in
            self?.getUpcomingEvent()
            }, failure: nil)
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

    func getUpcomingEvent() {
        let event = calAPI.upcomingEvents()?.first
        print(event?.title)
    }
    
    func updateUI() {
        
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }

}
