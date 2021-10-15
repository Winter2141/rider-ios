//
//  ProfileViewController.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var imgUserProfilePic: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     self.lblUserName.text = User.main.firstName ?? ""
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
          return UIStatusBarStyle.lightContent
      }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        DispatchQueue.global(qos: .background).async {
            do
            {
                var pictureUrl = User.main.picture ?? ""
                if pictureUrl != ""
                {
                    pictureUrl = "\(baseUrl)/storage/app/public/\(pictureUrl)"
                    let url = URL(string:pictureUrl )
                    if let data = try? Data(contentsOf: url!)
                    {
                        let image: UIImage = UIImage(data: data)!
                        DispatchQueue.main.async {
                        self.imgUserProfilePic.image = image
                        }
                    }
                }            }
            catch {
                // error
            }
        }
       
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditProfile(_ sender: Any) {
         self.push(id: Storyboard.Ids.UpdateProfileVC, animation: true)
    }
    
    @IBAction func btnBecomeDriver(_ sender: Any) {
        if let url = URL(string: "https://pintaxi.xyz") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func btnReviewClicked(_ sender: Any) {
         self.push(id: Storyboard.Ids.ReviewVC, animation: true)
    }
    
    @IBAction func btnPasswordClicked(_ sender: Any) {
        
        self.push(id: Storyboard.Ids.ChangePasswordVC, animation: true)
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
        showAlert(message: SuccessMessage.list.sureToLogout, okHandler: {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: EmailViewController.self) {
                    
                    UserDefaults.standard.removeObject(forKey: Keys.list.userData)
                    UserDefaults.standard.synchronize()
                    self.navigationController!.popToViewController(controller, animated: false
                    )
                    
                    break
                }
                else
                {
                    UserDefaults.standard.removeObject(forKey: Keys.list.userData)
                    UserDefaults.standard.synchronize()
                    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.window?.rootViewController = Router.setWireFrame()
                }
                
            }
        }, cancelHandler: nil, fromView: self)
    }
    
}
