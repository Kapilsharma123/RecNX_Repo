//
//  SubCategoryList.swift
//  MP9_REFERRAL
//
//  Created by macrew on 26/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct SubCategoryList: Decodable {
    
    var subCategories: [SubCategories]
    
    enum CodingKeys : String, CodingKey {
        case subCategories = "sub_categories"
        
    }
    
}

struct SubCategories: Decodable {
    let id: Int?
    let categoryId: Int?
    let subCatName: String?
    let status: Int?
    let created: String?
    let name: String?
    let subCatStatus: Int?
    var selected: Int?
    var scalar: String?
    enum CodingKeys : String, CodingKey {
        case id
        case categoryId = "category_id"
        case subCatName = "sub_cat_name"
        case status
        case created
        case name
        case subCatStatus = "sub_cat_status"
        case selected
        case scalar
    }
}
