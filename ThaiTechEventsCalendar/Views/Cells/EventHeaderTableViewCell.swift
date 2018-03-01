//
//  EventHeaderTableViewCell.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/25/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit
import TagListView

class EventHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topicTagListView: TagListView!
    weak var rootVC: UIViewController?
    weak var event: Event?
    override func awakeFromNib() {
        super.awakeFromNib()
        topicTagListView.textFont = UIFont.systemFont(ofSize: 15)
        topicTagListView.alignment = .left
    }

    @IBAction func tapShareButton(_ sender: UIButton) {
        guard let event = event else {
            return
        }
        let baseUrl = "https://calendar.thaiprogrammer.org/event/"
        let link = baseUrl + event.eventId
        let eventTitle = event.title

        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: [eventTitle, link], applicationActivities: nil)

        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender

        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = .down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        rootVC?.present(activityViewController, animated: true, completion: nil)
    }
}
extension EventHeaderTableViewCell: Updatable {
    func updateUIWith(_ event: Event) {
        self.event = event
        headerLabel.text = event.title
        topicTagListView.removeAllTags()
        event.categories.forEach({ topicTagListView.addTag($0) })
        event.topics.forEach({ topicTagListView.addTag($0) })
    }
}
