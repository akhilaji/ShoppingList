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
    
    var userLists:[String]?
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var listsTable: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //create tap gesture to minimize keyboard after editing
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        persistanceManager.loadData()
        counter = persistanceManager.getCount()
        userLists = self.persistanceManager.userLists
       
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

    }
    
    //MARK - TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(persistanceManager.userLists.count)
        return persistanceManager.userLists.count
    }

    //Add
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as! UserListsTableViewCell
        let listItem = persistanceManager.userLists[indexPath.row]
        cell.listName.text = listItem
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
    
    @IBAction func reloadTable(_ sender: Any) {
        counter = persistanceManager.getCount()
        self.listsTable.reloadData()
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    <#code#>
    //}
    
    //MARK - MAP VIEW FUNCTIONS
    func LocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude
                , longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            //self.map.setRegion(region, animated: true)
            self.map.setRegion(map.regionThatFits(region), animated: true)
        }
    }
    
    
}

