//
//  ReviewVC.swift
//  TranxitUser
//
//  Created by 99appdev on 26/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class ReviewVC: UIViewController , UITableViewDataSource , UITableViewDelegate{
    var arrayReviewList = [[String : Any]] ()
    @IBOutlet weak var tblReview: UITableView!
      let reach = NetworkReachabilityManager ()
    
    private lazy var loader : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
          return UIStatusBarStyle.lightContent
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loader.isHidden = false
        if self.reach?.isReachable ?? false
        {
             self.tblReview.isHidden = true
            self.GetReviewList()
        }
        else
        {
            showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
        }
        self.tblReview.estimatedRowHeight = 80
        self.tblReview.rowHeight = UITableView.automaticDimension
       

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayReviewList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        let DictRating = self.arrayReviewList[indexPath.row]
        let strComment = DictRating["provider_comment"] as? String ?? ""
        if strComment != ""{
            cell.lblReview.text = strComment
        }
        
        //SET DATE AND TIME
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateStr = DictRating["created_at"] as? String ?? ""
        let date = dateFormatter.date(from:dateStr)
        dateFormatter.dateFormat = "dd MMM yyyy"
        cell.lblDate.text = dateFormatter.string(from: date!)

    
                               
        
        if let rating = Float(DictRating["user_rating"] as? String ?? "") {
            cell.RatingView.value = CGFloat(rating)
        }
      //  cell.RatingView.value = Float(DictRating["user_rating"] as? String ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return  UITableView.automaticDimension
        
    }
    func GetReviewList()
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.userReview.rawValue)"
        let param = ["provider_id" : User.main.id ?? 0] as [String : Any]
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
           // print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                self.loader.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    print("result is \(result)")
                    self.arrayReviewList = [[String : Any]] ()
                    self.arrayReviewList  = result?["Data"] as? [[String : Any]] ?? [[:]]
                    if self.arrayReviewList.count == 0
                    {
                       self.tblReview.isHidden = true
                        showAlert(message: SuccessMessage.list.noDataFound, okHandler: {
                            self.navigationController?.popViewController(animated: true)
                        }, fromView: self)
                    }
                    else
                    {
                        self.tblReview.isHidden = false
                        self.tblReview.dataSource = self
                        self.tblReview.delegate = self
                        self.tblReview.reloadData()
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

    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   

}
