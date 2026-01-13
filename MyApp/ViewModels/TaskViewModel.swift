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
        let filtered: [Task]
        switch filterOption {
        case .all:
            filtered = tasks
        case .active:
            filtered = tasks.filter { !$0.isCompleted }
        case .completed:
            filtered = tasks.filter { $0.isCompleted }
        }
        // Sort by priority (high first) and then by creation date (newest first)
        return filtered.sorted { task1, task2 in
            if task1.priority != task2.priority {
                return task1.priority == .high || 
                       (task1.priority == .medium && task2.priority == .low)
            }
            return task1.createdAt > task2.createdAt
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
