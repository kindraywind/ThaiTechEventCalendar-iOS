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

// MARK: - Configurable constants
private let itemHeight: CGFloat = 170
private let lineSpacing: CGFloat = 20
private let xInset: CGFloat = 10
private let topInset: CGFloat = 10

class EventFeedViewController: UIViewController {
    fileprivate let cellId = "EventCollectionViewCell"
    @IBOutlet private weak var collectionView: UICollectionView!
    let realm = try! Realm() //やばいよ
    let events = try! Realm()
        .objects(Event.self)
        .sorted(byKeyPath: "start", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL ?? "")
        let nib = UINib(nibName: cellId, bundle: nil)
        collectionView.register( nib, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset.bottom = itemHeight
        populate()
        configureCollectionViewLayout()
        setUpNavBar()
    }

    private func setUpNavBar() {
        navigationItem.title = "Event list"
        navigationController?.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    private func configureCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.estimatedItemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
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

extension EventFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCollectionViewCell
        let event = events[indexPath.row]
        cell.updateUIWith(event)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPaths = collectionView.indexPathsForSelectedItems,
            let indexPath = indexPaths.first {
            let dest = segue.destination as! EventDetailViewController
            dest.event = events[(indexPath.row)]
        }

    }
}
