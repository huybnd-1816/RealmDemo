//
//  Model.swift
//  RealmDemo
//
//  Created by nguyen.duc.huyb on 6/3/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class User: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var fullname: String = ""
    let age = RealmOptional<Int>()
    dynamic var pet: Pet?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String, age: Int?, pet: Pet?) {
        self.init()
        self.fullname = name
        self.age.value = age
        self.pet = pet
    }
    
    func ageString() -> String? {
        guard let age = age.value else { return nil }
        return String(age)
    }
}

@objcMembers class Pet: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    let owner = LinkingObjects(fromType: User.self, property: "pet")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
