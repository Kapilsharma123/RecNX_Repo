//
//  User.swift
//  MP9_REFERRAL
//
//  Created by macrew on 20/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
import UIKit
struct User : Codable
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
    var referralCode : String?
   // var socialId : String?
   // var smPlatform : String?
    
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
        case referralCode = "referral_code"
       // case socialId = "social_id"
       // case smPlatform = "sm_platform"
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
         referralCode :String? = nil
        // socialId :String? = nil,
       //  smPlatform : String? = nil
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
        self.referralCode = referralCode
       // self.socialId = socialId
       // self.smPlatform = smPlatform
        
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

extension UIScreen {
    
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}
