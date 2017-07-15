//
//  PairsTableViewController.swift
//  Pair
//
//  Created by Luis Puentes on 6/2/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit

class PairsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PairController.shared.fetchName() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return PairController.shared.groups.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PairController.shared.groups[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)

        let name = PairController.shared.groups[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = name.names
        
        return cell
    }

    // Allow user to delete rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let name = PairController.shared.groups[indexPath.section][indexPath.row]
            PairController.shared.delete(name: name)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add Name", message: "Please add names", preferredStyle: .alert)
        
        var alertTextField: UITextField?
        
        alertController.addTextField { (textField) in
            alertTextField = textField
            textField.placeholder = "Enter first name..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let name = alertTextField?.text else { return }
            
            PairController.shared.addName(name: name) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        PairController.shared.names.shuffling()
        tableView.reloadData()
    }
}
