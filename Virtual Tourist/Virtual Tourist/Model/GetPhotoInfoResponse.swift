//
//  GetPhotoInfoResponse.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

struct GetPhotoInfoResponse: Codable {
    let sizes: InfoSizes
    enum CodingKeys: String, CodingKey {
        case sizes = "sizes"
    }
}

struct InfoSizes: Codable {
    let canBlog: Int
    let canPrint: Int
    let canDownload: Int
    let sizeWithLinks: [PhotoSizes]
    
    enum CodingKeys: String, CodingKey {
        case canBlog = "canblog"
        case canPrint = "canprint"
        case canDownload = "candownload"
        case sizeWithLinks = "size"
    }
}

struct PhotoSizes: Codable {
    let label: String
    //let width: Double
    //let height: Double
    let source: String
    let url: String
    let media: String

    enum CodingKeys: String, CodingKey {
        case label = "label"
//        case width = "width"
//        case height = "height"
        case source = "source"
        case url = "url"
        case media = "media"
    }
}
