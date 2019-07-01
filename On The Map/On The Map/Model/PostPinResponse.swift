//
//  PostPinResponse.swift
//  On The Map
//
//  Created by Sam Rich on 6/25/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
struct PostPinResponse: Codable {
    let objectId: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectId"
        case createdAt = "createdAt"
    }
}
