//
//  helpViewController.swift
//  User
//
//  Created by CSS on 08/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import MessageUI

class HelpViewController: BaseViewController {
    @IBOutlet var imgCall : UIImageView!
    @IBOutlet var imgChat : UIImageView!
    @IBOutlet var imgWeb : UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imgColor(img: imgCall, colorHex: Constants.BLACK_COLOUR)
        imgColor(img: imgChat, colorHex: Constants.BLACK_COLOUR)
        imgColor(img: imgWeb, colorHex: Constants.BLACK_COLOUR)
        
        loadGoogleAdmob()
        
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
          return UIStatusBarStyle.lightContent
      }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCallSupport(_ sender: Any) {
        self.callNumber(phoneNumber: "+91-882-660-5937")
    }
    
    @IBAction func btnChatSupport(_ sender: Any) {
        
        if let url = URL(string: "https://tawk.to/chat/592f3203b3d02e11ecc67ae4/default?$_tawk_sk=5d80ed8f8d291605571e7736&$_tawk_tk=2db32880f475d74b61060c784ddf955f&v=679") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        
        
    }
    
    @IBAction func btnOpenUrl(_ sender: Any) {
        if let url = URL(string: "https://pintaxi.xyz") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    
    
    
}
