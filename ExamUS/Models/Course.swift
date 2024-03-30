//
//  Course.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 28/3/24.
//

import Foundation
import SwiftData

@Model
class Course {
    var name: String
    var details: String
    var year: Int
    var professor: String
    var color: String
    @Relationship(deleteRule: .cascade) var exams = [Exam]()
    
    init(name: String, details: String = "", year: Int = Calendar.current.component(.year, from: Date()), professor: String = "", color: String = "green") {
        self.name = name
        self.details = details
        self.year = year
        self.professor = professor
        self.color = color
    }
}

