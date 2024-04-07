//
//  Task.swift
//

import UIKit
let defaults = UserDefaults.standard
// The Task model
struct Task : Codable{

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {

    // UserDefaults key for storing tasks
        private static let tasksKey = "SavedTasks"
    
    
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {

        // TODO: Save the array of tasks
        do {
                    let encoder = JSONEncoder()
                    let encodedTasks = try encoder.encode(tasks)
                    defaults.set(encodedTasks, forKey: tasksKey)
                } catch {
                    print("Error encoding tasks: \(error)")
                }
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults
        guard let encodedTasks = defaults.data(forKey: tasksKey) else {
                    return []
                }
                do {
                    let decoder = JSONDecoder()
                    let tasks = try decoder.decode([Task].self, from: encodedTasks)

                    return tasks
                } catch {
                    print("Error decoding tasks: \(error)")
                    return []
                }
    }

    // Add a new task or update an existing task with the current task.
    func save() {
        var tasks = Task.getTasks()
//        for task in tasks{
//            print("id of task list: ", task.id)
//        }
        print("id of current task to update: ", self.id)
        if let existingIndex = tasks.firstIndex(where: { $0.id == self.id }) {
            print("found id: ", tasks[existingIndex].id, "vs ", self.id)
            tasks.remove(at: existingIndex)

        }
        // Append the updated task to the end of the array
        print("didn't found")
        tasks.append(self)
        Task.save(tasks)
    }
}
