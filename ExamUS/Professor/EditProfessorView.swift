//
//  EditProfessorView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 15/4/24.
//

import SwiftUI
import SwiftData

struct EditProfessorView: View {
    @Bindable var profe: Professor
    
    @Query(sort: [SortDescriptor(\Professor.name)]) var professors: [Professor]
    
    
    
    var body: some View {
        Form{
            Section("Email") {
                TextField("someone(at)example.com", text: $profe.email, axis: .vertical)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            Section("Courses associated"){
                List {
                    ForEach(profe.course ?? []) { course in
                        HStack {
                            Text(course.name)
                            Spacer()
                            Image(systemName: "circle.fill")
                                .foregroundStyle(convertColor(color: course.color))
                        }
                    }
                }
            }
        }
        .navigationTitle($profe.name)
        .navigationBarTitleDisplayMode(.inline)
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
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Exam.self, configurations: config)
        let example = Professor(name: "Pepe", email: "pepe@us.es")
        
        return EditProfessorView(profe: example)
            .modelContainer(container)
    } catch {
        fatalError("Fail to create model container")
    }
}


