//
//  GroupModel.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit

struct Group {
    var name: String!
    var location: String?
    var genre: String?
    var image: UIImage?
    var imageName: String?
    
    static let groupsList = ["Ajattara", "Amon Amarth", "Beseech", "Children Of Bodom", "Dimmu Borgir", "Eluveitie", "Kalmah", "Kataklysm", "Metallica", "Nightwish", "Rammstein", "Sepultura", "Slipknot", "Soulfly"]
    
    static func getGroups() -> [Group] {
        var groups = [Group]()
        for group in groupsList {
            groups.append(Group(name: group, location: "Earth Planet", genre: "Metal", image: nil, imageName: group))
        }
        return groups
    }
}
