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
    var events: Results<Event>? = try! Realm().objects(Event.self) //やばいよ
    let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
    var isSearching = false

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Events"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(nib, forCellReuseIdentifier: "EventTableViewCell")
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
//    }
//
//    @objc func keyboardWillAppear() {
//        //Do something here
//    }
//
//    @objc func keyboardWillDisappear() {
//        //Do something here
//        searchController.resignFirstResponder()
//    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
}

// MARK: - TableView datasource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        if let event = events?[indexPath.row] {
            cell.updateUIWith(event)
            cell.summaryLabel.text = ""
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
        performSegue(withIdentifier: "eventDetail", sender: nil)
        searchController.searchBar.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let dest = segue.destination as? EventDetailViewController,
            let event = events?[(indexPath.row)] else {
                return
        }

            dest.event = event
            dest.modalPresentationCapturesStatusBarAppearance = true
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
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
        updateTableAndTitle(query)
    }

    private func updateTableAndTitle(_ query: String) {
        isSearching = true
        events = CalendarAPI().eventsFromSearch(text: query)
        tableView.reloadSections([0], with: .automatic)
        navigationItem.prompt = "Found \(events?.count ?? 0) Results for: \"\(query)\""
        navigationItem.title = "Search"
    }

}
