//
//  ApiProvider.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
import Moya

enum APIProvider {
    case login(countryCode: String, phoneNo: String,password: String, deviceType: String,deviceId: String)
    case getCountryListing()
    case GetAllStatesByCountryId(id: String)
    case GetAllCitiesByStateId(id: String)
    case SignUp(withUser: User)
    case SignUpSM(withUser: UserSocialMedia)
    
     case UpdateDeviceId(userId: String, savedDeviceID: String, deviceId: String)
    
    case verifyOTP(countryCode: String, phoneNo: String,otp: String, deviceType: String,deviceId: String)
    case resendOTP(countryCode: String, phoneNo: String)
    case forgotPassword(countryCode: String, phoneNo: String)
    case verifyPasswordOTP(countryCode: String, phoneNo: String,otp: String)
    case createPassword(countryCode: String, phoneNo: String,newPassword: String, confirmPassword: String)
    case changePassword(userId: String, oldPassword: String,newPassword: String, confirmPassword: String)
    case logOut(userId: String, savedDeviceID: String)
    case editProfile(userId: String, firstName: String,lastName: String, email: String, phoneNo: String, countryCode: String, countryId: String, stateId: String, cityId: String,savedDeviceId : String)
    case getAllCategories()
    case getSubCategories(categoryId: String)
    case getSurveyByCategory(categoryId: String, subCategoryId: String)
    case PostSurvey(withSurvey: SurveyParams)
    case UpdatePostSharedStatus(userID: String, postID: String,facebook: String, twitter: String,RECNXCommunity: String, postDate: String,socialMessage: String)
    case CommunityRecommendation(AppUserID: String, postID: String,SurveyID: String, CategoryID: String,SubCatID: String,FirstName: String, LastName: String,Comment: String, QuestionRating: String ,plaeFullInfo : placeFullInfo)
    
    case getQuestions(postID: String, userID: String)
    case GetUsersSurvey(userId: String)
     case GetUsersClosedSurvey(userId: String)
    case GetSurveyRecommendations(userId: String, postId: String, surveyId: String)
    case GetBusinessOffers(businessID: String)
    case AcceptOffer(userId: String, businessId: String,offerId: String, categoryId: String)
    case AcceptRecommendation(userId: String, businessId: String,recommendID: String)
   // case registerNewCertifierUser(withUser: User)
    
}

extension APIProvider: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://app.recnx.com/api/"/*"https://macrew.info/my_referal9/dev/api/"*/)!
    }
    
    var path: String {
        switch self {
        case .login  : return "login"
      //  case .registerNewCertifierUser  : return "/guestRegister"
        case .getCountryListing  : return "GetAllCountriesCodes"
        case .GetAllStatesByCountryId  : return "GetAllStatesByCountryId"
        case .GetAllCitiesByStateId  : return "GetAllCitiesByStateId"
        case .SignUp  : return "SignUp"
        case .SignUpSM  : return "SignUpWithSM"
        case .verifyOTP  : return "VerifyOTP"
        case .resendOTP  : return "ResendOTP"
        case .forgotPassword  : return "ResendOTP"
        case .verifyPasswordOTP  : return "VerifyPasswordOTP"
        case .createPassword  : return "CreatePassword"
        case .changePassword  : return "ChangePassword"
        case .logOut  : return "logout"
        case .editProfile  : return "EditProfile"
        case .getAllCategories  : return "GetAllCategories"
        case .getSubCategories  : return "GetAllSubCategories"
        case .getSurveyByCategory  : return "GetSurveyByCategory"
        case .PostSurvey : return "PostSurvey"
        case .UpdatePostSharedStatus : return "UpdatePostSharedStatus"
        case .CommunityRecommendation : return "CommunityRecommendation"
            
        case .UpdateDeviceId : return "UpdateDeviceId"
            
        case .getQuestions : return "GetQuestions"
        case .GetUsersSurvey : return "GetUsersSurvey"
        case .GetUsersClosedSurvey : return "GetUsersClosedSurvey"
        case .GetSurveyRecommendations : return "GetSurveyRecommendations"
        case .GetBusinessOffers : return "GetBusinessOffers"
        case .AcceptOffer : return "AcceptOffer"
        case .AcceptRecommendation : return "AcceptRecommendation"
       
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .login(countryCode , phoneNo, password, deviceType,deviceId ):
            var parameters = [String: Any]()
            parameters["country_code"] = countryCode
            parameters["phone_no"] = phoneNo
            parameters["password"] = password
            parameters["device_type"] = deviceType
            parameters["device_id"] = deviceId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .getCountryListing():
            return .requestPlain
        case let .GetAllStatesByCountryId(id):
            var parameters = [String: Any]()
            parameters["country_id"] = id
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .GetAllCitiesByStateId(id):
            var parameters = [String: Any]()
            parameters["state_id"] = id
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .SignUp(let user):
              return .requestParameters(parameters: user.encodeToDict(), encoding: URLEncoding.default)
        case .SignUpSM(let user):
            return .requestParameters(parameters: user.encodeToDict(), encoding: URLEncoding.default)
            
        case let .verifyOTP(countryCode , phoneNo, otp, deviceType,deviceId ):
            var parameters = [String: Any]()
            parameters["country_code"] = countryCode
            parameters["phone_no"] = phoneNo
            parameters["otp"] = otp
            parameters["device_type"] = deviceType
            parameters["device_id"] = deviceId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .resendOTP(countryCode , phoneNo ):
            var parameters = [String: Any]()
            parameters["country_code"] = countryCode
            parameters["phone_no"] = phoneNo
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .forgotPassword(countryCode , phoneNo ):
            var parameters = [String: Any]()
            parameters["country_code"] = countryCode
            parameters["phone_no"] = phoneNo
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .verifyPasswordOTP(countryCode , phoneNo, otp):
            var parameters = [String: Any]()
            parameters["country_code"] = countryCode
            parameters["phone_no"] = phoneNo
            parameters["otp"] = otp
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .UpdateDeviceId(userId, savedDeviceID, deviceId):
            var parameters = [String: Any]()
            parameters["user_id"] = userId
            parameters["saved_device_id"] = savedDeviceID
            parameters["device_id"] = deviceId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
            
            
            
        case let .createPassword(countryCode , phoneNo, newPassword, confirmPassword):
            var parameters = [String: Any]()
            parameters["country_code"] = countryCode
            parameters["phone_no"] = phoneNo
            parameters["new_password"] = newPassword
            parameters["confirm_password"] = confirmPassword
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .changePassword(userId, oldPassword,newPassword, confirmPassword):
            var parameters = [String: Any]()
            parameters["user_id"] = userId
            parameters["old_password"] = oldPassword
            parameters["new_password"] = newPassword
            parameters["confirm_password"] = confirmPassword
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .logOut(userId , savedDeviceID):
            var parameters = [String: Any]()
            parameters["user_id"] = userId
            parameters["saved_device_id"] = savedDeviceID
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .editProfile(userId, firstName, lastName, email, phoneNo, countryCode, countryId, stateId, cityId, savedDeviceId):
            var parameters = [String: Any]()
            parameters["user_id"] = userId
            parameters["first_name"] = firstName
            parameters["last_name"] = lastName
            parameters["email"] = email
            parameters["phone_no"] = phoneNo
            parameters["country_code"] = countryCode
            parameters["country_id"] = countryId
            parameters["state_id"] = stateId
            parameters["city_id"] = cityId
            parameters["saved_device_id"] = savedDeviceId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getAllCategories():
            return .requestPlain
        case let .getSubCategories(categoryId ):
            var parameters = [String: Any]()
            parameters["category_id"] = categoryId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .getSurveyByCategory(categoryId, subCategoryId):
            var parameters = [String: Any]()
            parameters["category_id"] = categoryId
            parameters["sub_cat_id"] = subCategoryId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .PostSurvey(let survey):
            return .requestParameters(parameters: survey.encodeToDict(), encoding: URLEncoding.default)
        case let .UpdatePostSharedStatus(userID, postID, facebook, twitter, RECNXCommunity, postDate,socialMessage):
            var parameters = [String: Any]()
            parameters["user_id"] = userID
            parameters["post_id"] = postID
            parameters["facebook"] = facebook
            parameters["twitter"] = twitter
            parameters["RECNX_community"] = RECNXCommunity
            parameters["post_date"] = postDate
            parameters["social_message"] = socialMessage
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
            
        case let .CommunityRecommendation(AppUserID, postID, SurveyID, CategoryID, SubCatID, FirstName, LastName, Comment, QuestionRating, plaeFullInfo):
            var parameters = [String: Any]()
            parameters = plaeFullInfo.encodeToDict()
            parameters["app_user_id"] = AppUserID
            parameters["post_id"] = postID
            parameters["survey_id"] = SurveyID
            parameters["category_id"] = CategoryID
            parameters["sub_category_id"] = SubCatID
            parameters["first_name"] = FirstName
            parameters["last_name"] = LastName
            parameters["comment"] = Comment
            parameters["question_rating"] = QuestionRating
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
            
        case let .getQuestions(postID, userID):
            var parameters = [String: Any]()
            parameters["post_id"] = postID
            parameters["user_id"] = userID
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .GetUsersSurvey(userId):
            var parameters = [String: Any]()
            parameters["user_id"] = userId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .GetUsersClosedSurvey(userId):
            var parameters = [String: Any]()
            parameters["user_id"] = userId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
            
        case let .GetSurveyRecommendations(userId, postId, surveyId):
            var parameters = [String: Any]()
            parameters["user_id"] = userId
            parameters["post_id"] = postId
            parameters["survey_id"] = surveyId
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .GetBusinessOffers(businessID):
            var parameters = [String: Any]()
            parameters["business_id"] = businessID
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .AcceptOffer(userId, businessId,offerId, categoryId):
            var parameters = [String: Any]()
            
            parameters["user_id"] = userId
            parameters["business_id"] = businessId
            parameters["offer_id"] = offerId
            parameters["category_id"] = categoryId
           
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .AcceptRecommendation(userId, businessId,recommendID):
            var parameters = [String: Any]()
            
            parameters["user_id"] = userId
            parameters["business_id"] = businessId
            parameters["recommendation_id"] = recommendID
           
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
      //  case .registerNewCertifierUser(let user):
          //  return .requestParameters(parameters: user.encodeToDict(), encoding: URLEncoding.default)
            
       
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
