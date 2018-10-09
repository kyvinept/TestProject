//
//  CoreData.swift
//  TestProject
//
//  Created by Silchenko on 08.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import CoreData
import UIKit

class DBManager {
    
    private enum Entity: String {
        case Task
        case Note
    }
    
    private let queue = DispatchQueue(label: "com.concurrent.DBManager")
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
        queue.async {
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("error save data")
                }
            }
        }
    }
    
    func addTask(withModel task: TaskModel) {
        queue.async {
            let entity = NSEntityDescription.entity(forEntityName: Entity.Task.rawValue, in: self.persistentContainer.viewContext)
            let newTask = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! Task
            newTask.id = Int32(task.id!)
            newTask.name = task.name
            newTask.completed = task.completed
            self.saveContext()
        }
    }
    
    func addNote(withModel note: NoteModel, toTask task: TaskModel) {
        queue.async {
            let entity = NSEntityDescription.entity(forEntityName: Entity.Note.rawValue, in: self.persistentContainer.viewContext)
            let newNote = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! Note
            newNote.id = Int32(note.id!)
            newNote.text = note.text
            newNote.completed = note.completed
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.Task.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var tasks = [Task]()
            do {
                tasks = try context.fetch(fetchRequest) as! [Task]
                let filterTask = tasks.first { Int($0.id) == task.id }
                newNote.task = filterTask
            } catch {
                print("Failed")
            }
            self.saveContext()
        }
    }
    
    func loadData(successBlock: @escaping ([TaskModel]) -> ()) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.Task.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var task = [Task]()
            do {
                task = try context.fetch(fetchRequest) as! [Task]
                let createTasks = self.createNewTaskModel(tasks: task)
                successBlock(createTasks)
            } catch {
                print("Failed")
            }
        }
    }
    
    private func createNewTaskModel(tasks: [Task]) -> [TaskModel] {
        var taskModel = [TaskModel]()
        for task in tasks {
            let newTask = TaskModel()
            newTask.id = Int(task.id)
            newTask.name = task.name
            newTask.completed = task.completed
            newTask.notes = createNewNoteModel(notes: Array(task.notes!) as! [Note], task: newTask)
            taskModel.append(newTask)
        }
        return taskModel
    }
    
    private func createNewNoteModel(notes: [Note], task: TaskModel) -> [NoteModel] {
        var noteModel = [NoteModel]()
        for note in notes {
            let newNote = NoteModel()
            newNote.id = Int(note.id)
            newNote.text = note.text
            newNote.completed = note.completed
            newNote.task = task
            noteModel.append(newNote)
        }
        return noteModel
    }
    
    func deleteTask(task: TaskModel) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.Task.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var tasks = [Task]()
            do {
                tasks = try context.fetch(fetchRequest) as! [Task]
                for object in tasks {
                    if Int(object.id) == task.id {
                        self.persistentContainer.viewContext.delete(object)
                        break;
                    }
                }
                self.saveContext()
            } catch {
                print("Failed")
            }
        }
    }
    
    func updateNoteValue(_ note: NoteModel, fromTask task: TaskModel) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.Task.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var tasks = [Task]()
            do {
                tasks = try context.fetch(fetchRequest) as! [Task]
                for object in tasks {
                    if Int(object.id) == task.id {
                        for currentNote in Array(object.notes!) as! [Note] {
                            if Int(currentNote.id) == note.id {
                                currentNote.completed = note.completed
                                self.saveContext()
                                return
                            }
                        }
                    }
                }
            } catch {
                print("Failed")
            }
        }
    }
    
    func updateTaskValue(_ task: TaskModel) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.Task.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var tasks = [Task]()
            do {
                tasks = try context.fetch(fetchRequest) as! [Task]
                tasks.first { Int($0.id) == task.id }?.completed = task.completed
                self.saveContext()
            } catch {
                print("Failed")
            }
        }
    }
    
    func deleteNote(_ note: NoteModel, fromTask task: TaskModel) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.Task.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var tasks = [Task]()
            do {
                tasks = try context.fetch(fetchRequest) as! [Task]
                for object in tasks {
                    if Int(object.id) == task.id {
                        for currentNote in Array(object.notes!) as! [Note] {
                            if Int(currentNote.id) == note.id {
                                self.persistentContainer.viewContext.delete(currentNote)
                                break;
                            }
                        }
                    }
                }
                self.saveContext()
            } catch {
                print("Failed")
            }
        }
    }
}
