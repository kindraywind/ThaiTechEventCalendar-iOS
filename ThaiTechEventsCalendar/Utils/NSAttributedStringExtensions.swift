//
//  NSAttributedStringExtensions.swift
//  ThaiTechEventsCalendar
//
//  Created by WorametMuangsiri on 2018/02/27.
//  Copyright © 2018 WM. All rights reserved.
//

import Foundation
import markymark

extension NSAttributedString {

    class func from(_ markdown: String) -> NSAttributedString {
        let markyMark = MarkyMark(build: {
            $0.setFlavor(ContentfulFlavor())
        })

        var styling = DefaultStyling()
        styling.linkStyling.textColor = UIColor.TTOrange()
        styling.paragraphStyling.baseFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        styling.listStyling.baseFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        styling.quoteStyling.baseFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        styling.quoteStyling.isItalic = false
        let configuration = MarkDownToAttributedStringConverterConfiguration(styling: styling)
        let converter = MarkDownConverter(configuration: configuration)
        let str = markyMark.parseMarkDown(markdown)
        return converter.convert(str)
    }
}
