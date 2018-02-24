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
import VegaScrollFlowLayout
import SwiftyJSON
import DeckTransition

class EventFeedViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!

    let realm = try! Realm() //やばいよ
    let events = try! Realm()
        .objects(Event.self)
        .sorted(byKeyPath: "start", ascending: false)
    let nib = UINib(nibName: "EventTableViewCell", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL ?? "")
        populate()
        feedTableView.register(nib, forCellReuseIdentifier: "EventTableViewCell")
        setUpNavBar()
    }

    private func setUpNavBar() {
        navigationItem.title = "Event list"
        navigationController?.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Populate dummy data
    private func populate() {
        guard let path = Bundle.main.path(forResource: "calendar", ofType: "json"),
        let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            return
        }
        let json = JSON(parseJSON: jsonString)
        try! realm.write {
            json.arrayValue.forEach({ realm.add(Event($0), update: true) })
        }
    }

}

extension EventFeedViewController: UITableViewDataSource, UITableViewDelegate {
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
        if let indexPath = feedTableView.indexPathForSelectedRow {
            let dest = segue.destination as! EventDetailViewController
            dest.event = events[(indexPath.row)]
        }

    }
}
//
//extension EventFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCollectionViewCell
//        let event = events[indexPath.row]
//        cell.updateUIWith(event)
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return events.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "eventDetail", sender: nil)
//    }
//
//
//}
