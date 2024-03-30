//
//  Topic.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 28/3/24.
//

import Foundation
import SwiftData

@Model
class Topic: Identifiable {
    var id: UUID
    var number: Int
    var name: String
    var details: String
    
    init(name: String, number: Int, details: String) {
        self.id = UUID()
        self.name = name
        self.number = number
        self.details = details
    }
}
