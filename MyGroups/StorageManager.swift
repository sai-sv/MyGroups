//
//  StorageManager.swift
//  MyGroups
//
//  Created by Admin on 19.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import RealmSwift

 let realm = try! Realm()


class StorageManager {
    
    static func saveObject(_ group: Group) {
        try! realm.write {
            realm.add(group)
        }
    }
}
