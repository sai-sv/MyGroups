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
       
    private var groups: Results<Group>!
//    var isImageChanged = false
    private var searchController = UISearchController(searchResultsController: nil)
    private var filteredGroups: Results<Group>!
    private var isSearchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isSearchActive: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    private var isAscendingSortType = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButtonItem: UIBarButtonItem!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = realm.objects(Group.self)
        
        // search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.isActive = false // hide on start
        navigationItem.searchController = searchController
        definesPresentationContext = true // позволяет отпустить строку поиска при переходе на другой экран (не заметил изменений)
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return filteredGroups.isEmpty ? 0 : filteredGroups.count
        }
        return groups.isEmpty ? 0 : groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let group = isSearchActive ? filteredGroups[indexPath.row] : groups[indexPath.row]
        
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
            let group = self.isSearchActive ? self.filteredGroups[indexPath.row] : self.groups[indexPath.row]
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
            
            dvc.currentGroup = isSearchActive ? filteredGroups[indexPath.row] : groups[indexPath.row]
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


// MARK: - SearcController
extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredGroups = groups.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", text, text)
        tableView.reloadData()
    }
}
