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
    
    
    
    
    func loadListNames(){
        db.collection("UserLists").getDocuments() { (querySnapshot, err) in
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
    
    func loadCollections(){
        
        
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
                
                
                
                //                db.collection("UserLists").document(listNames[i]).collection(listNames[i]).getDocuments() { (querySnapshot, err) in
                //                    if let err = err {
                //                        print("Error getting documents: \(err)")
                //                    } else {
                //                        if let querySnapshot = querySnapshot{
                //                            for document in querySnapshot.documents {
                //                                self.listNames?.append(document.documentID)
                //                            }
                //                        }
                //                    }
                //
                //                }
            }
            
        }
    }
    
    func loadData() {
        loadListNames()
        print(listNames.count)
        loadCollections()
        print(userLocations.count)
        
        
        userLocations.append("Safeway")
        userLocations.append("Target")
        userLocations.append("Costco")
        
        print(annotationsList.count)
    }
    
    func performSearch(){
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
