//
//  SurveyParams.swift
//  MP9_REFERRAL
//
//  Created by macrew on 30/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct SurveyParams : Codable
{
    var postId : String?
    var userId : String?
    var categoryId : String?
    var subCategoryId : String?
    var surveyId : String?
  
    var questionsId : String?
    
    var postCity : String?
    
    var facebook : String?
    var twitter : String?
    var RECNXCommunity : String?
    
    
    enum CodingKeys: String,CodingKey
    {
        case postId = "post_id"
        case userId = "user_id"
        case categoryId = "category_id"
        case subCategoryId = "sub_category_id"
        case surveyId = "survey_id"
        case questionsId = "questions_id"
        case postCity = "post_city"
        case facebook
        case twitter
        case RECNXCommunity = "RECNX_community"
    }
    init(postId:String? = nil,
         userId:String? = nil,
         categoryId : String? = nil,
         subCategoryId : String? = nil,
         surveyId:String? = nil,
         //title : String? = nil,
         questionsId : String? = nil,
        
         postCity : String? = nil,
         
         facebook : String? = nil,
         twitter : String? = nil,
         RECNXCommunity : String? = nil
         
        )
    {
        self.postId = postId
        self.userId = userId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.surveyId = surveyId
      //  self.title = title
        self.questionsId = questionsId
       
        self.postCity = postCity
        self.facebook = facebook
        self.twitter = twitter
        self.RECNXCommunity = RECNXCommunity
        
    }
    
    init?(data: Data?) {
        guard let _ = data else {return nil}
        do {
            self = try JSONDecoder().decode(type(of: self), from: data!)
        } catch let error {
            print("Parsing response body error:", error.localizedDescription)
            return nil
        }
    }
    
    func encodeToDict()-> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] ?? [:]
        } catch let error {
            print(error)
            return [:]
        }
    }
    

}


