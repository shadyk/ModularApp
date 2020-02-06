//
//  ViewController.swift
//  App
//
//  Created by Shady Kahaleh on 1/19/20.
//  Copyright © 2020 Shady Kahaleh. All rights reserved.
//

import UIKit
import SKAuth
import SKAPI

class LoginViewController: UIViewController{

    var loginAction : LoginAction!

    convenience init(loader: LoginAction){
        self.init()
        self.loginAction = loader
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.login(username: "", password: "")

        // Do any additional setup after loading the view.
    }

    func login(username: String, password: String) {
        self.loginAction.login(username: username, pass: password)
    }

}

