//
//  ResponseBody.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct ResponseBody {
    var statusCode: Int
    var bodyData: Data?
    var responseMessage: String?
    
    init?(json: Dictionary<String, Any>?) {
        guard let json = json else { return nil }
        if let statusCode = json["status"] as? Int {
            self.statusCode = statusCode
            self.responseMessage = json["ResponseMessage"] as? String
            if let data = json["ResponseBody"] , JSONSerialization.isValidJSONObject(data) {
                self.bodyData = try? JSONSerialization.data(withJSONObject: data, options: [])
                
                do {
                    
                    if  let json = try JSONSerialization.jsonObject(with:self.bodyData!, options: .mutableContainers) as? NSDictionary
                        {
                            print("jasonResponse====\(String(describing: json))")
                           
                        }
                }
                catch {
                   
                }
                
            }
        } else {
            print("Wrning: Response Body parsing not valid")
            return nil
        }
    }
    
    init?(data: Data?) {
        guard let _ = data else {return nil}
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            self.init(json: responseJSON as? [String: Any])
        } catch let error {
            print("Parsing response body error:", error.localizedDescription)
            return nil
        }
    }
}
