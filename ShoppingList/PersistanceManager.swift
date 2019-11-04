//
//  persistanceManager.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/1/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import Firebase

class PersistanceManager {
    
    let db = Firestore.firestore()
    var userLists = [String]()
    
    
    func getCount() -> Int{
        var counter = 0
        db.collection("UserLists").getDocuments(){
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
        return counter
    }
    
    func loadData() {
        db.collection("UserLists").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    self.userLists.append(document.documentID)
                }
            }

        }
        
    }
    
    func deleteData(){
        db.collection("UserLists")
    }
}

