//
//  SuggestedCollectionViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 15/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class SuggestedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelQueName: UILabel!
    
    @IBOutlet weak var leadingConstLabelQuesName: NSLayoutConstraint!
    
    
    @IBOutlet weak var labelrating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
