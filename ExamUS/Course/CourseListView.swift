//
//  CourseListView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 28/3/24.
//

import SwiftUI
import SwiftData

struct CourseListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Course.year), SortDescriptor(\Course.name)]) var courses: [Course]
    
    @State private var details: Course?
    @State private var showingAlertCourse = false

    var body: some View {
        List {
            if (courses.isEmpty){
                ContentUnavailableView{
                    Image(systemName: "book")
                        .font(.largeTitle)
                } description: {
                    Text("There is not courses to show. Create the course first, to then add an exam.")
                }
            } else {
                ForEach(courses) { course in
                    NavigationLink(value: course) {
                        HStack{
                            VStack(alignment: .leading) {
                                Text(course.name)
                                    .font(.headline)
                                Text(course.year.formatted().replacingOccurrences(of: ".", with: ""))
                                //Text(course.professor)
                            }
                            Spacer()
                            Image(systemName: "circle.fill")
                                .foregroundStyle(convertColor(color: course.color))
                        }
                    }
                }
                .onDelete(perform: deleteCourses)
            }
        }
                .alert(isPresented: $showingAlertCourse) {
                    buildAlert()
                }
    }
    init(sort: SortDescriptor<Course>, search: String){

        _courses = Query(filter: #Predicate {
            if search.isEmpty{
               return true
            } else {
                return $0.name.localizedStandardContains(search)
            }
        }, sort: [sort])
    }
    
    func deleteCourses(_ indexSet: IndexSet){
        for index in indexSet {
            let course = courses[index]
            if course.exams.count >= 1{
                details = course
                showingAlertCourse = true
            } else {
                modelContext.delete(course)
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
    
    func buildAlert() -> Alert {
        if let course = details {
            return Alert(
                title: Text("Confirm Deletion of \(course.name)"),
                message: Text("This will also delete \(course.exams.count) exams linked to it")
                    ,
                primaryButton: .destructive(Text("Delete")) {
                    modelContext.delete(course)
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    showingAlertCourse = false
                }
            )
        } else {
            return Alert(title: Text("Error"), message: Text("Course details not found"), dismissButton: .cancel())
        }
    }
}

#Preview {
    CourseListView(sort: SortDescriptor(\Course.year), search: "")
}
