//
//  Item.swift
//  Todoey
//
//  Created by Milo Wyner on 11/17/18.
//  Copyright © 2018 Milo Wyner. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic let title: String = ""
    @objc dynamic var done: Bool = false
}
