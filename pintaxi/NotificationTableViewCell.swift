//
//  NotificationTableViewCell.swift
//  Provider
//
//  Created by Sravani on 08/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NotifImage: UIImageView!
    @IBOutlet weak var notifHeaderLbl: UILabel!
    @IBOutlet weak var notifContentLbl: UILabel!
    @IBOutlet weak var NitifView: UIView!
    @IBOutlet weak var readMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        setViewShadow(myView: NitifView)
//        self.setdesign()
    }
    
    
    func setViewShadow(myView : UIView) {
        //SER CONFIRM REQUEST
        myView.layer.shadowPath =
            UIBezierPath(roundedRect: myView.bounds,
                         cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.2
        myView.layer.shadowOffset = CGSize(width: 2, height: 2)
        myView.layer.shadowRadius = 5
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = 10
    }
    
    func setdesign() {
        self.NitifView.layer.borderWidth = 1.5
        self.NitifView.layer.borderColor = UIColor.gray.cgColor
        Common.setFont(to: notifHeaderLbl, isTitle: false, size: 17)
        Common.setFont(to: notifContentLbl, isTitle: false, size: 14)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

