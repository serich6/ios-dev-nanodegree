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
    class func loginRequest(password: String, emailAddress: String, completion: @escaping (Bool, String?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(emailAddress)\", \"password\": \"\(password)\"}}"
        let responseType = LoginResponse.self
        
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            // From Code review feedback
            if error != nil {
                completion(false, error?.localizedDescription)
                return
            }
            
             // From Code review feedback
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(false, error?.localizedDescription)
                return
            }
            
             // From Code review feedback
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                // Since Status Code is valid. Process Data here only.
                guard let data = data else {
                    completion(false, error?.localizedDescription)
                    return
                }
                 // This is syntax to create Range in Swift 5
                let range = 5..<data.count
                let newData = data.subdata(in: range) /* subset response data! */
                // Continue processing the data and deserialize it

                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(responseType.self, from: newData)
                    if response.account.key != "" {
                        DataModel.user.userKey = response.account.key
                        DataModel.user.sessionID = response.session.id
                        completion(true, nil)
                    }
                }
                catch {
                    completion(false, error.localizedDescription)
                    return
                }
            }
                 // From Code review feedback
            else {
                var errorMessage: String
                switch httpStatusCode {
                case 400:
                   errorMessage = "Bad Request"
                case 401:
                    errorMessage = "Unauthorized"
                case 403:
                    errorMessage = "Invalid Credentials"
                case 405:
                    errorMessage = "HttpMethod Not Allowed"
                case 410:
                    errorMessage = "URL Changed"
                case 500:
                    errorMessage = "A Server Error error occurred. Please try again"
                default:
                    errorMessage = "An unknown error occurred. Please try again"
                }
                completion(false, errorMessage)
            }
        }
        task.resume()
    }
    
    // From class provided code example
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        let responseType = GetUserDataResponse.self
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(DataModel.user.userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(false, error)
                return
            }
            
            // From Code review feedback
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(false, error)
                return
            }
            
            // From Code review feedback
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                // Since Status Code is valid. Process Data here only.
                guard let data = data else {
                    completion(false, error)
                    return
                }
                // This is syntax to create Range in Swift 5
                let range = 5..<data.count
                let newData = data.subdata(in: range) /* subset response data! */
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(responseType.self, from: newData)
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
                return
            } else {
                let range = 5..<data!.count
                let newData = data?.subdata(in: range) /* subset response data! */
                completion(true, nil)
            }
        }
        task.resume()
    }
    
}
