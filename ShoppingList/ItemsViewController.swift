//
//  ItemsViewController.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/5/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var db = Firestore.firestore()
    
    var listName = ""
    var itemNames = [String]()
    
    @IBOutlet weak var itemsTable: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Update NavBar Title
        self.title = listName
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as! ListItemTableViewCell
        let listItem = itemNames[indexPath.row]
        cell.itemName.text = listItem
        print("Add Function")
        
        return cell
    }
    
    @IBAction func add(_ sender: Any) {
        
        
        //self.persistanceManager.userLists.append(listItem!)
        //self.db.collection(listName).addDocument(data: "Name", )
        print("Added" + (listName ?? "listNameEmptyError"))
        //self.loadData()
        self.itemsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           //let index: IndexPath = self.listsTable.indexPath(for: sender as! UITableViewCell)!
           
           if(segue.destination is AddListItemViewController){
               let destination = segue.destination as! AddListItemViewController
               destination.db = db
               destination.listName = listName
           }
       }
    
}
