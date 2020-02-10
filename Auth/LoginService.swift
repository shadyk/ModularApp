//
//  LoginService.swift
//  Auth
//
//  Created by Shady Kahaleh on 1/19/20.
//  Copyright © 2020 Shady Kahaleh. All rights reserved.
//

import Foundation
import Alamofire
import SKAPI

enum MainResult {
    case success
    case Failure(Error)
}

enum LoginResult{
    case success(User)
}

extension ApiClient {
    public func login(username : String, completion:(Bool,User)->Void){

        completion(true,User())
    }
}

public protocol LoginAction{
    func login(username:String, pass:String)
}
