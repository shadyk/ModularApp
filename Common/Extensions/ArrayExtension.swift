//
//  ArrayExtension.swift
//  banking
//
//  Created by Shady Kahaleh on 11/3/17.
//  Copyright © 2017 Shady Kahaleh. All rights reserved.
//

import UIKit

extension Array where Element : NSObject {
    func toStringArray() -> [String]{
        return self.map{
            return $0.description
        }
    }
}
