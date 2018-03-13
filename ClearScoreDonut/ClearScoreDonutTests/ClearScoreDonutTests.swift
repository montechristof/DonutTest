//
//  ClearScoreDonutTests.swift
//  ClearScoreDonutTests
//
//  Created by Chris on 13/03/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import XCTest
@testable import ClearScoreDonut

class ClearScoreDonutTests: XCTestCase {
    

    //test correct dict parsing, using data taken from the json.
    func testCustomerInitialisation() {
        
        var customer:Customer!
        
        do {
            if let file = Bundle.main.url(forResource: "accountDetails", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let customerDetails = json as? [String: Any] {
                    customer = Customer(dictionary: customerDetails)
                    XCTAssertTrue(customer.creditScore == 514)
                    XCTAssertTrue(customer.maxCreditScore == 700)
                } else {
                    assertionFailure("Missing file at path")
                }
            } else {
                print("no file found")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    
}
