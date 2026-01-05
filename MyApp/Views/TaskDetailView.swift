//
//  TaskDetailView.swift
//  MyApp
//
//  Created by Kacper Zajkowski on 05/01/2026.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel
    
    let task: Task
    
    @State private var title: String
    @State private var description: String
    @State private var selectedPriority: Priority
    @State private var dueDate: Date?
    @State private var hasDueDate: Bool
    @State private var isEditing = false
    
    init(task: Task, viewModel: TaskViewModel) {
        self.task = task
        self.viewModel = viewModel
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _selectedPriority = State(initialValue: task.priority)
        _dueDate = State(initialValue: task.dueDate)
        _hasDueDate = State(initialValue: task.dueDate != nil)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                if isEditing {
                    Section("Task Details") {
                        TextField("Title", text: $title)
                        TextField("Description", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                    }
                    
                    Section("Priority") {
                        Picker("Priority", selection: $selectedPriority) {
                            ForEach(Priority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("Due Date") {
                        Toggle("Set due date", isOn: $hasDueDate)
                        
                        if hasDueDate {
                            DatePicker(
                                "Due Date",
                                selection: Binding(
                                    get: { dueDate ?? Date() },
                                    set: { dueDate = $0 }
                                ),
                                displayedComponents: [.date]
                            )
                        }
                    }
                } else {
                    Section("Task") {
                        HStack {
                            Text("Title")
                            Spacer()
                            Text(task.title)
                                .foregroundColor(.secondary)
                        }
                        
                        if !task.description.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Description")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(task.description)
                            }
                        }
                    }
                    
                    Section("Details") {
                        HStack {
                            Text("Priority")
                            Spacer()
                            PriorityBadge(priority: task.priority)
                        }
                        
                        HStack {
                            Text("Status")
                            Spacer()
                            Text(task.isCompleted ? "Completed" : "Active")
                                .foregroundColor(task.isCompleted ? .green : .orange)
                        }
                        
                        if let dueDate = task.dueDate {
                            HStack {
                                Text("Due Date")
                                Spacer()
                                Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(dueDate < Date() && !task.isCompleted ? .red : .secondary)
                            }
                        }
                        
                        HStack {
                            Text("Created")
                            Spacer()
                            Text(task.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.deleteTask(task)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Delete Task", systemImage: "trash")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Task" : "Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if isEditing {
                        Button("Cancel") {
                            isEditing = false
                            resetFields()
                        }
                    } else {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isEditing {
                        Button("Save") {
                            saveChanges()
                            isEditing = false
                        }
                        .disabled(title.isEmpty)
                    } else {
                        Button("Edit") {
                            isEditing = true
                        }
                    }
                }
            }
        }
    }
    
    private func resetFields() {
        title = task.title
        description = task.description
        selectedPriority = task.priority
        dueDate = task.dueDate
        hasDueDate = task.dueDate != nil
    }
    
    private func saveChanges() {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.description = description
        updatedTask.priority = selectedPriority
        updatedTask.dueDate = hasDueDate ? dueDate : nil
        viewModel.updateTask(updatedTask)
    }
}

#Preview {
    TaskDetailView(
        task: Task(
            title: "Sample Task",
            description: "This is a sample task description",
            priority: .high,
            dueDate: Date()
        ),
        viewModel: TaskViewModel()
    )
}
