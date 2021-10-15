//
//  NetworkHelper.swift
//  Clykk
//
//  Created by Apple on 25/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire

protocol ServerCommunicationApiDelegate {
    func dataReceiveFromService(dic:Dictionary<String,Any> ,requestName:String)
    func dataFailure(error:String,requestName:String)
    
}

class NetworkHelper: NSObject {
    var delegate:ServerCommunicationApiDelegate?
    var dict:Dictionary<String,Any> = [:]
    
    
    
    // MARK:- POST Api Methods
    
    func getDataFromUrlWithPOST(url:String,requestName:String ,headerField:String, parameter dict: Dictionary<String,Any>){
        if isConnectedToNetwork(){
            Alamofire.request(url, method: .post, parameters: dict)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        if response.result.value != nil{
                            if let delegate = self.delegate{
                                delegate.dataReceiveFromService( dic: response.result.value! as! Dictionary<String, Any>, requestName: requestName)
                            }
                        }
                        break
                    case .failure(_):
                        print(response.result.error!)
                        let errorString:String = response.result.error!.localizedDescription
                        if let delegate = self.delegate{
                            delegate.dataFailure(error: errorString, requestName: requestName)
                        }
                        break
                    }
            }
        }else{
            self.delegate? .dataFailure(error: "Network Connection unavailable.", requestName: requestName)
        }
    }
    
    
    // MARK:- GET Api Methods
    func getDataFromUrlWithGET(url:String,requestName:String){
        if isConnectedToNetwork() {
            let headers = [WebConstants.string.Authorization: "\(Keys.list.bearer)\(User.main.accessToken ?? "")"]
            var request = URLRequest(url: URL(string:url)!)
            request.httpMethod = WebConstants.string.get
            request.allHTTPHeaderFields = headers
            request.setValue(WebConstants.string.XMLHttpRequest, forHTTPHeaderField: "X-Requested-With")
            Alamofire.request(request).responseJSON { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                       var dicData:Dictionary<String,Any> = [:]
                        if let delegate = self.delegate{
                            if let arr = response.result.value as? Array<Any>{
                               dicData["data"] = arr
                                delegate.dataReceiveFromService( dic: dicData , requestName: requestName)
                            }else{
                               delegate.dataReceiveFromService( dic: response.result.value as! Dictionary<String, Any>, requestName: requestName)
                            }
                           
                        }
                    }
                    break
                case .failure(_):
                    print(response.result.error!)
                    let errorString:String = response.result.error!.localizedDescription
                    if let delegate = self.delegate{
                        delegate.dataFailure(error: errorString, requestName: requestName)
                    }
                    break
                }
            }
        }else{
            self.delegate? .dataFailure(error: "Network Connection unavailable.", requestName: requestName)
        }
        
    }
    
    
    func getDataFromUrlWithAccessPOST(url:String,requestName:String ,headerField:String, parameter dict: Dictionary<String,Any>){
        if isConnectedToNetwork() {
            var header:[String:String] = [:]
            header["Content-Type"] = "application/json"
            header["X-Requested-With"] = "XMLHttpRequest"
            if User.main.accessToken != nil && User.main.accessToken != ""
            {
                header["Authorization"] =  "Bearer " + "\(User.main.accessToken ?? "")"
            }
            
            Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        if let delegate = self.delegate{
                            delegate.dataReceiveFromService( dic: response.result.value! as! Dictionary<String, Any>, requestName: requestName)
                        }
                    }
                    break
                case .failure(_):
                    print(response.result.error!)
                    let errorString:String = response.result.error!.localizedDescription
                    if let delegate = self.delegate{
                        delegate.dataFailure(error: errorString, requestName: requestName)
                    }
                    break
                }
            }
        }else{
            self.delegate? .dataFailure(error: "Network Connection unavailable.", requestName: requestName)
        }
    }
    
    func uploadImage(url:String,requestName:String ,imageData: Data, parameter dict: Dictionary<String,Any>){
        print(url)
        let tokenStr = UserDefaults.standard.object(forKey:Keys.list.accessToken)
        let headers = [WebConstants.string.Authorization: "\(Keys.list.bearer)\(tokenStr!)"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "Image",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in dict {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            } //Optional for extra parameters
        },
                         to:url, method: .post, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseString(completionHandler: { response in
                    //print(response)
                    print(response.result.value!)
                    if response.result.value != nil{
                        let dic = self.convertToDictionary(text: response.result.value!)
                        if let delegate = self.delegate{
                            
                            delegate.dataReceiveFromService(dic: dic!, requestName: requestName)
                        }
                    }
                })
                
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        }
    }
    
    
    // MARK:- Network Connection Check
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
        
    }
    
    func convertToDictionary(text: Any) -> [String: Any]? {
        if let data = (text as! String).data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}












