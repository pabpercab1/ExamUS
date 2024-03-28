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
    @State private var newTopic = ""
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
                TextField("Course", text: $exam.course)
            }
            Section("Topics"){
                ForEach(exam.topics) { topic in
                    HStack {
                        Text(topic.name)
                        Spacer()
                        Button(action: {showAlert(for: topic)}) {
                            Image(systemName: "trash.circle")
                                .accentColor(.red)
                        }
                    }
                }
                HStack{
                    TextField("Add topic in \(exam.name)", text: $newTopic)
                    Button(action: addTopic) {
                            Image(systemName: "plus")
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
    func addTopic(){
        guard newTopic.isEmpty == false else { return }
        
        withAnimation {
            let topic = Topic(name: newTopic, details: "")
            exam.topics.append(topic)
            newTopic = ""
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
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Exam.self, configurations: config)
        let example = Exam(name: "Example", details: "Detail example", course: "CBD")
        return EditExamView(exam: example)
            .modelContainer(container)
    } catch {
        fatalError("Fail to create model container")
    }
}
