//
//  PostSurveyResponse.swift
//  MP9_REFERRAL
//
//  Created by macrew on 01/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation




struct PostSurveyResponse: Decodable {
    
    var postURL: String?
    var postID: Int?
   
    enum CodingKeys : String, CodingKey {
        
        case postURL = "post_url"
        case postID = "post_id"
        
    }
}

