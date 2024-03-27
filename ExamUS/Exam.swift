//
//  Exam.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 27/3/24.
//

import Foundation
import SwiftData

@Model
class Exam {
    var id: String
    var name: String
    var course: String
    var details: String
    var date: Date
    var session: Int
    
    init(name: String = "", details: String = "", course: String = "", date: Date = .now, session: Int = 2) {
        self.id = UUID().uuidString
        self.name = name
        self.details = details
        self.course = course
        self.date = date
        self.session = session
    }
}
