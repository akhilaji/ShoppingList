//
//  AddListItemViewController.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/5/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class AddListItemViewController: UIViewController{
    
    var db = Firestore.firestore()
    var listName = ""
    
    @IBOutlet weak var itemLocation: UITextField!
    @IBOutlet weak var itemName: UITextField!
    //@IBOutlet weak var foodStatus: UISwitch!
    @IBOutlet weak var status1: UIButton!
    @IBOutlet weak var status2: UIButton!
    
    
    var name = ""
    var location = ""
    var status = false
    
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create tap gesture to minimize keyboard after editing
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
        name = itemName.text ?? ""
        location = itemLocation.text ?? ""
    
        status1.isHidden = false
        status2.isHidden = true
        
    }
    @IBAction func status1(_ sender: Any) {
        status1.isHidden = true
        status2.isHidden = false
        status = true
    }
    
    @IBAction func status2(_ sender: Any) {
        status1.isHidden = false
        status2.isHidden = true
        status = false
    }
    
    @IBAction func add(_ sender: Any) {
        name = itemName.text ?? ""
        location = itemLocation.text ?? ""
        print(listName)
        print(name)
        var error = ""

        // Add a new collection in document "list"
        var itemReference = db.collection("UserLists").document(listName).collection(listName)
        
        itemReference.document(name).setData([ "Location": location,
                                               "Status": status,
                                               "Completed": "false"])
        { err in
            if let err = err {
                error = "Error writing document: \(err)"
                print("Error writing document: \(err)")
                
                //Display alert to user regarding item add status
                let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            } else {
                error = "Item Added"
                print("Document successfully written!")
                
                //Display alert to user regarding item add status
                let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        itemName.text = ""
        itemLocation.text = ""
        status = false
    
    }
}
