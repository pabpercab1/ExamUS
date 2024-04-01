//  ContentView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 27/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var examPath = [Exam]()
    @State private var coursePath = [Course]()
    @State private var sortOrder = SortDescriptor(\Exam.date)
    @State private var sortOrderCourse = SortDescriptor(\Course.year)
    @State private var searchText = ""
    @State private var searchTextCourse = ""
    
    @State private var showingAlert = false
    @State private var isShowingDetailView = false
    
    var body: some View {
            TabView {
                // First Tab
                NavigationStack(path: $examPath) {
                    ExamListView(sort: sortOrder, search: searchText)
                        .navigationTitle("ExamUS")
                        .navigationDestination(for: Exam.self) { exam in
                            EditExamView(exam: exam)
                                .onDisappear{
                                    if ((exam.course) != nil){
                                        addExamToCourse()
                                    } else {
                                        showingAlert = true
                                        // Here it would be great to return to the view
                                        modelContext.delete(exam)
                                    }
                                }
                        }
                        .alert(isPresented: $showingAlert) {
                                buildAlert()
                                }
                        .searchable(text: $searchText)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                                Button("Add sample", action: addSamples)
                                Button(action: addExam) {
                                    Image(systemName: "plus.circle.fill")
                                }
                                Menu {
                                    Picker("Sort", selection: $sortOrder) {
                                        Label("Name", systemImage: "abc").tag(SortDescriptor(\Exam.name))
                                        Label("Date", systemImage: "calendar").tag(SortDescriptor(\Exam.date))
                                    }
                                    .pickerStyle(.inline)
                                } label: {
                                    Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                                }
                            }
                        }
                }
                .tabItem {
                    Label("ExamUS", systemImage: "house.fill")
                }

                // Second Tab
                NavigationStack(path: $coursePath) {
                    CourseListView(sort: sortOrderCourse, search: searchTextCourse)
                        .navigationTitle("Courses")
                        .navigationDestination(for: Course.self) { course in
                            EditCourseView(course: course)
                        }
                        .toolbar(){
//                            Button("Add sample", action: addSamplesCourses)
                            Button(action: addCourse){
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        .searchable(text: $searchTextCourse)
                }
                .tabItem {
                    Label("Courses", systemImage: "book")
                }
            }
        }
    func addExam(){
        let exam = Exam(name:"New exam")
        modelContext.insert(exam)
        examPath = [exam]
    }
    func addCourse(){
        let course = Course(name:"New course")
        modelContext.insert(course)
        coursePath = [course]
    }
    
    func addSamples(){
        let cbd = Exam(name: "Primer parcial", course: Course(name: "CBD", details: "String", professor: "Paula"))
        let ispp = Exam(name: "Presentación", course: Course(name: "ISPP", details: "Detail", professor: "Ramon"))
        let dp = Exam(name: "Examen final", course: Course(name: "DP1", details: "Thst", professor: "Raul"))
        
        modelContext.insert(cbd)
        modelContext.insert(ispp)
        modelContext.insert(dp)
    }
    func addSamplesCourses(){
        let cbd = Course(name: "CBD", details: "String", professor: "Paula")
        let ispp = Course(name: "ISPP", details: "Detail", professor: "Ramon")
        let dp = Course(name: "DP1", details: "Thst", professor: "Raul")
        
        modelContext.insert(cbd)
        modelContext.insert(ispp)
        modelContext.insert(dp)
    }
    func addExamToCourse(){
        guard let selectedExam = examPath.first, let selectedCourse = selectedExam.course else {
            return
        }
        selectedCourse.exams.append(selectedExam)
        do {
            try modelContext.save()
        } catch {
            print("Error adding exam to course: \(error)")
        }
    }
    func buildAlert() -> Alert {
        return Alert(
                title: Text("Error creating the exam"),
                message: Text("The exam created did not have a valid Course selected")
            )
    }
}

#Preview {
    ContentView()
}
