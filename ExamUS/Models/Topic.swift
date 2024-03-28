//
//  Topic.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 28/3/24.
//

import Foundation
import SwiftData

@Model
class Topic{
    var name: String
    var details: String
    
    init(name: String, details: String) {
        self.name = name
        self.details = details
    }
}
