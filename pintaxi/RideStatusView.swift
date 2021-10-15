//
//  RideStatusView.swift
//  User
//
//  Created by CSS on 23/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import FloatRatingView
class RideStatusView: UIView {
    
    //MARK :- IBOutlets
    @IBOutlet private weak var imageViewProvider : UIImageView!
    @IBOutlet private weak var labelProviderName : UILabel!
    @IBOutlet private weak var lblSourceAddress : UILabel!
    @IBOutlet private weak var lblDisAddress : UILabel!
    @IBOutlet private weak var viewRating : FloatRatingView!
    @IBOutlet private weak var imageViewService : UIImageView!
    @IBOutlet private weak var lblDistance : UILabel!
    @IBOutlet private weak var lblTime : UILabel!
    @IBOutlet private weak var btnNote : UIButton!

    @IBOutlet private weak var viewMain : UIView!
    @IBOutlet private weak var cancelButton : UIButton!

    // Mark:- Local variable
    
    private var request : Request?
    var onClickPickupNote : (()->Void)?
    var onClickCancel : (()->Void)?
    var onClickShare : (()->Void)?
    var onChatView : ((Int, Int)->Void)?
    private var currentStatus : RideStatus = .none {
        didSet{
            DispatchQueue.main.async {
                if [RideStatus.started, .accepted, .arrived].contains(self.currentStatus) {
                    self.cancelButton.setTitleColor(UIColor.red, for: .normal)
                    self.cancelButton.setTitle("Cancel Ride", for: .normal) //self.buttonCancel.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
                } else {
                    self.cancelButton.setTitleColor(UIColor.green, for: .normal)
                   self.cancelButton.setTitle("Share", for: .normal) //self.buttonCancel.setTitle(Constants.string.shareRide.localize().uppercased(), for: .normal)
                }
            }
        }
    }
    
    private var isOnSurge : Bool = false {
        didSet {
           // self.constraintSurge.constant = isOnSurge ? 30 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imageViewProvider.makeRoundedCorner()
    }
}

//MARK:- Local methods

extension RideStatusView {
    func setViewShadow(myView : UIView) {
        //SER CONFIRM REQUEST
        myView.layer.shadowPath =
            UIBezierPath(roundedRect: myView.bounds,
                         cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.3
        myView.layer.shadowOffset = CGSize(width: 0, height: 1)
        myView.layer.shadowRadius = myView.frame.size.height / 2
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = 10
        
    }
    
    private func initialLoads() {
        self.initRating()
        self.localize()
//        self.buttonCall.addTarget(self, action: #selector(self.callAction), for: .touchUpInside)
//        self.buttonCancel.addTarget(self, action: #selector(self.cancelShareAction), for: .touchUpInside)
        self.setDesign()
        
        //        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        //        self.addGestureRecognizer(gesture)
        //        gesture.delegate = self
    }
    
    /*    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
     
     if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
     
     let translation = gestureRecognizer.translation(in: self.view)
     print(gestureRecognizer.view!.center.y)
     
     if(gestureRecognizer.view!.center.y < 555) {
     
     gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
     
     }else {
     gestureRecognizer.view!.center = CGPoint(x:gestureRecognizer.view!.center.x, y:554)
     }
     gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
     }
     } */
    
    
    //  Set Designs
    
    private func setDesign() {
        DispatchQueue.main.async {
        }
//        Common.setFont(to: labelETA, isTitle: true)
//        Common.setFont(to: labelOtp, isTitle: true)
//        Common.setFont(to: labelTopTitle)
//        Common.setFont(to: labelServiceName)
//        Common.setFont(to: labelProviderName)
//        Common.setFont(to: labelServiceNumber)
//        Common.setFont(to: labelSurgeDescription)
//        Common.setFont(to: labelServiceDescription)
//        Common.setFont(to: buttonCancel, isTitle: true)
//        Common.setFont(to: buttonCall, isTitle: true)
        
    }
    
    //  Localization
    private func localize() {
//        self.labelSurgeDescription.text = Constants.string.peakInfo.localize()
//        self.buttonCall.setTitle(Constants.string.call.localize().uppercased()
//            , for: .normal)
//        self.buttonCancel.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
    }
    
    //  Rating
    private func initRating() {
        
//        viewRating.fullImage = #imageLiteral(resourceName: "StarEmpty")
//        viewRating.emptyImage = #imageLiteral(resourceName: "start-unfilled")
//        viewRating.minRating = 0
//        viewRating.maxRating = 5
//        viewRating.rating = 0
//        viewRating.editable = false
//        viewRating.minImageSize = CGSize(width: 3, height: 3)
//        viewRating.floatRatings = true
//        viewRating.contentMode = .scaleAspectFit
    }
    
    
    func setETA(time : String , duration : String){
        lblDistance.text = time
        lblTime.text = duration
    }
    
    //  Set Values
    func set(values : Request) {
        
        self.request = values
        self.currentStatus = values.status ?? .none

        //SET NAME DETAILS
        Cache.image(forUrl: Common.getImageUrl(for: "\(baseUrl)/\(values.provider?.avatar ?? "")")) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageViewProvider.image = image
                }
            }
        }
        
        Cache.image(forUrl: "\(baseUrl)/\(values.service?.image ?? "")") { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageViewService.image = image
                }
            }
        }
        
        
        self.labelProviderName.text = String.removeNil(values.provider?.first_name)
//        self.viewRating.rating = 3.0
        self.viewRating.rating = Double(values.provider?.rating ?? "0") ?? 0
        lblSourceAddress.text = values.s_address
        lblDisAddress.text = values.d_address
        
        lblDistance.text = "0.0Km"
        lblTime.text = "0 min"
        self.isOnSurge = values.surge == 1
    }
    
    //  Call Provider
    @IBAction private func btn() {

    }
    @IBAction private func callAction() {
        
        Common.call(to: request?.provider?.mobile)
        
    }
    
    @IBAction private func chatAction() {
        self.onChatView?(request?.provider?.id ?? 0 , request?.id ?? 0)

        
    }
    @IBAction private func btnPickuNoteClicked() {
        self.onClickPickupNote?()
        
    }
    
    //  Cancel Share Action
    
    @IBAction private func cancelShareAction() {
        
        if let status = request?.status,[RideStatus.accepted, .started, .arrived].contains(status) {
            self.onClickCancel?()
        } else {
            self.onClickShare?()
        }
    }
}

// Mark:-FloatyDelegate

extension RideStatusView : FloatyDelegate {
    
    func floatyWillOpen(_ floaty: Floaty) {
        print("Clocked")
    }
    
}
