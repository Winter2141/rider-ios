//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire

class BaseViewController: UIViewController, SlideMenuDelegate {
    var isViewPresentInNavigation : Bool!
    var bannerView : GADBannerView!
    
    public var isConfirmAdmob = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isViewPresentInNavigation = false
        
        getAdmobSetting()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func getAdmobSetting(){
        let headers = [
            "Authorization": "Bearer \(User.main.accessToken ?? "")",
            "Content-Type":"application/json",
            "X-Requested-With" : "XMLHttpRequest"
        ]
        
        let urlString = "\(baseUrl)\(Base.getAdmobSetting.rawValue)"
        
        Alamofire.request(urlString, method: .get, headers: headers).responseJSON
        { [self]
            response in
            debugPrint(response)
            
            if let responseDict =  response.value as? NSDictionary?{
                if responseDict?["ad_show"] != nil
                {
                    //showAlert(message: "\(responseDict?["ad_show"])", okHandler: nil, fromView: self)
                    if responseDict!["ad_show"] as! Int == 1 {
                        isConfirmAdmob = true
                    }
                    else
                    {
                        isConfirmAdmob = false
                    }
                    
                    debugPrint("cofirmAdmob", isConfirmAdmob)
                }
            }
        }
    }
    
    public func loadGoogleAdmob1(stack:UIStackView){
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        let viewWidth = self.view.frame.size.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView.heightAnchor.constraint(equalToConstant: bannerView.adSize.size.height).isActive = true
        bannerView.widthAnchor.constraint(equalToConstant: stack.frame.width).isActive = true
        stack.addArrangedSubview(bannerView)
    }
    
    public func loadGoogleAdmob(){
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        loadBannerAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Note loadBannerAd is called in viewDidAppear as this is the first time that
        // the safe area is known. If safe area is not a concern (e.g., your app is
        // locked in portrait mode), the banner can be loaded in viewWillAppear.
    }
    
    override func viewWillTransition(to size: CGSize,
                              with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
          self.loadBannerAd()
        })
      }
    
    func loadBannerAd() {
        // Step 2 - Determine the view width to use for the ad width.
        let frame = { () -> CGRect in
          // Here safe area is taken into account, hence the view frame is used
          // after the view has been laid out.
          if #available(iOS 11.0, *) {
            return view.frame.inset(by: view.safeAreaInsets)
          } else {
            return view.frame
          }
        }()
        let viewWidth = frame.size.width

        // Step 3 - Get Adaptive GADAdSize and set the ad view.
        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        // Step 4 - Create an ad request and load the adaptive banner ad.
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
      }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        riderStatus = .none

        switch(index){
        case 0:
            print("Home\n", terminator: "")

            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ChacelRequesrt"), object: nil)

            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: false
                        )
                        self.isViewPresentInNavigation = true
                        break
                    }
                    else
                    {
                        self.isViewPresentInNavigation = false
                    }
                }
                if self.isViewPresentInNavigation == false
                {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let destViewController =
                        storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController!.pushViewController(destViewController, animated: false)
                }
            })
            
            break
            
        case 1:
            print("On Going")
          
            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: OngoingViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: false)
                        self.isViewPresentInNavigation = true
                        break
                    }
                    else
                    {
                        self.isViewPresentInNavigation = false
                    }
                }
                
                if self.isViewPresentInNavigation == false
                {
                    let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.OngoingViewController)
                    self.navigationController!.pushViewController(destViewController, animated: false)
                }
            })
            
            break
                                  
        case 2:
            print("History", terminator: "")
            
            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HistoryVC.self) {
                        self.navigationController!.popToViewController(controller, animated: false)
                        self.isViewPresentInNavigation = true
                        break
                    }
                    else
                    {
                        self.isViewPresentInNavigation = false
                    }
                }
                
                if self.isViewPresentInNavigation == false
                {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
                    let destViewController =
                        storyBoard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
                    self.navigationController!.pushViewController(destViewController, animated: false)
                    
                }
            })
            break
            
            
        case 3:
            print("Notification\n", terminator: "")
                        
            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: NotificationsViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: false)
                        self.isViewPresentInNavigation = true
                        break
                    }
                    else
                    {
                        self.isViewPresentInNavigation = false
                    }
                }
                
                if self.isViewPresentInNavigation == false
                {
                    let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.NotificationController)
                    self.navigationController!.pushViewController(destViewController, animated: false)
                }
            })
            
            break
            
        case 4:
            print("Payment\n", terminator: "")
            
            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PaymentsViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: false)
                        self.isViewPresentInNavigation = true
                        break
                    }
                    else
                    {
                        self.isViewPresentInNavigation = false
                    }
                }
                
                if self.isViewPresentInNavigation == false
                {
                    let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.PaymentsViewController)
                    self.navigationController!.pushViewController(destViewController, animated: false)
                }
            })
            
            
            break
            
        case 5:
            print("Wallet\n", terminator: "")
            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: WalletViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: false)
                        self.isViewPresentInNavigation = true
                        break
                    }
                    else
                    {
                        self.isViewPresentInNavigation = false
                    }
                }
                
                if self.isViewPresentInNavigation == false
                {
                    let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.Ids.WalletViewController)
                    self.navigationController!.pushViewController(destViewController, animated: false)
                }
            })
            
            break
            
        case 6:
            print("Hellp\n", terminator: "")
            
            
            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HelpViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: false)
                        self.isViewPresentInNavigation = true
                        break
                    }
                    else
                    {
                        self.isViewPresentInNavigation = false
                    }
                }
                
                if self.isViewPresentInNavigation == false
                {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
                    let destViewController =
                        storyBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                    self.navigationController!.pushViewController(destViewController, animated: false)
                    
                }
            })
            break
            
            
            
        case 7:
            print("Share\n", terminator: "")
            
            
            self.slideMenuItemSelectedAtIndex(-1);
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.isViewPresentInNavigation = false
                
                
                if self.isViewPresentInNavigation == false
                {
                    if let urlStr = NSURL(string: "https://www.99appdev.com") {
                        let objectsToShare = [urlStr]
                        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                        
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            if let popup = activityVC.popoverPresentationController {
                                popup.sourceView = self.view
                                popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                            }
                        }
                        
                        self.present(activityVC, animated: true, completion: nil)
                    }
                    
                }
            })
            
            break
            
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        //        for controller in self.navigationController!.viewControllers as Array {
        //            if controller.isKind(of: ViewController.self) {
        //                self.navigationController!.popToViewController(controller, animated: true)
        //                break
        //            }
        //        }
        
        
        self.navigationController!.pushViewController(destViewController, animated: true)
        
        
        
        
        
    }
    
    func addSlideMenuButton(btnShowMenu : UIButton){
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
    }
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let menuVC : MenuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        // let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
}
