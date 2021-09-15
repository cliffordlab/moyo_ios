//
//  Router.swift
//  MOYO
//
//  Created by Corey S on 23/08/2018.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

class DataHolder {
    private static var _token: String? = nil
    private static let keychain = KeychainSwift()
    private static var _study: String? = nil
    private static let apiToken = "api.token"
    private static let userName = "userIf"
    private static let studyID = "studyID"
    private static var _userID: Int? = nil
    static var userID: Int? {
        get {
            if let v = _userID  {
                return v
            }
            _userID = UserDefaults.standard.value(forKey: userName) as? Int
            return _userID
        }
        set {
            _userID = newValue
            UserDefaults.standard.set(_userID, forKey: userName)
            UserDefaults.standard.synchronize()
        }
    }
    static var token: String? {
        get {
            if let t = _token {
                return t
            }
            _token = keychain.get(apiToken)
            return _token
        }
        set {
            _token = newValue
            if let value = _token {
                keychain.set(value, forKey: apiToken)
            }
            else {
                keychain.delete(apiToken)
            }
        }
    }
    
    static var study: String? {
        get {
            if let s = _study {
    
                return s
            }
            _study = keychain.get(studyID)
            return _study
        }
        set {
            print("lets set this action")
            _study = newValue
            if let value = _study {
                keychain.set(value, forKey: studyID)
            }
            else {
                keychain.delete(studyID)
            }
        }
    }
}

enum Router: URLRequestConvertible {
    
    //DEV
  // static let baseURL = AMOSSSERVERDEV
    //PROD
   static let baseURL = AMOSS_API_BASE_URL
    case login(email: String, password: String, participantID: Int)
    case uploadFile
    case uploadVitals
    case uploadSymptoms
    func methodAndPath() -> (HTTPMethod, String) {
        switch self {
        case .login:
            return (.post, AMOSS_LOGIN_ENDPOINT)
        case .uploadFile:
            //MAY CHANGE
            return (.post, AMOSS_UPLOAD_ENDPOINT)
        case .uploadVitals:
               return (.post, AMOSS_UPLOAD_VITALS)
          
        case .uploadSymptoms:
               return (.post, AMOSS_UPLOAD_SYMPTOMS)
        }
    }
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Router.baseURL)
        let (method, path) = self.methodAndPath()
        var request = URLRequest(url: url!.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        // auth
        switch self {
        case .login:
            break
        case .uploadFile:
            if let token = DataHolder.token{
                request.setValue("Mars \(token)", forHTTPHeaderField: "authorization")
            }
        case .uploadVitals:
                if let token = DataHolder.token{
                    request.setValue("Mars \(token)", forHTTPHeaderField: "authorization")
                }
            case .uploadSymptoms:
               if let token = DataHolder.token{
                   request.setValue("Mars \(token)", forHTTPHeaderField: "authorization")
               }
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch self {
        case let .login(email, password, participantID):
            request = try JSONEncoding.default.encode(request, with:["email" : email, "password": password, "participantID": participantID])
        case .uploadFile:
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            break
        case .uploadVitals:
             request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
             break
          case .uploadSymptoms:
             request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
             break
        }
        return request
    }
    
}
