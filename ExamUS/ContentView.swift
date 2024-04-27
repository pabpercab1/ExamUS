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
    @State private var professorPath = [Professor]()
    @State private var sortOrder = SortDescriptor(\Exam.date)
    @State private var sortOrderCourse = SortDescriptor(\Course.year)
    @State private var sortOrderProfessor = SortDescriptor(\Professor.name)
    @State private var searchText = ""
    @State private var searchTextCourse = ""
    @State private var searchTextProfessor = ""
    
    @State private var showingAlert = false
    @State private var isShowingDetailView = false
    
    @Query(sort: [SortDescriptor(\Exam.date),
                  SortDescriptor(\Exam.course?.name)]) var exams: [Exam]
    @Query(sort: [SortDescriptor(\Course.year), SortDescriptor(\Course.name)]) var courses: [Course]
    @Query(sort: [SortDescriptor(\Professor.name), SortDescriptor(\Professor.email)]) var professors: [Professor]
    
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
                                if (!exams.isEmpty){
                                    EditButton()
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
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                //                            Button("Add sample", action: addSamplesCourses)
                                Button(action: addCourse){
                                    Image(systemName: "plus.circle.fill")
                                }
                                if (!courses.isEmpty){
                                    EditButton()
                                }
                            }
                        }
                        .searchable(text: $searchTextCourse)
                }
                .tabItem {
                    Label("Courses", systemImage: "book")
                }
                
                //Thrid tab
                NavigationStack(path: $professorPath) {
                    ProfessorListView(sort: sortOrderProfessor, search: searchTextProfessor)
                        .navigationTitle("Professors")
                        .navigationDestination(for: Professor.self) { profe in
                            EditProfessorView(profe: profe)
                        }
                        .toolbar(){
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                //                            Button("Add sample", action: addSamplesCourses)
                                Button(action: addProfessor){
                                    Image(systemName: "plus.circle.fill")
                                }
                                if (!professors.isEmpty){
                                    EditButton()
                                }
                            }
                        }
                        .searchable(text: $searchTextProfessor)
                }
                .tabItem {
                    Label("Professors", systemImage: "person.3.fill")
                }
            }
        }
    func addExam(){
        let exam = Exam(name:"Click here to add a exam title")
        modelContext.insert(exam)
        examPath = [exam]
    }
    func addCourse(){
        let course = Course(name:"Click here to add a course name")
        modelContext.insert(course)
        coursePath = [course]
    }
    func addProfessor(){
        let profe = Professor(name: "Click here to add the professor name")
        modelContext.insert(profe)
        professorPath = [profe]
    }
    
    func addSamples(){
        let cbd = Exam(name: "Primer parcial", course: Course(name: "CBD", details: "String"))
        let ispp = Exam(name: "Presentación", course: Course(name: "ISPP", details: "Detail"))
        let dp = Exam(name: "Examen final", course: Course(name: "DP1", details: "Thst"))
        
        modelContext.insert(cbd)
        modelContext.insert(ispp)
        modelContext.insert(dp)
    }
    func addSamplesCourses(){
        let cbd = Course(name: "CBD", details: "String")
        let ispp = Course(name: "ISPP", details: "Detail")
        let dp = Course(name: "DP1", details: "Thst")
        
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
