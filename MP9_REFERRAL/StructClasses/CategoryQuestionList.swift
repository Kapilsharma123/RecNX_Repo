//
//  CategoryQuestionList.swift
//  MP9_REFERRAL
//
//  Created by macrew on 27/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct CategoryQuestionList: Codable {
    
    var survey: [Survey]
    enum CodingKeys : String, CodingKey {
        
        case survey
    }
    
}


struct Survey: Codable {
    let id: Int?
    let categoryId: Int?
    let isLimited: String?
    let maximum: String?
    let status: Int?
    let created: String?
    var questions: [Questions]
    
    enum CodingKeys : String, CodingKey {
        case id
        case categoryId = "category_id"
        case isLimited = "is_limited"
        case maximum
        case status
        case created
        case questions
        
    }
}

struct Questions: Codable {
    let id: Int?
    let surveyId: Int?
    let question: String?
    var checked: Int?
    
    enum CodingKeys : String, CodingKey {
        case id
        case surveyId = "survey_id"
        case question
        case checked
       
    }
}
