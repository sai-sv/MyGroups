//
//  MainViewController.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
       
    var groups = Group.getGroups()
    var isImageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let group = groups[indexPath.row]
        
        cell.nameLabel.text = group.name
        cell.locationLabel.text = group.location
        cell.genreLabel.text = group.genre
        
        if group.image == nil {
            cell.imageOfGroup.image = UIImage(named: groups[indexPath.row].imageName!)
        } else {
            cell.imageOfGroup.image = group.image
        }
        
        cell.imageOfGroup.layer.cornerRadius = cell.imageOfGroup.frame.size.height / 2
        cell.imageOfGroup.clipsToBounds = true

        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let svc = segue.source as? NewGroupTableViewController else { return }
        
        svc.saveNewGroup()
        groups.append(svc.group!)
        
        tableView.reloadData()
    }
}
