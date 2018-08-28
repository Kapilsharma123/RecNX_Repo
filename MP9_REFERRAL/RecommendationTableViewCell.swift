//
//  RecommendationTableViewCell.swift
//  MP9_REFERRAL
//
//  Created by macrew on 02/08/18.
//  Copyright © 2018 macrew. All rights reserved.
//

import UIKit
protocol ClassRecommendationTableDelegate: class {
    func setTheRating(index : Int , rating : Int)
}
class RecommendationTableViewCell: UITableViewCell {

    weak var delegate: ClassRecommendationTableDelegate?
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var viewStars: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func ActionRatingButtons(_ sender: UIButton) {
        
        
        delegate?.setTheRating(index: self.tag,rating: sender.tag)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
