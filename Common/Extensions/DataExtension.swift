//
//  DataExtension.swift
//  RiyadhBankWallet
//
//  Created by Shady Kahaleh on 9/18/18.
//  Copyright © 2018 Shady Kahaleh. All rights reserved.
//

import UIKit

extension Data {
    var hex: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
