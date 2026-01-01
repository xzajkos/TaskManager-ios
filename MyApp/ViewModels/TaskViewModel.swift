//
//  TaskViewModel.swift
//  MyApp
//
//  Created by Kacper Zajkowski on 01/01/2026.
//

import Foundation
import SwiftUI

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var filterOption: FilterOption = .all
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
    }
    
    private let userDefaultsKey = "savedTasks"
    
    init() {
        loadTasks()
    }
    
    var filteredTasks: [Task] {
        switch filterOption {
        case .all:
            return tasks
        case .active:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter { $0.isCompleted }
        }
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var activeTasksCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    func addTask(title: String, description: String, priority: Priority, dueDate: Date?) {
        let newTask = Task(
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate
        )
        tasks.append(newTask)
        saveTasks()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    func deleteCompletedTasks() {
        tasks.removeAll { $0.isCompleted }
        saveTasks()
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}
