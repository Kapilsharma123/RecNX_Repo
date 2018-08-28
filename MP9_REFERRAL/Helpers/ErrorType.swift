//
//  ErrorType.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
public enum ErrorType: String, Error {
    case noNetwork      = "0"
    case duplicate      = "409"
    case tiomeout       = "503"
    case serverError    = "500"
    case unauthorized   = "401"
    case invalidData    = "400"
    case unknown        = "420"
    case internalError  = "203"
    var localizedDescription: String? {
        switch self {
        case .noNetwork:
            return GlobalConstants.ApiErrorMessage.noNetwork
        case .serverError:
            return GlobalConstants.ApiErrorMessage.serverError
        case .invalidData,.unknown :
            return GlobalConstants.ApiErrorMessage.unknown
        case .tiomeout:
            return GlobalConstants.ApiErrorMessage.timeOut
        case .unauthorized:
            return GlobalConstants.ApiErrorMessage.unauthorised
        case .internalError:
            return GlobalConstants.ApiErrorMessage.internalError
        default:
            return nil
        }
    }
}
