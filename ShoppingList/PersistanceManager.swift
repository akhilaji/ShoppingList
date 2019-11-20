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
    var listNames:[String] = []
    //let viewController = ViewController()
    
    
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
                if let querySnapshot = querySnapshot{
                    for document in querySnapshot.documents {
                        
                        self.userLists.append(document.documentID)
                    }
                    
                }
                
            }
//            DispatchQueue.main.async {
//
//            }
        }
        
        
    }
    
    func loadCollections(){
        print("second")
        if !listNames.isEmpty{
            for i in 1...listNames.count - 1{
                db.collection("UserLists").document(listNames[i]).collection(listNames[i]).whereField("Location", isEqualTo: true)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                }
            }
            
        }
    }
    
    func groupQuery(){
        db.collectionGroup("UserLists").whereField("Location", isEqualTo: true).getDocuments { (snapshot, error) in
            // ...
            if let error = error{
                print("Error getting documents: \(error)")
            }else{
                for document in snapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        

    }
    
    
    
    func deleteData(){
        db.collection("UserLists")
    }
}

