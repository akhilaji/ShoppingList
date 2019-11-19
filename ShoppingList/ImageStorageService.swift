//
//  ImageStorageService.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/17/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct ImageStorageService{
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


