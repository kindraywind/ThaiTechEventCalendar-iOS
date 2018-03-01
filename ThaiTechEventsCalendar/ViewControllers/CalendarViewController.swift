//
//  CalendarViewController.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 3/1/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit
import CVCalendar
import RealmSwift

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!

    @IBOutlet weak var tableView: UITableView!
    private let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
    private var currentCalendar: Calendar?
    let events = try! Realm().objects(Event.self)

    override func awakeFromNib() {
        let timeZoneBias = 420 // (Bangkok UTC+07:00)
        currentCalendar = Calendar(identifier: .gregorian)
        if let timeZone = TimeZone(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentCalendar = currentCalendar else {
            return
        }
        self.navigationItem.title = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        self.tableView.register(nib, forCellReuseIdentifier: "EventTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        calendarMenuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }

}

extension CalendarViewController: CVCalendarViewDelegate {
    func presentationMode() -> CalendarMode {
        return .monthView
    }

    func firstWeekday() -> Weekday {
        return .sunday
    }
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        print(dayView.date.day)
    }
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
}

extension CalendarViewController: CVCalendarMenuViewDelegate {
    func presentedDateUpdated(_ date: CVDate) {
        self.navigationItem.title = date.globalDescription
    }

}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        cell.updateUIWith(event)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let dest = segue.destination as! EventDetailViewController
            dest.event = events[(indexPath.row)]
            dest.modalPresentationCapturesStatusBarAppearance = true
        }

    }
}
