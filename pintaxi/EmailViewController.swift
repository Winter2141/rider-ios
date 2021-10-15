//
//  EmailViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class EmailViewController: UIViewController {
    
    //MARK:- IBOutlets
     let reach = NetworkReachabilityManager ()
    @IBOutlet private var viewNext: UIView!
    @IBOutlet private var textFieldEmail : UITextField!
    @IBOutlet private var buttonCreateAcount : UIButton!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!
    @IBOutlet private var imgCircel : UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var objCollectionView: UICollectionView!

    var isfaceBook = false
    //MARK:- Local Variable
    var accessToken : String?
    var googleId :String?
    var isHideLeftBarButton = false
    
    
    var FbFirstName : String = ""
    var FbEmail : String = ""
    var FbId : String = ""
    
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
         self.localize()
            NotificationCenter.default.addObserver(self, selector: #selector(self.GetNumberfromAccountKit(_:)), name: NSNotification.Name(rawValue: "accountkitnumber"), object: nil)
        
        viewInfo.isHidden = false
        btnSkip.isHidden = false
        if UserDefaults.standard.bool(forKey: "setInfo"){
            viewInfo.isHidden = true
            btnSkip.isHidden = true
        }
     
    }
    
    override func viewLayoutMarginsDidChange() {
        objCollectionView.reloadData()
    }
    // handle notification
    @objc func GetNumberfromAccountKit(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let number = dict["number"] as? String{
                print("number is \(number) && from facebook \(self.isfaceBook)")
                if self.isfaceBook == false
                {
                    self.googleLoginApi(number : number)
                }
                else
                {
//                    facebookLoginApi(number : number)
                }
            }
            
        }
    }
    
    @IBAction func btnFacebookClicked(_ sender: Any) {
        
        accessToken = nil // reset access token
        self.facebookLogin()
        
    }
    
    private func facebookLogin() {
        self.isfaceBook = true
        print("Facebook")
        let loginManager =  LoginManager()
        loginManager.loginBehavior = .browser
        loginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            // self.accessToken = self.accessToken
            if let emailStr = result?.grantedPermissions.contains("email") {
                print("LoginResult==========\(String(describing: emailStr))")
                
                self.returnUserData()
            }
        }
    }
    
    func returnUserData() {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("\n\n Error: \(String(describing: error))")
            } else {
                let resultDic = result as! NSDictionary
                print("\n\n  fetched user: \(String(describing: result))")
                
                
                
              
                
                if (resultDic.value(forKey:"name") != nil) {
                    let userName = resultDic.value(forKey:"name")! as! String as NSString?
                    print("\n User Name is: \(String(describing: userName))")
                    self.FbFirstName = "\(userName ?? "")"
                }
                
                if (resultDic.value(forKey:"email") != nil) {
                    let userEmail = resultDic.value(forKey:"email")! as! String as NSString?
                    print("\n User Email is: \(userEmail ?? "")")
                    self.FbEmail = "\(userEmail ?? "")"
                }
                if (resultDic.value(forKey:"id") != nil) {
                    let userId = resultDic.value(forKey:"id")! as! String as NSString?
                    self.FbId = "\(userId ?? "")"
                }
                
                self.accessToken = AccessToken.current?.tokenString
                
                
                let withDrawDetail = self.storyboard?.instantiateViewController(withIdentifier:"EnterMobileNoVC") as! EnterMobileNoVC
                withDrawDetail.screenFrom = "login"
                withDrawDetail.fullName = self.FbFirstName
                withDrawDetail.strEmail = self.FbEmail
                withDrawDetail.accessTokenStr =  self.accessToken ?? ""
                withDrawDetail.social_mediaId = self.FbId
                withDrawDetail.checkLoginStatus = "FB"
                self.navigationController?.pushViewController(withDrawDetail, animated: true)
                
//
//
//                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//                appDelegate?.accountKit()
            }
        })
    }
    
    
    @IBAction func btnGoogleClicked(_ sender: Any) {
        self.googleLogin()
        User.main.loginType = LoginType.google.rawValue
    }
    
    // MARK:- Google Login
    
    private func googleLogin(){
        
        self.loader.isHidden = false
        self.isfaceBook = false
        
        GIDSignIn.sharedInstance.signOut()
        let signInConfig = GIDConfiguration.init(clientID: "914441446532-qr03h8jhjid5nsj1ftlvo0h8lgs1qmco.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { (user, error) in
            guard user != nil else {
                return
            }
            self.accessToken = user!.authentication.accessToken
        }
        
    }
   
    func googleLoginApi(number : String)
    {
        
      /*  self.loader.isHidden = false
        let urlString = "\(baseUrl)\(Base.googleLogin.rawValue)"
        let param = ["accessToken" :  self.accessToken ?? "", "device_type" : DeviceType.ios.rawValue , "device_id" : UUID().uuidString , "id" :self.gmailId!, "device_token" : "\(deviceTokenString)","email":self.gmailId! ,"name":self.user_Name!, "login_by" : "google" , "mobile" : number] as [String : Any]
        Alamofire.request(urlString, method: .post, parameters: param,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                
                if let responseDict =  response.value as? NSDictionary{
                    
                    print("ResponseDict =======\(responseDict)")
                    
                    if let error = responseDict["error"] as? String
                    {
                        showAlert(message: error, okHandler: nil, fromView: self)
                    }
                    else
                    {
                        
                        
                        UserDefaults.standard.set(responseDict["access_token"] as? String ?? "", forKey: "access_token")
                        
                        self.push(id: Storyboard.Ids.GoingSomewhereViewController, animation: true)
                    }
                }
                
                self.loader.isHidden = true
                
                
                
                
                break
            case .failure(let error):
                self.loader.isHidden = true
                print(error)
            }
        }*/
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        viewInfo.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnForgot(_ sender: Any) {
         self.push(id: Storyboard.Ids.ForgotPasswordViewController, animation: true)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.viewNext.makeRoundedCorner()
//        self.viewScroll.frame = self.scrollView.bounds
//        self.scrollView.contentSize = self.viewScroll.bounds.size
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        textFieldEmail.text = ""
        textFieldPassword.text = ""
        
        //SET IMAGE
        imgColor(img: imgCircel, colorHex: Constants.BLACK_COLOUR)
       
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBAction func btnRegister(_ sender: Any) {
        self.push(id: Storyboard.Ids.SignUPViewController, animation: true)
    }
    
    
}

//MARK:- Local Methods

extension EmailViewController {
    
   
    
    
    private func setDesigns(){

        
    }
    
    private func localize() {
        
        self.textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()

    }
    
    
    // Next View Tap Action
    
    @IBAction private func nextAction(){
        view.endEditing(true)

        guard  let emailText = self.textFieldEmail.text, !emailText.isEmpty else {
             showAlert(message: "\(ErrorMessage.list.enterEmail.localize())", okHandler: nil, fromView: self)
          
                self.textFieldEmail.becomeFirstResponder()
          
            return
        }
        
        guard Common.isValid(email: emailText) else {
            
            showAlert(message: "\(ErrorMessage.list.enterValidEmail)", okHandler: nil, fromView: self)
            
            self.textFieldEmail.becomeFirstResponder()
           
            return
        }
        
        guard  let passwordText = self.textFieldPassword.text, !passwordText.isEmpty else {
            
             showAlert(message: "\(ErrorMessage.list.enterPassword)", okHandler: nil, fromView: self)
          
                self.textFieldPassword.becomeFirstResponder()
          
            return
        }
        
        self.loader.isHidden = false
        if self.reach?.isReachable ?? false
        {
           self.LoginUser()
        }
        else
        {
            showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
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
                showAlert(message: result?["message"] as? String ?? "", okHandler: nil, fromView: self)

//
//                self.loader.isHidden = true
//                let arrayValues = result?.allValues as NSArray?
//                if (arrayValues?.count ?? 0) > 0
//                {
//                    print("array values\(arrayValues!)")
//                    let responseMessageArray = arrayValues?[0] as? [String] ?? []
//                    if responseMessageArray.count > 0
//                    {
//                        showAlert(message: responseMessageArray[0], okHandler: nil, fromView: self)
//                    }
//                    else
//                    {
//                        if (arrayValues?[0] as? String != nil && arrayValues?[0] as? String != nil)
//                            {
//                                showAlert(message: arrayValues?[0] as? String ?? "", okHandler: nil, fromView: self)
//                        }
//                            else
//                            {
////                            showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
//                            }
//
//                    }
//                }
//                else
//                {
////                    showAlert(message: "Something went wrong", okHandler: nil, fromView: self)
//                }
                
            }
        }
        
    }
    
   
    
  
}

//MARK:- UITextFieldDelegate
extension EmailViewController : UITextFieldDelegate {
    
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

//MARK:- PostViewProtocol

extension EmailViewController : PostViewProtocol {
    
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vcPointTitles =
            storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vcPointTitles, animated: true)

    }
    
    
}





//MARK: - Collection View -
extension EmailViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: self.view.frame.size.height)

        //return CGSize(width: viewInfo.frame.size.width, height: viewInfo.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red

        //sET IMAGE
        let img_Icon : UIImageView = cell.viewWithTag(100) as! UIImageView
        img_Icon.image = UIImage(named: "info_1")
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      }
}


