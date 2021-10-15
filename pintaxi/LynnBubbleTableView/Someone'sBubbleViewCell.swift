//
//  Someone'sBubbleViewCell.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import UIKit

class Someone_sBubbleViewCell: MyBubbleViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lbNick: UILabel!
    @IBOutlet weak var img_Bg: UIImageView!
    
    @IBOutlet weak var constraintForNickHidden: NSLayoutConstraint! // default 24 when hidden set 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.imgProfile.layer.cornerRadius = 21.5
        self.imgProfile.clipsToBounds = true
        
        let profileTapped = UITapGestureRecognizer(target: self, action: #selector(actProfile(sender:)))
        profileTapped.delegate = self
        profileTapped.numberOfTapsRequired = 1
        self.imgProfile?.addGestureRecognizer(profileTapped)
        
       // self.img_Bg.layer.cornerRadius = (self.view_base.frame.height/2)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.img_Bg.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight,
//            UIRectCorner.bottomLeft], radius: self.img_Bg.frame.height/2)
//        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setBubbleData(data:LynnBubbleData, grouping:Bool, showNickName:Bool) {
        
        self.imgProfile.isHidden = grouping
        
        if grouping {
            self.constraintForNickHidden.constant = 0
        }else{
            if showNickName {
                self.constraintForNickHidden.constant = 24
            }else{
                self.constraintForNickHidden.constant = 0
            }
        }
        
        self.setBubbleData(data: data)
    }
    
    override func setBubbleData(data: LynnBubbleData) {
        
        super.setBubbleData(data: data)
        
        self.imgProfile.image = data.userData.userProfileImage
        self.lbNick.text = data.userData.userNickName
        
        self.img_Bg?.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: (self.img_Bg?.frame.height)!/2)
        
    }
    @objc func actProfile(sender : UIGestureRecognizer){
        self.gestureTarget?.userProfilePressed(cell: self)
    }
    
}

