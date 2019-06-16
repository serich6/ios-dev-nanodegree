//
//  PinClient.swift
//  On The Map
//
//  Created by Sam Rich on 6/15/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

class PinClient {
    class func getPins(completion: @escaping ([StudentInformation]?, Error?) -> Void) {
        let responseType = GetPinsResponse.self
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order-=updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            //if there is an error with the datatask
            if error != nil {
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: data!)
                completion(response.results, nil)
            }
            catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
