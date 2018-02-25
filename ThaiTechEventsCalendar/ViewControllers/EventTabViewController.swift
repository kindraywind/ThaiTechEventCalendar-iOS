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
    let upcomingEventNavVC = storyboard.instantiateViewController(withIdentifier: "eventDetailNav")
    let pastEventNavVC = storyboard.instantiateViewController(withIdentifier: "eventDetailNav")
    
    viewControllers.append(upcomingEventNavVC)
    viewControllers.append(pastEventNavVC)
    self.dataSource = self
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
