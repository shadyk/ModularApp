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

public typealias LoginCompletion = (Bool,User) -> Void
public typealias LoginClosure = (String, LoginCompletion) -> Void

public protocol LoginProtocol {
    func success()
    func failed()
}


public struct LoginParams {
    public var username : String?
    public var pass : String?

    public init(username: String, pass:String){
        
    }
}

public class LoginService {
    let params : LoginParams
    let delegate : LoginProtocol?

    public init(params : LoginParams, delegate:LoginProtocol){
        self.params = params
        self.delegate = delegate
    }
}

extension ApiClient {
    public func login(username : String, completion:(Bool,User)->Void){

        completion(true,User())
    }
}

public protocol LoginAction{
    func login(username:String, pass:String)
}
