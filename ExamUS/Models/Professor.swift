//
//  Professor.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 15/4/24.
//

import Foundation
import SwiftData

@Model
class Professor {
    var name: String
    var email: String
    var course: [Course]?
    
    init(name: String, email: String = "") {
        self.name = name
        self.email = email
    }
}
