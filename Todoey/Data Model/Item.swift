//
//  Item.swift
//  Todoey
//
//  Created by Milo Wyner on 10/29/18.
//  Copyright © 2018 Milo Wyner. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String = ""
    var done: Bool = false
    
    init(name: String) {
        title = name
    }
}
