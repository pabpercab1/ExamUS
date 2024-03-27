//
//  Exam.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 27/3/24.
//

import Foundation

class Exam {
    var id: String
    var name: String
    var description: String
    var date: Date
    var priority: Int
    
    init(name: String, description: String, date: Date, priority: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.date = date
        self.priority = priority
    }
}
