

import UIKit
import Alamofire
class WebServiceVK: NSObject {
    static let instance            = WebServiceVK()
    let reach = NetworkReachabilityManager ()
    private  let kTimeOut : Double = 120.0
    typealias completionBlock = (_ statusCode: Int?,_ tObject:AnyObject?) -> Void
    typealias downloadBlock = (_ progress: (Double,Double),_ isCompleted:Bool,_ error:Error?,_ progress:Progress?) -> Void
    typealias imageCompletionBlock = (_ statusCode: Int,_ imageUrl:String?,_ image:UIImage?) -> Void
    typealias alerImageCompletionBlock = (_ statusCode: Int,_ imageUrl:String?,_ image:UIImage?,_ encVer:Int) -> Void
    //*******************************************************
    // MARK: -  PublicMethods
    // MARK: -
    //*******************************************************
    
    
    
    func signInNormal(parameter:[String: Any] , url : String,completion:@escaping completionBlock){
        let fullUrl = url
        callNetworkRequest(completeUrl: fullUrl,method:.post ,params:parameter as [String : Any],authRequired:false, block: completion)
    }
    
    
   
    
    
    // End
    
    
    
    //*******************************************************
    // MARK: -  Network Request
    // MARK: -
    //*******************************************************
    
    func callNetworkRequest(completeUrl: String, method: HTTPMethod = .get,params:Parameters! = nil,authRequired: Bool = true,loaderRequired: Bool = true,isAlertShown: Bool = true,block: @escaping completionBlock){
        
        if reach?.isReachable ?? false
        {
         
            var header:[String:String] = [:]
            header["Content-Type"] = "application/json"
             header["X-Requested-With"] = "XMLHttpRequest"
            if User.main.accessToken != nil && User.main.accessToken != ""
            {
                header["Authorization"] =  "Bearer " + "\(User.main.accessToken ?? "")"
             }
            
            NetworkingManager.getInstance.manager.request(completeUrl, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let response = response.response{
                    print("HTTP STATUS CODE:\(response.statusCode): for URL:",completeUrl)
                }
                switch(response.result) {
                case .success(_):
                  
                    var statusCode = response.response?.statusCode
                    
                    if let responseDict = response.result.value as? [String:Any]{
                        if let code = responseDict["APIResponseCode"] as? Int{
                            statusCode = code
                            if code != 200{
                                if let message = responseDict["APIResponseMessage"] as? String{
                                 if let viewController = UIApplication.topViewController() {
                                        showAlert(message: message, okHandler: nil, fromView: viewController)
                                    }
                                }
                            }
                        }
                    }
                    block((statusCode) ,response.result.value as AnyObject?)
                    print(completeUrl)
                    break
                case .failure(let error):
                   
                    print(error.localizedDescription)
                    let message = error.localizedDescription
                  
                    if let viewController = UIApplication.topViewController() {
                        showAlert(message: message, okHandler: nil, fromView: viewController)
                    }
                    let statusCode = (error as NSError).code
                    block((statusCode) ,error as AnyObject)
                    break
                }
            }
            
        }else{
            if let viewController = UIApplication.topViewController() {
                showAlert(message: "\(ErrorMessage.list.notReachable.localize())", okHandler: nil, fromView: viewController)
            }
          
        }
    }

    
 
    
   
}
