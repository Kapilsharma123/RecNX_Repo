//
//  QuestionsInfo.swift
//  MP9_REFERRAL
//
//  Created by macrew on 06/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct QuestionsInfo
{
    
    struct SelectedQuestionsInfo {
    static var questionDetail :[Questions]?
        
    }
}
struct QuestionDetail: Codable {
    let id: String?
    let rating: String?
    
    enum CodingKeys : String, CodingKey {
        case id
        case rating
    }
}

struct QuestionsForRecommendation: Decodable {
    
    var questions: [QuesForRecommendation]?
   
    enum CodingKeys : String, CodingKey {
        case questions
    }
    
}

struct QuesForRecommendation: Decodable {
    
    var id: Int?
    var surveyId: Int?
    var question: String?
    var checked: Int?
    var isDeleted: Int?
    var ratings: Int?
    
    
    enum CodingKeys : String, CodingKey {
        case id
        case surveyId = "survey_id"
        case question
        case checked
        case isDeleted = "is_deleted"
        case ratings
        
    }
    
}
//////////////////
struct SubmitQuesForRecommendation: Decodable {
    
    var id: String?
    var ratings: String?
    
    
    enum CodingKeys : String, CodingKey {
        case id
        case ratings
    }
        



}
