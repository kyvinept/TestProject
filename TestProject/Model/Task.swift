//
//  Task.swift
//  TestProject
//
//  Created by Silchenko on 09.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class TaskModel {
    
    var id: Int?
    var name: String?
    var completed = false
    var notes = [NoteModel]()
}
