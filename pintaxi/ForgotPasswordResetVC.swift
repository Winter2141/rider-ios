//
//  ForgotPasswordResetVC.swift
//  TranxitUser
//
//  Created by 99appdev on 24/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
class ForgotPasswordResetVC: UIViewController {
  let reach = NetworkReachabilityManager ()
    @IBOutlet weak var txtEmailAddress: UITextField!
    
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    var emailId : String!
    var strId : String!
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmailAddress.text = emailId ?? ""

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btnNext(_ sender: Any) {
      
        
        guard  let emailText = self.txtEmailAddress.text, !emailText.isEmpty else {
            
            self.view.make(toast: ErrorMessage.list.enterEmail) {
                self.txtEmailAddress.becomeFirstResponder()
            }
            return
        }
        
        guard Common.isValid(email: emailText) else {
            self.view.make(toast: ErrorMessage.list.enterValidEmail) {
                self.txtEmailAddress.becomeFirstResponder()
            }
            return
        }
        
        guard let newPassword = self.txtNewPassword.text, newPassword.count>0 else {
            
            showAlert(message: "\(ErrorMessage.list.enterPassword.localize())", okHandler: nil, fromView: self)
            return
        }
        guard let confirmNewPassword = self.txtConfirmNewPassword.text, confirmNewPassword.count>0 else {
            
            showAlert(message: "\(ErrorMessage.list.enterConfirmPassword.localize())", okHandler: nil, fromView: self)
            return
        }
        if self.txtConfirmNewPassword.text != self.txtNewPassword.text
        {
            showAlert(message: "\(ErrorMessage.list.passwordDonotMatch.localize())", okHandler: nil, fromView: self)
        }
        else
        {
           
            if self.reach?.isReachable ?? false
            {
                self.ResetPassword()
            }
            else
            {
                showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
            }
            
        }
    }
    
    func ResetPassword()
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.resetPassword.rawValue)"
        let param = ["email" : self.txtEmailAddress.text ?? "" , "password" : self.txtNewPassword.text ?? "" , "password_confirmation" : self.txtNewPassword.text ?? "" , "id" : self.strId ?? ""] as [String : Any]
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    showAlert(message: Constants.string.passwordresetMesage, okHandler: {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: EmailViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: false
                                )
                                
                                break
                            }
                            
                        }
                    }, fromView: self)

                    
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
