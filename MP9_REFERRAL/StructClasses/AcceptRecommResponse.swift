//
//  AcceptRecommResponse.swift
//  MP9_REFERRAL
//
//  Created by macrew on 17/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct AcceptRecommResponse: Decodable {
    let badge : Int?
    
    enum CodingKeys : String, CodingKey {
        case badge
        
    }
}
