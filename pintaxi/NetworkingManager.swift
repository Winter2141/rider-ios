
import UIKit
import Alamofire
class NetworkingManager: NSObject {
    static let getInstance = NetworkingManager()
    var requestURLCountMap:[String:Int] = [String:Int]()
    let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest     =   120
        configuration.timeoutIntervalForResource    =   120
        return Alamofire.SessionManager(configuration: configuration)
    }()
}
