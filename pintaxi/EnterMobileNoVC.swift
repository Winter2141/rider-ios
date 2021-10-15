//
//  EnterMobileNoVC.swift
//  Clykk
//
//  Created by Deepak Jain on 08/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class EnterMobileNoVC: UIViewController, UITextFieldDelegate, countryPickDelegate {

    var str_langCode = ""
    var screenFrom = ""
    var strEmail = ""
    var strPassword = ""
    var fullName = ""
    var checkLoginStatus = ""
    var accessTokenStr :String = ""
    var social_mediaId:String = ""
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_MobileBG: UIView!
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_countryCode: UILabel!
    @IBOutlet weak var txt_Mobile: UITextField!
    @IBOutlet weak var btnLoginSignup: UIControl!
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.loader.isHidden = true
        
        self.txt_Mobile.addDoneToolbar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let strPhoneCode = getCountryPhonceCode(countryCode)
            self.img_flag.image = UIImage.init(named: "\(countryCode).png")
            self.lbl_countryCode.text = "+\(strPhoneCode)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loader.isHidden = true
    }
    
    // MARK:- KEYBOARD METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        let userinfo:NSDictionary = (notification.userInfo as NSDictionary?)!
        if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //self.constraint_viewBottom.constant = keybordsize.height/4
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //self.constraint_viewBottom.constant = 0
        self.view.layoutIfNeeded()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func firebase_Auth() {
        let strCountryCode = self.lbl_countryCode.text ?? ""
        let strMobileNumbr = self.txt_Mobile.text ?? ""
        if strCountryCode.count > 0 && strMobileNumbr.count > 0 {
            let number = strCountryCode + strMobileNumbr

            self.loader.isHidden = false

            PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
                self.loader.isHidden = true
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")

                //ShowProgressHud(message: AppMessage.plzWait)
                if error != nil {
                  //  DismissProgressHud()
                    print("Error while sending confirmation code = \(error?.localizedDescription ?? "")")
                    
                    showAlert(message: error?.localizedDescription ?? "", okHandler: nil, fromView: self)

                    
                   // showSingleAlert(Title: "", Message: "\(error?.localizedDescription ?? "")", buttonTitle: AppMessage.Ok, completion: {
//                    })
                    return
                } else {
                    print("Confirmation code did sent  = \(verificationID ?? "")")
                   if verificationID != nil {
                      //  DismissProgressHud()
                        let objOTP = self.storyboard?.instantiateViewController(withIdentifier: "EnterOTPVC") as! EnterOTPVC
                        objOTP.strMobileNo = number
                        objOTP.strCountryCode = strCountryCode
                        objOTP.strEmail = self.strEmail
                        objOTP.strPassword = self.strPassword
                        objOTP.screenFrom = self.screenFrom
                        objOTP.password = self.strPassword
                        objOTP.email = self.strEmail
                        objOTP.fullName = self.fullName
                        objOTP.accessTokenStr = self.accessTokenStr
                        objOTP.social_mediaId = self.social_mediaId
                        objOTP.checkLoginStatus = self.checkLoginStatus
                        objOTP.verificationID = verificationID ?? ""
                        self.navigationController?.pushViewController(objOTP, animated: true)
                    }
                }
            }
            
        }
    }
    
    
    //MARK: - UIButton Action
    @IBAction func btncountrycode_Action(_ sender: UIButton) {
        let objCountry = self.storyboard?.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        objCountry.delegate = self
        self.navigationController?.pushViewController(objCountry, animated: true)
    }
    
    
    @IBAction func btnLoginSign_Action(_ sender: UIControl) {

        let str_Mobile = self.txt_Mobile.text ?? ""
        if str_Mobile == "" {
            showAlertMessage(titleStr: "Mobile Number", messageStr: "Please enter mobile number.")
        }
        else {
            self.firebase_Auth()
        }
    }
    
    
    
    //MARK: - Picked Country
    func selectCountry(screenFrom: String, is_Pick: Bool, selectedCountry: CountryCode?) {
        self.img_flag.image = selectedCountry?.flag
        self.str_langCode = selectedCountry?.code ?? ""
        self.lbl_countryCode.text = selectedCountry?.phoneCode ?? "+1"
        self.txt_Mobile.becomeFirstResponder()
    }
    
    //MARK: - UITextfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString

        let ACCEPTABLE_NUMBERS = "1234567890"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if string != filtered {
            return false
        }
        return newString.length <= 15
    }
    
    
}

