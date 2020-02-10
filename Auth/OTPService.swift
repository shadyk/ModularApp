//
//  OTPService.swift
//  ModularApp
//
//  Created by Shady Kahaleh on 2/9/20.
//  Copyright © 2020 Shady Kahaleh. All rights reserved.
//

import Foundation
import SKAPI

extension ApiClient {
    public func otpAction(otp : String, completion:(String)->Void){

        completion("")
    }
}

public protocol LoginAction{
    func login(username:String, pass:String)
}
