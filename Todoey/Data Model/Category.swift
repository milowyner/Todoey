//
//  Category.swift
//  Todoey
//
//  Created by Milo Wyner on 11/17/18.
//  Copyright © 2018 Milo Wyner. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
