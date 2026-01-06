//
//  TaskViewModelTests.swift
//  MyAppTests
//
//  Created by Kacper Zajkowski on 06/01/2026.
//

import XCTest
@testable import MyApp

@MainActor
final class TaskViewModelTests: XCTestCase {
    var viewModel: TaskViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = TaskViewModel()
        // Clear tasks for clean test state
        viewModel.tasks = []
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddTask() {
        // Given
        let initialCount = viewModel.tasks.count
        
        // When
        viewModel.addTask(
            title: "Test Task",
            description: "Test Description",
            priority: .high,
            dueDate: nil
        )
        
        // Then
        XCTAssertEqual(viewModel.tasks.count, initialCount + 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Test Task")
        XCTAssertEqual(viewModel.tasks.first?.description, "Test Description")
        XCTAssertEqual(viewModel.tasks.first?.priority, .high)
        XCTAssertFalse(viewModel.tasks.first?.isCompleted ?? true)
    }
    
    func testToggleTaskCompletion() {
        // Given
        viewModel.addTask(title: "Test Task", description: "", priority: .medium, dueDate: nil)
        let task = viewModel.tasks.first!
        XCTAssertFalse(task.isCompleted)
        
        // When
        viewModel.toggleTaskCompletion(task)
        
        // Then
        XCTAssertTrue(viewModel.tasks.first?.isCompleted ?? false)
        
        // When - toggle again
        viewModel.toggleTaskCompletion(viewModel.tasks.first!)
        
        // Then
        XCTAssertFalse(viewModel.tasks.first?.isCompleted ?? true)
    }
    
    func testDeleteTask() {
        // Given
        viewModel.addTask(title: "Task 1", description: "", priority: .low, dueDate: nil)
        viewModel.addTask(title: "Task 2", description: "", priority: .medium, dueDate: nil)
        let initialCount = viewModel.tasks.count
        let taskToDelete = viewModel.tasks.first!
        
        // When
        viewModel.deleteTask(taskToDelete)
        
        // Then
        XCTAssertEqual(viewModel.tasks.count, initialCount - 1)
        XCTAssertFalse(viewModel.tasks.contains(where: { $0.id == taskToDelete.id }))
    }
    
    func testFilterAllTasks() {
        // Given
        viewModel.addTask(title: "Task 1", description: "", priority: .low, dueDate: nil)
        viewModel.addTask(title: "Task 2", description: "", priority: .medium, dueDate: nil)
        viewModel.toggleTaskCompletion(viewModel.tasks.first!)
        
        // When
        viewModel.filterOption = .all
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks.count, 2)
    }
    
    func testFilterActiveTasks() {
        // Given
        viewModel.addTask(title: "Task 1", description: "", priority: .low, dueDate: nil)
        viewModel.addTask(title: "Task 2", description: "", priority: .medium, dueDate: nil)
        viewModel.toggleTaskCompletion(viewModel.tasks.first!)
        
        // When
        viewModel.filterOption = .active
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks.count, 1)
        XCTAssertFalse(viewModel.filteredTasks.first?.isCompleted ?? true)
    }
    
    func testFilterCompletedTasks() {
        // Given
        viewModel.addTask(title: "Task 1", description: "", priority: .low, dueDate: nil)
        viewModel.addTask(title: "Task 2", description: "", priority: .medium, dueDate: nil)
        viewModel.toggleTaskCompletion(viewModel.tasks.first!)
        
        // When
        viewModel.filterOption = .completed
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks.count, 1)
        XCTAssertTrue(viewModel.filteredTasks.first?.isCompleted ?? false)
    }
    
    func testDeleteCompletedTasks() {
        // Given
        viewModel.addTask(title: "Task 1", description: "", priority: .low, dueDate: nil)
        viewModel.addTask(title: "Task 2", description: "", priority: .medium, dueDate: nil)
        viewModel.addTask(title: "Task 3", description: "", priority: .high, dueDate: nil)
        viewModel.toggleTaskCompletion(viewModel.tasks[0])
        viewModel.toggleTaskCompletion(viewModel.tasks[1])
        let initialCount = viewModel.tasks.count
        
        // When
        viewModel.deleteCompletedTasks()
        
        // Then
        XCTAssertEqual(viewModel.tasks.count, initialCount - 2)
        XCTAssertTrue(viewModel.tasks.allSatisfy { !$0.isCompleted })
    }
    
    func testTaskCounts() {
        // Given
        viewModel.addTask(title: "Task 1", description: "", priority: .low, dueDate: nil)
        viewModel.addTask(title: "Task 2", description: "", priority: .medium, dueDate: nil)
        viewModel.addTask(title: "Task 3", description: "", priority: .high, dueDate: nil)
        viewModel.toggleTaskCompletion(viewModel.tasks[0])
        
        // Then
        XCTAssertEqual(viewModel.tasks.count, 3)
        XCTAssertEqual(viewModel.completedTasksCount, 1)
        XCTAssertEqual(viewModel.activeTasksCount, 2)
    }
    
    func testUpdateTask() {
        // Given
        viewModel.addTask(title: "Original Title", description: "Original", priority: .low, dueDate: nil)
        var task = viewModel.tasks.first!
        task.title = "Updated Title"
        task.description = "Updated"
        task.priority = .high
        
        // When
        viewModel.updateTask(task)
        
        // Then
        XCTAssertEqual(viewModel.tasks.first?.title, "Updated Title")
        XCTAssertEqual(viewModel.tasks.first?.description, "Updated")
        XCTAssertEqual(viewModel.tasks.first?.priority, .high)
    }
}
