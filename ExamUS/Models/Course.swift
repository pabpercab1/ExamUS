//
//  Course.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 28/3/24.
//

import Foundation
import SwiftData
import UIKit

@Model
class Course{
    var name: String
    var details: String
    var year: Int
    var professor: String
    var color: UIColor
    
    
    init(name: String, details: String, year: Int = Calendar.current.component(.year, from: Date()), professor: String, color: UIColor = .green) {
        self.name = name
        self.details = details
        self.year = year
        self.professor = professor
        self.color = color
    }
}
