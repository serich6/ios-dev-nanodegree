//
//  PhotoData.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
struct Photo: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    var mediaURL: String
    let uniqueKey: String
    var objectId: String
    var createdAt: String
    // Don't have to parse these two for the actual app
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
        case longitude = "longitude"
        case latitude = "latitude"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case uniqueKey = "uniqueKey"
        case objectId = "objectId"
        case createdAt = "createdAt"
        // Don't have to parse these two for the actual app
        case updatedAt = "updatedAt"
    }
}
