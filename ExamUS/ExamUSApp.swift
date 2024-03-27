//
//  ExamUSApp.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 27/3/24.
//

import SwiftUI
import SwiftData

@main
struct ExamUSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Exam.self)
    }
}
