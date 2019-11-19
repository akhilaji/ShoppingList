//
//  PlacemarksManager.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/18/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class PlacemarksManager{
    var userLocations = [String]()
    let db = Firestore.firestore()
    
    
    func loadData() {
        db.collection("UserLists").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let querySnapshot = querySnapshot{
                    for document in querySnapshot.documents {
                        self.userLocations.append(document.documentID)
                    }
                }
            }
        }
    }
    
}
