//
//  EmptyPlaceholder.swift
//  ThaiTechEventsCalendar
//
//  Created by Woramet Muangsiri on 3/14/18.
//  Copyright © 2018 WM. All rights reserved.
//

import UIKit

class EmptyPlaceholder: UIView {
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    class func instanceFromNib() -> EmptyPlaceholder {
        return UINib(nibName: "EmptyPlaceholder", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyPlaceholder
    }
}
