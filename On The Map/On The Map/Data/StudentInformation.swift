//
//  StudentInformation.swift
//  On The Map
//
//  Created by Sam Rich on 6/11/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

// Example:
// [{"firstName":"Raheem","lastName":"Medhurst","longitude":46.754795,"latitude":24.580842,"mapString":"sara","mediaURL":"https%252525253A%252525252F%252525252FPune.com","uniqueKey":"555364971","objectId":"ID10","createdAt":"2019-05-17T00:53:33.941Z","updatedAt":"2019-06-06T21:17:08.510Z"}
struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    var mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    // Don't have to parse these two for the actual app
    let updatedAt: String
    
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
