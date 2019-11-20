//
//  MainViewController.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
       
    var groups: Results<Group>!
//    var isImageChanged = false
    var isAscendingSortType = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButtonItem: UIBarButtonItem!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = realm.objects(Group.self)
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.isEmpty ? 0 : groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            guard let dvc = segue.destination as? NewGroupTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            dvc.currentGroup = groups[indexPath.row]
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let svc = segue.source as? NewGroupTableViewController else { return }
        svc.saveGroup()
        
        tableView.reloadData()
    }
    
    
    @IBAction func sortButtonItemStateChanged(_ sender: UIBarButtonItem) {
        
        self.isAscendingSortType.toggle()
        sortButtonItem.image = self.isAscendingSortType ? #imageLiteral(resourceName: "AZ") : #imageLiteral(resourceName: "ZA")
        
        sortData()
    }
    
    @IBAction func sortSegmentValueChanged(_ sender: UISegmentedControl) {
        sortData()
    }
    
    // MARK: -
    private func sortData() {
        
        if sortSegment.selectedSegmentIndex == 0 {
            groups = groups.sorted(byKeyPath: "date", ascending: self.isAscendingSortType)
        } else {
            groups = groups.sorted(byKeyPath: "name", ascending: self.isAscendingSortType)
        }
        
        tableView.reloadData()
    }
}
