//
//  GlobalConstants.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
struct GlobalConstants
{
    struct ApiErrorMessage {
        static let unableToDecode = "Unable to decode data !"
        static let noData = "No Data Found !"
        static let noNetwork = "No Network connection available!"
        static let timeOut = "Timeout!\nPlease check your internet connection and try again."
        static let serverError = "Somthing went wrong, please try again!"
        static let unknown = "Unknown error occurred!"
        static let unauthorised = "you are not authorised, please login again."
        static let internalError = "Sorry, internal error occurred!"
        static let resedOTPAlert = "You are not verified with the app.\nDo you want to verfy your mobile number with OTP verification?"
        static let feildReqired = "All Fields Are Reqiured."
    }
    struct FillAllDetails {
        static let pleaseEnterFirstName = "Please Enter First Name !"
         static let pleaseEnterLastName = "Please Enter Last Name !"
        static let newPasswordAndConfirmPasswordShouldBeSame = "New Password and Confirm Passwords should be Same !"
        static let pleaseEnterEmail = "Please Enter Email !"
        static let invalidEmail = "Invalid Email !"
        static let pleaseSelectCountryCode = "Please Select Country Code!"
        static let pleaseSelectPhoneNumber = "Please Select Phone Number."
        static let pleaseSelectPassword = "Please Select Password!"
        static let passwordMustBeAtleast6Characters = "Password must be atleast 6 Characters!"
        static let pleaseSelectState = "Please Select State."
        static let pleaseSelectCity = "Please  Select City!"
        static let pleaseEnterFourdigitcode = "Please Enter 4 digit code !"
        
        static let pleaseSelectAge = "Please Select Age !"
        static let pleaseSelectSex = "Please Select Sex !"
        static let pleaseEnterTitle = "Please Enter Title !"
        static let pleaseSelectEndDate = "Please Select End Date !"
        static let pleaseAddCity = "Please select a city."
        static let pleaseEnterBusiness = "Please Enter Business !"
        
    }
    struct GooglePLACEAPi {
        static let googlePlaceAPIKey = "AIzaSyAR7uGSk3bqiq6OIiiV2e1qKF1AwoWouk8"//"AIzaSyCXPlPjzjiiCnRXLogzyEk0H2-e5Mg2JwQ"
        static var placeFullInfo :placeFullInfo?
        
    }
}
