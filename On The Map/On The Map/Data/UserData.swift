//
//  UserData.swift
//  On The Map
//
//  Created by Sam Rich on 6/11/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

class UserData {
    var userKey: Int
    var sessionID: String
    var hasPin: Bool
    
    init() {
        userKey = 0
        sessionID = ""
        hasPin = false
    }
}
