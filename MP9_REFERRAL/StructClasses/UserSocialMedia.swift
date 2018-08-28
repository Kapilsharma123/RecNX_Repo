//
//  UserSocialMedia.swift
//  MP9_REFERRAL
//
//  Created by macrew on 20/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
import UIKit
struct UserSocialMedia : Codable
{
    var firstName : String?
    var lastName : String?
    var email : String?
    var phoneNo : String?
    var password : String?
    var countryCode : String?
    var countryId : String?
    var stateId : String?
    var cityId : String?
   
     var socialId : String?
     var smPlatform : String?
    var deviceId : String?
    var deviceType : String?
    
    enum CodingKeys: String,CodingKey
    {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNo = "phone_no"
        case password
        case countryCode = "country_code"
        case countryId = "country_id"
        case stateId = "state_id"
        case cityId = "city_id"
       
         case socialId = "social_id"
         case smPlatform = "sm_platform"
        case deviceId = "device_id"
        case deviceType = "device_type"
    }
    init(firstName:String? = nil,
         lastName : String? = nil,
         email : String? = nil,
         phoneNo : String? = nil,
         password:String? = nil,
         countryCode : String? = nil,
         countryId : String? = nil,
         stateId : String? = nil,
         cityId : String? = nil,
         
         socialId :String? = nil,
          smPlatform : String? = nil,
          deviceId :String? = nil,
          deviceType : String? = nil
        )
    {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNo = phoneNo
        self.password = password
        self.countryCode = countryCode
        self.countryId = countryId
        self.stateId = stateId
        self.cityId = cityId
       
         self.socialId = socialId
         self.smPlatform = smPlatform
        self.deviceId = deviceId
        self.deviceType = deviceType
        
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


