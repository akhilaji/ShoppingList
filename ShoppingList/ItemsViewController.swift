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
        
     loadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of Items in List")
        print(itemNames.count)
        print(getCount())
        return itemNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! ListItemTableViewCell
        let listItem = itemNames[indexPath.row]
        cell.itemName.text = listItem
        print("Add Function")
        
        return cell
    }
    
    @IBAction func add(_ sender: Any) {
        
    }
    
    
    //Firebase Methods
    func getCount() -> Int{
        var counter = 0
        
         db.collection("UserLists").document(listName).collection(listName).getDocuments(){
            (querySnapshot, err) in
            
            if let err = err{
                print("Error getting documents: \(err)");
            }
            else{
                for document in querySnapshot!.documents {
                    counter += 1
                    print("\(document.documentID) => \(document.data())");
                }
                // print("Count = \(counter)");
            }
        }
        print("Count Function Results from ItemsViewController")
        print(counter)
        return counter
    }
    
    func loadData() {
        
        itemNames = [String]()
        
        db.collection("UserLists").document(listName).collection(listName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let querySnapshot = querySnapshot{
                    
                    for document in querySnapshot.documents {
                        
                        self.itemNames.append(document.documentID)
                    }
                }
            }
            DispatchQueue.main.async {
                self.itemsTable.reloadData()
            }
        }
    
        
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
