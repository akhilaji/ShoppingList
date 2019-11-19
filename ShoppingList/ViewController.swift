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
import CoreLocation
import MapKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate
{
    
    let db = Firestore.firestore()
    let persistanceManager = PersistanceManager()
    let placemarksManager = PlacemarksManager()
    
    var userLists:[String]?
    var listNames = [String]()
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var listsTable: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    var counter = 0
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //create tap gesture to minimize keyboard after editing
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        placemarksManager.loadData()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            self.map.setRegion(region, animated: true)
        }
        
        if placemarksManager.userLocations.count != 0{
            for i in 1...placemarksManager.userLocations.count-1{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = placemarksManager.userLocations[i]
                
                let search = MKLocalSearch(request: request)
                
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
                        
                        self.map.addAnnotation(annotation)
                    }
                    self.map.showAnnotations(self.map.annotations, animated: true)                }
            }
        }
        loadData()
    }
    
    
    //MARK - TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(persistanceManager.userLists.count)
        //return persistanceManager.userLists.count
        return listNames.count
        
    }
    
    //Add
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as! UserListsTableViewCell
        //let listItem = persistanceManager.userLists[indexPath.row]
        
        let listItem = listNames[indexPath.row]
        cell.listName.text = listItem
        //print("Add Function")
        //print(persistanceManager.userLists)
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
        
        let itemName = listNames[indexPath.row]
        persistanceManager.userLists.remove(at: indexPath.row)
        db.collection("UserLists").whereField("name", isEqualTo: itemName).getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
        loadData()
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
            //print("Added" + (listName ?? "listNameEmptyError"))
            self.loadData()
            self.listsTable.reloadData()
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func reloadTable(_ sender: Any) {
        counter = persistanceManager.getCount()
        self.listsTable.reloadData()
    }
    
    func reloadTableView(){
        self.listsTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index: IndexPath = self.listsTable.indexPath(for: sender as! UITableViewCell)!
        
        if(segue.destination is ItemsViewController){
            let destination = segue.destination as! ItemsViewController
            destination.db = db
            destination.listName = listNames[index.row]
        }
    }
    
    
    //MARK - Persistance manager methods
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
                    //print("\(document.documentID) => \(document.data())");
                }
                // print("Count = \(counter)");
            }
        }
        return counter
    }
    
    func loadData() {
        listNames = [String]()
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
            DispatchQueue.main.async {
                self.listsTable.reloadData()
            }
        }
    }
}

