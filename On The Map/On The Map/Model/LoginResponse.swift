//
//  LoginResponse.swift
//  On The Map
//
//  Created by Sam Rich on 6/10/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
    struct Account: Codable {
        let registered: Bool
        let key: String
        
        enum CodingKeys: String, CodingKey {
            case registered = "registered"
            case key = "key"
        }
    }
    
    struct Session: Codable {
        let id: String
        let expiration: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case expiration = "expiration"
        }
    }
}
