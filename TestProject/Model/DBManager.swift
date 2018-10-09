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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addTask(withModel task: TaskModel) {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext)
        let newTask = NSManagedObject(entity: entity!, insertInto: persistentContainer.viewContext) as! Task
        newTask.id = Int32(task.id!)
        newTask.name = task.name
        newTask.completed = task.completed
        saveContext()
    }
    
    func addNote(withModel note: NoteModel, toTask task: TaskModel) {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: persistentContainer.viewContext)
        let newNote = NSManagedObject(entity: entity!, insertInto: persistentContainer.viewContext) as! Note
        newNote.id = Int32(note.id!)
        newNote.text = note.text
        newNote.completed = note.completed
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
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
        saveContext()
    }
    
    func loadData() -> [TaskModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.returnsObjectsAsFaults = false
        let context = self.persistentContainer.viewContext
        var task = [Task]()
        do {
            task = try context.fetch(fetchRequest) as! [Task]
        } catch {
            print("Failed")
        }
        return createNewTaskModel(tasks: task)
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.returnsObjectsAsFaults = false
        let context = self.persistentContainer.viewContext
        var tasks = [Task]()
        do {
            tasks = try context.fetch(fetchRequest) as! [Task]
            for object in tasks {
                if Int(object.id) == task.id {
                    persistentContainer.viewContext.delete(object)
                    break;
                }
            }
            saveContext()
        } catch {
            print("Failed")
        }
    }
    
    func updateNoteValue(_ note: NoteModel, fromTask task: TaskModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
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
                            saveContext()
                            return
                        }
                    }
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    func updateTaskValue(_ task: TaskModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.returnsObjectsAsFaults = false
        let context = self.persistentContainer.viewContext
        var tasks = [Task]()
        do {
            tasks = try context.fetch(fetchRequest) as! [Task]
            tasks.first { Int($0.id) == task.id }?.completed = task.completed
            saveContext()
        } catch {
            print("Failed")
        }
    }
    
    func deleteNote(_ note: NoteModel, fromTask task: TaskModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.returnsObjectsAsFaults = false
        let context = self.persistentContainer.viewContext
        var tasks = [Task]()
        do {
            tasks = try context.fetch(fetchRequest) as! [Task]
            for object in tasks {
                if Int(object.id) == task.id {
                    for currentNote in Array(object.notes!) as! [Note] {
                        if Int(currentNote.id) == note.id {
                            persistentContainer.viewContext.delete(currentNote)
                            break;
                        }
                    }
                }
            }
            saveContext()
        } catch {
            print("Failed")
        }
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
//        let result = try? persistentContainer.viewContext.fetch(fetchRequest)
//        let notes = result as! [Note]
//        for object in notes {
//            print(object)
//            print(note)
//            if object == note {
//                persistentContainer.viewContext.delete(object)
//                saveContext()
//                return
//            }
//        }
    }
}
