//
//  NotificationsViewController.swift
//  Provider
//
//  Created by Sravani on 08/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class NotificationsViewController: UIViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NotificationsTextLabel: UILabel!
    @IBOutlet weak var lblNodata: UILabel!

    var dataSource : NSArray?
    var selectedIndexPath: Int = -1
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.SetNavigationcontroller()
        self.getUserDetails()
//        self.presenter?.get(api: .notificationManager, parameters: nil)
        self.tableView.estimatedRowHeight = 120
    }
    
    
    
    //MARK:- USERDETAILS.....
    func getUserDetails()
    {
        self.loader.isHidden = false
        self.lblNodata.isHidden = false
        
        let headers = [
            "Authorization": "Bearer \(User.main.accessToken ?? "")",
            "Content-Type":"application/json",
            "X-Requested-With" : "XMLHttpRequest"
        ]
        let urlString = "\(baseUrl)\(Base.notificationManager.rawValue)"
        Alamofire.request(urlString, method: .get, headers: headers).responseJSON
            {
                response in
                self.loader.isHidden = true

                debugPrint(response)
                if let responseDict =  response.value as? NSDictionary?{
                    
                    if let arrData = responseDict?["Data"] as? NSArray{
                        self.lblNodata.isHidden = true
                        self.dataSource = arrData
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
}

//MARK:- LocalMethod

extension NotificationsViewController {
    
    func SetNavigationcontroller() {
            self.navigationController?.isNavigationBarHidden = true
        if #available(iOS 11.0, *) {

//            self.navigationController?.navigationBar.prefersLargeTitles = false
//            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        
        title = Constants.string.notifications.localize()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backBarButtonTapped(button:)))
    }
    
    @objc func backBarButtonTapped(button: UINavigationItem){
        self.popOrDismiss(animation: true)
    }
    
    
    
}

//MARK:- UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if dataSource?.count != 0 {
            self.tableView.isHidden = false
            NotificationsTextLabel.text = ""
        }
        else {
            self.tableView.isHidden = true
            NotificationsTextLabel.text = Constants.string.noNotifications.localize()
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.NotificationTableViewCell, for: indexPath) as! NotificationTableViewCell
        cell.selectionStyle = .none
        let obj = dataSource?[indexPath.row] as? NSDictionary
    
        cell.notifHeaderLbl.text = obj?["notification_text"] as? String
        cell.notifContentLbl.text = obj?["expiration_date"] as? String
        cell.NotifImage.setImage(with: "\(baseUrl)\(obj?["image"] ?? "")", placeHolder: UIImage(named: "Logo"))
       // setViewShadow(myView: cell.NitifView)
        cell.NitifView.layer.shadowOffset = CGSize(width: 2, height: 2)

        cell.layoutIfNeeded()
        

        
        
        
//        if self.selectedIndexPath == indexPath.row {
//            cell.readMoreButton.setTitle(Constants().readLess, for: .normal)
//        }
//        else {
//            cell.readMoreButton.setTitle(Constants().readMore, for: .normal)
//        }
        return cell
    }
    
    func setViewShadow(myView : UIView) {
          //SER CONFIRM REQUEST
          myView.layer.shadowPath =
              UIBezierPath(roundedRect: myView.bounds,
                           cornerRadius: myView.layer.cornerRadius).cgPath
          myView.layer.shadowColor = UIColor.black.cgColor
          myView.layer.shadowOpacity = 0.2
          myView.layer.shadowOffset = CGSize(width: 10, height: 10)
          myView.layer.shadowRadius = 3
          myView.layer.masksToBounds = false
          myView.layer.cornerRadius = 10
      }
    
    @objc func expandCell(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at:buttonPosition) {
            if self.selectedIndexPath == indexPath.row {
                self.selectedIndexPath = -1
            }
            else {
                self.selectedIndexPath = indexPath.row
            }
            self.tableView.reloadData()
            //            self.tableView.beginUpdates()
            //            self.tableView.endUpdates()
        }
    }
}

//MARK:- UITableViewDelegate

extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndexPath == indexPath.row {
            return UITableView.automaticDimension
        }
        else {
            return 120
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    
}

//MARK:- PostViewProtocol

extension NotificationsViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    
    func getNotificationsMangerList(api: Base, data: [NotificationManagerModel]?) {
        print("Notification")
    }
//    func getNotificationsMangerList(api: Base, data: [NotificationManagerModel]?) {
//        
//        if api == .notificationManager {
//            print(data as Any)
//            dataSource = data
//            self.tableView.reloadData()
//        }
//    }
}

