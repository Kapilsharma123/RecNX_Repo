//
//  StateCity.swift
//  MP9_REFERRAL
//
//  Created by macrew on 19/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct StateCity : Decodable
{
    struct CountryListing : Decodable
    {
        var countries : [Countries]
        enum CodingKeys : String, CodingKey {
            case countries
        }
    }
   
    struct Countries: Decodable {
        let id: Int
        let name: String
        let phonecode: String
        enum CodingKeys : String, CodingKey {
            case id
            case name
            case phonecode
        }
    }
    /////////////////////////////////////////////////
    struct StatesListing : Decodable
    {
        var states : [States]
        enum CodingKeys : String, CodingKey {
            case states
        }
    }
    
    struct States: Decodable {
        let id: Int
        let name: String
       
        enum CodingKeys : String, CodingKey {
            case id
            case name
           
        }
    }
    /////////////////////////////////////////////////
    struct CitiesListing : Decodable
    {
        var cities : [Cities]
        enum CodingKeys : String, CodingKey {
            case cities
        }
    }
    
    struct Cities: Decodable {
        let id: Int
        let name: String
        
        enum CodingKeys : String, CodingKey {
            case id
            case name
            
        }
    }
    
    
    
}
