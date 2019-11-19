//
//  GroupModel.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import RealmSwift

class Group: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var genre: String?
    @objc dynamic var imageData: Data?
    
    convenience init(name: String, location: String?, genre: String?, imageData: Data?) {
        self.init()
        
        self.name = name
        self.location = location
        self.genre = genre
        self.imageData = imageData
    }
}
