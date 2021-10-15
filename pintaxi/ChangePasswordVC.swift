//
//  ChangePasswordVC.swift
//  TranxitUser
//
//  Created by 99appdev on 25/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire


class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtCurrentPassword: UITextField!
    
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
          return UIStatusBarStyle.lightContent
      }
    @IBAction func btnChangePassword(_ sender: Any) {
        
        guard let oldPassword = self.txtCurrentPassword.text, oldPassword.count>0 else {
            
            showAlert(message: "\(ErrorMessage.list.enterPassword.localize())", okHandler: nil, fromView: self)
            return
        }
        
        guard let newPassword = self.txtNewPassword.text, newPassword.count>0 else {
            
            showAlert(message: "\(ErrorMessage.list.enterNewPassword.localize())", okHandler: nil, fromView: self)
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
           self.ChangePassword()
            
        }
    }
    
    func ChangePassword()
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.changePassword.rawValue)"
        let param = ["old_password" : self.txtCurrentPassword.text ?? "" , "password" : self.txtNewPassword.text ?? "" , "password_confirmation" : self.txtNewPassword.text ?? ""] as [String : Any]
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    showAlert(message: Constants.string.passwordresetMesage, okHandler: {
                      self.navigationController?.popViewController(animated: true)
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
