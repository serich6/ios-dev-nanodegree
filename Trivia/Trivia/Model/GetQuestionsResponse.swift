//
//  GetQuestionsResponse.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

struct GetQuestionsResponse: Codable {
    let responseCode: Int
    let questions: [Question]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case questions = "results"
    }
}

struct Question: Codable {
    let category: String
    let type: String
    let difficulty: String
    var question: String
    let correctAnswer: String
    let incorrectAnswers: Array<String>
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case type = "type"
        case difficulty = "difficulty"
        case question = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
}
