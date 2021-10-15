//
//  ForgotPasswordViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController{
    
    //MARK:_ IBOutlets
     let reach = NetworkReachabilityManager ()
  
    @IBOutlet private var textFieldEmail : UITextField!
    @IBOutlet private var imgNext : UIImageView!

    
    //MARK:- LOcal variables
    
    var emailString : String?
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    func ForgotPasswordEmailValidate()
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.forgotPassword.rawValue)"
        let param = ["email" : self.textFieldEmail.text ?? ""] as [String : Any]
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let DictUser = result?["user"] as? [String : Any] ?? [:]
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ForgotPasswordResetVC) as? ForgotPasswordResetVC
                    {
                     vc.emailId = self.textFieldEmail.text ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                        vc.strId = "\(DictUser["id"] as? Int ?? 0)"
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        //SET IMAGE
        imgColor(img: imgNext, colorHex: Constants.BLACK_COLOUR)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        self.setFrame()
    }
    
}

//MARK:-  Local Methods

extension ForgotPasswordViewController {
    
    private func initialLoads(){
        
       /* self.setDesigns()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.scrollView.addSubview(viewScroll)
        self.scrollView.isDirectionalLockEnabled = true
        self.setFrame()
        self.textFieldEmail.text = emailString
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }*/
    }
    
    private func setFrame() {
       /* self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size*/
    }
    
    private func setDesigns(){
        
      /*  self.textFieldEmail.borderActiveColor = .primary
        self.textFieldEmail.borderInactiveColor = .lightGray
        self.textFieldEmail.placeholderColor = .gray
        self.textFieldEmail.textColor = .black
        self.textFieldEmail.delegate = self
        Common.setFont(to: textFieldEmail)*/
    }
    
    private func localize(){
        
        self.textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        self.navigationItem.title = Constants.string.enterYourMailIdForrecovery.localize()
    }
    
    
    // Next View Tap Action
    
    @IBAction private func nextAction(){
        
      //  self.viewNext.addPressAnimation()
        
        guard  let emailText = self.textFieldEmail.text, !emailText.isEmpty else {
             showAlert(message: "\(ErrorMessage.list.enterEmail)", okHandler: nil, fromView: self)
            
           
                self.textFieldEmail.becomeFirstResponder()
            
            return
        }
        
        guard Common.isValid(email: emailText) else {
             showAlert(message: "\(ErrorMessage.list.enterValidEmail)", okHandler: nil, fromView: self)
          
                self.textFieldEmail.becomeFirstResponder()
            
            return
        }
    }
}

//MARK:- UITextFieldDelegate

extension ForgotPasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldEmail.placeholder = Constants.string.email.localize()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        }
    }
    
}

