//
//  ExamListView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 28/3/24.
//

import SwiftUI
import SwiftData

struct ExamListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Exam.date),
                  SortDescriptor(\Exam.course)]) var exams: [Exam]
    
    var body: some View {
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
    }
    init(sort: SortDescriptor<Exam>, search: String){

        _exams = Query(filter: #Predicate {
            if search.isEmpty{
               return true
            } else {
                return $0.name.localizedStandardContains(search)
            }
        }, sort: [sort])
    }
    
    func deleteExams(_ indexSet: IndexSet){
        for index in indexSet {
            let exam = exams[index]
            modelContext.delete(exam)
        }
    }
}

#Preview {
    ExamListView(sort: SortDescriptor(\Exam.date), search: "")
}
