//
//  TaskListView.swift
//  MyApp
//
//  Created by Kacper Zajkowski on 02/01/2026.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false
    @State private var selectedTask: Task?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Statistics Header
                HStack(spacing: 20) {
                    StatisticCard(
                        title: "Total",
                        count: viewModel.tasks.count,
                        color: .blue
                    )
                    StatisticCard(
                        title: "Active",
                        count: viewModel.activeTasksCount,
                        color: .orange
                    )
                    StatisticCard(
                        title: "Completed",
                        count: viewModel.completedTasksCount,
                        color: .green
                    )
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                
                // Filter Picker
                Picker("Filter", selection: $viewModel.filterOption) {
                    ForEach(TaskViewModel.FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Task List
                if viewModel.filteredTasks.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(viewModel.filteredTasks) { task in
                            TaskRowView(task: task) {
                                viewModel.toggleTaskCompletion(task)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                selectedTask = task
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                if viewModel.completedTasksCount > 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.deleteCompletedTasks()
                        } label: {
                            Text("Clear Completed")
                                .font(.caption)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(viewModel: viewModel)
            }
            .sheet(item: $selectedTask) { task in
                TaskDetailView(task: task, viewModel: viewModel)
            }
        }
    }
}

struct StatisticCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No tasks yet")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Tap the + button to add your first task")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    TaskListView()
}
