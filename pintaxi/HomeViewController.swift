    //
    //  HomeViewController.swift
    //  User
    //
    //  Created by CSS on 02/05/18.
    //  Copyright © 2018 Appoets. All rights reserved.
    //
    
    import UIKit
    import KWDrawerController
    import GoogleMaps
    import GooglePlaces
    import DateTimePicker
    import Firebase
    import MapKit
    //    import PaymentSDK
    import Reachability
    import BraintreeDropIn
    import Braintree
    import FirebaseStorage
    import FirebaseAnalytics
    import FirebaseDatabase
    import Alamofire
    import SDWebImage
    import Razorpay

    var riderStatus : RideStatus = .none // Provider Current Status
    
    class HomeViewController: BaseViewController ,ServerCommunicationApiDelegate{
        
        
        //MARK:- IBOutlets
        
        @IBOutlet weak var estimatedFareBottomContaints: NSLayoutConstraint!
        @IBOutlet  var viewEstimated : UIView!
        @IBOutlet  var viewButton : UIView!
        @IBOutlet  var viewZone : UIView!
        
        @IBOutlet weak var buttonMenu: UIButton!
        @IBOutlet private var viewSideMenu : UIView!
        @IBOutlet var viewCurrentLocation : UIView!
        @IBOutlet weak var viewMapOuter : UIView!
        @IBOutlet weak private var viewFavouriteSource : UIView!
        @IBOutlet weak private var viewFavouriteDestination : UIView!
        @IBOutlet weak private var imageViewFavouriteSource : ImageView!
        @IBOutlet weak private var imageViewFavouriteDestination : ImageView!
        @IBOutlet weak var viewSourceLocation : UIView!
        @IBOutlet weak var viewDestinationLocation : UIView!
        @IBOutlet weak private var viewAddress : UIView!
        @IBOutlet weak var viewAddressOuter : UIView!
        @IBOutlet weak var textFieldSourceLocation : UITextField!
        @IBOutlet weak private var textFieldDestinationLocation : UITextField!
        @IBOutlet weak private var imageViewMarkerCenter : UIImageView!
        @IBOutlet weak private var imageViewSideBar : UIImageView!
        @IBOutlet weak var buttonSOS : UIButton!
        @IBOutlet weak private var viewHomeLocation : UIView!
        @IBOutlet weak private var viewWorkLocation : UIView!
        @IBOutlet weak var viewChangeDestinaiton : UIView!
        @IBOutlet weak var viewLocationDot : UIView!
        @IBOutlet weak var viewLocationButtons : UIStackView!
        @IBOutlet weak var buttonWithoutDest:UIButton! //not used
        @IBOutlet var constraint : NSLayoutConstraint!
        @IBOutlet var con_mapView : NSLayoutConstraint!
        @IBOutlet weak var btnCash : UIButton!
        @IBOutlet weak var btnPromocode : UIButton!

        //Estimated Fare PopUp
        @IBOutlet weak var sourceLbl : UILabel!
        @IBOutlet weak var destinationLbl : UILabel!
        @IBOutlet weak var lblDistance : UILabel!
        @IBOutlet weak var durationLbl : UILabel!
        @IBOutlet weak var PriceLbl:UILabel! //not used
        @IBOutlet weak var viewPickuo:UIView! //not used
        @IBOutlet weak var view1:UIView! //not used
        @IBOutlet weak var view2:UIView! //not used
        @IBOutlet weak var view3:UIView! //not used
        @IBOutlet weak var view4:UIView! //not used
        @IBOutlet weak var imgDrop:UIImageView! //not used
        @IBOutlet var con_CouponHieght : NSLayoutConstraint!
        @IBOutlet weak var viewRequesr1:UIView!
        @IBOutlet weak var viewRequesr2:UIView!
        @IBOutlet weak var viewRequesr3:UIView!
        @IBOutlet weak var btnConfirm:UIButton!
        @IBOutlet weak var imgCarConfrim:UIImageView!

        @IBOutlet weak var viewStatus1:UIView!
        @IBOutlet weak var viewStatus2:UIView!
        @IBOutlet weak var viewStatus3:UIView!
        @IBOutlet weak var viewStatus4:UIView!
        @IBOutlet weak var viewStatus5:UIView!
        @IBOutlet weak var imgStatus1:UIImageView!
        @IBOutlet weak var imgStatus2:UIImageView!
        @IBOutlet weak var imgStatus3:UIImageView!
        @IBOutlet weak var imgStatus4:UIImageView!

        @IBOutlet weak var stackBanner: UIStackView!
        var statusTypeView : StatusTypeView?
        var selectCare : String = ""
        var isMapSet : Bool = false
        var isConfimBooking = false
        
        //MARK:- Local Variable
        var withoutDest:Bool = false
        var currentRequestId = 0
        var pathIndex = 0
        var isInvoiceShowed:Bool = false
        private var isUserInteractingWithMap = false // Boolean to handle Mapview User interaction
        private var isScheduled = false // Flag For Schedule
        var isTapDone:Bool = false
        
        var sourceLocationDetail : Bind<LocationDetail>? = Bind<LocationDetail>(nil)
        var currentLocation = Bind<LocationCoordinate>(defaultMapLocation)
        
        var providerLastLocation = LocationCoordinate()
        //var serviceSelectionView : ServiceSelectionView?
        var estimationFareView : RequestSelectionView?
        var statusView:StatusTypeView?
        private var infoWindow = PinInfoView()
        var couponView : CouponView?
        var locationSelectionView : LocationSelectionView?
        var requestLoaderView : LoaderView?
        var invoiceView : InvoiceView?
        var ratingView : RatingView?
        var rideNowView : RideNowView?
        var floatyButton : Floaty?
        var reasonView : ReasonView?
        var timerETA : Timer?
        var cancelReason = [ReasonEntity]()
        var markersProviders = [GMSMarker]()
        var reRouteTimer : Timer?
        var listOfProviders : [Provider]?
        var selectedService : Service?
        var mapViewHelper : GoogleMapsHelper?
        final var currentProvider: Provider?
        
        @IBOutlet weak var collectionService: UICollectionView!
        var ArrServices = [[String : Any]] ()
        var fareArr:Array<Any> = []
        var timeDuration:String?
        var distanceKm:String = ""
        var selectedItem = NSMutableArray()
        var selectedPriceArr = NSMutableArray()
        var routeArr:Array<Dictionary<String,Any>> = []
        
        var scheduleDate:String?
        var scheduleTime:String?
        var isSchedule:Bool = false
        var strCardID:String = ""
        var currentLocationValue : Double = 0.0
        var setTimeStatus : String = ""
        var razorpay: RazorpayCheckout!

        fileprivate var locationMarker : GMSMarker? = GMSMarker()

        
        
        lazy var markerProviderLocation : GMSMarker = {  // Provider Location Marker
            let marker = GMSMarker()
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
            imageView.contentMode =  .scaleAspectFit
            imageView.image = #imageLiteral(resourceName: "map-vehicle-icon-black")
            marker.iconView = imageView
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = self.mapViewHelper?.mapView
            return marker
        }()
        
        private var selectedLocationView = UIView() // View to change the location pinpoint
            {
            didSet{
                if !([viewSourceLocation, viewDestinationLocation].contains(selectedLocationView)) {
                    [viewSourceLocation, viewDestinationLocation].forEach({ $0?.transform = .identity })
                }
            }
        }
        
        
        var isOnBooking = false {  // Boolean to handle favourite source location
            didSet{
            }
        }
        
        private var isSourceFavourited = false {  // Boolean to handle favourite source location
            didSet{
                self.isAddFavouriteLocation(in: self.viewFavouriteSource, isAdd: isSourceFavourited)
            }
        }
        
        private var isDestinationFavourited = false { // Boolean to handle favourite destination location
            didSet{
                self.isAddFavouriteLocation(in: self.viewFavouriteDestination, isAdd: isDestinationFavourited)
            }
        }
        
        var destinationLocationDetail : LocationDetail? {  // Destination Location Detail
            didSet{
                DispatchQueue.main.async {
                    self.isDestinationFavourited = false // reset favourite location on change
                    if self.destinationLocationDetail == nil {
                        self.isDestinationFavourited = false
                    }
                    self.textFieldDestinationLocation.text = (self.destinationLocationDetail?.address.removingWhitespaces().isEmpty ?? true) ? nil : self.destinationLocationDetail?.address
                }
            }
        }
        
        var rideStatusView : RideStatusView? {
            didSet {
                if self.rideStatusView == nil {
                    self.floatyButton?.removeFromSuperview()
                }
            }
        }
        
        lazy var loader  : UIView = {
            return createActivityIndicator(self.view)
        }()
        
        //MARKERS
        
        var sourceMarker : GMSMarker = {
            let marker = GMSMarker()
            marker.title = Constants.string.ETA.localize()
            marker.appearAnimation = .pop
            marker.icon =  #imageLiteral(resourceName: "ub__ic_pin_pickup").resizeImage(newWidth: 30)
            return marker
        }()
        
        var destinationMarker : GMSMarker = {
            let marker = GMSMarker()
            marker.appearAnimation = .pop
            marker.icon =  #imageLiteral(resourceName: "ub__ic_pin_dropoff").resizeImage(newWidth: 30)
            return marker
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //self.getServices()
            self.clearAllView()
            
            
            debugPrint("cofirmAdmob123", isConfirmAdmob)
            
        }
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            loadGoogleAdmob1(stack: stackBanner)
        }
        override func viewWillAppear(_ animated: Bool) {
            razorpay = RazorpayCheckout.initWithKey("rzp_test_zGD0bTIi1I9XnS", andDelegate: self)

            
            super.viewWillAppear(animated)
            self.viewWillAppearCustom()
            self.getUserDetails()
            
            btnCash.setTitle(Payment_type, for: .normal)

            riderStatus = .none
            
            //SET VIEW
            viewZone.isHidden = true
            viewPickuo.layer.masksToBounds = true
            viewPickuo.layer.cornerRadius = 5
            imgColor(img: imgDrop, colorHex: "FFFFFF")
            
            setViewShadow(myView: viewRequesr1)
            setViewShadow(myView: viewRequesr2)
            setViewShadow(myView: viewRequesr3)
            btnConfirm.layer.masksToBounds = true
            btnConfirm.layer.cornerRadius = 5
            
            // Chat push redirection
            NotificationCenter.default.addObserver(self, selector: #selector(isChatPushRedirection), name: NSNotification.Name("ChatPushRedirection"), object: nil)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(clearAllView), name: NSNotification.Name("ChacelRequesrt"), object: nil)

        }
        
        func setViewShadow(myView : UIView) {
            //SER CONFIRM REQUEST
            myView.layer.shadowPath =
                UIBezierPath(roundedRect: myView.bounds,
                             cornerRadius: myView.layer.cornerRadius).cgPath
            myView.layer.shadowColor = UIColor.black.cgColor
            myView.layer.shadowOpacity = 0.2
            myView.layer.shadowOffset = CGSize(width: 2, height: 2)
            myView.layer.shadowRadius = 5
            myView.layer.masksToBounds = false
            myView.layer.cornerRadius = 10
            
        }
        override var preferredStatusBarStyle : UIStatusBarStyle {
            return UIStatusBarStyle.default
        }
        
        @objc func isChatPushRedirection() {
            
            if let ChatPage = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.ChatVC) as? ChatVC {
//                ChatPage.set(user: self.currentProvider ?? Provider(), requestId: self.currentRequestId)
                let navigation = UINavigationController(rootViewController: ChatPage)
                self.present(navigation, animated: true, completion: nil)
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            NotificationCenter.default.removeObserver(self)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            self.viewLayouts()
        }
        
        //MARK:- WebService for Promo List
        func getEstimatedFareHit(){
            fareArr.removeAll()
            DispatchQueue.main.async {
                //  self.loader.isHidden = false
            }
            
            DispatchQueue.global(qos: .userInteractive).async {
                guard let sourceLocation = self.sourceLocationDetail?.value?.coordinate, let destinationLocation = self.destinationLocationDetail?.coordinate, sourceLocation.latitude>0, sourceLocation.longitude>0, destinationLocation.latitude>0, destinationLocation.longitude>0 else {
                    return
                }
                
                for i in 0..<self.ArrServices.count{
                    let dic = self.ArrServices[i]
                    let service_id = dic["id"] as! Int
                    let url = "\(baseUrl)\(Base.estimateFare.rawValue)\("s_latitude=")\(sourceLocation.latitude)\("&s_longitude=")\(sourceLocation.longitude)\("&d_latitude=")\(destinationLocation.latitude)\("&d_longitude=")\(destinationLocation.longitude)\("&service_type=")\(service_id)"
                    let network = NetworkHelper()
                    network.delegate = self
                    network.getDataFromUrlWithGET(url: url, requestName: Base.estimateFare.rawValue)
                }
            }
        }
        
        //MARK:- Receive Service Methods
        func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
            DispatchQueue.main.async {
                self.loader.isHidden = true
                print(dic)
                switch requestName{
                case Base.estimateFare.rawValue :
                    self.fareArr.append(dic)
                    if self.fareArr.count == self.ArrServices.count {
                        self.isOnBooking = true
                        self.selectedPriceArr.removeAllObjects()
                        
                        let obj = self.ArrServices[0]
                        let pictureUrl = obj["image"] as? String ?? ""
                        self.selectCare = "\(baseUrl)/\(pictureUrl)"
                        self.selectedPriceArr.add(self.fareArr[0])
                        self.collectionService.dataSource = self
                        self.collectionService.delegate = self
                        self.collectionService.reloadData()
                    }
                    
                    break
                    
                case "directionApi" :
                    self.routeArr = dic["routes"] as! Array<Dictionary<String,Any>>
                    if self.routeArr.count > 0{
                        let legArr = self.routeArr[0]["legs"] as? Array<Dictionary<String,Any>>
                        let distance = legArr![0]["distance"] as? Dictionary<String,Any>
                        let durationArr = legArr![0]["duration"] as? Dictionary<String,Any>
                        print(distance?["text"] as? Float ?? 0.0 )
                        print(durationArr?["text"] as? String ?? "")
                        
                        self.imgCarConfrim.layer.masksToBounds = true
                        self.imgCarConfrim.layer.cornerRadius = self.imgCarConfrim.frame.size.height / 2

                        
                        self.timeDuration = durationArr?["text"] as? String ?? ""
                        self.distanceKm = distance?["text"] as! String
                        self.sourceLbl.text = self.textFieldSourceLocation.text
                        self.destinationLbl.text = self.textFieldDestinationLocation.text
                        self.durationLbl.text = self.timeDuration
                        self.lblDistance.text = self.distanceKm
                        
                        if self.selectedPriceArr.count > 0{
                            print(self.selectedPriceArr)
                            for i in 0..<self.selectedPriceArr.count{
                                let dic = self.selectedPriceArr[i] as? NSDictionary
                                let currency = dic?["currency"] as? String ?? ""
                                let fare =  dic?.getStringForID(key: "estimated_fare")
                                self.PriceLbl.text = "\(currency)" + " \(fare!)"
                            }
                        }
                    }
                    break
                case  Base.sendRequest.rawValue:
                    if dic.keys.contains("error") {
                        showAlert(message: dic["error"] as? String ?? "", okHandler: nil, fromView: self)
                    }else{
                        let message = dic["message"] as? String ?? ""
                        if message == "New request Created!" {
                            self.hideEstimatedFarePop()
                            self.showLoaderView(with: 0)
                        }
                        else{
                            self.hideEstimatedFarePop()
                            showAlert(message: message , okHandler: nil, fromView: self)
                        }
                    }
                    
                    
                case Base.zone.rawValue:
                    self.viewZone.isHidden = true
                    self.viewEstimated.isHidden = false
                    self.viewButton.isHidden = false
                    self.imageViewSideBar.image = #imageLiteral(resourceName: "left-arrow")
                    self.con_CouponHieght.constant = 40
                    self.btnCash.isHidden = false
                    self.btnPromocode.isHidden = false
                    
                    let dicdata = dic as? NSDictionary
                    if dicdata?.getStringForID(key: "status") == "0"{
                        self.viewZone.isHidden = false
                        self.viewEstimated.isHidden = true
                        self.viewButton.isHidden = true
                    }
                    break
                    
                case "getDistance" :
                    self.routeArr = dic["routes"] as! Array<Dictionary<String,Any>>
                    if self.routeArr.count > 0{
                        let legArr = self.routeArr[0]["legs"] as? Array<Dictionary<String,Any>>
                        let distance = legArr![0]["distance"] as? Dictionary<String,Any>
                        let durationArr = legArr![0]["duration"] as? Dictionary<String,Any>


                        self.setTimeStatus = durationArr?["text"] as? String ?? ""
                        self.rideStatusView?.setETA(time: distance?["text"] as! String, duration: self.setTimeStatus)

                    }
                    break
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
        
        //MARK:- USERDETAILS.....
        func getUserDetails()
        {
            self.loader.isHidden = false
            
            let headers = [
                "Authorization": "Bearer \(User.main.accessToken ?? "")",
                "Content-Type":"application/json",
                "X-Requested-With" : "XMLHttpRequest"
            ]
            let urlString = "\(baseUrl)\(Base.getProfile.rawValue)"
            Alamofire.request(urlString, method: .get, headers: headers).responseJSON
                {
                    response in
                    debugPrint(response)
                    if let responseDict =  response.value as? NSDictionary?{
                        if responseDict?["location"] != nil
                        {
                            let arrayLocation = responseDict?["location"] as? [[String : Any]] ?? [[:]]
                            let dataLocation : NSData = NSKeyedArchiver.archivedData(withRootObject: arrayLocation) as NSData
                            UserDefaults.standard.set(dataLocation, forKey: "user_location")
                        }
                    }
                    
            }
            self.loader.isHidden = true
        }
        
      
        func getServices()
        {
            self.loader.isHidden = false
            viewEstimated.isHidden = true
            let headers = [
                "Authorization": "Bearer \(User.main.accessToken ?? "")",
                "Content-Type":"application/json",
                "X-Requested-With" : "XMLHttpRequest"
            ]
            let urlString = "\(baseUrl)\(Base.servicesList.rawValue)"
            Alamofire.request(urlString, method: .get, headers: headers).responseJSON
                {
                    response in
                    debugPrint(response)
                    self.loader.isHidden = true

                    if let responseArray =  response.value as? [[String : Any]]?{
                        self.viewEstimated.isHidden = false
                        self.ArrServices = [[String : Any]] ()
                        // print("response array is ", responseArray)
                        self.ArrServices = responseArray ?? [[:]]
                        self.selectedItem.add(self.ArrServices[0])
                        self.collectionService.dataSource = self
                        self.collectionService.delegate = self
                        self.collectionService.reloadData()
                    }
            }
        }
        
        @IBAction func btnRequestRide(_ sender: Any) {
          
            //viewAddressOuter.backgroundColor = UIColor.white
            setRequest()
        }
        
        func setRequest() {
            guard  let source = self.textFieldSourceLocation.text, !source.isEmpty else {
                
                showAlert(message: "\(ErrorMessage.list.emptySourceLocation)", okHandler: nil, fromView: self)
                
                return
            }
            guard  let destination = self.textFieldDestinationLocation.text, !destination.isEmpty else {
                
                showAlert(message: "\(ErrorMessage.list.emptySourceLocation)", okHandler: nil, fromView: self)
                
                return
            }
            self.imgCarConfrim.setImage(with: self.selectCare, placeHolder: UIImage(named:"CarplaceHolder"))
            self.sourceLbl.text = self.textFieldSourceLocation.text
            self.destinationLbl.text = self.textFieldDestinationLocation.text
            
            getETA()
            showEstimatedFarePop()
        }
        
        @IBAction func btnConfirmRide(_ sender: Any) {
//            hideEstimatedFarePop()
            isConfimBooking = true
            requesrSendCall()
            
        }
        
        
        @IBAction func btnMenuClicked(_ sender: UIButton) {
            
            if self.estimatedFareBottomContaints.constant == 0{
                hideEstimatedFarePop()
            }
            else if con_CouponHieght.constant == 40{
                clearAllView()
            }
            else{
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
        
        
        func hideEstimatedFarePop(){
            viewEstimated.isHidden = false
            viewButton.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.estimatedFareBottomContaints.constant = 600
                self.view.layoutIfNeeded()
            }
        }
        
        func showEstimatedFarePop(){
            viewEstimated.isHidden = true
            viewButton.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.estimatedFareBottomContaints.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        // get Distance
        func getETA(){
            guard let sourceLocation = self.sourceLocationDetail?.value?.coordinate, let destinationLocation = self.destinationLocationDetail?.coordinate, sourceLocation.latitude>0, sourceLocation.longitude>0, destinationLocation.latitude>0, destinationLocation.longitude>0 else {
                return
            }
            let googleUrl = "https://maps.googleapis.com/maps/api/directions/json"
            let url = "\(googleUrl)\("?origin=")\(sourceLocation.latitude)\(",")\(sourceLocation.longitude)\("&destination=")\(destinationLocation.latitude)\(",")\(destinationLocation.longitude)\("&sensor=false&key=")\(googleMapKey)"
            let network = NetworkHelper()
            network.delegate = self
            network.getDataFromUrlWithGET(url: url, requestName: "directionApi")
        }
        
        func requesrSendCall(){
            guard let sourceLocation = self.sourceLocationDetail?.value?.coordinate, let destinationLocation = self.destinationLocationDetail?.coordinate, sourceLocation.latitude>0, sourceLocation.longitude>0, destinationLocation.latitude>0, destinationLocation.longitude>0 else {
                return
            }
            var serviceType_id:Int?
            var strPay:String = ""
            let s_lat = sourceLocation.latitude
            let s_long = sourceLocation.longitude
            let d_lat = destinationLocation.latitude
            let d_long = destinationLocation.longitude
            let s_address = textFieldSourceLocation.text
            let d_address = textFieldDestinationLocation.text
            // self.distance
            if selectedItem.count > 0{
                let dic = selectedItem[0] as? Dictionary<String,Any>
                serviceType_id =  dic?["id"] as? Int ?? 0
            }
            
            if strCardID == "" {
                strPay = "CASH"
            }else{
                strPay = "CARD"
            }
            
            // Check Schedule Time
            var distanceVal:Float = 0.0
            let str = self.distanceKm.dropLast(3)
            let formattedString = str.replacingOccurrences(of: ",", with: "")
            let dist = Int(formattedString)
            if dist != nil{
                distanceVal = Float(dist!)
            }else{
                distanceVal = Float(formattedString)!
            }
            
            var Card : String = ""
            if Payment_type == "CARD"{
                Card = selected_Card?.card_id ?? ""
                
            }
            
            if isSchedule{
                let params:Parameters = ["s_latitude":s_lat,
                                         "s_longitude":s_long,
                                         "d_latitude":d_lat,
                                         "d_longitude":d_long,
                                         "service_type":serviceType_id!,
                                         "distance":distanceVal,
                                         "payment_mode":strPay,
                                         "card_id":Card,
                                         "s_address":s_address!,
                                         "d_address":d_address!,
                                         "use_wallet":User.main.wallet_balance ?? "",
                                         "schedule_date":scheduleDate!,
                                         "schedule_time":scheduleTime!]
                SendRequestApiCall(parameters: params)
                
            }else{
                let param:Parameters = ["s_latitude":s_lat,
                                        "s_longitude":s_long,
                                        "d_latitude":d_lat,
                                        "d_longitude":d_long,
                                        "s_address":s_address!,
                                        "d_address":d_address!,
                                        "service_type":serviceType_id!,
                                        "distance":distanceVal,
                                        "schedule_date" : "",
                                        "schedule_time" : "",
                                        "use_wallet":User.main.wallet_balance ?? "",
                                        "payment_mode":Payment_type,
                                        "card_id":Card]
                SendRequestApiCall(parameters: param)
            }
        }
        
        // Call Send Request Api
        
        func SendRequestApiCall(parameters:Parameters){
            print(parameters)
            self.loader.isHidden = false
            let url = "\(baseUrl)\(Base.sendRequest.rawValue)"
            let network = NetworkHelper()
            network.delegate = self
            network.getDataFromUrlWithAccessPOST(url: url, requestName: Base.sendRequest.rawValue, headerField: "", parameter: parameters)
            
        }
        
        
        @IBAction func btnAddPromoCoupon(_ sender: Any) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "PromoCouponVC") as? PromoCouponVC
            navigationController?.pushViewController(vc!, animated: true)
        }
        @IBAction func btnPaymentType(_ sender: Any) {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentsViewController") as? PaymentsViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
         
        
//        @IBAction func btnPayment(_ sender: Any) {
//            let payment = storyboard?.instantiateViewController(withIdentifier: "PaymentsViewController") as? PaymentsViewController
//            navigationController?.pushViewController(payment!, animated: true)
//        }
        
        @IBAction func btnScheduleRide(_ sender: Any) {
            guard  let source = self.textFieldSourceLocation.text, !source.isEmpty else {
                showAlert(message: "\(ErrorMessage.list.emptySourceLocation)", okHandler: nil, fromView: self)
                return
            }
            guard  let destination = self.textFieldDestinationLocation.text, !destination.isEmpty else {
                showAlert(message: "\(ErrorMessage.list.emptyDestinationLocation)", okHandler: nil, fromView: self)
                return
            }
            
            schedulePickerView { (date) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateStr = dateFormatter.string(from: date)
                print(dateStr)
                self.scheduleDate = dateStr
                dateFormatter.dateFormat = "hh:mm:a"
                let timeStr = dateFormatter.string(from: date)
                print(timeStr)
                self.scheduleTime = timeStr
                self.isSchedule = true
                self.setRequest()
            }
        }
        
    }
    
    
    
    // MARK:- Local  Methods
    
    extension HomeViewController {
        
        private func initialLoads() {
            
            self.addMapView()
            // self.getFavouriteLocations()
            // self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
            self.navigationController?.isNavigationBarHidden = true
            self.viewFavouriteDestination.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
            self.viewFavouriteSource.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
            [self.viewSourceLocation, self.viewDestinationLocation].forEach({ $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationTapAction(sender:))))})
            self.currentLocation.bind(listener: { (locationCoordinate) in
                // TODO:- Handle Current Location
                if locationCoordinate != nil {
                    self.mapViewHelper?.moveTo(location: locationCoordinate!, with: self.viewMapOuter.center)
                }
            })
            self.viewCurrentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getCurrentLocation)))
            self.sourceLocationDetail?.bind(listener: { (locationDetail) in
                //                if locationDetail == nil {
                //                    self.isSourceFavourited = false
                //                }
                DispatchQueue.main.async {
                    self.isSourceFavourited = false // reset favourite location on change
                    self.textFieldSourceLocation.text = locationDetail?.address
                    self.textFieldSourceLocation.textColor = .white
                }
            })
            // destination pin
            
            // self.viewDestinationLocation.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.checkForProviderStatus()
            self.buttonSOS.isHidden = true
            self.buttonSOS.addTarget(self, action: #selector(self.buttonSOSAction), for: .touchUpInside)
            self.setDesign()
            NotificationCenter.default.addObserver(self, selector: #selector(self.observer(notification:)), name: .providers, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.networkChanged(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
            
            
            //            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowRateView(info:)), name: .UIKeyboardWillShow, object: nil)
            //            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideRateView(info:)), name: .UIKeyboardWillHide, object: nil)      }
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.presenter?.get(api: .getProfile, parameters: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                // self.presenter?.get(api: .cancelReason, parameters: nil)
            })
            //MARK :Hide it , android is not have
            //            self.viewFavouriteSource.isHidden = true
            //            self.viewFavouriteDestination.isHidden = true
            //            self.viewChangeDestinaiton.isHidden = true
            //self.viewChangeDestinaiton.backgroundColor = .primary
            //            self.buttonWithoutDest.addTarget(self, action: #selector(tapWithoutDest), for: .touchUpInside)
            self.reRouteTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (_) in
                if isRerouteEnable {
                    self.drawPolyline(isReroute: true)
                    print("Reroute Timer")
                }
                if riderStatus == .pickedup {
                    self.updateCamera()
                }
            })
            
            
            self.reRouteTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { (_) in
                self.getAllProviders()
            })

        }
        
        //  viewWillAppearCustom
        
        private func viewWillAppearCustom() {
            isInvoiceShowed = false
            self.navigationController?.isNavigationBarHidden = true
            self.localize()
            self.getFavouriteLocationsFromLocal()
            self.getAllProviders()
        }
        
        //  View Will Layouts
        
        private func viewLayouts() {
            
            self.viewCurrentLocation.makeRoundedCorner()
            self.mapViewHelper?.mapView?.frame = viewMapOuter.bounds
            self.viewSideMenu.makeRoundedCorner()
            self.navigationController?.isNavigationBarHidden = true
        }
        
        @IBAction private func getCurrentLocation(){
            
            self.viewCurrentLocation.addPressAnimation()
            if currentLocation.value != nil {
                self.mapViewHelper?.getPlaceAddress(from: currentLocation.value!, on: { (locationDetail) in  // On Tapping current location, set
                    if self.selectedLocationView == self.viewSourceLocation {
                        self.sourceLocationDetail?.value = locationDetail
                    } else if self.selectedLocationView == self.viewDestinationLocation {
                        self.destinationLocationDetail = locationDetail
                    }
                })
                self.mapViewHelper?.moveTo(location: self.currentLocation.value!, with: self.viewMapOuter.center)
            }
        }
        
        //  Localize
        
        private func localize(){
            
//            self.textFieldSourceLocation.placeholder = Constants.string.source.localize()
//            self.textFieldDestinationLocation.placeholder = Constants.string.destination.localize()
//            self.textFieldDestinationLocation.attributedPlaceholder = NSAttributedString(string: Constants.string.destination.localize(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            
            self.textFieldSourceLocation.attributedPlaceholder = NSAttributedString(string:Constants.string.source.localize(), attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font :UIFont(name: "Montserrat-SemiBold", size: 16)!])
            
            self.textFieldDestinationLocation.attributedPlaceholder = NSAttributedString(string:Constants.string.destination.localize(), attributes:[NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font :UIFont(name: "Montserrat-SemiBold", size: 16)!])
            //            self.buttonWithoutDest.setTitle(Constants.string.withoutDest, for: .normal)
            
        }
        
        func getAllProviders() {
            if currentLocation.value?.latitude != nil || currentLocation.value?.longitude != nil {
                let json = [Constants.string.latitude : self.sourceLocationDetail?.value?.coordinate.latitude ?? defaultMapLocation.latitude, Constants.string.longitude : self.sourceLocationDetail?.value?.coordinate.longitude ?? defaultMapLocation.longitude] as [String : Any]
                self.presenter?.get(api: .getProviders, parameters: json)
            }
        }
        
        //  Set Design
        
        private func setDesign() {
            
            // Common.setFont(to: textFieldSourceLocation)
            // Common.setFont(to: textFieldDestinationLocation)
            //            Common.setFont(to: buttonWithoutDest)
            //            Common.setFont(to: buttonWithoutDest, isTitle: true, size: 17)
            //            buttonWithoutDest.titleLabel?.textColor = .primary
        }
        
        //  Add Mapview
        
        private func addMapView(){
            
            self.mapViewHelper = GoogleMapsHelper()
            self.mapViewHelper?.getMapView(withDelegate: self, in: self.viewMapOuter)
            self.getCurrentLocationDetails()
        }
        // Getting current location detail
        private func getCurrentLocationDetails() {
            self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
                if self.sourceLocationDetail?.value == nil {
                    self.mapViewHelper?.getPlaceAddress(from: location.coordinate, on: { (locationDetail) in
                        self.sourceLocationDetail?.value = locationDetail
                    })
                }
                self.currentLocation.value = location.coordinate
            })
        }
        
        
        
        
        func showRideNowWithoutDest(with source : [Service]) {
            
            
            if self.rideNowView == nil {
                
                self.rideNowView = Bundle.main.loadNibNamed(XIB.Names.RideNowView, owner: self, options: [:])?.first as? RideNowView
                self.rideNowView?.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-self.rideNowView!.frame.height), size: CGSize(width: self.view.frame.width, height: self.rideNowView!.frame.height))
                self.rideNowView?.clipsToBounds = false
                self.rideNowView?.show(with: .bottom, completion: nil)
                self.view.addSubview(self.rideNowView!)
                self.rideNowView?.onClickProceed = { [weak self] service in
                    self?.showEstimationView(with: service)
                }
                self.rideNowView?.onClickService = { [weak self] service in
                    guard let self = self else {return}
                    self.sourceMarker.snippet = service?.pricing?.time
                    self.mapViewHelper?.mapView?.selectedMarker = (service?.pricing?.time) == nil ? nil : self.sourceMarker
                    self.selectedService = service
                    self.showProviderInCurrentLocation(with: self.listOfProviders!, serviceTypeID: (service?.id)!)
                }
                
            }
            self.rideNowView?.setAddress(source: currentLocation.value!, destination: currentLocation.value!)
            self.rideNowView?.set(source: source)
        }
        
        //  Observer
        
        @objc private func observer(notification : Notification) {
            
            if notification.name == .providers, let _ = notification.userInfo?[Notification.Name.providers.rawValue] as? [Service] {
                //                showProviderInCurrentLocation(with: serviceArray, serviceTypeID: 0)
            }
        }
        
        //  Get Favourite Location From Local
        
        private func getFavouriteLocationsFromLocal() {
            
            let favouriteLocationFromLocal = CoreDataHelper().favouriteLocations()
            [self.viewHomeLocation, self.viewWorkLocation].forEach({
                $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewLocationButtonAction(sender:))))
                $0?.isHidden = true
            })
            for location in favouriteLocationFromLocal
            {
                switch location.key {
                case CoreDataEntity.work.rawValue where location.value is Work:
                    if let workObject = location.value as? Work, let address = workObject.address {
                        if let index = favouriteLocations.firstIndex(where: { $0.address == Constants.string.work}) {
                            favouriteLocations[index] = (location.key, (address, LocationCoordinate(latitude: workObject.latitude, longitude: workObject.longitude)))
                        } else {
                            favouriteLocations.append((location.key, (address, LocationCoordinate(latitude: workObject.latitude, longitude: workObject.longitude))))
                        }
                        self.viewWorkLocation.isHidden = false
                    }
                case CoreDataEntity.home.rawValue where location.value is Home:
                    if let homeObject = location.value as? Home, let address = homeObject.address {
                        if let index = favouriteLocations.firstIndex(where: { $0.address == Constants.string.home}) {
                            favouriteLocations[index] = (location.key, (address, LocationCoordinate(latitude: homeObject.latitude, longitude: homeObject.longitude)))
                        }
                        else {
                            favouriteLocations.append((location.key, (address, LocationCoordinate(latitude: homeObject.latitude, longitude: homeObject.longitude))))
                        }
                        self.viewHomeLocation.isHidden = false
                    }
                default:
                    break
                    
                }
            }
        }
        
        //  View Location Action
        
        @IBAction private func viewLocationButtonAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view else { return }
            if senderView == viewHomeLocation, let location = CoreDataHelper().favouriteLocations()[CoreDataEntity.home.rawValue] as? Home, let addressString = location.address {
                self.destinationLocationDetail = (addressString, LocationCoordinate(latitude: location.latitude, longitude: location.longitude))
            } else if senderView == viewWorkLocation, let location = CoreDataHelper().favouriteLocations()[CoreDataEntity.work.rawValue] as? Work, let addressString = location.address {
                self.destinationLocationDetail = (addressString, LocationCoordinate(latitude: location.latitude, longitude: location.longitude))
            }
            
            if destinationLocationDetail == nil { // No Previous Location Avaliable
                self.showLocationView()
            } else {
                print("Polydraw 1")
                self.drawPolyline(isReroute: false) // Draw polyline between source and destination
                //  self.getServicesList() // get Services
                //                self.withoutDest = false
            }
            
        }
        
        
        //  Favourite Location Action
        
        @IBAction private func favouriteLocationAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view else { return }
            senderView.addPressAnimation()
            if senderView == viewFavouriteSource {
                self.isSourceFavourited = self.sourceLocationDetail?.value != nil ? !self.isSourceFavourited : false
            } else if senderView == viewFavouriteDestination {
                self.isDestinationFavourited = self.destinationLocationDetail != nil ? !self.isDestinationFavourited : false
            }
        }
        
        //  Favourite Location Action
        
        private func isAddFavouriteLocation(in viewFavourite : UIView, isAdd : Bool) {
            
            if viewFavourite == viewFavouriteSource {
                self.imageViewFavouriteSource.image = (isAdd ? #imageLiteral(resourceName: "like") : #imageLiteral(resourceName: "unlike")).withRenderingMode(.alwaysTemplate)
            } else {
                self.imageViewFavouriteDestination.image = (isAdd ? #imageLiteral(resourceName: "like") : #imageLiteral(resourceName: "unlike")).withRenderingMode(.alwaysTemplate)
            }
            
            imgColor(img: imageViewFavouriteSource, colorHex: "FFFFFF")
            self.favouriteLocationApi(in: viewFavourite, isAdd: isAdd) // Send to Api Call
            
        }
        
        //  Favourite Location Action
        
        @IBAction private func locationTapAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view  else { return }
            if riderStatus != .none, senderView == viewSourceLocation { // Ignore if user is onRide and trying to change source location
                return
            }
            // self.selectedLocationView.transform = CGAffineTransform.identity
            
            if self.selectedLocationView == senderView {
                self.showLocationView()
            }
            else {
                self.selectedLocationView = senderView
                self.selectionViewAction(in: senderView)
            }
            //  self.selectedLocationView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            // self.viewAddress.bringSubviewToFront(self.selectedLocationView)
            // self.showLocationView()
        }
        
        
        //  Show Marker on Location
        
        private func selectionViewAction(in currentSelectionView : UIView){
            
            if currentSelectionView == self.viewSourceLocation {
                
                if let coordinate = self.sourceLocationDetail?.value?.coordinate{
                    self.plotMarker(marker: &sourceMarker, with: coordinate)
                    print("Source Marker - ", coordinate.latitude, " ",coordinate.longitude)
                }
                else {
                    self.showLocationView()
                }
            }
            else if currentSelectionView == self.viewDestinationLocation {
                
                if let coordinate = self.destinationLocationDetail?.coordinate{
                    self.plotMarker( marker: &destinationMarker, with: coordinate)
                    print("Destination Marker - ", coordinate.latitude, " ",coordinate.longitude)
                    //getEstimateFareFor(serviceId: 0, isWODest: true)
                }
                else {
                    self.showLocationView()
                }
            }
        }
        
        private func plotMarker(marker : inout GMSMarker, with coordinate : CLLocationCoordinate2D){
            
            marker.position = coordinate
            marker.map = self.mapViewHelper?.mapView
            self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
        }
        
        //  Show Location View
        
        @IBAction private func showLocationView() {
            
            if let locationView = Bundle.main.loadNibNamed(XIB.Names.LocationSelectionView, owner: self, options: [:])?.first as? LocationSelectionView {
                locationView.frame = self.view.bounds
                locationView.setValues(address: (sourceLocationDetail,destinationLocationDetail)) { [weak self] (address) in
                    guard let self = self else {return}
                    self.sourceLocationDetail = address.source
                    if riderStatus != .pickedup { //
                        self.destinationLocationDetail = address.destination
                        self.drawPolyline(isReroute: false)  // Draw polyline between source and destination
                        
                        //CEHCK ZONE IS VALID
                        self.checkValideZone()
                    }
                    if [RideStatus.accepted, .arrived, .pickedup, .started].contains(riderStatus) {
                        if let dAddress = address.destination?.address, let coordinate = address.destination?.coordinate {
                            
                            if coordinate.latitude != 0 && coordinate.longitude != 0 {
                                if riderStatus == .pickedup {
                                    showAlert(message: Constants.string.locationChange.localize(), okHandler: {
                                        self.destinationLocationDetail = address.destination
                                        self.extendTrip(requestID: self.currentRequestId, dLat: coordinate.latitude, dLong: coordinate.longitude, address: dAddress)
                                        self.drawPolyline(isReroute: false)
                                    }, cancelHandler: {
                                        
                                    }, fromView: self)
                                }
                            }
                            self.updateLocation(with: (dAddress,coordinate))
                        }
                    }
                    else {
                        self.removeUnnecessaryView(with: .cancelled) // Remove services or ride now if previously open
                        //  self.getServicesList() // get Services
                        //                        self.withoutDest = false
                    }
                }
                self.view.addSubview(locationView)
                if selectedLocationView == self.viewSourceLocation {
                    locationView.textFieldSource.becomeFirstResponder()
                } else {
                    locationView.textFieldDestination.becomeFirstResponder()
                }
                self.selectedLocationView.transform = .identity
                self.selectedLocationView = UIView()
                self.locationSelectionView = locationView
            }
        }
        
        // MARK:- Remove Location VIew
        
        func removeLocationView() {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.locationSelectionView?.tableViewBottom.frame.origin.y = (self.locationSelectionView?.tableViewBottom.frame.height) ?? 0
                self.locationSelectionView?.viewTop.frame.origin.y = -(self.locationSelectionView?.viewTop.frame.height ?? 0)
            }) { (_) in
                self.locationSelectionView?.isHidden = true
                self.locationSelectionView?.removeFromSuperview()
                self.locationSelectionView = nil
            }
        }
        
        // Draw Polyline
        
        func drawPolyline(isReroute:Bool) {
            
            // self.imageViewMarkerCenter.isHidden = true
            if var sourceCoordinate = self.sourceLocationDetail?.value?.coordinate,
                let destinationCoordinate = self.destinationLocationDetail?.coordinate {  // Draw polyline from source to destination
                
                self.mapViewHelper?.mapView?.clear()
                self.sourceMarker.map = self.mapViewHelper?.mapView
                self.destinationMarker.map = self.mapViewHelper?.mapView
                if isReroute{
                    isRerouteEnable = false
                    let coordinate = CLLocationCoordinate2D(latitude: (providerLastLocation.latitude), longitude: (providerLastLocation.longitude))
                    sourceCoordinate = coordinate
                }
                if !isReroute {
                    self.sourceMarker.position = sourceCoordinate
                    self.destinationMarker.position = destinationCoordinate
                    
                    if destinationCoordinate.latitude == 0.0 && destinationCoordinate.longitude == 0.0{
                        print("Not destinationCoordinate")
                    }else{
                        print("destinationCoordinate")
                        getEstimatedFareHit()
                        
                    }
                }
                //SET VIEW
                setTheManiView(isValue: true)
                self.selectionViewAction(in: self.viewSourceLocation)
                self.selectionViewAction(in: self.viewDestinationLocation)
                self.mapViewHelper?.mapView?.drawPolygon(from: sourceCoordinate, to: destinationCoordinate)
                self.selectedLocationView = UIView()
            }
            
        }
        
        
   
        
        
        
        func drawProviderPolyline(isPickup:Bool, sourceLat : Double, sourceLong : Double  ,destinationLat : Double, destinationLong : Double, address : String) {
            
            if currentLocationValue == 0.0 || currentLocationValue != destinationLat{
                self.mapViewHelper?.mapView?.clear()
            }
            
     
            
            // Draw polyline from source to destination
            self.sourceMarker.map = self.mapViewHelper?.mapView
            self.destinationMarker.map = self.mapViewHelper?.mapView
            
            //GET DISTANCE
                 let googleUrl = "https://maps.googleapis.com/maps/api/directions/json"
                 let url = "\(googleUrl)\("?origin=")\(sourceLat)\(",")\(sourceLong)\("&destination=")\(destinationLat)\(",")\(destinationLong)\("&sensor=false&key=")\(googleMapKey)"
                 let network = NetworkHelper()
                 network.delegate = self
                 network.getDataFromUrlWithGET(url: url, requestName: "getDistance")
                 
         
            
            let coordinate = CLLocationCoordinate2D(latitude: (sourceLat), longitude: (sourceLong))
            let sourceCoordinate = coordinate
            let marker1 = GMSMarker(position: sourceCoordinate)
            marker1.title = ""
            marker1.snippet = ""
            marker1.isFlat = false
            marker1.icon = UIImage(named: "ub__ic_pin_pickup")
            marker1.tracksViewChanges = false
            marker1.map = self.mapViewHelper?.mapView
                                
            
            
            let d_coordinate = CLLocationCoordinate2D(latitude: (destinationLat), longitude: (destinationLong))
            let destinationCoordinate = d_coordinate
            currentLocationValue = destinationLat
            let marker2 = GMSMarker(position: destinationCoordinate)
            marker2.title = address
            marker2.snippet = setTimeStatus
            marker2.isFlat = false
            marker2.icon = UIImage(named: "ub__ic_pin_dropoff")
            marker2.tracksViewChanges = false
            marker2.map = self.mapViewHelper?.mapView
            marker2.userData = address
            self.mapViewHelper?.mapView?.selectedMarker = marker2
            
            //SET VIEW
            setTheManiView(isValue: true)
            //                self.selectionViewAction(in: self.viewSourceLocation)
            //                self.selectionViewAction(in: self.viewDestinationLocation)
            self.mapViewHelper?.mapView?.drawPolygon(from: sourceCoordinate, to: destinationCoordinate)
            self.selectedLocationView = UIView()
        }
        
        
        
        func setTheManiView(isValue : Bool) {
            //isOnBooking = isValue
            viewAddressOuter.isHidden = isValue
        }
        
        // MARK:- Get Favourite Locations
        
        private func getFavouriteLocations(){
            
            favouriteLocations.append((Constants.string.home,nil))
            favouriteLocations.append((Constants.string.work,nil))
            self.presenter?.get(api: .locationService, parameters: nil)
        }
        
        //  Cancel Request if it exceeds a certain interval
        
        @IBAction func validateRequest() {
            
            if riderStatus == .searching {
                UIApplication.shared.keyWindow?.makeToast(Constants.string.noDriversFound.localize())
                self.cancelRequest()
            }
        }
        
        //  SideMenu Button Action
        
        @IBAction private func sideMenuAction(){
            
            /*  if self.isOnBooking { // If User is on Ride Selection remove all view and make it to default
             self.clearAllView()
             print("ViewAddressOuter ", #function)
             } else {
             self.drawerController?.openSide(selectedLanguage == .arabic ? .right : .left)
             self.viewSideMenu.addPressAnimation()
             }*/
            
        }
        
        // Clear Map
        
        @objc func clearAllView() {

            self.removeLoaderView()
            self.removeUnnecessaryView(with: .cancelled)
            self.clearMapview()
            self.viewAddressOuter.isHidden = false
            self.viewLocationButtons.isHidden = false
            self.viewSourceLocation.isHidden = false
            self.viewDestinationLocation.isHidden = false
            
            self.viewEstimated.isHidden = false
            collectionService.isHidden = false
            collectionService.reloadData()
            self.viewButton.isHidden = false
            
            self.fareArr = []
            self.initialLoads()
            self.localize()
            self.hideEstimatedFarePop()
            self.setTheManiView(isValue: false)
            self.viewZone.isHidden = true
            self.getCurrentLocation()
            con_mapView.constant = 0
            self.con_CouponHieght.constant = 0
            btnCash.isHidden = true
            btnPromocode.isHidden = true
            self.imageViewSideBar.image = #imageLiteral(resourceName: "menu_icon")
            
            
            viewStatus1.isHidden = true
            viewStatus2.isHidden = true
            viewStatus3.isHidden = true
            viewStatus4.isHidden = true
            viewStatus5.isHidden = true
            self.viewCurrentLocation.isHidden = false
        }
        
        
        //  Show DateTimePicker
        
        func schedulePickerView(on completion : @escaping ((Date)->())){
            
            var dateComponents = DateComponents()
            dateComponents.day = 7
            let now = Date()
            let maximumDate = Calendar.current.date(byAdding: dateComponents, to: now)
            dateComponents.minute = 5
            dateComponents.day = nil
            let minimumDate = Calendar.current.date(byAdding: dateComponents, to: now)
            let datePicker = DateTimePicker.create(minimumDate: minimumDate, maximumDate: maximumDate)
            datePicker.includesMonth = true
            datePicker.cancelButtonTitle = Constants.string.Cancel.localize()
            
            datePicker.doneButtonTitle = Constants.string.Done.localize()
            datePicker.is12HourFormat = true
            datePicker.dateFormat = DateFormat.list.hhmmddMMMyyyy
            datePicker.highlightColor = hexStringToUIColor(hex: Constants.BLACK_COLOUR)
            datePicker.doneBackgroundColor = hexStringToUIColor(hex: Constants.BLACK_COLOUR)
            datePicker.completionHandler = { date in
                completion(date)
                print(date)
                
                
                
                
                
                
            }
            datePicker.show()
        }
        
        //  Observe Network Changes
        @objc private func networkChanged(notification : Notification) {
            if let reachability = notification.object as? Reachability, ([Reachability.Connection.cellular, .wifi].contains(reachability.connection)) {
                self.getCurrentLocationDetails()
            }
        }
        
    }
    
    // Mark:- If driver app exist
    
    extension HomeViewController {
        
        // if driver app exist need to show warning alert
        func driverAppExist() {
            let app = UIApplication.shared
            let bundleId = driverBundleID+"://"
            
            if app.canOpenURL(URL(string: bundleId)!) {
                let appExistAlert = UIAlertController(title: "", message: Constants.string.warningMsg.localize(), preferredStyle: .actionSheet)
                
                appExistAlert.addAction(UIAlertAction(title: Constants.string.Continue.localize(), style: .default, handler: { (Void) in
                    print("App is install")
                }))
                present(appExistAlert, animated: true, completion: nil)
            }
            else {
                print("App is not installed")
            }
        }
    }
    
    // MARK:- GMSMapViewDelegate
    
    extension HomeViewController : GMSMapViewDelegate {
        
        func loadNiB() -> PinInfoView {
            let infoWindow = PinInfoView.instanceFromNib() as! PinInfoView
            return infoWindow
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            
            if let address = marker.userData{
                //GET USER DATA
                locationMarker = marker
                infoWindow.removeFromSuperview()
                infoWindow = loadNiB()
                guard let location = locationMarker?.position else {
                    print("locationMarker is nil")
                    return false
                }
                
                //SET DETAILS
                infoWindow.lblAddress.text = "\(address)"
                infoWindow.lblTime.text = marker.snippet
                
                
                infoWindow.center = mapView.projection.point(for: location)
                infoWindow.center.y = infoWindow.center.y - (infoWindow.frame.size.height / 2) - 30
                self.view.addSubview(infoWindow)
                return false
            }
            return false

            
        }
        
          func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
              if (locationMarker != nil){
                  guard let location = locationMarker?.position else {
                      print("locationMarker is nil")
                      return
                  }
                  infoWindow.center = mapView.projection.point(for: location)
                  infoWindow.center.y = infoWindow.center.y - (infoWindow.frame.size.height / 2) - 30
              }
          }
          
          func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
              infoWindow.removeFromSuperview()
          }
        
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            
//            mapView.selectedMarker = self.mapViewHelper?.mapView
            if self.isUserInteractingWithMap {
                
                func getUpdate(on location : CLLocationCoordinate2D, completion :@escaping ((LocationDetail)->Void)) {
                    self.drawPolyline(isReroute: false)
                    print("Polydraw 3")
                    //  self.getServicesList()
                    //                    self.withoutDest = false
                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                        completion(locationDetail)
                    })
                }
                
                if self.selectedLocationView == self.viewSourceLocation, self.sourceLocationDetail != nil {
                    
                    if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                        self.sourceLocationDetail?.value?.coordinate = location
                        getUpdate(on: location) { (locationDetail) in
                            self.sourceLocationDetail?.value = locationDetail
                        }
                    }
                }
                else if self.selectedLocationView == self.viewDestinationLocation, self.destinationLocationDetail != nil {
                    
                    if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                        self.destinationLocationDetail?.coordinate = location
                        getUpdate(on: location) { (locationDetail) in
                            self.destinationLocationDetail = locationDetail
                            if riderStatus == .pickedup {
                                showAlert(message: Constants.string.locationChange.localize(), okHandler: {
                                    
                                    self.extendTrip(requestID: self.currentRequestId, dLat: locationDetail.coordinate.latitude, dLong: locationDetail.coordinate.longitude, address: locationDetail.address)
                                }, cancelHandler: {
                                    
                                }, fromView: self)
                            }else{
                                self.updateLocation(with: locationDetail) // Update Request Destination Location
                            }
                        }
                    }
                }
            }
            self.isMapInteracted(false)
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            
            print("Gesture ",gesture)
            self.isUserInteractingWithMap = gesture
            
            if self.isUserInteractingWithMap {
//                self.isMapInteracted(true)
            }
            
        }
        
//        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//
//            // return
//
//            if isUserInteractingWithMap {
//
//                if self.selectedLocationView == self.viewSourceLocation, self.sourceLocationDetail != nil {
//
//                    self.sourceMarker.map = nil
//                    self.imageViewMarkerCenter.tintColor = .secondary
//                    self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "sourcePin").withRenderingMode(.alwaysTemplate)
//                    self.imageViewMarkerCenter.isHidden = true // false
//                    //                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
//                    //                    self.sourceLocationDetail?.value?.coordinate = location
//                    //                    self.mapViewHelper?.getPlaceAddress(from: location,x on: { (locationDetail) in
//                    //                        print(locationDetail)
//                    //                        self.sourceLocationDetail?.value = locationDetail
//                    ////                        let sLocation = self.sourceLocationDetail
//                    ////                        self.sourceLocationDetail = sLocation
//                    //                    })
//                    //                }
//
//
//                } else if self.selectedLocationView == self.viewDestinationLocation, self.destinationLocationDetail != nil {
//
//                    self.destinationMarker.map = nil
//                    self.imageViewMarkerCenter.tintColor = .primary
//                    self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "destinationPin").withRenderingMode(.alwaysTemplate)
//                    self.imageViewMarkerCenter.isHidden = true//false
//                    //                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
//                    //                    self.destinationLocationDetail?.coordinate = location
//                    //                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
//                    //                        print(locationDetail)
//                    //                        self.destinationLocationDetail = locationDetail
//                    //                    })
//                    //                }
//                }
//
//            }
//            //        else {
//            //            self.destinationMarker.map = self.mapViewHelper?.mapView
//            //            self.sourceMarker.map = self.mapViewHelper?.mapView
//            //            self.imageViewMarkerCenter.isHidden = true
//            //        }
//
//        }
        
        
        
        func extendTrip(requestID:Int,dLat:Double,dLong:Double,address:String) {
            var extendTrip = ExtendTrip()
            extendTrip.request_id = requestID
            extendTrip.latitude = dLat
            extendTrip.longitude = dLong
            extendTrip.address = address
            self.presenter?.post(api: .extendTrip, data: extendTrip.toData())
        }
        
    }
    
    // MARK:- Service Calls
    
    extension HomeViewController  {
        
        // Check For Service Status
        
        private func checkForProviderStatus() {
            
            HomePageHelper.shared.startListening(on: { (error, request) in
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.con_mapView.constant = 0
                }, completion:nil)
                
                self.isOnBooking = false
               
                if error != nil {
                    riderStatus = .none
                    //                    DispatchQueue.main.async {
                    //                        showAlert(message: error?.localizedDescription, okHandler: nil, fromView: self)
                    //                    }
                } else if request != nil {
                    if let requestId = request?.id {
                        self.currentRequestId = requestId
                    }
                    if let pLatitude = Double(request?.provider?.latitude ?? ""), let pLongitude = Double(request?.provider?.longitude ?? "") {
                        DispatchQueue.main.async {
                            
                            
                            if request?.status == .searching || request?.status == .pickedup{
                                self.drawProviderPolyline(isPickup: true, sourceLat: Double(request?.s_latitude ?? "") ?? 0.0, sourceLong: Double(request?.s_longitude ?? "") ?? 0.0  , destinationLat: Double(request?.d_latitude ?? "") ?? 0.0 , destinationLong: Double(request?.d_longitude ?? "") ?? 0.0, address: request?.d_address ?? "" )

                            }
                            else if request?.status == .accepted || request?.status == .arrived || request?.status == .started{
                                self.drawProviderPolyline(isPickup: true,sourceLat: Double(request?.s_latitude ?? "") ?? 0.0, sourceLong: Double(request?.s_longitude ?? "") ?? 0.0 , destinationLat: pLatitude, destinationLong: pLongitude, address: request?.s_address ?? "")

                            }
                            else{
                                self.isMapSet = false
                                self.mapViewHelper?.mapView?.clear()
                                self.updateCamera()

                            }
                            
                            
                            if request?.status != .searching && request?.status != .completed{
                                
                                //SET STATUS
                                self.viewCurrentLocation.isHidden = true
                                self.viewStatus1.isHidden = false
                                self.viewStatus2.isHidden = true
                                self.viewStatus3.isHidden = true
                                self.viewStatus4.isHidden = true
                                self.viewStatus5.isHidden = true
                                
                            }
                            else{
                                self.imageViewSideBar.image = #imageLiteral(resourceName: "menu_icon")
                            }
                          
                            self.imgStatus1.image = UIImage(named: "green colour driver")
                            self.imgStatus2.image = UIImage(named: "location in white circle")
                            self.imgStatus3.image = UIImage(named: "Car in white circle")
                            self.imgStatus4.image = UIImage(named: "Flag  in white circle")
                            
                            
                            if request?.status == .started{
                                self.viewStatus2.isHidden = false
                                self.imgStatus1.image = UIImage(named: "green colour driver")
                            }
                            else if request?.status == .arrived{
                                self.viewStatus3.isHidden = false
                                self.imgStatus1.image = UIImage(named: "green colour driver")
                                self.imgStatus2.image = UIImage(named: "2_state_complet")
                            }
                            else if request?.status == .pickedup{
                                self.viewStatus4.isHidden = false
                                self.imgStatus1.image = UIImage(named: "green colour driver")
                                self.imgStatus2.image = UIImage(named: "2_state_complet")
                                self.imgStatus3.image = UIImage(named: "3_state_complet")
                                
                            }
                            else if request?.status == .dropped{
                                self.viewStatus5.isHidden = false
                                self.imgStatus1.image = UIImage(named: "green colour driver")
                                self.imgStatus2.image = UIImage(named: "2_state_complet")
                                self.imgStatus3.image = UIImage(named: "3_state_complet")
                                    self.imgStatus4.image = UIImage(named: "4_state_complet")
                            }
                            
                            
                            // MARK:- Showing Provider ETA
                            let currentStatus = request?.status ?? .none
                            if [RideStatus.accepted, .started, .arrived, .pickedup].contains(currentStatus) {
//                                self.showETA(with: LocationCoordinate(latitude: pLatitude, longitude: pLongitude))
                                self.viewAddressOuter.isHidden = true
                            }
                        }
                    }
                
                    let status = request?.status
                    if status == .completed {
                        self.setTheView()
                    }
                    guard riderStatus != request?.status else {
                        return
                    }
                    riderStatus = request?.status ?? .none
                    self.isScheduled = ((request?.is_scheduled ?? false) && riderStatus == .searching)
                    self.handle(request: request!)
                } else {
                    
                    //SET STATUS
                    self.viewStatus1.isHidden = true
                    self.viewStatus2.isHidden = true
                    self.viewStatus3.isHidden = true
                    self.viewStatus4.isHidden = true
                    self.viewStatus5.isHidden = true
                    self.viewCurrentLocation.isHidden = false
                    
                    
                    if self.isConfimBooking{
                        //SET VIEW
                        DispatchQueue.main.async {
                            self.isConfimBooking = false
                            self.isOnBooking = false
                            self.viewLocationButtons.isHidden = false
                            self.viewSourceLocation.isHidden = false
                            self.viewAddressOuter.isHidden = false
                            self.collectionService.isHidden = false
                            self.estimationFareView?.isHidden = false
                            self.viewDestinationLocation.isHidden = false
                            self.loader.isHidden = true
                            self.viewEstimated.isHidden = false
                            self.viewButton.isHidden = false
                            print("ViewAddressOuter ", #function)
                            
                            
                        }
                    }
                    
                    let previousStatus = riderStatus
                    riderStatus = request?.status ?? .none
                    if riderStatus != previousStatus {
                        self.clearMapview()
                    }
                    if self.isScheduled {
                        self.isScheduled = false
                        //                        if let yourtripsVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.YourTripsPassbookViewController) as? YourTripsPassbookViewController {
                        //                            yourtripsVC.isYourTripsSelected = true
                        //                            yourtripsVC.isFirstBlockSelected = false
                        //                            self.navigationController?.pushViewController(yourtripsVC, animated: true)
                        //                        }
                        self.removeUnnecessaryView(with: .cancelled)
                    } else {
                        self.removeUnnecessaryView(with: .none)
                    }
                    
                }
            })
        }
        
        func setTheView() {
            //SET STATUS
            self.viewStatus1.isHidden = true
            self.viewStatus2.isHidden = true
            self.viewStatus3.isHidden = true
            self.viewStatus4.isHidden = true
            self.viewStatus5.isHidden = true
            self.viewCurrentLocation.isHidden = false
            self.viewLocationButtons.isHidden = true
            self.viewSourceLocation.isHidden = true
            self.collectionService.isHidden = true
            self.estimationFareView?.isHidden = true
            self.viewDestinationLocation.isHidden = true
            self.loader.isHidden = true
            self.viewEstimated.isHidden = true
            self.viewButton.isHidden = true
            self.viewAddressOuter.isHidden = true


        }
        func getDataFromFirebase(providerID:Int)  {
            Database .database()
                .reference()
                .child("loc_p_\(providerID)").observe(.value, with: { (snapshot) in
                    guard let _ = snapshot.value as? NSDictionary else {
                        print("Error")
                        return
                    }
                    let providerLoc = ProviderLocation(from: snapshot)
                    
                    /* var latDouble = 0.0 //for android sending any or double
                     var longDouble = 0.0
                     var bearingDouble = 0.0
                     if let latitude = dict.value(forKey: "lat") as? Double {
                     latDouble = Double(latitude)
                     }else{
                     let strLat = dict.value(forKey: "lat")
                     latDouble = Double("\(strLat ?? 0.0)")!
                     }
                     if let longitude = dict.value(forKey: "lng") as? Double {
                     longDouble = Double(longitude)
                     }else{
                     let strLong = dict.value(forKey: "lng")
                     longDouble = Double("\(strLong ?? 0.0)")!
                     }
                     if let bearing = dict.value(forKey: "bearing") as? Double {
                     bearingDouble = bearing
                     } */
                    
                    //                    if let pLatitude = latDouble, let pLongitude = longDouble {
                    DispatchQueue.main.async {
                        print("Moving \(String(describing: providerLoc?.lat)) \(String(describing: providerLoc?.lng))")
                        self.moveProviderMarker(to: LocationCoordinate(latitude: providerLoc?.lat ?? defaultMapLocation.latitude , longitude: providerLoc?.lng ?? defaultMapLocation.longitude),bearing: providerLoc?.bearing ?? 0.0)
                        if polyLinePath.path != nil {
                            if riderStatus == .pickedup {
                                self.updateTravelledPath(currentLoc: CLLocationCoordinate2D(latitude: providerLoc?.lat ?? defaultMapLocation.latitude, longitude: providerLoc?.lng ?? defaultMapLocation.longitude))
                                self.mapViewHelper?.checkPolyline(coordinate:  LocationCoordinate(latitude: providerLoc?.lat ?? defaultMapLocation.latitude , longitude: providerLoc?.lng ?? defaultMapLocation.longitude))
                            }
                        }
                    }
                })
        }
        
        
        // Get Services provided by Provider
        
        /*  private func getServicesList() {
         if self.sourceLocationDetail?.value != nil, self.destinationLocationDetail != nil, riderStatus == .none || riderStatus == .searching { // Get Services only if location Available
         self.presenter?.get(api: .servicesList, parameters: nil)
         }
         
         }*/
        
        // Get Estimate Fare
        
        func getEstimateFareFor(serviceId : Int,isWODest:Bool) {
            
            DispatchQueue.global(qos: .userInteractive).async {
                guard let sourceLocation = self.sourceLocationDetail?.value?.coordinate, let destinationLocation = self.destinationLocationDetail?.coordinate, sourceLocation.latitude>0, sourceLocation.longitude>0, destinationLocation.latitude>0, destinationLocation.longitude>0 else {
                    return
                }
                var estimateFare = EstimateFareRequest()
                estimateFare.s_latitude = sourceLocation.latitude
                estimateFare.s_longitude = sourceLocation.longitude
                estimateFare.d_latitude = destinationLocation.latitude
                estimateFare.d_longitude = destinationLocation.longitude
                estimateFare.service_type = serviceId
                
                self.presenter?.get(api: .estimateFare, parameters: estimateFare.JSONRepresentation)
                
            }
        }
        
        
        
        // Cancel Request
        
        func cancelRequest(reason : String? = nil) {
            
            if self.currentRequestId>0 {
                let request = Request()
                request.request_id = self.currentRequestId
                request.cancel_reason = reason
                self.presenter?.post(api: .cancelRequest, data: request.toData())
            }
        }
        
        
        // Create Request
        
        func createRequest(for service : Service, isScheduled : Bool, scheduleDate : Date?, cardEntity entity : CardEntity?, paymentType : PaymentType) {
            // Validate whether the card entity has valid data
            if paymentType == .CARD && entity == nil {
                UIApplication.shared.keyWindow?.make(toast: Constants.string.selectCardToContinue.localize())
                return
            }
            
            self.showLoaderView()
            DispatchQueue.global(qos: .background).async {
                let request = Request()
                request.s_address = self.sourceLocationDetail?.value?.address
                request.s_latitude = "\(self.sourceLocationDetail?.value?.coordinate.latitude ?? 0.0)"
                request.s_longitude = "\(self.sourceLocationDetail?.value?.coordinate.longitude ?? 0.0)"
                request.d_address = self.destinationLocationDetail?.address
                request.d_latitude = "\(self.destinationLocationDetail?.coordinate.latitude ?? 0.0)"
                request.d_longitude = "\(self.destinationLocationDetail?.coordinate.longitude ?? 0.0)"
                request.service_type = service.id
//                request.payment_mode = paymentType
                request.distance = "\(service.pricing?.distance ?? 0)"
                request.use_wallet = service.pricing?.useWallet
                request.card_id = entity?.card_id
                if isScheduled {
                    if let dateString = Formatter.shared.getString(from: scheduleDate, format: DateFormat.list.ddMMyyyyhhmma) {
                        let dateArray = dateString.components(separatedBy: " ")
                        request.schedule_date = dateArray.first
                        request.schedule_time = dateArray.last
                    }
                }
                if let couponId = service.promocode?.id {
                    request.promocode_id = couponId
                }
                self.presenter?.post(api: .sendRequest, data: request.toData())
                
            }
        }
        
        // MARK:- Update Location for Existing Request
        
        func updateLocation(with detail : LocationDetail) {
            //.pickedup
            guard [RideStatus.accepted, .arrived, .started].contains(riderStatus) else { return } // Update Location only if status falls under certain category
            
            let request = Request()
            request.request_id = self.currentRequestId
            request.address = detail.address
            request.latitude = detail.coordinate.latitude
            request.longitude = detail.coordinate.longitude
            self.presenter?.post(api: .updateRequest, data: request.toData())
            
        }
        
//        //  Change Payment Type For existing Request
//        func updatePaymentType(with cardDetail : CardEntity?, paymentType: PaymentType) {
//            let request = Request()
//            request.request_id = self.currentRequestId
//            if paymentType == .CARD {
//                request.payment_mode = .CARD
//                request.card_id = cardDetail!.card_id
//            }
//            else {
//                request.payment_mode = paymentType
//            }
//            self.loader.isHideInMainThread(false)
//            self.presenter?.post(api: .updateRequest, data: request.toData())
//        }
        
        //  Favourite Location on Other Category
        func favouriteLocationApi(in view : UIView, isAdd : Bool) {
            
            guard isAdd else { return }
            
            let service = Service() // Save Favourite location in Server
            service.type = CoreDataEntity.other.rawValue.lowercased()
            if view == self.viewFavouriteSource, let address = self.sourceLocationDetail?.value {
                service.address = address.address
                service.latitude = address.coordinate.latitude
                service.longitude = address.coordinate.longitude
            } else if view == self.viewFavouriteDestination, self.destinationLocationDetail != nil {
                service.address = self.destinationLocationDetail!.address
                service.latitude = self.destinationLocationDetail!.coordinate.latitude
                service.longitude = self.destinationLocationDetail!.coordinate.longitude
            } else { return }
            
            self.presenter?.post(api: .locationServicePostDelete, data: service.toData())
            
        }
    }
    
    // MARK:- PostViewProtocol
    
    extension HomeViewController : PostViewProtocol {
        
        func onError(api: Base, message: String, statusCode code: Int) {
            
            DispatchQueue.main.async {
                self.loader.isHidden = true
                if api == .locationServicePostDelete {
                    UIApplication.shared.keyWindow?.make(toast: message)
                } else {
                    if code != StatusCode.notreachable.rawValue && api != .checkRequest && api != .cancelRequest{
                        showAlert(message: message, okHandler: nil, fromView: self)
                    }
                    
                }
                if api == .sendRequest {
                    self.clearAllView()
                    self.removeLoaderView()
                }
            }
        }
        
        func getServiceList(api: Base, data: [Service]) {
            
            if api == .servicesList {
                DispatchQueue.main.async {  // Show Services
                    //                    if self.withoutDest {
                    //                        self.showRideNowWithoutDest(with: data)
                    //                    }else{
                    self.showRideNowView(with: data)
                    //                    }
                    
                }
            }
            
        }
        
        func getProviderList(api: Base, data: [Provider]) {
            if api == .getProviders {  // Show Providers in Current Location
                DispatchQueue.main.async {
                    self.listOfProviders = data
                    self.showProviderInCurrentLocation(with: self.listOfProviders!,serviceTypeID:0)
                }
            }
        }
        
        func getRequest(api: Base, data: Request?) {
            
            print(data?.request_id ?? 0)
            if api == .sendRequest {
                self.success(api: api, data: nil)
                
                self.currentRequestId = data?.request_id ?? 0
                self.checkForProviderStatus()
                
                if data?.message == Constants.string.scheduleReqMsg {
                    UIApplication.shared.keyWindow?.makeToast(Constants.string.rideCreated.localize())
                    clearAllView()
                    self.removeLoaderView()
                }else{
                    DispatchQueue.main.async {
                        self.showLoaderView(with: self.currentRequestId)
                    }
                }
            }
        }
        
        func success(api: Base, message: String?) {
            riderStatus = .none
            self.loader.isHideInMainThread(true)
        }
        
        func getWalletEntity(api: Base, data: WalletEntity?) {
            
        }
        
        func success(api: Base, data: WalletEntity?) {
            
            
            if api == .updateRequest {
                riderStatus = .none
                return
            }
                
            else if api == .locationServicePostDelete {
                self.presenter?.get(api: .locationService, parameters: nil)
            }else if api == .rateProvider  {
                riderStatus = .none
                getAllProviders()
                return
            }
            else if api == .payNow {
                self.isInvoiceShowed = true
                
                //                paytym
                //                self.makePaymentWithPaytm(paymentEntity: data)
                
                //                payumoney
                //                self.makePaymentWithPayumoney(paymentEntity: data)
                
            }
            else if api == .cancelRequest{
                riderStatus = .none
            }
            else {
                riderStatus = .none // Make Ride Status to Default
                //                if api == .payNow { // Remove PayNow if Card Payment is Success
                //                    self.removeInvoiceView()
                //                }
            }
        }
        
        func getLocationService(api: Base, data: LocationService?) {
            
            self.loader.isHideInMainThread(true)
            storeFavouriteLocations(from: data)
        }
        
        func getProfile(api: Base, data: Profile?) {
            Common.storeUserData(from: data)
            storeInUserDefaults()
        }
        
        func getReason(api: Base, data: [ReasonEntity]) {
            self.cancelReason = data
        }
        
        func getExtendTrip(api: Base, data: ExtendTrip) {
            print(data)
        }
    }
    
    //    //MARK:- PayTM Payment Gateway
    //    extension HomeViewController {
    //        func makePaymentWithPaytm(paymentEntity: PayTmEntity?) {
    //
    //            PGServerEnvironment().selectServerDialog(self.view, completionHandler: {(type: ServerType) -> Void in
    //
    //                let amount: String = "\(paymentEntity?.TXN_AMOUNT ?? 0.0)"
    //                let customerId: String = "\(paymentEntity?.CUST_ID ?? "")"
    //                let type :ServerType = .eServerTypeStaging
    //                let order = PGOrder(orderID: (paymentEntity?.ORDER_ID)!,
    //                                    customerID: customerId,
    //                                    amount: amount,
    //                                    eMail: (paymentEntity?.EMAIL)!,
    //                                    mobile: (paymentEntity?.MOBILE_NO)!)
    //
    //                order.params = [Constants().mid: (paymentEntity?.MID)!,
    //                                Constants().orderId: (paymentEntity?.ORDER_ID)!,
    //                                Constants().custId: customerId,
    //                                Constants().mobileNo: (paymentEntity?.MOBILE_NO)!,
    //                                Constants().emailId: (paymentEntity?.EMAIL)!,
    //                                Constants().channelId: (paymentEntity?.CHANNEL_ID)!,
    //                                Constants().website: (paymentEntity?.WEBSITE)!,
    //                                Constants().txnAmount: amount,
    //                                Constants().industryType: (paymentEntity?.INDUSTRY_TYPE_ID)!,
    //                                Constants().checksumhash: (paymentEntity?.CHECKSUMHASH)!,
    //                                Constants().callbackUrl: (paymentEntity?.CALLBACK_URL)!]
    //
    //                let txnController = PGTransactionViewController().initTransaction(for: order) as! PGTransactionViewController
    //                //                self.txnController = self.txnController?.initTransaction(for: order) as? PGTransactionViewController
    //                txnController.title = "Paytm Payments"
    //                txnController.setLoggingEnabled(true)
    //                if(type != ServerType.eServerTypeNone) {
    //                    txnController.serverType = type
    //                } else {
    //                    return
    //                }
    //                txnController.merchant = PGMerchantConfiguration.defaultConfiguration()
    //                txnController.delegate = self
    //                self.navigationController?.pushViewController(txnController, animated: true)
    //            })
    //        }
    //    }
    //
    //    //MARK:- PGTransactionDelegate
    //
    //    extension HomeViewController: PGTransactionDelegate {
    //        //this function triggers when transaction gets finished
    //        func didFinishedResponse(_ controller: PGTransactionViewController, response responseString: String) {
    //            let msg : String = responseString
    //            var titlemsg : String = ""
    //            if let data = responseString.data(using: String.Encoding.utf8) {
    //                do {
    //                    if let jsonresponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] , jsonresponse.count > 0{
    //                        titlemsg = jsonresponse["STATUS"] as? String ?? ""
    //                    }
    //                } catch {
    //                    print("Something went wrong")
    //                }
    //            }
    //            let actionSheetController: UIAlertController = UIAlertController(title: titlemsg , message: msg, preferredStyle: .alert)
    //            let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
    //                action -> Void in
    //                controller.navigationController?.popViewController(animated: true)
    //            }
    //            actionSheetController.addAction(cancelAction)
    //            self.present(actionSheetController, animated: true, completion: nil)
    //        }
    //        //this function triggers when transaction gets cancelled
    //        func didCancelTrasaction(_ controller : PGTransactionViewController) {
    //            controller.navigationController?.popViewController(animated: true)
    //        }
    //        //Called when a required parameter is missing.
    //        func errorMisssingParameter(_ controller : PGTransactionViewController, error : NSError?) {
    //            controller.navigationController?.popViewController(animated: true)
    //        }
    //    }
    
    
    //MARK:- BrainTree Payment
    
    extension HomeViewController {
        func fetchBrainTreeClientToken() {
            self.presenter?.get(api: .getbraintreenonce, parameters: nil)
        }
        
        func getBrainTreeToken(api: Base, data: TokenEntity) {
            guard let token: String = data.token else {
                return
            }
            self.showDropIn(newToken: token)
        }
        
        
        func showDropIn(newToken: String) {
            let newRequest =  BTDropInRequest()
            let dropIn = BTDropInController(authorization: newToken, request: newRequest)
            { (controller, result, error) in
                if (error != nil) {
                    print("ERROR")
                } else if (result?.isCancelled == true) {
                    print("CANCELLED")
                } else if let result = result {
                    // Use the BTDropInResult properties to update your UI
                    // result.paymentOptionType
                    // result.paymentMethod
                    // result.paymentIcon
                    // result.paymentDescription
                    print(result)
                }
                controller.dismiss(animated: true, completion: nil)
            }
            self.present(dropIn!, animated: true, completion: nil)
        }
    }
    
    // Mark:- Pay with payumoney on Invoice payment
    
    extension HomeViewController {
        func makePaymentWithPayumoney(paymentEntity: PayUMoneyEntity) {
            print(paymentEntity as Any)
            PayUServiceHelper.sharedManager()?.getPayment(self, paymentEntity.email, "8179722510", paymentEntity.firstname,"\((paymentEntity.amount)!)", paymentEntity.txnid, paymentEntity.merchant_id, paymentEntity.key, paymentEntity.payu_salt, paymentEntity.surl, paymentEntity.curl, productInfo: paymentEntity.productinfo, udf1: "\(self.currentRequestId)", didComplete: { (dict, error) in
                
                if let result = dict?["result"] as? NSDictionary {
                    var payUEntity = PayUMoneyEntity()
                    payUEntity.request_id = self.currentRequestId
                    let txnId = (result.value(forKey: Constants().stxnid))
                    let param = [Constants().sid : self.currentRequestId,
                                 Constants().spay : txnId!,
                                 Constants().swallet : 0,
                                 Constants().stype : UserType.user.rawValue,
                                 Constants().suid : User.main.id ?? ""] as [String : Any]
                    self.presenter?.get(api: .payUMoneySuccessResponse, parameters: param)
                }
                
            }) { (error) in
                print("Payment Process Breaked")
            }
        }
    }
    
    //MARK: CollectionView DataSource and Delegate Methods

    extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
     
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.ArrServices.count

        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 120)
        }
                
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellService", for: indexPath) as! ServicesCollectionViewCell
            let dictService = self.ArrServices[indexPath.row]
            
            //SET LABLE
            cell.lblPax.layer.masksToBounds = true
            cell.lblPax.layer.cornerRadius = cell.lblPax.frame.size.height / 2
            cell.imgCar.layer.masksToBounds = true
            cell.imgCar.layer.cornerRadius = cell.imgCar.frame.size.height / 2
            cell.lblCarName.layer.masksToBounds = true
            cell.lblCarName.layer.cornerRadius = 3
            
            
            cell.lblPax.text = dictService["capacity"] as? String ?? ""
            cell.lblCarName.text = " \(dictService["name"] as? String ?? "") "
            let pictureUrl = dictService["image"] as? String ?? ""
            cell.imgCar.setImage(with: "\(baseUrl)/\(pictureUrl)", placeHolder: UIImage(named:"CarplaceHolder"))
            if selectedItem.contains(dictService){
                cell.lblCarName.textColor = UIColor.white
                cell.lblCarName.backgroundColor = UIColor.black
            }else{
                cell.lblCarName.textColor = UIColor.lightGray
                cell.lblCarName.backgroundColor = UIColor.clear
            }
            
            cell.lblPrice.text = ""
            if fareArr.count > 0{
                print(fareArr)
                
                let fareDic = fareArr[indexPath.row] as? NSDictionary
                let currency = fareDic?["currency"] as? String ?? ""
                let fare =  fareDic?.getStringForID(key: "estimated_fare")
                cell.lblPrice.text = "\(currency)" + " \(fare!)"
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
            let dic = self.ArrServices[indexPath.row]
            
            //SETLECT IMAGE
            let pictureUrl = dic["image"] as? String ?? ""
            self.selectCare = "\(baseUrl)/\(pictureUrl)"

            selectedItem.removeAllObjects()
            if selectedItem.contains(self.ArrServices[indexPath.row]){
                selectedItem.remove(dic)
            }else{
                selectedItem.add(dic)
            }

            
            if fareArr.count > 0{
                selectedPriceArr.removeAllObjects()
                selectedPriceArr.add(fareArr[indexPath.row])
            }
            self.collectionService.reloadData()
        }
        
        
        
        func checkValideZone (){
            if let sourceCoordinate = self.sourceLocationDetail?.value?.coordinate,
            let destinationCoordinate = self.destinationLocationDetail?.coordinate {
                if destinationCoordinate.latitude != 0.0{
                    let params:Parameters = ["s_latitude":"\(sourceCoordinate.latitude)",
                        "s_longitude":"\(sourceCoordinate.longitude)",
                        "d_latitude":"\(destinationCoordinate.latitude)",
                        "d_longitude":"\(destinationCoordinate.longitude)"]
                    
                    
                    self.loader.isHidden = false
                    let url = "\(baseUrl)\(Base.zone.rawValue)"
                    let network = NetworkHelper()
                    network.delegate = self
                    network.getDataFromUrlWithAccessPOST(url: url, requestName: Base.zone.rawValue, headerField: "", parameter: params)
                    
                }
            }
        }
    }
    
    extension HomeViewController : RazorpayPaymentCompletionProtocol {
        func onPaymentError(_ code: Int32, description str: String) {
            let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        }
        
        func onPaymentSuccess(_ payment_id: String) {
            invoiceView?.payment_id(id: payment_id)
        }
        
    
        func showPaymentForm(amount : String, orderId : String){
            let options: [String:Any] = [
                        "amount": amount, //This is in currency subunits. 100 = 100 paise= INR 1.
                "currency": "\(User.main.currency ?? "")",//We support more that 92 international currencies.
                        "description": "purchase description",
                        "image": "",
                        "name": "PinTaxi",
                        "prefill": [
                            "contact": User.main.dispatcherNumber,
                            "email": User.main.email
                        ],
                        "theme": [
                            "color": "#000000"
                        ]
                    ]
            
            razorpay.open(options)
        }
    }
