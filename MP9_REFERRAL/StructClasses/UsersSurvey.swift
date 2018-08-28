//
//  UsersSurvey.swift
//  MP9_REFERRAL
//
//  Created by macrew on 09/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct UsersSurvey: Decodable {
    let data : [UsersSurveyArray]?
    
    enum CodingKeys : String, CodingKey {
        case data
        
    }
}


struct UsersSurveyArray: Decodable {
    let postId: Int?
    let userID: Int?
    let surveyId: Int?
    let categoryId: Int?
    let categoryName: String?
    let postDate: String?
    
    let SubCategoriesNames: String?
    let city: String?
    let endDate: String?
    let noOfRecomm: Int?
    
    
    enum CodingKeys : String, CodingKey {
        case postId = "post_id"
        case userID = "user_id"
        case surveyId = "survey_id"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case postDate = "post_date"
        
        case SubCategoriesNames
        case city
        case endDate = "end_date"
        case noOfRecomm = "no_of_recommendations"
    }
}




