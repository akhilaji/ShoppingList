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
import MapKit

class PlacemarksManager{
    var listNames:[String] = []
    var userLocations = [String]()
    var annotationsList = [MKPointAnnotation]()
    var places = [MKPlacemark]()
    let db = Firestore.firestore()
    let persistanceManager = PersistanceManager()
    
    func loadData() {
        loadListNames()
        print(listNames.count)
        loadCollections()
        print(userLocations.count)
        
        //groupQuery()
        
        //persistanceManager.loadData()
        //persistanceManager.loadCollections()
        
        
        
        userLocations.append("Grocery Store")
        //userLocations.append("Target")
        //userLocations.append("Costco")
        
        print(annotationsList.count)
    }
       
    
    
    func loadListNames(){
        DispatchQueue.main.async {
            print("first")
            self.db.collection("UserLists").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let querySnapshot = querySnapshot{
                        for document in querySnapshot.documents {
                            
                            self.listNames.append(document.documentID)
                        }
                    }
                }
            }
        }
        
    }
    
    
    func loadCollections(){
        DispatchQueue.main.async{
            print("second")
            if !self.listNames.isEmpty{
                for i in 1...self.listNames.count - 1{
                self.db.collection("UserLists").document(self.listNames[i]).collection(self.listNames[i]).whereField("Location", isEqualTo: true)
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
    
   
    func performSearch(){
        print("third")
        if userLocations.count != 0{
            for i in 1...userLocations.count-1{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = userLocations[i]
                
                let search = MKLocalSearch(request: request)
                //let annotations = mapView.annotations
                
                
                search.start { response, _ in
                    guard let response = response else {
                        return
                    }
                    print( response.mapItems )
                    var matchingItems:[MKMapItem] = []
                    matchingItems = response.mapItems
                    for i in 1...matchingItems.count - 1
                    {
                        let place = matchingItems[i].placemark
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = place.location!.coordinate
                        annotation.title = place.name
                        
                        self.places.append(place)
                        self.annotationsList.append(annotation)

                    }
                    
                }
            }
        }
        
        
        
    }
    
}
