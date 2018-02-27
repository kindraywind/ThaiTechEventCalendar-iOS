//
//  SummaryTableViewCell.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 2/24/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var grayView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SummaryTableViewCell: Updatable {

    func updateUIWith(_ event: Event) {
        summaryLabel?.attributedText = NSAttributedString.from(event.summary)

        if event.summary.isEmpty {
            summaryLabel.isHidden = true
            grayView.isHidden = true
        }

        descLabel.attributedText = NSAttributedString.from(event.desc)
    }

}
