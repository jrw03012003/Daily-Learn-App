//
//  EisenhowerMatrixView.swift
//  test 2 app
//
//  Created by Jack white on 17/11/2024.
//

import SwiftUI

struct EisenhowerMatrixView: View {
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.appBackgroundColor) var appBackgroundColor
    @State private var showInfoAlert = false // State variable for the alert
    @State private var tasks: [Quadrant: [TaskItem]] = [
        .doFirst: [],
        .schedule: [],
        .delegate: [],
        .eliminate: []
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Header with Title and Info Button
                ZStack {
                    // Centered Title
                    Text("Eisenhower Matrix")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    // Info Button aligned to the right
                    HStack {
                        Spacer()
                        Button(action: {
                            showInfoAlert = true
                        }) {
                            Image(systemName: "info.circle")
                                .font(.title2)
                        }
                        .padding()
                    }
                }

                // The rest of your content
                ZStack {
                    appBackgroundColor.edgesIgnoringSafeArea(.all)

                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            // Top Scale Titles
                            HStack(spacing: 0) {
                                Spacer().frame(width: geometry.size.width * 0.1) // Adjust spacer width as needed
                                Text("Important")
                                    .font(preferencesFont(size: 18))
                                    .frame(maxWidth: .infinity)
                                Text("Not Important")
                                    .font(preferencesFont(size: 18))
                                    .frame(maxWidth: .infinity)
                            }

                            HStack(spacing: 0) {
                                // Left Side Labels with Rotation
                                VStack(spacing: 0) {
                                    Text("Urgent")
                                        .font(preferencesFont(size: 18))
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: geometry.size.height * 0.2) // Ensure enough width for rotated text
                                        .fixedSize() // Prevent text wrapping
                                    Spacer()
                                        .frame(maxHeight: 300) // Limits the spacer to a maximum of 300 points
                                    Text("Not Urgent")
                                        .font(preferencesFont(size: 18))
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: geometry.size.height * 0.2) // Ensure enough width for rotated text
                                        .fixedSize() // Prevent text wrapping
                                }
                                .frame(width: geometry.size.width * 0.1)

                                // Matrix Grid
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        QuadrantView(
                                            quadrant: .doFirst,
                                            tasks: bindingForQuadrant(.doFirst)
                                        )
                                        QuadrantView(
                                            quadrant: .schedule,
                                            tasks: bindingForQuadrant(.schedule)
                                        )
                                    }
                                    HStack(spacing: 0) {
                                        QuadrantView(
                                            quadrant: .delegate,
                                            tasks: bindingForQuadrant(.delegate)
                                        )
                                        QuadrantView(
                                            quadrant: .eliminate,
                                            tasks: bindingForQuadrant(.eliminate)
                                        )
                                    }
                                }
                                .frame(width: geometry.size.width * 0.9)
                            }
                        }
                    }
                    .alert(isPresented: $showInfoAlert) {
                        Alert(
                            title: Text("About Eisenhower Matrix"),
                            message: Text("""
                            The Eisenhower Matrix is a task & time management tool that helps you prioritise tasks by urgency and importance.

                            Use the '+' buttons in each quadrant to add tasks, and manage them directly within the matrix. To delete tasks simply swipe right to left (Tasks will not be automatically deleted)
                            """),
                            dismissButton: .default(Text("Got it!"))
                        )
                    }
                }
            }
            .background(appBackgroundColor)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // To ensure consistent behavior across devices
    }
    
    // Helper function to get preferred font
    private func preferencesFont(size: CGFloat) -> Font {
        preferences.useOpenDyslexicFont
            ? .custom("OpenDyslexic3-Regular", size: size)
            : .system(size: size)
    }

    // Computed Binding Function
    private func bindingForQuadrant(_ quadrant: Quadrant) -> Binding<[TaskItem]> {
        Binding(
            get: { tasks[quadrant, default: []] },
            set: { tasks[quadrant] = $0 }
        )
    }
}

struct QuadrantView: View {
    let quadrant: Quadrant
    @Binding var tasks: [TaskItem]
    @EnvironmentObject var preferences: PreferencesManager
    @Environment(\.appBackgroundColor) var appBackgroundColor

    var body: some View {
        VStack(alignment: .leading) {
            // Quadrant Header with Plus Button
            HStack {
                Text(quadrant.title)
                    .font(preferencesFont(size: 18))
                Spacer()
                Button(action: addTask) {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                }
            }
            .padding([.leading, .trailing, .top])

            Divider()

            // Task List or Placeholder
            if tasks.isEmpty {
                Text(quadrant.description)
                    .font(preferencesFont(size: 16))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach($tasks) { $task in
                        TaskRow(task: $task)
                    }
                    .onMove(perform: moveTask)
                    .onDelete(perform: deleteTask)
                }
                .listStyle(PlainListStyle())
                .background(appBackgroundColor)
            }
        }
        .padding(5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appBackgroundColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .onChange(of: tasks) { _ in
            sortTasks()
        }
    }

    // Helper function to get preferred font
    private func preferencesFont(size: CGFloat) -> Font {
        preferences.useOpenDyslexicFont
            ? .custom("OpenDyslexic3-Regular", size: size)
            : .system(size: size)
    }

    // Functions for adding, moving, deleting, and sorting tasks
    func addTask() {
        tasks.insert(TaskItem(), at: 0)
        sortTasks()
    }

    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        sortTasks()
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    func sortTasks() {
        tasks.sort { !$0.isCompleted && $1.isCompleted }
    }
}

struct TaskRow: View {
    @Binding var task: TaskItem
    @EnvironmentObject var preferences: PreferencesManager

    var body: some View {
        HStack {
            // Completion Button
            Button(action: toggleCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }

            // Task Description
            TextField("New Task", text: $task.description)
                .font(preferencesFont(size: 16))
                .overlay(
                    task.isCompleted
                        ? Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .offset(y: 0)
                        : nil
                )
                .foregroundColor(task.isCompleted ? .gray : .primary)
        }
    }

    // Helper function to get preferred font
    private func preferencesFont(size: CGFloat) -> Font {
        preferences.useOpenDyslexicFont
            ? .custom("OpenDyslexic3-Regular", size: size)
            : .system(size: size)
    }

    func toggleCompletion() {
        task.isCompleted.toggle()
    }
}
