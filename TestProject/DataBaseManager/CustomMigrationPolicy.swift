//
//  CustomMigrationPolicy.swift
//  TestProject
//
//  Created by Silchenko on 09.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    @objc func changeData(forData data: String) -> String {
        return data
    }
}
