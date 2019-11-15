//
//  PictureViewCell.swift
//  ShoppingList
//
//  Created by Akhil Aji on 11/5/19.
//  Copyright © 2019 Akhil Aji. All rights reserved.
//


import Foundation
import UIKit

class PictureViewCell: UITableViewCell{
    @IBOutlet weak var picture: UIImageView!
    override func awakeFromNib(){
        super.awakeFromNib()
        picture.layer.cornerRadius = 20
        picture.clipsToBounds = true
        
        picture.layer.shadowColor = UIColor.black.cgColor
        picture.layer.shadowOffset = CGSize(width:0.5, height:4.0);
        picture.layer.shadowOpacity = 0.5
        picture.layer.shadowRadius = 5.0 //Here your control your blur
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
