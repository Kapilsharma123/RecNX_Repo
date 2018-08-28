//
//  GooglePlaceInfo.swift
//  MP9_REFERRAL
//
//  Created by macrew on 03/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct GooglePlaceInfo : Codable
{
    var placeName : String?
    var placeId : String?
    var placeFullInfo : placeFullInfo?
   
    
    enum CodingKeys: String,CodingKey
    {
        case placeName
        case placeId
        case placeFullInfo
        
    }
   /* init(placeName:String? = nil,
         placeId : String? = nil
        
        )
    {
        self.placeName = placeName
        self.placeId = placeId
        
        
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
    }*/
    
    
}

struct placeFullInfo: Codable {
    let name: String?
    let email: String?
    let address: String?
    let countryID: String?
    let cityID: String?
    let stateID: String?
    let phoneNo: String?
    let postalCode: String?
    let placeId: String?
    let lat: String?
    let lng: String?
    enum CodingKeys : String, CodingKey {
        case name
        case email
        case address
        case countryID = "country_id"
        case cityID = "city_id"
        case stateID = "state_id"
        case phoneNo = "phone_no"
        case postalCode = "postal_code"
        case placeId = "place_id"
        case lat
        case lng
        
    }
    init(name:String? = nil,
         email : String? = nil,
         address:String? = nil,
         countryID : String? = nil,
         cityID:String? = nil,
         stateID : String? = nil,
         phoneNo:String? = nil,
         postalCode : String? = nil,
         placeId:String? = nil,
         lat : String? = nil,
         lng:String? = nil
        
        )
    {
        self.name = name
        self.email = email
        self.address = address
        self.countryID = countryID
        self.cityID = cityID
        self.stateID = stateID
        self.phoneNo = phoneNo
        self.postalCode = postalCode
        self.placeId = placeId
        self.lat = lat
        self.lng = lng
        
        
        
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
