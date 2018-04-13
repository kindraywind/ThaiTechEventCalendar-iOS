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
    private let nib = UINib(nibName: EventTableViewCell.nibName, bundle: nil)
    private var cachedDots = Array(repeating: 0, count: 32)
    var events: Results<Event>?

    lazy var placeholder: EmptyPlaceholder = {
       let pholder = EmptyPlaceholder.instanceFromNib()
        pholder.emptyLabel.text = "Relax, no tech event this day :)"
        pholder.emptyImageView.image = UIImage(named: "beach")
        return pholder
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentedDateUpdated(CVDate(date: Date()))
        self.tableView.register(nib, forCellReuseIdentifier: EventTableViewCell.identifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarMenuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CalendarViewController: AppearanceDelegate {
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        let count = min(3, cachedDots[dayView.date.day])
        return Array(repeating: UIColor.TTOrange(), count: count)
    }

    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return UIColor.TTOrange()
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
        guard let today = dayView.date.convertedDate() else {
            return
        }
        events = CalendarAPI().events(on: today)
        tableView?.reloadSections([0], with: .automatic)
        tableView?.setContentOffset(CGPoint.zero, animated: false)

    }

    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        guard let date = dayView.date.convertedDate() else {
            return false
        }
        let count = CalendarAPI().events(on: date)?.count ?? 0
        cachedDots[dayView.date.day] = count
        return count > 0
    }
}

extension CalendarViewController: CVCalendarMenuViewDelegate {
    func presentedDateUpdated(_ date: CVDate) {
        self.navigationItem.title = date.globalDescription
    }

}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updatePlaceholder()
        return (events?.count) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as? EventTableViewCell,
            let event = events?[indexPath.row] else {
            return UITableViewCell(style: .default, reuseIdentifier: EventTableViewCell.identifier)
        }
        cell.updateUIWith(event)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let event = events?[indexPath.row],
            let dest = segue.destination as? EventDetailViewController {
            dest.event = event
            dest.modalPresentationCapturesStatusBarAppearance = true
        }

    }

    private func updatePlaceholder() {
        if let events = events, !events.isEmpty {
            tableView.backgroundView = nil
        } else {
            tableView.backgroundView = placeholder
        }
    }
}
