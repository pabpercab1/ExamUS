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
    
    @State private var path = [Exam]()
    @State private var sortOrder = SortDescriptor(\Exam.date)
    @State private var searchText = ""
    
    var body: some View {
        TabView {
            NavigationStack(path: $path) {
                ExamListView(sort: sortOrder, search: searchText)
                    .navigationTitle("ExamUS")
                    .navigationDestination(for: Exam.self, destination: EditExamView.init)
                    .searchable(text: $searchText)
                    .toolbar{
                        Button("Add sample", action: addSamples)
                        Button("Add", systemImage: "plus", action: addExam)
                        Menu {
                            Picker("Sort", selection: $sortOrder) {
                                Label("Name", systemImage: "abc").tag(SortDescriptor(\Exam.name))
                                Label("Date", systemImage: "calendar").tag(SortDescriptor(\Exam.date))
                                Label("Course", systemImage: "book").tag(SortDescriptor(\Exam.course))
                            }
                            .pickerStyle(.inline)
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                        }
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            Text("test")
            .tabItem {
                Image(systemName: "book")
                Text("Courses")
            }
        }
    }
    func addExam(){
        let exam = Exam(name:"New exam")
        modelContext.insert(exam)
        path = [exam]
    }
    func addSamples(){
        let cbd = Exam(name: "Primer parcial", course: "CBD")
        let ispp = Exam(name: "Presentación", course: "ISPP")
        let dp = Exam(name: "Examen final", course: "DP1")
        
        modelContext.insert(cbd)
        modelContext.insert(ispp)
        modelContext.insert(dp)
    }
}

#Preview {
    ContentView()
}
