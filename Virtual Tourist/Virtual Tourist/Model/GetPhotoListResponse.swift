//
//  GetPhotoListResponse.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//


// example response
//{"photos":
//{"page":1,"pages":603,"perpage":250,"total":"150683","photo":[{"id":"48164509312","owner":"72677183@N00","secret":"669ebde7e1","server":"65535","farm":66,"title":"Pav Bhaji!","ispublic":1,"isfriend":0,"isfamily":0},{"id":"48162952266","owner":"163949237@N08","secret":"5c68aa1759","server":"65535","farm":66,"title":"Baylands Dawn","ispublic":1,"isfriend":0,"isfamily":0},
import Foundation
struct GetPhotoListResponse: Codable {
    
    let photos: Page
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
}

struct Page: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perpage = "perpage"
        case total = "total"
        case photo = "photo"
    }
}

struct Photo: Codable {
    let id: String
    let ownder: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownder = "owner"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
        case title = "title"
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}
