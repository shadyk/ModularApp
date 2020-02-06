//
//  StringExtensions.swift
//  RiyadhBankWallet
//
//  Created by Shady Kahaleh on 8/6/18.
//  Copyright © 2018 Shady Kahaleh. All rights reserved.
//

import UIKit
public extension String {

    func lastFourChars() -> String {
        return String(self.suffix(4))
    }
    func decodeHTML() -> String? {

        guard let data = self.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        return attributedString.string
    }

    func hexToDecimal() -> Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }

    func stripHTML() -> String{

        let str = self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return str
    }


    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else
        {
            return nil
        }
        return String(data: data, encoding: .ascii)
    }



    func charAt(at: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: at)
        return self[charIndex]
    }

    func replaceHindiDigits() -> String {
        var temp = self
        let format =  NumberFormatter()
        format.locale = NSLocale(localeIdentifier: "ar") as Locale
        for i in 0..<10 {
            let num : NSNumber = NSNumber.init(value: i)
            temp = temp.replacingOccurrences(of: format.string(from: num) ?? "", with: "\(num)")
        }
        format.locale = NSLocale(localeIdentifier: "en") as Locale
        return temp
    }

    func base64URLToBase64() -> String {

        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return base64
    }

    func base64ToBase64url() -> String {
        let base64url = self
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }

    func hexStringToData() -> Data? {
         var hex = self
         var data = Data()
         while(hex.count > 0) {
             let subIndex = hex.index(hex.startIndex, offsetBy: 2)
             let c = String(hex[..<subIndex])
             hex = String(hex[subIndex...])
             var ch: UInt32 = 0
             Scanner(string: c).scanHexInt32(&ch)
             var char = UInt8(ch)
             data.append(&char, count: 1)
         }
         return data
     }
}
