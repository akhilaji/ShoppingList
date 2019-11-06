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

class ItemsViewController: UIViewController//, UITableViewDataSource, UITableViewDelegate
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
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemNames.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }
    
    @IBAction func add(_ sender: Any) {
    }
    
}
