//
//  File.swift
//  banking
//
//  Created by Shady Kahaleh on 9/18/17.
//  Copyright © 2017 Kassem Itani. All rights reserved.
//
// herllo world 123

import Foundation
import Alamofire
import SKCommon
import SKCrypto

class MainResponse{

}

protocol ResponseProtocol {
    func response(dict:Dictionary<String, Any>)
}

let CONTENT_TYPE = "application/json"
let ACCEPT = "application/json"
var Authorization = "application/x-www-form-urlencoded"
var X_PATH = "h"

public enum AccecssTokenStatuses {
    case usingAccessToken
    case usingRefreshToken
}

public enum HttpStatusCode : Int {
    case OK = 200                       // /GET, /DELETE result is successful
    case CREATED = 201                  // /POST or /PUT is successful
    case NOT_MODIFIED = 304             //If caching is enabled & etag matches w/ the server
    case BAD_REQUEST = 400              // Possibly the parameters are invalid
    case INVALID_CREDENTIAL = 403       // INVALID CREDENTIAL, possible invalid token --- Access token expired
    case NOT_FOUND = 404                // The item you looked for is not found
    case CONFLICT = 409                 // Conflict - means already exist
    case ACCESS_TOKEN_EXPIRED = 401    // Expired
    case SERVER_ERROR = 500   // System error
}

enum CustomNotification:String {
    case SERVER_ERROR = "SERVER_ERROR"
    case NOT_FOUND = "NOT_FOUND"
    case TIME_OUT = "TIME_OUT"
    case AccessTokenExpired = "accessTokenExpired"
}

public enum CallbackResultType {
    case Success(Any?)
    case Failure(ErrorType) // todo: add string for error msg
}

public enum ErrorType {
    case UnknownError
    case AlreadyExist // Resource does already exist
    case NotExist // Resource does NOT exist
    case InvalidParameters // The parameter(s) is/are invalid
    case InvalidCredentials // Credentials are invalid
    case InternalError // There's a server-side problem
    case AccessTokenTimeout // Access Token for the user is timed out
    case APIEndpointNotAvailable // The API endpoint is not available
    case InvalidCsrfToken // Invalid Csrf Token (possibly not exist, or expired)
}

public class RequestHelper {

    static var reseponseDelegate : ResponseProtocol?
    //wihtout pinning
//    var sessionManager = SessionManager()

    //with pinning
    static let customSessionDelegate = CustomSessionDelegate()
    static var sessionManager =  SessionManager(
        delegate: RequestHelper.customSessionDelegate, // Feeding our own session delegate
        serverTrustPolicyManager: CustomServerTrustPolicyManager(
            policies: [:]
        )
    )

    class func sendSecuredPostRequest<T: MainResponse>(type : T.Type, url: String, headers: [String : Any]?, params: [String : Any]?,encrypted:Bool, completion: @escaping (_ response:T) -> Void) {
        RequestHelper.sendSecuredRequest(type : type, url: url, method:.post, headers:headers, params: params,encrypted:encrypted, completion : completion);
    }
    
    class func sendSecuredGETRequest<T: MainResponse>(type : T.Type, url: String, headers: [String : Any]?, params: [String : Any]?,encrypted:Bool, completion: @escaping (_ response:T) -> Void) {
        RequestHelper.sendSecuredRequest(type : type, url: url, method:.get, headers:headers, params: params,encrypted:encrypted, completion : completion);
    }
    
    class func sendSecuredRequest<T: MainResponse>(type : T.Type, url: String, method : HTTPMethod, headers: [String : Any]?, params: [String : Any]?, encrypted:Bool, completion: @escaping (_ response : T) -> Void) {
        
        let requestTuple = self.securedURLRequest(url: url, parameters: params)
        sessionManager.request(requestTuple.request).response { response in

            if(response.response?.statusCode == nil){ //no internet (timeout)
                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.TIME_OUT.rawValue), object: self)
                return
            } else if(response.response?.statusCode == HttpStatusCode.ACCESS_TOKEN_EXPIRED.rawValue){ //access token

                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.AccessTokenExpired.rawValue), object: self)
                return;

////                if API.AccessTokenStatus == .usingAccessToken  {
////                    API.AccessTokenStatus = .usingRefreshToken
////                    API().refreshAccessToken(onSuccess:
////                        {_ in
////                            self.sendSecuredRequest(type: type, url: url, method: method, headers: headers, params: params, completion: completion)
////                        }, onError:
////                            {_ in
////                                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.AccessTokenExpired.rawValue), object: self)
////
////                        })
////                    return
//                }else {
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.AccessTokenExpired.rawValue), object: self)
//                    return
//                }
            } else if(response.response?.statusCode == HttpStatusCode.SERVER_ERROR.rawValue){
//                debugprint("Response  \(String(describing: response.response))")
                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.SERVER_ERROR.rawValue), object: self)

//                let responseObject = T(responseDict: ["":""])
//                completion(responseObject as T)
                //FIXME : shady new
                self.reseponseDelegate?.response(dict: ["":""])
                return
            }
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                var decryptedResult : String
                if encrypted{
                    decryptedResult = CryptoFunctions.decrypt(encryptedJSON: utf8Text, AESkey: requestTuple.randomKey)
                }
                else{
                    decryptedResult = utf8Text
                }
                let dict = self.convertToDictionary(text: decryptedResult) ?? ["":""]
//                let responseObject = T(responseDict: dict)
//                completion(responseObject as T)
                //FIXME : shady new
                self.reseponseDelegate?.response(dict: ["":""])

            }
        }
    }
    
    class func sendAnonPostRequest<T: MainResponse>(type : T.Type, url: String, headers: [String : Any]?, params: [String : Any]?, completion: @escaping (_ response:T) -> Void) {
        RequestHelper.sendAnonRequest(type : type, url: url, method:.post, headers:headers, params: params, completion : completion);
    }
    
    class func sendAnonGETRequest<T: MainResponse>(type : T.Type, url: String, headers: [String : Any]?, params: [String : Any]?, completion: @escaping (_ response:T) -> Void) {
        RequestHelper.sendAnonRequest(type : type, url: url, method:.get, headers:headers, params: params, completion : completion);
    }
    
    class func sendAnonRequest<T: MainResponse>(type : T.Type, url: String, method : HTTPMethod, headers: [String : Any]?, params: [String : Any]?, completion: @escaping (_ response : T) -> Void) {
        
        let requestTuple = self.anonURLRequest(url: url, parameters: params)
        
        sessionManager.request(requestTuple.request).response { response in
//            debugPrint("Response: \(response)")

            if(response.response?.statusCode == nil){ //no internet (timeout)
                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.TIME_OUT.rawValue), object: self)
                return
            }else if(response.response?.statusCode == HttpStatusCode.ACCESS_TOKEN_EXPIRED.rawValue){ //access token
                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.AccessTokenExpired.rawValue), object: self)
                return
            }else if (response.response?.statusCode == HttpStatusCode.SERVER_ERROR.rawValue) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.SERVER_ERROR.rawValue), object: self)
                return
            }else if (response.response?.statusCode == HttpStatusCode.NOT_FOUND.rawValue) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: CustomNotification.NOT_FOUND.rawValue), object: self)
                return
            } else if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let decryptedResult = CryptoFunctions.decrypt(encryptedJSON: utf8Text, AESkey: requestTuple.randomKey)
                let dict = self.convertToDictionary(text: decryptedResult) ?? ["":""]
                //FIXME : shady new
                self.reseponseDelegate?.response(dict: dict)
//                let responseObject = T(responseDict: dict)
//                completion(responseObject as T)
                
            }
        }
    }
    
    //MARK: private methods
    private class func securedURLRequest(url: String, parameters:[String:Any]?) -> (request: URLRequest,randomKey: String) {
        var payload = "";
        if let params = parameters, (parameters?.count)! > 0{
            payload = self.jsonToString(json: params)
        }
        
        let randomkey = CryptoFunctions.generateRandomAESKey()
        //FIXME: shady new
//        let encryptedKey = CryptoFunctions.encrptKey(keyString: randomkey)
//        let encryptedPayload = CryptoFunctions.encrypt(clearJSON: payload, AESkey: randomkey)
        let encryptedKey = ""
        let encryptedPayload = ""

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(CONTENT_TYPE, forHTTPHeaderField: "Content-Type")
        request.setValue(ACCEPT, forHTTPHeaderField: "Accept")
        //FIXME: shady new
//        request.setValue("Bearer \(API.AccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue(encryptedKey, forHTTPHeaderField: "X-PATH")
        let data = (encryptedPayload.data(using: .utf8))! as Data
        request.httpBody = data
        return (request,randomkey);
    }
    
    private class func anonURLRequest(url: String, parameters:[String:Any]?) -> (request: URLRequest,randomKey: String) {
        var payload = "";
        if let params = parameters, (parameters?.count)! > 0{
            payload = self.jsonToString(json: params)
        }
        
        let randomkey = CryptoFunctions.generateRandomAESKey()
        //FIXME: shady new
//        let encryptedKey = CryptoFunctions.encrptKey(keyString: randomkey)
//        let encryptedPayload = CryptoFunctions.encrypt(clearJSON: payload, AESkey: randomkey)

        let encryptedKey = ""
               let encryptedPayload = ""
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(CONTENT_TYPE, forHTTPHeaderField: "Content-Type")
        request.setValue(ACCEPT, forHTTPHeaderField: "Accept")
        request.setValue(encryptedKey, forHTTPHeaderField: "X-PATH")
        let data = (encryptedPayload.data(using: .utf8))! as Data
        request.httpBody = data
    
        return (request,randomkey);
    }
    
    private  class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                //print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private class func jsonToString(json: Any) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.init(rawValue: 0)) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString!
        } catch let myJSONError {
//            debugPrint(myJSONError)
            return ""
        }
    }
    
    private class func isValidJson(_ jsonString: String) -> Bool{
        if convertToDictionary(text: jsonString) != nil {
            return true
        }
        return false

    }
}
