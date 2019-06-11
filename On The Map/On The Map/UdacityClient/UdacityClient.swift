//
//  UdacityClient.swift
//  On The Map
//
//  Created by Sam Rich on 6/11/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

class UdacityClient {
    // move to login, then refactor out post request stuff to another class
    class func loginRequest(password: String, emailAddress: String, completion: @escaping (Bool, Error?) -> Void) {
        //TODO: refactor to move these two lines out.
        let body = "{\"udacity\": {\"username\": \"\(emailAddress)\", \"password\": \"\(password)\"}}"
        let responseType = LoginResponse.self
        
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: newData!)
                print("in do")
                print(response.account)
                if response.account.key != "" {
                    completion(true, nil)
                }
            }
            catch {
                print("unable to decode response")
                // this part isn't working, need to figure out why
                completion(false, nil)
                return
            }
            
        }
        task.resume()
    }
}
