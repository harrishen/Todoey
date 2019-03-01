//
//  Category.swift
//  Todoey
//
//  Created by Hongyuan Shen on 3/1/19.
//  Copyright © 2019 Hongyuan Shen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
