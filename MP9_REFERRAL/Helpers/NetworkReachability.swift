//
//  NetworkReachability.swift
//  MP9_REFERRAL
//
//  Created by macrew on 23/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity
{
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
