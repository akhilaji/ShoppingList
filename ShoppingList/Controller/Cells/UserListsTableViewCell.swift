//
//  UserListsTableViewCell.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/1/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit

class UserListsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var listName: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
