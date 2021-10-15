//
//  HistoryPastDetailVC.swift
//  TranxitUser
//
//  Created by IndianRenters on 13/11/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import FloatRatingView

class HistoryPastDetailVC: UIViewController,ServerCommunicationApiDelegate {
    @IBOutlet weak var mapImgView : UIImageView!
    @IBOutlet weak var userImg : UIImageView!
    @IBOutlet weak var payImg : UIImageView!

    @IBOutlet weak var viewRating : FloatRatingView!

    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var pickLbl : UILabel!
    @IBOutlet weak var bookingId : UILabel!
    
    @IBOutlet weak var dropLbl : UILabel!
    @IBOutlet weak var paymentLbl : UILabel!
    @IBOutlet weak var payTypeLbl : UILabel!
    @IBOutlet weak var cashLbl : UILabel!
    
    @IBOutlet weak var commentTitleLbl : UILabel!
    @IBOutlet weak var commentsLbl : UILabel!
    @IBOutlet weak var bookingIdLbl : UILabel!
    
    
    @IBOutlet weak var viewInvoice : UIView!
    @IBOutlet weak var lblBookinId : UILabel!
    @IBOutlet weak var lblFare : UILabel!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var lblTax : UILabel!
    @IBOutlet weak var lblTotal : UILabel!
    @IBOutlet weak var viewPickup : UIView!
    @IBOutlet weak var imgDrop : UIImageView!
    @IBOutlet weak var viewComment : UIView!
    @IBOutlet weak var btnCancel : UIButton!

    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var btnCancel1: UIButton!
    @IBOutlet weak var btnCancel2: UIButton!
    @IBOutlet weak var btnCancel3: UIButton!
    @IBOutlet weak var btnCancel4: UIButton!
    @IBOutlet weak var btnCancel5: UIButton!
    var arrCancel : [String] = ["Plan Changed", "Booked another cab", "My reason is not listed","Driver is not moving", "Driver Denied to come"]
    var selectCancel : Int = 0
    var selectID : Int = 0

    var isViewInvoice : Bool = true
    var isPayment : Bool = false
    
   // @IBOutlet weak var cashLbl : UILabel!
    
    var dictDetail:Dictionary<String,Any> = [:]
    var ispastride:Bool?
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        //SET DETAILS
        viewPickup.layer.masksToBounds = true
        viewPickup.layer.cornerRadius = 5
        imgColor(img: imgDrop, colorHex: "6AC33E")
        viewInvoice.isHidden = true
        viewCancel.isHidden = true
        
//        userRating.fullImage = #imageLiteral(resourceName: "star-filled")
//        userRating.emptyImage = #imageLiteral(resourceName: "start-unfilled")
//        userRating.minRating = 0
//        userRating.maxRating = 5
//        userRating.rating = 0
//        userRating.editable = false
//        userRating.minImageSize = CGSize(width: 3, height: 3)
//        //userRating.floatRatings = true
//        userRating.contentMode = .scaleAspectFit
//
        
        getHistory(request_id: dictDetail["id"] as! Int)
        
        viewComment.isHidden = false
        btnCancel.backgroundColor = UIColor.black
        lblHeader.text = "History"
        if ispastride == false{
            viewComment.isHidden = true
            lblHeader.text = "Upcoming Ride"
            //BTN
            btnCancel.setTitle("Cancel Ride", for: .normal)
            btnCancel.backgroundColor = UIColor.red
        }
    }
    


    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK:- WebService for History Detail List
    func getHistory(request_id:Int){
        var serviceStr:String = ""
        DispatchQueue.main.async {
            self.loader.isHidden = false
        }
        
        if ispastride!{
           serviceStr = Base.pastHistory.rawValue
        }else{
           serviceStr = Base.upcomingHistory.rawValue
        }
        
        let url = "\(baseUrl)\(serviceStr)" + "request_id=" + "\(request_id)"
        let network = NetworkHelper()
        network.delegate = self
        network.getDataFromUrlWithGET(url: url, requestName: "History Detail")
    }
    
    //MARK:- Receive Service Methods
    func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            print(dic)
            switch requestName{
            case "History Detail" :
                if dic.keys.contains("error") {
                    showAlert(message: dic["error"] as? String ?? "", okHandler: nil, fromView: self)
                }else{
                  let data = dic["data"] as! Array<Dictionary<String, Any>>
                    if data.count > 0{
                        
                        
                        self.selectID =  data[0]["id"] as! Int
                        //IMAGE
                        let pictureUrl = data[0]["static_map"] as? String ?? ""
                        let url = URL(string: pictureUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

                        do {
                            let data = try NSData(contentsOf: url!, options: NSData.ReadingOptions())
                            self.mapImgView.image = UIImage(data: data as Data)
                        } catch {
                            self.mapImgView.image = UIImage(named: "rd-map")
                        }
                        
                        
                        //PROVIDER
                        let provider = data[0]["provider"] as? Dictionary<String,Any>
                        self.nameLbl.text = "Not assigned yet"
                        if let provider = provider{
                            
                        
                            self.nameLbl.text = "\(provider["first_name"] as? String ?? "")" + "\(provider["last_name"] as? String ?? "")"
                            
//                            self.viewRating.rating = 3.0
                            let rating = provider["rating"]  as? String
                            print(rating ?? "")
                            self.viewRating.rating = Double(rating ?? "") ?? 0.0
                            
                            let pictureUrl = provider["avatar"] as? String ?? ""
                            self.userImg.setImage(with: "\(baseUrl)/\(pictureUrl)", placeHolder: UIImage(named:"userPlaceholder"))

                            
                        }
                        
                        //SET DATE AND TIME
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let dateStr = data[0]["assigned_at"] as? String ?? ""
                        let date = dateFormatter.date(from:dateStr)
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        let dateStrVal = dateFormatter.string(from: date!)
                        self.dateLbl.text = "\(dateStrVal)"
                        dateFormatter.dateFormat = "hh:mm a"
                        let timeStrVal = dateFormatter.string(from: date!)
                        self.timeLbl.text = "\(timeStrVal)"
                        
                        

                        //OTHER DETAILS
                        self.bookingIdLbl.text = data[0]["booking_id"] as? String ?? ""
                        let pickup = data[0]["s_address"] as? String ?? ""
                        self.pickLbl.text = pickup.replacingOccurrences(of: " ", with: "")

                        let drop = data[0]["d_address"] as? String ?? ""
                        self.dropLbl.text = drop.replacingOccurrences(of: " ", with: "")
                      
                        self.payTypeLbl.text = data[0]["payment_mode"] as? String ?? ""
                       
                        let payment = data[0]["payment"] as? Dictionary<String,Any>
                        self.isPayment = false
                        if let pay = payment{
                            self.isPayment = true
                            self.paymentLbl.text = "$" + "\(pay["total"] as? String ?? "")"
                            self.lblTotal.text = "$" + "\(pay["total"] as? String ?? "")"
                            self.lblTax.text = "$" + "\(pay["tax"] as? String ?? "")"
                            self.lblDistance.text = "$" + "\(pay["distance"] as? String ?? "")"
                            self.lblFare.text = "$" + "\(pay["fixed"] as? String ?? "")"
                            self.lblBookinId.text = data[0]["booking_id"] as? String ?? ""
                        }
                        let rating = data[0]["rating"] as? Dictionary<String,Any>
                        self.commentsLbl.text = "No comment available"
                        if let rating = rating{
                            let comment = rating["user_comment"]  as? String
                            if comment != "" && comment != nil{
                                self.commentsLbl.text = rating["user_comment"] as? String ?? "No comment available"
                            }
                        }
                    }
                }
            case Base.upcomingHistory.rawValue :
                if dic.keys.contains("error") {
                    showAlert(message: dic["error"] as? String ?? "", okHandler: nil, fromView: self)
                }else{
                    
                }
                
            case Base.cancelRequest.rawValue:
                self.navigationController?.popViewController(animated: true)
                
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
    
    
    // MARK: - Action Methode
   
    @IBAction func BtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnViewInvoiceClicked(_ sender: Any) {
        
        if ispastride == true{
            if isPayment{
                if isViewInvoice{
                    isViewInvoice = false
                    viewInvoice.isHidden = false
                }else{
                    isViewInvoice = true
                    viewInvoice.isHidden = true
                }
            }
        }
        else{
            viewCancel.isHidden = false
        }
       
    }
    @IBAction func btnCloseClicked(_ sender: Any) {
        isViewInvoice = true
        viewInvoice.isHidden = true
    }
    
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {

        btnCancel1.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel2.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel3.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel4.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)
        btnCancel5.setImage(UIImage(named: "ic_radio_unselect"), for: .normal)

        if sender.tag == 0{
            btnCancel1.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 1{
            btnCancel2.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 2{
            btnCancel3.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 3{
            btnCancel4.setImage(UIImage(named: "ic_radio_select"), for: .normal)

        }else if sender.tag == 4{
            btnCancel5.setImage(UIImage(named: "ic_radio_select"), for: .normal)
        }
    }
    @IBAction func btnOKClicked(_ sender: Any) {
        viewCancel.isHidden = true
        cancelRequest(reason: arrCancel[selectCancel], selectId: selectID)
    }
    @IBAction func btnNOClicked(_ sender: Any) {
        viewCancel.isHidden = true
    }

    
    func cancelRequest(reason : String , selectId : Int) {
        let params:Parameters = ["request_id":selectId,
                                 "cancel_reason":reason]
        
        self.loader.isHidden = false
        let url = "\(baseUrl)\(Base.cancelRequest.rawValue)"
        let network = NetworkHelper()
        network.delegate = self
        network.getDataFromUrlWithAccessPOST(url: url, requestName: Base.cancelRequest.rawValue, headerField: "", parameter: params)
        
    }
}


extension HistoryPastDetailVC  {
//    func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
//        self.loader.isHidden = true
//        self.navigationController?.popViewController(animated: true)
//    }
    
   

}
