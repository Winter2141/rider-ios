//
//  StatusTypeView.swift
//  TranxitUser
//
//  Created by IndianRenters on 04/11/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class StatusTypeView: UIView {
    
    @IBOutlet private weak var driverBtn : UIButton!
    @IBOutlet private weak var locationStatusBtn : UIButton!
    @IBOutlet private weak var carStutasBtn : UIButton!
    @IBOutlet private weak var completeBtn : UIButton!
    
    @IBOutlet private weak var driverAcceptView : UIView!
    @IBOutlet private weak var driverArrivedView : UIView!
    @IBOutlet private weak var onRideView : UIView!
    @IBOutlet private weak var completeView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    func statusType(strType:String){
        if strType == "STARTED" {
            driverAcceptView.isHidden = false
            driverArrivedView.isHidden = true
            onRideView.isHidden = true
            completeView.isHidden = true
        }
        else if strType == "ARRIVED"{
            driverAcceptView.isHidden = true
            driverArrivedView.isHidden = false
            onRideView.isHidden = true
            completeView.isHidden = true
        }
        else if strType == "PICKEDUP"{
            driverAcceptView.isHidden = true
            driverArrivedView.isHidden = true
            onRideView.isHidden = false
            completeView.isHidden = true
        }
        else if strType == "DROPPED"{
            driverAcceptView.isHidden = true
            driverArrivedView.isHidden = true
            onRideView.isHidden = true
            completeView.isHidden = false
            
        }
    }

}

extension StatusTypeView {
    
    private func initialLoads() {
        //statusView.frame.origin.y = self.completeBtn.center.y
        //slideY(yy: self.completeBtn.frame.origin.y)
       // statusView.center = CGPoint(x: 22, y: self.completeBtn.frame.origin.y)
    }
    
    func slideY(yy:CGFloat) {
//        let xPosition = self.statusView.frame.origin.x
//        let yPosition = self.statusView.frame.origin.y
//        let height = self.statusView.frame.height
//        let width = self.statusView.frame.width
//        UIView.animate(withDuration: 1.0, animations: {
//            self.statusView.frame = CGRect(x: xPosition, y: yPosition + yy, width: width, height: height)
//            self.popView.addSubview(self.statusView!)
//        })
        
    }
        
}

