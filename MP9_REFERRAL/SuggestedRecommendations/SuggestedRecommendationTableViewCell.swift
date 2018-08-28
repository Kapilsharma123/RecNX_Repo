//
//  SuggestedRecommendationTableViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 18/07/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class SuggestedRecommendationTableViewCell: UITableViewCell {

    @IBOutlet weak var BtnAccept: UIButton!
    
    @IBOutlet weak var cellCollectionView: UICollectionView!
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var recommendedBy: UILabel!
    
    @IBOutlet weak var labelBusinessAndCatName: UILabel!
    
   
    @IBOutlet weak var viewOfferDetail: UIView!
    
    @IBOutlet weak var labelBusinessNameOffer: UILabel!
    
    @IBOutlet weak var labelOfferName: UILabel!
    
    @IBOutlet weak var labelOfferDesc: UILabel!
    
    @IBOutlet weak var labelActualPrice: UILabel!
    
    @IBOutlet weak var labelDiscountPrice: UILabel!
    
    @IBOutlet weak var labelExpiryDate: UILabel!
    
    @IBOutlet weak var heightConstraintCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var labelComment: UILabel!
    
    @IBOutlet weak var labelSetComment: UILabel!
    
    @IBOutlet weak var heightConstLabelComment: NSLayoutConstraint!
    
    @IBOutlet weak var verticalGapBtwnSetCoommentAndBottomBtn: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellView.layer.cornerRadius = 10.0
        self.cellView.clipsToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
