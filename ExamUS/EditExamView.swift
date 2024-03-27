//
//  EditExamView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 27/3/24.
//

import SwiftUI
import SwiftData

struct EditExamView: View {
    @Bindable var exam: Exam
    
    var body: some View {
        Form{
            Section("Basic info") {
                TextField("Details", text: $exam.details, axis: .vertical)
                DatePicker("Date", selection: $exam.date)
            }
            
            Section("Session") {
                Picker("Session", selection: $exam.session){
                    Text("A").tag(1)
                    Text("B").tag(2)
                    Text("C").tag(3)
                    Text("D").tag(4)
                }
                .pickerStyle(.segmented)
            }
            Section("Course selection") {
                TextField("Course", text: $exam.course)
            }
        }
        .navigationTitle($exam.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Exam.self, configurations: config)
        let example = Exam(name: "Example", details: "Detail example", course: "CBD")
        return EditExamView(exam: example)
            .modelContainer(container)
    } catch {
        fatalError("Fail to create model container")
    }
}
