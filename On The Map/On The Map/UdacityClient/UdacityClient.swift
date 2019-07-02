//
//  UdacityClient.swift
//  On The Map
//
//  Created by Sam Rich on 6/11/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

class UdacityClient {
    //refactor out post request stuff to another class
    class func loginRequest(password: String, emailAddress: String, completion: @escaping (Bool, Error?) -> Void) {
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
                if response.account.key != "" {
                    DataModel.user.userKey = response.account.key
                    DataModel.user.sessionID = response.session.id
                    completion(true, nil)
                }
            }
            catch {
                completion(false, nil)
                return
            }
        }
        task.resume()
    }
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        let responseType = GetUserDataResponse.self
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(DataModel.user.userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                print("There was an error retrieving user data. Defaulting to test values")
                completion(false, error)
            } else {
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(responseType.self, from: newData!)
                    DataModel.user.lastName = response.lastName
                    DataModel.user.firstName = response.firstName
                    completion(true, nil)
                }
                catch {
                    completion(false, error)
                    return
                }
            }
            
        }
        task.resume()
    }
    
    //refactor out post request stuff to another class
    class func logoutRequest(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
            } else {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                completion(true, nil)
            }
        }
        task.resume()
    }
    
}
