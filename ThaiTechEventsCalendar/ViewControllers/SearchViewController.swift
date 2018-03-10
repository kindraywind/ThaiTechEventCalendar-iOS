//
//  SearchViewController.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 3/4/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    var events: Results<Event>? = try! Realm().objects(Event.self) //やばいよ、 dependency injectionの方がいいよ。
    let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
    var isSearching = false
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        tableView.register(nib, forCellReuseIdentifier: "EventTableViewCell")
        configureRealmNotification()
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = search
        } else {
            // Fallback on earlier versions
        }
    }

    private func configureRealmNotification() {
        // Observe Results Notifications
        notificationToken = events?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
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

// MARK: - TableView datasource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        if let event = events?[indexPath.row] {
            cell.updateUIWith(event)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? (events?.count ?? 0) : (0)
    }
}

// MARK: - TableView delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - SearchViewController results updating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchController)
        perform(#selector(self.reload(_:)), with: searchController, afterDelay: 0.2)
    }

    @objc private func reload(_ searchController: UISearchController) {
        guard let query = searchController.searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            //nothing to search
            isSearching = false
            return
        }
        isSearching = true
        events = CalendarAPI().eventsFromSearch(text: query)
        tableView.reloadSections([0], with: .automatic)
        navigationItem.prompt = "Found \(events?.count ?? 0) Results for:"
        navigationItem.title = "\"\(query)\""
    }

}
