//
//  Constants.swift
//  MOYO
//
//  Created by Whitney Bremer on 8/9/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//


import Foundation


//REPLACE THESE URL'S AND ENDPOINTS WITH YOUR OWN

//ROUTER.SWIFT

let ENVIRONMENT_URL = "https://localhost/query?lat="

let AMOSS_SERVER_DEV = "https://localhost/dev"

let AMOSS_API_BASE_URL = "https://localhost"

let AMOSS_LOGIN_ENDPOINT = "/loginParticipant"

let AMOSS_UPLOAD_ENDPOINT = "/api/yourproject/upload_s3"

let AMOSS_UPLOAD_VITALS = "/api/yourproject/mom/yourinstitution/vitals/upload"

let AMOSS_UPLOAD_SYMPTOMS = "/api/yourprojecy/mom/yourinstitution/symptoms/upload"



//EMRVIEWCONTROLLER

let AWS_ENDPOINT = "https://xxxxxxxx.execute-api.us-east-1.amazonaws.com/default/fhirFilter"

let EPIC_FHIR_PROD_BASE_URL = "https://EpicIntprxyPRD.yourinstitution/FHIR/oauth2/token"

let REDIRECT_URL = "https://localhost"

let PREFIX_URL = "https://localhost/yourinstitution?code="

let SERVER_LOGON = "https://EpicIntprxyPRD.yourURL/FHIR/oauth2/authorize?response_type=code&client_id=\(utswID().clientID)&redirect_uri=https://localhost/yourinstituion"

//CONTACTUSVIEWCONTROLLER

let WEBVIEW_URL = "https://yourWebViewURL"
