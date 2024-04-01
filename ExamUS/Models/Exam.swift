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
    var name: String
    var details: String
    var date: Date
    var session: Int
    @Relationship var course: Course?
    @Relationship(deleteRule: .cascade) var topics = [Topic]()
    
    init(name: String = "", details: String = "", course: Course? = nil, date: Date = .now, session: Int = 1) {
        self.name = name
        self.details = details
        self.course = course
        self.date = date
        self.session = session
    }
}
