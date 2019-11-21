//
//  DetailViewController.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/19/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
import MapKit



class DetailViewController: UIViewController, CLLocationManagerDelegate{
    
    var listName = ""
    var name = ""
    var location = ""
    var db = Firestore.firestore()
    var apiResults:NSMutableArray?
    var resultCount:NSNumber?
    var itemTitleVar = ""
    var servingTimeVar = ""
    var servingSizeVar = ""
    var imgURL = ""
    var RecepieImage:UIImage?
    var regionInMeters: Double = 5000
    
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemLocationValue: UILabel!
    @IBOutlet weak var markAsCompleted: UIButton!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var servingTime: UILabel!
    @IBOutlet weak var servingSize: UILabel!
    @IBOutlet weak var readyInLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var recepiesLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = name
        markAsCompleted.layer.cornerRadius = 20
        markAsCompleted.clipsToBounds = true
        readyInLabel.isHidden = true
        servingsLabel.isHidden = true
        recepiesLabel.isHidden = true
        
        //Retreive Data from the list item
        var itemReference = db.collection("UserLists").document(listName).collection(listName).document(name)
        print(itemReference)
        
        itemReference.getDocument { (document, error) in
            //error check
            if error == nil{
                //check for document
                if document != nil && document!.exists{
                    let documentData = document?.data()
                    print(documentData)
                    self.location = documentData!["Location"] as! String
                    self.itemLocationValue.text = self.location
                    
                    let request = MKLocalSearch.Request()
                    request.naturalLanguageQuery = self.location
                           
                           let search = MKLocalSearch(request: request)
                           
                           search.start { response, _ in
                               guard let response = response else {
                                   return
                               }
                               //print( response.mapItems )
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
                               self.map.showAnnotations(self.map.annotations, animated: true)
                               
                           }
                }
            }
        }
        
        apiCall()
        imageProccessing()
        
        print("past resume")
        let checkNil = self.itemTitleVar
        if checkNil.isEmpty != true{
            self.itemTitle.text = self.itemTitleVar
            self.servingTime.text = self.servingTimeVar
            self.servingSize.text = self.servingSizeVar
            self.itemImage.image = self.RecepieImage
            self.itemImage.layer.cornerRadius = 5
            self.itemImage.clipsToBounds = true
            
            self.readyInLabel.isHidden = false
            self.servingsLabel.isHidden = false
            self.recepiesLabel.isHidden = false
            
        }
        
        var locationManager: CLLocationManager!
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
        
       
    }
    
    func apiCall(){
        //create API Call
        var s = DispatchSemaphore(value: 0)
        let itemName = self.name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlAsString = "https://api.spoonacular.com/recipes/search?apiKey=5f6be10b86e24c2bb7aad528551bb0f0&query="+itemName+"&number=1"
        
        let url = URL(string: urlAsString)
        let urlSession = URLSession.shared
        
        let jsonQuery = urlSession.dataTask(with: url!, completionHandler: { data, response, error -> Void in
            if error != nil{
                print(error!.localizedDescription)
            }
            
            var err: NSError?
            
            let decoder = JSONDecoder()
            var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            print(jsonResult)
            
            self.resultCount = jsonResult["totalResults"] as? NSNumber
            print(Int(self.resultCount!.intValue))
            let numValofResult = Int(self.resultCount!.intValue)
            print(numValofResult)
            
            if numValofResult > 0{
                self.apiResults = jsonResult["results"] as! NSMutableArray
                
                print(self.apiResults)
                
                let data = self.apiResults?[0] as? [String: AnyObject]
                print((data?["title"])!)
                
                
                print("printing saved data")
                self.itemTitleVar = (data?["title"])! as! String
                print(self.itemTitleVar)
                self.servingTimeVar = String(describing: data!["readyInMinutes"])
                print(self.servingTimeVar)
                self.servingSizeVar = String(describing: data!["servings"])
                self.imgURL = data!["image"] as! String
            }else{
                print("noResultsFound")
            }
            
            
            
            s.signal()
            
        })
        
        jsonQuery.resume()
        s.wait(timeout: .now() + 2)
    }
    
    func imageProccessing(){
        var s = DispatchSemaphore(value: 0)
        let pictureURL = URL(string: "https://spoonacular.com/recipeImages/" + self.imgURL)
        let session  = URLSession(configuration: .default)
        
        let imageDownloader = session.dataTask(with: pictureURL!) { (data, response, error) in
            if let error = error{
                print("Error downloading image")
            }else{
                if let response = response as? HTTPURLResponse{
                    let imageData = data
                    //convert to UIImage
                    self.RecepieImage = UIImage(data: imageData!)
                    
                }
            }
            s.signal()
        }
        imageDownloader.resume()
        s.wait(timeout: .now() + 2)
    }
    @IBAction func markAsCompleted(_ sender: Any) {
        var itemReference = db.collection("UserLists").document(listName).collection(listName).document(name)
        itemReference.updateData(["Completed": "true"]) { (error) in
            if let error = error{
                print(error)
            }else{
                print("Status Updated")
            }
        }
    }
    
    
    
}
