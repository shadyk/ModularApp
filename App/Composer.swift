//
//  Composer.swift
//  App
//
//  Created by Shady Kahaleh on 2/2/20.
//  Copyright © 2020 Shady Kahaleh. All rights reserved.
//

import Foundation

import SKAuth

class RemoteLoginAction : LoginAction {
    func login(username: String, pass: String) {
        //call api
        print("remote login")
    }
}

class LocalLoginAction : LoginAction {
    func login(username: String, pass: String) {
        //call
        print("local login")
    }
}

class Composer {
    static func initLogin() -> LoginViewController{
        let vc =  LoginViewController(loader: RemoteLoginAction())
//        vc.loginAction = RemoteLoginAction()
//        vc.loginAction = LocalLoginAction()
        return vc

    }

}

