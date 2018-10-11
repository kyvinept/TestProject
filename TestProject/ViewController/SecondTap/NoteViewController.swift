//
//  NoteViewController.swift
//  TestProject
//
//  Created by Silchenko on 08.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class NoteViewController: BaseViewController {
    
    private let data = DBManager()
    private var currentTask: TaskModel!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createBackButton()
        createAddButton()
        self.title = currentTask.name
    }
    
    func configure(task: TaskModel) {
        self.currentTask = task
    }
    
    private func createAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func addButtonTapped() {
        let alert = UIAlertController(title: "", message: "Input note text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Input text..."
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let text = alert.textFields!.first!.text!
            if text != "" {
                let note = self.createNewNote(withText: text)
                self.currentTask?.notes.append(note)
                self.data.addNote(withModel: note, toTask: self.currentTask!)
                self.tableView.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createNewNote(withText text: String) -> NoteModel {
        let note = NoteModel()
        let index = self.currentTask.notes.max { $0.id! > $1.id! }?.id
        if let index = index {
            note.id = index + 1
        } else {
            note.id = 0
        }
        note.text = text
        note.task = self.currentTask
        return note
    }
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTask.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = currentTask.notes[indexPath.row].text
        if currentTask.notes[indexPath.row].completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.data.deleteNote(self.currentTask.notes[indexPath.row], fromTask: self.currentTask)
            self.currentTask.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTask.notes[indexPath.row].completed.toggle()
        data.updateNoteValue(currentTask.notes[indexPath.row], fromTask: currentTask)
        if currentTask.notes[indexPath.row].completed {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        checkCompletedNotes()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func checkCompletedNotes() {
        let countCompletedNotes = currentTask.notes.filter({ $0.completed }).count
        if currentTask.notes.count == countCompletedNotes && !currentTask.completed {
            currentTask.completed = true
            data.updateTaskValue(currentTask)
        } else if currentTask.completed {
            currentTask.completed = false
            data.updateTaskValue(currentTask)
        }
    }
}
