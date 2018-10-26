//
//  ArticlesTableViewCell.swift
//  IOS-Exercise
//
//  Created by Lama Alashed on 23/10/2018.
//  Copyright © 2018 Lama Alashed. All rights reserved.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
