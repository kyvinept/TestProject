//
//  SaveDataController.swift
//  TestProject
//
//  Created by Silchenko on 04.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class TaskViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let data = DBManager()
    private var tasks = [TaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.title = "Tasks"
        createBackButton()
        createAddButton()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func createAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    private func loadData() {
        tasks = data.loadData()
        tasks.reverse()
        tableView.reloadData()
    }
    
    @objc func addButtonTapped() {
        let alert = UIAlertController(title: "",
                                    message: "Input name of new task",
                             preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Task name..."
        }
        alert.addAction(UIAlertAction(title: "Save",
                                      style: .default,
                                    handler: { (action) in
                                        let text = alert.textFields!.first!.text!
                                        if text != "" {
                                            let task = self.createNewTask(withName: text)
                                            self.tasks.insert(task, at: 0)
                                            self.data.addTask(withModel: task)
                                            self.tableView.reloadData()
                                        }
                                    }))
        self.present(alert,
                     animated: true,
                   completion: nil)
    }
    
    private func createNewTask(withName name: String) -> TaskModel {
        let task = TaskModel()
        let index = self.tasks.max { a, b in a.id! < b.id! }?.id
        if let index = index {
            task.id = index + 1
        } else {
            task.id = 0
        }
        task.name = name
        return task
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        if tasks[indexPath.row].completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        self.navigationController?.pushViewController(noteVC, animated: true)
        noteVC.configure(task: tasks[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.deleteTask(task: self.tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.data.deleteTask(task: self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
}
