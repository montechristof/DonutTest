//
//  Request.swift
//  ClearScoreDonut
//
//  Created by Chris on 13/03/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation

struct Customer {
    let maxCreditScore: Double
    let creditScore: Double
    
    init(dictionary: [String: Any]) {
        self.maxCreditScore = dictionary["maxScoreValue"] as? Double ?? 0
        self.creditScore = dictionary["score"] as? Double ?? 0
    }
    
}

class Request {
    
    func getCustomerDataFromURL(completion: @escaping (Customer?, Error?) -> ()){
        
        let url = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { completion(nil, error); return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let rawData = json["creditReportInfo"] as? [String: Any] ?? [:]
                let customer = Customer(dictionary: rawData)
                completion(customer, nil)
            } catch let error as NSError {
                completion(nil, error)
            }
        }).resume()
        
        
    }
}
