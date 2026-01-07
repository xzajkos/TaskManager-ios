//
//  TaskModelTests.swift
//  MyAppTests
//
//  Created by Kacper Zajkowski on 07/01/2026.
//

import XCTest
@testable import MyApp

final class TaskModelTests: XCTestCase {
    
    func testTaskInitialization() {
        // When
        let task = Task(
            title: "Test Task",
            description: "Test Description",
            isCompleted: false,
            priority: .high
        )
        
        // Then
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.description, "Test Description")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.priority, .high)
        XCTAssertNotNil(task.id)
        XCTAssertNotNil(task.createdAt)
    }
    
    func testTaskDefaultValues() {
        // When
        let task = Task(title: "Simple Task")
        
        // Then
        XCTAssertEqual(task.title, "Simple Task")
        XCTAssertEqual(task.description, "")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.priority, .medium)
        XCTAssertNil(task.dueDate)
    }
    
    func testTaskEquality() {
        // Given
        let id = UUID()
        let date = Date()
        let task1 = Task(
            id: id,
            title: "Task",
            description: "Description",
            isCompleted: false,
            priority: .high,
            dueDate: date,
            createdAt: date
        )
        let task2 = Task(
            id: id,
            title: "Task",
            description: "Description",
            isCompleted: false,
            priority: .high,
            dueDate: date,
            createdAt: date
        )
        
        // Then
        XCTAssertEqual(task1, task2)
    }
    
    func testTaskInequality() {
        // Given
        let task1 = Task(title: "Task 1")
        let task2 = Task(title: "Task 2")
        
        // Then
        XCTAssertNotEqual(task1, task2)
    }
    
    func testPriorityCases() {
        // Then
        XCTAssertEqual(Priority.low.rawValue, "Low")
        XCTAssertEqual(Priority.medium.rawValue, "Medium")
        XCTAssertEqual(Priority.high.rawValue, "High")
    }
    
    func testPriorityColors() {
        // Then
        XCTAssertEqual(Priority.low.color, "green")
        XCTAssertEqual(Priority.medium.color, "orange")
        XCTAssertEqual(Priority.high.color, "red")
    }
    
    func testTaskCodable() throws {
        // Given
        let task = Task(
            title: "Test Task",
            description: "Test Description",
            isCompleted: true,
            priority: .high,
            dueDate: Date()
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(task)
        
        let decoder = JSONDecoder()
        let decodedTask = try decoder.decode(Task.self, from: data)
        
        // Then
        XCTAssertEqual(task.id, decodedTask.id)
        XCTAssertEqual(task.title, decodedTask.title)
        XCTAssertEqual(task.description, decodedTask.description)
        XCTAssertEqual(task.isCompleted, decodedTask.isCompleted)
        XCTAssertEqual(task.priority, decodedTask.priority)
    }
}
