//
//  BusinessOffer.swift
//  MP9_REFERRAL
//
//  Created by macrew on 09/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct BusinessOffer: Decodable {
    let offerId: Int?
    //let businessId: Int?
    //let categoryId: Int?
    let title: String?
    let description: String?
    let actualPrice: String?
    let disCountedPrice:String?
    
    let startDate: String?
    let endDate: String?
    // let status:Int?
    
    enum CodingKeys : String, CodingKey {
        case offerId = "offer_id"
        //case businessId = "business_id"
        //case categoryId = "category_id"
        case title = "title"
        case description = "description"
        case actualPrice = "actual_price"
        case disCountedPrice = "discounted_price"
        case startDate = "start_date"
        case endDate = "end_date"
        // case status = "status"
        
        
    }
}





