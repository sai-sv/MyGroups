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
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    convenience init(name: String, location: String?, genre: String?, imageData: Data?, rating: Double) {
        self.init()
        
        self.name = name
        self.location = location
        self.genre = genre
        self.imageData = imageData
        self.rating = rating
    }
}
