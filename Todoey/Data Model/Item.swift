//
//  Item.swift
//  Todoey
//
//  Created by Mateusz Przybyłowski on 29.04.2018.
//  Copyright © 2018 buikaKRU. All rights reserved.
//

import Foundation

class Item {
    var title: String = ""
    var done: Bool = false
    
    let date = Date()
    let calendar = Calendar.current
    
    var year: Int
    var hour: Int
    var minute: Int
    
    init (title: String){
        self.title = title
        
        self.year = calendar.component(.year, from: date)
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
    }
    
    func printNow() {
        print(title, done)
        print("hour ============== \(hour):\(minute) year:\(year)")
    }
    
}