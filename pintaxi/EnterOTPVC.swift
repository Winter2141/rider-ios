//
//  EnterOTPVC.swift
//  Cotasker
//
//  Created by Zignuts Technolab on 22/10/19.
//  Copyright © 2019 Pearl Inc. All rights reserved.
//

import UIKit
import SVPinView
import Firebase
import Alamofire
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
//import Google

protocol SuccessDelegate {
    func onSuccessWithPhone(mobileNumber:String,code:String)
}

class EnterOTPVC: UIViewController, UITextFieldDelegate {
    
    var strEmail = ""
    var strPassword = ""
    var fullName :String = ""
    var password : String = ""
    var email : String = ""
    var accessTokenStr:String = ""
    var social_mediaId:String = ""
    var full_name:String = ""
    var screenFrom = ""
    var str_enteredOTP = ""
    var strMobileNo = ""
    var strCountryCode = ""
    var verificationID = ""
    var checkLoginStatus = ""
    var fromStr:String = String()
    var delegate:SuccessDelegate?
    @IBOutlet weak var pinView: SVPinView!
    
    
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePinView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:- KEYBOARD METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        let userinfo:NSDictionary = (notification.userInfo as NSDictionary?)!
        if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.view.layoutIfNeeded()
    }
    
    func configurePinView() {
        
        pinView.style = .underline
        pinView.pinLength = 6
        pinView.interSpace = 5
        pinView.placeholder = ""
        pinView.borderLineThickness = 1
        pinView.keyboardType = .phonePad
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.secureCharacter = "\u{25CF}"
        pinView.activeBorderLineThickness = 1
        pinView.becomeFirstResponderAtIndex = 0
        pinView.borderLineColor = UIColor.lightGray
        pinView.fieldBackgroundColor = UIColor.white
        pinView.activeBorderLineColor = UIColor.lightGray
        pinView.activeFieldBackgroundColor = UIColor.white
        pinView.font = UIFont.systemFont(ofSize: 20)

        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            self.str_enteredOTP = pin
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    
    func didFinishEnteringPin(pin:String) {
        self.str_enteredOTP = pin
    }
    
    

    // MARK: UIButton Action
    @IBAction func btnSubmit_Action(_ sender: UIControl) {
    if self.str_enteredOTP != "" {
       let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: self.str_enteredOTP)
       Auth.auth().signIn(with: credential) { (authData, error) in
       if error != nil {
         showAlertMessage(titleStr: "Error", messageStr: error?.localizedDescription ?? "")
       }else{
         if self.fromStr == "UpdateMobile" {
            self.delegate?.onSuccessWithPhone(mobileNumber: self.strMobileNo, code: self.strCountryCode)
          self.navigationController?.popViewController(animated:true)
        }else{
         self.onLogin()
         }
        }
       }
    }
      else {
        showAlertMessage(titleStr: "OTP", messageStr: "Please enter OTP")
         }
     }
    
    
    func onLogin() {
        if self.screenFrom == "signup" {
         if self.checkLoginStatus == "FB"{
            self.getFBUserData(number: self.strMobileNo)
          }
        else if(self.checkLoginStatus == "google"){
            self.googleSign(accessToken: self.accessTokenStr, social_unique_id: self.social_mediaId, mobile: strMobileNo, fullName: self.full_name, email: self.email)
        }else{
           self.RegisterUser(number: strMobileNo)
        //                    self.userSignUp(fullName:self.fullName, emailId:self.email, passWord: self.password, phoneNumber: strMobileNo)
                        }
                    }
          else {
            if self.checkLoginStatus == "FB"{
                self.getFBUserData(number: self.strMobileNo)
            }else{
              self.googleSign(accessToken: self.accessTokenStr, social_unique_id: self.social_mediaId, mobile: strMobileNo, fullName: self.full_name, email: self.email)
                }
        }
    }

    
    @IBAction func btnResendOTP_Action(_ sender: UIButton) {
    }
    
    
    //MARK:- getFBUserData Facebook Data retrive
    func getFBUserData(number : String)
       {
           let headers = [
               "Content-Type":"application/json",
               "X-Requested-With" : "XMLHttpRequest"
           ]
           self.loader.isHidden = false
           let urlString = "\(baseUrl)\(Base.facebookLogin.rawValue)"
           let param = ["first_name" : fullName, "id" : social_mediaId , "email" : strEmail , "accessToken" :  accessTokenStr, "device_type" : DeviceType.ios.rawValue , "device_id" : UUID().uuidString , "device_token" : "\(deviceTokenString)" , "login_by" : "facebook" , "mobile" : number] as [String : Any]
           Alamofire.request(urlString, method: .post, parameters: param,encoding: JSONEncoding.default, headers: headers).responseJSON {
               response in
               switch response.result {
               case .success:
                   print(response)
                   //   let user = User()
                   if let responseDict =  response.value as? NSDictionary{
                       
                       print("ResponseDict =======\(responseDict)")
                       
                       if let error = responseDict["error"] as? String
                       {
                           showAlert(message: error, okHandler: nil, fromView: self)
                       }
                       else
                       {
                           
                           
                           UserDefaults.standard.set(responseDict["access_token"] as? String ?? "", forKey: "access_token")
                           
                           
                           //self.push(id: Storyboard.Ids.GoingSomewhereViewController, animation: true)
                       }
                   }
                   
                   self.loader.isHidden = true
                   break
               case .failure(let error):
                   self.loader.isHidden = true
                   print(error)
               }
           }
       }

    func googleSign(accessToken:String,social_unique_id:String,mobile:String,fullName:String,email:String){
        
//        let url =  baseUrl+googleLogin // This //will be your link
//        let deviceToken = UserDefaults.standard.string(forKey:"deviceToken")
//        let deviceId = UIDevice.current.identifierForVendor!.uuidString
//        let parameters: Parameters = ["accessToken":accessToken , "device_token":deviceToken ?? "", "device_type":"ios", "device_id":deviceId,"login_by":"google", "social_unique_id":social_unique_id, "mobile":mobile,"password":social_unique_id,"full_name":fullName,"email":email]
//        //This will be your parameter
//        print("GoogleSignUpUrl====\(url)")
//        self.startActivity()
//        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
//            self.stopActivity()
//
//            if  response.result.value == nil{
//                print("No Reponse Found")
//                DispatchQueue.main.async {
//                    self.showAlertMessage(titleStr:customAlert.app_name.rawValue, messageStr: customAlert.something_wrong.rawValue)
//                }
//
//
//            }else{
//
//                if let responseData = response.result.value as? NSDictionary{
//                    print("GoogleSignUpResponse========(\(responseData))")
//                    if let errorStr = (responseData.value(forKey:"error") as? String){
//                        print("Error=====\(errorStr)")
//                        self.showAlertMessage(titleStr:customAlert.app_name.rawValue, messageStr: responseData.value(forKey:"message") as! String)
//                        DispatchQueue.main.async {
//
//                            if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
//                                viewControllers = viewControllers.reversed()
//                                for currentViewController in viewControllers {
//                                    if currentViewController .isKind(of: LoginVC.self) {
//                                        self.navigationController?.popToViewController(currentViewController, animated: true)
//                                        break
//                                    }
//                                }
//                            }
//                        }
//
//                    }else{
//                        let access_token = responseData.value(forKey:"access_token")
//                        let token_type = responseData.value(forKey:"token_type")
//                        let refresh_token = responseData.value(forKey:"refresh_token")
//                        UserDefaults.standard.setValue(access_token, forKey:"access_token")
//                        UserDefaults.standard.setValue(token_type, forKey:"token_type")
//                        UserDefaults.standard.setValue(refresh_token, forKey:"refresh_token")
//                        UserDefaults.standard.set(true, forKey:"isLoggedIn")
//                        DispatchQueue.main.async {
//                            self .getUserDetails()
//
//                        }
//                    }
//                }else{
//                    self.showAlertMessage(titleStr:customAlert.app_name.rawValue, messageStr: customAlert.something_wrong.rawValue)
//                }
//            }
//
//        }
    }
    
    
    
    
        func RegisterUser(number : String)
        {
            self.view.endEditingForce()
            self.loader.isHidden = false
            
            let urlString = "\(baseUrl)\(Base.signUp.rawValue)"
        
            
            let param = ["email" : strEmail, "first_name" : fullName, "password" : strPassword, "last_name" : "" , "mobile" : number , "device_type" : DeviceType.ios.rawValue , "device_id" : UUID().uuidString , "device_token" : "\(deviceTokenString)" , "login_by" : LoginType.manual.rawValue] as [String : Any]

        
            WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
                print("result is \(result)")
                self.loader.isHidden = true
                if statusCode == StatusCode.success.rawValue{
                    
                    let keyExists = result?["msg"] != nil
                    if keyExists{
                        self.navigationController?.popViewController(animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            showAlert(message: result?["msg"] as? String ?? "", okHandler: nil, fromView: self)
                        }
                    }
                    else{
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.LoginUser()
                        }
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
    //                       showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
                        }
                    }
                    else
                    {
    //                  showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
                    }
                   
                    
                }
                
            }

        }
    
    
        func LoginUser()
        {
            self.view.endEditingForce()
            self.loader.isHidden = false
            
            let urlString = "\(baseUrl)\(Base.login.rawValue)"
            let param = ["username" : email, "client_id" : appClientId, "password" : strPassword , "client_secret" : appSecretKey , "grant_type" : WebConstants.string.password , "device_type" : DeviceType.ios.rawValue , "device_id" : UUID().uuidString , "device_token" : "\(deviceTokenString)" , "scope" : ""] as [String : Any]
            
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
                    
                    showAlert(message: result?["message"] as? String ?? "", okHandler: nil, fromView: self)

//
//                    self.loader.isHidden = true
//                    let arrayValues = result?.allValues as NSArray?
//                    if (arrayValues?.count ?? 0) > 0
//                    {
//                        print("array values\(arrayValues!)")
//                        let responseMessageArray = arrayValues?[0] as? [String] ?? []
//                        if responseMessageArray.count > 0
//                        {
//                            showAlert(message: responseMessageArray[0], okHandler: nil, fromView: self)
//                        }
//                        else
//                        {
//                            if (arrayValues?[0] as? String != nil && arrayValues?[0] as? String != nil)
//                            {
//                                showAlert(message: arrayValues?[0] as? String ?? "", okHandler: nil, fromView: self)
//                            }
//                            else
//                            {
//    //                            showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
//                            }
//
//                        }
//                    }
//                    else
//                    {
//    //                    showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
//                    }
                    
                    
                }
                
            }
            
        }
    
//
//    //MARK:- Failure Delegate
//    func dataFailure(error:String,requestName:String){
//        self.showAlertMessage(titleStr: customAlert.app_name.rawValue, messageStr: error)
//
//
//    }
    
//    //MARK:- User Details
//    func getUserDetails(){
//        let url = baseUrl+userProfileDetail
//        let secondTok: String =  UserDefaults.standard.string(forKey:"access_token") ?? ""
//        let bear = "Bearer " + secondTok
//        let header = ["Content-Type" : "application/json","Accept" : "application/json", "Authorization" : bear]
//        self.startActivity()
//        print("UrlProfileUrl=====\(url)")
//        Alamofire.request(url, method: .get , encoding: JSONEncoding.default, headers: header).responseJSON { response in
//            self.stopActivity()
//
//            if (response.result.value == nil){
//                self.showAlertMessage(titleStr:customAlert.app_name.rawValue, messageStr: customAlert.something_wrong.rawValue)
//            }else{
//                if let userDict = response.result.value as? NSDictionary{
//                    print("UserProfileDetails========(\(userDict))")
//                    let fullname = userDict.value(forKey:"full_name")
//                    let emailid =  userDict.value(forKey:"email")
//                    let mobileNo = userDict.value(forKey:"mobile")
//                    let rating =   userDict.value(forKey:"rating")
//
//                    UserDefaults.standard.set(fullname, forKey:"full_name")
//                    UserDefaults.standard.set(emailid, forKey:"email")
//                    UserDefaults.standard.set(mobileNo, forKey:"mobile")
//                    UserDefaults.standard.set(rating, forKey:"rating")
//
//                    let home = self.storyboard?.instantiateViewController(withIdentifier:"HomeVC")as! HomeVC
//                    self.navigationController?.pushViewController(home, animated: true)
//
//                }else{
//                    self.showAlertMessage(titleStr:customAlert.app_name.rawValue, messageStr: customAlert.something_wrong.rawValue)
//
//                }
//            }
//
//        }
//    }
    
//    //MARK:- Redirect to Next ....
//    func movetoLocation(){
//        let home = self.storyboard?.instantiateViewController(withIdentifier:"HomeVC")as! HomeVC
//        self.navigationController?.pushViewController(home, animated: true)
//    }
}






//MARK:- PostViewProtocol

extension EnterOTPVC : PostViewProtocol {
    
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

