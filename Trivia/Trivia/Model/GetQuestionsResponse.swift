//
//  GetQuestionsResponse.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

// {"response_code":0,"results":[{"category":"General Knowledge","type":"multiple","difficulty":"easy","question":"On a dartboard, what number is directly opposite No. 1?","correct_answer":"19","incorrect_answers":["20","12","15"]},{"category":"General Knowledge","type":"multiple","difficulty":"medium","question":"Which slogan did the fast food company, McDonald&#039;s, use before their &quot;I&#039;m Lovin&#039; It&quot; slogan?","correct_answer":"We Love to See You Smile","incorrect_answers":["Why Pay More!?","Have It Your Way","Making People Happy Through Food"]}]}
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
    let question: String
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
