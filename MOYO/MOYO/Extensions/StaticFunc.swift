//
//  StaticFunc.swift
//  MOYO
//
//  Created by Corey S on 16/09/2018.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import KRProgressHUD

func formattedDateAndMillis() -> (String, Int64) {
    let date = Date()
    print(date)
    let multipliedMillis = Int64(date.timeIntervalSince1970 * 1000)
    let millis = multipliedMillis % Int64(truncating: NSDecimalNumber(decimal: pow(10, multipliedMillis.description.count - 1)))
    
    let formmatter = DateFormatter()
    formmatter.dateFormat = "yyyyMMdd-hh:mm"
    let formattedDate = formmatter.string(from: date)
    print(millis)
    return (formattedDate, millis)
}


func formattedWeeklyMillis() -> (Int64) {
    var setDate = Date()
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.weekday], from: setDate)
    if components.weekday == 2{
        setDate = Date.today().previous(.monday).next(.monday)
    } else {
    
        if components.weekday == 1{
            setDate = Date.today().next(.monday)
        } else {
            setDate = Date.today().previous(.monday)
        }
    }
    print("here is date \(setDate)")
    let multipliedMillis = Int64(setDate.timeIntervalSince1970 * 1000)
    let weekMillis = multipliedMillis % Int64(truncating: NSDecimalNumber(decimal: pow(10, multipliedMillis.description.count - 1)))
    print(weekMillis)
    return (weekMillis)
}

func sendFile(fileName name: String, withString string: String, completion: ((_ success: Bool) -> Void)? = nil) {
    let (_, millis) = formattedDateAndMillis()
    let (weeklyMilis) = formattedWeeklyMillis()
   
    if DataHolder.userID != nil {
        let fileName = "\(String(describing: DataHolder.userID!))_\(millis)_iOS_\(name)"
        print(fileName)
        // send data
        let data = string.data(using: .utf8)!
        KRProgressHUD.show(withMessage:NSLocalizedString("Sending data..", comment: ""), completion: nil)
        print("file:\n" + fileName)
        print("data:\n" + string)
        print(weeklyMilis)
        API.default.uploadFile(millis: weeklyMilis, data: data, fileName:fileName, completion: { (result) in
            KRProgressHUD.dismiss()
            switch result {
            case let .Error(message):
                UIViewController.showError(message: message)
                completion?(false)
            case .Success:
                completion?(true)
            }
        })
    }
    else {
        completion?(false)
    }
}
