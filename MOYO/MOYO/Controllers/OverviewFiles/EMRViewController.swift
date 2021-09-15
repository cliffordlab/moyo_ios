//
//  EMRViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 7/16/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class EMRViewController: UIViewController, WKNavigationDelegate {
    
    var clientID = utswID().clientID
    let storedClientID = String()
    var urlCode = String()
    var accessToken = String()
    var patientID = String()
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self
        serverLogOn()
        
    }
    
    
    func serverLogOn() {
        //Production server. Log on with client ID which is stored safely in a file that is gitignore
            if let url = URL(string: SERVER_LOGON) {
                clientID = storedClientID
            let request = URLRequest(url: url)
                webview.load(request)
            }
    }
    
    //Detects webkit redirect, compare with URL we need code from, grab code
    //Return user to home page of app and continue submitting data on background
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url as Any)
        if navigationAction.request.url!.absoluteString.hasPrefix(PREFIX_URL) {

            let queryParam = getQueryStringParameter(url: (navigationAction.request.url)!, param: "code")
            urlCode = queryParam ?? ""
    
            //
            DispatchQueue.background(background: {
                self.getAccessTokenAndPatient()
            }, completion:{
                print("BACK TO MAIN THREAD")
            })
     
        }
        decisionHandler(.allow)
        
    }
    
    //Make Post request using code from above function "urlCode" to grab access_token and patient
    func getAccessTokenAndPatient() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }

        let parameters = [
                    "grant_type": "authorization_code",
                    "code": urlCode,
                    "redirect_uri": REDIRECT_URL,
                    "client_id": utswID().clientID
                  
                ]
        
                let headers = ["Content-Type": "application/x-www-form-urlencoded"]
                let url = EPIC_FHIR_PROD_BASE_URL
      
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            print(response)
            print(url)
            if let json = response.result.value as? [String: Any] {
                
                guard let responseToken = json["access_token"] as? String,
                      let responsePatient = json["patient"] as? String else {
           
                      print("Failed to parse JSON")
                      return
                }
                
                self.accessToken = responseToken
                self.patientID = responsePatient
                self.amossRequest()
            }
            
        })
      
    }
    
    func amossRequest() {
        //Payload to AMOSS with parameters below

        //WeekMillis needs to be timestamp below but with first digit removed
        let timestamp = String(Int(round(NSDate().timeIntervalSince1970 * 1000)))
        let timestampFirstDropped = timestamp.dropFirst()
        let timestampFinalForm = String(timestampFirstDropped)
        
        //Moyo ID must be string
        let stringMoyoID = String(DataHolder.userID!)
        
        let parameters = [
            "participant_ID": stringMoyoID,
            "patient_token": accessToken,
            "patient_ID": patientID,
            "category": "allergy"
          
        ] as [String : Any]

        let headers = ["Content-Type": "multipart/form-data",
                       "weekMillis": timestampFinalForm
        ]
       let url = AWS_ENDPOINT

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            print(response)
           
        })
    
    }
    
    //Grabs query param from url
    func getQueryStringParameter(url: URL, param: String) -> String? {
        guard let url = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

//Extension for background thread
extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
