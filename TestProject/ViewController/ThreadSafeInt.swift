//
//  ThreadSafeInt.swift
//  TestProject
//
//  Created by Silchenko on 18.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class ThreadSafeInt {
    private var _count = 0
    private let queue = DispatchQueue(label: "com.concurrent.ThreadSafeInt", attributes: .concurrent)
    
    var count: Int {
        var k = 0
        queue.sync {
            k = _count
        }
        return k
    }
    
    init(count: Int) {
        queue.async(group: nil, qos: .default, flags: .barrier) {
            self._count = count
        }
    }
    
    func addValue(_ index: Int) {
        queue.sync {
            self._count += index
        }
    }
}
