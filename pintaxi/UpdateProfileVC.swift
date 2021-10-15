//
//  UpdateProfileVC.swift
//  TranxitUser
//
//  Created by 99appdev on 25/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire


class UpdateProfileVC: UIViewController , clickedLocation{

    @IBOutlet weak var lblHomeAddress: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblWorkAddress: UILabel!
    @IBOutlet weak var lblNameProfile: UILabel!
    
    @IBOutlet weak var lblMobileProfile: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblMobile: UILabel!
    let reach = NetworkReachabilityManager ()
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
          return UIStatusBarStyle.lightContent
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                            
                            self.imgProfile.image = image
                        }
                    }
                }
            }
            catch {
                // error
            }
        }
        
        if UserDefaults.standard.value(forKey: "user_location") != nil
        {
            let userdata = UserDefaults.standard.value(forKey: "user_location") as? Data
            let arrayLocation = NSKeyedUnarchiver.unarchiveObject(with: userdata!) as? [[String : Any]] ?? [[:]]
            for (index,_) in arrayLocation.enumerated()
            {
                let dictLoc = arrayLocation[index]
                if dictLoc["location_type"] as? String == "Home"
                {
                   self.lblHomeAddress.text = dictLoc["address"] as? String ?? ""
                }
                else
                {
                   self.lblWorkAddress.text = dictLoc["address"] as? String ?? ""
                }
            }
            
        }

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblName.text = User.main.firstName ?? ""
        self.lblNameProfile.text = User.main.firstName ?? ""
        
        self.lblMobile.text = User.main.mobile ?? ""
        self.lblMobileProfile.text = User.main.mobile ?? ""
        self.lblEmail.text = User.main.email ?? ""
       
      }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdateName(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.UpdateNameVC) as? UpdateNameVC{
            vc.strName = self.lblName.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btnUpdateEmail(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.UpdateEmailVC)  as? UpdateEmailVC{
             vc.strEmail = self.lblEmail.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btnUpdateMobile(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.UpdateMobileVC) as? UpdateMobileVC{
            vc.strMobile = self.lblMobileProfile.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        self.showImage { (image) in
            if image != nil {
                self.imgProfile.image = image?.resizeImage(newWidth: 200)
                self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
                self.imgProfile.clipsToBounds = true
                let reach = NetworkReachabilityManager ()
                if reach?.isReachable ?? false
                {
                    
                    let parameters : [String : String] = ["email" : User.main.email ?? "" , "first_name" : User.main.firstName ?? "" , "last_name" : "" , "mobile" : User.main.mobile ?? ""]
                    
                    if self.imgProfile.image != nil, let dataImg = self.imgProfile.image!.pngData() {
                        if self.reach?.isReachable ?? false
                        {
                            self.loader.isHidden = false
                            self.UpdateProfileApi(dataImg: dataImg, param: parameters )
                        }
                        else
                        {
                            self.loader.isHidden = true
                            showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
                        }
                        
                    }
                    
                }
                else
                {
                    showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
                }

            }
        }
    }
    func UpdateProfileApi(dataImg : Data , param : [String : String])
    {
        
        let headers = [
            "Authorization": "Bearer \(User.main.accessToken ?? "")",
            "Content-Type":"application/json",
            "X-Requested-With" : "XMLHttpRequest"
        ]
        
        Alamofire.upload(multipartFormData:
            { (multipartFormData) in
                
                if dataImg != nil {
                    multipartFormData.append(dataImg, withName:"picture", fileName:"user.jpg", mimeType:"file")
                }
                for (key, value) in param
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        }, to:"\(baseUrl)\(Base.updateProfile.rawValue)", method: .post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _ , _ ):
                upload.uploadProgress(closure:
                    { (progress) in
                        //Print progress
                        
                })
                
                upload.responseJSON { response in
                    
                    print("response is \(String(describing: response.value))")
                    
                    print("response is \(response.result)")
                    
                    if let responseDict =  response.value as? NSDictionary{
                        
                        print("ResponseDict =======\(responseDict)")
                        if let error = responseDict["error"] as? String
                        {
                            showAlert(message: error, okHandler: nil, fromView: self)
                        }
                        else
                        {
                           
                            self.loader.isHidden = false
                            self.presenter?.get(api: .getProfile, parameters: nil)
                        }
                    }
                    self.loader.isHidden = true
                    
                }
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                self.loader.isHidden = true
                break
            }
        }
        
    }
    
    @IBAction func btnHomeAddress(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.WorkLocationVC)  as? WorkLocationVC{
            vc.strHomeOrWork = "Home"
            vc.delegate = self
           self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnWorkAddress(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.WorkLocationVC)  as? WorkLocationVC{
             vc.strHomeOrWork = "Work"
             vc.delegate = self
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func locationData(address : String , lat : String , lon : String , homeOrWork : String)
    {
        if homeOrWork == "Home"
        {
           self.lblHomeAddress.text = address
        }
        else
        {
           self.lblWorkAddress.text = address
        }
        if self.reach?.isReachable ?? false
        {
            self.loader.isHidden = false
            self.UpdateAddress(workType : homeOrWork , strLat : lat , strLong : lon , strAddress : address)
        }
        else
        {
            self.loader.isHidden = true
            showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: self)
        }
    }
    
    func UpdateAddress(workType : String , strLat : String , strLong : String , strAddress : String)
    {
        self.view.endEditingForce()
        self.loader.isHidden = false
        
        let urlString = "\(baseUrl)\(Base.updateAddress.rawValue)"
        let param = ["user_id" : User.main.id ?? "" , "location_type" : workType , "address" : strAddress , "latitude" : strLat , "longitude" : strLong] as [String : Any]
        
        WebServiceVK.instance.signInNormal(parameter: param , url : urlString) { (statusCode, result) in
            print("result is \(result)")
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.loader.isHidden = false
                    self.getUserDetails()
                    
                    
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
                showAlert(message: "\(SuccessMessage.list.AddressUpdated.localize())", okHandler: {
                    
                }, fromView: self)
                
        }
        self.loader.isHidden = true
    }
}

//MARK:- PostViewProtocol

extension UpdateProfileVC : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        let alert = showAlert(message: message)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {
                self.loader.isHidden = true
            })
        }
        
    }
    
    func getOath(api: Base, data: LoginRequest?) {
        
        guard let accessToken = data?.access_token, let refreshToken = data?.refresh_token else {
            self.onError(api: api, message: ErrorMessage.list.serverError.localize(), statusCode: 0)
            return
        }
        
        User.main.accessToken = accessToken
        User.main.refreshToken = refreshToken
        self.presenter?.get(api: .getProfile, parameters: nil)
    }
    
    
    func getProfile(api: Base, data: Profile?) {
        
        guard data != nil  else { return  }
        Common.storeUserData(from: data)
        storeInUserDefaults()
        self.loader.isHidden = true
        showAlert(message: "\(SuccessMessage.list.AddressUpdated.localize())", okHandler: {
           
        }, fromView: self)
        
    }
    
    
}
