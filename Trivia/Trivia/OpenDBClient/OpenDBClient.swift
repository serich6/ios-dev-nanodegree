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
    
    class func getQuestions(category: Int, completion: @escaping ([Question]?, Error?) -> Void) {
        let responseType = GetQuestionsResponse.self
        let urlString = buildUserDefaultsString(category: category)
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
                let questions = cleanQuestions(questions: response.questions)
                completion(questions, nil)
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
    
    class func buildUserDefaultsString(category: Int) -> String {
        //trueFalseEnabled
        // multipleChoiceEnabled
        var result = "https://opentdb.com/api.php?amount=5&category=\(category)"
        switch UserDefaults.standard.integer(forKey: "difficultyLevel") {
        case 0:
            result.append("&difficulty=easy")
        case 1:
            result.append("&difficulty=medium")
        case 2:
            result.append("&difficulty=hard")
        default:
            result.append("")
        }
        
        if !UserDefaults.standard.bool(forKey: "multipleChoiceEnabled") {
            result.append("&type=multiple")
        } else if !UserDefaults.standard.bool(forKey: "trueFalseEnabled") {
            result.append("&type=boolean")
        }
        return result
    }
    
    
    // Added method to clean the questions from special character encoding(?) issues.
    class func cleanQuestions(questions: [Question]) -> [Question] {
        var cleanedQuestions: [Question] = []
        for var q in questions {
            var modifiedString = q.question.replacingOccurrences(of: "&quot;", with: "\"")
            modifiedString = modifiedString.replacingOccurrences(of: "&#039;", with: "'")
            modifiedString = modifiedString.replacingOccurrences(of: "&amp;", with: "&")
            q.question = modifiedString
            cleanedQuestions.append(q)
        }
        return cleanedQuestions
    }
}
