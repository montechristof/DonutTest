//
//  ClearScoreDonutUITests.swift
//  ClearScoreDonutUITests
//
//  Created by Chris on 13/03/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import XCTest

class ClearScoreDonutUITests: XCTestCase {
    
    var viewController: ViewController!

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
        
    }

    
    func testErrorAlert() {
        
        XCTAssertNotNil(XCUIApplication().alerts["UPS! Something went wrong"].buttons["Retry"])

    }
    
    func testLabelsForValues() {
        
        let app = XCUIApplication()
        
        XCTAssertNotNil(app.staticTexts["out of: "])
        XCTAssertNotNil(app.staticTexts["Your Credit Score is:"])
        XCTAssertNotNil(app.staticTexts["514"])
        
        
        
    
    }
    
}
