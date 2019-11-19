//
//  MainViewController.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
       
    var groups: Results<Group>!
    var isImageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = realm.objects(Group.self)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.isEmpty ? 0 : groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let group = groups[indexPath.row]
        
        cell.nameLabel.text = group.name
        cell.locationLabel.text = group.location
        cell.genreLabel.text = group.genre
        
        cell.imageOfGroup.image = UIImage(data: group.imageData!)
        cell.imageOfGroup.layer.cornerRadius = cell.imageOfGroup.frame.size.height / 2
        cell.imageOfGroup.clipsToBounds = true

        return cell
    }
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            // delete data
            let group = self.groups[indexPath.row]
            StorageManager.deleteObject(group)
            // delete row
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let actionsCOnfiguration = UISwipeActionsConfiguration(actions: [action])
        return actionsCOnfiguration
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
        
        tableView.reloadData()
    }
}
