//
//  UdacityResponse.swift
//  On The Map
//
//  Created by Sam Rich on 6/10/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
// Modeled after TMDBResponse
struct LoginResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension LoginResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
