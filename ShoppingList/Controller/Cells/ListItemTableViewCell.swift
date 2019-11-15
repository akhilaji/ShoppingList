//
//  ListItemTableViewCell.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/3/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//

import Foundation
import UIKit

class ListItemTableViewCell: UITableViewCell{

    @IBOutlet weak var itemName: UILabel!
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

