//
//  StudentInformation.swift
//  On The Map
//
//  Created by Sam Rich on 6/11/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let key: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    // Don't have to parse these two for the actual app
    let updatedAt: Date
    let acl: String
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case uniqueKey = "uniqueKey"
        case firstName = "firstName"
        case lastName = "lastName"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case latitude = "latitude"
        case longitude = "longitude"
        case createdAt = "createdAt"
        // Don't have to parse these two for the actual app
        case updatedAt = "updatedAt"
        case acl = "ACL"
    }
}
