//
//  HistoryTableViewCell.swift
//  TranxitUser
//
//  Created by 99appdev on 27/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCancelled: UIImageView!
    @IBOutlet weak var lblSourceLocationText: UILabel!
    
    @IBOutlet weak var lblSourceLocationValue: UILabel!
    @IBOutlet weak var lblDAte: UILabel!
    @IBOutlet weak var imgAddressLine: UIImageView!
    @IBOutlet weak var lblDestinationLocationValue: UILabel!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var viewpickup: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
}
}
