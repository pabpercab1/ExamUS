//
//  EditExamView.swift
//  ExamUS
//
//  Created by Pablo Periañez Cabrero on 27/3/24.
//

import SwiftUI
import SwiftData

struct EditExamView: View {
    @Bindable var exam: Exam
    
    @Query(sort: [SortDescriptor(\Course.name)]) var courses: [Course]
    
    @State private var newTopic = ""
    @State private var newTopicDescription = ""
    @State private var selectedTopicToDelete: Topic?
    
    
    var body: some View {
        Form{
            Section("Basic info") {
                TextField("Details", text: $exam.details, axis: .vertical)
                DatePicker("Date", selection: $exam.date)
            }
            
            Section("Session & Course") {
                Picker("Session", selection: $exam.session){
                    Text("Parcial").tag(1)
                    Text("Final").tag(2)
                    Text("Convocatoria ordinaria").tag(3)
                    Text("Convocatoria extraordinaria").tag(4)
                }
                .pickerStyle(.menu)
                if courses == []{
                    HStack{
                        Text("Course")
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                        Text("Create first a course in the other tab")
                            .foregroundColor(.red)
                    }
                        
                } else {
                    Picker("Course", selection: $exam.course) {
                        if exam.course == nil{ Text("Select a course")}
                        ForEach(courses) { course in
                            Text(course.name).tag(course as Course?)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            Section("\(exam.topics.count) Topics"){
                    EditButton()
                ForEach(exam.topics.sorted(by: { $0.number < $1.number })) { topic in
                    VStack{
                        HStack {
                            if (topic.check){
                                Button(){
                                    topic.check = false
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            } else {
                                Button(){
                                    topic.check = true
                                } label: {
                                    Image(systemName: "circle")
                                }
                            }
                            Text(topic.name)
                        }
                    }
                }
                .onDelete(perform: deleteTopicQuick)
                .onMove { sourceIndices, destinationIndex in
                    guard destinationIndex < exam.topics.count else { return }
                    guard let sourceIndex = sourceIndices.first else { return }
                    guard sourceIndex != destinationIndex else { return }
                    var updatedTopics = exam.topics
                    let movedTopic = updatedTopics.remove(at: sourceIndex)

                    if destinationIndex < sourceIndex {
                        updatedTopics.insert(movedTopic, at: destinationIndex)
                    } else {
                        updatedTopics.insert(movedTopic, at: destinationIndex - 1)
                    }
                    for (index, _) in updatedTopics.enumerated() {
                        updatedTopics[index].number = index
                    }
                    exam.topics = updatedTopics
                }
                VStack{
                    HStack{
                        TextField("Add topic in \(exam.name)", text: $newTopic)
                            .onSubmit {
                                addTopic()
                            }
                        Button(action: addTopic) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .alert(item: $selectedTopicToDelete) { topic in
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this topic?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Delete")) {
                        deleteTopic(topic)
                    }
                )
            }
        }
        .navigationTitle($exam.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    func addTopic() {
        guard !newTopic.isEmpty else { return }
        
        withAnimation {
            let topic = Topic(name: newTopic, number: exam.topics.count, details: newTopicDescription)
            exam.topics.append(topic)
            newTopic = ""
            newTopicDescription = ""
        }
    }
    private func showAlert(for topic: Topic) {
        selectedTopicToDelete = topic
    }
    private func deleteTopic(_ topic: Topic) {
        withAnimation {
            if let index = exam.topics.firstIndex(where: { $0.id == topic.id }) {
                exam.topics.remove(at: index)
            }
        }
    }
    func deleteTopicQuick(_ indexSet: IndexSet){
        exam.topics.remove(atOffsets: indexSet)
    }
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Exam.self, configurations: config)
        let example = Exam(name: "Example", details: "Detail example", course: Course(name: "Example", details: "Example"))
        
        return EditExamView(exam: example)
            .modelContainer(container)
    } catch {
        fatalError("Fail to create model container")
    }
}

