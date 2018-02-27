//
//  DetailTableViewCell.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureLocationRow(_ event: Event) {
        iconImageView.image = UIImage(named: "map-pin")
        tag = 1
        guard  let location = event.location else {
            return
        }

        let orangeAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.TTOrange(),
            .font: UIFont.systemFont(ofSize: 17.0)
        ]
        let title = NSAttributedString(string: location.title,
                                       attributes: orangeAttributes)

        let plainAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.systemFont(ofSize: 17.0)
        ]

        let detail = NSAttributedString(string: !location.detail.isEmpty ? "\n\(location.detail)" : "",
                                        attributes: plainAttributes)

        let linkAttributedString = NSMutableAttributedString()
        linkAttributedString.append(title)
        linkAttributedString.append(detail)

        detailLabel?.attributedText = linkAttributedString
    }

}
