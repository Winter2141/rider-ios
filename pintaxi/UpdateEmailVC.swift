//
//  UpdateEmailVC.swift
//  TranxitUser
//
//  Created by 99appdev on 25/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class UpdateEmailVC: UIViewController {

    var strEmail : String!
    @IBOutlet weak var txtEmail: UITextField!
    
    let reach = NetworkReachabilityManager ()
    
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
 self.txtEmail.text = self.strEmail ?? ""
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnUpdate(_ sender: Any) {
        
        guard  let emailText = self.txtEmail.text, !emailText.isEmpty else {
            showAlert(message: "\(ErrorMessage.list.enterEmail.localize())", okHandler: nil, fromView: self)
            
            self.txtEmail.becomeFirstResponder()
            
            return
        }
        
        guard Common.isValid(email: emailText) else {
            
            showAlert(message: "\(ErrorMessage.list.enterValidEmail)", okHandler: nil, fromView: self)
            
            self.txtEmail.becomeFirstResponder()
            
            return
        }
        
        self.loader.isHidden = false
        if self.reach?.isReachable ?? false
        {
            self.UpdateEmail()
        }
        else
        {
            showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
        }
        
        
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func UpdateEmail()
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.updateProfile.rawValue)"
        let param = ["email" : self.txtEmail.text ?? "" , "first_name" : User.main.firstName ?? "" , "last_name" : User.main.lastName ?? "" , "mobile" : User.main.mobile ?? ""] as [String : Any]
        
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

extension UpdateEmailVC : PostViewProtocol {
    
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
        showAlert(message: Constants.string.emailUpdated, okHandler: {
            self.navigationController?.popViewController(animated: true)
        }, fromView: self)
        
    }
    
    
}

