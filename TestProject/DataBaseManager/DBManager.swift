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
    
    private enum DataModel: String {
        case news = "News"
        case toDo = "ToDo"
        
        enum News: String {
            case newsEntity = "NewsEntity"
        }
        enum ToDo: String {
            case task = "Task"
            case note = "Note"
        }
    }
    
    private var dataModelType: DataModel!
    private let queue = DispatchQueue(label: "com.concurrent.DBManager")
    private var willSaveNews = [News]()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelType.rawValue)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
        queue.async {
            self.dataModelType = .toDo
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
            self.dataModelType = .toDo
            let entity = NSEntityDescription.entity(forEntityName: DataModel.ToDo.task.rawValue, in: self.persistentContainer.viewContext)
            let newTask = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! Task
            newTask.id = Int32(task.id!)
            newTask.text = task.text
            newTask.name = task.name
            newTask.completed = task.completed
            self.saveContext()
        }
    }
    
    func addNote(withModel note: NoteModel, toTask task: TaskModel) {
        queue.async {
            self.dataModelType = .toDo
            let entity = NSEntityDescription.entity(forEntityName: DataModel.ToDo.task.rawValue, in: self.persistentContainer.viewContext)
            let newNote = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! Note
            newNote.id = Int32(note.id!)
            newNote.text = note.text
            newNote.completed = note.completed
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.ToDo.task.rawValue)
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
            self.dataModelType = .toDo
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.ToDo.task.rawValue)
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
        self.dataModelType = .toDo
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
        self.dataModelType = .toDo
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
            self.dataModelType = .toDo
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.ToDo.task.rawValue)
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
            self.dataModelType = .toDo
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.ToDo.task.rawValue)
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
            self.dataModelType = .toDo
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.ToDo.task.rawValue)
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
            self.dataModelType = .toDo
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.ToDo.task.rawValue)
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
    
    func addNews(news: [News]) {
        queue.async {
            self.dataModelType = .news
            self.willSaveNews = news
            self.loadNews(successBlock: { news in
                              self.checkRepeatNews(news: news)
                          }, failBlock: {
                              self.saveNotRepeatNews()
                          })
        }
    }
    
    private func checkRepeatNews(news: [News]) {
        queue.async {
            for loadedNews in news {
                self.willSaveNews.removeAll { $0.id == loadedNews.id
                                              && $0.author == loadedNews.author
                                              && $0.content == loadedNews.content
                                              && $0.descriptionNews == loadedNews.descriptionNews
                                              && $0.imageUrl == loadedNews.imageUrl
                                              && $0.title == loadedNews.title;
                }
            }
            self.saveNotRepeatNews()
        }
    }
    
    private func saveNotRepeatNews() {
        queue.async {
            let entity = NSEntityDescription.entity(forEntityName: DataModel.News.newsEntity.rawValue, in: self.persistentContainer.viewContext)
            if let entity = entity {
                for n in self.willSaveNews {
                    self.createNews(entity: entity, news: n)
                }
            }
        }
    }
    
    func deleteAllNews() {
        queue.async {
            self.dataModelType = .news
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.News.newsEntity.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var loadedNews = [NewsEntity]()
            do {
                loadedNews = try context.fetch(fetchRequest) as! [NewsEntity]
                for news in loadedNews {
                    self.persistentContainer.viewContext.delete(news)
                }
                self.saveContext()
            } catch {
                print("Failed")
            }
        }
    }
    
    func updateImageNews(_ news: News) {
        queue.async {
            self.dataModelType = .news
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.News.newsEntity.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var loadedNews = [NewsEntity]()
            do {
                loadedNews = try context.fetch(fetchRequest) as! [NewsEntity]
                loadedNews.first { $0.id == news.id
                                   && $0.author == news.author
                                   && $0.content == news.content
                                   && $0.descriptionNews == news.descriptionNews
                                   && $0.imageUrl == news.imageUrl
                                   && $0.publishedAt == news.publishedAt
                                   && $0.title == news.title
                }?.image = Data(image: news.image)
                self.saveContext()
            } catch {
                print("Failed")
            }
        }
    }
    
    private func createNews(entity: NSEntityDescription , news: News) {
        queue.async {
            let newNews = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext) as! NewsEntity
            newNews.id = news.id
            newNews.author = news.author
            newNews.content = news.content
            newNews.descriptionNews = news.descriptionNews
            newNews.imageUrl = news.imageUrl
            newNews.publishedAt = news.publishedAt
            newNews.title = news.title
            newNews.image = Data(image: news.image)
            self.saveContext()
        }
    }
    
    func loadNews(successBlock: @escaping ([News]) -> (), failBlock: @escaping () -> ()) {
        queue.async {
            self.dataModelType = .news
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataModel.News.newsEntity.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var news = [NewsEntity]()
            do {
                news = try context.fetch(fetchRequest) as! [NewsEntity]
                var newsNews = self.createNewNews(news: news)
                newsNews.sort { $0.publishedAt > $1.publishedAt }
                if newsNews.count == 0 {
                    failBlock()
                    return
                }
                successBlock(newsNews)
            } catch {
                failBlock()
            }
        }
    }
    
    private func createNewNews(news: [NewsEntity]) -> [News] {
        var allNews = [News]()
        for newNews in news {
            var image: UIImage? = nil
            if let img = newNews.image {
                image = UIImage(data: img)
            }
            let createNews = News(id: newNews.id,
                              author: newNews.author,
                               title: newNews.title!,
                     descriptionNews: newNews.descriptionNews!,
                         publishedAt: newNews.publishedAt!,
                             content: newNews.content!,
                            imageUrl: newNews.imageUrl,
                               image: image)
            allNews.append(createNews)
        }
        return allNews
    }
}

extension Data {
    init?(image: UIImage?) {
        self.init()
        if let image = image {
            if let data: Data = UIImagePNGRepresentation(image) {
                self = data
            } else if let data: Data = UIImageJPEGRepresentation(image, 1.0) {
                self = data
            }
        }
    }
}
