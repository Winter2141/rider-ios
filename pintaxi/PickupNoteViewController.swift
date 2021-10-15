//
//  PickupNoteViewController.swift
//  TranxitUser
//
//  Created by khatri Jigar on 05/12/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire


class PickupNoteViewController: UIViewController ,ServerCommunicationApiDelegate{
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var imgSend: UIImageView!
    var requestId : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillLayoutSubviews() {
        imgColor(img: imgSend, colorHex: "FFFFFF")
        viewSend.layer.masksToBounds = true
        viewSend.layer.cornerRadius = viewSend.frame.size.height / 2

        self.setViewShadow(myView: self.viewText)

    }
    override func viewLayoutMarginsDidChange() {

    }
    
    func setViewShadow(myView : UIView) {
        //SER CONFIRM REQUEST
        myView.layer.shadowPath =
            UIBezierPath(roundedRect: myView.bounds,
                         cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.2
        myView.layer.shadowOffset = CGSize(width: 0, height: 1)
        myView.layer.shadowRadius = myView.frame.size.height / 2
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendNoteClicked(_ sender: Any) {
        if txtNote.text == "" {
            showAlert(message: "Please enter note.", okHandler: nil, fromView: self)
            
        }else{
            self.navigationController?.popViewController(animated: true)

            
//            let url =  "\(baseUrl)\(Base.addCard.rawValue)"
//            let params:Parameters = ["special_note": txtNote.text ?? "",
//                                     "request_id" : requestId]
//            let network = NetworkHelper()
//            network.delegate = self
//            
//            network.getDataFromUrlWithAccessPOST(url: url, requestName: Base.addCard.rawValue, headerField: "", parameter: params)
        }
    }
    
    
    
    //MARK:- Receive Service Methods
    func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func dataFailure(error: String, requestName: String) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
        }
       // showAlert(message: error, okHandler: nil, fromView: self)
        // self.showAlertMessage(titleStr:"Quick Ride User", messageStr:error)
        print(error)
    }
    
    
}
