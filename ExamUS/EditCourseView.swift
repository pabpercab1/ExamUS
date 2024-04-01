//
//  EditCourseView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 29/3/24.
//

import SwiftUI
import SwiftData

struct EditCourseView: View {
    @Bindable var course: Course
    
    var body: some View {
        Form{
            Section("Basic info") {
                TextField("Details", text: $course.details, axis: .vertical)
                TextField("Year", value: $course.year, formatter: NumberFormatter())
            }
            Section("Colour") {
                Picker("Course colour", selection: $course.color) {
                    Text("Red").tag("red")
                    Text("Green").tag("green")
                    Text("Blue").tag("blue")
                    Text("Yellow").tag("yellow")
                    Text("Orange").tag("orange")
                    Text("Purple").tag("purple")
                    Text("Pink").tag("pink")
                    Text("Cyan").tag("cyan")
                    Text("Teal").tag("teal")
                    Text("Indigo").tag("indigo")
                    Text("Mint").tag("mint")
                    Text("Brown").tag("brown")
                    Text("Gray").tag("gray")
                    Text("Black").tag("black")
                }
                .pickerStyle(.menu)
            }
            Section("Exams associated"){
                List {
                    ForEach(course.exams) { exam in
                        HStack {
                            Text(exam.name)
                            Spacer()
                            Text(exam.date.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                }
            }
        }
        .navigationTitle($course.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Course.self, configurations: config)
        let example = Course(name: "Example", details: "Detail example", year: 2024, professor: "Raúl Rodríguez")
        return EditCourseView(course: example)
            .modelContainer(container)
    } catch {
        fatalError("Fail to create model container")
    }
}
