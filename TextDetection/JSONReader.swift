//
//  JSONReader.swift
//  TextDetection
//
//  Created by Andy on 2024/8/31.
//

import Foundation

struct ExamQuestion: Codable {
    let paper: String
    let questions: [String: String]
    let ms: [String: String]
    let n: [String: String]
}

func parseExamQuestions() -> [ExamQuestion]? {
    guard let url = Bundle.main.url(forResource: "paperkey", withExtension: "json") else {
        print("File not found")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        let json = try JSONDecoder().decode([String: [String: [String: String]]].self, from: data)
        
        var examQuestions: [ExamQuestion] = []
        
        for (paperName, questionsDict) in json {
            var questions: [String: String] = [:]
            var markSchemes: [String: String] = [:]
            var numImage: [String: String] = [:]
            
            for (questionNumber, questionData) in questionsDict {
                if let content = questionData["content"] {
                    questions[questionNumber] = content
                }
                if let ms = questionData["ms"] {
                    markSchemes[questionNumber] = ms
                }
                if let n = questionData["n"] {
                    numImage[questionNumber] = n
                }
            }
            
            let examQuestion = ExamQuestion(paper: paperName, questions: questions, ms: markSchemes, n: numImage)
            examQuestions.append(examQuestion)
        }
        
        return examQuestions
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

