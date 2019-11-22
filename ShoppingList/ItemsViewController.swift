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
        cell.itemCompletion.isHidden = true
        let listItem = itemNames[indexPath.row]
        //Set completion image visibility based on itemCompletion Status
        var itemReference = db.collection("UserLists").document(listName).collection(listName).document(itemNames[indexPath.row])
            print(itemReference)
            itemReference.getDocument { (document, error) in
                //error check
                if error == nil{
                    //check for document
                    if document != nil && document!.exists{
                        let documentData = document?.data()
                        print(documentData)
                        var completion = documentData!["Completed"] as! String
                        //self.itemLocationValue.text = self.location
                        
                        if completion.contains("true"){
                            cell.itemCompletion.isHidden = false
                        }else{
                            cell.itemCompletion.isHidden = true
                        }
                    }
                }
        }
        cell.itemName.text = listItem
        print("Add Function")
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle{
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    //Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        let itemName = itemNames[indexPath.row]
        db.collection("UserLists").document(listName).collection(listName).document(itemName).delete(completion: { (error) in
            if let error = error{
                print(error)
            }
        })
        
        loadData()
        self.itemsTable.reloadData()
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
        
        
        if(segue.destination is AddListItemViewController){
            let destination = segue.destination as! AddListItemViewController
            destination.db = db
            destination.listName = listName
        }
        
        if(segue.destination is DetailViewController){
            let index: IndexPath = self.itemsTable.indexPath(for: sender as! UITableViewCell)!
            let destination = segue.destination as! DetailViewController
            destination.listName = listName
            destination.name = itemNames[index.row]
        }
    }
    
    @IBAction func unwindDetailViewController(segue: UIStoryboardSegue) {
           print("unwinded")
           if let sourceView = segue.source as? DetailViewController {
            self.itemsTable.reloadData()
           }
           
           
    }
    
    @IBAction func unwindAddController(segue: UIStoryboardSegue) {
        print("unwinded")
        
        if let sourceView = segue.source as? AddListItemViewController {
            loadData()
        }
        
        
    }
}
