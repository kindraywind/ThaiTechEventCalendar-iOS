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
    var events: Results<Event>?
    var upcomingEvents: Results<Event>?
    var pastEvents: Results<Event>?

    let nib = UINib(nibName: EventTableViewCell.nibName, bundle: nil)
    let calendarAPI = CalendarAPI()

    lazy var searchController: UISearchController = {
        let searchCon = UISearchController(searchResultsController: nil)
        searchCon.searchBar.placeholder = "Events"
        searchCon.searchResultsUpdater = self
        searchCon.dimsBackgroundDuringPresentation = false
        searchCon.obscuresBackgroundDuringPresentation = false
        return searchCon
    }()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        events = try! Realm().objects(Event.self)

        self.tabBarController?.delegate = self
        tableView.register(nib, forCellReuseIdentifier: EventTableViewCell.identifier)
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }

}

// MARK: - TableView datasource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as! EventTableViewCell
        let eventList = indexPath.section == 0 ? upcomingEvents : pastEvents
        if let event = eventList?[indexPath.row] {
            cell.updateUIWith(event)
            cell.summaryLabel.text = ""
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return (upcomingEvents?.isEmpty ?? true) ? nil : NSLocalizedString(LocalizationId.upcomingEvents, comment: "")
        case 1:
            return (pastEvents?.isEmpty ?? true) ? nil : NSLocalizedString(LocalizationId.pastEvents, comment: "")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if !isSearching {
//            return 0
//        }

        switch section {
        case 0: return upcomingEvents?.count ?? 0
        case 1: return pastEvents?.count ?? 0
        default: return 0
        }
    }
}

// MARK: - TableView delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetail", sender: nil)
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let dest = segue.destination as? EventDetailViewController else {
                return
        }

        var event: Event?

        switch indexPath.section {
        case 0: event = upcomingEvents?[(indexPath.row)]
        case 1: event = pastEvents?[(indexPath.row)]
        default: event = nil
        }

        if let event = event {
            dest.event = event
            dest.modalPresentationCapturesStatusBarAppearance = true
        }
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
            return
        }
        updateTableAndTitle(query)
    }

    private func updateTableAndTitle(_ query: String) {
        events = calendarAPI.eventsFromSearch(text: query)
        upcomingEvents = calendarAPI.upcomingEventsFrom(events: events)
        pastEvents = calendarAPI.pastEventsFrom(events: events)

        tableView.reloadSections([0, 1], with: .automatic)
        navigationItem.prompt = "Found \(events?.count ?? 0) Results for: \"\(query)\""
        navigationItem.title = "Search"
    }

}

// MARK: - Scroll and Tabbar delegate for dismissing keyboard
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
extension SearchViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //for preventing weird layout bug....
        searchController.isActive = false
    }
}
// MARK: -
