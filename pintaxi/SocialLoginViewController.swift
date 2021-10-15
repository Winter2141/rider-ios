//
//  SocailLoginViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


class SocialLoginViewController: UITableViewController {
    
    //MARK:- Local Variable
    
    private let tableCellId = "SocialLoginCell"
    private var isfaceBook = false
    private var accessToken : String?
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
        self.navigationController?.isNavigationBarHidden = false
    }
}

// MARK:- Local Methods

extension SocialLoginViewController {
    
    private func initialLoads() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:  #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func localize() {
        
        self.navigationItem.title = Constants.string.chooseAnAccount.localize()
    }
    
    //  Socail Login
    
    private func didSelect(at indexPath : IndexPath) {
       
        accessToken = nil // reset access token
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            self.facebookLogin()
            User.main.loginType = LoginType.facebook.rawValue
        case (0,1):
            self.googleLogin()
            User.main.loginType = LoginType.google.rawValue

        default:
            break
        }
        
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
    
    
    // MARK:- Facebook Login
    
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
                }
                
                if (resultDic.value(forKey:"email") != nil) {
                    let userEmail = resultDic.value(forKey:"email")! as! String as NSString?
                    print("\n User Email is: \(userEmail ?? "")")
                }
            //  self.accessToken =
            }
        })
    }

    
    
    
    private func loadAPI(accessToken: String?,phoneNumber: Int?, loginBy: LoginType,country_code: String?){
        self.loader.isHidden = false
        let user = UserData()
        user.accessToken = accessToken
        user.device_id = UUID().uuidString
        user.device_token = deviceTokenString
        user.device_type = .ios
        user.login_by = loginBy
        user.mobile = phoneNumber
        user.country_code = "+\(country_code!)"
        let apiType : Base = isfaceBook ? .facebookLogin : .googleLogin
        self.presenter?.post(api: apiType, data: user.toData())
    }  
}

// MARK:- TableView

extension SocialLoginViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellId, for: indexPath) as? SocialLoginCell {
            
            tableCell.labelTitle.text = (indexPath.row == 0 ? Constants.string.facebook : Constants.string.google).localize()
            tableCell.imageViewTitle.image = indexPath.row == 0 ?  #imageLiteral(resourceName: "fb_icon") :  #imageLiteral(resourceName: "google_icon")
            return tableCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.didSelect(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension SocialLoginViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    func getProfile(api: Base, data: Profile?) {
        
        if api == .getProfile {
            Common.storeUserData(from: data)
            storeInUserDefaults()
            self.navigationController?.present(Common.setDrawerController(), animated: true, completion: nil)
        }
        loader.isHideInMainThread(true)
        
    }
    
    func getOath(api: Base, data: LoginRequest?) {
        if api == .facebookLogin || api == .googleLogin, let accessTokenString = data?.access_token {
            User.main.accessToken = accessTokenString
            User.main.refreshToken =  data?.refresh_token
            self.presenter?.get(api: .getProfile, parameters: nil)
        }
    }
}





class SocialLoginCell : UITableViewCell {
    
    @IBOutlet weak var imageViewTitle : UIImageView!
    @IBOutlet weak var labelTitle : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDesign()
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        Common.setFont(to: self.labelTitle, isTitle: true)
    }
    
    
    
}

