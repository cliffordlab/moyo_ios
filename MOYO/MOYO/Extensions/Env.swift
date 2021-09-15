//
//  Env.swift
//  MOYO
//
//  Created by User on 1/17/19.
//  Copyright © 2019 Clifford Lab. All rights reserved.
//

import UIKit

class Env {
    
    static var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
