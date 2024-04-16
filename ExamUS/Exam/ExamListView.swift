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
                  SortDescriptor(\Exam.course?.name)]) var exams: [Exam]
    
    var body: some View {
        List {
            if (exams.isEmpty){
                ContentUnavailableView{
                    Image(systemName: "book.pages")
                        .font(.largeTitle)
                } description: {
                    Text("There is not exams to show. Make sure that you have created a course first.")
                }
            } else {
                ForEach(exams) {exam in
                    NavigationLink(value: exam) {
                        VStack(alignment: .leading) {
                            Text(exam.name)
                                .font(.headline)
                            HStack{
                                Image(systemName: "circle")
                                    .foregroundStyle(convertColor(color: exam.course?.color ?? "black"))
                                Text(exam.course?.name ?? "No course assigned")
                                    .foregroundStyle(convertColor(color: exam.course?.color ?? "black"))
                            }
                            Text(exam.date.formatted(date: .long, time: .shortened))
                            Text("\(exam.topicsToReviewCount) topics to do & \(exam.reviewedTopicsCount) already done")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteExams)
            }
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
    ExamListView(sort: SortDescriptor(\Exam.date), search: "")
}

extension Exam {
    var topicsToReviewCount: Int {
        topics.filter { !$0.check }.count
    }

    var reviewedTopicsCount: Int {
        topics.filter { $0.check }.count
    }
}
