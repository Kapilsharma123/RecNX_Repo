//
//  OfferDetailTableViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 09/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class OfferDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var labelOfferName: UILabel!
    
    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var labelActualPrice: UILabel!
    
    @IBOutlet weak var labelDiscountedPrice: UILabel!
    
    @IBOutlet weak var labelPostEndDate: UILabel!
    
    @IBOutlet weak var BtnAccept: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
