//
//  NetworkHelper.swift
//  MP9_REFERRAL
//
//  Created by macrew on 16/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
import Moya
import Alamofire

public class NetworkHelper {
    
    fileprivate let provider = MoyaProvider<APIProvider>()
    
    func makeRequest(withAPIProvider apiProvider: APIProvider, completion cb: @escaping (_ error: ErrorType?,_ responseBody: ResponseBody?)->(), progressValue:  ((Double)-> ())? = nil )-> Cancellable {//7MAY
        let request = provider.requestNormal(apiProvider, callbackQueue: nil, progress: { (progressResponse) in
            progressValue?(progressResponse.progress)
        }) { (result) in
            print("Result==\(result)")
            switch result {
            case .success(let response):
                print("result===\(result)")
                if let responseBody =  ResponseBody(data: response.data) {
                    print("ApiResponseModel statusCode: ", responseBody.statusCode)
                    print("ApiResponseModel responseMessage: ", responseBody.responseMessage ?? "np api message")
                    cb(nil, responseBody)
                } else {
                    cb(ErrorType.serverError, nil)
                }
            case .failure(let error):
                cb(self._getErrorType(withError: error), nil)
            }
        }
        return request
    }
    
    private func _getErrorType(withError error: Error?) -> ErrorType? {
        guard error != nil else {return nil}
        switch error!._code {
        case NSURLErrorTimedOut:
            return ErrorType.tiomeout
        case NSURLErrorNetworkConnectionLost, -1009:
            return ErrorType.noNetwork
        default:
            return ErrorType.serverError
        }
    }
    
}
