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
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: data!)
                completion(response.triviaCategories, nil)
            }
            catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
