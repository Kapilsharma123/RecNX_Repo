//
//  SubCatTableViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 13/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class SubCatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewINsideCell: UIView!
    
    @IBOutlet weak var labelSubCatName: UILabel!
    
    @IBOutlet weak var imgCheckBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
