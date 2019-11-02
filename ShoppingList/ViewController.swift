//
//  ViewController.swift
//  ShoppingList
//
//  Created by Akhil Aji on 10/31/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    let db = Firestore.firestore()
    let persistanceManager = PersistanceManager()
    //var userLists = [String]()
    var listNames = [String]()
    var userLists:[String]?
    
    @IBOutlet weak var listsTable: UITableView!
    
    var counter = 0
    //var userLists = ["list1", "list2","list3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        persistanceManager.loadData()
        counter = persistanceManager.getCount()
        //print(counter)
        //print("ViewDidLoad")
        //print(persistanceManager.userLists)
        userLists = self.persistanceManager.userLists

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(persistanceManager.userLists.count)
        print(persistanceManager.userLists.count)
        return persistanceManager.userLists.count
    }

    //Add
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as! UserListsTableViewCell
        //persistanceManager.loadData()
        let listItem = persistanceManager.userLists[indexPath.row]
        print(listNames)
        cell.listName.text = listItem
        //tableView.reloadData()
        print("Add Function")
        
        print(persistanceManager.userLists)
        return cell
    }
    
    //Edit
    func tableView(_ tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle{
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    //Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        persistanceManager.userLists.remove(at: indexPath.row)
        self.listsTable.reloadData()
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Create a new list", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField{ (UITextField) in
            UITextField.placeholder = "Add a new list"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler:{
            action in
            
            let listName = alert.textFields?.first?.text
            self.persistanceManager.userLists.append(listName!)
            self.db.collection("UserLists").document(listName!).setData(["name": listName!])
            print("Added" + (listName ?? "listNameEmptyError"))
            self.listsTable.reloadData()
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func reloadTable(_ sender: Any) {
        counter = persistanceManager.getCount()
        self.listsTable.reloadData()
    }
    
    
}

