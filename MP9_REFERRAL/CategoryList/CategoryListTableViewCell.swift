//
//  CategoryListTableViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 17/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCategoryName: UIView!
    
    @IBOutlet weak var imgCatBG: UIImageView!
    
    @IBOutlet weak var labelCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewCategoryName.layer.cornerRadius = 8.0
        self.viewCategoryName.clipsToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
