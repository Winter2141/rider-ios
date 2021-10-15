//
//  UpdateMobileVC.swift
//  TranxitUser
//
//  Created by 99appdev on 25/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import Firebase

class UpdateMobileVC: UIViewController{
    var strMobile : String!
    var str_langCode = ""
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var img_flag: UIImageView!
       @IBOutlet weak var lbl_countryCode: UILabel!
    
    let reach = NetworkReachabilityManager ()
    
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
             let strPhoneCode = getCountryPhonceCode(countryCode)
             self.img_flag.image = UIImage.init(named: "\(countryCode).png")
             self.lbl_countryCode.text = "+\(strPhoneCode)"
         }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func btnUpdate(_ sender: Any) {
        guard let firstName = self.txtMobile.text, firstName.count>0 else {
            
            showAlert(message: "\(ErrorMessage.list.enterMobileNumber.localize())", okHandler: nil, fromView: self)
            return
        }
        self.loginWithPhone()
    }
    
    func loginWithPhone()  {
        let strCountryCode = self.lbl_countryCode.text ?? ""
        let strMobileNumbr = self.txtMobile.text ?? ""
        if strCountryCode.count > 0 && strMobileNumbr.count > 0 {
            let number = strCountryCode + strMobileNumbr
            self.loader.isHidden = true
             PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) {
                (verificationID, error) in
                self.loader.isHidden = true
                if error != nil {
                    showAlert(message: error?.localizedDescription ?? "", okHandler: nil, fromView: self)
                    return
                } else {
                    DispatchQueue.main.async {
                        if verificationID != nil {
                        let objOTP = self.storyboard?.instantiateViewController(withIdentifier: "EnterOTPVC") as! EnterOTPVC
                            objOTP.fromStr = "UpdateMobile"
                            objOTP.delegate = self
                            objOTP.strMobileNo = strMobileNumbr
                            objOTP.strCountryCode = strCountryCode
                            objOTP.verificationID = verificationID ?? ""
                            self.navigationController?.pushViewController(objOTP, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btncountrycode_Action(_ sender: UIButton) {
        let objCountry = self.storyboard?.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        objCountry.delegate = self
        self.navigationController?.pushViewController(objCountry, animated: true)
    }

    func UpdateMobile(number : String , code : String)
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.updateProfile.rawValue)"
        let param = ["email" : User.main.email ?? "" , "first_name" : User.main.firstName ?? "" , "last_name" : User.main.lastName ?? "" , "mobile" : "+\(code)\(number)"] as [String : Any]
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.loader.isHidden = false
                    self.presenter?.get(api: .getProfile, parameters: nil)
                    
                    
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

extension UpdateMobileVC : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        let alert = showAlert(message: message)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {
                self.loader.isHidden = true
            })
        }
        
    }
    
    func getOath(api: Base, data: LoginRequest?) {
        
        guard let accessToken = data?.access_token, let refreshToken = data?.refresh_token else {
            self.onError(api: api, message: ErrorMessage.list.serverError.localize(), statusCode: 0)
            return
        }
        
        User.main.accessToken = accessToken
        User.main.refreshToken = refreshToken
        self.presenter?.get(api: .getProfile, parameters: nil)
    }
    
    
    func getProfile(api: Base, data: Profile?) {
        
        guard data != nil  else { return  }
        Common.storeUserData(from: data)
        storeInUserDefaults()
        self.loader.isHidden = true
        self.navigationController?.popViewController(animated: true)
        showAlert(message: Constants.string.mobileUpdated, okHandler:nil, fromView: self)
    }
    
    
}

extension UpdateMobileVC:countryPickDelegate,SuccessDelegate{
    func onSuccessWithPhone(mobileNumber:String,code:String) {
        if mobileNumber != ""{
           if self.reach?.isReachable ?? false{
               self.UpdateMobile(number: mobileNumber, code: code)
           }
           else{
               showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
           }
        }
    }
    //MARK: - Picked Country
    func selectCountry(screenFrom: String, is_Pick: Bool, selectedCountry: CountryCode?) {
        self.img_flag.image = selectedCountry?.flag
        self.str_langCode = selectedCountry?.code ?? ""
        self.lbl_countryCode.text = selectedCountry?.phoneCode ?? "+1"
        self.txtMobile.becomeFirstResponder()
    }
}
