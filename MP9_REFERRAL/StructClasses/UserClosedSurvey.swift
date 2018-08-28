//
//  UserClosedSurvey.swift
//  MP9_REFERRAL
//
//  Created by macrew on 15/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct UserClosedSurvey: Decodable {
    let data : [UserClosedSurveyArray]?
    
    enum CodingKeys : String, CodingKey {
        case data
        
    }
}


struct UserClosedSurveyArray: Decodable {
    let postId: Int?
    let userID: Int?
    let surveyId: Int?
    let categoryId: Int?
    let categoryName: String?
    let postDate: String?
    let recommendBy: String?
    
    let SubCategoriesNames: String?
    let city: String?
    let endDate: String?
    let noOfRecomm: Int?
    let businessName: String?
    let comment : String?
    let questions: [RecmQuestions]?
    let offer: BusinessOffer?
    
    
    enum CodingKeys : String, CodingKey {
        case postId = "post_id"
        case userID = "user_id"
        case surveyId = "survey_id"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case postDate = "post_date"
        case recommendBy = "recommended_by"
        
        case SubCategoriesNames
        case city
        case endDate = "end_date"
        case noOfRecomm = "no_of_recommendations"
        case offer
        case questions
        case businessName = "business_name"
        case comment
    }
}
