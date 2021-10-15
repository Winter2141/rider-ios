//
//  ReviewTableViewCell.swift
//  TranxitUser
//
//  Created by 99appdev on 26/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var RatingView: HCSStarRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
