//
//  OpenDBClient.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

class OpenDBClient {
    
    class func getCategories(completion: @escaping ([Category]?, Error?) -> Void) {
        let responseType = GetCategoriesResponse.self
        let urlString = "https://opentdb.com/api_category.php"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            //if there is an error with the datatask
            if error != nil {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: data!)
                completion(response.triviaCategories, nil)
                return
            }
            catch {
                print(error)
                completion(nil, error)
                return
            }
        }
        task.resume()
    }
    
    class func getQuestions(completion: @escaping ([Question]?, Error?) -> Void) {
        let responseType = GetQuestionsResponse.self
        let urlString = "https://opentdb.com/api.php?amount=2&category=9"
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            //if there is an error with the datatask
            if error != nil {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: data!)
                completion(response.questions, nil)
                return
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
