//
//  API.swift
//  MOYO
//
//  Created by Corey S on 25/08/2018.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
    case anyError
}

enum ApiResult<T>{
    case Success(result:T)
    case Error(message:String)
}
let kUnknownError = NSLocalizedString("Unknown error", comment: "Unknown error")
class API {
    public static let `default` = API()
    typealias APIBoolResult = ApiResult<Bool>
    func login(user: String, password: String, participantID: Int, completion: @escaping (APIBoolResult) -> Void){
        print("Ok")
        let request = Alamofire.request(Router.login(email: user, password: password, participantID: participantID))
        .validate()
        .responseJSON { (response) in
            if let error = response.error {
                print(response)
                completion(APIBoolResult.Error(message: error.localizedDescription))
                return
            }
            if let json = response.result.value as? [String: Any], let error = json ["error"] as? String{
                completion(APIBoolResult.Error(message: error))
                return
            }

            if let json = response.result.value as? [String: Any], let token = json ["token"] as? String, let participantID = json ["participantID"] as? String {
        
                DataHolder.token = token
                print(response)
              
                DataHolder.userID = Int(participantID)
            }
            
            if let studyResponse = response.result.value as? [String: Any], let study = studyResponse ["study"] as? String {
                DataHolder.study = study
            
    
            }
            
            else {
                
                completion(APIBoolResult.Error(message: "Error:"))
            }
            completion(API.APIBoolResult.Success(result: true))
        }
        print(request.debugDescription)
    }
    
    func sendDataReq(fileURL : URL, completion: @escaping (APIBoolResult) -> Void) {
        let uploadURL = (try! Router.uploadFile.asURLRequest().url)!
        let token = DataHolder.token!
        let timestamp = String(Int(round(NSDate().timeIntervalSince1970 * 1000)))
        print("here is the timestamp")
        print(timestamp)
        let headers = [
            "Authorization": "Mars \(String(token))",
            "weekMillis": timestamp,
            "Content-Type": "multipart/form-data",
                        ] as [String : Any]
        print("here is the token")
        print("\(String(describing: token))")
        Alamofire.upload(multipartFormData: { multipartFormData in
         
            multipartFormData.append(fileURL, withName: "upload")
            print(fileURL)
        },
                         to: uploadURL,
                         headers: headers as? HTTPHeaders, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in debugPrint(response)
                    print(response)
                    let jsonDictionary = response.value as? [String: Any]
                    print("here is the jsonDictionary")
                    print(jsonDictionary ?? "default")
                    if let message = jsonDictionary?["file"] as? String {
                        if message == "file uploaded" {
                            print("upload successful")
                        } else {
                            print("upload unsuccessful")
                        }
                    }
                    }
                    completion(API.APIBoolResult.Success(result: true))

                case .failure(let encodingError): print(encodingError)
                    completion(API.APIBoolResult.Error(message: encodingError.localizedDescription))
                }
        })

    }
    
    func uploadFile(millis:Int64, data:Data, fileName:String, completion: @escaping (APIBoolResult) -> Void){
        let url = try! Router.uploadFile.asURLRequest().url
        var mimeType = "application/octet-stream"
        switch url!.lastPathComponent {
        case "jpg", "jpeg":
            mimeType = "image/jpeg"
        case "png":
            mimeType = "image/png"
        case "csv":
            mimeType = "text/csv"
        default:
            break
        }

        if url?.pathExtension == "jpg" {
            mimeType = "image/jpeg"
        }
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(data, withName: "upload", fileName: fileName, mimeType: mimeType)
        }, to:url!,
           headers: ["Authorization" : "Mars " + DataHolder.token!,
                    //"Accept" : "application/json",
                    "weekMillis" : "\(millis)"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload
                    .responseJSON { response in
                        if let error = response.error {
                           print(response)
                            completion(APIBoolResult.Error(message: error.localizedDescription))
                            return
                        }
                        else if let json = response.value as? [String: Any]{
                            print(response)
                            if let message = json["success"] as? String {
                                if message == "you have completed upload to amoss_mhealth" {
                                    print(json)
                                    print(message)
                                    print("upload successful")
                                    completion(API.APIBoolResult.Success(result: true))
                                    return
                                } else {
                                    print("upload unsuccessful")
                                }
                            }
                        }
                        completion(API.APIBoolResult.Success(result: false))
                }
            case .failure(let encodingError):
                #if DEBUG
                print(encodingError)
                #endif
                completion(API.APIBoolResult.Error(message: encodingError.localizedDescription))
            }
        }
    }
    
    func uploadVitals(millis:Int64, data:Data, fileName:String, spb:Int, dbp:Int, pulse:Int, created_at: Int64, completion: @escaping (APIBoolResult) -> Void){
           
        let url = try! Router.uploadVitals.asURLRequest().url
           var mimeType = "application/octet-stream"
           switch url!.lastPathComponent {
           case "jpg", "jpeg":
               mimeType = "image/jpeg"
           case "png":
               mimeType = "image/png"
           case "csv":
               mimeType = "text/csv"
           default:
               break
           }

           if url?.pathExtension == "jpg" {
               mimeType = "image/jpeg"
           }
           Alamofire.upload(multipartFormData: { (MultipartFormData) in
               MultipartFormData.append(data, withName: "upload", fileName: fileName, mimeType: mimeType)
               MultipartFormData.append("\(spb)".data(using: .utf8)!, withName: "sbp")
               MultipartFormData.append("\(dbp)".data(using: .utf8)!, withName: "dbp")
               MultipartFormData.append("\(pulse)".data(using: .utf8)!, withName: "pulse")
               MultipartFormData.append("\(created_at)".data(using: .utf8)!, withName: "created_at")
           }, to:url!,
              headers: ["Authorization" : "Mars " + DataHolder.token!,
                       "Accept" : "application/json",
                       "weekMillis" : "\(millis)"])
           { (result) in
               switch result {
               case .success(let upload, _, _):
                   upload
                       .responseJSON { response in
                           if let error = response.error {
                             //  print(response.error)
                               completion(APIBoolResult.Error(message: error.localizedDescription))
                               return
                           }
                           else if let json = response.value as? [String: Any]{
                               if let message = json["success"] as? String {
                                   if message == "you have completed upload to amoss_mhealth" {
                                       print(json)
                                       print(message)
                                       print("upload successful")
                                       completion(API.APIBoolResult.Success(result: true))
                                       return
                                   } else {
                                       print("upload unsuccessful")
                                   }
                               }
                           }
                           completion(API.APIBoolResult.Success(result: false))
                   }
               case .failure(let encodingError):
                   #if DEBUG
                   print(encodingError)
                   #endif
                   completion(API.APIBoolResult.Error(message: encodingError.localizedDescription))
               }
           }
       }
       
       func uploadSymptoms(millis:Int64, data:Data, fileName:String, headache:Bool, blurred_vision:Bool, side_pain:Bool, difficulty_breathing:Bool, created_at: Int64, completion: @escaping (APIBoolResult) -> Void){
           
           let url = try! Router.uploadSymptoms.asURLRequest().url
           var mimeType = "application/octet-stream"
           switch url!.lastPathComponent {
           case "jpg", "jpeg":
               mimeType = "image/jpeg"
           case "png":
               mimeType = "image/png"
           case "csv":
               mimeType = "text/csv"
           default:
               break
           }

           if url?.pathExtension == "jpg" {
               mimeType = "image/jpeg"
           }
           Alamofire.upload(multipartFormData: { (MultipartFormData) in
               MultipartFormData.append(data, withName: "upload", fileName: fileName, mimeType: mimeType)
               MultipartFormData.append("\(headache)".data(using: .utf8)!, withName: "headache")
               MultipartFormData.append("\(blurred_vision)".data(using: .utf8)!, withName: "blurred_vision")
               MultipartFormData.append("\(side_pain)".data(using: .utf8)!, withName: "side_pain")
               MultipartFormData.append("\(difficulty_breathing)".data(using: .utf8)!, withName: "difficulty_breathing")
               MultipartFormData.append("\(created_at)".data(using: .utf8)!, withName: "created_at")
           }, to:url!,
              headers: ["Authorization" : "Mars " + DataHolder.token!,
                       "Accept" : "application/json",
                       "weekMillis" : "\(millis)"])
           { (result) in
               switch result {
               case .success(let upload, _, _):
                   upload
                       .responseJSON { response in
                           if let error = response.error {
                             //  print(response.error)
                               completion(APIBoolResult.Error(message: error.localizedDescription))
                               return
                           }
                           else if let json = response.value as? [String: Any]{
                               if let message = json["success"] as? String {
                                   if message == "you have completed upload to amoss_mhealth" {
                                       print(json)
                                       print(message)
                                       print("upload successful")
                                       completion(API.APIBoolResult.Success(result: true))
                                       return
                                   } else {
                                       print("upload unsuccessful")
                                   }
                               }
                           }
                           completion(API.APIBoolResult.Success(result: false))
                   }
               case .failure(let encodingError):
                   #if DEBUG
                   print(encodingError)
                   #endif
                   completion(API.APIBoolResult.Error(message: encodingError.localizedDescription))
               }
           }
       }
}
