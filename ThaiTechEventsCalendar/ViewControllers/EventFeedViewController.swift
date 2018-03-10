//
//  EventFeedViewController.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//
//shamelessly copied from VegaScrollFlowLayout

import UIKit
import RealmSwift
import SwiftyJSON
import DeckTransition

class EventFeedViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!

    let realm = try! Realm()
    var events: Results<Event>! //やばいよ、 dependency injectionの方がいいよ。
    let nib = UINib(nibName: EventTableViewCell.nibName, bundle: nil)
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL ?? "")
        configureRealmNotification()
        feedTableView.register(nib, forCellReuseIdentifier: EventTableViewCell.identifier)
    }

    private func configureRealmNotification() {
        // Observe Results Notifications
        notificationToken = events.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.feedTableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        notificationToken?.invalidate()
    }

}

extension EventFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        cell.updateUIWith(event)
        return cell
    }
}

extension EventFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = feedTableView.indexPathForSelectedRow {
            let dest = segue.destination as! EventDetailViewController
            dest.event = events[(indexPath.row)]
            dest.modalPresentationCapturesStatusBarAppearance = true
        }

    }
}
