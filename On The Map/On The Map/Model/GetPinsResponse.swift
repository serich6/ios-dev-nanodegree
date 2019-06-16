//
//  GetPinsResponse.swift
//  On The Map
//
//  Created by Sam Rich on 6/15/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
struct GetPinsResponse: Codable {
    
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
