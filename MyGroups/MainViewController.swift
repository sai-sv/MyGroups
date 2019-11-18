//
//  MainViewController.swift
//  MyGroups
//
//  Created by Admin on 18.11.2019.
//  Copyright © 2019 Sergei Sai. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    let groupsList = ["Ajattara", "Amon Amarth", "Beseech", "Children Of Bodom", "Dimmu Borgir", "Eluveitie", "Kalmah", "Kataklysm", "Metallica", "Nightwish", "Rammstein", "Sepultura", "Slipknot", "Soulfly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        cell.nameLabel.text = groupsList[indexPath.row]
        cell.groupImageView.image = UIImage(named: groupsList[indexPath.row])
        cell.groupImageView.layer.cornerRadius = cell.groupImageView.frame.size.height / 2
        cell.groupImageView.clipsToBounds = true
        

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
