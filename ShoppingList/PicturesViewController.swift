//
//  PicturesViewController.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/5/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PicturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    let db = Firestore.firestore()
    var imagesArray = [UIImage]()
    let picker = UIImagePickerController()
    
    var savedImage:UIImage?
    @IBOutlet weak var pictureTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(imagesArray.count)
        return imagesArray.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureViewCell", for: indexPath) as! PictureViewCell
        let item = imagesArray[indexPath.row]
        cell.picture.image = item
        return cell
    }
    
    @IBAction func addImage(_ sender: Any) {
        //let picker = UIImagePickerController()
        
        let alert = UIAlertController(title: "Add Images", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take Picture", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
                
            } else {
                print("The Camera is Unavailable")
            }
        })
        
        let photoLibraryAction = UIAlertAction(title: "Camera Roll", style: .default, handler: { action in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
        })
        
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        
        self.present(alert, animated: true, completion: nil)
        
        self.pictureTable.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        savedImage = selectedImage
        imagesArray.append(savedImage!)
        self.pictureTable.reloadData()

        dismiss(animated: true, completion: nil)
     }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }

    
    
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let yourPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imagesArray.append(yourPickedImage)
//            self.pictureTable.reloadData()
//        }
//        dismiss(animated: true, completion: nil)
//    }
//
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {self.dismiss(animated: true, completion: nil)
//    }

    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        savedImage = image
//        dismiss(animated: true, completion: nil)
//        //var data = NSData()
//        imagesArray.append(savedImage!)
//        self.pictureTable.reloadData()
//
//    }
//
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

    
}
