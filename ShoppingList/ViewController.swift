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
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //count()
        //print(persistanceManager.userLists.count)
        print(counter)
        //print(userLists!.count)
        //return persistanceManager.getCount()
        return counter
        //let value = persistanceManager.userLists.count()
        //return userLists!.count
        //return 3
    }

    //Add
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as! UserListsTableViewCell
        //loadData()
        //let listItem = persistanceManager.userLists[indexPath.row]
        let listItem = listNames[indexPath.row]
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
    
    
    
//    func count() -> Int{
//        var counter = 0
//        db.collection("UserLists").getDocuments(){
//            (querySnapshot, err) in
//
//            if let err = err{
//                print("Error getting documents: \(err)");
//            }
//            else{
//                for document in querySnapshot!.documents {
//                    counter += 1
//                    print("\(document.documentID) => \(document.data())");
//                }
//                print("Count = \(counter)");
//            }
//        }
//        return counter
//    }

//    func loadData() {
//        db.collection("UserLists").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//
//                    self.userLists.append(document.documentID)
//                }
//            }
//            print(self.userLists)
//            self.listsTable.reloadData()
//        }
//
//    }
    
    func loadData(){


        db.collection("UserLists").getDocuments { (querySnapshot, error) in
            if let error = error
            {
                print("\(error.localizedDescription)")
            }
            else
            {

                 for document in (querySnapshot?.documents)! {
                     if let Title = document.data()["title"] as? String {
                         print(Title)
                         //self.title = Title
                         let title = Title
                         //job.title = Title

                        self.listNames.append(title)
                         //self.numOfCells += 1
                     }
                 }

                DispatchQueue.main.async
                {
                    self.listsTable.reloadData()
                }

            }
        }

    }

    
    @IBAction func reloadTable(_ sender: Any) {
        self.listsTable.reloadData()
    }
    
    
}

