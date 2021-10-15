//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import Alamofire
//import SDWebImage

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}



class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ButtonGoToProfile: UIButton!
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    @IBOutlet weak var imgUserProfilePic: UIImageView!
    
    @IBOutlet weak var lbluserName: UILabel!
    
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblUserRating: UILabel!
    
    @IBOutlet weak var lblAppVersion: UILabel!
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    
    @IBOutlet weak var buttonOfferedRide: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = true
       // ChangeTintColor(strImage: "StarFull", imageView: self.imgStar, color: .white)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        self.lblAppVersion.text = "\("v \(appVersion)")"
        if User.main.accessToken != nil
        {
       
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

            let first_name = User.main.firstName ?? ""
            self.lbluserName.text = "\(first_name)"
         self.lblUserRating.text = User.main.rating ?? ""
            if self.lblUserRating.text?.contains(".") ?? false
            {
                let arrayRating = self.lblUserRating.text?.components(separatedBy: ".")
                self.lblUserRating.text = arrayRating?[0] ?? ""
            }
        
           // self.imgUserProfilePic.setImage(with: pictureUrl, placeHolder: UIImage(named:"userPlaceholder"))
           
        }
        else
        {
            let first_name =  "JACK"
            self.lbluserName.text = first_name
            self.imgUserProfilePic.image = UIImage(named:"userPlaceholder")
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    @IBAction func btnGoToProfile(_ sender: Any) {
       //  self.onCloseMenuClick(self.ButtonGoToProfile)
        self.ButtonGoToProfile.tag = 10
        self.onCloseMenuClick(self.ButtonGoToProfile)
        let storyBoard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let vcPointTitles =
            storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(vcPointTitles, animated: true)
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController"){
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
       
       
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
          return UIStatusBarStyle.lightContent
      }
    
    
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"Home", "icon":"map_menu_icon"])
        arrayMenuOptions.append(["title":"On Going Trip", "icon":"Tracking"])
        arrayMenuOptions.append(["title":"History", "icon":"History"])
        arrayMenuOptions.append(["title":"Notification", "icon":"BellIcon"])
        arrayMenuOptions.append(["title":"Payment", "icon":"icon_payment"])
        arrayMenuOptions.append(["title":"PinTaxi Wallet", "icon":"icon_wallet"])
        arrayMenuOptions.append(["title":"Help", "icon":"support_menu_icon"])
         arrayMenuOptions.append(["title":"Share", "icon":"Share"])
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    @IBAction func btnofferedRide(_ sender: Any) {
        self.buttonOfferedRide.tag = 10
        self.onCloseMenuClick(self.buttonOfferedRide)
       //  self.push(id: Storyboard.Ids.MyTripViewController, animation: true)
    }
    
    
}
