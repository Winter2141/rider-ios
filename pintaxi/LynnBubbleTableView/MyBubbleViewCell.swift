//
//  MyBubbleViewCell.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import UIKit

class MyBubbleViewCell: UITableViewCell {
    
    @IBOutlet weak var lbText: UILabel?
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var view_base: UIView!
    weak var gestureTarget:BubbleViewCellEventDelegate?
    
  
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
      
        self.selectionStyle = .none
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:)))
        longPressed.delegate = self
        self.lbText?.addGestureRecognizer(longPressed)
        
       // self.view_base.layer.cornerRadius = 25// (self.view_base.frame.height/2)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.view_base.roundCorners(corners: [.topLeft, UIRectCorner.topRight,
//            UIRectCorner.bottomLeft], radius: self.view_base.frame.height/2)
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setBubbleData(data:LynnBubbleData) {
        
        self.lbText!.text = data.text
     
        self.lbTime.text = data.userData.msgTime
       
       // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.view_base?.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: (self.view_base?.frame.height)!/2)
       // }
        
    }
    
    @objc func longTap(sender : UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
            self.gestureTarget?.textLongPressed(cell: self)
//            self.gestureTarget?.textLongPressed?(cell:self, text:self.lbText!.text!)
        }
    }
    
//    func textLongPressed() {
//        
//    }
    
}
