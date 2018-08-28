//
//  PostedSurveyDetailTableViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 09/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit

class PostedSurveyDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelCategory: UILabel!
    
    @IBOutlet weak var labelSubCategory: UILabel!
    
    @IBOutlet weak var labelBusinessName: UILabel!
    
    @IBOutlet weak var BtnBusinessName: UIButton!
    
    @IBOutlet weak var heightConstBusinessName: NSLayoutConstraint!
    
    @IBOutlet weak var BtnViewNow: UIButton!
    
    @IBOutlet weak var labelPostDate: UILabel!
    
    @IBOutlet weak var labelEndDate: UILabel!
    
    @IBOutlet weak var viewInsideZCell: UIView!
    
    
    
    @IBOutlet weak var labelNoOfRecomm: UILabel!
    
    @IBOutlet weak var labelCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
