//
//  TaskRowView.swift
//  MyApp
//
//  Created by Kacper Zajkowski on 02/01/2026.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 8) {
                    PriorityBadge(priority: task.priority)
                    
                    if let dueDate = task.dueDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                        }
                        .foregroundColor(dueDate < Date() && !task.isCompleted ? .red : .secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            (dueDate < Date() && !task.isCompleted ? Color.red : Color.gray)
                                .opacity(0.1)
                        )
                        .cornerRadius(6)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct PriorityBadge: View {
    let priority: Priority
    
    var body: some View {
        Text(priority.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(priority.color).opacity(0.2))
            .foregroundColor(Color(priority.color))
            .cornerRadius(8)
    }
}

#Preview {
    List {
        TaskRowView(
            task: Task(
                title: "Sample Task",
                description: "This is a sample description",
                priority: .high,
                dueDate: Date()
            ),
            onToggle: {}
        )
    }
}
