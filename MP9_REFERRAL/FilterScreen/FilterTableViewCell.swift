//
//  FilterTableViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 18/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var imgCheckMark: UIImageView!
    
    @IBOutlet weak var Button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewCell.layer.cornerRadius = 8.0
        self.viewCell.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
