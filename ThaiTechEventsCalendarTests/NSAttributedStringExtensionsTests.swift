//
//  NSAttributedStringExtensionsTests.swift
//  ThaiTechEventsCalendarTests
//
//  Created by WorametMuangsiri on 2018/02/27.
//  Copyright © 2018 WM. All rights reserved.
//

import XCTest
@testable import ThaiTechEventsCalendar

class NSAttributedStringExtensionsTests: XCTestCase {

    func testAttributedStringFromMarkdownStringNotNil() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let markdownString = "- \"Every language needs its underscore: FP in Python\" - Alexander Schepanovski.\n- \"Panel Discussion: What it's like to a female in Thai tech\" - To help support the upcoming [Django Girls one day workshop 10 March 2018](https://djangogirls.org/bangkok/).\n- Short talks and lightning talks\n\nMonthly meetup for those using python, learning python of just py-curious. Python is one of more popular programming languages in the word and rising further, being used in fields such as web, science, big data, dev-ops and digital entertainment. We to have talks from beginners to advance and provide a friendly atmosphere to meet and network with your fellow pythonistas."
        let attributedString = NSAttributedString.from(markdownString)
        XCTAssertNotNil(attributedString)
    }

}
