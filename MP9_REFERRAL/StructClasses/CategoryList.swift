//
//  CategoryList.swift
//  MP9_REFERRAL
//
//  Created by macrew on 26/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct CategoryList: Decodable {
    
    var categories: [Categories]
    
    enum CodingKeys : String, CodingKey {
        case categories
        
    }
    
}

struct Categories: Decodable {
    let id: Int?
    let name: String?
    let status: Int?
    let created: String?
    let subCatStatus: Int?
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case status
        case created
        case subCatStatus = "sub_cat_status"
    }
}

