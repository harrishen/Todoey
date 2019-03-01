//
//  Item.swift
//  Todoey
//
//  Created by Hongyuan Shen on 3/1/19.
//  Copyright © 2019 Hongyuan Shen. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var finished: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
