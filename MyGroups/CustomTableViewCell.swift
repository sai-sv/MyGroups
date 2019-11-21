//
//  CustomTableViewCell.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {    
    @IBOutlet weak var imageOfGroup: UIImageView! {
        didSet {
            imageOfGroup.layer.cornerRadius = imageOfGroup.frame.size.height / 2
            imageOfGroup.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
}
