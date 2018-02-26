//
//  EventTabViewController.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/25/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import RealmSwift

class EventTabViewController: TabmanViewController {
    var viewControllers = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIBar()
        populateVC()
    }

    private func configureUIBar() {
        bar.style = .bar
        bar.location = .top
        bar.items = [Item(title: "Upcoming events"),
                     Item(title: "Past events")]
        bar.appearance = TabmanBar.Appearance({ appearance in
            appearance.indicator.color = UIColor.TTOrange()
            appearance.indicator.bounces = true
            appearance.indicator.useRoundedCorners = true
        })
    }

    private func populateVC() {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    guard let upcomingEventNavVC = storyboard.instantiateViewController(withIdentifier: "eventDetailNav") as? UINavigationController,
        let pastEventNavVC = storyboard.instantiateViewController(withIdentifier: "eventDetailNav") as? UINavigationController,
        let upcomingVC = upcomingEventNavVC.viewControllers.first as? EventFeedViewController,
        let pastEventVC = pastEventNavVC.viewControllers.first as? EventFeedViewController,
        let upcomingEvents = upcomingEvents(),
        let pastEvents = pastEvents() else {
            return
        }

    upcomingVC.events = upcomingEvents
    upcomingVC.title = "Upcoming events"
    pastEventVC.events = pastEvents
    pastEventVC.title = "Past events"
    viewControllers.append(upcomingEventNavVC)
    viewControllers.append(pastEventNavVC)
    self.dataSource = self
    }

    private func upcomingEvents() -> Results<Event>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let upcomingPredicate = NSPredicate(format: "start >= %@", Date() as NSDate)
        return realm
            .objects(Event.self)
            .filter(upcomingPredicate)
            .sorted(byKeyPath: "start", ascending: true)
    }

    private func pastEvents() -> Results<Event>? {
        guard let realm = try? Realm() else {
            return nil
        }
        let pastPredicate = NSPredicate(format: "start < %@", Date() as NSDate)
        return realm
            .objects(Event.self)
            .filter(pastPredicate)
            .sorted(byKeyPath: "start", ascending: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension EventTabViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}
