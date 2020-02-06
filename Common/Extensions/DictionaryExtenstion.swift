//
//  DictionaryExtenstion.swift
//  banking
//
//  Created by Shady Kahaleh on 11/2/17.
//  Copyright © 2017 Shady Kahaleh. All rights reserved.
//

import UIKit

public extension Dictionary {    
    func prettyPrint(){
        self.forEach { print("\($0): \($1)") }
    }
}
