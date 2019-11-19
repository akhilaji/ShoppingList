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
import FirebaseStorage

class PicturesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let db = Firestore.firestore()
    var imagesArray = [UIImage]()
    let picker = UIImagePickerController()
    var id = 0
    
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
        let data = savedImage?.jpegData(compressionQuality: 1.0)
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(imageName)
        var URL = ""
        
        PicturesViewController.uploadImage(savedImage!, at: imageReference) { (output) in
            
            guard let output = output else {return}
            do{
               self.db.collection("UserImages").document(try String(contentsOf: output)).setData(["URL": try String(contentsOf: output)])
            }catch{
                print("Exception Caught")
            }
            
            self.id += 1
        }
     
        self.pictureTable.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    //    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
    //        let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
    //        if let uploadData = savedImage?.jpegData(compressionQuality: 1.0) {
    //            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
    //                if error != nil {
    //                    print("error")
    //                    completion(nil)
    //                } else {
    //
    //                    storageRef.downloadURL(completion: { (url, error) in
    //
    //                        print(url?.absoluteString)
    //                        completion(url?.absoluteString)
    //                    })
    //                    //completion((metadata?.downloadURL().absoluteString)!))
    //                    //your uploaded photo url.
    //
    //
    //
    //                }
    //            }
    //        }
    //    }
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 1.0) else{
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil, completion: { (metadata, err) in
            
            if let err = err{
                assertionFailure(err.localizedDescription)
                return completion(nil)
            }
            
            reference.downloadURL(completion: { (url, err) in
                if let err = err{
                    assertionFailure(err.localizedDescription)
                    return completion(nil)
                }
                
                completion(url)
            })
        })
    }
    
}
