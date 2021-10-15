//
//  PromoCouponVC.swift
//  TranxitUser
//
//  Created by IndianRenters on 14/10/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class PromoCouponVC: UIViewController,ServerCommunicationApiDelegate {
    
    @IBOutlet weak var promoListTblView : UITableView!
    @IBOutlet weak var couponText : UITextField!
    var promoList:Array<Dictionary<String,Any>> = []
    @IBOutlet weak var lblTitle : UILabel!

    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        getCouponListHit()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCouponBack(_ sender: Any) {
        guard  let text = self.couponText.text, !text.isEmpty else {
            showAlert(message: "Please enter your promo code.", okHandler: nil, fromView: self)
            return
        }
        addpromocodeHit()
        
    }
    
    //MARK:- WebService for Promo List
    func getCouponListHit(){
        DispatchQueue.main.async {
             self.loader.isHidden = false
        }
        let url =  "\(baseUrl)\(Base.promocodes.rawValue)"
        let network = NetworkHelper()
        network.delegate = self
        network.getDataFromUrlWithGET(url: url, requestName: Base.promocodes.rawValue)
    }
    
    //MARK:- WebService for Add Promo
    func addpromocodeHit(){
        DispatchQueue.main.async {
            self.loader.isHidden = false
        }
        let url =  "\(baseUrl)\(Base.addPromocode.rawValue)"
        let params:Parameters = ["promocode":couponText.text!]
        let network = NetworkHelper()
        network.delegate = self
        network.getDataFromUrlWithAccessPOST(url: url, requestName: Base.addPromocode.rawValue, headerField: "", parameter: params)
      
    }
    
    //MARK:- Receive Service Methods
    func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            print(dic)
            switch requestName{
            case Base.promocodes.rawValue :
                let dataArr =  dic["data"] as! Array<Dictionary<String,Any>>
                if dataArr.count > 0{
                    self.promoList =  dic["data"] as! Array<Dictionary<String,Any>>
                    self.promoListTblView.reloadData()
                    }else{
                        showAlert(message: "No Data Found", okHandler: nil, fromView: self)
                    }
                
        
            case Base.addPromocode.rawValue :
                if dic.count > 0{
                    if let promocode = dic["promocode"] as? Array<Any>{
                        showAlert(message: (promocode[0] as! String), okHandler: nil, fromView: self)
                    }else{
                    let code =  dic["code"] as! String
                        showAlert(message: code, okHandler: nil, fromView: self)
                    }
                }else{
                    showAlert(message: "No Data Found", okHandler: nil, fromView: self)
                }
                
                
            default:
                print("default")
            }
        }
    }
    
    func dataFailure(error: String, requestName: String) {
        DispatchQueue.main.async {
           self.loader.isHidden = true
        }
         showAlert(message: error, okHandler: nil, fromView: self)
       // self.showAlertMessage(titleStr:"Quick Ride User", messageStr:error)
        print(error)
    }
    

}

extension PromoCouponVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promoListtblCell", for: indexPath) as! promoListtblCell
        let dic = promoList[indexPath.row]
        let promoCode = dic["promocode"] as? Dictionary<String,Any>
        cell.codeLbl.text = promoCode?["promo_code"] as? String ?? ""
        cell.discountLbl.text = "€ " + "\(promoCode?["discount"] as? String ?? "")" + " OFF"
        //cell.expiresLbl.text = promoCode?["expiration"] as? String ?? ""
        //€
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
         let dateStr = promoCode?["expiration"] as? String ?? ""
         let date = dateFormatter.date(from:dateStr)
         dateFormatter.dateFormat = "dd MMM yyyy"
        let dateStrVal = dateFormatter.string(from: date!)
        cell.expiresLbl.text = "Valid until " + "\(dateStrVal)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
}


class promoListtblCell:UITableViewCell{
     @IBOutlet weak var codeLbl: UILabel!
     @IBOutlet weak var discountLbl: UILabel!
     @IBOutlet weak var expiresLbl: UILabel!
}
