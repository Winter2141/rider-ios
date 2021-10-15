//
//  SignUPViewController.swift
//  TranxitUser
//
//  Created by IndianRenters on 28/08/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth

class SignUPViewController: UIViewController , UITextFieldDelegate{
    //    @IBOutlet private var textFieldEmail : HoshiTextField!
    //     @IBOutlet private var textFieldName : HoshiTextField!
    //    @IBOutlet private var textFieldPassword : HoshiTextField!
    private var changedImage : UIImage?
   
    @IBOutlet private var textFieldEmail : UITextField!
    @IBOutlet private var textFieldPassword : UITextField!
    @IBOutlet private var textFieldFullName : UITextField!
    @IBOutlet private var imgCircel : UIImageView!

    let limitPhone = 10
    
   
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
     let reach = NetworkReachabilityManager ()
    var registeredNumber : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
//        ChangeTintColor (strImage : "back-icon" , imageView : self.imgBackButton, color : UIColor.white)
//        PlaceholderSizeAndColor(color : UIColor.lightGray , size : 12.0 , font : "Ubuntu-Regular" , textFieldname : textFieldPhone , title : "Phone Number")
//        PlaceholderSizeAndColor(color : UIColor.lightGray , size : 12.0 , font : "Ubuntu-Regular" , textFieldname : textFieldFirstName , title : "First Name")
//        PlaceholderSizeAndColor(color : UIColor.lightGray , size : 12.0 , font : "Ubuntu-Regular" , textFieldname : textFieldLastName , title : "Last Name")
//        PlaceholderSizeAndColor(color : UIColor.lightGray , size : 12.0 , font : "Ubuntu-Regular" , textFieldname : textFieldPassword , title : "Password")
//        PlaceholderSizeAndColor(color : UIColor.lightGray , size : 12.0 , font : "Ubuntu-Regular" , textFieldname : textFieldConfirmPassword , title : "Confirm Password")
        
        
        
        //SET IMAGE
        imgColor(img: imgCircel, colorHex: Constants.BLACK_COLOUR)

        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillAppear() {
        //Do something here
       // self.bottomToScroll.constant = 300
    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
       // self.bottomToScroll.constant = 28
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    
    @IBAction func BtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    //MARK:- Sign up button action
    @IBAction func btnSignUpNow(_ sender: Any) {
        guard let fullName = self.textFieldFullName.text, fullName.count>0 else {
            
            showAlert(message: "\(ErrorMessage.list.enterFirstName.localize())", okHandler: nil, fromView: self)
            return
        }

        guard let password = self.textFieldPassword.text, password.count>0 else {
            
            showAlert(message: "\(ErrorMessage.list.enterPassword.localize())", okHandler: nil, fromView: self)
            return
        }
        guard  let emailText = self.textFieldEmail.text, !emailText.isEmpty else {
            showAlert(message: "\( ErrorMessage.list.enterEmail)", okHandler: nil, fromView: self)
         
                self.textFieldEmail.becomeFirstResponder()
            
            return
        }
        
        guard Common.isValid(email: emailText) else {
            showAlert(message: "\(ErrorMessage.list.enterValidEmail)", okHandler: nil, fromView: self)
           
            self.textFieldEmail.becomeFirstResponder()
            
            return
        }
        
        let withDrawDetail = self.storyboard?.instantiateViewController(withIdentifier:"EnterMobileNoVC") as! EnterMobileNoVC
        withDrawDetail.screenFrom = "signup"
        withDrawDetail.fullName = fullName
        withDrawDetail.strPassword = password
        withDrawDetail.strEmail = emailText
        withDrawDetail.checkLoginStatus = "signup"
        self.navigationController?.pushViewController(withDrawDetail, animated: true)

    }
    
    func RegisterUser(number : String)
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.signUp.rawValue)"
        let param = ["email" : self.textFieldEmail.text ?? "", "first_name" : self.self.textFieldFullName.text ?? "" , "password" : self.textFieldPassword.text ?? "" , "last_name" : "" , "mobile" : number , "device_type" : DeviceType.ios.rawValue , "device_id" : UUID().uuidString , "device_token" : "\(deviceTokenString)" , "login_by" : LoginType.manual.rawValue] as [String : Any]
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.LoginUser()
                }
                
            }
            else
            {
                self.loader.isHidden = true
                let arrayValues = result?.allValues as NSArray?
                if (arrayValues?.count ?? 0) > 0
                {
                    print("array values\(arrayValues!)")
                    let responseMessageArray = arrayValues?[0] as? [String] ?? []
                    if responseMessageArray.count > 0
                    {
                    showAlert(message: responseMessageArray[0], okHandler: nil, fromView: self)
                    }
                    else
                    {
                    }
                }
            }
        }

    }
    
    func LoginUser()
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.login.rawValue)"
        let param = ["username" : self.textFieldEmail.text ?? "", "client_id" : appClientId, "password" : self.textFieldPassword.text ?? "" , "client_secret" : appSecretKey , "grant_type" : WebConstants.string.password , "device_type" : DeviceType.ios.rawValue , "device_id" : UUID().uuidString , "device_token" : "\(deviceTokenString)" , "scope" : ""] as [String : Any]
        
        
        UIPasteboard.general.string = "\(deviceTokenString)"
        
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                }
                User.main.accessToken = result?["access_token"] as? String ?? ""
                User.main.refreshToken = result?["refresh_token"] as? String ?? ""
                self.loader.isHidden = false
                self.presenter?.get(api: .getProfile, parameters: nil)
                
            }
            else
            {
                self.loader.isHidden = true
                let arrayValues = result?.allValues as NSArray?
                if (arrayValues?.count ?? 0) > 0
                {
                    print("array values\(arrayValues!)")
                    let responseMessageArray = arrayValues?[0] as? [String] ?? []
                    if responseMessageArray.count > 0
                    {
                        showAlert(message: responseMessageArray[0], okHandler: nil, fromView: self)
                    }
                    else
                    {
                        if (arrayValues?[0] as? String != nil && arrayValues?[0] as? String != nil)
                        {
                            showAlert(message: arrayValues?[0] as? String ?? "", okHandler: nil, fromView: self)
                        }
                        else
                        {
                            //                            showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
                        }
                        
                    }
                }
                else
                {
                    //                    showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
                }
                
                
            }
            
        }
        
    }

    
}
//MARK:- PostViewProtocol

extension SignUPViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        let alert = showAlert(message: message)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {
                self.loader.isHidden = true
            })
        }
        
    }
    func getProfile(api: Base, data: Profile?) {
        
        guard data != nil  else { return  }
        Common.storeUserData(from: data)
        storeInUserDefaults()
        self.loader.isHidden = true
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vcPointTitles =
            storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vcPointTitles, animated: true)
        
    }
    
}



