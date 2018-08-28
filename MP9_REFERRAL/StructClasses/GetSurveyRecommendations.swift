//
//  GetSurveyRecommendations.swift
//  MP9_REFERRAL
//
//  Created by macrew on 09/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct GetSurveyRecommendations: Decodable {
    let data : [GetSurveyRecommendationsAray]?
    
    enum CodingKeys : String, CodingKey {
        case data
        
    }
}


struct GetSurveyRecommendationsAray: Decodable {
    let recommendId: Int?
    let recommendBy: String?
    let businessId: Int?
    let businessName: String?
    let categoryId: Int?
    let categoryName: String?
    let totalRating: String?
    let comment: String?
    let questions: [RecmQuestions]?
    let offer: BusinessOffer?
    enum CodingKeys : String, CodingKey {
        case recommendId = "recommendation_id"
        case recommendBy = "recommended_by"
        case businessId = "business_id"
        case businessName = "business_name"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case totalRating = "total_rating"
        case questions
        case offer
        case comment
       
    }
}

struct RecmQuestions: Decodable {
    let questionId: Int?
    let question: String?
    let rating: String?
    
    enum CodingKeys : String, CodingKey {
        case questionId = "question_id"
        case question = "question"
        case rating = "ratings"
       
        
    }
}
/////////////////////


