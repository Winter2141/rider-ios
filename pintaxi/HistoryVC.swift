//
//  HistoryVC.swift
//  TranxitUser
//
//  Created by 99appdev on 27/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

class HistoryVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate , HistoryCellAction , UICollectionViewDelegateFlowLayout{
    
    let reach = NetworkReachabilityManager ()
    
    @IBOutlet weak var leadingLblMove: NSLayoutConstraint!
    
    @IBOutlet weak var ButtonUpcoming: UIButton!
    @IBOutlet weak var imgBackButton: UIImageView!
    
    @IBOutlet weak var ButtonPast: UIButton!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var btnCancel1: UIButton!
    @IBOutlet weak var btnCancel2: UIButton!
    @IBOutlet weak var btnCancel3: UIButton!
    @IBOutlet weak var btnCancel4: UIButton!
    @IBOutlet weak var btnCancel5: UIButton!

    var arrayTripData = [[String : Any]] ()
    var selectCancel : Int = 0
    var selectID : Int = 0
    var arrCancel : [String] = ["Plan Changed", "Booked another cab", "My reason is not listed","Driver is not moving", "Driver Denied to come"]
    
    @IBOutlet weak var MyTripCollection: UICollectionView!
    var indexPage : Int!
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    var DictCompleteData = [String : Any] ()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewCancel.isHidden = true
        indexPage = 0
        self.GetBookingCall()
        self.MyTripCollection.dataSource = self
        self.MyTripCollection.delegate = self
        
        loadGoogleAdmob()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getMyBookings()

    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func GetBookingCall()
    {
        if reach?.isReachable ?? false
        {
            self.getMyBookings()
        }
        else
        {
            showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
        }
        
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
    
    @IBAction func btnPast(_ sender: Any) {
         self.arrayTripData.removeAll()
        indexPage = 0
        UIView.animate(withDuration: 8.0, animations: { () -> Void in
            
            self.leadingLblMove.constant = 0
            
        }, completion: { (finished) -> Void in
            
        })
        ReturnCollectionToIndex (index : 0)
          self.GetBookingCall()
        
    }
    
    @IBAction func btnUpcoming(_ sender: Any) {
        self.arrayTripData.removeAll()
        indexPage = 1
        UIView.animate(withDuration: 8.0, animations: { () -> Void in
            
            self.leadingLblMove.constant = self.ButtonPast.frame.size.width
        }, completion: { (finished) -> Void in
            
        })
        
        ReturnCollectionToIndex (index : 1)
          self.GetBookingCall()
    }
    
    @IBAction func BtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBooking", for: indexPath) as! HistoryCollectionViewCell
        cell.delegate = self
        
        cell.getItemIndex(cellIndex:indexPath.item, ArrayData: self.arrayTripData , page : self.indexPage)
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : self.MyTripCollection.frame.size.width , height : self.MyTripCollection.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        print("page number is \(currentPage)")
        if currentPage == 0
        {
            if indexPage != currentPage
            {
                self.btnPast(self)
            }
        }
        else
        {
            if indexPage != currentPage
            {
                self.btnUpcoming(self)
            }
        }
    }
    
    func ReturnCollectionToIndex (index : Int)
    {
        self.MyTripCollection.scrollToItem(at:IndexPath(item: index, section: 0), at: .right, animated: true)
    }
    
    
    func getRowIndexClicked (indexClicked : Int , dictClicked : [String : Any])
    {
        print("index of table clicked is \(indexClicked) && dict is \(dictClicked)")
       // let historyDetailVc = self.storyboard!.instantiateViewController(withIdentifier: "HistoryPastDetailVC") as! HistoryPastDetailVC
        
        let destViewController : HistoryPastDetailVC = self.storyboard!.instantiateViewController(withIdentifier: "HistoryPastDetailVC") as! HistoryPastDetailVC
        if indexPage == 0
        {
            destViewController.ispastride = true
        }
        else
        {
            destViewController.ispastride = false
        }
        //destViewController.DictCompleteData = self.DictCompleteData
        destViewController.dictDetail = dictClicked
        
       // destViewController.delegate = self
        self.navigationController!.pushViewController(destViewController, animated: false)
    }
    
    func BookingCancel(strCancelID : Int){
        viewCancel.isHidden = false
        selectID = strCancelID
    }
    
    
    func cancelRequest(reason : String , selectId : Int) {
//        let request = Request()
//        request.request_id = selectId
//        request.cancel_reason = reason
        let params:Parameters = ["request_id":selectId,
                                 "cancel_reason":reason]
            
        self.loader.isHidden = false
        let url = "\(baseUrl)\(Base.cancelRequest.rawValue)"
        let network = NetworkHelper()
        network.delegate = self
        network.getDataFromUrlWithAccessPOST(url: url, requestName: Base.cancelRequest.rawValue, headerField: "", parameter: params)
        
    }
          
    
    
    func getMyBookings()
    {
        self.loader.isHidden = false
        let headers = [
            "Authorization": "Bearer \(User.main.accessToken ?? "")",
            "Content-Type":"application/json",
            "X-Requested-With" : "XMLHttpRequest"
        ]
        var strurl = ""
        if indexPage == 0
        {
         strurl = "\(Base.historyList.rawValue)"
        }
        else
        {
         strurl = "\(Base.upcomingList.rawValue)"
        }
        let urlString = "\(baseUrl)\(strurl)"
        Alamofire.request(urlString, method: .get, headers: headers).responseJSON
            {
                response in
                self.loader.isHidden = true

                debugPrint(response)
                if let responseArray =  response.value as? [Any]?{
                    self.arrayTripData = responseArray as! [[String : Any]]
                    print("response array is", responseArray ?? [])
                    
                    DispatchQueue.main.async {
                      self.MyTripCollection.reloadData()
                    }
                }
        }
    }
    

}
extension HistoryVC : ServerCommunicationApiDelegate {
    func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
        self.loader.isHidden = true
        self.getMyBookings()
    }
    
    func dataFailure(error: String, requestName: String) {
    }

}
