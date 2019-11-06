//
//  AddListItemViewController.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/5/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit

class AddListItemViewController: UIViewController{
    
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
    }
    
    @IBAction func add(_ sender: Any) {
    }
}
