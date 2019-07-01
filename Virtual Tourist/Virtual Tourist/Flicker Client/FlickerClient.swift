//
//  FlickerClient.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//



import Foundation

class FlickerClient {
    class func getPhotoPage(latitude: Double, longitude: Double, completion: @escaping ([Photo]?, Error?) -> Void) {
        let responseType = GetPhotoListResponse.self
        let request = URLRequest(url: URL(string:"https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=3d30e69daae03b256d1f0393d3c4e328&lat=\(latitude)&lon=\(longitude)&&extras=url&format=json&nojsoncallback=1")!)
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
}
