//
//  Category.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 14.05.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var finished: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    
    let items = List<Item>()
    
    
}
