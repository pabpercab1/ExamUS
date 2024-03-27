//
//  ContentView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 27/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var exams: [Exam]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exams) {exam in
                    NavigationLink(value: exam) {
                        VStack(alignment: .leading) {
                            Text(exam.name)
                                .font(.headline)
                            Text(exam.course)
                            Text(exam.date.formatted(date: .long, time: .shortened))
                        }
                    }
                }
                .onDelete(perform: deleteExams)
            }
            .navigationTitle("ExamUS")
            .navigationDestination(for: Exam.self, destination: EditExamView.init)
            .toolbar{
                Button("Add sample", action: addSamples)
            }
        }
    }
    func addSamples(){
        let cbd = Exam(name: "Primer parcial", course: "CBD")
        let ispp = Exam(name: "Presentación", course: "ISPP")
        let dp = Exam(name: "Examen final", course: "DP1")
        
        modelContext.insert(cbd)
        modelContext.insert(ispp)
        modelContext.insert(dp)
    }
    func deleteExams(_ indexSet: IndexSet){
        for index in indexSet {
            let exam = exams[index]
            modelContext.delete(exam)
        }
    }
}

#Preview {
    ContentView()
}
