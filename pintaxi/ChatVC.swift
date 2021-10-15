//
//  ChatVC.swift
//  Share My Ride
//
//  Created by 99appdev on 17/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ChatVC: UIViewController ,LynnBubbleViewDataSource, UITextViewDelegate,ServerCommunicationApiDelegate{
    @IBOutlet weak var tbBubbleDemo: LynnBubbleTableView!
     let reach = NetworkReachabilityManager ()
    @IBOutlet weak var imgBackButton: UIImageView!
    var arrChatTest:Array<LynnBubbleData> = []
    
    @IBOutlet weak var imgSend: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    var DictSearchItemClicked = [String : Any] ()
    @IBOutlet weak var textViewMessage: UITextView!
    var is_user_to_provider : String!
    var LoginId : String!
    var ArrayOfData = [[String : Any]] ()
    var Driver_ID :String!
    var Traveller_ID :String!
    var MyNameForChat : String!
    var OtherUserNameForChat : String!
    var strOtherUserImage : String!
    var gameTimer: Timer?
    
    
    var requestID : String = ""
    var providerID : String = ""
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var user_Id_From_All_Chat : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeTintColor(strImage: "send", imageView: self.imgSend, color: UIColor.white)
        self.lblName.text = "\(self.DictSearchItemClicked["first_name"] as? String ?? "") \(self.DictSearchItemClicked["last_name"] as? String ?? "")"
        
       // ChangeTintColor (strImage : "back-icon" , imageView : self.imgBackButton, color : UIColor.black)
        tbBubbleDemo.bubbleDelegate = self
        tbBubbleDemo.bubbleDataSource = self
        
        textViewMessage.delegate = self
        self.textViewMessage.text = "type here..."
        self.textViewMessage.textColor = UIColor.lightGray
        self.textViewMessage.contentInset = UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 15)
        
        
   //   self.testChatData()
        
        if UserDefaults.standard.value(forKey: "user_data") != nil{
            let userdata = UserDefaults.standard.value(forKey: "user_data") as? Data
            let dictionaryUser:NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: userdata!) as? NSDictionary
            LoginId = String(dictionaryUser?["id"] as? Int ?? 0)
        
        }
        let driver_id = "\(self.DictSearchItemClicked["user_id"] as? String ?? "")"
        if driver_id == LoginId{
            self.Driver_ID = driver_id
           self.Traveller_ID = user_Id_From_All_Chat
           self.is_user_to_provider = "pu"
        }else{
            self.Driver_ID = driver_id
             self.Traveller_ID = self.LoginId ?? ""
          self.is_user_to_provider = "up"
        }
    
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

         self.loader.isHidden = false
       //self.GetAllChat()
        getAllChatHit()
        
    }
    
    @objc func runTimedCode ()
    {
        getAllChatHit()
      //self.GetAllChat()
    }
    override func viewWillDisappear(_ animated: Bool) {
         gameTimer?.invalidate()
    }
    
    // Change Tint Color of Image
    
    func ChangeTintColor (strImage : String , imageView : UIImageView , color : UIColor)
    {
        let templateImage = UIImage(named: strImage)!.withRenderingMode(.alwaysTemplate)
        imageView.image = templateImage
        imageView.tintColor = color
    }
    
    
    
    //MARK:- WebService for Promo List
    func getAllChatHit(){
//        DispatchQueue.main.async {
//            self.loader.isHidden = false
//        }
        let url = "\(baseUrl)\("/api/user/firebase/getChat?request_id=\(requestID)")"
        let network = NetworkHelper()
        network.delegate = self
        network.getDataFromUrlWithGET(url: url, requestName: "Chat")
    }

    func sendRequestMessageApi(message:String){
        self.loader.isHidden = false
        let url = "\(baseUrl)\("/api/user/firebase/getChat?request_id=12")\("&message=")\(message)\("&provider_id=")\(providerID)\("&user_id=")\(User.main.id ?? 0)\("&type=up")"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let network = NetworkHelper()
        network.delegate = self
        network.getDataFromUrlWithGET(url: urlString!, requestName: "Chat")
    }
    
    //MARK:- Receive Service Methods
    func dataReceiveFromService(dic: Dictionary<String, Any>, requestName: String) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            print(dic)
            switch requestName{
            case "Chat" :
                if dic.keys.contains("error") {
                    showAlert(message: dic["error"] as? String ?? "", okHandler: nil, fromView: self)
                }else{
                    self.ArrayOfData = [[String : Any]] ()
                    let dataArray = dic["data"] as? [[String : Any]] ?? [[:]]
                    for (index,_) in dataArray.enumerated(){
                        let Dictdata = dataArray[index]
                        let driverId = Dictdata["provider_id"] as? String ?? ""
                        let travelerid = Dictdata["user_id"] as? String ?? ""
                        self.ArrayOfData.append(Dictdata)
                        if self.Driver_ID == driverId && self.Traveller_ID == travelerid{
                            self.ArrayOfData.append(Dictdata)
                        }
                    }
                    self.arrChatTest  = []
                    self.testChatData ()
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

    

    
    func textViewDidBeginEditing(_ textView: UITextView){
        if self.textViewMessage.text == "type here..."{
            self.textViewMessage.text = ""
            self.textViewMessage.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if self.textViewMessage.text == "type here..."{
            self.textViewMessage.text = "type here..."
            self.textViewMessage.textColor = UIColor.lightGray
        }
    }

    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func testChatData () {
       
      //  let yesterDay = Date().addingTimeInterval(-60*60*24)
        for (index,_) in  self.ArrayOfData.enumerated() {
            
            let DictMessage = self.ArrayOfData[index]
            let messageChat = DictMessage["message"] as? String ?? ""
           let type = DictMessage["type"] as? String ?? ""
        
            let strdate = DictMessage["created_at"] as? String ?? ""
            var timeChat = ""
            if strdate.contains(" ")
            {
                let arrayDateTime = strdate.components(separatedBy: " ")
                timeChat = arrayDateTime[1]
            }
            let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      
            let dateMessage = dateFormatter.date(from: strdate)
          
            let driver_id = "\(self.DictSearchItemClicked["user_id"] as? String ?? "")"
            if driver_id == LoginId
            {
               self.MyNameForChat = "\(DictMessage["provider_name"] as? String ?? "")"
                 self.OtherUserNameForChat = "\(DictMessage["user_name"] as? String ?? "")"
                strOtherUserImage = DictMessage["user_image"] as? String ?? ""
               
            }
            else
            {
                self.MyNameForChat = "\(DictMessage["user_name"] as? String ?? "")"
                self.OtherUserNameForChat = "\(DictMessage["provider_name"] as? String ?? "")"
               strOtherUserImage = DictMessage["provider_image"] as? String ?? ""
                
            }
            
            
            if self.is_user_to_provider == type
            {
                 let userMe = LynnUserData(userUniqueId: "123", userNickName: self.MyNameForChat  , msgTime: timeChat , userProfileImage: nil, additionalInfo: nil)
                let bubbleData:LynnBubbleData = LynnBubbleData(userData: userMe, dataOwner: .me, message: messageChat, messageDate: dateMessage!)
                
                self.arrChatTest.append(bubbleData)
            }
            else
            {
                let imageUser = UIImageView ()
               
                imageUser.setImage(with: strOtherUserImage ?? "", placeHolder: UIImage(named:"userPlaceholder"))
                 let userSomeone = LynnUserData(userUniqueId: "234", userNickName: self.OtherUserNameForChat , msgTime: timeChat , userProfileImage: imageUser.image, additionalInfo: nil)
                let bubbleData:LynnBubbleData = LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: messageChat, messageDate: dateMessage!)
                self.arrChatTest.append(bubbleData)
            }
         }
        self.tbBubbleDemo.reloadData()
        self.tbBubbleDemo.scrollToBottom()
        
    }
    
    
    func bubbleTableView(dataAt index: Int, bubbleTableView: LynnBubbleTableView) -> LynnBubbleData {
        return self.arrChatTest[index]
    }
    
    func bubbleTableView(numberOfRows bubbleTableView: LynnBubbleTableView) -> Int {
        return self.arrChatTest.count
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        self.SendMessage(message : self.textViewMessage.text ?? "")
        self.textViewMessage.text = ""
    }
   
    
    func GetAllChat(){
//        let driver_id = "\(self.DictSearchItemClicked["user_id"] as? String ?? "")"
        let ride_id = "\(self.DictSearchItemClicked["id"] as? Int ?? 0)"
        
        let urlString = "\(baseUrl)\(Base.chatPush.rawValue)"
        let param = ["request_id" :  ride_id] as [String : Any]
        
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                }
                print("result is \(result)")
                
                self.ArrayOfData = [[String : Any]] ()
                
                let dataArray = result?["data"] as? [[String : Any]] ?? [[:]]
                for (index,_) in dataArray.enumerated()
                {
                  let Dictdata = dataArray[index]
                    let driverId = Dictdata["provider_id"] as? String ?? ""
                    let travelerid = Dictdata["user_id"] as? String ?? ""
                    if self.Driver_ID == driverId && self.Traveller_ID == travelerid
                    {
                       self.ArrayOfData.append(Dictdata)
                    }
                }
                   self.arrChatTest  = []
                self.testChatData ()
                
            }
            else
            {
                self.loader.isHidden = true
                
//                let responseMessage = result?["error"] as? String ?? ""
//                showAlert(message: responseMessage, okHandler: nil, fromView: self)
            }
            
        }
    }
    
    
    func SendMessage(message : String)
    {
        sendRequestMessageApi(message: message)
       // let url = "\(baseUrl)\("/api/user/firebase/getChat?request_id=12")\("&message=")\(message)\("&provider_id=")\(self.Driver_ID)\("&user_id=")\(self.Traveller_ID)\("&type=up")"
       
       // let ride_id = "\(self.DictSearchItemClicked["id"] as? Int ?? 0)"
        
       // self.loader.isHidden = false
       // var param = [String : Any] ()
       // let urlString = "\("http://97pixelsdev.com/sharemyride")\(Base.chatSend.rawValue)"
      
         // param = ["request_id" :  ride_id , "provider_id" : self.Driver_ID , "user_id" :  self.Traveller_ID , "message" : message , "type" : self.is_user_to_provider] as [String : Any]
//          WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
//            self.loader.isHidden = true
//            if statusCode == StatusCode.success.rawValue{
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//
//                }
//                print("result is \(result)")
//                self.ArrayOfData = [[String : Any]] ()
//
//                let dataArray = result?["data"] as? [[String : Any]] ?? [[:]]
//                for (index,_) in dataArray.enumerated()
//                {
//                    let Dictdata = dataArray[index]
//                    let driverId = Dictdata["provider_id"] as? String ?? ""
//                    let travelerid = Dictdata["user_id"] as? String ?? ""
//                    if self.Driver_ID == driverId && self.Traveller_ID == travelerid
//                    {
//                        self.ArrayOfData.append(Dictdata)
//                    }
//                }
//
//                self.arrChatTest  = []
//                self.testChatData ()
//
//
//            }
//            else
//            {
//                self.loader.isHidden = true
//
////                let responseMessage = result?["error"] as? String ?? ""
////                showAlert(message: responseMessage, okHandler: nil, fromView: self)
//            }
//
//        }
    }
    
    
}

extension ChatVC : LynnBubbleViewDelegate {
    // optional
 /*   func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didSelectRowAt index: Int) {
        
        let alert = UIAlertController(title: nil, message: "selected index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didLongTouchedAt index: Int) {
        let alert = UIAlertController(title: nil, message: "LongTouchedAt index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didTouchedAttachedImage image: UIImage, at index: Int) {
        let alert = UIAlertController(title: nil, message: "AttachedImage index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didTouchedUserProfile userData: LynnUserData, at index: Int) {
        let alert = UIAlertController(title: nil, message: "UserProfile index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }*/
    
    
    
    
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            if self.numberOfSections != 0
            {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}



