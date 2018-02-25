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

    override func awakeFromNib() {
        super.awakeFromNib()
        topicTagListView.textFont = UIFont.systemFont(ofSize: 15)
        topicTagListView.alignment = .left
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension EventHeaderTableViewCell: Updatable {
    func updateUIWith(_ event: Event) {
        headerLabel.text = event.title
        topicTagListView.removeAllTags()
        event.categories.forEach({ topicTagListView.addTag($0) })
        event.topics.forEach({ topicTagListView.addTag($0) })
    }
}
