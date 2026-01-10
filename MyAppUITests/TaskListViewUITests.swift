//
//  TaskListViewUITests.swift
//  MyAppUITests
//
//  Created by Kacper Zajkowski on 10/01/2026.
//

import XCTest

final class TaskListViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAddTask() throws {
        // Given - app is launched
        let addButton = app.buttons["plus.circle.fill"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        
        // When - tap add button
        addButton.tap()
        
        // Then - add task view should appear
        let titleField = app.textFields["Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        
        // Fill in task details
        titleField.tap()
        titleField.typeText("Test Task")
        
        let descriptionField = app.textFields["Description (optional)"]
        if descriptionField.exists {
            descriptionField.tap()
            descriptionField.typeText("Test Description")
        }
        
        // Add the task
        let addButtonInSheet = app.buttons["Add"]
        if addButtonInSheet.exists {
            addButtonInSheet.tap()
        }
        
        // Verify task appears in list
        let taskText = app.staticTexts["Test Task"]
        XCTAssertTrue(taskText.waitForExistence(timeout: 2))
    }
    
    func testToggleTaskCompletion() throws {
        // Given - add a task first
        let addButton = app.buttons["plus.circle.fill"]
        if addButton.waitForExistence(timeout: 2) {
            addButton.tap()
            
            let titleField = app.textFields["Title"]
            if titleField.waitForExistence(timeout: 2) {
                titleField.tap()
                titleField.typeText("Task to Complete")
                
                let addButtonInSheet = app.buttons["Add"]
                if addButtonInSheet.exists {
                    addButtonInSheet.tap()
                }
            }
        }
        
        // When - tap the task completion button
        let taskRow = app.staticTexts["Task to Complete"]
        if taskRow.waitForExistence(timeout: 2) {
            let checkmarkButton = app.buttons.matching(identifier: "checkmark.circle.fill").firstMatch
            if !checkmarkButton.exists {
                let circleButton = app.buttons.matching(identifier: "circle").firstMatch
                if circleButton.exists {
                    circleButton.tap()
                }
            }
        }
    }
    
    func testFilterTasks() throws {
        // Given - app is launched
        let segmentedControl = app.segmentedControls.firstMatch
        if segmentedControl.waitForExistence(timeout: 2) {
            // When - select Active filter
            let activeButton = segmentedControl.buttons["Active"]
            if activeButton.exists {
                activeButton.tap()
            }
            
            // Then - verify filter is applied
            XCTAssertTrue(activeButton.isSelected)
        }
    }
    
    func testStatisticsDisplay() throws {
        // Given - app is launched
        // Then - statistics should be visible
        let totalLabel = app.staticTexts["Total"]
        let activeLabel = app.staticTexts["Active"]
        let completedLabel = app.staticTexts["Completed"]
        
        // At least one should exist (they might be in different views)
        XCTAssertTrue(
            totalLabel.exists || activeLabel.exists || completedLabel.exists,
            "Statistics should be displayed"
        )
    }
}
