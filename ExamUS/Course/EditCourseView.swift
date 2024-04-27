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
    @Query(sort: [SortDescriptor(\Professor.name), SortDescriptor(\Professor.email)]) var professors: [Professor]
    
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
                .foregroundStyle(convertColor(color: course.color))
            }
            Section("Professors"){
                List{
                    if (professors.isEmpty){
                        HStack{
                            Image(systemName: "exclamationmark.triangle")
//                                .foregroundColor(.red)
                            Text("There are not professors added")
//                                .foregroundColor(.red)
                        }
                    } else {
                        ForEach(professors) { profe in
                            HStack{
                                if let courseProfessors = course.professors {
                                    if courseProfessors.isEmpty {
                                        Button {
                                            addRemoveProfessor(profe)
                                        } label: {
                                            Image(systemName: "circle")
                                        } .foregroundStyle(convertColor(color: course.color))
                                    } else {
                                        Button {
                                            addRemoveProfessor(profe)
                                        } label: {
                                            Image(systemName: courseProfessors.contains(profe) ?
                                                  "checkmark.circle.fill": "circle")
                                        }
                                    }
                                }
                                Text(profe.name)
                            }
                        }
                    }
                }
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
    func addRemoveProfessor(_ professor: Professor){
        if let courseProfessors = course.professors {
            if courseProfessors.isEmpty{
                course.professors?.append(professor)
            } else {
                if courseProfessors.contains(professor),
                   let index = courseProfessors.firstIndex(where: {$0.id == professor.id}){
                    course.professors?.remove(at: index)
                } else {
                    course.professors?.append(professor)
                }
            }
        }
    }
}

func convertColor(color: String) -> Color {
    switch color {
        case "red": return Color.red
        case "green": return Color.green
        case "blue": return Color.blue
        case "yellow": return Color.yellow
        case "orange": return Color.orange
        case "purple": return Color.purple
        case "pink": return Color.pink
        case "cyan": return Color.cyan
        case "mint": return Color.mint
        case "teal": return Color.teal
        case "indigo": return Color.indigo
        case "brown": return Color.brown
        case "gray": return Color.gray
        case "black": return Color.black
        default: return Color.clear // Default color if no match is found
    }
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Course.self, configurations: config)
        let example = Course(name: "Example", details: "Detail example", year: 2024)
        return EditCourseView(course: example)
            .modelContainer(container)
    } catch {
        fatalError("Fail to create model container")
    }
}
