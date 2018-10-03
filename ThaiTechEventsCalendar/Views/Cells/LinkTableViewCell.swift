//
//  LinkTableViewCell.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/25/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textLabel?.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension LinkTableViewCell: Updatable {

    func updateUIWith(_ event: Event) {
        assertionFailure("Use updateUIWith(event:indexPath: for this one.)")
    }

    func updateUIWith(_ event: Event, _ indexPath: IndexPath) {
        let link = event.links[indexPath.row]
        let orangeAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.TTOrange(),
            .font: UIFont.systemFont(ofSize: 17.0)
        ]
        let title = NSAttributedString(string: link.title, attributes: orangeAttributes)

        let plainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17.0)
        ]
        let type = NSAttributedString(string: " (\(link.type))", attributes: plainAttributes)
        let price = NSAttributedString(string: " \(link.price)", attributes: plainAttributes)

        let linkAttributedString = NSMutableAttributedString()
        linkAttributedString.append(title)
        linkAttributedString.append(type)
        linkAttributedString.append(price)

        textLabel?.attributedText = linkAttributedString
    }

}
