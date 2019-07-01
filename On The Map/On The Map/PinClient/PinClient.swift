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
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            //if there is an error with the datatask
            if error != nil {
                completion(nil, error)
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
    
    class func getUsersPin(completion: @escaping (Bool, Error?) -> Void) {
        let responseType = GetPinsResponse.self
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey=\(DataModel.user.userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            //if there is an error with the datatask
            if error != nil {
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: data!)
                print(response)
                completion(true, nil)
            }
            catch {
                print(error)
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func postPin(pin: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        var pin = pin
        let responseType = PostPinResponse.self
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(DataModel.user.userKey)\", \"firstName\": \"\(DataModel.user.firstName)\", \"lastName\": \"\(DataModel.user.lastName)\",\"mapString\": \"\(pin.mapString)\", \"mediaURL\": \"\(pin.mediaURL)\",\"latitude\": \(pin.latitude), \"longitude\": \(pin.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: data!)
                pin.createdAt = response.createdAt
                pin.objectId = response.objectId
                DataModel.pinData.append(pin)
                print(response)
                completion(true, nil)
            }
            catch {
                print(error)
                completion(false, error)
            }
        }
        task.resume()
        
    }
}
