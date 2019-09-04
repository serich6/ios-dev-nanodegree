//
//  FlickerClient.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//



import Foundation

class FlickerClient {
    static let apiKey = "3d30e69daae03b256d1f0393d3c4e328"
    static let base = "https://www.flickr.com/services/rest/"
    static let method = "?method=flickr.photos.search"
    static let urlExtra = "&extras=url_n"
    static let jsonFormat = "&format=json&nojsoncallback=1"
    static let pageInfo = "&per_page=20&page=1"
    
    class func getPhotoPage(latitude: Double, longitude: Double, completion: @escaping ([FlickrPhoto]?, Error?) -> Void) {
        let responseType = GetPhotoListResponse.self
        let urlString = base + method + "&api_key=\(apiKey)&lat=\(latitude)&lon=\(longitude)" + pageInfo + urlExtra + jsonFormat
        let request = URLRequest(url: URL(string:urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            //if there is an error with the datatask
            if error != nil {
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: data!)
                completion(response.photos.photo, nil)
            }
            catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
//    class func convertFlikrPhotosToURLArray(photoSearchResults: [FlickrPhoto]) -> [String] {
//        var photoIDs: [String] = []
//        for photo in photoSearchResults {
//            photoIDs.append(photo.url)
//        }
//        return photoIDs
//    }
    class func convertFlikrPhotosToURLArray(photoSearchResults: [FlickrPhoto], completion: @escaping ([String]?, Error?) -> Void){
        var photoIDs: [String] = []
        for photo in photoSearchResults {
            photoIDs.append(photo.url)
        }
        completion(photoIDs, nil)
    }
    
    class func downloadImageData(photoURL: String, completion: @escaping (Data?, Error?) -> Void) {
        let responseType = GetPhotoInfoResponse.self
        let request = URLRequest(url: URL(string:photoURL)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                //let response = try decoder.decode(responseType.self, from: data!)
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                //completion(data, nil)
            }
            catch {
                print(error)
                completion(nil, error)
                return
            }
        }
        task.resume()
    }
}
