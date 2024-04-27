//
//  ProfessorListView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 15/4/24.
//

import SwiftUI
import SwiftData

struct ProfessorListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Professor.name), SortDescriptor(\Professor.email)]) var professors: [Professor]
    
    @State private var details: Professor?
    @State private var showingAlertCourse = false

    var body: some View {
        List {
            if (professors.isEmpty){
                ContentUnavailableView{
                    Image(systemName: "person.3")
                        .font(.largeTitle)
                } description: {
                    Text("There is not professors to show. You can create a new one in this window.")
                }
            } else {
                ForEach(professors) { profe in
                    NavigationLink(value: profe) {
                        HStack{
                            VStack(alignment: .leading) {
                                Text(profe.name)
                                    .font(.headline)
                                Text(profe.email)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteProfessors)
            }
        }
    }
    init(sort: SortDescriptor<Professor>, search: String){

        _professors = Query(filter: #Predicate {
            if search.isEmpty{
               return true
            } else {
                return $0.name.localizedStandardContains(search)
            }
        }, sort: [sort])
    }
    
    func deleteProfessors(_ indexSet: IndexSet){
        for index in indexSet {
            let profe = professors[index]
            modelContext.delete(profe)
        }
    }
}


#Preview {
    CourseListView(sort: SortDescriptor(\Course.year), search: "")
}
